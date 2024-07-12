import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class E_Statement extends StatefulWidget {
  final String user;
  const E_Statement({super.key, required this.user});

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<E_Statement> {
  double totallInvestment = 0.0;
  Future<List<Map<String, dynamic>>>? dataList;
  List<Map<String, dynamic>> allDocuments = [];
  Set<String> allKeys = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllDocuments().then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> fetchAllDocuments() async {
    List<Map<String, dynamic>> mergedDocuments = [];

    List<Map<String, dynamic>> investmentDocs = await getInvestmentData();
    List<Map<String, dynamic>> profitDocs = await getProfitData();
    List<Map<String, dynamic>> taxDocs = await getTaxData();
    List<Map<String, dynamic>> withdrawDocs = await getwithdrawData();

    mergedDocuments.addAll(investmentDocs);
    mergedDocuments.addAll(profitDocs);
    mergedDocuments.addAll(taxDocs);
    mergedDocuments.addAll(withdrawDocs);

    // Collect all unique keys
    for (var doc in mergedDocuments) {
      allKeys.addAll(doc.keys);
    }

    mergedDocuments.sort((a, b) {
      DateTime dateA = (a['Date'] as Timestamp).toDate();
      DateTime dateB = (b['Date'] as Timestamp).toDate();
      return dateB.compareTo(dateA);
    });

    setState(() {
      allDocuments = mergedDocuments;
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
    });
    await fetchAllDocuments();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              color: Colors.white,
            ),
            SizedBox(
              width: 10.0,
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Text(
                'E-Statement',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              width: 50.0,
            ),
          ],
        ),
        automaticallyImplyLeading: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(40.0),
              bottomLeft: Radius.circular(40.0)),
        ),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
              onPressed: () {
                _refreshData();
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : allDocuments.isEmpty
              ? const Center(child: Text('No data available'))
              : SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: DataTable(
                            border: TableBorder.all(),
                            headingRowHeight: 30,
                            columnSpacing: 20,
                            headingRowColor: WidgetStateColor.resolveWith(
                                (states) => Colors.green),
                            columns: const [
                              DataColumn(
                                  label: Text(
                                'Date',
                                style: TextStyle(color: Colors.white),
                              )),
                              DataColumn(
                                  label: Text(
                                'Amount',
                                style: TextStyle(color: Colors.white),
                              )),
                              DataColumn(
                                  label: Text(
                                'Type',
                                style: TextStyle(color: Colors.white),
                              )),
                            ],
                            rows: allDocuments.map((doc) {
                              return DataRow(cells: [
                                DataCell(Text(DateFormat('dd-MMM-yy').format(
                                    (doc['Date'] as Timestamp).toDate()))),
                                DataCell(Text(
                                  doc.containsKey('Invest Amount')
                                      ? doc['Invest Amount'].toString()
                                      : doc.containsKey('Profit')
                                          ? doc['Profit'].toString()
                                          : doc.containsKey('Tax')
                                              ? doc['Tax'].toString()
                                              : doc.containsKey('Withdraw')
                                                  ? doc['Withdraw'].toString()
                                                  : '',
                                  style: TextStyle(
                                    color: doc.containsKey('Tax')
                                        ? Colors.red
                                        : doc.containsKey('Withdraw')
                                            ? Colors.red
                                            : Colors.green,
                                  ),
                                )),
                                DataCell(Text(
                                  doc['collection'],
                                  style: TextStyle(
                                    color: doc['collection'] == 'Withdraw' ||
                                            doc['collection'] == 'Tax'
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                ))
                              ]);
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Future<List<Map<String, dynamic>>> getInvestmentData() async {
    final collectionRef = FirebaseFirestore.instance.collection('Investment');
    final querySnapshot =
        await collectionRef.where('Investor', isEqualTo: widget.user).get();

    final dataList = querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data();
      data['collection'] = 'Investment';
      return data;
    }).toList();
    return dataList;
  }

  Future<List<Map<String, dynamic>>> getProfitData() async {
    final collectionRef = FirebaseFirestore.instance.collection('Profit');
    final querySnapshot = await collectionRef
        .where('Investor', isEqualTo: widget.user)
        .where('Converted to Investment', isEqualTo: false)
        .get();

    final dataList = querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data();
      data['collection'] = 'Profit';
      return data;
    }).toList();

    return dataList;
  }

  Future<List<Map<String, dynamic>>> getTaxData() async {
    final collectionRef = FirebaseFirestore.instance.collection('Tax');
    final querySnapshot =
        await collectionRef.where('User', isEqualTo: widget.user).get();

    final dataList = querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data();
      data['collection'] = 'Tax';
      return data;
    }).toList();
    return dataList;
  }

  Future<List<Map<String, dynamic>>> getwithdrawData() async {
    final collectionRef = FirebaseFirestore.instance.collection('Withdraw');
    final querySnapshot = await collectionRef
        .where('User', isEqualTo: widget.user)
        .where('Withdraw Delivered', isEqualTo: true)
        .get();

    final dataList = querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data();
      data['collection'] = 'Withdraw';
      return data;
    }).toList();
    return dataList;
  }
}
