import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WithdrawTab2 extends StatefulWidget {
  final String user;
  const WithdrawTab2({super.key, required this.user});
  @override
  State<StatefulWidget> createState() {
    return _InvestmentTabState();
  }
}

class _InvestmentTabState extends State<WithdrawTab2> {
  double totallInvestment = 0.0;
  Future<List<Map<String, dynamic>>>? dataList;

  @override
  void initState() {
    super.initState();
    dataList = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: dataList,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (!snapshot.hasData) {
                return const SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                        ),
                        Text('Loading..\n'),
                        CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                );
              }

              final data = snapshot.data!;
              totallInvestment = data.fold(
                  0.0, (sum1, item) => sum1 + (item['Withdraw'] as num));
              final numberFormat = NumberFormat('#,##0', 'en_US');

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Pending For Approval:   ${numberFormat.format(totallInvestment)}/- ',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.green,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(color: Colors.white10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        headingRowHeight: 30,
                        columnSpacing: 20,
                        headingRowColor: WidgetStateColor.resolveWith(
                            (states) => Colors.green),
                        columns: const [
                          DataColumn(
                              label: Flexible(
                                  fit: FlexFit.loose,
                                  child: FittedBox(
                                      child: Text(
                                    'Request Date',
                                    style: TextStyle(color: Colors.white),
                                  )))),
                          DataColumn(
                              label: Flexible(
                                  fit: FlexFit.loose,
                                  child: FittedBox(
                                      child: Text('Withdraw Amount',
                                          style: TextStyle(
                                              color: Colors.white))))),
                        ],
                        rows: data
                            .map((item) => DataRow(
                                  cells: [
                                    DataCell(Text(
                                      DateFormat('dd-MMM-yyyy').format(
                                          (item['Date'] as Timestamp).toDate()),
                                    )),
                                    DataCell(Text(
                                      numberFormat.format(item['Withdraw']),
                                      style: const TextStyle(
                                        color: Colors.green,
                                      ),
                                    )),
                                  ],
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> getData() async {
    final collectionRef = FirebaseFirestore.instance.collection('Withdraw');

    final querySnapshot = await collectionRef
        .where('User', isEqualTo: widget.user)
        .where('Withdraw Approved', isEqualTo: false)
        .get();

    // Sort the retrieved documents by the 'Date' field (descending order)
    final sortedDocs = querySnapshot.docs.toList()
      ..sort(
        (a, b) => (b.data()['Date'] as Timestamp)
            .compareTo(a.data()['Date'] as Timestamp),
      );

    final dataList = sortedDocs.map((doc) => doc.data()).toList();

    return dataList;
  }
}
