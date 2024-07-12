import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BankPage extends StatefulWidget {
  final String user;
  const BankPage({super.key, required this.user});

  @override
  State<BankPage> createState() => _BankPageState();
}

class _BankPageState extends State<BankPage> {
  String sBankName = '';
  String sAccountTitle = '';
  String sAccountNumber = '';
  Future<List<Map<String, dynamic>>>? documents;
  bool isLoading = true;

  List<String> bankNames = [
    "State Bank of Pakistan (SBP)",
    "National Bank of Pakistan (NBP)",
    "Allied Bank Limited (ABL)",
    "United Bank Limited (UBL)",
    "Habib Bank Limited (HBL)",
    "MCB Bank Limited (MCB)",
    "Askari Bank Limited",
    "Bank Alfalah",
    "Faysal Bank Limited",
    "Standard Chartered Bank (Pakistan)",
    "Bank of Punjab (BOP)",
    "Sindh Bank",
    "Meezan Bank Limited",
    "JS Bank Limited",
    "Bank Islami Pakistan Limited",
    "Summit Bank",
    "Soneri Bank Limited",
    "First Women Bank Limited",
    "Habib Metropolitan Bank Limited",
    "Al Baraka Bank (Pakistan) Limited",
    "Samba Bank Limited",
    "Dubai Islamic Bank Pakistan Limited",
    "Industrial and Commercial Bank of China (ICBC)",
    "NIB Bank Limited",
    "Pak Oman Investment Company Limited",
    "Bank of Khyber",
    "Silk Bank Limited",
    "Punjab Provincial Cooperative Bank",
    "Zarai Taraqiati Bank Limited (ZTBL)",
    "Khushhali Microfinance Bank",
    "U Microfinance Bank Limited",
    "Easypaisa",
    "JazzCash",
    "SadaPay",
    "Finja",
    "UPaisa",
    "Keenu Wallet",
    "NayaPay",
    "SimSim Wallet"
  ];

  @override
  void initState() {
    super.initState();
    documents = getData();
    isLoading = false;
  }

  Future<List<Map<String, dynamic>>> getData() async {
    final collectionRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.user)
        .collection('user_details')
        .doc('bank_details')
        .collection('details');
    final querySnapshot = await collectionRef.get();
    final sortedDocs = querySnapshot.docs.toList();
    final dataList = sortedDocs.map((doc) {
      var data = doc.data();
      data['id'] = doc.id; // Include the document ID in the data
      return data;
    }).toList();
    return dataList;
  }

  Future<void> addBankDetail() async {
    final collectionRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.user)
        .collection('user_details')
        .doc('bank_details')
        .collection('details');
    await collectionRef.add({
      'Bank Name': sBankName,
      'Account Title': sAccountTitle,
      'Account Number': sAccountNumber,
    });
    setState(() {
      documents = getData();
    });
  }

  Future<void> updateBankDetail(String docId) async {
    final docRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.user)
        .collection('user_details')
        .doc('bank_details')
        .collection('details')
        .doc(docId);
    await docRef.update({
      'Bank Name': sBankName,
      'Account Title': sAccountTitle,
      'Account Number': sAccountNumber,
    });
    setState(() {
      documents = getData();
    });
  }

  Future<void> deleteBankDetail(String docId) async {
    final docRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.user)
        .collection('user_details')
        .doc('bank_details')
        .collection('details')
        .doc(docId);
    await docRef.delete();
    setState(() {
      documents = getData();
    });
  }

  void showAddBankDetailPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Bank Detail'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Bank Name'),
                items: bankNames.map((String bank) {
                  return DropdownMenuItem<String>(
                    value: bank,
                    child: Text(bank),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    sBankName = value!;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Account Title'),
                onChanged: (value) {
                  setState(() {
                    sAccountTitle = value;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Account Number'),
                onChanged: (value) {
                  setState(() {
                    sAccountNumber = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                addBankDetail();
                Navigator.of(context).pop();
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void showEditBankDetailPopup(Map<String, dynamic> data) {
    setState(() {
      sBankName = data['Bank Name'];
      sAccountTitle = data['Account Title'];
      sAccountNumber = data['Account Number'];
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Bank Detail'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: sBankName,
                decoration: InputDecoration(labelText: 'Bank Name'),
                items: bankNames.map((String bank) {
                  return DropdownMenuItem<String>(
                    value: bank,
                    child: Text(bank),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    sBankName = value!;
                  });
                },
              ),
              TextField(
                controller: TextEditingController(text: sAccountTitle),
                decoration: InputDecoration(labelText: 'Account Title'),
                onChanged: (value) {
                  setState(() {
                    sAccountTitle = value;
                  });
                },
              ),
              TextField(
                controller: TextEditingController(text: sAccountNumber),
                decoration: InputDecoration(labelText: 'Account Number'),
                onChanged: (value) {
                  setState(() {
                    sAccountNumber = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                updateBankDetail(data['id']);
                Navigator.of(context).pop();
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void showDeleteConfirmationPopup(String docId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Bank Detail?'),
          content: Text('Are you sure you want to delete this bank detail?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                deleteBankDetail(docId);
                Navigator.of(context).pop();
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home,
              color: Colors.white,
            ),
            SizedBox(width: 10.0),
            Text(
              'Your Banks Details',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(40.0),
              bottomLeft: Radius.circular(40.0)),
        ),
        backgroundColor: Colors.green,
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: documents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error : ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No bank details available'));
          } else {
            return showbankDetails(
              documents: snapshot.data!,
              onEdit: showEditBankDetailPopup,
              onDelete: showDeleteConfirmationPopup,
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddBankDetailPopup,
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}

class showbankDetails extends StatelessWidget {
  final List<Map<String, dynamic>> documents;
  final Function(Map<String, dynamic>) onEdit;
  final Function(String) onDelete;

  const showbankDetails({
    super.key,
    required this.documents,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: documents.length,
      itemBuilder: (context, Index) {
        var data = documents[Index];
        String BankName = data['Bank Name'];
        String BankTitle = data['Account Title'];
        String AccountNo = data['Account Number'];
        String docId = data['id']; // Retrieve document ID

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: Colors.white,
            elevation: 5,
            child: ListTile(
              title: Text(BankName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(BankTitle),
                  Text(AccountNo),
                ],
              ),
              leading: const Icon(Icons.account_balance),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => onEdit(data),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => onDelete(docId),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
