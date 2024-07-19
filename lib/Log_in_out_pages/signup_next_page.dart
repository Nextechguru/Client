import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:roshan_dastak_client/Log_in_out_pages/Login_Page.dart';

class SignupNextPage extends StatefulWidget {
  final String user;

  const SignupNextPage({super.key, required this.user});
  @override
  State<StatefulWidget> createState() {
    return _SignupNextPageState();
  }
}

class _SignupNextPageState extends State<SignupNextPage> {
  String profileImageURL = '';

  String CNICfrontURL = '';

  String nomineeCNICfrontURL = '';

  String CNICbackURL = '';

  String nomineeCNICbackURL = '';
  Color tickcolor1 = Colors.grey;
  Color tickcolor2 = Colors.grey;
  Color tickcolor3 = Colors.grey;
  Color tickcolor4 = Colors.grey;
  Color tickcolor5 = Colors.grey;
  Color tickcolor6 = Colors.grey;
  //.................................................
  //User Bank Details TextFormfield Text Controlers
  TextEditingController accountTitle = TextEditingController();
  TextEditingController accountNumber = TextEditingController();
  //nominee Bank Details TextFormfield Text Controlers
  TextEditingController accountTitleNominee = TextEditingController();
  TextEditingController accountNumberNominee = TextEditingController();
  //Nominee TextFormfield Text Controlers
  TextEditingController nomineeName = TextEditingController();
  TextEditingController nomineeFather = TextEditingController();
  TextEditingController nomineePhone = TextEditingController();
  TextEditingController nomineeCNIC = TextEditingController();
  TextEditingController nomineeAdress = TextEditingController();
  //.................................................

  List<String> bankNames = [
    // Traditional Banks
    "State Bank of Pakistan (SBP)",
    "National Bank of Pakistan (NBP)",
    "Allied Bank Limited (ABL)",
    "United Bank Limited (UBL)",
    "Habib Bank Limited (HBL)",
    "MCB Bank Limited (MCB)",
    "Askari Bank Limited",
    "Bank Alfalah",
    "Faysal Bank Limited",
    "Standard Chartered Bank (Pakistan)",
    "Bank of Punjab (BOP)",
    "Sindh Bank",
    "Meezan Bank Limited",
    "JS Bank Limited",
    "Bank Islami Pakistan Limited",
    "Summit Bank",
    "Soneri Bank Limited",
    "First Women Bank Limited",
    "Habib Metropolitan Bank Limited",
    "Al Baraka Bank (Pakistan) Limited",
    "Samba Bank Limited",
    "Dubai Islamic Bank Pakistan Limited",
    "Industrial and Commercial Bank of China (ICBC)",
    "NIB Bank Limited",
    "Pak Oman Investment Company Limited",
    "Bank of Khyber",
    "Silk Bank Limited",
    "Punjab Provincial Cooperative Bank",
    "Zarai Taraqiati Bank Limited (ZTBL)",
    "Khushhali Microfinance Bank",
    "U Microfinance Bank Limited",

    // Digital Wallet Banks
    "Easypaisa",
    "JazzCash",
    "SadaPay",
    "Finja",
    "UPaisa",
    "Keenu Wallet",
    "NayaPay",
    "SimSim Wallet"
  ];

  String selectedValue = 'State Bank of Pakistan (SBP)';
  //.................................................
  // the drop downlist for Nominee Relation
  List<String> nomineeRelation = [
    "Father",
    "Mother",
    "Son",
    "Daughter",
    "Brother",
    "Sister",
    "Grandfather",
    "Grandmother",
    "Grandson",
    "Granddaughter",
    "Uncle (Father's brother)",
    "Uncle (Mother's brother)",
    "Aunt (Father's sister)",
    "Aunt (Mother's sister)",
    "Cousin", // Further clarification needed (maternal/paternal)
    "Niece",
    "Nephew",
    "Friend",
    "Other"
  ];
  String selectedValueNominee = 'Father';
  //.................................................
  // Start initState to get imageurl from Firebase
  @override
  void initState() {
    super.initState();
    fetchProfileImageUser();
  }

