import 'dart:convert';
import 'package:epucc/siswaModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShowDataSiswa extends StatefulWidget {
  @override
  _ShowDataSiswaState createState() => _ShowDataSiswaState();
}

class _ShowDataSiswaState extends State<ShowDataSiswa> {
  SiswaModel dataSiswa;

  @override
  void initState() {
    super.initState();
    // memanggil method fetchData();
    fetchData();
  }

  fetchData() async {
    var respon = await http.get("http://192.168.1.10:1399/simple_api_native/trans.php?page=1");
    // print(respon.body);
    var decodedJson = jsonDecode(respon.body);
    dataSiswa = SiswaModel.fromJson(decodedJson);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      // body: (dataSiswa == null) ? Center(child: CircularProgressIndicator()) : Listview.count(
      //   crossAxisCount: 1, 
      //   children: dataSiswa.dataSiswa.map((dsw) => 
      //     Padding(
      //       padding: const EdgeInsets.all(1.0),
      //       child: Text(dsw.nama)
      //     )
      //   ).toList()
      // ),

      // body: ListView.builder(
      //   itemCount: dataSiswa.dataSiswa.length,
      //   itemBuilder: (BuildContext ctxt, int index) {
      //     return Text(dataSiswa.dataSiswa[index].nama);
      //   },
      // ),

      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text("Data Siswa"),
      ),
      body: (dataSiswa == null) ? Center(child: CircularProgressIndicator()) : DataTable(
        columnSpacing: 20.0,
        columns: [
          DataColumn(label: Text("NIM")),
          DataColumn(label: Text("Nama")),
        ],
        rows: 
          dataSiswa.dataSiswa.map((dsw) => 
            DataRow(
              cells: [
                DataCell(Text(dsw.nim)),
                DataCell(Text(dsw.jurusan)),
              ]
            )
          ).toList(),
      ),
    );
  }
}