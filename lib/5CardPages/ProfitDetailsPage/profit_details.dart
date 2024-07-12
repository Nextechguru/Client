import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfitDetails extends StatefulWidget {
  final String user;
  const ProfitDetails({super.key, required this.user});
  @override
  State<StatefulWidget> createState() {
    return _ProfitDetailsState();
  }
}

class _ProfitDetailsState extends State<ProfitDetails> {
  double totallInvestment = 0.0;
  Future<List<Map<String, dynamic>>>? dataList;

  @override
  void initState() {
    super.initState();
    dataList = getData();
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
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Change this to your desired color
        ),
        title: const Row(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center the Row contents
          children: [
            Icon(
              Icons.price_check,
              color: Colors.white,
            ),
            SizedBox(
              width: 10.0, // Add some spacing between icon and title (optional)
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Text(
                'Profit Details',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              width: 50.0, // Add some spacing between icon and title (optional)
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
        actions: const [],
      ),
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
                  0.0, (sum1, item) => sum1 + (item['Profit'] as num));
              final numberFormat = NumberFormat('#,##0', 'en_US');

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Total profit:   ${numberFormat.format(totallInvestment)}/- ',
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
                                    'Release Date',
                                    style: TextStyle(color: Colors.white),
                                  )))),
                          DataColumn(
                              label: Flexible(
                                  fit: FlexFit.loose,
                                  child: FittedBox(
                                      child: Text('Profit',
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
                                      numberFormat.format(item['Profit']),
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
    final collectionRef = FirebaseFirestore.instance.collection('Profit');

    final querySnapshot =
        await collectionRef.where('Investor', isEqualTo: widget.user).get();

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
