// ignore_for_file: library_private_types_in_public_api, camel_case_types

import 'package:flutter/material.dart';
import 'package:roshan_dastak_client/5CardPages/Withdraw%20Details/tab1.dart';
import 'package:roshan_dastak_client/5CardPages/Withdraw%20Details/tab2.dart';

class Withdrawdetails extends StatefulWidget {
  final user;
  const Withdrawdetails({super.key, required this.user});

  @override
  _withdrawState createState() => _withdrawState();
}

class _withdrawState extends State<Withdrawdetails>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Change this to your desired color
        ),
        title: const Row(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center the Row contents
          children: [
            Icon(
              Icons.payments,
              color: Colors.white,
            ),
            SizedBox(
              width: 10.0, // Add some spacing between icon and title (optional)
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Text(
                'Withdraw Details',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(40.0),
              bottomLeft: Radius.circular(40.0)), // Rounded bottom left corner
        ),
        backgroundColor: Colors.green,
        actions: const [
          SizedBox(
            width: 50,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              const SizedBox(height: 25),
              Container(
                // height: 50,
                width: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: TabBar(
                        unselectedLabelColor: Colors.white,
                        labelColor: Colors.black,
                        indicatorColor: Colors.white,
                        indicatorWeight: 2,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        controller: tabController,
                        tabs: const [
                          Tab(
                            text: 'Approved',
                          ),
                          Tab(
                            text: 'Pending',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    WithdrawTab1(
                      user: widget.user,
                    ),
                    WithdrawTab2(
                      user: widget.user,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
