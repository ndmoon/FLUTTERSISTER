import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'insertmahasiswa.dart';
import 'updatemahasiswa.dart';
import 'package:flutservice1/nilai/nilaiMahasiswa.dart';

class DataMahasiswa extends StatefulWidget {
  const DataMahasiswa({super.key});

  @override
  State<DataMahasiswa> createState() => _DataMahasiswaState();
}

class _DataMahasiswaState extends State<DataMahasiswa> {
  List listMahasiswa = [];

  @override
  void initState() {
    allMahasiswa();
    super.initState();
  }

  Future<void> allMahasiswa() async {
    String urlMahasiswa = "http://192.168.26.232:9005/api/v1/mahasiswa";

    // String urlMahasiswa = "http://192.168.18.17:9005/api/v1/mahasiswa";
    try {
      var response = await http.get(Uri.parse(urlMahasiswa));
      listMahasiswa = jsonDecode(response.body);
      setState(() {
        listMahasiswa = jsonDecode(response.body);
      });
    } catch (exc) {
      print(exc);
    }
  }

  Future<void> deleteMahasiwa(int id) async {
    String urlMahasiswa = "http://192.168.26.232:9005/api/v1/mahasiswa/${id}";
    try {
      await http.delete(Uri.parse(urlMahasiswa));
      setState(() {
        allMahasiswa();
      });
    } catch (exc) {
      print(exc);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Mahasiswa"),
        backgroundColor: Colors.green,
        actions: [
          // IconButton(
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const InsertMahasiswa(),
          //       ),
          //     ).then((value) => allMahasiswa());
          //   },
          //   icon: const Icon(
          //     Icons.add,
          //     size: 30,
          //   ),
          // )
        ],
      ),
      body: listMahasiswa.isEmpty
          ? const Center(
              child: Text(
                'Tidak ada data',
                style: TextStyle(fontSize: 20),
              ),
            )
          : ListView.builder(
              itemCount: listMahasiswa.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(5),
                  child: ListTile(
                    leading: const Icon(
                      Icons.person_outline_rounded,
                      color: Colors.green,
                      size: 24,
                    ),
                    title: Text(
                      listMahasiswa[index]["nama"]?.toString() ?? "",
                      style: const TextStyle(
                          color: Colors.green,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "${listMahasiswa[index]["email"]?.toString() ?? ""}\n${listMahasiswa[index]["tgllahir"]?.toString() ?? ""}",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.normal),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            tooltip: "Lihat Nilai",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NilaiMahasiswa(
                                    listMahasiswa[index]["id"],
                                  ),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.pin_rounded,
                              color: Colors.yellow.shade600,
                              size: 24,
                            )),
                        IconButton(
                          tooltip: "Hapus Data",
                          onPressed: () {
                            deleteMahasiwa(listMahasiswa[index]["id"]);
                          },
                          icon: Icon(
                            Icons.delete_outline,
                            color: Colors.red.shade600,
                            size: 24,
                          ),
                        ),
                        IconButton(
                          tooltip: "Edit Data",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return UpdateMahasiswa(
                                    listMahasiswa[index]["id"] ?? 0,
                                    listMahasiswa[index]["nama"] ?? "",
                                    listMahasiswa[index]["email"] ?? "",
                                    listMahasiswa[index]["tgllahir"] != null
                                        ? DateTime.parse(
                                            listMahasiswa[index]["tgllahir"])
                                        : DateTime.now(),
                                  );
                                },
                              ),
                            ).then((value) => allMahasiswa());
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
              builder: (context) => const InsertMahasiswa(),
            ),
          ).then((value) => allMahasiswa());
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
