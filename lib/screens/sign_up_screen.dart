import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:siber_etik/screens/homepage_screen.dart';
import 'package:siber_etik/services/firebaseauth.dart';
import 'package:siber_etik/widgets/appbar.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  @override
  Widget build(BuildContext context) {
    AuthOperations auth = AuthOperations();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    bool showPassword = true;
    return Scaffold(
      appBar: appBarMyOwn('Siber Etik'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 85),
                  child: Text(
                    'Hesap Oluşturalım',
                    style: Theme.of(context).textTheme.headline4?.copyWith(color: Colors.white70),
                  ),
                ),
                const Gap(30),
                TextField(
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    hintText: 'E-mail',
                  ),
                ),
                const Gap(20),
                TextField(
                  controller: passwordController,
                  autofillHints: const [AutofillHints.password],
                  obscureText: showPassword,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.security),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                        icon: const Icon(
                          Icons.remove_red_eye,
                          color: Colors.grey,
                        )),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    hintText: 'Password',
                  ),
                ),
                const Gap(30),
                ElevatedButton(
                    onPressed: () {
                      auth
                          .signUp(emailController.text, passwordController.text)
                          .then((value) => showAlertDialog(context, 'Hesabınız Başarıyla Oluşturuldu'));
                    },
                    child: const Text('Hesap Oluştur'))
              ],
            )
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, String text) {
    Widget continueButton = ElevatedButton(
      child: const Text("Anladım"),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return const HomePage();
          },
        ));
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Başarılı"),
      content: Text(text),
      actions: [
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
