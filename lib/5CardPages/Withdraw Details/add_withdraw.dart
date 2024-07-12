import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class Withdrawpage extends StatefulWidget {
  final String user;
  const Withdrawpage({super.key, required this.user});
  @override
  State<StatefulWidget> createState() {
    return _InvestpageState();
  }
}

class _InvestpageState extends State<Withdrawpage> {
  TextEditingController withdrawAmount = TextEditingController();
  @override
  void dispose() {
    withdrawAmount.dispose();
    super.dispose();
  }

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
                'Withdraw',
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
                const Flexible(
                    child: Text('Enter Amount you want to Withdraw')),
                Flexible(
                    child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: TextFormField(
                    controller: withdrawAmount,
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
                Column(
                  children: [
                    const SizedBox(
                      height: 60,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          DateTime date = DateTime.now();
                          int amount = int.parse(withdrawAmount.text);
                          Timestamp timestamp = Timestamp.fromDate(date);
                          Timestamp? timestamp2;
                          timestamp2 = null;
                          final mainInstance =
                              FirebaseFirestore.instance.collection('Withdraw');
                          await mainInstance.add({
                            'Date': timestamp,
                            'User': widget.user,
                            'Withdraw': amount.toDouble(),
                            'Withdraw Approved': false,
                            'Withdraw Delivered': false,
                            'Delivered Date': timestamp2,
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
                            withdrawAmount.clear();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        child: const Text(
                          'Confirm Withdraw Amount',
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
