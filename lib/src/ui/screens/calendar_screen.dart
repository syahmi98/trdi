import 'package:trdi/src/ui/screens/home/tabs/calendar_tab.dart';
import 'package:flutter/material.dart';
import '../../utils/utils.dart';

class CalendarScreen extends StatefulWidget {
  static const route = "/calendar";
  CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: CalendarTab(),
    );
  }
}