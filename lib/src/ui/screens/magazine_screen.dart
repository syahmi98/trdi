import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/error_dialog.dart';
import '../widgets/pdf_viewer.dart';
import '../../utils/enums.dart';
import '../../../src/models/magazine/magazine.dart';
import '../../providers/posts.dart';
import '../widgets/centered_circular_progress_indicator.dart';
import '../../utils/utils.dart';

class MagazineScreen extends StatefulWidget {
  @override
  _MagazineScreenState createState() => _MagazineScreenState();
}

class _MagazineScreenState extends State<MagazineScreen> {
  UiState _uiState;
  Magazine _magazine;
  bool _hasLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if(!_hasLoaded) {
      loadData().then((_) => _hasLoaded = true);
    }
  }

  Future<void> loadData() async {
    if(_uiState == UiState.isLoading) return;
    setState(() => _uiState = UiState.isLoading);

    try {
      final postSlug = ModalRoute.of(context).settings.arguments as String;

      print(postSlug);

      final response = await Provider.of<Posts>(context, listen: false).getMagazineBySlug(postSlug);
      setState(() {
        _magazine = response;
        _uiState = UiState.hasData;
      });

    } catch (error) {
      setState(() => _uiState = UiState.hasError);

    }
  }

  Widget _buildLoadingWidget() => CenteredCircularProgressIndicator();
  Widget _buildErrorWidget() => ErrorDialog(
    onTap: () => Navigator.of(context).pop(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: _uiState == UiState.hasError
        ? _buildErrorWidget()
        : _uiState == UiState.isLoading
          ? _buildLoadingWidget()
          : _buildDataWidget()
    );
  }

  Widget _buildDataWidget() {
    return PDFLoader(
      pdf: _magazine.pdf,
      onError: (context, message) {
        return _buildErrorWidget();
      },
    );
  }
}
/*
class _MagazineScreenState extends State<MagazineScreen> {
  var _isLoading = true;
  var hasLoaded = false;
  PDFDocument _pdf;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if(!hasLoaded) {
      String postSlug = 
        ModalRoute.of(context).settings.arguments as String;

      print(postSlug);

      _loadpdf(postSlug);
    }
  }

  void _loadpdf(String slug) async {
    final Magazine magazine = await Provider.of<Posts>(context, listen: false).getMagazineBySlug(slug);
    final PDFDocument doc = await PDFDocument.fromURL(magazine.pdfUrl);

    setState(() {
      _pdf = doc;
      _isLoading = false;
      hasLoaded = true;
    });

  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    final appBar = buildAppBar();

    if(_isLoading || _pdf == null) {
      return Scaffold(
        appBar: appBar,
        body: CenteredCircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: appBar,
      body: FutureProvider<PDFPage> (
        create: (_) async => await _pdf.get(page: 1),
        child: Consumer<PDFPage>(
          builder: (ctx, provider, child) {
            if(provider == null) return CenteredCircularProgressIndicator();
            print(provider.imgPath);
            return provider;
          },
        ),
      ),//PDFViewer(document: _pdf,),
    );
  }
}*/