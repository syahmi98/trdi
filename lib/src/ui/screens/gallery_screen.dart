import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';

import '../../models/album/album.dart';
import '../../models/file/file.dart';
// import '../../providers/albums.dart';
import '../widgets/centered_circular_progress_indicator.dart';
import '../widgets/error_dialog.dart';
import '../../utils/enums.dart';
import '../../utils/utils.dart';

class GalleryScreen extends StatefulWidget {
  static const route = "/gallery-screen";

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  late OverlayEntry imageOverlay;
  late Album album;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, share: album),
      body:  _buildDataWidget(),
    );
  }

  Widget _buildDataWidget() {
    final mediaQuery = MediaQuery.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 12),
              Text(
                album.title,
                style: Theme.of(context).textTheme.headline!.copyWith(
                  fontFamily: FONT_MONTSERRAT,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                album.author,
                style: Theme.of(context).textTheme.body2
              ),
              Text(album.formattedDate,
                style: Theme.of(context).textTheme.body1!.copyWith(
                  color: Theme.of(context).textTheme.body1!.color!.withOpacity(.45)
                )),

              const SizedBox(height: 12,),

              Divider(),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            itemCount: album.images.length,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3
            ),
            itemBuilder: (context, index) {
              File file = album.images[index];

              return AspectRatio(
                aspectRatio: 2,
                child: Card(
                  color: Colors.transparent,
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: <Widget>[
                        Hero(
                          tag: file.id,
                          child: CachedNetworkImage(
                            imageUrl: file.url as String,
                            fit: BoxFit.cover,
                            height: double.infinity,
                            width: double.infinity,
                          ),
                        ),
                        Material(
                          type: MaterialType.transparency,
                          child: InkWell(
                            onTap: () => Navigator.of(context).pushNamed(SingleImageScreen.route, arguments: {
                              "album": album,
                              "file": file
                            }),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
          ),
        )
      ],
    );
  }
}

class SingleImageScreen extends StatefulWidget {
  static const route = "/gallery-image";

  @override
  _SingleImageScreenState createState() => _SingleImageScreenState();
}

class _SingleImageScreenState extends State<SingleImageScreen> with SingleTickerProviderStateMixin {
  late PhotoViewController _photoViewController;
  late AnimationController _fadeController;
  late PageController _pageController;
  bool _hasLoaded = false;
  bool _showDetails = false;
  late Album album;
  late File currentFile;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);    

    _photoViewController = PhotoViewController()..addIgnorableListener(() {
      print(_photoViewController.initial.scale == _photoViewController.scale);
    });

    _fadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if(!_hasLoaded) {
      final map = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      album = map['album'];
      currentFile = map['file'];

      _pageController = PageController(
        initialPage: album.images.indexWhere((file) => file.id == currentFile.id),
      );

      _hasLoaded = true;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _photoViewController.dispose();
    _fadeController.dispose();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    
    SystemChrome.setEnabledSystemUIOverlays([
      SystemUiOverlay.top,
      SystemUiOverlay.bottom
    ]);

    super.dispose();
  }

  void showDetails() {
    if(_showDetails) {
      SystemChrome.setEnabledSystemUIOverlays([]);
      _fadeController.reverse();

    } else {
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

      _fadeController.forward();

    }

    _showDetails = !_showDetails;
  }

  @override
  Widget build(BuildContext context) {    
    final mediaQuery = MediaQuery.of(context);

    if(!_showDetails)
      SystemChrome.setEnabledSystemUIOverlays([]);      

    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black
        ),
        constraints: BoxConstraints.expand(
          height: double.infinity,
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: PhotoViewGallery.builder(
                itemCount: album.images.length,
                pageController: _pageController,
                onPageChanged: (index) {
                  setState(() =>currentFile = album.images[index]);
                },
                builder: (context, index) {
                  File file = album.images[index];
                  return PhotoViewGalleryPageOptions(
                    heroAttributes: PhotoViewHeroAttributes(tag: file.id),
                    imageProvider: CachedNetworkImageProvider(file.url as String),
                    initialScale: PhotoViewComputedScale.contained,
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 1.1,
                  );
                },
              ),
            ),
            Positioned(
              bottom: 0,
              child: FadeTransition(
                opacity: _fadeController,
                child: SingleChildScrollView(
                  child: Container(
                    width: mediaQuery.size.width,
                    padding: const EdgeInsets.all(24.0),
                    color: Colors.black45,
                    child: Text(
                      currentFile.description,
                      style: TextStyle(
                        fontFamily: FONT_MONTSERRAT,
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
              )
            ),
            GestureDetector(
              onTap: showDetails,
            ),
          ],
        ),
      ),
    );
    
  }
}

/* 
return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        itemCount: album.images.length,
        itemBuilder: (context, index) {
          File currentFile = album.images[index];

          return Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onTap: showDetails,
                  child: PhotoView.customChild(
                  controller: _photoViewController,
                  initialScale: 1.0,
                  minScale: 1.0,
                  maxScale: 3.0,
                    child: Hero(
                      tag: currentFile.id,
                      child: CachedNetworkImage(
                        imageUrl: currentFile.url,
                        fit: BoxFit.contain,
                      ), 
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: FadeTransition(
                  opacity: _fadeController,
                  child: SingleChildScrollView(
                    child: Container(
                      width: mediaQuery.size.width,
                      padding: const EdgeInsets.all(24.0),
                      color: Colors.black45,
                      child: Text(
                        currentFile.description,
                        style: TextStyle(
                          fontFamily: FONT_MONTSERRAT,
                          color: Colors.white
                        ),
                      ),
                    ),
                  ),
                )
              ),
            ],
          );
        },
      )
    );
*/

 /*
 SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      appBar: buildAppBar(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Hero(
            tag: file.id,
            child: CachedNetworkImage(
              imageUrl: file.url,
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Html(
              data: file.description,
              showImages: true,
              useRichText: true,
              renderNewlines: true,
              defaultTextStyle: TextStyle(
                fontSize: 15,
                fontFamily: FONT_MONTSERRAT,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    ); */