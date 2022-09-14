import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:siber_etik/services/firebaseauth.dart';
import 'package:siber_etik/screens/sign_up_screen.dart';
import 'package:siber_etik/widgets/appbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void buildError(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    AuthOperations auth = AuthOperations();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    bool showPassword = false;

    return Scaffold(
      appBar: appBarMyOwn('Siber Etik'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            const Gap(100),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 150,
                  width: 200,
                  decoration: const BoxDecoration(
                      image: DecorationImage(image: AssetImage('assets/Cyber-security.jpg')),
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                ),
                const Gap(50),
                TextField(
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'E-Mail',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                ),
                const Gap(20),
                TextField(
                  controller: passwordController,
                  autofillHints: const [AutofillHints.password],
                  obscureText: !showPassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.security),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                        icon: const Icon(
                          Icons.remove_red_eye,
                          //         color: showPassword ? Colors.blue : Colors.grey, // buradaki hatayı yarın aksam çöz
                        )),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                ),
                const Gap(35),
                ElevatedButton(
                    onPressed: () {
                      auth.signIn(emailController.text, passwordController.text, context);
                    },
                    child: const Text('Giris Yap')),
                const Gap(5),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpView()));
                    },
                    child: const Text('Kayıt Ol')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
