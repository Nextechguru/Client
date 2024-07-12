// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:roshan_dastak_client/Log_in_out_pages/signup_next_page.dart';
import 'package:roshan_dastak_client/Log_in_out_pages/signup_page.dart';
import 'package:roshan_dastak_client/main.dart';
import 'package:roshan_dastak_client/services_pages/firebase_auth_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State {
  var name;
  var father;
  var cnic;
  var phone;
  var address;
  var password;

  var nomineeName;
  var nomineeFather;
  var nomineeCNIC;
  var nomineeAddress;
  var profileURL;
  var profileStatus;
  // this is use to auto focus to next text filed after entering value and press enter in keyboard
  FocusNode FocusNode1 = FocusNode();
  FocusNode FocusNode2 = FocusNode();
  FocusNode FocusNode3 = FocusNode();

  // Calling _auth form firebase_auth_servies very important
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  // Textfield data store in these variable
  var uID = TextEditingController();
  var uPassword = TextEditingController();
  // for Shared Preference Keys
  // togel password show in stars or show password in textformfield
  var _isobsecured;

  // to dispose vareiable so it will not use space when not used

  @override
  void dispose() {
    uID.dispose();
    uPassword.dispose();
    super.dispose();
  }

  var UserName = "";

  @override
  void initState() {
    super.initState();
    _isobsecured = true;
    // getValue_Prefs();
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Stack(children: [
            Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            Positioned(
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(100.0),
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 55,
                            backgroundColor: Colors.greenAccent,
                            child: Stack(
                              alignment: Alignment
                                  .center, // Center the icon within the avatar
                              children: [
                                CircleAvatar(
                                  radius: 54,
                                  backgroundColor: Colors.white,
                                ),
                                Icon(
                                  Icons
                                      .person_rounded, // Replace 'Icons.person' with your desired icon
                                  size: 100.0, // Adjust icon size as needed
                                  color: Colors.green, // Set icon color
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(100.0),
                        ),
                      ),
                      child: const Center(
                          child: Text(
                        'Welcome \n to Roshan Dastak',
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      )),
                    ),
                  ),
                ],
              ),
            ),
          ]),
          Positioned(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 20, left: 20),
                child: Opacity(
                  opacity: 0.9,
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(right: 40, top: 50, left: 40),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            controller: uID,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(13),
                            ],
                            focusNode: FocusNode1,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              label: const Text("CNIC"),
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(21),
                                  borderSide: const BorderSide(
                                      color: Colors.green, width: 1)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(21),
                                  borderSide: const BorderSide(
                                      color: Colors.black, width: 1)),
                              hintText: 'Enter Your Id Card',
                              suffixIcon: uID.text.length == 13
                                  ? const Icon(Icons.check, color: Colors.green)
                                  : null,
                              //prefixIcon: IconButton(icon: const Icon(Icons.contact_mail),color: Colors.orangeAccent, onPressed:(){},),
                              prefixIcon: const Icon(Icons.contact_mail,
                                  color: Colors.green),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(21),
                                  borderSide: const BorderSide(
                                      color: Colors.blue, width: 1)),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(21),
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 1)),
                            ),
                            onChanged: (text) => setState(() {
                              // Update state to trigger rebuild
                            }),
                            validator: (number) {
                              if (number!.isEmpty) {
                                return null; // No error for empty field
                              } else if (number.length != 13) {
                                return 'Please Enter Correct CNIC'; // Error for incorrect length
                              } else {
                                return null; // No error for valid length (13 characters)
                              }
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onFieldSubmitted: (value) {
                              FocusScope.of(context).requestFocus(FocusNode2);
                            },
                          ),
                          const SizedBox(
                              child: Padding(
                            padding:
                                EdgeInsets.only(left: 15, bottom: 7, top: 15),
                          )),
                          TextFormField(
                            focusNode: FocusNode2,
                            // for Hiding password during entering.. also adding variable "_isobsecured" instead of ture, to toglle with eye button
                            obscureText: _isobsecured,
                            enabled: true,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(6),
                            ],
                            controller: uPassword,
                            decoration: InputDecoration(
                              label: const Text("Password"),
                              fillColor: Colors.white,
                              hintText: 'Enter Your Password',
                              prefixIcon: const Icon(
                                Icons.password,
                                color: Colors.green,
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.remove_red_eye),
                                color: Colors.green,
                                onPressed: () {
                                  if (_isobsecured == true) {
                                    _isobsecured = false;
                                  } else {
                                    _isobsecured = true;
                                  }
                                  setState(() {});
                                },
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(21),
                                  borderSide: const BorderSide(
                                      color: Colors.green, width: 1)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(21),
                                  borderSide: const BorderSide(
                                      color: Colors.black, width: 1)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(21),
                                  borderSide: const BorderSide(
                                      color: Colors.blue, width: 1)),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(21),
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 1)),
                            ),
                            onChanged: (number) => setState(() {
                              // Update state to trigger rebuild
                            }),
                            validator: (number) {
                              if (number!.isEmpty) {
                                return null; // No error for empty field
                              } else if (number.length != 6) {
                                return 'Please Enter 6 digit Password'; // Error for incorrect length
                              } else {
                                return null; // No error for valid length (13 characters)
                              }
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onFieldSubmitted: (value) {
                              FocusScope.of(context).requestFocus(FocusNode3);
                              _signIn();
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Center(
                                child: SizedBox(
                              width: double.infinity,
                              height: 35,
                              child: ElevatedButton(
                                  focusNode: FocusNode3,
                                  onPressed: () async {
                                    setState(() {
                                      isLoading = true;
                                      _signIn();
                                    });
                                  },
                                  child: isLoading
                                      ? const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text('Validating...       '),
                                            CircularProgressIndicator(),
                                          ],
                                        )
                                      : const Text('Login')),
                            )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SignUpPage()));
                                  },
                                  child: const Text(
                                    'New User > SignUp Here',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    )));
  }

  void _signIn() async {
    String user_CNIC = uID.text;
    String user_pass = uPassword.text;

    // use @mail.com on every user because firebase accept email formate so i use CNIC with @mail.com
    final email = '$user_CNIC@mail.com';

    User? user = await _auth.signInWithEmailAndPassword(email, user_pass);
    if (user != null) {
      // Checking If Profile Status is Completed then move to Home Page other vise move tho NEXT-SIGNUP-PAGE to complete profile
      DocumentReference MainInstance =
          FirebaseFirestore.instance.collection('Users').doc(user_CNIC);

      DocumentSnapshot MainInstanceSnapshot = await MainInstance.get();

      if (MainInstanceSnapshot.exists) {
        // first we fetch URL then we change the TICK Colour if URL Already Exists
        var data = MainInstanceSnapshot.data() as Map<String, dynamic>;
        profileStatus = data['Profile Status'];
      }
      if (profileStatus == "Completed") {
        cnic = user_CNIC;
        getUserData();
      } else {
        Get.off(() => SignupNextPage(user: user_CNIC),
            transition: Transition.topLevel,
            duration: const Duration(seconds: 2));
      }

      // pasword storing
    } else {
      setState(() {
        isLoading = false;
      });
      Get.defaultDialog(
        title: "Wrong Credentials Try again!",
        titleStyle: const TextStyle(color: Colors.red),
        content: const Icon(
          Icons.error_outline_outlined,
          color: Colors.red,
          size: 50,
        ),
        textCancel: "Try Again!",
        backgroundColor: Colors.white,
        titlePadding: const EdgeInsets.only(top: 20, right: 30, left: 30),
        cancelTextColor: Colors.red,
        buttonColor: Colors.red,
      );
    }
  }

  Future<void> getUserData() async {
    DocumentReference MainInstance =
        FirebaseFirestore.instance.collection('Users').doc(cnic);

    DocumentSnapshot MainInstanceSnapshot = await MainInstance.get();

    if (MainInstanceSnapshot.exists) {
      // first we fetch URL then we change the TICK Colour if URL Already Exists
      var data = MainInstanceSnapshot.data() as Map<dynamic, dynamic>;

      name = data['Name'];
      father = data['Father Name'];
      phone = data['Phone'];
      address = data['Address'];
    }

    // For Profile Pic URL
    DocumentReference profileUrlInstance =
        MainInstance.collection('user_details').doc('profile_pic');
    DocumentSnapshot snapshotProfileURL = await profileUrlInstance.get();
    if (snapshotProfileURL.exists) {
      var snapData2 = snapshotProfileURL.data() as Map<String, dynamic>;
      profileURL = snapData2['profileURL'];
    }
    // For BankDetails

    // For Nominee Details
    DocumentReference nomineeInstance =
        MainInstance.collection('user_details').doc('nominee_details');
    DocumentSnapshot snapshotNominee = await nomineeInstance.get();
    if (snapshotNominee.exists) {
      var snapData4 = snapshotNominee.data() as Map<String, dynamic>;
      nomineeName = snapData4['Nominee Name'];
      nomineeFather = snapData4['Nominee Father'];
      nomineeCNIC = snapData4['Nominee CNIC'];
      nomineeAddress = snapData4['Nominee Address'];
    }

    var pref1 = await SharedPreferences.getInstance();

    pref1.setString('Name', name);

    pref1.setString('Father', father);
    pref1.setString('CNIC', cnic);

    pref1.setString('Phone', phone);
    pref1.setString('Address', address);

    pref1.setString('ProfileURL', profileURL);

    pref1.setString('NomineeName', nomineeName);
    pref1.setString('NomineeFather', nomineeFather);
    pref1.setString('NomineeCNIC', nomineeCNIC);
    pref1.setString('NomineeAdress', nomineeAddress);

    Get.off(() => MainScreen(user: cnic),
        transition: Transition.topLevel, duration: const Duration(seconds: 2));
  }
}
