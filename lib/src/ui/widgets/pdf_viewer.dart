import 'dart:async';
import 'dart:io' as io;

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:photo_view/photo_view.dart';

import '../../models/file/file.dart';
import 'centered_circular_progress_indicator.dart';

class PDFLoader extends StatefulWidget {
  final double initialScale, minScale, maxScale;
  final File pdf;
  final Widget Function(BuildContext context, String errorMessage) onError;

  PDFLoader({
    @required this.pdf,
    this.onError,
    this.initialScale = 1.0,
    this.minScale = 1.0,
    this.maxScale = 3.0,
  }) : assert (pdf != null);

  @override
  _PDFLoaderState createState() => _PDFLoaderState();
}

class _PDFLoaderState extends State<PDFLoader> {
  Dio _dio;
  
  PdfDocument _doc;

  double _downloadProgress;

  bool _isLoading;
  bool _hasError;
  String _errorMessage;

   @override
  void initState() {
    super.initState();

    _dio = Dio();

    _hasError = false;
    _isLoading = true;

    loadDocument();
  }

  Future<void> loadDocument() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final filePath = "${dir.path}/${widget.pdf.fileName}.${widget.pdf.fileExtension}";
      io.File file = io.File.fromUri(Uri.parse(filePath));

      if(! await file.exists())
        await _dio.download(
          widget.pdf.url, 
          filePath,
          onReceiveProgress: (downloaded, total) {
            if(mounted)
              setState(() =>
                _downloadProgress = (downloaded / total ) * 100
              );
          }
        );

      _doc = await PdfDocument.openFile(filePath);
      setState(() => _isLoading = false);

    } catch (error) {
      _errorMessage = error.message;

    } finally {
      if(mounted && _errorMessage != null)
        setState(() => _hasError = true);
    }
  }

  @override
  void dispose() {
    _dio?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget body = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget> [
          CenteredCircularProgressIndicator(),
          SizedBox(height: 50),
          _loadingText,
        ],
      ),
    );

    if(_hasError) {
      if(widget.onError == null)
        body = Container();
      else
        body = widget.onError(context, _errorMessage);
    }

    if(!_isLoading && !_hasError)
      body = PDFViewer(
        doc: _doc,
        initialScale: widget.initialScale,
        minScale: widget.minScale,
        maxScale: widget.maxScale,
      );

    return Scaffold(
      body: body,
    );
  }

  Text get _loadingText {
    if(_downloadProgress != null) {
        return Text("${_downloadProgress.toStringAsFixed(2)} %");
    }

    return Text("Loading...");
  }
}

class PDFViewer extends StatefulWidget {
  final double initialScale, minScale, maxScale;
  final PdfDocument doc;

  PDFViewer({
    @required this.doc,
    this.initialScale = 1.0,
    this.minScale = 1.0,
    this.maxScale = 3.0,
  }) : assert (doc != null);
  @override
  _PDFViewerState createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  final PhotoViewController _controller =  PhotoViewController();
  final scale = 320.0 / 72.0;

  PdfPageImage _currentPage;
  int _currentPageNumber = 0;
  int _pageCount = 1;

  bool _isLoading;

  @override
  void initState() {
    super.initState();
    _pageCount = widget.doc.pageCount;
    _isLoading = true;

    _loadPage(number: 1);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadPage({@required int number}) async {
    if(number <= 0) number = 1;
    if(number > _pageCount) return;

    if(!_isLoading)
      setState(() {
        _isLoading = true;
      });

    _currentPageNumber = number;

    var page = await widget.doc.getPage(number);

    var fullWidth = page.width * scale;
    var fullHeight = page.height * scale;

    _currentPage = await page.render(
      x: 0,
      y: 0,
      width: fullWidth.toInt(),
      height: fullHeight.toInt(),
      fullWidth: fullWidth,
      fullHeight: fullHeight
    );

    setState(() {
      _isLoading = false;
    });
  }

  void _previousPage() async =>
    await _loadPage(number: _currentPageNumber-1);

  void _nextPage() async =>
    await _loadPage(number: _currentPageNumber+1);

  void _pickPage() {
    showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return NumberPickerDialog.integer(
            title: Center(child: Text("Select Page")),
            minValue: 1,
            cancelWidget: Container(),
            maxValue: _pageCount,
            initialIntegerValue: _currentPageNumber,
          );
        }).then((int value) {
      if (value != null) {
        _loadPage(number: value);
      }
    });
  }

  Widget _drawIndicator() {
    return Positioned(
      bottom: 20,
      right: 20,
      child: GestureDetector(
        onTap: _pickPage,
        child: Container(
          padding:
            EdgeInsets.only(top: 4.0, left: 16.0, bottom: 4.0, right: 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: Colors.black54,
          ),
          child: Text("$_currentPageNumber/$_pageCount",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.w400
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (_isLoading || _currentPage == null) 
        ? CenteredCircularProgressIndicator() 
        : Container(
        child: Stack(
          fit: StackFit.expand,
          children: [
            PhotoView.customChild(
              controller: _controller,
              initialScale: widget.initialScale,
              minScale: widget.minScale,
              maxScale: widget.maxScale,
              child: RawImage(
                image: _currentPage.image,
              ),
            ),
            _drawIndicator(),
          ],
        ),
      ),

    floatingActionButton: _pageCount > 1
      ? FloatingActionButton(
        elevation: 4.0,
        child: Icon(Icons.view_carousel),
        onPressed: () => _pickPage(),
      )
      : null,

    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    bottomNavigationBar: _pageCount == 1
      ? SizedBox.shrink()
      : BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: IconButton(
                  icon: Icon(Icons.first_page),
                  onPressed: () {
                    _loadPage(number: 1);
                  },
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: Icon(Icons.chevron_left),
                  onPressed: () {
                    _previousPage();
                  },
                ),
              ),
              Expanded(child: SizedBox.shrink(),),
              Expanded(
                child: IconButton(
                  icon: Icon(Icons.chevron_right),
                  onPressed: () {
                    _nextPage();
                  },
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: Icon(Icons.last_page),
                  onPressed: () {
                    _loadPage(number: _pageCount);
                  },
                ),
              ),
            ],
          ),
        )
    );
  }
}
