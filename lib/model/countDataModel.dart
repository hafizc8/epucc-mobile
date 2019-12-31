// To parse this JSON data, do
//
//     final countDataModel = countDataModelFromJson(jsonString);

import 'dart:convert';

CountDataModel countDataModelFromJson(String str) => CountDataModel.fromJson(json.decode(str));

String countDataModelToJson(CountDataModel data) => json.encode(data.toJson());

class CountDataModel {
    DateTime tglUpdate;
    String jumlahSiswa;
    String jumlahMapel;

    CountDataModel({
        this.tglUpdate,
        this.jumlahSiswa,
        this.jumlahMapel,
    });

    factory CountDataModel.fromJson(Map<String, dynamic> json) => CountDataModel(
        tglUpdate: DateTime.parse(json["tgl_update"]),
        jumlahSiswa: json["jumlah_siswa"],
        jumlahMapel: json["jumlah_mapel"],
    );

    Map<String, dynamic> toJson() => {
        "tgl_update": tglUpdate.toIso8601String(),
        "jumlah_siswa": jumlahSiswa,
        "jumlah_mapel": jumlahMapel,
    };
}