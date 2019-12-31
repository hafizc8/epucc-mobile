// To parse this JSON data, do
//
//     final siswaModel = siswaModelFromJson(jsonString);

import 'dart:convert';

SiswaModel siswaModelFromJson(String str) => SiswaModel.fromJson(json.decode(str));

String siswaModelToJson(SiswaModel data) => json.encode(data.toJson());

class SiswaModel {
    String pages;
    DateTime tglUpdate;
    List<DataSiswa> dataSiswa;

    SiswaModel({
        this.pages,
        this.tglUpdate,
        this.dataSiswa,
    });

    factory SiswaModel.fromJson(Map<String, dynamic> json) => SiswaModel(
        pages: json["pages"],
        tglUpdate: DateTime.parse(json["tgl_update"]),
        dataSiswa: List<DataSiswa>.from(json["data_siswa"].map((x) => DataSiswa.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "pages": pages,
        "tgl_update": tglUpdate.toIso8601String(),
        "data_siswa": List<dynamic>.from(dataSiswa.map((x) => x.toJson())),
    };
}

class DataSiswa {
    String id;
    String nama;
    String nim;
    String jurusan;

    DataSiswa({
        this.id,
        this.nama,
        this.nim,
        this.jurusan,
    });

    factory DataSiswa.fromJson(Map<String, dynamic> json) => DataSiswa(
        id: json["id"],
        nama: json["nama"],
        nim: json["nim"],
        jurusan: json["jurusan"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "nim": nim,
        "jurusan": jurusan,
    };
}