  Future<void> fetchProfileImageUser() async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.user)
        .collection('user_details')
        .doc('profile_pic');

    DocumentSnapshot documentSnapshot = await documentReference.get();

    if (documentSnapshot.exists) {
      // first we fetch URL then we change the TICK Colour if URL Already Exists
      var data = documentSnapshot.data() as Map<String, dynamic>;
      setState(() {
        profileImageURL = data['profileURL'];
        if (profileImageURL != '') {
          tickcolor2 = Colors.green;
        }
      });
    }
    // Checking if FrontCNIC Already uploaded then get URL and save in Variable
    DocumentReference cnicFrontRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.user)
        .collection('user_details')
        .doc('CNIC_pic');

    DocumentSnapshot cnicFrontSnapshot = await cnicFrontRef.get();

    if (cnicFrontSnapshot.exists) {
      // first we fetch URL then we change the TICK Colour if URL Already Exists
      var data = cnicFrontSnapshot.data() as Map<String, dynamic>;
      setState(() {
        if (data['CNICfrontURL'] != null) {
          CNICfrontURL = data['CNICfrontURL'];
        }
      });
    }
    // Checking if BackCNIC Already uploaded then get URL and save in Variable
    DocumentReference cnicbackRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.user)
        .collection('user_details')
        .doc('CNIC_pic');

    DocumentSnapshot cnicbackSnapshot = await cnicbackRef.get();

    if (cnicbackSnapshot.exists) {
      // first we fetch URL then we change the TICK Colour if URL Already Exists
      var data = cnicbackSnapshot.data() as Map<String, dynamic>;
      setState(() {
        if (data['CNICbackURL'] != null) {
          CNICbackURL = data['CNICbackURL'];
        }
        if (CNICbackURL != '') {
          tickcolor3 = Colors.green;
        }
      });
    }
    // ---------------------------------------------------------
    // Nominee Record Check Nominee CNIC Show if already have
    DocumentReference nomineecnicFrontRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.user)
        .collection('user_details')
        .doc('nominee_details')
        .collection('nominee_other_details')
        .doc('nominee_CNIC_details');

    DocumentSnapshot nomineeCnicFrontSnapShot = await nomineecnicFrontRef.get();

    if (nomineeCnicFrontSnapShot.exists) {
      // first we fetch URL then we change the TICK Colour if URL Already Exists
      var data = nomineeCnicFrontSnapShot.data() as Map<String, dynamic>;
      setState(() {
        if (data['CNICfrontURL'] != null) {
          nomineeCNICfrontURL = data['CNICfrontURL'];
        }
      });
    }
    // Checking if BackCNIC Already uploaded then get URL and save in Variable
    DocumentReference nomineeCnicbackRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.user)
        .collection('user_details')
        .doc('nominee_details')
        .collection('nominee_other_details')
        .doc('nominee_CNIC_details');

    DocumentSnapshot nomineeCnicbackSnapshot = await nomineeCnicbackRef.get();

    if (nomineeCnicbackSnapshot.exists) {
      // first we fetch URL then we change the TICK Colour if URL Already Exists
      var data = nomineeCnicbackSnapshot.data() as Map<String, dynamic>;
      setState(() {
        if (data['CNICbackURL'] != null) {
          nomineeCNICbackURL = data['CNICbackURL'];
        }
        if (nomineeCNICbackURL != '') {
          tickcolor6 = Colors.green;
        }
      });
    }
    //-------------------------------------------------------

    // Checking if BackCNIC Already uploaded then get URL and save in Variable
    DocumentReference nomineeDetails = FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.user)
        .collection('user_details')
        .doc('nominee_details');

    DocumentSnapshot nomineedetailsSnapshot = await nomineeDetails.get();

    if (nomineedetailsSnapshot.exists) {
      // first we fetch URL then we change the TICK Colour if URL Already Exists
      var data = nomineedetailsSnapshot.data() as Map<String, dynamic>;
      setState(() {
        if (data['Nominee Address'] != null) {
          if (data['Nominee Address'] != '') {
            tickcolor4 = Colors.green;
          }
        }
      });
    }
    //-------------------------------------------------------

    DocumentReference bankRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.user)
        .collection('user_details')
        .doc('bank_details');

    DocumentSnapshot bankNumberSnapshot = await bankRef.get();
    if (bankNumberSnapshot.exists) {
      var data = bankNumberSnapshot.data() as Map<String, dynamic>;
      String isbankAdded = data['Account Number'];
      setState(() {
        if (isbankAdded != '') {
          tickcolor1 = Colors.green;
        }
      });
    }
    //-------------------------------------------------------

    DocumentReference nomineebankRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.user)
        .collection('user_details')
        .doc('nominee_details')
        .collection('nominee_other_details')
        .doc('nominee_bank_details');

    DocumentSnapshot nomineebankNumberSnapshot = await nomineebankRef.get();
    if (nomineebankNumberSnapshot.exists) {
      var data = nomineebankNumberSnapshot.data() as Map<String, dynamic>;
      String isbankAdded = data['Account Number'];
      setState(() {
        if (isbankAdded != '') {
          tickcolor5 = Colors.green;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    List<DropdownMenuItem<String>> dropdownItems = bankNames
        .map((String value) => DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            ))
        .toList();

    return Scaffold(
      body: Container(
        height: double.infinity,
        color: Colors.white10,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 70, right: 30, left: 30),
            child: Column(
              children: [
                const Text(
                  'Complete Profile',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: Colors.green),
                ),
                // 1st List Tile for Bank Details
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: InkWell(
                    onTap: () {
                      showBankDialog(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: ListTile(
                        title: const Text(
                          'Add Bank Account',
                          style: TextStyle(color: Colors.green),
                        ),
                        subtitle: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Add your bank account for funds transfer',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              'Required',
                              style: TextStyle(color: Colors.red, fontSize: 10),
                            )
                          ],
                        ),
                        trailing: Icon(
                          Icons.check_circle_outline_rounded,
                          color: tickcolor1,
                        ),
                      ),
                    ),
                  ),
                ),
                //2nd List tile for Profile Pic
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: InkWell(
                    onTap: () {
                      showPhotoDialog();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: ListTile(
                        title: const Text(
                          'Profile Photo',
                          style: TextStyle(color: Colors.green),
                        ),
                        subtitle: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Add your profile photo for clear identity',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              'Required',
                              style: TextStyle(color: Colors.red, fontSize: 10),
                            )
                          ],
                        ),
                        trailing: Icon(
                          Icons.check_circle_outline_rounded,
                          color: tickcolor2,
                        ),
                      ),
                    ),
                  ),
                ),
                //3rd List tile for CNIC Front BACK photo
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: InkWell(
                    onTap: () {
                      showCNICdialog();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: ListTile(
                        title: const Text(
                          'Add CNIC',
                          style: TextStyle(color: Colors.green),
                        ),
                        subtitle: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Add Your CNIC Photo for Varification',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              'Required',
                              style: TextStyle(color: Colors.red, fontSize: 10),
                            )
                          ],
                        ),
                        trailing: Icon(
                          Icons.check_circle_outline_rounded,
                          color: tickcolor3,
                        ),
                      ),
                    ),
                  ),
                ),
                // 4th List tile for Nominee Details
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: InkWell(
                    onTap: () {
                      showNomineeDetails(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: ListTile(
                        title: const Text(
                          'Add Nominee',
                          style: TextStyle(color: Colors.green),
                        ),
                        subtitle: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Effortlessly nominee deserving individuals',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              'Required',
                              style: TextStyle(color: Colors.red, fontSize: 10),
                            )
                          ],
                        ),
                        trailing: Icon(
                          Icons.check_circle_outline_rounded,
                          color: tickcolor4,
                        ),
                      ),
                    ),
                  ),
                ),
                // 5th List tile  for Nominee Bank Account
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: InkWell(
                    onTap: () {
                      showNomineeBankDialog(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: ListTile(
                        title: const Text(
                          'Nominee Bank Account',
                          style: TextStyle(color: Colors.green),
                        ),
                        subtitle: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Add you nominee bank account for funds claim',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              'Required',
                              style: TextStyle(color: Colors.red, fontSize: 10),
                            )
                          ],
                        ),
                        trailing: Icon(
                          Icons.check_circle_outline_rounded,
                          color: tickcolor5,
                        ),
                      ),
                    ),
                  ),
                ),
                // 6th List tile for Nominee CNIC
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: InkWell(
                    onTap: () {
                      showNomineeCNICdialog();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: ListTile(
                        title: const Text(
                          'Add Nominee CNIC',
                          style: TextStyle(color: Colors.green),
                        ),
                        subtitle: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Upload both side photo of your nominee CNIC',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              'Required',
                              style: TextStyle(color: Colors.red, fontSize: 10),
                            )
                          ],
                        ),
                        trailing: Icon(
                          Icons.check_circle_outline_rounded,
                          color: tickcolor6,
                        ),
                      ),
                    ),
                  ),
                ),
                // Submit Final Button
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                      onPressed: () async {
                        if (tickcolor1 == Colors.green &&
                            tickcolor2 == Colors.green &&
                            tickcolor3 == Colors.green &&
                            tickcolor4 == Colors.green &&
                            tickcolor5 == Colors.green &&
                            tickcolor6 == Colors.green) {
                          final mainInstance = FirebaseFirestore.instance
                              .collection('Users')
                              .doc(widget.user);
                          await mainInstance.set(
                              {'Profile Status': 'Completed'},
                              SetOptions(merge: true));
                          Get.off(() => const LoginPage(),
                              transition: Transition.circularReveal,
                              duration: const Duration(seconds: 2));
                        }
                      },
                      child: const Text('Complete Profile')),
                ),
                // Go Back to LoginPage
                Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      },
                      child: const Text(
                        'Back to Login Page',
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showBankDialog(BuildContext context) {
    String dialogSelectedValue = selectedValue;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: AlertDialog(
                title: const Text('Add Bank Account!'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                        'Add your bank account details for funds transfer and other services'),
                    const SizedBox(height: 10),
                    const Text(
                      'Select Bank',
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: dialogSelectedValue,
                            icon: const Icon(Icons.arrow_drop_down),
                            items: bankNames.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                dialogSelectedValue = newValue!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: accountTitle,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        label: const Text("Account Title"),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 1)),
                        hintText: 'Your Bank Account Title',
                      ),
                      onChanged: (text) => setState(() {
                        // Update state to trigger rebuild
                      }),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: accountNumber,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        label: const Text("IBAN Number"),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 1)),
                        hintText: 'PK24UNL0123XXXXXXXXXXX',
                      ),
                      onChanged: (text) => setState(() {
                        // Update state to trigger rebuild
                      }),
                    ),
                  ],
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: const Text('Cancel')),
                      TextButton(
                        onPressed: () async {
                          String bankN = dialogSelectedValue;
                          String accountT = accountTitle.text;
                          String accountN = accountNumber.text;
                          final Maininstance = FirebaseFirestore.instance
                              .collection('Users')
                              .doc(widget.user)
                              .collection("user_details")
                              .doc('bank_details');
                          await Maininstance.set({
                            'Bank Name': bankN,
                            'Account Tittle': accountT,
                            'Account Number': accountN,
                          });
                          setState(() {
                            tickcolor1 = Colors.green;
                          });

                          Navigator.pop(context, true);
                        },
                        child: const Text('Upload'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((shouldUpdate) {
      if (shouldUpdate == true) {
        setState(() {});
      }
    });
  }

  void showPhotoDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add your Profile Photo'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Flexible(
                    child: Text(
                      'Upload Your Profile Photo For Clear Identification',
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(profileImageURL),
                        radius: 70,
                      ),
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Row(
                      children: [
                        Flexible(
                          child: ElevatedButton(
                            onPressed: () async {
                              XFile? file = await ImagePicker().pickImage(
                                source: ImageSource.camera,
                              );

                              if (file != null) {
                                final ImageCropper imageCropper =
                                    ImageCropper();
                                CroppedFile? croppedFile =
                                    await imageCropper.cropImage(
                                  sourcePath: file.path,
                                  aspectRatioPresets: [
                                    CropAspectRatioPreset.square,
                                  ],
                                );

                                if (croppedFile != null) {
                                  // Proceed with uploading the cropped image
                                  Reference referenceRoot =
                                      FirebaseStorage.instance.ref();
                                  Reference referenceImageDir =
                                      referenceRoot.child('Profile Images');
                                  Reference refToUploadimage = referenceImageDir
                                      .child('${widget.user}' "ProfilePic");
                                  try {
                                    File croppedFileConverted =
                                        File(croppedFile.path);
                                    await refToUploadimage
                                        .putFile(croppedFileConverted);
                                    String newProfileImageURL =
                                        await refToUploadimage.getDownloadURL();

                                    final mainInstance = FirebaseFirestore
                                        .instance
                                        .collection('Users')
                                        .doc(widget.user)
                                        .collection('user_details')
                                        .doc('profile_pic');
                                    await mainInstance.set({
                                      'profileURL': newProfileImageURL,
                                      'profileimageUser': widget.user
                                    });
                                    setState(() {
                                      profileImageURL = newProfileImageURL;
                                    });
                                  } catch (error) {
                                    print('Error while uploading');
                                  }
                                }
                              }
                            },
                            child: const Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: FittedBox(
                                    child: Icon(Icons.camera),
                                  ),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: FittedBox(
                                    child: Text(' Camera'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: ElevatedButton(
                            onPressed: () async {
                              XFile? file = await ImagePicker().pickImage(
                                source: ImageSource.gallery,
                              );

                              if (file != null) {
                                final ImageCropper imageCropper =
                                    ImageCropper();
                                CroppedFile? croppedFile =
                                    await imageCropper.cropImage(
                                  sourcePath: file.path,
                                  aspectRatioPresets: [
                                    CropAspectRatioPreset.square,
                                  ],
                                );

                                if (croppedFile != null) {
                                  // Proceed with uploading the cropped image
                                  Reference referenceRoot =
                                      FirebaseStorage.instance.ref();
                                  Reference referenceImageDir =
                                      referenceRoot.child('Profile Images');
                                  Reference refToUploadimage = referenceImageDir
                                      .child('${widget.user}' "ProfilePic");
                                  try {
                                    File croppedFileConverted =
                                        File(croppedFile.path);
                                    await refToUploadimage
                                        .putFile(croppedFileConverted);
                                    String newProfileImageURL =
                                        await refToUploadimage.getDownloadURL();

                                    final mainInstance = FirebaseFirestore
                                        .instance
                                        .collection('Users')
                                        .doc(widget.user)
                                        .collection('user_details')
                                        .doc('profile_pic');
                                    await mainInstance.set({
                                      'profileURL': newProfileImageURL,
                                      'profileimageUser': widget.user
                                    });
                                    setState(() {
                                      profileImageURL = newProfileImageURL;
                                    });
                                  } catch (error) {
                                    print('Error while uploading');
                                  }
                                }
                              }
                            },
                            child: const Row(
                              children: [
                                Flexible(
                                    flex: 1,
                                    child: FittedBox(
                                        child: Icon(Icons.perm_media))),
                                Flexible(
                                    flex: 2,
                                    child: FittedBox(child: Text(' Gallery'))),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          if (profileImageURL != '') {
                            setState(() {
                              tickcolor2 = Colors.green;
                            });
                            Navigator.pop(context, true);
                          }
                        },
                        child: const Text(
                          'Upload',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    ).then((shouldUpdate) {
      if (shouldUpdate == true) {
        setState(() {});
      }
    });
  }

  void showCNICdialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add your CNIC Photo'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Flexible(
                    fit: FlexFit.loose,
                    child: Text(
                      '01) Front Side of CNIC\n',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: SizedBox(
                          child: CNICfrontURL != ''
                              ? Image.network(CNICfrontURL)
                              : const Placeholder(
                                  // Or your custom placeholder widget
                                  child: Text('Please Select Photo...'),
                                ),
                        )),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Row(
                      children: [
                        Flexible(
                          child: ElevatedButton(
                            onPressed: () async {
                              XFile? file = await ImagePicker().pickImage(
                                source: ImageSource.camera,
                              );

                              if (file != null) {
                                final ImageCropper imageCropper =
                                    ImageCropper();
                                CroppedFile? croppedFile =
                                    await imageCropper.cropImage(
                                  sourcePath: file.path,
                                  aspectRatioPresets: [
                                    CropAspectRatioPreset.ratio3x2,
                                  ],
                                );

                                if (croppedFile != null) {
                                  // Proceed with uploading the cropped image
                                  Reference referenceRoot =
                                      FirebaseStorage.instance.ref();
                                  Reference referenceImageDir =
                                      referenceRoot.child('CNIC Images');
                                  Reference refToUploadimage = referenceImageDir
                                      .child('${widget.user}' "CNICfront");
                                  try {
                                    File croppedFileConverted =
                                        File(croppedFile.path);
                                    await refToUploadimage
                                        .putFile(croppedFileConverted);
                                    String newImageURL =
                                        await refToUploadimage.getDownloadURL();

                                    final mainInstance1 = FirebaseFirestore
                                        .instance
                                        .collection('Users')
                                        .doc(widget.user)
                                        .collection('user_details')
                                        .doc('CNIC_pic');
                                    await mainInstance1.set({
                                      'CNICfrontURL': newImageURL,
                                      'User': widget.user
                                    }, SetOptions(merge: true));
                                    setState(() {
                                      CNICfrontURL = newImageURL;
                                    });
                                  } catch (error) {
                                    print('Error while uploading');
                                  }
                                }
                              }
                            },
                            child: const Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: FittedBox(
                                    child: Icon(Icons.camera),
                                  ),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: FittedBox(
                                    child: Text(' Camera'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: ElevatedButton(
                            onPressed: () async {
                              XFile? file = await ImagePicker().pickImage(
                                source: ImageSource.gallery,
                              );

                              if (file != null) {
                                final ImageCropper imageCropper =
                                    ImageCropper();
                                CroppedFile? croppedFile =
                                    await imageCropper.cropImage(
                                  sourcePath: file.path,
                                  aspectRatioPresets: [
                                    CropAspectRatioPreset.ratio3x2,
                                  ],
                                );

                                if (croppedFile != null) {
                                  // Proceed with uploading the cropped image
                                  Reference referenceRoot =
                                      FirebaseStorage.instance.ref();
                                  Reference referenceImageDir =
                                      referenceRoot.child('CNIC Images');
                                  Reference refToUploadimage = referenceImageDir
                                      .child('${widget.user}' "CNICfront");
                                  try {
                                    File croppedFileConverted =
                                        File(croppedFile.path);
                                    await refToUploadimage
                                        .putFile(croppedFileConverted);
                                    String newImageURL =
                                        await refToUploadimage.getDownloadURL();

                                    final mainInstance1 = FirebaseFirestore
                                        .instance
                                        .collection('Users')
                                        .doc(widget.user)
                                        .collection('user_details')
                                        .doc('CNIC_pic');
                                    await mainInstance1.set({
                                      'CNICfrontURL': newImageURL,
                                      'User': widget.user
                                    }, SetOptions(merge: true));
                                    setState(() {
                                      CNICfrontURL = newImageURL;
                                    });
                                  } catch (error) {
                                    print('Error while uploading');
                                  }
                                }
                              }
                            },
                            child: const Row(
                              children: [
                                Flexible(
                                    flex: 1,
                                    child: FittedBox(
                                        child: Icon(Icons.perm_media))),
                                Flexible(
                                    flex: 2,
                                    child: FittedBox(child: Text(' Gallery'))),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const Flexible(
                    fit: FlexFit.loose,
                    child: Text(
                      ' \n \n 02) Back Side of CNIC \n',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: SizedBox(
                          height: 200,
                          child:
                              //Image.network(CNICbackURL),
                              CNICbackURL != ''
                                  ? Image.network(CNICbackURL)
                                  : const Placeholder(
                                      // Or your custom placeholder widget
                                      child: Text('Please Select a Photo...'),
                                    ),
                        )),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Row(
                      children: [
                        Flexible(
                          child: ElevatedButton(
                            onPressed: () async {
                              XFile? file = await ImagePicker().pickImage(
                                source: ImageSource.camera,
                              );

                              if (file != null) {
                                final ImageCropper imageCropper =
                                    ImageCropper();
                                CroppedFile? croppedFile =
                                    await imageCropper.cropImage(
                                  sourcePath: file.path,
                                  aspectRatioPresets: [
                                    CropAspectRatioPreset.ratio3x2,
                                  ],
                                );

                                if (croppedFile != null) {
                                  // Proceed with uploading the cropped image
                                  Reference referenceRoot =
                                      FirebaseStorage.instance.ref();
                                  Reference referenceImageDir =
                                      referenceRoot.child('CNIC Images');
                                  Reference refToUploadimage = referenceImageDir
                                      .child('${widget.user}' "CNICbackURL");
                                  try {
                                    File croppedFileConverted =
                                        File(croppedFile.path);
                                    await refToUploadimage
                                        .putFile(croppedFileConverted);
                                    String newImageURL =
                                        await refToUploadimage.getDownloadURL();

                                    final mainInstance = FirebaseFirestore
                                        .instance
                                        .collection('Users')
                                        .doc(widget.user)
                                        .collection('user_details')
                                        .doc('CNIC_pic');
                                    await mainInstance.set({
                                      'CNICbackURL': newImageURL,
                                    }, SetOptions(merge: true));
                                    setState(() {
                                      CNICbackURL = newImageURL;
                                    });
                                  } catch (error) {
                                    print('Error while uploading');
                                  }
                                }
                              }
                            },
                            child: const Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: FittedBox(
                                    child: Icon(Icons.camera),
                                  ),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: FittedBox(
                                    child: Text(' Camera'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: ElevatedButton(
                            onPressed: () async {
                              XFile? file = await ImagePicker().pickImage(
                                source: ImageSource.gallery,
                              );

                              if (file != null) {
                                final ImageCropper imageCropper =
                                    ImageCropper();
                                CroppedFile? croppedFile =
                                    await imageCropper.cropImage(
                                  sourcePath: file.path,
                                  aspectRatioPresets: [
                                    CropAspectRatioPreset.ratio3x2,
                                  ],
                                );

                                if (croppedFile != null) {
                                  // Proceed with uploading the cropped image
                                  Reference referenceRoot =
                                      FirebaseStorage.instance.ref();
                                  Reference referenceImageDir =
                                      referenceRoot.child('CNIC Images');
                                  Reference refToUploadimage = referenceImageDir
                                      .child('${widget.user}' "CNICback");
                                  try {
                                    File croppedFileConverted =
                                        File(croppedFile.path);
                                    await refToUploadimage
                                        .putFile(croppedFileConverted);
                                    String newImageURL =
                                        await refToUploadimage.getDownloadURL();

                                    final mainInstance = FirebaseFirestore
                                        .instance
                                        .collection('Users')
                                        .doc(widget.user)
                                        .collection('user_details')
                                        .doc('CNIC_pic');
                                    await mainInstance.set({
                                      'CNICbackURL': newImageURL,
                                    }, SetOptions(merge: true));
                                    setState(() {
                                      CNICbackURL = newImageURL;
                                    });
                                  } catch (error) {
                                    print('Error while uploading');
                                  }
                                }
                              }
                            },
                            child: const Row(
                              children: [
                                Flexible(
                                    flex: 1,
                                    child: FittedBox(
                                        child: Icon(Icons.perm_media))),
                                Flexible(
                                    flex: 2,
                                    child: FittedBox(child: Text(' Gallery'))),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          setState(() {});
                          Navigator.pop(context, true);
                        },
                        child: const Text(
                          'Close',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          if (CNICfrontURL != '' && CNICbackURL != '') {
                            setState(() {
                              tickcolor3 = Colors.green;
                            });
                            Navigator.pop(context, true);
                          }
                        },
                        child: const Text(
                          'Uploaded',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    ).then((shouldUpdate) {
      if (shouldUpdate == true) {
        setState(() {});
      }
    });
  }

  void showNomineeDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: AlertDialog(
                title: const Text('Add You Nominee'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                        'Please Provide the following details of your nominee for your secure future'),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text(
                          'Nominee is your',
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                        Expanded(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: selectedValueNominee,
                            icon: const Icon(Icons.arrow_drop_down),
                            items: nomineeRelation.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedValueNominee = newValue!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: nomineeName,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        label: const Text("Full Name"),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 1)),
                        hintText: 'Enter Nominee Full Name',
                      ),
                      onChanged: (text) => setState(() {
                        // Update state to trigger rebuild
                      }),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: nomineeFather,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        label: const Text("Father Name"),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 1)),
                        hintText: 'Enter Nominee Full Name',
                      ),
                      onChanged: (text) => setState(() {
                        // Update state to trigger rebuild
                      }),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: nomineePhone,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        label: const Text("Mobile Number"),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 1)),
                        hintText: '030012XXXXXX',
                      ),
                      onChanged: (text) => setState(() {
                        // Update state to trigger rebuild
                      }),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: nomineeCNIC,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        label: const Text("CNIC"),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 1)),
                        hintText: '38403XXXXXXXX',
                      ),
                      onChanged: (text) => setState(() {
                        // Update state to trigger rebuild
                      }),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      maxLines: null,
                      minLines: 2,
                      controller: nomineeAdress,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        label: const Text("Postal Adress"),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 1)),
                        hintText: 'Nominee Postal Adress',
                      ),
                      onChanged: (text) => setState(() {
                        // Update state to trigger rebuild
                      }),
                    ),
                  ],
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: const Text('Cancel')),
                      TextButton(
                        onPressed: () async {
                          String Relation = selectedValueNominee;
                          String name = nomineeName.text;
                          String father = nomineeFather.text;
                          String mobile = nomineePhone.text;
                          String cnic = nomineeCNIC.text;
                          String adress = nomineeAdress.text;
                          final Maininstance = FirebaseFirestore.instance
                              .collection('Users')
                              .doc(widget.user)
                              .collection("user_details")
                              .doc('nominee_details');
                          await Maininstance.set({
                            'Nominee Relation': Relation,
                            'Nominee Name': name,
                            'Nominee Father': father,
                            'Nominee Mobile': mobile,
                            'Nominee CNIC': cnic,
                            'Nominee Address': adress,
                          });
                          setState(() {
                            tickcolor4 = Colors.green;
                          });

                          Navigator.pop(context, true);
                        },
                        child: const Text('Upload'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((shouldUpdate) {
      if (shouldUpdate == true) {
        setState(() {});
      }
    });
  }

  void showNomineeBankDialog(BuildContext context) {
    String dialogSelectedValue = selectedValue;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: AlertDialog(
                title: const Text('Add Nominee Bank Account!'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Add your bank account details for funds claim'),
                    const SizedBox(height: 10),
                    const Text(
                      'Select Bank',
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: dialogSelectedValue,
                            icon: const Icon(Icons.arrow_drop_down),
                            items: bankNames.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                dialogSelectedValue = newValue!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: accountTitleNominee,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        label: const Text("Account Title"),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 1)),
                        hintText: 'Your Bank Account Title',
                      ),
                      onChanged: (text) => setState(() {
                        // Update state to trigger rebuild
                      }),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: accountNumberNominee,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        label: const Text("IBAN Number"),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 1)),
                        hintText: 'PK24UNL0123XXXXXXXXXXX',
                      ),
                      onChanged: (text) => setState(() {
                        // Update state to trigger rebuild
                      }),
                    ),
                  ],
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: const Text('Cancel')),
                      TextButton(
                        onPressed: () async {
                          String bankN = dialogSelectedValue;
                          String accountT = accountTitleNominee.text;
                          String accountN = accountNumberNominee.text;
                          final Maininstance = FirebaseFirestore.instance
                              .collection('Users')
                              .doc(widget.user)
                              .collection("user_details")
                              .doc('nominee_details')
                              .collection('nominee_other_details')
                              .doc('nominee_bank_details')
                              .collection('details');

                          await Maininstance.add({
                            'Bank Name': bankN,
                            'Account Title': accountT,
                            'Account Number': accountN,
                          });
                          setState(() {
                            tickcolor5 = Colors.green;
                          });

                          Navigator.pop(context, true);
                        },
                        child: const Text('Upload'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((shouldUpdate) {
      if (shouldUpdate == true) {
        setState(() {});
      }
    });
  }

  void showNomineeCNICdialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add your CNIC Photo'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Flexible(
                    fit: FlexFit.loose,
                    child: Text(
                      '01) Front Side of CNIC\n',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: SizedBox(
                          child: nomineeCNICfrontURL != ''
                              ? Image.network(nomineeCNICfrontURL)
                              : const Placeholder(
                                  // Or your custom placeholder widget
                                  child: Text('Please Select Photo...'),
                                ),
                        )),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Row(
                      children: [
                        Flexible(
                          child: ElevatedButton(
                            onPressed: () async {
                              XFile? file = await ImagePicker().pickImage(
                                source: ImageSource.camera,
                              );

                              if (file != null) {
                                final ImageCropper imageCropper =
                                    ImageCropper();
                                CroppedFile? croppedFile =
                                    await imageCropper.cropImage(
                                  sourcePath: file.path,
                                  aspectRatioPresets: [
                                    CropAspectRatioPreset.ratio3x2,
                                  ],
                                );

                                if (croppedFile != null) {
                                  // Proceed with uploading the cropped image
                                  Reference referenceRoot =
                                      FirebaseStorage.instance.ref();
                                  Reference referenceImageDir = referenceRoot
                                      .child('Nominee CNIC Images');
                                  Reference refToUploadimage =
                                      referenceImageDir.child(
                                          '${widget.user}' "nomineeCNICfront");
                                  try {
                                    File croppedFileConverted =
                                        File(croppedFile.path);
                                    await refToUploadimage
                                        .putFile(croppedFileConverted);
                                    String newImageURL =
                                        await refToUploadimage.getDownloadURL();

                                    final mainInstance1 = FirebaseFirestore
                                        .instance
                                        .collection('Users')
                                        .doc(widget.user)
                                        .collection('user_details')
                                        .doc('nominee_details')
                                        .collection('nominee_other_details')
                                        .doc('nominee_CNIC_details');
                                    await mainInstance1.set({
                                      'CNICfrontURL': newImageURL,
                                      'User': widget.user
                                    }, SetOptions(merge: true));
                                    setState(() {
                                      nomineeCNICfrontURL = newImageURL;
                                    });
                                  } catch (error) {
                                    print('Error while uploading');
                                  }
                                }
                              }
                            },
                            child: const Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: FittedBox(
                                    child: Icon(Icons.camera),
                                  ),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: FittedBox(
                                    child: Text(' Camera'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: ElevatedButton(
                            onPressed: () async {
                              XFile? file = await ImagePicker().pickImage(
                                source: ImageSource.gallery,
                              );

                              if (file != null) {
                                final ImageCropper imageCropper =
                                    ImageCropper();
                                CroppedFile? croppedFile =
                                    await imageCropper.cropImage(
                                  sourcePath: file.path,
                                  aspectRatioPresets: [
                                    CropAspectRatioPreset.ratio3x2,
                                  ],
                                );

                                if (croppedFile != null) {
                                  // Proceed with uploading the cropped image
                                  Reference referenceRoot =
                                      FirebaseStorage.instance.ref();
                                  Reference referenceImageDir = referenceRoot
                                      .child('Nominee CNIC Images');
                                  Reference refToUploadimage =
                                      referenceImageDir.child(
                                          '${widget.user}' "nomineeCNICfront");
                                  try {
                                    File croppedFileConverted =
                                        File(croppedFile.path);
                                    await refToUploadimage
                                        .putFile(croppedFileConverted);
                                    String newImageURL =
                                        await refToUploadimage.getDownloadURL();

                                    final mainInstance1 = FirebaseFirestore
                                        .instance
                                        .collection('Users')
                                        .doc(widget.user)
                                        .collection('user_details')
                                        .doc('nominee_details')
                                        .collection('nominee_other_details')
                                        .doc('nominee_CNIC_details');
                                    await mainInstance1.set({
                                      'CNICfrontURL': newImageURL,
                                      'User': widget.user
                                    }, SetOptions(merge: true));
                                    setState(() {
                                      nomineeCNICfrontURL = newImageURL;
                                    });
                                  } catch (error) {
                                    print('Error while uploading');
                                  }
                                }
                              }
                            },
                            child: const Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: FittedBox(
                                    child: Icon(Icons.camera),
                                  ),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: FittedBox(
                                    child: Text(' Camera'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Flexible(
                    fit: FlexFit.loose,
                    child: Text(
                      ' \n \n 02) Back Side of CNIC \n',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: SizedBox(
                          height: 200,
                          child:
                              //Image.network(CNICbackURL),
                              nomineeCNICbackURL != ''
                                  ? Image.network(nomineeCNICbackURL)
                                  : const Placeholder(
                                      // Or your custom placeholder widget
                                      child: Text('Please Select a Photo...'),
                                    ),
                        )),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Row(
                      children: [
                        Flexible(
                          child: ElevatedButton(
                            onPressed: () async {
                              XFile? file = await ImagePicker().pickImage(
                                source: ImageSource.camera,
                              );

                              if (file != null) {
                                final ImageCropper imageCropper =
                                    ImageCropper();
                                CroppedFile? croppedFile =
                                    await imageCropper.cropImage(
                                  sourcePath: file.path,
                                  aspectRatioPresets: [
                                    CropAspectRatioPreset.ratio3x2,
                                  ],
                                );

                                if (croppedFile != null) {
                                  // Proceed with uploading the cropped image
                                  Reference referenceRoot =
                                      FirebaseStorage.instance.ref();
                                  Reference referenceImageDir = referenceRoot
                                      .child('Nominee CNIC Images');
                                  Reference refToUploadimage =
                                      referenceImageDir.child('${widget.user}'
                                          "nomineeCNICbackURL");
                                  try {
                                    File croppedFileConverted =
                                        File(croppedFile.path);
                                    await refToUploadimage
                                        .putFile(croppedFileConverted);
                                    String newImageURL =
                                        await refToUploadimage.getDownloadURL();

                                    final mainInstance = FirebaseFirestore
                                        .instance
                                        .collection('Users')
                                        .doc(widget.user)
                                        .collection('user_details')
                                        .doc('nominee_details')
                                        .collection('nominee_other_details')
                                        .doc('nominee_CNIC_details');
                                    await mainInstance.set({
                                      'CNICbackURL': newImageURL,
                                    }, SetOptions(merge: true));
                                    setState(() {
                                      nomineeCNICbackURL = newImageURL;
                                    });
                                  } catch (error) {
                                    print('Error while uploading');
                                  }
                                }
                              }
                            },
                            child: const Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: FittedBox(
                                    child: Icon(Icons.camera),
                                  ),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: FittedBox(
                                    child: Text(' Camera'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: ElevatedButton(
                            onPressed: () async {
                              XFile? file = await ImagePicker().pickImage(
                                source: ImageSource.gallery,
                              );

                              if (file != null) {
                                final ImageCropper imageCropper =
                                    ImageCropper();
                                CroppedFile? croppedFile =
                                    await imageCropper.cropImage(
                                  sourcePath: file.path,
                                  aspectRatioPresets: [
                                    CropAspectRatioPreset.ratio3x2,
                                  ],
                                );

                                if (croppedFile != null) {
                                  // Proceed with uploading the cropped image
                                  Reference referenceRoot =
                                      FirebaseStorage.instance.ref();
                                  Reference referenceImageDir = referenceRoot
                                      .child('Nominee CNIC Images');
                                  Reference refToUploadimage =
                                      referenceImageDir.child('${widget.user}'
                                          "nomineeCNICbackURL");
                                  try {
                                    File croppedFileConverted =
                                        File(croppedFile.path);
                                    await refToUploadimage
                                        .putFile(croppedFileConverted);
                                    String newImageURL =
                                        await refToUploadimage.getDownloadURL();

                                    final mainInstance = FirebaseFirestore
                                        .instance
                                        .collection('Users')
                                        .doc(widget.user)
                                        .collection('user_details')
                                        .doc('nominee_details')
                                        .collection('nominee_other_details')
                                        .doc('nominee_CNIC_details');
                                    await mainInstance.set({
                                      'CNICbackURL': newImageURL,
                                    }, SetOptions(merge: true));
                                    setState(() {
                                      nomineeCNICbackURL = newImageURL;
                                    });
                                  } catch (error) {
                                    print('Error while uploading');
                                  }
                                }
                              }
                            },
                            child: const Row(
                              children: [
                                Flexible(
                                    flex: 1,
                                    child: FittedBox(
                                        child: Icon(Icons.perm_media))),
                                Flexible(
                                    flex: 2,
                                    child: FittedBox(child: Text(' Gallery'))),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          setState(() {});
                          Navigator.pop(context, true);
                        },
                        child: const Text(
                          'Close',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          if (nomineeCNICfrontURL != '' &&
                              nomineeCNICbackURL != '') {
                            setState(() {});
                            Navigator.pop(context, true);
                            tickcolor6 = Colors.green;
                          }
                        },
                        child: const Text(
                          'Uploaded',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    ).then((shouldUpdate) {
      if (shouldUpdate == true) {
        setState(() {});
      }
    });
  }
}
