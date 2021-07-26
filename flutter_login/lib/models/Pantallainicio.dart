import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/models/buscador.dart';
import 'package:flutter_login/models/manga.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Manga>>? _listadomangas;

  Future<List<Manga>> _getManga() async {
    final response =
        await http.get(Uri.parse("https://api.jikan.moe/v3/top/manga//"));
    List<Manga> mangas = [];
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      print(jsonData["top"]);
      for (var item in jsonData["top"]) {
        mangas.add(Manga(item["title"], item["image_url"]));
      }
      return mangas;
    } else {
      throw Exception("paila mi papae");
    }
  }
  Future<List> Busqueda(query) async {
    final response =
        await http.get(Uri.parse("https://api.jikan.moe/v3/top/manga//"));
    List<Manga> mangas = [];
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      for (var item in jsonData["top"]) {
        mangas.add(Manga(item["title"], item["image_url"]));
      }
      return mangas;
    } else {
      throw Exception("paila mi papae");
    }
  }

  @override
  void initState() {
    super.initState();
    _listadomangas = _getManga();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
            onPressed: () {
              showSearch(context: context, delegate: BuscadorMan());
            },
            icon: Icon(Icons.search))
      ]),
      // No se proporciona ningún appbar al Scaffold, sólo un body con un
      // CustomScrollView
      body: FutureBuilder(
        future: _listadomangas,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: _listmangas(snapshot.data),
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  List<Widget> _listmangas(List<Manga> data) {
    List<Widget> mangas = [];
    for (var manga in data) {
      mangas.add(Card(
          child: Column(
        children: [
          Image.network(manga.url),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(manga.name),
          ),
        ],
      )));
    }
    return mangas;
  }
}
