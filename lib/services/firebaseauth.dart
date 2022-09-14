import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:siber_etik/screens/list_cities_screen.dart';

class AuthOperations {
  void buildError(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future signUp(String email, String password) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future signIn(String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then(
            (value) => {
              Navigator.pushAndRemoveUntil(
                  context, MaterialPageRoute(builder: (BuildContext context) => const ListCitiesScreen()), (r) => false)
            },
          );
    } catch (e) {
      if (e.toString().contains('firebase_auth/unknown')) {
        buildError('E-mail veya şifre boş bırakılamaz !');
      }
      if (e.toString().contains('invalid-email')) {
        buildError('Lütfen geçerli bir E-mail adresi giriniz !');
      }
      if (e.toString().contains('user-not-found')) {
        buildError('Kullanıcı bulunamadı !');
      }
      if (e.toString().contains('wrong-password')) {
        buildError('Şifreniz hatalı !');
      }
    }
  }

  Future logOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
