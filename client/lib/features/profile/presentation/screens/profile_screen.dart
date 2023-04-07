import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mochi/core/widgets/layout/layout.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../core/config/colours.dart';
import '../../../events/presentation/screens/event_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const String route = '/profile';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> _data = {};
  List<Widget> userImageSliders = [];
  List<Widget> userHistoryImageSliders = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    try {
      log('inside get data');
      var tokenId = await FirebaseAuth.instance.currentUser!.getIdToken(true);
      var queryParameters = {
        'email': '${FirebaseAuth.instance.currentUser!.email}'
      };
      var url = Uri.http('10.0.2.2:3000', '/users/find', queryParameters);
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
      });
      log(_data.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  void setUserImageSliders(bool isHistory) {
    log('inside set user image sliders');
    print('inside set user image sliders');
    print(_data['events']);
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
                margin:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
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
                  Text(_data['name'] ?? 'loading',
                      style: const TextStyle(fontSize: 24)),
                  Text(_data['display_message'] ?? 'loading'),
                  ElevatedButton(
                      onPressed: (() => {
                            Navigator.pushNamed(context, '/edit-profile')
                                .then((_) {
                              setState(() {
                                _getData();
                              });
                            })
                          }),
                      child: const Text("Edit Profile")),
                ],
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(30, 20, 0, 0),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text("INTERESTS", style: TextStyle(fontSize: 18))),
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
                  child: Text("No interests selected yet...",
                      style: TextStyle(color: Colors.grey)),
                ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(30, 10, 0, 0),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text("UPCOMING EVENTS", style: TextStyle(fontSize: 18))),
        ),
        (userImageSliders.isNotEmpty
            ? CarouselSlider(
                options: CarouselOptions(
                  autoPlay: false,
                  aspectRatio: 2.0,
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
          padding: EdgeInsets.fromLTRB(30, 10, 0, 0),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text("PAST EVENTS", style: TextStyle(fontSize: 18))),
        ),
        (userHistoryImageSliders.isNotEmpty
            ? CarouselSlider(
                options: CarouselOptions(
                  autoPlay: false,
                  aspectRatio: 2.0,
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
        // const Padding(
        //   padding: EdgeInsets.fromLTRB(30, 20, 0, 0),
        //   child: Align(
        //       alignment: Alignment.centerLeft,
        //       child: Text("SOCIAL MEDIA", style: TextStyle(fontSize: 18))),
        // ),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        //   child: Wrap(
        //     children: buildSMChips(),
        //   ),
        // ),
        // Container(
        //   height: 100,
        //   color: Colours.blueGreen,
        //   margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        // ),
      ],
    )));
  }

  Widget imageProfile() {
    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
          radius: 60.0,
          backgroundImage: (_data['profile_picture'] == null)
              ? const NetworkImage(
                  "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png")
              : NetworkImage(_data['profile_picture'] ?? ''),
        ),
      ]),
    );
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
}
