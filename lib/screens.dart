import 'package:flutter/material.dart';
import 'package:tracker/home_screen.dart';
import 'package:tracker/settings_screen.dart';
import 'package:tracker/item.dart';

class Screens {
  static List<Widget Function(List<Item>)> get screens => [
        (items) => HomeScreen(items: items),
      ];
}
