import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:mochi/core/widgets/layout/layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../core/config/colours.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:filter_list/filter_list.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:mochi/core/enums/interestsList.dart' as interests_list;
import 'package:mochi/core/utils/server_url.dart';

import 'package:flutter/cupertino.dart';
import 'package:mochi/core/widgets/media_picker/media_picker.dart';

class EditProfileScreen extends StatefulWidget {
  static const String route = '/edit-profile';
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Map<String, dynamic> _data = {};
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String? _image64;
  String? _imageExtension;

  final _formKey = GlobalKey<FormState>();
  final displayNameController = TextEditingController();
  final displayMessageController = TextEditingController();
  List<String> selectedInterestsList = <String>[];
  String name = '';
  String displayMessage = '';

  // Tab Button Variables
  bool tabButtonSelected = false;

  //notification settings
  String coldStreakNotifications = "daily";
  String hotStreakNotifications = "daily";
  String eventsNotifications = "daily";

  //Notification Options
  List<String> intervals = ["off", "daily", "weekly", "random"];
  List<String> preferences = ["off", "invites", "reminders", "updates"];

  @override
  void dispose() {
    displayNameController.dispose();
    displayMessageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _updateData() async {
    try {
      var tokenId = await FirebaseAuth.instance.currentUser!.getIdToken(true);

      String id = _data['_id'];

      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $tokenId',
      };

      var saveProfileImageUrl =
          Uri.parse('${getServerUrl()}users/saveProfileImage');

      var saveProfileImageRes = await http.post(saveProfileImageUrl,
          headers: headers,
          body: jsonEncode({
            "image64": _image64,
            "extension": _imageExtension,
          }));

      var imageURL = saveProfileImageRes.body;

      var url = Uri.parse('${getServerUrl()}users/update/$id');

      final response = await http.put(url,
          headers: headers,
          body: jsonEncode({
            'name': displayNameController.text,
            'display_message': displayMessageController.text,
            'profile_picture': imageURL,
            'tags': selectedInterestsList,
            'settings': {
              'friend_cold_notifications': [coldStreakNotifications],
              'friend_hot_notifications': [hotStreakNotifications],
              'event_notifications': [eventsNotifications]
            }
          }));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error updating profile'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _getData() async {
    try {
      log('inside get data');
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
      final jsonResponse = jsonDecode(response.body);
      final firstItem = jsonResponse[0];
      final id = firstItem['_id'];

      setState(() {
        _data = firstItem;
      });
      log(_data.toString());
    } catch (e) {
      log(e.toString());
    }

    selectedInterestsList =
        (_data['tags'] as List).map((item) => item as String).toList();
    name = _data['name'] ?? '';
    displayMessage = _data['display_message'] ?? '';
    coldStreakNotifications =
        _data['settings']['friend_cold_notifications'][0] ?? "daily";
    hotStreakNotifications =
        _data['settings']['friend_hot_notifications'][0] ?? "daily";
    eventsNotifications =
        _data['settings']['event_notifications'][0] ?? "daily";
  }

  signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.of(context).pushNamed(EditProfileScreen.route);
    }
  }

  List<DropdownMenuItem<String>> get inters {
    List<DropdownMenuItem<String>> items = [];
    for (String interval in intervals) {
      items.add(DropdownMenuItem(
        value: interval,
        child: Text(interval),
      ));
    }
    return items;
  }

  List<DropdownMenuItem<String>> get prefs {
    List<DropdownMenuItem<String>> items = [];
    for (String preference in preferences) {
      items.add(DropdownMenuItem(
        value: preference,
        child: Text(preference),
      ));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
        // needsAuth: false,
        navBar: false,
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottomOpacity: 0,
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Profile Settings',
                    style: TextStyle(
                      fontSize: 30,
                    )),
              ),
              settingTabs(),
              if (!tabButtonSelected) ...[
                // Show profile settings if false; else show notification settings
                imageProfile(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a display name';
                      }
                      return null;
                    },
                    controller: displayNameController..text = name,
                    onChanged: (value) => name = value,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      prefixIcon: Padding(
                        padding: EdgeInsets.fromLTRB(10, 12, 0, 0),
                        child: FaIcon(FontAwesomeIcons.circleUser),
                      ),
                      border: UnderlineInputBorder(),
                      labelText: 'Display Name',
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      hintText: 'Display Name',
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
                    controller: displayMessageController..text = displayMessage,
                    onChanged: (value) => displayMessage = value,
                    autofocus: false,
                    autocorrect: false,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 8,
                    decoration: const InputDecoration(
                      labelText: 'Display Message',
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      hintText: 'Display Message',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Color(0xFFF2F2F2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1),
                      ),
                    ),
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 10, 0, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Interests",
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
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
                      icon: const FaIcon(FontAwesomeIcons.heartCirclePlus,
                          size: 20),
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                      ),
                      onPressed: () {
                        _openFilterDialog();
                      },
                      label: const Text("Add Interests"),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: (selectedInterestsList.isNotEmpty)
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          child: Wrap(
                            children: buildChips(),
                          ),
                        )
                      : const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          child: Text("No interests selected yet...",
                              style: TextStyle(color: Colors.grey)),
                        ),
                ),
                buildSaveBtn(context),
                buildChangePasswordBtn(context),
                buildLogoutBtn(context),
              ] else ...[
                ListView(
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 10, 0, 0),
                      child: Text(
                        "Events notifications",
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  color: Colors.black,
                                ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: eventsNotifications,
                        onChanged: (String? newValue) {
                          setState(() {
                            eventsNotifications = newValue!;
                          });
                        },
                        items: intervals
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                      child: Text(
                        "Hot Streak notifications",
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  color: Colors.black,
                                ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: hotStreakNotifications,
                        onChanged: (String? newValue) {
                          setState(() {
                            hotStreakNotifications = newValue!;
                          });
                        },
                        items: intervals
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                      child: Text(
                        "Cold Streak notifications",
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  color: Colors.black,
                                ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: coldStreakNotifications,
                        onChanged: (String? newValue) {
                          setState(() {
                            coldStreakNotifications = newValue!;
                          });
                        },
                        items: intervals
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ]),
          ),
        ));
  }

  Padding buildSaveBtn(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          onPressed: () async {
            await _updateData();
          },
          child: const Text('Save'),
        ));
  }

  Padding buildChangePasswordBtn(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/update-password');
          },
          child: const Text('Update Password'),
        ));
  }

  Padding buildLogoutBtn(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          onPressed: () async {
            await signOut(context);
          },
          child: const Text('Logout'),
        ));
  }

  Widget settingTabs() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 6.0),
              child: ElevatedButton(
                  onPressed: () => {
                        setState(() {
                          tabButtonSelected = false;
                        })
                      },
                  child: Text("Profile"),
                  style: ElevatedButton.styleFrom(
                    primary: tabButtonSelected ? Colors.grey : Colors.green,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 6.0),
              child: ElevatedButton(
                  onPressed: () => {
                        setState(() {
                          tabButtonSelected = true;
                        })
                      },
                  child: Text("Notifications"),
                  style: ElevatedButton.styleFrom(
                    primary: tabButtonSelected ? Colors.green : Colors.grey,
                  )),
            )
          ],
        ));
  }

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
              color: Colours.pink,
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
      headlineText: 'Select Users',
      height: 500,
      listData: interests_list.interestsList,
      selectedListData: selectedInterestsList,
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
          selectedInterestsList = List.from(list!);
          name = displayNameController.text;
          displayMessage = displayMessageController.text;
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

  String displaySelectedInterests() {
    String interests = "";
    for (int i = 0; i < selectedInterestsList.length && i < 6; i++) {
      interests += selectedInterestsList[i];
      if (i != selectedInterestsList.length - 1 && i != 5) {
        interests += ", ";
      }
      if (i == 5) {
        interests += " \t\t+${selectedInterestsList.length - 6} more";
      }
    }
    return interests;
  }

  List<Widget> buildChips() {
    List<Widget> chips = [];
    for (int i = 0; i < selectedInterestsList.length && i < 3; i++) {
      chips.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
          child: InputChip(
            labelPadding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
            labelStyle: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            label: Text(selectedInterestsList[i]),
            backgroundColor: Colours.green,
            onDeleted: () {
              setState(() {
                selectedInterestsList.removeAt(i);
                name = displayNameController.text;
                displayMessage = displayMessageController.text;
              });
            },
          ),
        ),
      );
      if (i == 2) {
        if (i != selectedInterestsList.length - 1) {
          chips.add(const SizedBox(width: 5));
          chips.add(Text("+${selectedInterestsList.length - 3} more",
              style: const TextStyle(color: Colors.grey, fontSize: 10)));
        }
      }
    }
    return chips;
  }
}
