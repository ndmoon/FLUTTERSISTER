import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class UpdateMahasiswa extends StatefulWidget {
  int idup;
  String namaup;
  String emailup;
  DateTime tgllahirup;
  UpdateMahasiswa(this.idup, this.namaup, this.emailup, this.tgllahirup,
      {super.key});

  @override
  State<UpdateMahasiswa> createState() => _UpdateMahasiswaState();
}

class _UpdateMahasiswaState extends State<UpdateMahasiswa> {
  int id = 0;
  final nama = TextEditingController();
  final email = TextEditingController();
  DateTime tgllahir = DateTime.now();

  @override
  void initState() {
    nama.text = widget.namaup;
    email.text = widget.emailup;
    tgllahir = widget.tgllahirup;
    id = widget.idup;

    super.initState();
  }

  Future<void> _pilihTgl(BuildContext context) async {
    final DateTime? kalender = await showDatePicker(
        context: context,
        initialDate: tgllahir,
        firstDate: DateTime(1990),
        lastDate: DateTime(2025));

    if (kalender != null && kalender != tgllahir) {
      setState(() {
        tgllahir = kalender;
      });
    }
  }

  Future<void> updateMahasiswa() async {
    String urlInsert = "http://192.168.26.232:9001/api/v1/mahasiswa/${id}";

    try {
      var response = await http.put(Uri.parse(urlInsert),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "nama": nama.text,
            "email": email.text,
            "tgllahir": "${tgllahir.toLocal()}".split(" ")[0],
          }));

      if (response.statusCode == 200) {
        Navigator.pop(context);
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Data Mahasiswa"),
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
                controller: nama,
                decoration: InputDecoration(
                  labelText: "Nama",
                  hintText: "Ketikkan Nama",
                  prefixIcon: Icon(
                    Icons.person_sharp,
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
                controller: email,
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "Ketikkan Email",
                  prefixIcon: Icon(
                    Icons.email_rounded,
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
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Tanggal Lahir",
                  hintText: "Pilih Tanggal Lahir",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fillColor: Colors.green.shade200,
                  prefixIcon: Icon(
                    Icons.calendar_month_rounded,
                    color: Colors.green,
                  ),
                ),
                onTap: () => _pilihTgl(context),
                controller: TextEditingController(
                  text: "${tgllahir.toLocal()}".split(" ")[0],
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
                  onPressed: () => updateMahasiswa(),
                  child: Text(
                    "SIMPAN",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
