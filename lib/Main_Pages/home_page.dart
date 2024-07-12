// ignore_for_file: avoid_types_as_parameter_names, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:roshan_dastak_client/5CardPages/Estatement/eStatement.dart';
import 'package:roshan_dastak_client/5CardPages/InvestmentDetails/addinvestment.dart';
import 'package:roshan_dastak_client/5CardPages/InvestmentDetails/investment_details.dart';
import 'package:roshan_dastak_client/5CardPages/ProfitDetailsPage/profit_details.dart';
import 'package:roshan_dastak_client/5CardPages/TaxDetails/TaxDetails.dart';
import 'package:roshan_dastak_client/5CardPages/Withdraw%20Details/Add_Withdraw.dart';
import 'package:roshan_dastak_client/5CardPages/Withdraw%20Details/WithdrawDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  final String user;

  const MyHomePage({super.key, required this.user});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String name = '';
  // Declaring Variables for universal use
  double totalActive = 0;
  double inActive = 0;
  double totalProfit = 0;
  double totalConvertedProfit = 0;
  double totalWithdraw = 0;
  double totalTax = 0;

  Future<List<Map<String, dynamic>>>? dataList;
  var investImage = '';
  TextEditingController investAmount = TextEditingController();
  // InItState to state when page open while building app
  @override
  void initState() {
    super.initState();
    dataList = getData();
  }

  Future<List<Map<String, dynamic>>> getData() async {
    final collectionRef = FirebaseFirestore.instance.collection('Investment');
    // 01 totall Active Investment
    final querySnapshot = await collectionRef
        .where('Investor', isEqualTo: widget.user)
        .where('Investment Active', isEqualTo: true)
        .where('Investment Approved', isEqualTo: true)
        .get();

    // Sort the retrieved documents by the 'Date' field (descending order)
    final sortedDocs = querySnapshot.docs.toList();

    final dataList = sortedDocs.map((doc) => doc.data()).toList();

    totalActive =
        dataList.fold(0.0, (sum, item) => sum + (item['Invest Amount'] as num));

    // 02  For In-Active Investment

    final querySnapshot2 = await collectionRef
        .where('Investor', isEqualTo: widget.user)
        .where('Investment Active', isEqualTo: false)
        .where('Investment Approved', isEqualTo: true)
        .get();

    // Sort the retrieved documents by the 'Date' field (descending order)
    final sortedDocs2 = querySnapshot2.docs.toList();

    final dataList2 = sortedDocs2.map((doc) => doc.data()).toList();

    inActive = dataList2.fold(
        0.0, (sum, item) => sum + (item['Invest Amount'] as num));

    // 03 For Totall-Profit which is Not Converted to  Investment
    final profitcollection = FirebaseFirestore.instance.collection('Profit');
    final querySnapshot3 = await profitcollection
        .where('Investor', isEqualTo: widget.user)
        .where('Converted to Investment', isEqualTo: false)
        .get();

    // Sort the retrieved documents by the 'Date' field (descending order)
    final sortedDocs3 = querySnapshot3.docs.toList();

    final dataList3 = sortedDocs3.map((doc) => doc.data()).toList();

    totalProfit =
        dataList3.fold(0.0, (sum, item) => sum + (item['Profit'] as num));
    print(totalProfit);
    // 04 For Totall-Converted-Profit which is Not Converted to  Investment
    final querySnapshot4 = await profitcollection
        .where('Investor', isEqualTo: widget.user)
        .where('Converted to Investment', isEqualTo: true)
        .get();

    // Sort the retrieved documents by the 'Date' field (descending order)
    final sortedDocs4 = querySnapshot4.docs.toList();

    final dataList4 = sortedDocs4.map((doc) => doc.data()).toList();

    totalConvertedProfit =
        dataList4.fold(0.0, (sum, item) => sum + (item['Profit'] as num));

    // 06 For Totall-withdraw
    final taxcollection = FirebaseFirestore.instance.collection('Tax');
    final querySnapshot6 =
        await taxcollection.where('User', isEqualTo: widget.user).get();

    // Sort the retrieved documents by the 'Date' field (descending order)
    final sortedDocs6 = querySnapshot6.docs.toList();

    final dataList6 = sortedDocs6.map((doc) => doc.data()).toList();

    totalTax = dataList6.fold(0.0, (sum, item) => sum + (item['Tax'] as num));

    // Now We have total Sum of All required keys value

    // As total Active Investment is equal to ActiveInvestment minus total tax
    totalActive -= totalTax;

    // geting Username for Sharedpreferences that we save at the time of login
    var pref1 = await SharedPreferences.getInstance();
    String? name1 = pref1.getString('Name');

    if (name1 != null) {
      name = name1;
    } else {
      name = 'Default Name'; // or any default value you prefer
    }
    setState(() {});

    return dataList;
  }

  Future<void> _refreshData() async {
    setState(() {
      // Call getData() to fetch updated data
      dataList = getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
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
              'Home',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(40.0),
              bottomLeft: Radius.circular(40.0)), // Rounded bottom left corner
        ),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomDetailsCard(
              totalInvestment: totalActive,
              inActive: inActive,
              availableProfit: totalProfit,
              name: name,
            ),
            TwoButton(
              user: widget.user,
            ),
            FourInkwellCard(
              user: widget.user,
            ),
          ],
        ),
      ),
    );
  }
}

