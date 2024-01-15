// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class UpdateMatakuliah extends StatefulWidget {
  int idup;
  String kodeup;
  String namaup;
  String sksup;
  UpdateMatakuliah(this.idup, this.kodeup, this.namaup, this.sksup);

  @override
  State<UpdateMatakuliah> createState() => _UpdateMatakuliahState();
}

class _UpdateMatakuliahState extends State<UpdateMatakuliah> {
  int id = 0;
  final kode = TextEditingController();
  final nama = TextEditingController();
  final sks = TextEditingController();

  @override
  void initState() {
    kode.text = widget.kodeup;
    nama.text = widget.namaup;
    sks.text = widget.sksup;
    id = widget.idup;

    super.initState();
  }

  bool isNumeric(String str) {
    // ignore: unnecessary_null_comparison
    if (str == null || str.isEmpty) {
      return false;
    }
    final format = RegExp(r'^[0-9]+$');
    return format.hasMatch(str);
  }

  Future<void> updateMatakuliah() async {
    if (isNumeric(sks.text)) {
      String urlUpdate = "http://192.168.26.232:9004/api/v1/matakuliah/${id}";
      try {
        var response = await http.put(
          Uri.parse(urlUpdate),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(
            {
              "kode": kode.text,
              "nama": nama.text,
              "sks": sks.text,
            },
          ),
        );

        if (response.statusCode == 200) {
          Navigator.pop(context);
        } else {
          print(response.statusCode);
        }
      } catch (e) {
        print(e);
      }
    } else {
      print("Bukan Angka");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Data Matakuliah"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 100, 0, 0),
          width: 800,
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: "Kode",
                  hintText: "Ketikkan Kode Matakuliah",
                  prefixIcon: Icon(
                    Icons.code,
                    color: Colors.green,
                  ),
                  fillColor: Colors.green.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                controller: kode,
              ),
              SizedBox(height: 10),
              TextField(
                controller: nama,
                decoration: InputDecoration(
                  labelText: "Nama",
                  hintText: "Ketikkan Nama Matakuliah",
                  prefixIcon: Icon(
                    Icons.book_rounded,
                    color: Colors.green,
                  ),
                  fillColor: Colors.green.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: sks,
                decoration: InputDecoration(
                  labelText: "SKS",
                  hintText: "Ketikkan Jumlah SKS",
                  prefixIcon: Icon(
                    Icons.numbers_rounded,
                    color: Colors.green,
                  ),
                  fillColor: Colors.green.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 50,
                width: 200,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                  ),
                  onPressed: () {
                    updateMatakuliah();
                  },
                  child: Text(
                    "SIMPAN",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
