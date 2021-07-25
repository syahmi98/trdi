import 'package:flutter/material.dart';

import '../../utils/utils.dart';

class AboutScreen extends StatelessWidget {

  final List<Map<String, dynamic>> items = [{
      "icon": Icons.home,
      "text": "Jalan Pejabat, 20200 Kuala Terengganu, Terengganu",

    }, {
      "icon": Icons.phone,
      "text": "+609-623 0582",

    }, {
      "icon": Icons.phonelink,
      "text": "+609-631 7504",

    }, {
      "icon": Icons.mail,
      "text": "updi@terengganu.gov.my"
    }
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Text(
            "Hubungi Kami",
            style: Theme.of(context).textTheme.headline!.copyWith(
              fontWeight: FontWeight.bold
            ),
          ),
          Text("Urusetia Penerangan Darul Iman (UPDI)"),
          Divider(),

          ...items.map((item) {
            return Column(
              children: [
                ListTile(
                  leading: Icon(
                    item['icon'],
                    color: Colors.black,
                  ),
                  title: Text(item['text']),
                ),
                Divider(),
              ],
            );
          }).toList(),
          SizedBox(height: 16),
          Text(
            "Polisi dan Peribadi",
            style: Theme.of(context).textTheme.headline!.copyWith(
              fontWeight: FontWeight.bold
            ),
          ),
          Text(
            "TRDI aims to establish a safe and enjoyable environment for our users by keeping your personal information confidential while using the TRDI services. TRDI is committed to keeping your personal information safe. Links to other Websites TRDI contains hyperlinks to other websites operated by third party companies. These third party companies have their own privacy policies that we urge you to review. TRDI does not hold any responsibility for the privacy practices of such third party websites and your use of such websites is at your own risk.",
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}