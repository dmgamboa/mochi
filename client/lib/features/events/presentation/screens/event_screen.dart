import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mochi/core/utils/server_url.dart';
import 'package:mochi/core/widgets/layout/layout.dart';
import 'package:http/http.dart' as http;
import 'package:mochi/features/events/presentation/screens/events_screen.dart';
import 'dart:convert';

import '../../../../core/config/colours.dart';

class EventScreenArgs {
  final String eventId;

  EventScreenArgs({
    required this.eventId,
  });
}

class EventScreen extends StatefulWidget {
  static const String route = '/event';

  final EventScreenArgs args;

  const EventScreen({
    required this.args,
    Key? key,
  }) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  Map<String, dynamic> _data = {};

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _parseTime() async {
    final rawStartDate = _data['startDate'];
    final rawEndDate = _data['endDate'];
    final rawStartTime = _data['startTime'];
    final rawEndTime = _data['endTime'];

    final parsedStartDate = DateTime.parse(rawStartDate);
    final parsedEndDate = DateTime.parse(rawEndDate);
    final parsedStartTime = DateTime.parse(rawStartTime);
    final parsedEndTime = DateTime.parse(rawEndTime);

    final startDate = DateFormat('EEEE, MMMM d yyyy').format(parsedStartDate);
    final endDate = DateFormat('EEEE, MMMM d yyyy').format(parsedEndDate);
    final startTime = DateFormat('h:mm a').format(parsedStartTime);
    final endTime = DateFormat('h:mm a').format(parsedEndTime);

    setState(() {
      _data['startDateParsed'] = startDate;
      _data['endDateParsed'] = endDate;
      _data['startTimeParsed'] = startTime;
      _data['endTimeParsed'] = endTime;
    });
  }

