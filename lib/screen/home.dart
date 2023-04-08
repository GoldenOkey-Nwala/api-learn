import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/user.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<User> users = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Rest API'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          final name = user.name;
          final color = user.gender == 'male' ? Colors.blue : Colors.pink;
          return ListTile(
            title: Text(name.first),
            subtitle: Text(user.phone),
            tileColor: color,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchUser,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> fetchUser() async {
    print('Button got clicked.');
    const url = 'https://randomuser.me/api/?results=20';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    final results = json['results'] as List<dynamic>;

    final transformed = results.map((e) {
      final name = UserName(
        title: e['name']['title'],
        first: e['name']['first'],
        last: e['name']['last'],
      );
      return User(
        gender: e['gender'],
        email: e['email'],
        phone: e['phone'],
        cell: e['cell'],
        nat: e['nat'],
        name: name,
      );
    }).toList();
    setState(() {
      users = transformed;
    });
    print('fetchUsers completed');
  }
}
