// ignore_for_file: camel_case_types

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class getWithdraw extends StatefulWidget {
  final String user;
  const getWithdraw({super.key, required this.user});
  @override
  State<StatefulWidget> createState() {
    return _getWithdraw();
  }
}

class _getWithdraw extends State<getWithdraw> {
  TextEditingController investAmount = TextEditingController();
  @override
  void dispose() {
    investAmount.dispose();
    super.dispose();
  }

  var investImage = '';
  @override
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
                const SizedBox(
                  height: 100,
                ),
                const Flexible(child: Text('Enter Amount you want to Invest')),
                Flexible(
                    child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: TextFormField(
                    controller: investAmount,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      label: const Text('Amount'),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(21),
                          borderSide:
                              const BorderSide(color: Colors.black, width: 1)),
                      hintText: 'Enter in PKR',
                    ),
                    onChanged: (text) => setState(() {
                      // Update state to trigger rebuild
                    }),
                  ),
                )),
                const Flexible(child: Text('Attach Investment Recipt')),
                Flexible(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 200,
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
                                      referenceRoot.child('Investment Images');
                                  Reference refToUploadimage = referenceImageDir
                                      .child('${widget.user}' "Invest");
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
                                    CropAspectRatioPreset.original,
                                    CropAspectRatioPreset.square,
                                    CropAspectRatioPreset.ratio16x9,
                                    CropAspectRatioPreset.ratio3x2,
                                    CropAspectRatioPreset.square
                                  ],
                                );

                                if (croppedFile != null) {
                                  // Proceed with uploading the cropped image
                                  Reference referenceRoot =
                                      FirebaseStorage.instance.ref();
                                  Reference referenceImageDir =
                                      referenceRoot.child('Investment Images');
                                  Reference refToUploadimage = referenceImageDir
                                      .child('${widget.user}' "Invest");
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
                          final mainInstance = FirebaseFirestore.instance
                              .collection('Investment');
                          await mainInstance.add({
                            'Date': timestamp,
                            'InvestImageURL': investImage,
                            'Investor': widget.user,
                            'Invest Amount': amount.toDouble(),
                            'Investment Status': 'InActive',
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
}
