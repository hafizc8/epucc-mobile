import 'dart:convert';

import 'package:epucc/login_page.dart';
import 'package:epucc/model/countDataModel.dart';
import 'package:epucc/showDataSiswa.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "E-PUCC MOBILE",
      debugShowCheckedModeBanner: false,
      home: MainPage(),
      theme: ThemeData(
        accentColor: Colors.white70
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  SharedPreferences sharedPreferences;
  bool loadingMain = true;
  int _selectedIndex = 0;
  CountDataModel countData;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  // method utk bottom navigasi
  void _ontapBottomNav(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getInt("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
    } else {
      getCountData();
    }
    // matikan loading
    setState(() {
      loadingMain = false;
    });
  }

  getCountData() async {
    var respon = await http.get("http://192.168.1.10:1399/simple_api_native/get_count_data.php");
    // print(respon.body);
    var decodedJson = jsonDecode(respon.body);
    countData = CountDataModel.fromJson(decodedJson);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    // == START PROPERTIES BOTTOM NAVBAR
    // == START PROPERTIES BOTTOM NAVBAR
    // isi route bottom navbar
    final _listPage = <Widget> [
      Text("Halaman Home"),
      Text("Halaman Favorite"),
      Text("Halaman Profile"),
    ];

    // isi bottom navbar
    final _bottomNavbarItems = <BottomNavigationBarItem> [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: SizedBox.shrink()
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.favorite),
        title: SizedBox.shrink()
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        title: SizedBox.shrink()
      ),
    ];

    final _bottomnavbar = BottomNavigationBar(
      items: _bottomNavbarItems,
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.blueGrey,
      onTap: _ontapBottomNav,
      backgroundColor: Color.fromRGBO(64, 80, 105, 1.0),
      elevation: 5.0,
    );
    // == END PROPERTIES BOTTOM NAVBAR
    // == END PROPERTIES BOTTOM NAVBAR

    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromRGBO(64, 80, 105, 1.0),
        title: Text("E-PUCC MOBILE", style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          // FlatButton(
          //   onPressed: () {
          //     sharedPreferences.clear();
          //     // sharedPreferences.commit();
          //     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
          //   },
          //   // child: Text("Log Out", style: TextStyle(color: Colors.white)),
          //   // child: Icon(Icons.power_settings_new, color: Colors.white),
          // ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: (loadingMain) ? Center(child: CircularProgressIndicator()) : Container(
          child: Column(
            children: <Widget>[
              // CARD UTK PROFILE
              Card(
                elevation: 8.0,
                color: Color.fromRGBO(64, 80, 105, 1.0),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  leading: Container(
                      padding: EdgeInsets.only(right: 12.0),
                      decoration: new BoxDecoration(
                          border: new Border(
                              right: new BorderSide(width: 1.0, color: Colors.white24)
                          )
                      ),
                      child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(
                    (sharedPreferences.getString("nama")) ?? "please login first", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Row(
                      children: <Widget>[
                        Icon(Icons.linear_scale, color: Colors.yellowAccent),
                        Text((sharedPreferences.getString("jurusan")) ?? "please login first", style: TextStyle(color: Colors.white))
                      ],
                  ),
                  trailing: GestureDetector(
                    child: Icon(Icons.power_settings_new, color: Colors.white, size: 30.0),
                    onTap: () {
                      sharedPreferences.clear();
                      // sharedPreferences.commit();
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
                    }
                  )
                ),
              ),

              SizedBox(height: 30.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(alignment: Alignment.centerLeft, child: Text("Menu Dashboard", style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w400))),
              ),

              // CARD UTK MENU SISWA
              GestureDetector(
                child: Card(
                  elevation: 8.0,
                  color: Color.fromRGBO(64, 80, 105, 1.0),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    leading: Container(
                        padding: EdgeInsets.only(right: 12.0),
                        decoration: new BoxDecoration(
                            border: new Border(
                                right: new BorderSide(width: 1.0, color: Colors.white24)
                            )
                        ),
                        child: Icon(Icons.bookmark, color: Colors.white),
                    ),
                    title: Text(
                      "Master Siswa", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Row(
                        children: <Widget>[
                          Text(countData.jumlahSiswa == null ? "loading.." : "${countData.jumlahSiswa} Orang", style: TextStyle(color: Colors.white))
                        ],
                    ),
                    trailing: Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0)
                  ),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ShowDataSiswa();
                  }));
                },
              ),

              // CARD UTK MENU MAPEL
              GestureDetector(
                child: Card(
                  elevation: 8.0,
                  color: Color.fromRGBO(64, 80, 105, 1.0),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    leading: Container(
                        padding: EdgeInsets.only(right: 12.0),
                        decoration: new BoxDecoration(
                            border: new Border(
                                right: new BorderSide(width: 1.0, color: Colors.white24)
                            )
                        ),
                        child: Icon(Icons.bookmark, color: Colors.white),
                    ),
                    title: Text(
                      "Master Mata Pelajaran", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Row(
                        children: <Widget>[
                          Text((countData.jumlahMapel == null) ? "loading.." : "${countData.jumlahMapel} Mata Pelajaran", style: TextStyle(color: Colors.white))
                        ],
                    ),
                    trailing: Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0)
                  ),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ShowDataSiswa();
                  }));
                },
              ),
            ],
          ),
        ),
      ),

      // == START DRAWER
      // drawer: Drawer(
      //   child: ListView(
      //     children: <Widget>[
      //       DrawerHeader(
      //         child: Text("Welcome"),
      //         decoration: BoxDecoration(
      //           color: Colors.blue
      //         ),
      //       ),
      //       ListTile(
      //         title: Text("Master Data Siswa"),
      //         trailing: Icon(Icons.arrow_forward_ios),
      //         onTap: (){
      //           Navigator.push(context, MaterialPageRoute(builder: (context) {
      //             return ShowDataSiswa();
      //           }));
      //         },
      //       ),
      //     ],
      //   ),
      // ),

      // == START BOTTOM NAV
      bottomNavigationBar: _bottomnavbar,
    );
  }
}