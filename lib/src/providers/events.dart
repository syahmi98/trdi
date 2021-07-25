import 'package:flutter/foundation.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';

import '../models/event/event.dart';
import '../api/api_repository.dart';

class Events with ChangeNotifier {
  EventList<Event> events = EventList(events: {});
  Set<Event> _loadedEvents = Set();
  ApiRepository _apiRepository = ApiRepository();
  bool hasLoadedOnce = false;

  Future<Event> getEventBySlug(String slug) async {
    return await _apiRepository.fetchEventBySlug(slug);
  }

  Future<void> loadEvents({int? year, int? month}) async {
    if(year == DateTime.now().year && month == DateTime.now().month) return;
    final Iterable<Event> newEvents = await _apiRepository.fetchEvents(year: year, month: month);

    events.events.clear();
    _loadedEvents.addAll(newEvents);
    _loadedEvents.forEach((e) {
        int days = DateTime(e.dateEnd.year, e.dateEnd.month, e.dateEnd.day)
          .difference(DateTime(e.dateStart.year, e.dateStart.month, e.dateStart.day))
          .inDays + 1;
        
        for(int i = 0; i < days; i++)
          events.add(DateTime(e.dateStart.year, e.dateStart.month, e.dateStart.day+i), e);
    });

    if(!hasLoadedOnce)
      hasLoadedOnce = true;

    notifyListeners();
  }

}