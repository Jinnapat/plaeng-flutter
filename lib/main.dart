import 'package:flutter/material.dart';
import 'lobby.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plaeng',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String username = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void handleUsernameChange(String inputName) {
    setState(() {
      username = inputName;
    });
  }

  void goToLobby() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Lobby(username: username))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Plaeng'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Enter your username to continue.'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
              child: TextFormField(
                onChanged: handleUsernameChange,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: 'your username',
                  border: OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'your username can\'t be empty';
                  }
                  return null;
                },
              ),
            ),
            ElevatedButton(onPressed: goToLobby, child: const Text('continue')),
          ],
        ),
      ),
    );
  }
}
