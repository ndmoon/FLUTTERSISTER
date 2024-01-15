import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'mahasiswa/mahasiswa.dart';
import 'matakuliah/matakuliah.dart';
import 'nilai/nilai.dart';

class MenuOption extends StatefulWidget {
  const MenuOption({super.key});

  @override
  State<MenuOption> createState() => _MenuOptionState();
}

class _MenuOptionState extends State<MenuOption> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Service",
            style: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(
              top: 20,
              bottom: 30,
            ),
            child: Center(
                child: Text(
              "Sistem Terdistribusi",
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.green,
                  fontWeight: FontWeight.bold),
            )),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    if (index == 0) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DataMahasiswa()));
                    } else if (index == 1) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DataMatakuliah()));
                    } else if (index == 2) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DataNilai()));
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    margin: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          index == 0
                              ? Icons.person_sharp
                              : (index == 1
                                  ? Icons.book_rounded
                                  : Icons.pin_rounded),
                          color: Colors.green,
                          size: 30.0,
                        ),
                        Text(
                          index == 0
                              ? 'Mahasiswa'
                              : (index == 1 ? 'Matakuliah' : 'Nilai'),
                          style: const TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.home,
                color: Colors.black,
                size: 35,
              ),
            ),
          )
        ],
      ),
    );
  }
}
