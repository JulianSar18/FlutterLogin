import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

FirebaseAuth auth = FirebaseAuth.instance;

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

extension PasswordValidator on String {
  bool isValidPass() {
    return RegExp(
            r'^(?=.*\d)(?=.*[\u0021-\u002b\u003c-\u0040])(?=.*[A-Z])(?=.*[a-z])\S{8,16}$')
        .hasMatch(this);
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
   String ? _email;
   String ? _pass;
  



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrarse'),
      ),
      body: Container(
        child: ListView(children: [
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: Image.network(
                      'https://image.flaticon.com/icons/png/512/753/753399.png',
                      width: 150,
                      height: 150,
                    )),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 50, right: 15, left: 15, bottom: 15),
                  child: TextFormField(
                    decoration: InputDecoration(hintText: "Ingrese su correo"),
                    // The validator receives the text that the user has entered.
                    validator: (input) => input!.isValidEmail()
                        ? null
                        : "Por favor ingrese un correo",
                    onSaved: (input) => _email = input,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextFormField(
                      decoration:
                          InputDecoration(hintText: "Ingrese su contraseña"),
                      obscureText: true,
                      // The validator receives the text that the user has entered.
                      validator: (value) => value!.isValidPass()
                          ? null
                          : "Por favor ingrese una contraseña",
                      onSaved: (value) => _pass = value),
                ),
                Padding(
                  padding: const EdgeInsets.all(50),
                  child: ElevatedButton(
                    child: Text('Registrarse'),
                    onPressed: () async{
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
       try {
  UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: _email!,
    password: _pass!
  );
} on FirebaseAuthException catch (e) {
  if (e.code == 'weak-password') {
    print('The password provided is too weak.');
  } else if (e.code == 'email-already-in-use') {
    print('The account already exists for that email.');
  }
} catch (e) {
  print(e);
}
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "Verifique correo o su contraseña. La contraseña debe tener al entre 8 y 16 caracteres, al menos un dígito, al menos una minúscula, al menos una mayúscula y al menos un caracter no alfanumérico.")));
    }
                    },
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
