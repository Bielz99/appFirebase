import 'package:app_firebase/components/menu_drawer.dart';
import 'package:app_firebase/models/hours_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({
    super.key,
    required this.user,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<HoursModel> listHours = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    // getHours();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Horas'),
      ),
      drawer: MenuDrawer(user: widget.user),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: (listHours.isEmpty)
          ? const Center(
              child: Text(
              'Nenhuma hora registrada',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
              ),
            ))
          : ListView(
              padding: const EdgeInsets.only(left: 4, right: 4),
              children: List.generate(listHours.length, (index) {
                HoursModel model = listHours[index];
                return Text(model.minutos.toString());
              }),
            ),
    );
  }
}