// Splitting App into Widgets.. by making class of code then calling in main page where we need
// Useful for cleanup code. and re_use the full class on different pages

// For State Full widget you have to create two class to Create a static widget that can be update when app is running
// (01)............ First Code StateFull which can be update
class CustomDetailsCard extends StatefulWidget {
  final double totalInvestment;
  final double inActive;
  final double availableProfit;
  final String name;

  const CustomDetailsCard(
      {super.key,
      required this.totalInvestment,
      required this.inActive,
      required this.availableProfit,
      required this.name});

  @override
  State<StatefulWidget> createState() {
    return CustomCardState();
  }
}

class CustomCardState extends State<CustomDetailsCard> {
  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,##0', 'en_US');

    return Container(
      margin: const EdgeInsets.only(top: 17, right: 17, left: 17),
      padding: const EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height / 5,
      width: double.infinity,
      decoration: BoxDecoration(
          image: const DecorationImage(
              image: AssetImage('assets/images/cardbg2.jpg'),
              fit: BoxFit.cover,
              opacity: 0.2),
          color: const Color(0xfffaf8ed),
          borderRadius: BorderRadius.circular(10.0), // Set corner radius
          boxShadow: [
            BoxShadow(
              color:
                  Colors.grey.withOpacity(0.5), // Semi-transparent grey shadow
              blurRadius: 5.0, // Amount of blur
              offset: const Offset(2.0, 4.0),
            ),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 3,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Investor', style: TextStyle(fontSize: 15)),
                        Text(widget.name, style: const TextStyle(fontSize: 25)),
                        const Text('Current (Active) Investment',
                            style: TextStyle(fontSize: 15))
                      ],
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 2,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Rs:  ', style: TextStyle(fontSize: 20)),
                        Text(numberFormat.format(widget.totalInvestment),
                            style: const TextStyle(fontSize: 30)),
                        const Text(' PKR', style: TextStyle(fontSize: 10))
                      ],
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      children: [
                        const Text('Rs:  ', style: TextStyle(fontSize: 15)),
                        Text(numberFormat.format(widget.inActive),
                            style: const TextStyle(fontSize: 20)),
                        const Text('(in-Active Investment)',
                            style: TextStyle(fontSize: 15)),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      children: [
                        const Text('Rs:  ', style: TextStyle(fontSize: 15)),
                        Text(numberFormat.format(widget.availableProfit),
                            style: const TextStyle(fontSize: 20)),
                        const Text(' (Available-Profit)',
                            style: TextStyle(fontSize: 15)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Expanded(
                    flex: 1,
                    child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text('VISA',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold)))),
                Expanded(
                    flex: 2,
                    child: Image.asset('assets/images/sim.png',
                        fit: BoxFit.cover)),
                const Expanded(flex: 3, child: SizedBox())
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// (02) Invest And Withdraw Button
class TwoButton extends StatelessWidget {
  final user;
  const TwoButton({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height / 13,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FittedBox(
                fit: BoxFit.scaleDown,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Investpage(user: user)));
                  },
                  icon: const Icon(Icons.account_balance),
                  label: const Text('Invest'),
                )),
            FittedBox(
                fit: BoxFit.scaleDown,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Withdrawpage(user: user)));
                  },
                  icon: const Icon(Icons.credit_score),
                  label: const Text('Withdraw'),
                )),
          ],
        ));
  }
}

