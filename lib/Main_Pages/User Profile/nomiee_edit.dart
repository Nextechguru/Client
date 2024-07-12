import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NomineeEdit extends StatefulWidget {
  final String user;
  const NomineeEdit({super.key, required this.user});

  @override
  State<NomineeEdit> createState() => _NomineeEditState();
}

class _NomineeEditState extends State<NomineeEdit> {
  late Map<String, dynamic> nomineeData;
  late Map<String, dynamic> bankData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNomineeDetails();
  }

  Future<void> fetchNomineeDetails() async {
    try {
      // Fetch nominee details
      final nomineeDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.user)
          .collection('user_details')
          .doc('nominee_details')
          .get();

      // Fetch bank details
      final bankDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.user)
          .collection('user_details')
          .doc('nominee_details')
          .collection('nominee_other_details')
          .doc('nominee_bank_details')
          .get();

      setState(() {
        nomineeData = nomineeDoc.data()!;
        bankData = bankDoc.data()!;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nominee Details'),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(40.0),
            bottomLeft: Radius.circular(40.0),
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    buildNomineeDetailTile(
                      title: 'Nominee',
                      icon: CupertinoIcons.person,
                      details: [
                        buildDetailRow('Relation:  ',
                            nomineeData['Nominee Relation'] ?? ''),
                        buildDetailRow(
                            'Name:      ', nomineeData['Nominee Name'] ?? ''),
                        buildDetailRow('S/D/O:      ',
                            nomineeData['Nominee Father'] ?? ''),
                      ],
                      onEdit: () => _editNomineeDetails(context),
                    ),
                    const SizedBox(height: 20),
                    buildDetailTile(
                      title: 'CNIC:',
                      icon: CupertinoIcons.creditcard_fill,
                      subtitle: nomineeData['Nominee CNIC'] ?? '',
                      onEdit: () => _editCNICDetails(context),
                    ),
                    const SizedBox(height: 20),
                    buildDetailTile(
                      title: 'Phone No.',
                      icon: CupertinoIcons.phone,
                      subtitle: nomineeData['Nominee Mobile'] ?? '',
                      onEdit: () => _editPhoneDetails(context),
                    ),
                    const SizedBox(height: 20),
                    buildDetailTile(
                      title: 'Address',
                      icon: CupertinoIcons.location,
                      subtitle: nomineeData['Nominee Address'] ?? '',
                      onEdit: () => _editAddressDetails(context),
                    ),
                    const SizedBox(height: 20),
                    buildNomineeDetailTile(
                      title: 'Bank Details',
                      icon: CupertinoIcons.archivebox,
                      details: [
                        buildDetailRow(
                            'Bank Name:      ', bankData['Bank Name'] ?? ''),
                        buildDetailRow('Account Title:   ',
                            bankData['Account Tittle'] ?? ''),
                        buildDetailRow('IBAN Number:    ',
                            bankData['Account Number'] ?? ''),
                      ],
                      onEdit: () => _editBankDetails(context),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(value),
      ],
    );
  }

  Widget buildDetailTile({
    required String title,
    required IconData icon,
    required String subtitle,
    VoidCallback? onEdit,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: Colors.green.withOpacity(.1),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(icon),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: onEdit,
        ),
        tileColor: Colors.white,
      ),
    );
  }

  Widget buildNomineeDetailTile({
    required String title,
    required IconData icon,
    required List<Widget> details,
    VoidCallback? onEdit,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: Colors.green.withOpacity(.1),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        title: Text(title),
        subtitle: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: details,
            ),
            const Column()
          ],
        ),
        leading: Icon(icon),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: onEdit,
        ),
        tileColor: Colors.white,
      ),
    );
  }

  void _editNomineeDetails(BuildContext context) {
    TextEditingController relationController =
        TextEditingController(text: nomineeData['Nominee Relation'] ?? '');
    TextEditingController nameController =
        TextEditingController(text: nomineeData['Nominee Name'] ?? '');
    TextEditingController sdOController =
        TextEditingController(text: nomineeData['Nominee Father'] ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Nominee Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: relationController,
                  decoration: const InputDecoration(labelText: 'Relation'),
                ),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextFormField(
                  controller: sdOController,
                  decoration: const InputDecoration(labelText: 'S/D/O'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                nomineeData['Nominee Relation'] = relationController.text;
                nomineeData['Nominee Name'] = nameController.text;
                nomineeData['Nominee Father'] = sdOController.text;

                // Update Firestore document here

                setState(() {}); // Update UI if needed
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _editCNICDetails(BuildContext context) {
    TextEditingController cnicController =
        TextEditingController(text: nomineeData['Nominee CNIC'] ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit CNIC'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: cnicController,
                  decoration: const InputDecoration(labelText: 'CNIC'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                nomineeData['Nominee CNIC'] = cnicController.text;

                // Update Firestore document here

                setState(() {}); // Update UI if needed
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _editPhoneDetails(BuildContext context) {
    TextEditingController phoneController =
        TextEditingController(text: nomineeData['Nominee Mobile'] ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Phone Number'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                nomineeData['Nominee Mobile'] = phoneController.text;

                // Update Firestore document here

                setState(() {}); // Update UI if needed
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _editAddressDetails(BuildContext context) {
    TextEditingController addressController =
        TextEditingController(text: nomineeData['Nominee Address'] ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Address'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                nomineeData['Nominee Address'] = addressController.text;

                // Update Firestore document here

                setState(() {}); // Update UI if needed
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _editBankDetails(BuildContext context) {
    TextEditingController bankNameController =
        TextEditingController(text: bankData['Bank Name'] ?? '');
    TextEditingController accountTitleController =
        TextEditingController(text: bankData['Account Tittle'] ?? '');
    TextEditingController ibanController =
        TextEditingController(text: bankData['Account Number'] ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Bank Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: bankNameController,
                  decoration: const InputDecoration(labelText: 'Bank Name'),
                ),
                TextFormField(
                  controller: accountTitleController,
                  decoration:
                      const InputDecoration(labelText: 'Account Tittle'),
                ),
                TextFormField(
                  controller: ibanController,
                  decoration:
                      const InputDecoration(labelText: 'Account Number'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                bankData['Bank Name'] = bankNameController.text;
                bankData['Account Tittle'] = accountTitleController.text;
                bankData['Account Number'] = ibanController.text;

                // Update Firestore document here

                setState(() {}); // Update UI if needed
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
