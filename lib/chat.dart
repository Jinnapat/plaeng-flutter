import 'package:flutter/material.dart';
import 'package:noise_meter/noise_meter.dart';
import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key, required this.username, required this.roomId});

  final String username;
  final String roomId;

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  bool _isRecording = false;
  NoiseReading? _latestReading;
  StreamSubscription<NoiseReading>? _noiseSubscription;
  NoiseMeter? _noiseMeter;
  List<String> chatHistory = [];
  List<String> chatSpeaker = [];
  late IO.Socket socket;

  void onError(Object error) {
    setState(() {
      _isRecording = false;
    });
  }

  void start() {
    try {
      _noiseSubscription = _noiseMeter?.noise.listen((noise) => {});
      setState(() {
        _isRecording = true;
      });
    } catch (err) {
      setState(() {
        _isRecording = false;
      });
    }
  }

  void stop() {
    try {
      _noiseSubscription?.cancel();
      setState(() {
        _isRecording = false;
      });
    } catch (err) {
      setState(() {
        _isRecording = false;
      });
    }
  }

  void addMessage(String speaker, String content) {
    setState(() {
      chatSpeaker.add(speaker);
      chatHistory.add(content);
    });
  }
  
  @override
  void initState() {
    super.initState();
    _noiseMeter = NoiseMeter(onError);

    socket = IO.io('https://8d8d-2403-6200-88a2-b453-1c70-28c5-f7e5-d2cb.ngrok-free.app');
    socket.onConnecting((data) { addMessage('', 'connecting');});

    socket.onError((data) => addMessage('', data.toString()));

    socket.onConnect((_) {
      addMessage('', 'connected to a server');
      socket.emit('join_room', [widget.username, widget.roomId]);
    });

    socket.onDisconnect((_) {
      addMessage('', 'disconnected from the server.');
    });

    socket.on('joined_room', (people) {
      for (var element in people) {addMessage('', '$element joined');}
    });

    socket.on('user_joined', (name) {
      addMessage('', '$name joined');
    });

    socket.on('user_disconnected', (name) {
      addMessage('', '$name left');
    });
  }

  @override
  void dispose() {
    _noiseSubscription?.cancel();
    chatHistory.clear();
    chatSpeaker.clear();
    socket.close();
    super.dispose();
  }

  Widget getContent() =>
        Container(
          margin: const EdgeInsets.all(20.0),
          child: ListView.builder(
              itemCount: chatHistory.length,
              semanticChildCount: chatHistory.length,
              clipBehavior: Clip.none,
              itemBuilder: (context, id) {
                return Container(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: ListTile(
                      title: Text(chatSpeaker[id]),
                      subtitle: Text(chatHistory[id]),
                      shape: const OutlineInputBorder(),
                    ));
              }),
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Plaeng"),
      ),
      body: getContent(),
      floatingActionButton: FloatingActionButton(
          backgroundColor: _isRecording ? Colors.red : Colors.green,
          onPressed: _isRecording ? stop : start,
          child: _isRecording ? const Icon(Icons.stop) : const Icon(Icons.mic)),
    );
  }
}
