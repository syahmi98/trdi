import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../widgets/centered_circular_progress_indicator.dart';
import '../widgets/error_dialog.dart';
import '../../utils/enums.dart';
import '../../providers/events.dart';
import '../../models/event/event.dart';
import '../../utils/utils.dart';

class EventScreen extends StatefulWidget {
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  UiState _uiState;
  bool _hasLoaded = false;
  Event event;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if(!_hasLoaded) {
      loadData().then((_) {
        _hasLoaded = true;
      });
    }
  }

  Future<void> loadData() async {
    if(_uiState == UiState.isLoading) return;
    setState(() => _uiState = UiState.isLoading);

    try {
      String postSlug = ModalRoute.of(context).settings.arguments as String;

      event = await Provider.of<Events>(context, listen: false).getEventBySlug(postSlug);
      
      setState(() => _uiState = UiState.hasData);
       
    } catch (error) {
      setState(() => _uiState = UiState.hasError);

    }
  }

  Widget buildErrorWidget() => ErrorDialog(
    onTap: () => Navigator.of(context).pop(),
  );
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: _uiState == UiState.hasError
        ? buildErrorWidget()
        : _uiState == UiState.isLoading
          ? CenteredCircularProgressIndicator()
          : buildDataWidget()
    );
  }

  Widget buildDataWidget() {
    var mediaQuery = MediaQuery.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if(event.imageUrl != null)
            CachedNetworkImage(
              imageUrl: event.imageUrl,
              placeholder: (_, __) => CenteredCircularProgressIndicator(),
              fit: BoxFit.cover,
              width: mediaQuery.size.width,
              height: mediaQuery.size.width * 0.6,
            ),

          const SizedBox(height: 18),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  event.title,
                  style: Theme.of(context).textTheme.headline.copyWith(
                    fontFamily: FONT_MONTSERRAT,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 12,),

                Text(
                  "${DateFormat.jm().format(event.dateStart)} - ${DateFormat.jm().format(event.dateEnd)}"
                ),

                const SizedBox(height: 12,),

                Divider(),

                if(event.description != null)
                    Html(
                    data: event.description,
                    showImages: true,
                    useRichText: true,
                    renderNewlines: true,
                    defaultTextStyle: TextStyle(
                      fontSize: 15,
                      fontFamily: FONT_MONTSERRAT,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                if(event.description != null)
                  const SizedBox(height: 12,),

                if(event.content != null)
                  Html(
                    data: event.content,
                    showImages: true,
                    useRichText: true,
                    renderNewlines: true,
                    defaultTextStyle: TextStyle(
                      fontSize: 15,
                      fontFamily: FONT_MONTSERRAT,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                const SizedBox(height: 12,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}