import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.pink, Colors.indigo],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
          ),
        ),
        child: _isLoading ? Center(child: CircularProgressIndicator()) : ListView(
          children: <Widget>[
            headerSection(),
            textSection(),
            buttonSection(),
          ],
        ),
      ),
    );
  }

  signIn(String email, pass) async {
    print("login diproses..");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print("username = " + email + ", password = " + pass);

    // isi array data utk body endpoint login
    Map data = {
      'username': email,
      'password': pass
    };

    var jsonResponse;
    var response = await http.post("http://192.168.1.10:1399/simple_api_native/login.php", body: data);
    if(response.statusCode == 200) {
      // print("login berhasil..");
      jsonResponse = json.decode(response.body.toString());
      // print("Hasil response : "+ jsonResponse);
      if(jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });

        // cek kebenaran user dan psw
        if (jsonResponse['psw'] != 0) {
          // set shared preference
          sharedPreferences.setInt("token", jsonResponse['token']);
          sharedPreferences.setString("nama", jsonResponse['nama']);
          sharedPreferences.setString("nim", jsonResponse['nim']);
          sharedPreferences.setString("jurusan", jsonResponse['jurusan']);

          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MainPage()), (Route<dynamic> route) => false);
        } else {
          // user dan psw salah
          Alert(
            context: context,
            type: AlertType.error,
            title: "Warning",
            desc: "NIM atau password salah!",
            buttons: [
              DialogButton(
                color: Colors.blueAccent,
                child: Text(
                  "Tutup",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Navigator.pop(context),
                width: 120,
              )
            ],
          ).show();
        }
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      print("login gagal");
      print(response.body);
    }
  }

  Container buttonSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40.0,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(top: 15.0),
      child: RaisedButton(
        onPressed: emailController.text == "" || passwordController.text == "" ? null : () {
          setState(() {
            _isLoading = true;
          });
          signIn(emailController.text, passwordController.text);
        },
        elevation: 0.0,
        color: Colors.purple,
        child: Text("Sign In", style: TextStyle(color: Colors.white70)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: emailController,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Icon(Icons.email, color: Colors.white70),
              hintText: "NIM",
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
          SizedBox(height: 30.0),
          TextFormField(
            controller: passwordController,
            cursorColor: Colors.white,
            obscureText: true,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Icon(Icons.lock, color: Colors.white70),
              hintText: "Password",
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Container headerSection() {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // logo
          Image(
            color: Colors.white,
            width: 150.0,
            alignment: Alignment.center,
            image: AssetImage("assets/pucclogo.png"),
            fit: BoxFit.cover,
          ),
          SizedBox(height: 20.0),
          Text(
            "E-PUCC MOBILE",
            style: TextStyle(
              color: Colors.white,
              fontSize: 40.0,
              fontWeight: FontWeight.bold
            )
          ),
        ],
      ),
    );
  }
}