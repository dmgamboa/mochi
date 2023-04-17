import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mochi/core/utils/server_url.dart';
import 'package:mochi/core/widgets/layout/layout.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mochi/features/events/presentation/screens/event_creation_screen.dart';
import 'package:mochi/features/events/presentation/screens/event_screen.dart';

import 'dart:developer';

import '../../../../core/config/colours.dart';

class EventsScreen extends StatefulWidget {
  static const String route = '/events';

  const EventsScreen({Key? key}) : super(key: key);

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  Map<String, dynamic> _data = {};
  List<Widget> userImageSliders = [];
  List<Widget> userHistoryImageSliders = [];
  List<Widget> friendImageSliders = [];
  List<Widget> invitedImageSliders = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      pageTitle: 'Events',
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      const Text('UPCOMING EVENTS',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.overline,
                              decorationColor: Colours.blueGreen,
                              decorationStyle: TextDecorationStyle.wavy,
                              decorationThickness: 5)),
                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colours.blueGreen,
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(EventCreationScreen.route);
                        },
                        child: const Text("Create Event"),
                      ),
                    ],
                  )),
            ),
            (userImageSliders.isNotEmpty
                ? CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      aspectRatio: 2.2,
                      enlargeCenterPage: true,
                    ),
                    items: userImageSliders,
                  )
                : const Padding(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 5),
                    child: Text(
                      "No Events Created Yet..",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )),
            const Padding(
              padding: EdgeInsets.fromLTRB(30, 30, 30, 10),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('INVITED EVENTS',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.overline,
                          decorationColor: Colours.green,
                          decorationStyle: TextDecorationStyle.wavy,
                          decorationThickness: 5))),
            ),
            (invitedImageSliders.isNotEmpty
                ? CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: false,
                      aspectRatio: 2.2,
                      enlargeCenterPage: true,
                    ),
                    items: invitedImageSliders,
                  )
                : const Padding(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 5),
                    child: Text(
                      "No Invited Events..",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )),
            const Padding(
              padding: EdgeInsets.fromLTRB(30, 30, 30, 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'FRIEND\'S EVENTS',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.overline,
                      decorationColor: Colours.pink,
                      decorationStyle: TextDecorationStyle.wavy,
                      decorationThickness: 5),
                ),
              ),
            ),
            (friendImageSliders.isNotEmpty
                ? CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: false,
                      aspectRatio: 2.2,
                      enlargeCenterPage: true,
                    ),
                    items: friendImageSliders,
                  )
                : const Padding(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 5),
                    child: Text(
                      "No Events Created Yet..",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )),
            const Padding(
              padding: EdgeInsets.fromLTRB(30, 30, 30, 10),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('PAST EVENTS',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.overline,
                          decorationColor: Colors.black,
                          decorationStyle: TextDecorationStyle.wavy,
                          decorationThickness: 5))),
            ),
            (userHistoryImageSliders.isNotEmpty
                ? CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: false,
                      aspectRatio: 2.2,
                      enlargeCenterPage: true,
                    ),
                    items: userHistoryImageSliders,
                  )
                : const Padding(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 5),
                    child: Text(
                      "No Past Events..",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )),
          ],
        ),
      ),
    );
  }

  final List<Widget> imageSliders = imgList
      .map((item) => GestureDetector(
            onTap: () {
              log('clicked on ${imgList.indexOf(item)}');
            },
            child: Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.network(item, fit: BoxFit.cover, width: 1000.0),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(200, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'No. ${imgList.indexOf(item)} image',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'March ${imgList.indexOf(item)}, 2023',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ))
      .toList();

  createEvent() {
    log('create event');
  }

  Future<void> _getData() async {
    try {
      var tokenId = await FirebaseAuth.instance.currentUser!.getIdToken(true);
      var queryParameters = {
        'email': '${FirebaseAuth.instance.currentUser!.email}'
      };
      var url = Uri.parse(
          '${getServerUrl()}users/find?email=${FirebaseAuth.instance.currentUser!.email}');
      var _headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $tokenId',
      };
      final response = await http.get(url, headers: _headers);
      log(response.body.toString());
      final jsonResponse = jsonDecode(response.body);
      final firstItem = jsonResponse[0];
      final id = firstItem['_id'];

      setState(() {
        _data = firstItem;
        setUserImageSliders(true);
        setUserImageSliders(false);
        setFriendImageSliders();
        setInvitedImageSliders();
      });
      log(_data.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  void setUserImageSliders(bool isHistory) {
    userImageSliders = _data['events']
        .where((item) => isHistory
            ? DateTime.parse(item['date']).millisecondsSinceEpoch <
                DateTime.now().millisecondsSinceEpoch
            : DateTime.parse(item['date']).millisecondsSinceEpoch >
                DateTime.now().millisecondsSinceEpoch)
        .map<Widget>((item) => GestureDetector(
              onTap: () {
                // log('clicked on ${item['event']}');
                Navigator.of(context).pushNamed(EventScreen.route,
                    arguments: EventScreenArgs(eventId: item['event_id']));
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                decoration: BoxDecoration(
                  border: isHistory
                      ? Border.all(
                          color: Colors.black,
                          width: 5.0,
                        )
                      : Border.all(
                          color: Colours.blueGreen,
                          width: 5.0,
                        ),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(0.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.network(item['image'],
                            fit: BoxFit.cover,
                            width: 1000.0,
                            color: isHistory ? Colors.grey : null,
                            colorBlendMode: BlendMode.saturation),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(200, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['event'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  DateFormat('MMMM dd, yyyy')
                                      .format(DateTime.parse(item['date'])),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ))
        .toList();
    setState(() {
      isHistory
          ? userHistoryImageSliders = userImageSliders
          : userImageSliders = userImageSliders;
    });
  }

  void setFriendImageSliders() async {
    try {
      var tokenId = await FirebaseAuth.instance.currentUser!.getIdToken(true);
      var url = Uri.parse('${getServerUrl()}events/friends');
      var _headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $tokenId',
      };

      final response = await http.get(url, headers: _headers);
      final eventsJsonResponse = jsonDecode(response.body);

      friendImageSliders = await eventsJsonResponse.map<Widget>((item) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(EventScreen.route,
                arguments: EventScreenArgs(eventId: item['event_id']));
          },
          child: Container(
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colours.pink,
                width: 5.0,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(0.0)),
              child: Stack(
                children: <Widget>[
                  Image.network(item['image'],
                      fit: BoxFit.cover, width: 1000.0),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(200, 0, 0, 0),
                            Color.fromARGB(0, 0, 0, 0)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['event'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            // DateFormat('yyyy-MM-dd').format(item['date']),
                            DateFormat('MMMM dd, yyyy')
                                .format(DateTime.parse(item['date'])),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList();

      setState(() {
        friendImageSliders = friendImageSliders;
      });
    } catch (e) {
      log('Error: ${e.toString()}');
    }
  }

  void setInvitedImageSliders() async {
    try {
      var tokenId = await FirebaseAuth.instance.currentUser!.getIdToken(true);
      var url = Uri.parse('${getServerUrl()}events/invited');
      var _headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $tokenId',
      };

      final response = await http.get(url, headers: _headers);
      final eventsJsonResponse = jsonDecode(response.body);

      invitedImageSliders = await eventsJsonResponse.map<Widget>((item) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              EventScreen.route,
              arguments: EventScreenArgs(eventId: item['event_id']),
            );
          },
          child: Container(
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colours.green,
                width: 5.0,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0.0),
              child: Stack(
                children: <Widget>[
                  Image.network(
                    item['image'],
                    fit: BoxFit.cover,
                    width: 1000.0,
                  ),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(200, 0, 0, 0),
                            Color.fromARGB(0, 0, 0, 0)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 20.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['event'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            DateFormat('MMMM dd, yyyy')
                                .format(DateTime.parse(item['date'])),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList();

      setState(() {
        invitedImageSliders = invitedImageSliders;
      });
    } catch (e) {
      log('Error: ${e.toString()}');
    }
  }
}

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];
