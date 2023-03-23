import 'package:flutter/material.dart';
import 'package:tracker/item.dart';
import 'package:tracker/screens.dart';
import 'package:tracker/database.dart';

void main() {
  runApp(MaterialApp(
    title: 'Tracking',
    theme: ThemeData.dark(),
    home: const Tracking(),
  ));
}

class Tracking extends StatefulWidget {
  const Tracking({super.key});

  @override
  State<StatefulWidget> createState() => _TrackingState();
}

class _TrackingState extends State<Tracking> {
  int _currentIndex = 0;
  List<Item> _items = [];

  @override
  void initState() {
    super.initState();
    _getItemsFromDatabase();
  }

  Future<void> _getItemsFromDatabase() async {
    List<Item> items = await DatabaseProvider.dbProvider.getItems();
    setState(() {
      _items = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracker'),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: Screens.screens.map((screen) => screen(_items)).toList(),
      ),
      /* bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: 'Tracking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ), */
    );
  }
}
