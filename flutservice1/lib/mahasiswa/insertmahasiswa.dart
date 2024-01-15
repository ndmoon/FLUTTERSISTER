import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InsertMahasiswa extends StatefulWidget {
  const InsertMahasiswa({super.key});

  @override
  State<InsertMahasiswa> createState() => _InsertMahasiswaState();
}

class _InsertMahasiswaState extends State<InsertMahasiswa> {
  final nama = TextEditingController();
  final email = TextEditingController();
  String namaMahasiswa = "";
  String emailMahasiswa = "";
  DateTime tgllahir = DateTime.now();

  Future<void> _pilihTgl(BuildContext context) async {
    final DateTime? kalender = await showDatePicker(
        context: context,
        initialDate: tgllahir,
        firstDate: DateTime(1950),
        lastDate: DateTime(2030));

    if (kalender != null && kalender != tgllahir) {
      setState(() {
        tgllahir = kalender;
      });
    }
  }

  Future<void> insertMahasiswa() async {
    String urlInsert = "http://192.168.26.232:9005/api/v1/mahasiswa";
    final Map<String, dynamic> data = {
      "nama": namaMahasiswa,
      "email": emailMahasiswa,
      "tglLahir": '${tgllahir.toLocal()}'.split(' ')[0]
    };

    try {
      var response = await http.post(Uri.parse(urlInsert),
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        Navigator.pop(context, "berhasil ditambahkan");
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
        title: const Text("Insert Data Mahasiswa"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 100, 0, 0),
          width: 800,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: "Nama",
                  hintText: "Ketikkan Nama",
                  prefixIcon: const Icon(
                    Icons.edit,
                    color: Colors.green,
                  ),
                  fillColor: Colors.green.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                controller: nama,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: email,
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "Ketikkan Email",
                  prefixIcon: const Icon(
                    Icons.email_rounded,
                    color: Colors.green,
                  ),
                  fillColor: Colors.green.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Tanggal Lahir",
                  hintText: "Pilih Tanggal Lahir",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fillColor: Colors.green.shade200,
                  prefixIcon: const Icon(
                    Icons.calendar_month_rounded,
                    color: Colors.green,
                  ),
                ),
                onTap: () => _pilihTgl(context),
                controller: TextEditingController(
                  text: "${tgllahir.toLocal()}".split(" ")[0],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                width: 200,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                  ),
                  onPressed: () {
                    setState(() {
                      namaMahasiswa = nama.text;
                      emailMahasiswa = email.text;
                    });
                    insertMahasiswa();
                  },
                  child: const Text(
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