  Future<void> _getData() async {
    try {
      var tokenId = await FirebaseAuth.instance.currentUser!.getIdToken(true);
      var body = {
        '_id': widget.args.eventId,
      };

      var url = Uri.parse('${getServerUrl()}events/find');
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $tokenId',
      };

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      List<dynamic> jsonResponse = jsonDecode(response.body);
      Map<String, dynamic> event = Map<String, dynamic>.from(jsonResponse[0]);

      setState(() {
        _data = event;
        _parseTime();
      });
    } catch (e) {
      log('EventScreen error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
        body: SingleChildScrollView(
            child: Column(
      children: [
        Row(
          children: [
            Expanded(child: imageProfile()),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_data['event'] ?? 'loading',
                      style: const TextStyle(fontSize: 24)),
                  // Text(_data['details'] ?? 'loading'),
                  ElevatedButton(
                      onPressed: (() => {}), child: const Text("Edit Event")),
                ],
              ),
            ),
          ],
        ),
        _data['attendees'] != null
            ? (_data['attendees'].any((attendee) =>
                    attendee['id'] == FirebaseAuth.instance.currentUser!.uid))
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: (() => acceptInvite()),
                          child: const Text("Accept Event")),
                      ElevatedButton(
                          onPressed: (() => declineInvite()),
                          child: const Text("Decline Event")),
                    ],
                  )
                : const SizedBox(
                    height: 0,
                  )
            : const CircularProgressIndicator(),
        const Padding(
          padding: EdgeInsets.fromLTRB(30, 20, 0, 0),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text("EVENT DETAILS",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Location:  ${_data['location']}',
                  style: const TextStyle(fontSize: 12))),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Start Date:  ${_data['startDateParsed']}',
                  style: const TextStyle(fontSize: 12))),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text('End Date:  ${_data['endDateParsed']}',
                  style: const TextStyle(fontSize: 12))),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Start Time:  ${_data['startTimeParsed']}',
                  style: const TextStyle(fontSize: 12))),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text('End Time:  ${_data['endTimeParsed']}',
                  style: const TextStyle(fontSize: 12))),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Details:  ${_data['details']}',
                  style: const TextStyle(fontSize: 12))),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(30, 20, 0, 0),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text("ATTENDEES",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: (_data['attendees'] != null && _data['attendees'].length > 0)
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Wrap(
                    children: buildAttendeeChips(),
                  ),
                )
              : const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text("No Attendees have been set for this event...",
                      style: TextStyle(color: Colors.grey)),
                ),
        ),
        // Container(
        //   height: 70,
        //   color: Colours.pink,
        // ),
        const Padding(
          padding: EdgeInsets.fromLTRB(30, 20, 0, 0),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text("EVENT TAGS",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
        ),
        //display chips
        Align(
          alignment: Alignment.centerLeft,
          child: (_data['tags'] != null && _data['tags'].length > 0)
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Wrap(
                    children: buildChips(),
                  ),
                )
              : const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text("No tags have been set for this event...",
                      style: TextStyle(color: Colors.grey)),
                ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(30, 10, 0, 0),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text("POSTS",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
        ),
        Container(
          height: 100,
          color: Colours.blueGreen,
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        ),
      ],
    )));
  }

  Widget imageProfile() {
    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
          radius: 60.0,
          backgroundImage: (_data['image'] == null)
              ? const NetworkImage(
                  "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png")
              : NetworkImage(_data['image'] ?? ''),
        ),
      ]),
    );
  }

  List<Widget> buildAttendeeChips() {
    List<Widget> chips = [];
    var friendsList = _data['attendees'] ?? [];
    var attendeesNameList = friendsList.map((e) => e['name']).toList();
    for (int i = 0; i < attendeesNameList.length && i < 3; i++) {
      // add attendee User object to list called attendeesList, this should be attendeesNameList.
      chips.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.network(
              friendsList.firstWhere((element) =>
                  element.containsKey('name') &&
                  element['name'] == attendeesNameList[i])['profile_picture'],
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
      if (i == 2) {
        if (i != attendeesNameList.length - 1) {
          chips.add(const SizedBox(width: 5));
          chips.add(Text("+${attendeesNameList.length - 3} more",
              style: const TextStyle(color: Colors.grey, fontSize: 10)));
        }
      }
    }
    return chips;
  }

  List<Widget> buildChips() {
    List<Widget> chips = [];
    for (int i = 0; i < _data['tags'].length && i < 3; i++) {
      chips.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
          child: Chip(
            labelPadding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
            labelStyle: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
            label: Text(_data['tags'][i]),
            backgroundColor: Colours.green,
          ),
        ),
      );
      if (i == 2) {
        if (i != _data['tags'].length - 1) {
          chips.add(const SizedBox(width: 5));
          chips.add(Text("+${_data['tags'].length - 3} more",
              style: const TextStyle(color: Colors.grey, fontSize: 10)));
        }
      }
    }
    return chips;
  }

  List<Widget> buildSMChips() {
    List<Widget> chips = [];
    for (int i = 0; i < socialMedias.length; i++) {
      chips.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
          child: Chip(
            labelPadding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            labelStyle: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
            label: Text(socialMedias[i]),
            backgroundColor: Colors.grey,
          ),
        ),
      );
    }
    return chips;
  }

  final socialMedias = ["ALL", "FACEBOOK", "TWITTER", "INSTAGRAM"];

  acceptInvite() async {
    var tokenId = await FirebaseAuth.instance.currentUser!.getIdToken(true);
    var body = {
      'uid': FirebaseAuth.instance.currentUser!.uid,
    };
    var id = widget.args.eventId;

    var url = Uri.parse('${getServerUrl()}events/acceptInvite/$id');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $tokenId',
    };

    final response = await http.put(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    if (context.mounted) {
      Navigator.of(context).pushNamed(EventsScreen.route);
    }
  }

  declineInvite() async {
    var tokenId = await FirebaseAuth.instance.currentUser!.getIdToken(true);
    var body = {
      'uid': FirebaseAuth.instance.currentUser!.uid,
    };
    var id = widget.args.eventId;

    var url = Uri.parse('${getServerUrl()}events/declineInvite/$id');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $tokenId',
    };

    final response = await http.put(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
    // List<dynamic> jsonResponse = jsonDecode(response.body);
    // Map<String, dynamic> event = Map<String, dynamic>.from(jsonResponse[0]);

    if (context.mounted) {
      Navigator.of(context).pushNamed(EventsScreen.route);
    }
  }
}
