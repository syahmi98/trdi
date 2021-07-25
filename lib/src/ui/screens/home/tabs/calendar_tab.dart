import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../utils/utils.dart';

class CalendarTab extends StatefulWidget {
  const CalendarTab({Key? key}) : super(key: key);
  @override
  _CalendarTabState createState() => _CalendarTabState();
}

// List<Event> testEvents = [
//   Event(0, "TEST 1", "slug", "", "", "", "", "", "", 0, 0, 0),
// ];

class _CalendarTabState extends State<CalendarTab> {
  late DateTime _selectedDate, _calendarDate;

  @override
  void initState() {
    // if(!Provider.of<Events>(context, listen: false).hasLoadedOnce) {
    //   Provider.of<Events>(context, listen: false).loadEvents().then((_) {
    //     setState(() {
    //       final today = DateTime.now();
    //       _selectedDate = DateTime(today.year, today.month, today.day);
    //     });
    //   });
    // }
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Events>(
      builder: (ctx, provider, child) {
        return Column(
          children: <Widget>[
            Expanded(
              child: CalendarCarousel<Event>(
                scrollDirection: Axis.horizontal,
                onDayPressed: (DateTime date, List<Event> events) {
                  this.setState(() => _selectedDate = date);
                },
                weekendTextStyle: TextStyle(
                  color: Theme.of(context).textTheme.body1.color,
                ),
                daysTextStyle: TextStyle(
                  color: Theme.of(context).textTheme.body1.color,
                ),
                thisMonthDayBorderColor: Theme.of(context).textTheme.body1.color.withOpacity(.45),
                markedDatesMap: provider.events,
                todayButtonColor: Theme.of(context).accentColor,
                selectedDateTime: _selectedDate,
                daysHaveCircularBorder: null,
                weekdayTextStyle: TextStyle(
                  color: Theme.of(context).textTheme.body1.color,
                ),
                weekFormat: false,
                onCalendarChanged: (date) {
                  if(_calendarDate != date) {
                    _calendarDate = date;

                    provider.loadEvents(
                      year: _calendarDate.year,
                      month: _calendarDate.month
                    ).then((_) => setState(() {}));
                  }
                },
              ),
            ),

            if(_selectedDate != null && provider.events.getEvents(_selectedDate).isNotEmpty)
            Expanded(
              flex: 1,
              child: ListView.builder(
                itemCount: provider.events.getEvents(_selectedDate).length,
                itemBuilder: (ctx, index) {
                  Event event = provider.events.getEvents(_selectedDate)[index];
                  return Container(
                    margin: EdgeInsets.only(
                      left: 5,
                      right: 5,
                      top: 5,
                      bottom: index == provider.events.getEvents(_selectedDate).length-1 ? 5 : 0,
                    ),
                    child: Material(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          width: 2.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      child: InkWell(
                        onTap: () => Navigator.of(context).pushNamed(ROUTE_EVENT_SCREEN, arguments: event.slug),
                        borderRadius: BorderRadius.circular(10),
                        child: ListTile(
                          title: Text(event.title),
                          subtitle: Text(
                            "${DateFormat.jm().format(event.dateStart)} - ${DateFormat.jm().format(event.dateEnd)}"
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}