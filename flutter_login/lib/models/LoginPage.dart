import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/models/Pantallainicio.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'Registration.dart';

Widget createButtonlogin() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 16)),
      onPressed: () {},
      child: const Text('Iniciar Sesión'),
    ),
  );
}

Widget createAccountlink(BuildContext context) {
  return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: TextButton(
        child: const Text('¡Registrate aquí!'),
        style: TextButton.styleFrom(textStyle: const TextStyle(fontSize: 12)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyCustomForm()),
          );
        },
      ));
}

Widget createseparator() {
  return Container(
      padding: const EdgeInsets.only(top: 15),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(children: [
          Expanded(child: Divider(height: 1)),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text('ó'),
          ),
          Expanded(child: Divider(height: 1))
        ]),
      ));
}

Widget createButtonfacebook() {
  return Padding(
      padding: const EdgeInsets.only(top: 25, left: 35, right: 35),
      child: SignInButton(
        Buttons.Facebook,
        text: "Iniciar con facebook ",
        onPressed: () {},
      ));
}

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late String _email;
  late String _pass;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido'),
      ),
      body: Container(
        child: ListView(children: [
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Image.asset(
                      'assets/images/beauty.png',
                      width: 150,
                      height: 150,
                    )),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10, right: 15, left: 15, bottom: 15),
                  child: TextFormField(
                    decoration: InputDecoration(hintText: "Ingrese su correo"),
                    // The validator receives the text that the user has entered.
                    validator: (value) =>
                        value!.isValidEmail() ? null : "Verifique su correo",
                    onSaved: (value) => _email = value!,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextFormField(
                    decoration:
                        InputDecoration(hintText: "Ingrese su contraseña"),
                    obscureText: true,
                    // The validator receives the text that the user has entered.
                    validator: (value) =>
                        value!.isEmpty ? "Ingrese una contraseña" : null,
                    onSaved: (value) => _pass = value!,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: ElevatedButton(
                    child: Text('Iniciar Sesión'),
                    onPressed: () async {
                      _formKey.currentState!.save();
                      try {
                        await FirebaseAuth
                            .instance
                            .signInWithEmailAndPassword(
                                email: _email, password: _pass);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          print('No user found for that email.');
                        } else if (e.code == 'wrong-password') {
                          print('Wrong password provided for that user.');
                        }
                      }
                    },
                  ),
                ),
                createAccountlink(context),
                createseparator(),
                createButtonfacebook(),
              ],
            ),
          )
        ]),
      ),
    );
  }
}


