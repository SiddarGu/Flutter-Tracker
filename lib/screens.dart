import 'package:flutter/material.dart';
import 'package:tracking/home_screen.dart';
import 'package:tracking/settings_screen.dart';
import 'package:tracking/item.dart';

class Screens {
  static List<Widget Function(List<Item>)> get screens => [
        (items) => HomeScreen(items: items),
      ];
}
