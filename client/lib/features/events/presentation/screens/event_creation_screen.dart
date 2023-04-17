import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mochi/core/utils/server_url.dart';
import 'package:mochi/core/widgets/layout/layout.dart';
import 'package:filter_list/filter_list.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:mochi/core/widgets/media_picker/media_picker.dart';

import '../../../../core/config/colours.dart';
import '../../../contacts/data/datasources/friends_remote_datasource.dart';
import '../../../contacts/data/respository/repository.dart';
import '../../../discover/presentation/screens/discover_screen.dart';
import './event_screen.dart';
import 'package:mochi/core/models/models.dart' as models;

import 'package:mochi/core/enums/interestsList.dart' as interests_list;

class EventCreationScreen extends StatefulWidget {
  static const String route = '/event_creation';

  const EventCreationScreen({Key? key}) : super(key: key);

  @override
  State<EventCreationScreen> createState() => _EventCreationScreenState();
}

class _EventCreationScreenState extends State<EventCreationScreen> {
  final ImagePicker _picker = ImagePicker();
  String? _image64;
  String? _imageExtension;

  final _formKey = GlobalKey<FormState>();
  final displayNameController = TextEditingController();
  final displayMessageController = TextEditingController();
  final locationController = TextEditingController();
  final startDateController = TextEditingController();
  final startTimeController = TextEditingController();
  final endDateController = TextEditingController();
  final endTimeController = TextEditingController();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  List<String> selectedTagsList = <String>[];
  List<String> inviteesNameList = <String>[];
  List<models.User> inviteesList = <models.User>[];
  List<models.User> friendsList = <models.User>[];

  late FriendsRemoteDataSource source;

