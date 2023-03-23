import 'package:flutter/material.dart';
import 'package:tracking/item.dart';
import 'package:tracking/database.dart';

class HomeScreen extends StatefulWidget {
  List<Item> items;

  HomeScreen({Key? key, required this.items}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _getItemsFromDatabase();
  }

  Future<void> _getItemsFromDatabase() async {
    List<Item> items = await DatabaseProvider.dbProvider.getItems();
    setState(() {
      widget.items = items;
    });
  }

  Future<void> _showAddItemDialog(BuildContext context) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController trackingController = TextEditingController();

    nameController.text = '';
    trackingController.text = '';

    StatefulBuilder addItemDialog() {
      const List<String> carriers = <String>['USPS', 'UPS', 'FedEx'];
      String carrierSelected = carriers.first;
      return StatefulBuilder(builder: (context, _setter) {
        return AlertDialog(
          title: const Text('Add New Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
                  Widget>[
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.local_shipping),
                  ),
                  hint: Text('Please choose account type'),
                  value: carrierSelected,
                  onChanged: (String? value) {
                    _setter(() {
                      carrierSelected = value!;
                    });
                    setState(() {
                      carrierSelected = value!;
                    });
                  },
                  items: carriers.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Center(
                          child: Text(
                        value,
                        textAlign: TextAlign.center,
                      )),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.subject),
                      border: OutlineInputBorder(
                        //Outline border type for TextFeild
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                          color: Colors.redAccent,
                          width: 3,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                          //Outline border type for TextFeild
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(
                            color: Colors.greenAccent,
                            width: 3,
                          ))),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: trackingController,
                  decoration: const InputDecoration(
                    labelText: 'Tracking Number',
                    prefixIcon: Icon(Icons.numbers),
                    border: OutlineInputBorder(
                      //Outline border type for TextFeild
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(
                        color: Colors.redAccent,
                        width: 3,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                        //Outline border type for TextFeild
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                          color: Colors.greenAccent,
                          width: 3,
                        )),
                  ),
                ),
              ])
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String trackingId = trackingController.text;
                String name = nameController.text;
                if (trackingId.isNotEmpty) {
                  Item newItem = Item(
                    id: widget.items.length + 1,
                    description: name,
                    trackingId: trackingId,
                    carrier: carrierSelected,
                  );
                  await DatabaseProvider.dbProvider.addItem(newItem);
                  _getItemsFromDatabase();
                  if (!mounted) return;
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      });
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return addItemDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
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
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ItemScreen(item: item)));
              },
              child: Card(
                child: ListTile(
                  title: Text(item.description),
                  subtitle: Text(item.trackingId),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await _showAddItemDialog(context);
          },
          tooltip: 'Add Item',
          label: const Text('Add Item'),
          icon: const Icon(Icons.post_add)),
    );
  }
}

class ItemScreen extends StatelessWidget {
  final Item item;

  ItemScreen({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Description: ${item.description}'),
            Text('Tracking ID: ${item.trackingId}'),
            Text('Carrier: ${item.carrier}'),
            // Add more fields as needed
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.pop(context);
    
      },
      child: Icon(Icons.refresh),
    ));
  }
}
