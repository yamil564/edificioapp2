import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color.fromRGBO(235, 31, 42, 1),
        hintColor: Colors.orange[600],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Demo Login'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //For LinearProgressIndicator.
  bool _visible = false;

  //Textediting Controller for Username and Password Input
  final userController = TextEditingController();
  final pwdController = TextEditingController();

  Future userLogin() async {
    //Login API URL
    //use your local IP address instead of localhost or use Web API
    var url = Uri.parse('http://127.0.0.1/login_api/user_login.php');

    // Showing LinearProgressIndicator.
    setState(() {
      _visible = true;
    });

    // Getting username and password from Controller
    var data = {
      'username': userController.text,
      'password': pwdController.text,
    };

    //Starting Web API Call.
    var response = await http.post(url, body: json.encode(data));
    if (response.statusCode == 200) {
      //Server response into variable
      print(response.body);
      var msg = jsonDecode(response.body);

      //Check Login Status
      if (msg['loginStatus'] == true) {
        setState(() {
          //hide progress indicator
          _visible = false;
        });

        // Navigate to Home Screen
        final String userName =
            msg['userInfo']['NAME']; // Captura el nombre de usuario

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              key:
                  UniqueKey(), // Proporciona una clave única o ajusta según tu necesidad
              uname: userName, // Pasa el nombre de usuario como argumento
            ),
          ),
        );
      } else {
        setState(() {
          //hide progress indicator
          _visible = false;

          //Show Error Message Dialog
          showMessage(msg["message"]);
        });
      }
    } else {
      setState(() {
        //hide progress indicator
        _visible = false;

        //Show Error Message Dialog
        showMessage("Error during connecting to Server.");
      });
    }
  }

  Future<void> showMessage(String msg) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(msg),
          actions: <Widget>[
            TextButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: _visible,
              child: Container(
                margin: EdgeInsets.only(bottom: 10.0),
                child: LinearProgressIndicator(),
              ),
            ),
            Container(
              height: 100.0,
            ),
            Icon(
              Icons.group,
              color: Theme.of(context).primaryColor,
              size: 80.0,
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'Inicio de sesion',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 40.0,
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Theme(
                      data: new ThemeData(
                        primaryColor: Color.fromRGBO(84, 87, 90, 0.5),
                        primaryColorDark: Color.fromRGBO(84, 87, 90, 0.5),
                        hintColor:
                            Color.fromRGBO(84, 87, 90, 0.5), //placeholder color
                      ),
                      child: TextFormField(
                        controller: userController,
                        decoration: InputDecoration(
                          focusedBorder: new OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(84, 87, 90, 0.5),
                              style: BorderStyle.solid,
                            ),
                          ),
                          enabledBorder: new OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(84, 87, 90, 0.5),
                              style: BorderStyle.solid,
                            ),
                          ),
                          errorBorder: new OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 1.0,
                              style: BorderStyle.solid,
                            ),
                          ),
                          labelText: 'Usuario',
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Color.fromRGBO(84, 87, 90, 0.5),
                          ),
                          border: new OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(84, 87, 90, 0.5),
                              style: BorderStyle.solid,
                            ),
                          ),
                          hintText: 'User Name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese su usuario';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Theme(
                      data: new ThemeData(
                        primaryColor: Color.fromRGBO(84, 87, 90, 0.5),
                        primaryColorDark: Color.fromRGBO(84, 87, 90, 0.5),
                        hintColor:
                            Color.fromRGBO(84, 87, 90, 0.5), //placeholder color
                      ),
                      child: TextFormField(
                        controller: pwdController,
                        obscureText: true,
                        decoration: InputDecoration(
                          focusedBorder: new OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(84, 87, 90, 0.5),
                              style: BorderStyle.solid,
                            ),
                          ),
                          enabledBorder: new OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(84, 87, 90, 0.5),
                              style: BorderStyle.solid,
                            ),
                          ),
                          errorBorder: new OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 1.0,
                              style: BorderStyle.solid,
                            ),
                          ),
                          border: new OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(84, 87, 90, 0.5),
                              style: BorderStyle.solid,
                            ),
                          ),
                          labelText: 'Contraseña',
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Color.fromRGBO(84, 87, 90, 0.5),
                          ),
                          hintText: 'Password',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese su contraseña';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () => {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {userLogin()}
                        },
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'Ingresar',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
