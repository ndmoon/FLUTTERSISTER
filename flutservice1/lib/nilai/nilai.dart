// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'updateNilai.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'insertNilai.dart';

class DataNilai extends StatefulWidget {
  const DataNilai({super.key});

  @override
  State<DataNilai> createState() => _DataNilaiState();
}

class _DataNilaiState extends State<DataNilai> {
  List<Map<String, dynamic>> namaMahasiswa = [];
  List<Map<String, dynamic>> namaMatakuliah = [];
  List listNilai = [];

  @override
  void initState() {
    allNilai();
    getMahasiswa();
    getMatakuliah();
    super.initState();
  }

  Future<void> getMahasiswa() async {
    String urlMahasiswa = "http://192.168.26.232:9005/api/v1/mahasiswa";
    try {
      var response = await http.get(Uri.parse(urlMahasiswa));
      final List<dynamic> dataMhs = jsonDecode(response.body);
      setState(
        () {
          namaMahasiswa = List.from(dataMhs);
        },
      );
    } catch (exc) {
      print(exc);
    }
  }

  Future<void> getMatakuliah() async {
    String urlMatakuliah = "http://192.168.26.232:9006/api/v1/matakuliah";
    try {
      var response = await http.get(Uri.parse(urlMatakuliah));
      final List<dynamic> dataMk = jsonDecode(response.body);
      setState(
        () {
          namaMatakuliah = List.from(dataMk);
        },
      );
    } catch (exc) {
      print(exc);
    }
  }

  Future<void> allNilai() async {
    String urlNilai = "http://192.168.26.232:9004/api/v1/nilai";
    try {
      var response = await http.get(Uri.parse(urlNilai));
      print('Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        setState(
          () {
            listNilai = jsonDecode(response.body);
          },
        );
      } else {
        print("Failed to fetch data");
      }
    } catch (exc) {
      print(exc);
    }
  }

  Future<void> deleteNilai(int id) async {
    String urlNilai = "http://192.168.26.232:9004/api/v1/nilai/${id}";
    try {
      var response = await http.delete(Uri.parse(urlNilai));
      if (response.statusCode == 200) {
        print("Data deleted successfully");
        allNilai(); // Update the state after deletion
      } else {
        print(
            "Failed to delete data with ID: $id. Server responded with status code ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (exc) {
      print(exc);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Data Nilai",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        actions: [
          // IconButton(
          //   tooltip: "Tambah Data",
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => InsertNilai(),
          //       ),
          //     ).then(
          //       (value) {
          //         allNilai();
          //       },
          //     );
          //   },
          //   icon: Icon(
          //     Icons.add,
          //     size: 30,
          //     color: Colors.white,
          //   ),
          // )
        ],
      ),
      body: listNilai.isEmpty
          ? Center(
              child: Text(
                'Tidak ada data',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                    fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              itemCount: listNilai.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(5),
                  child: ListTile(
                    leading: Icon(
                      Icons.pin_outlined,
                      color: Colors.green.shade300,
                      size: 24,
                    ),
                    title: Text(
                      "${namaMahasiswa.firstWhere((mahasiswa) => mahasiswa["id"] == listNilai[index]["mahasiswa_id"], orElse: () => {})["nama"] ?? ""}",
                      style: TextStyle(
                          color: Colors.green.shade400,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Matakuliah: ${namaMatakuliah.firstWhere((matakuliah) => matakuliah["id"] == listNilai[index]["matakuliah_id"], orElse: () => {})["nama"] ?? ""}\nNilai: ${listNilai[index]["nilai"]}",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.normal),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: "Hapus Data",
                          onPressed: () {
                            deleteNilai(listNilai[index]["id"]);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red.shade400,
                            size: 24,
                          ),
                        ),
                        IconButton(
                          tooltip: "Edit Data",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateNilai(
                                  listNilai[index]["id"],
                                  listNilai[index]["mahasiswa_id"],
                                  listNilai[index]["matakuliah_id"],
                                  listNilai[index]["nilai"],
                                ),
                              ),
                            ).then((value) => allNilai());
                          },
                          icon: Icon(
                            Icons.edit_document,
                            color: Colors.pink.shade800,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const InsertNilai(),
            ),
          ).then((value) => allNilai());
        },
        splashColor: Colors.green,
        backgroundColor: Colors.green.shade200,
        child: const Icon(
          Icons.add,
          size: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}
