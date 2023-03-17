import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mochi/core/widgets/layout/layout.dart';
import 'package:filter_list/filter_list.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mochi/features/profile/presentation/screens/profile_screen.dart';

import '../../../../core/config/colours.dart';
import '../../../discover/presentation/screens/discover_screen.dart';

import 'package:mochi/core/enums/interestsList.dart' as interests_list;

class ProfileCreationScreen extends StatefulWidget {
  static const String route = '/profile_creation';

  const ProfileCreationScreen({Key? key}) : super(key: key);

  @override
  State<ProfileCreationScreen> createState() => _ProfileCreationScreenState();
}

class _ProfileCreationScreenState extends State<ProfileCreationScreen> {
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();
  final displayNameController = TextEditingController();
  final displayMessageController = TextEditingController();
  List<String> selectedInterestsList = <String>[];

  @override
  void dispose() {
    displayNameController.dispose();
    displayMessageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    displayMessageController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
        // needsAuth: false,
        navBar: false,
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Create your profile',
                    style: TextStyle(
                      fontSize: 30,
                    )),
              ),
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
                  controller: displayNameController,
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
                  controller: displayMessageController,
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: Text("No interests selected yet...",
                            style: TextStyle(color: Colors.grey)),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      var tokenId = await FirebaseAuth.instance.currentUser!
                          .getIdToken(true);
                      var url =
                          Uri.parse('http://10.0.2.2:3000/profileCreation');
                      var _headers = {
                        'Content-Type': 'application/json',
                        'Authorization': 'Bearer $tokenId',
                      };
                      var response = await http.post(url,
                          headers: _headers,
                          body: jsonEncode({
                            "profileImage": "https://picsum.photos/200",
                            "displayName": displayNameController.text,
                            "displayMessage": displayMessageController.text,
                            "interests": selectedInterestsList,
                          }));
                      ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
                        content: Text(response.body),
                        backgroundColor: Colors.green,
                      ));
                      await Future.delayed(const Duration(seconds: 5));
                      if (context.mounted) {
                        Navigator.of(context).pushNamed(ProfileScreen.route);
                      }

                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(content: Text('Processing Data')),
                      // );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
              buildSignoutBtn(context),
            ]),
          ),
        ));
  }

  Padding buildSignoutBtn(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          onPressed: () => signOut(context),
          child: const Text('Sign Out'),
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
              TextButton.icon(
                icon: const Icon(Icons.camera, color: Colours.blueGreen),
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                label: const Text("Camera",
                    style: TextStyle(color: Colours.blueGreen)),
              ),
              TextButton.icon(
                icon: const Icon(Icons.image, color: Colours.blue),
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                label: const Text("Gallery",
                    style: TextStyle(color: Colours.blue)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile == null) return;
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Widget imageProfile() {
    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
          radius: 60.0,
          backgroundImage: (_imageFile == null)
              ? const NetworkImage(
                  "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png")
              : FileImage(File(_imageFile!.path)) as ImageProvider<Object>?,
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