  @override
  void dispose() {
    displayNameController.dispose();
    displayMessageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    startDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    endDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    startTimeController.text = DateFormat('HH:mm').format(DateTime.now());
    endTimeController.text = DateFormat('HH:mm').format(DateTime.now());
    source = FriendsRemoteDataSource();
    getFriends();

    displayMessageController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
        // needsAuth: false,
        navBar: false,
        pageTitle: 'Create an Event',
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Create An Event',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
              imageProfile(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an event name';
                    }
                    return null;
                  },
                  controller: displayNameController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20, 5, 5, 5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      borderSide: BorderSide(width: 1),
                    ),
                    labelText: 'Event Title',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    hintText: 'Title',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: TextFormField(
                          controller: startDateController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.calendar_today),
                            contentPadding: EdgeInsets.fromLTRB(10, 5, 5, 0),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              borderSide: BorderSide(width: 1),
                            ),
                            labelText: 'Start Date',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                            hintText: 'Day the event starts on',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: startDate,
                              firstDate: DateTime(2021),
                              lastDate: DateTime(2101),
                            );
                            if (picked != null) {
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(picked);
                              final newStartDate = DateTime(
                                  picked.year,
                                  picked.month,
                                  picked.day,
                                  startDate.hour,
                                  startDate.minute);

                              setState(() {
                                startDateController.text = formattedDate;
                                startDate = newStartDate;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                        child: TextFormField(
                          controller: startTimeController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.access_time),
                            contentPadding: EdgeInsets.fromLTRB(20, 5, 5, 5),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              borderSide: BorderSide(width: 1),
                            ),
                            labelText: 'Start Time',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                            hintText: 'Time the event starts',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          onTap: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(startDate),
                            );
                            if (picked != null) {
                              final newStartDate = DateTime(
                                  startDate.year,
                                  startDate.month,
                                  startDate.day,
                                  picked.hour,
                                  picked.minute);
                              String formattedTime =
                                  DateFormat('HH:mm').format(newStartDate);

                              setState(() {
                                startTimeController.text = formattedTime;
                                startDate = newStartDate;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: TextFormField(
                          controller: endDateController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.calendar_today),
                            contentPadding: EdgeInsets.fromLTRB(10, 5, 5, 0),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              borderSide: BorderSide(width: 1),
                            ),
                            labelText: 'End Date',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                            hintText: 'Day the event ends on',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: startDate,
                              firstDate: DateTime(2021),
                              lastDate: DateTime(2101),
                            );
                            if (picked != null) {
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(picked);
                              final newEndDate = DateTime(
                                  picked.year,
                                  picked.month,
                                  picked.day,
                                  endDate.hour,
                                  endDate.minute);

                              setState(() {
                                endDateController.text = formattedDate;
                                endDate = newEndDate;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                        child: TextFormField(
                          controller: endTimeController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.access_time),
                            contentPadding: EdgeInsets.fromLTRB(20, 5, 5, 5),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              borderSide: BorderSide(width: 1),
                            ),
                            labelText: 'End Time',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                            hintText: 'Time the event ends',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          onTap: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(endDate),
                            );
                            if (picked != null) {
                              final newEndDate = DateTime(
                                  endDate.year,
                                  endDate.month,
                                  endDate.day,
                                  picked.hour,
                                  picked.minute);
                              String formattedTime =
                                  DateFormat('HH:mm').format(newEndDate);

                              setState(() {
                                endTimeController.text = formattedTime;
                                endDate = newEndDate;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an event name';
                    }
                    return null;
                  },
                  controller: locationController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20, 5, 5, 5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      borderSide: BorderSide(width: 1),
                    ),
                    labelText: 'Event Location',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    hintText: 'Where\'s the party at?',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a display message';
                    }
                    if (value.length > 150) {
                      return 'Display message must be less than 150 characters';
                    }
                    return null;
                  },
                  controller: displayMessageController,
                  autofocus: false,
                  autocorrect: false,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    labelText: 'Event Description',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    hintText: 'Details...',
                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Color(0xFFF2F2F2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      borderSide: BorderSide(width: 1),
                    ),
                  ),
                  // onChanged: ,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "${displayMessageController.text.length}/150",
                    style: const TextStyle(color: Colors.grey, fontSize: 10),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 0, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Invitees",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                color: Colors.black,
                              )),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton.icon(
                        icon: const FaIcon(FontAwesomeIcons.personCirclePlus,
                            size: 20),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colours.blueGreen,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                          ),
                        ),
                        onPressed: () {
                          _openAttendeeDialog();
                        },
                        label: const Text("Invite"),
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: (inviteesNameList.isNotEmpty)
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        child: Wrap(
                          children: buildAttendeeChips(),
                        ),
                      )
                    : const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: Text("No invitees selected yet...",
                            style: TextStyle(color: Colors.grey)),
                      ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 0, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Tags",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                color: Colors.black,
                              )),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton.icon(
                        icon: const FaIcon(FontAwesomeIcons.tag, size: 20),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colours.blueGreen,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                          ),
                        ),
                        onPressed: () {
                          _openFilterDialog();
                        },
                        label: const Text("Add Tags"),
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: (selectedTagsList.isNotEmpty)
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        child: Wrap(
                          children: buildChips(),
                        ),
                      )
                    : const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: Text("No tags selected yet...",
                            style: TextStyle(color: Colors.grey)),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colours.blueGreen,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      var tokenId = await FirebaseAuth.instance.currentUser!
                          .getIdToken(true);

                      var headers = {
                        'Content-Type': 'application/json',
                        'Authorization': 'Bearer $tokenId',
                      };

                      var saveEventImageUrl =
                          Uri.parse('${getServerUrl()}events/saveEventImage');

                      var saveEventImageRes = await http.post(saveEventImageUrl,
                          headers: headers,
                          body: jsonEncode({
                            "image64": _image64,
                            "extension": _imageExtension,
                          }));

                      var imageURL = saveEventImageRes.body;

                      var eventCreationURL =
                          Uri.parse('${getServerUrl()}eventCreation');

                      var encodedUsersList =
                          models.User.encodeUsersList(inviteesList);
                      var startDateISO = startDate.toIso8601String();
                      var endDateISO = endDate.toIso8601String();
                      var response = await http.post(eventCreationURL,
                          headers: headers,
                          body: jsonEncode({
                            "image": imageURL,
                            "location": locationController.text,
                            "startTime": startDateISO,
                            "endTime": endDateISO,
                            "startDate": startDateController.text,
                            "endDate": endDateController.text,
                            "title": displayNameController.text,
                            "details": displayMessageController.text,
                            "attendees": encodedUsersList,
                            "acceptees": [],
                            "tags": selectedTagsList,
                            "posts": [
                              "https://picsum.photos/200",
                              "https://picsum.photos/200"
                            ]
                          }));
                      if (response.statusCode == 201 && context.mounted) {
                        final res = jsonDecode(response.body);

                        ScaffoldMessenger.of(this.context)
                            .showSnackBar(SnackBar(
                          content: Text(res['msg'] ?? ''),
                          backgroundColor: Colors.green,
                        ));

                        Navigator.of(context).pushNamed(
                          EventScreen.route,
                          arguments: EventScreenArgs(eventId: res['eventId']),
                        );
                      }

                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      // ScaffoldMessenger.of(this.context).showSnackBar(
                      //   const SnackBar(content: Text('Processing Data')),
                      // );
                    }
                  },
                  child: const Text('Create Event'),
                ),
              ),
              // buildSignoutBtn(context),
            ]),
          ),
        ));
  }

  // Padding buildSignoutBtn(BuildContext context) {
  //   return Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
  //       child: ElevatedButton(
  //         style: ElevatedButton.styleFrom(
  //           minimumSize: const Size(double.infinity, 50),
  //           shape: const RoundedRectangleBorder(
  //             borderRadius: BorderRadius.all(Radius.circular(10)),
  //           ),
  //         ),
  //         onPressed: () => signOut(context),
  //         child: const Text('Sign Out'),
  //       ));
  // }

  Widget bottomSheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          const Text(
            "Choose A Profile Photo",
            style: TextStyle(
              fontSize: 20.0,
              decoration: TextDecoration.underline,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MediaPicker(
                source: MediaSource.camera,
                onPicked: (path, extension) {
                  log('prestring');
                  log(path.toString());
                  setState(() {
                    _image64 = path;
                    _imageExtension = extension;
                  });
                },
                child: const Icon(CupertinoIcons.camera_fill),
              ),
              const SizedBox(width: 108.0),
              MediaPicker(
                source: MediaSource.gallery,
                onPicked: (path, extension) {
                  log('prestring');
                  log(path.toString());
                  setState(() {
                    _image64 = path;
                    _imageExtension = extension;
                  });
                },
                child: const Icon(CupertinoIcons.photo_fill),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
          radius: 60.0,
          backgroundImage: (_image64 == null)
              ? const NetworkImage(
                  "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png")
              : MemoryImage(
                  base64Decode(_image64!),
                ) as ImageProvider<Object>,
        ),
        Positioned(
          bottom: 12.0,
          right: 12.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                  context: context, builder: ((builder) => bottomSheet()));
            },
            child: const Icon(
              Icons.camera_alt,
              color: Colours.blueGreen,
              size: 28.0,
            ),
          ),
        ),
      ]),
    );
  }

  Future<void> _openFilterDialog() async {
    await FilterListDialog.display<String>(
      context,
      hideSelectedTextCount: true,
      themeData: FilterListThemeData(
        context,
        choiceChipTheme: ChoiceChipThemeData.light(context),
      ),
      headlineText: 'Select Tags',
      height: 500,
      listData: interests_list.interestsList,
      selectedListData: selectedTagsList,
      choiceChipLabel: (item) => item!,
      validateSelectedItem: (list, val) => list!.contains(val),
      controlButtons: [ControlButtonType.All, ControlButtonType.Reset],
      onItemSearch: (interest, query) {
        /// When search query change in search bar then this method will be called
        /// Check if items contains query
        return interest.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {
        setState(() {
          selectedTagsList = List.from(list!);
        });
        Navigator.pop(context);
      },

      /// uncomment below code to create custom choice chip
      choiceChipBuilder: (context, item, isSelected) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected! ? Colours.pink : Colors.grey[300]!,
            ),
            color: isSelected ? Colours.pink : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            item,
            style:
                TextStyle(color: isSelected ? Colors.white : Colors.grey[500]),
          ),
        );
      },
    );
  }

  signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.of(context).pushNamed(DiscoverScreen.route);
    }
  }

  String displaySelectedInterests() {
    String interests = "";
    for (int i = 0; i < selectedTagsList.length && i < 6; i++) {
      interests += selectedTagsList[i];
      if (i != selectedTagsList.length - 1 && i != 5) {
        interests += ", ";
      }
      if (i == 5) {
        interests += " \t\t+${selectedTagsList.length - 6} more";
      }
    }
    return interests;
  }

  List<Widget> buildChips() {
    List<Widget> chips = [];
    for (int i = 0; i < selectedTagsList.length && i < 3; i++) {
      chips.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
          child: InputChip(
            labelPadding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
            labelStyle: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            label: Text(selectedTagsList[i]),
            backgroundColor: Colours.green,
            onDeleted: () {
              setState(() {
                selectedTagsList.removeAt(i);
              });
            },
          ),
        ),
      );
      if (i == 2) {
        if (i != selectedTagsList.length - 1) {
          chips.add(const SizedBox(width: 5));
          chips.add(Text("+${selectedTagsList.length - 3} more",
              style: const TextStyle(color: Colors.grey, fontSize: 10)));
        }
      }
    }
    return chips;
  }

  List<Widget> buildAttendeeChips() {
    List<Widget> chips = [];
    for (int i = 0; i < inviteesNameList.length && i < 3; i++) {
      // add attendee User object to list called attendeesList, this should be attendeesNameList.
      chips.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.network(
              friendsList
                  .firstWhere((element) => element.name == inviteesNameList[i])
                  .avatar,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
      if (i == 2) {
        if (i != selectedTagsList.length - 1) {
          chips.add(const SizedBox(width: 5));
          chips.add(Text("+${inviteesNameList.length - 3} more",
              style: const TextStyle(color: Colors.grey, fontSize: 10)));
        }
      }
    }
    return chips;
  }

  Future<void> _openAttendeeDialog() async {
    await FilterListDialog.display<String>(
      context,
      hideSelectedTextCount: true,
      themeData: FilterListThemeData(
        context,
        choiceChipTheme: ChoiceChipThemeData.light(context),
      ),
      headlineText: 'Select Friends',
      height: 500,
      listData: friendsList.map((e) => e.name).toList(),
      selectedListData: inviteesNameList,
      choiceChipLabel: (item) => item!,
      validateSelectedItem: (list, val) => list!.contains(val),
      controlButtons: [ControlButtonType.All, ControlButtonType.Reset],
      onItemSearch: (friend, query) {
        /// When search query change in search bar then this method will be called
        /// Check if items contains query
        return friend.toLowerCase().contains(query.toLowerCase());
      },

      onApplyButtonClick: (list) {
        setState(() {
          inviteesNameList = List.from(list!);
          inviteesList = friendsList
              .where((element) => inviteesNameList.contains(element.name))
              .toList();
        });
        Navigator.pop(context);
      },

      /// uncomment below code to create custom choice chip
      choiceChipBuilder: (context, item, isSelected) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected! ? Colours.pink : Colors.grey[300]!,
            ),
            color: isSelected ? Colours.pink : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(
                  friendsList
                      .firstWhere((element) => element.name == item)
                      .avatar,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      friendsList
                          .firstWhere((element) => element.name == item)
                          .name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void getFriends() async {
    final res = FriendsListRepository.fromServer(await source.getFriends());
    setState(() => friendsList = res);
  }
}
