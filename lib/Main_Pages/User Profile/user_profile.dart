// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roshan_dastak_client/Log_in_out_pages/Login_Page.dart';
import 'package:roshan_dastak_client/Main_Pages/User%20Profile/nomiee_edit.dart';
import 'package:roshan_dastak_client/Main_Pages/User%20Profile/user_bankpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  final String user;
  const Profile({super.key, required this.user});
  @override
  State<StatefulWidget> createState() {
    return _Profile();
  }
}

class _Profile extends State<Profile> {
  var name;
  var father;
  var cnic;
  var phone;
  var address;
  var bankName;
  var bankTitle;
  var bankNumber;
  var nomineeName;
  var nomineeFather;
  var nomineeCNIC;
  var nomineeAddress;
  var profileURL;
  
  @override
  void initState() {
    super.initState();
    getDataSharePref();
    setState(() {});
  }

  Future<void> getDataSharePref() async {
    var pref1 = await SharedPreferences.getInstance();

    name = pref1.getString(
      'Name',
    );
    father = pref1.getString('Father');
    phone = pref1.getString(
      'Phone',
    );
    address = pref1.getString(
      'Address',
    );

    bankName = pref1.getString(
      'BankName',
    );
    bankTitle = pref1.getString(
      'BankTitle',
    );
    bankNumber = pref1.getString(
      'BankNumber',
    );
    nomineeName = pref1.getString(
      'NomineeName',
    );

    nomineeFather = pref1.getString(
      'NomineeFather',
    );
    nomineeCNIC = pref1.getString(
      'NomineeCNIC',
    );
    nomineeAddress = pref1.getString(
      'NomineeAdress',
    );
    var profileURL2 = pref1.getString(
      'ProfileURL',
    );
    profileURL = profileURL2;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Row(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center the Row contents
            children: [
              Icon(
                Icons.home,
                color: Colors.white,
              ),
              SizedBox(
                  width:
                      10.0), // Add some spacing between icon and title (optional)
              Text(
                'Profit Details',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          automaticallyImplyLeading: false,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(40.0),
                bottomLeft:
                    Radius.circular(40.0)), // Rounded bottom left corner
          ),
          backgroundColor: Colors.green),
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(right: 25, left: 25),
          child: Column(
            children: [
              const SizedBox(height: 100),
              CircleAvatar(
                radius: 70,
                backgroundImage: profileURL == null
                    ? const AssetImage('assets/images/placeholder.png')
                    : NetworkImage(profileURL),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(0, 5),
                          color: Colors.green.withOpacity(.1),
                          spreadRadius: 2,
                          blurRadius: 10)
                    ]),
                child: ListTile(
                  title: Text(name ?? ''),
                  subtitle: Row(
                    children: [
                      const Text('S/D/W/O:'),
                      Text(father ?? ''),
                    ],
                  ),
                  leading: const Icon(CupertinoIcons.person),
                  trailing:
                      Icon(Icons.arrow_forward, color: Colors.grey.shade400),
                  tileColor: Colors.white,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(0, 5),
                          color: Colors.green.withOpacity(.1),
                          spreadRadius: 2,
                          blurRadius: 10)
                    ]),
                child: ListTile(
                  title: const Text('CNIC:'),
                  subtitle: Text(widget.user),
                  leading: const Icon(CupertinoIcons.creditcard_fill),
                  trailing:
                      Icon(Icons.arrow_forward, color: Colors.grey.shade400),
                  tileColor: Colors.white,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(0, 5),
                          color: Colors.green.withOpacity(.1),
                          spreadRadius: 2,
                          blurRadius: 10)
                    ]),
                child: ListTile(
                  title: const Text('Phone No.'),
                  subtitle: Text(phone ?? ''),
                  leading: const Icon(CupertinoIcons.phone),
                  trailing:
                      Icon(Icons.arrow_forward, color: Colors.grey.shade400),
                  tileColor: Colors.white,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(0, 5),
                          color: Colors.green.withOpacity(.1),
                          spreadRadius: 2,
                          blurRadius: 10)
                    ]),
                child: ListTile(
                  title: const Text('Address'),
                  subtitle: Text(address ?? 'Loading'),
                  leading: const Icon(CupertinoIcons.location),
                  trailing:
                      Icon(Icons.arrow_forward, color: Colors.grey.shade400),
                  tileColor: Colors.white,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(0, 5),
                          color: Colors.green.withOpacity(.1),
                          spreadRadius: 2,
                          blurRadius: 10)
                    ]),
                child: ListTile(
                  title: const Text('Bank Details'),
                  subtitle:
                      const Text('Investor Can edit or add bank accounts.'),
                  leading: const Icon(CupertinoIcons.archivebox),
                  trailing:
                      Icon(Icons.arrow_forward, color: Colors.grey.shade400),
                  tileColor: Colors.white,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BankPage(
                                  user: widget.user,
                                )));
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(0, 5),
                          color: Colors.green.withOpacity(.1),
                          spreadRadius: 2,
                          blurRadius: 10)
                    ]),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NomineeEdit(
                                  user: widget.user,
                                )));
                  },
                  child: ListTile(
                    title: const Text('Nominee: '),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nomineeName ?? '',
                          style: const TextStyle(fontSize: 20),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'S/D/O:     ',
                              overflow: TextOverflow.ellipsis,
                            ),
                            Flexible(
                                fit: FlexFit.tight,
                                child: Text(nomineeFather ?? '')),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('CNIC:       '),
                            Flexible(
                                fit: FlexFit.tight,
                                child: Text(nomineeCNIC ?? '')),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Address:  '),
                            Flexible(
                                fit: FlexFit.loose,
                                child: Text(nomineeAddress ?? "")),
                          ],
                        )
                      ],
                    ),
                    trailing:
                        Icon(Icons.arrow_forward, color: Colors.grey.shade400),
                    tileColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                // width: double.infinity,
                child: ElevatedButton.icon(
                    onPressed: () async {
                      FirebaseAuth.instance.signOut();
                      var pref1 = await SharedPreferences.getInstance();
                      pref1.setString('CNIC', 'LOG OUT');
                      Navigator.pushReplacement(
                          // ignore: use_build_context_synchronously
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                    ),
                    icon: const Icon(Icons.logout),
                    label: const Text('Log Out')),
              ),
              const SizedBox(
                height: 150,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
