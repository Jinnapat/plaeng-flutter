import 'package:flutter/material.dart';
import 'chat.dart';

class Lobby extends StatefulWidget {
  const Lobby({super.key, required this.username});

  final String username;

  @override
  State<Lobby> createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> {
  String roomId = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void goToChat(String roomId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ChatRoom(username: widget.username, roomId: roomId)));
  }

  void openDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Enter room id'),
              content: Form(
                  key: _formKey,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: 'room id',
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'room id can\'t be empty';
                      }
                      return null;
                    },
                  )),
              actions: [
                ElevatedButton(
                    onPressed: () => {Navigator.pop(context)},
                    child: const Text('back')),
                ElevatedButton(
                    onPressed: () => {if (_formKey.currentState!.validate()) {goToChat(roomId)}},
                    child: const Text('join')),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Plaeng'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Hello, ${widget.username}!',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 30.0),
                child: Text(
                    'you can create a new room or join existing room with its room id to continue.',
                    textAlign: TextAlign.center),
              ),
              ElevatedButton(
                  onPressed: () => {goToChat('')},
                  child: const Text('create a room')),
              ElevatedButton(
                  onPressed: openDialog, child: const Text('join a room')),
            ],
          ),
        ));
  }
}