// (03) Four Cards that contain Image and link to different pages

class FourInkwellCard extends StatelessWidget {
  final String user;

  const FourInkwellCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.extent(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        maxCrossAxisExtent: 215,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TabBarPage(
                            user: user,
                          )));
              // Your button press action
            },
            child: Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: const Color(0xfffaf8ed),
                  borderRadius:
                      BorderRadius.circular(10.0), // Set corner radius
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey
                          .withOpacity(0.5), // Semi-transparent grey shadow
                      blurRadius: 5.0, // Amount of blur
                      offset: const Offset(2.0, 4.0),
                    ),
                  ]), // Set your desired background color
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Text(
                        'Investment Details  >',
                        style: TextStyle(fontSize: (12), color: Colors.green),
                      ),
                    ),
                    Expanded(
                        flex: 5,
                        child: Image.asset(
                          'assets/images/money.png',
                          fit: BoxFit.cover,
                        )),
                  ]),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfitDetails(
                            user: user,
                          )));
              // Your button press action here
              print('Button pressed!');
            },
            child: Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: const Color(0xfffaf8ed),
                  borderRadius:
                      BorderRadius.circular(10.0), // Set corner radius
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey
                          .withOpacity(0.5), // Semi-transparent grey shadow
                      blurRadius: 5.0, // Amount of blur
                      offset: const Offset(2.0, 4.0),
                    ),
                  ]), // Set your desired background color
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Flexible(
                      flex: 1,
                      child: Text(
                        'Profit Details',
                        style: TextStyle(fontSize: (12), color: Colors.green),
                      ),
                    ),
                    Expanded(
                        flex: 5,
                        child: Image.asset(
                          'assets/images/profit.png',
                          fit: BoxFit.cover,
                        )),
                  ]),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Withdrawdetails(
                            user: user,
                          )));
              // Your button press action here
            },
            child: Container(
              width: 200,
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: const Color(0xfffaf8ed),
                  borderRadius:
                      BorderRadius.circular(10.0), // Set corner radius
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey
                          .withOpacity(0.5), // Semi-transparent grey shadow
                      blurRadius: 5.0, // Amount of blur
                      offset: const Offset(2.0, 4.0),
                    ),
                  ]), // Set your desired background color
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Text(
                        'Withdraw Details',
                        style: TextStyle(fontSize: (12), color: Colors.green),
                      ),
                    ),
                    Expanded(
                        flex: 5,
                        child: Image.asset(
                          'assets/images/withdraw.png',
                          fit: BoxFit.cover,
                        )),
                  ]),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Taxdetails(
                            user: user,
                          )));
            },
            child: Container(
              width: 200,
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: const Color(0xfffaf8ed),
                  borderRadius:
                      BorderRadius.circular(10.0), // Set corner radius
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey
                          .withOpacity(0.5), // Semi-transparent grey shadow
                      blurRadius: 5.0, // Amount of blur
                      offset: const Offset(2.0, 4.0),
                    ),
                  ]), // Set your desired background color
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Text(
                        'Tax Details',
                        style: TextStyle(fontSize: (12), color: Colors.green),
                      ),
                    ),
                    Expanded(
                        flex: 5,
                        child: Image.asset(
                          'assets/images/taxes.png',
                          fit: BoxFit.cover,
                        )),
                  ]),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => E_Statement(
                            user: user,
                          )));
            },
            child: Container(
              width: 200,
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: const Color(0xfffaf8ed),
                  borderRadius:
                      BorderRadius.circular(10.0), // Set corner radius
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey
                          .withOpacity(0.5), // Semi-transparent grey shadow
                      blurRadius: 5.0, // Amount of blur
                      offset: const Offset(2.0, 4.0),
                    ),
                  ]), // Set your desired background color
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Text(
                        'E-Statement',
                        style: TextStyle(fontSize: (12), color: Colors.green),
                      ),
                    ),
                    Expanded(
                        flex: 5,
                        child: Image.asset(
                          'assets/images/eStatement.png',
                          fit: BoxFit.cover,
                        )),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
