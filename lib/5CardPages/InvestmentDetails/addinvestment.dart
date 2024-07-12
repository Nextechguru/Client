import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class Investpage extends StatefulWidget {
  final String user;
  const Investpage({super.key, required this.user});
  @override
  State<StatefulWidget> createState() {
    return _InvestpageState();
  }
}

class _InvestpageState extends State<Investpage> {
  TextEditingController investAmount = TextEditingController();
  String sBankName = 'Bank Name';
  String sAccountTitle = 'Bank Title';
  String sAccountNumber = 'IBAN Number';

  String aBankName = 'Bank Name';
  String aAccountTitle = 'Bank Title';
  String aAccountNumber = 'IBAN Number';

  @override
  void dispose() {
    investAmount.dispose();
    super.dispose();
  }

  var investImage = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, // Change this to your desired color
          ),
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
                'Add Investment Amount',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          automaticallyImplyLeading: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(40.0),
                bottomLeft:
                    Radius.circular(40.0)), // Rounded bottom left corner
          ),
          backgroundColor: Colors.green),
      body: SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(right: 30, left: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: InkWell(
                    onTap: () {
                      _selectBankDropDown(context);
                    },
                    child: ListTile(
                      title: const Text(
                        'Select Sender Account (Your Account)',
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(sBankName),
                          Text(sAccountTitle),
                          Text(sAccountNumber)
                        ],
                      ),
                      trailing: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.green,
                      ),
                      tileColor: const Color.fromARGB(255, 255, 255, 255),
                      textColor: Colors.green,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: InkWell(
                    onTap: () {
                      _selectAdminBankDropDown(context);
                    },
                    child: ListTile(
                      title: const Text(
                        'Select Admin Account (Company Account)',
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(aBankName),
                          Text(aAccountTitle),
                          Text(aAccountNumber)
                        ],
                      ),
                      trailing: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.green,
                      ),
                      tileColor: const Color.fromARGB(255, 255, 255, 255),
                      textColor: Colors.green,
                    ),
                  ),
                ),
                const Flexible(
                    child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text('Enter Amount you want to Invest'),
                )),
                Flexible(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  child: SizedBox(
                    width: 500,
                    child: TextFormField(
                      controller: investAmount,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        label: const Text('Amount'),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 1)),
                        hintText: 'Enter in PKR',
                      ),
                      onChanged: (text) => setState(() {
                        // Update state to trigger rebuild
                      }),
                    ),
                  ),
                )),
                const Flexible(child: Text('Attach Investment Recipt')),
                Flexible(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 100,
                        child: investImage == ''
                            ? const Image(
                                image:
                                    AssetImage('assets/images/dummyImage.jpg'),
                              )
                            : Image.network(investImage),
                      )),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                                    CropAspectRatioPreset.original,
                                    CropAspectRatioPreset.square,
                                    CropAspectRatioPreset.ratio16x9,
                                    CropAspectRatioPreset.ratio3x2,
                                    CropAspectRatioPreset.square
                                  ],
                                );

                                if (croppedFile != null) {
                                  Timestamp time = Timestamp.now();
                                  // Proceed with uploading the cropped image
                                  Reference referenceRoot =
                                      FirebaseStorage.instance.ref();
                                  Reference referenceImageDir =
                                      referenceRoot.child('Investment Images');
                                  Reference refToUploadimage = referenceImageDir
                                      .child('${widget.user}' "$time");
                                  try {
                                    File croppedFileConverted =
                                        File(croppedFile.path);
                                    await refToUploadimage
                                        .putFile(croppedFileConverted);
                                    String newinvestImageURL =
                                        await refToUploadimage.getDownloadURL();

                                    setState(() {
                                      investImage = newinvestImageURL;
                                    });
                                  } catch (error) {
                                    print('Error while uploading');
                                  }
                                }
                              }
                            },
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
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
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 60,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          DateTime date = DateTime.now();
                          int amount = int.parse(investAmount.text);
                          Timestamp timestamp = Timestamp.fromDate(date);
                          Timestamp? timestamp2;
                          timestamp2 = null;
                          final mainInstance = FirebaseFirestore.instance
                              .collection('Investment');
                          await mainInstance.add({
                            'Date': timestamp,
                            'InvestImageURL': investImage,
                            'Investor': widget.user,
                            'Invest Amount': amount.toDouble(),
                            'Investment Approved': false,
                            'Investment Active': false,
                            'Activation Date': timestamp2,
                            'Sender Bank Name': sBankName,
                            'Sender Account Title': sAccountTitle,
                            'Sender Account Number': sAccountNumber,
                            'Reciver Bank Name': aBankName,
                            'Reciver Account Title': aAccountTitle,
                            'Reciver Account Number': aAccountNumber,
                          });
                          showToastWidget(
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.green),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'Success',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            context: context,
                            position: StyledToastPosition.center,
                            animation: StyledToastAnimation.slideToBottomFade,
                            duration: const Duration(seconds: 3),
                          );

                          setState(() {
                            investAmount.clear();
                            investImage = '';
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        child: const Text(
                          'Confirm Invest Amount',
                          style: TextStyle(color: Colors.white),
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _selectBankDropDown(BuildContext context) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.user)
        .collection('user_details')
        .doc('bank_details')
        .collection('details')
        .get();
    List<QueryDocumentSnapshot> documents = querySnapshot.docs;

    return showModalBottomSheet(
        // ignore: use_build_context_synchronously
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        builder: (context) => SizedBox(
              height: 230,
              child: ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, Index) {
                  var data = documents[Index].data() as Map<String, dynamic>;
                  String BankName = data['Bank Name'];
                  String BankTitle = data['Account Title'];
                  String AccountNo = data['Account Number'];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      color: Colors.white,
                      elevation: 5,
                      child: ListTile(
                        title: Text(BankName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text(BankTitle), Text(AccountNo)],
                        ),
                        leading: const Icon(
                          Icons.account_balance,
                        ),
                        onTap: () {
                          setState(() {
                            sBankName = BankName;
                            sAccountTitle = BankTitle;
                            sAccountNumber = AccountNo;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  );
                },
              ),
            ));
  }

  Future _selectAdminBankDropDown(BuildContext context) async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('admin').get();
    List<QueryDocumentSnapshot> document = querySnapshot.docs;
    return showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        builder: (context) => SizedBox(
              height: 230,
              child: ListView.builder(
                itemCount: document.length,
                itemBuilder: (context, index) {
                  var data = document[index].data() as Map<String, dynamic>;
                  String BankName = data['Bank Name'];
                  String BankTitle = data['Account Title'];
                  String AccountNo = data['Account Number'];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      color: Colors.white,
                      elevation: 5,
                      child: ListTile(
                        title: Text(BankName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text(BankTitle), Text(AccountNo)],
                        ),
                        leading: const Icon(
                          Icons.account_balance,
                          color: Colors.black,
                        ),
                        onTap: () {
                          setState(() {
                            aBankName = BankName;
                            aAccountTitle = BankTitle;
                            aAccountNumber = AccountNo;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  );
                },
              ),
            ));
  }
}
