import 'package:flutter/material.dart';
import 'package:tracker/item.dart';
import 'package:tracker/database.dart';

class SettingsScreen extends StatefulWidget {
  List<Item> items;

  SettingsScreen({Key? key, required this.items}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (BuildContext context, int index) {
          Item item = widget.items[index];

          return Dismissible(
            key: Key(item.id.toString()),
            direction: DismissDirection.horizontal,
            onDismissed: (direction) async {
              await DatabaseProvider.dbProvider.deleteItem(item.id);
              setState(() {
                widget.items.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Deletion successful!'),
                  behavior: SnackBarBehavior.floating,
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      setState(() {
                        widget.items.insert(index, item);
                        DatabaseProvider.dbProvider.addItem(item);
                      });
                    },
                  ),
                ),
              );
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            child: ListTile(
              title: Text(item.description),
              subtitle: Text('days'),
            ),
          );
        },
      );
  }
}
