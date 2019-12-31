import 'package:epucc/login_page.dart';
import 'package:epucc/showDataSiswa.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    }
    // matikan loading
    setState(() {
      loadingMain = false;
    });
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
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.grey,
      onTap: _ontapBottomNav,
    );
    // == END PROPERTIES BOTTOM NAVBAR
    // == END PROPERTIES BOTTOM NAVBAR

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("E-PUCC MOBILE", style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              sharedPreferences.clear();
              // sharedPreferences.commit();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
            },
            child: Text("Log Out", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: (loadingMain) ? Center(child: CircularProgressIndicator()) : Container(
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text((sharedPreferences.getString("nama")) ?? "please login first"),
                  subtitle: Text(sharedPreferences.getString("jurusan") ?? "please login first"),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ),
        ),
      ),

      // == START DRAWER
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text("Welcome"),
              decoration: BoxDecoration(
                color: Colors.blue
              ),
            ),
            ListTile(
              title: Text("Master Data Siswa"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ShowDataSiswa();
                }));
              },
            ),
          ],
        ),
      ),

      // == START BOTTOM NAV
      bottomNavigationBar: _bottomnavbar,
    );
  }
}