import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:santaslist/models/little_bg_adapter.dart';
import 'package:santaslist/models/little_bg.dart';
import 'package:santaslist/repository/little_bg_repo.dart';

void main() async {
  // Initialize hive
  await Hive.initFlutter();
  Hive.registerAdapter(LittleBGAdapter());

  runApp(const SantasListApplication());
}

// We do this
class SantasListApplication extends StatelessWidget {
  const SantasListApplication({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Santa\'s List',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Santa\'s List'),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final LittleBgRepository repository = LittleBgRepository();
  List<LittleBG> _children = [];

  @override
  void initState() {
    super.initState();
    _initRepository();
    _loadChildren();
  }

  Future<void> _initRepository() async {
    await repository.init();
  }

  Future<void> _loadChildren() async {
    setState(() {
      _children = repository.getAllLittleBGs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _children.isEmpty
          ? const Center(child: Text('No children on the list yet.'))
          : ListView.builder(
              itemCount: _children.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_children[index].name),
                  onTap: () {
                    // Navigate to message thread for this child
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              String name = '';
              String profilePhotoPath = '';
              int age = 0;
              Gender gender = Gender.unspecified;

              return AlertDialog(
                title: const Text('Add Child'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                        onChanged: (value) => name = value,
                        decoration: const InputDecoration(hintText: 'Name')),
                    TextField(
                        onChanged: (value) => profilePhotoPath = value,
                        decoration: const InputDecoration(
                            hintText: 'Profile Photo Path')),
                    TextField(
                        onChanged: (value) => age = int.parse(value),
                        decoration: const InputDecoration(hintText: 'Age')),
                    DropdownButtonFormField<Gender>(
                      value:
                          gender, // Set the initial value to Gender.unspecified
                      onChanged: (value) {
                        setState(() {
                          gender = value!; // Update the selected gender
                        });
                      },
                      items: Gender.values
                          .map((gender) => DropdownMenuItem(
                                value: gender,
                                child: Text(gender
                                    .name), // Display the name of the gender
                              ))
                          .toList(),
                      decoration: const InputDecoration(hintText: 'Gender'),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final newChild =
                          LittleBG(name, profilePhotoPath, age, gender);
                      await repository.addLittleBG(newChild);
                      _loadChildren(); // Refresh the UI by reloading children
                      Navigator.pop(context);
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        tooltip: 'Add Child',
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
