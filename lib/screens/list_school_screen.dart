import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:siber_etik/services/firebaseauth.dart';

import 'homepage_screen.dart';

class ListSchoolScreen extends StatefulWidget {
  late final DocumentReference? ref;
  // ignore: prefer_const_constructors_in_immutables
  ListSchoolScreen({super.key, required this.ref});

  @override
  State<ListSchoolScreen> createState() => _ListSchoolScreenState();
}

class _ListSchoolScreenState extends State<ListSchoolScreen> {
  AuthOperations auth = AuthOperations();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController schoolNameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  List<DocumentSnapshot> schools = [];
  bool isAdd = false;
  DocumentReference? selectedRef;

  @override
  Widget build(BuildContext context) {
    CollectionReference collectionReference = _firestore.collection('/şehirler/${widget.ref?.id}/üniler');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Center(child: Text('Okullar')),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  auth.logOut().then((value) => Navigator.pushAndRemoveUntil(
                      context, MaterialPageRoute(builder: (BuildContext context) => const HomePage()), (r) => false));
                },
                icon: const Icon(Icons.login_outlined)),
          )
        ],
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: collectionReference.snapshots(),
            builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
              if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                const Text('Veriler Yükleniyor');
              } else if (asyncSnapshot.hasError) {
                const Text('Bir Hata Oluştu');
              } else if (asyncSnapshot.hasData) {
                List<DocumentSnapshot> listOfSchools = asyncSnapshot.data.docs;
                schools = listOfSchools;
                return Flexible(
                  child: ListView.builder(
                    itemCount: listOfSchools.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            tileColor: Colors.brown,
                            trailing: IconButton(
                                iconSize: 32,
                                onPressed: () {
                                  Widget cancelButton = ElevatedButton(
                                    child: const Text("Hayır"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  );
                                  Widget continueButton = ElevatedButton(
                                    child: const Text("Evet"),
                                    onPressed: () {
                                      listOfSchools[index].reference.delete();
                                      Navigator.pop(context);
                                    },
                                  );
                                  AlertDialog alert = AlertDialog(
                                    title: const Text("Dikkat"),
                                    content: const Text('Okulu silmek istediğinizden emin misiniz ?'),
                                    actions: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          cancelButton,
                                          const Gap(10),
                                          continueButton,
                                        ],
                                      )
                                    ],
                                  );
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return alert;
                                    },
                                  );

                                  //
                                },
                                icon: const Icon(Icons.delete)),
                            onTap: () {
                              schoolNameController.text = listOfSchools[index].get('name');
                              contactController.text = listOfSchools[index].get('iletisim');
                              isAdd = true;
                              selectedRef = listOfSchools[index].reference;
                            },
                            title: Text(listOfSchools[index].get('name')),
                            subtitle: Text(listOfSchools[index].get('iletisim')),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
              return const Text('');
            },
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Container(
              height: 230,
              width: MediaQuery.of(context).size.width - 50,
              decoration: BoxDecoration(color: Colors.blueGrey, borderRadius: BorderRadius.circular(25)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: schoolNameController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Okul Adı',
                        prefixIcon: Icon(Icons.school),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const Gap(20),
                    TextField(
                      controller: contactController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'İletişim',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const Gap(12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Map<String, dynamic> schoolData = {
                                'name': schoolNameController.text,
                                'iletisim': contactController.text
                              };
                              selectedRef?.update(schoolData);
                            },
                            child: const Text('Güncelle')),
                        ElevatedButton(
                            onPressed: () async {
                              Map<String, dynamic> schoolData = {
                                'name': schoolNameController.text,
                                'iletisim': contactController.text
                              };
                              await collectionReference.doc(schoolNameController.text).set(schoolData);
                            },
                            child: const Text('   Ekle   '))
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // bool isContain() {
  //   for (int i = 0; i < schools.length; i++) {
  //     if (schools[i].get('name').toString() == schoolNameController.text) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   }
  //   return false;
  // }
}
