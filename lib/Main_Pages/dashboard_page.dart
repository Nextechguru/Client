import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  final String user;
  const DashboardPage({super.key, required this.user});
  @override
  State<StatefulWidget> createState() {
    return _DashboardPage();
  }
}

class _DashboardPage extends State<DashboardPage> {
  String announcement='Loading....';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    setState(() {
      
    });

  }
  Future getData()async{
    
    final CollectionRef= FirebaseFirestore.instance.collection('admin').doc('Announcement');
    final snapshot= await CollectionRef.get();
    announcement = snapshot.data()?['Announcement'];     
     }
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    


    return Scaffold(
      extendBody: true,
      appBar: AppBar(
          title: const Row(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center the Row contents
            children: [
              Icon(
                Icons.dashboard,
                color: Colors.white,
              ),
              SizedBox(
                  width:
                      10.0), // Add some spacing between icon and title (optional)
              Text(
                'Dash Board',
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
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xfff3ad21), Colors.white],
                      stops: [0.7, 1.0]),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 110, right: 20, left: 20, bottom: 50),
                  child: Card(
                    color: const Color(0xffe8dbd5),
                    child: SizedBox(
                      height: screenHeight / 4,
                      width: double.infinity,
                      child:  Column(
                        children: [const
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "Announcement !",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.green, // Adjust text color
                                fontSize: 20, // Adjust text size
                              ),
                            ),
                          ),
                          Text(
                          announcement,
                            textAlign: TextAlign.center,
                            style:const TextStyle(
                              color: Colors.red, // Adjust text color
                              fontSize: 10, // Adjust text size
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: screenHeight * 0.29,
                right: 10, // Change to 10 or another value instead of 0.2
                child: SizedBox(
                  width: screenWidth *
                      0.3, // Ensure the SizedBox has a proper width
                  height: 100,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Image.asset('assets/images/mic.png'),
                  ),
                ),
              ),
            ],
          ),
          const Text(
            'Important Links',
            style: TextStyle(color: Colors.black54),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Column(children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(CupertinoIcons.info,
                          size: 40, color: Colors.green)),
                  const Text('About Us',
                      style: (TextStyle(fontSize: 10, color: Colors.green)))
                ]),
              ),
              Expanded(
                child: Column(children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.ac_unit_rounded,
                          size: 40, color: Colors.green)),
                  const Text('Contact Us',
                      style: (TextStyle(fontSize: 10, color: Colors.green)))
                ]),
              ),
              Expanded(
                child: Column(children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.extension_outlined,
                          size: 40, color: Colors.green)),
                  const Text('Services',
                      style: (TextStyle(fontSize: 10, color: Colors.green)))
                ]),
              ),
              Expanded(
                child: Column(children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.receipt_long_rounded,
                          size: 40, color: Colors.green)),
                  const Text(
                    'Accounts',
                    style: (TextStyle(fontSize: 10, color: Colors.green)),
                  )
                ]),
              ),
            ],
          )
        ],
      ),
    );
  }
}
