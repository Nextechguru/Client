import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:roshan_dastak_client/Log_in_out_pages/Login_Page.dart';
import 'package:roshan_dastak_client/Log_in_out_pages/signup_next_page.dart';
import 'package:roshan_dastak_client/services_pages/firebase_auth_services.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SignUpPage();
  }
}

class _SignUpPage extends State<SignUpPage> {
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  final _formKey = GlobalKey<FormState>();

  TextEditingController userNAME = TextEditingController();
  TextEditingController userFNAME = TextEditingController();
  TextEditingController userCNIC = TextEditingController();
  TextEditingController userPhone = TextEditingController();
  TextEditingController userADRESS = TextEditingController();
  TextEditingController userPassword = TextEditingController();

  @override
  void dispose() {
    userNAME.dispose();
    userFNAME.dispose();
    userCNIC.dispose();
    userPhone.dispose();
    userADRESS.dispose();
    userPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        color: Colors.white10,
        child: Padding(
          padding: const EdgeInsets.only(top: 100, right: 30, left: 30),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        'SignUp',
                        style: TextStyle(
                            fontSize: 45,
                            fontWeight: FontWeight.w600,
                            color: Colors.green),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: TextFormField(
                      controller: userNAME,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        label: const Text("Name"),
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                            borderSide: const BorderSide(
                                color: Colors.green, width: 1)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 1)),
                        hintText: 'Full Name',
                        prefixIcon:
                            const Icon(Icons.contact_mail, color: Colors.green),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                            borderSide:
                                const BorderSide(color: Colors.blue, width: 1)),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                            borderSide:
                                const BorderSide(color: Colors.red, width: 1)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: TextFormField(
                      controller: userFNAME,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        label: const Text("Father Name"),
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                            borderSide: const BorderSide(
                                color: Colors.green, width: 1)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 1)),
                        hintText: 'Father Name',
                        prefixIcon:
                            const Icon(Icons.contact_mail, color: Colors.green),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                            borderSide:
                                const BorderSide(color: Colors.blue, width: 1)),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                            borderSide:
                                const BorderSide(color: Colors.red, width: 1)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your father\'s name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(13),
                      ],
                      controller: userCNIC,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        label: const Text("C.N.I.C"),
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                            borderSide: const BorderSide(
                                color: Colors.green, width: 1)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 1)),
                        hintText: 'C.N.I.C (38403XXXXXXXX)',
                        suffixIcon: userCNIC.text.length == 13
                            ? const Icon(Icons.check, color: Colors.green)
                            : null,
                        prefixIcon:
                            const Icon(Icons.contact_mail, color: Colors.green),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                            borderSide:
                                const BorderSide(color: Colors.blue, width: 1)),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                            borderSide:
                                const BorderSide(color: Colors.red, width: 1)),
                      ),
                      onChanged: (text) => setState(() {
                        // Update state to trigger rebuild
                      }),
                      validator: (number) {
                        if (number == null || number.isEmpty) {
                          return 'Please enter your CNIC';
                        } else if (number.length != 13) {
                          return 'Please enter a valid CNIC';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(11),
                      ],
                      controller: userPhone,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        label: const Text("Mobile Number"),
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                            borderSide: const BorderSide(
                                color: Colors.green, width: 1)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 1)),
                        hintText: '0300XXXXXXX',
                        suffixIcon: userPhone.text.length == 11
                            ? const Icon(Icons.check, color: Colors.green)
                            : null,
                        prefixIcon:
                            const Icon(Icons.contact_mail, color: Colors.green),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                            borderSide:
                                const BorderSide(color: Colors.blue, width: 1)),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                            borderSide:
                                const BorderSide(color: Colors.red, width: 1)),
                      ),
                      onChanged: (text) => setState(() {
                        // Update state to trigger rebuild
                      }),
                      validator: (number) {
                        if (number == null || number.isEmpty) {
                          return 'Please enter your phone number';
                        } else if (number.length != 11) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: TextFormField(
                      controller: userADRESS,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 2,
                      decoration: InputDecoration(
                        label: const Text("Postal Address"),
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                            borderSide: const BorderSide(
                                color: Colors.green, width: 1)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 1)),
                        hintText: 'Postal Address',
                        prefixIcon:
                            const Icon(Icons.location_on, color: Colors.green),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                            borderSide:
                                const BorderSide(color: Colors.blue, width: 1)),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                            borderSide:
                                const BorderSide(color: Colors.red, width: 1)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your postal address';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: TextFormField(
                      controller: userPassword,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      decoration: InputDecoration(
                        label: const Text("Password"),
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                            borderSide: const BorderSide(
                                color: Colors.green, width: 1)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 1)),
                        hintText: 'Password',
                        prefixIcon:
                            const Icon(Icons.contact_mail, color: Colors.green),
                        suffixIcon: userPassword.text.length == 6
                            ? const Icon(Icons.check, color: Colors.green)
                            : null,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                            borderSide:
                                const BorderSide(color: Colors.blue, width: 1)),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                            borderSide:
                                const BorderSide(color: Colors.red, width: 1)),
                      ),
                      onChanged: (number) => setState(() {
                        // Update state to trigger rebuild
                      }),
                      validator: (number) {
                        if (number == null || number.isEmpty) {
                          return 'Please enter your password';
                        } else if (number.length != 6) {
                          return 'Please enter a 6-digit password';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ElevatedButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            if (_formKey.currentState!.validate()) {
                              _signUp();
                            } else {
                              // Show error message if validation fails
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please correct the errors'),
                                ),
                              );
                            }
                          },
                          child: const Text('Next Page'))),
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
                          style:
                              TextStyle(decoration: TextDecoration.underline),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    String cnic = userCNIC.text;
    String password = userPassword.text;
    final email = '$cnic@mail.com';
    User? user = await _auth.signUpWithEmailAndPassword(email, password);
    if (user != null) {
      // if user signup successfully add other information to database
      addUserDetails();

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => SignupNextPage(
                    user: cnic,
                  )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please correct the errors'),
      ));
    }
  }

  Future addUserDetails() async {
    final mainInstance =
        FirebaseFirestore.instance.collection('Users').doc(userCNIC.text);
    await mainInstance.set({
      'Name': userNAME.text,
      'Father Name': userFNAME.text,
      'CNIC': userCNIC.text,
      'Address': userADRESS.text,
      'Password': userPassword.text,
      'Phone': userPhone.text,
      'Profile Status': 'inComplete'
    });
  }
}
