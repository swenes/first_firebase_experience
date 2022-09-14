import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:siber_etik/screens/list_school_screen.dart';
import 'package:siber_etik/services/firebaseauth.dart';
import 'package:siber_etik/screens/homepage_screen.dart';

class ListCitiesScreen extends StatefulWidget {
  const ListCitiesScreen({super.key});

  @override
  State<ListCitiesScreen> createState() => _ListCitiesScreenState();
}

class _ListCitiesScreenState extends State<ListCitiesScreen> {
  AuthOperations auth = AuthOperations();
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    CollectionReference sehirlerRef = _firestore.collection('şehirler');
    DocumentReference selectedReference;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Center(
            child: Padding(
          padding: EdgeInsets.only(left: 66.0),
          child: Text('Şehirler'),
        )),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
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
                      auth.logOut().then((value) => Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (BuildContext context) => const HomePage()), (r) => false));
                    },
                  );
                  AlertDialog alert = AlertDialog(
                    title: const Text("Dikkat"),
                    content: const Text('Çıkış yapmak istediğinizden emin misiniz ?'),
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
                },
                icon: const Icon(Icons.login_outlined)),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: sehirlerRef.snapshots(),
        builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
          // verileri çekerken loading koy buraya !
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            const Text('Veriler Yükleniyor');
          } else if (asyncSnapshot.hasError) {
            const Text('Bir Hata Oluştu');
          } else if (asyncSnapshot.hasData) {
            List<DocumentSnapshot> listOfCities = asyncSnapshot.data.docs;
            return ListView.builder(
              itemCount: listOfCities.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                        tileColor: Colors.brown,
                        onTap: () async {
                          selectedReference = listOfCities[index].reference;
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ListSchoolScreen(ref: selectedReference),
                              ));
                        },
                        title: Text(listOfCities[index].id),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Text('data');
        },
      ),
    );
  }
}
