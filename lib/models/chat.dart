import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:telegram_clone/config/api.dart';
import 'package:telegram_clone/models/message.dart';
import 'package:telegram_clone/providers/auth.dart';

class Members {
  final String? name;
  final int? id;

  Members({
    required this.name,
    required this.id,
  });

  factory Members.fromJson(Map<String, dynamic> json) {
    return Members(
      name: json['name'] ?? null,
      id: json['id'] ?? null,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
      };
}

class Chat {
  final int id;
  final String? name;
  final String? subtitle;
  final String? time;
  final String? avatarUrl;
  final int? isGroup;

  final List<Message>? message;
  final List<Members>? members;

  Chat({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.time,
    required this.avatarUrl,
    required this.isGroup,
    required this.message,
    required this.members,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'] ?? null,
      name: json['name'] ?? null,
      subtitle: json['subtitle'] ?? null,
      time: json['time'] ?? null,
      avatarUrl: json['avatarUrl'] ?? null,
      isGroup: json['is_group'] ?? null,
      message: json['messages'] != null
          ? List<Message>.from(
              json['messages'].map((msg) => Message.fromJson(msg)))
          : null,
      members: json['members'] != null
          ? List<Members>.from(
              json['members'].map((member) => Members.fromJson(member)))
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'subtitle': subtitle,
        'time': time,
        'avatarUrl': avatarUrl,
        'is_group': isGroup,
        'message': message,
        'members': members,
      };

  static Future<List<Chat>> fetch() async {
    final userId = await AuthServices.getUserId();
    // final userId = 1;
    final response = await http.get(
      Uri.parse("${ApiServices.baseUrl}/chats/" + userId.toString()),
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Chat.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  static Future<void> addChat(String phone) async {
    final String? userId = await AuthServices.getUserId();
    final response = await http.post(
      Uri.parse("${ApiServices.baseUrl}/chats/createChat"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "phone": phone,
        "user_id": userId!,
      }),
    );

    final Map data = jsonDecode(response.body);

    if (data['status'] == 200) {
      return;
    } else {
      throw Exception(data['message']);
    }
  }

  static Future<String> upload(Uint8List file) async {
    final formData = FormData.fromMap({
      'photo': MultipartFile.fromBytes(
        file,
        filename: "upload.jpg",
      ),
    });

    var res = await Dio().post(
      '${ApiServices.baseUrl}/file/upload',
      data: formData,
    );

    if (res.statusCode == 200) {
      return res.data['photo'];
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  static Future<bool> send(Message message) async {
    final response = await http.post(
      Uri.parse("${ApiServices.baseUrl}/chats"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(message.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(response.body.toString());
    }
  }
}

void main() {
  runApp(
    MaterialApp(debugShowCheckedModeBanner: false, home: MyChat()),
  );
}

class MyChat extends StatefulWidget {
  const MyChat({super.key});

  @override
  State<MyChat> createState() => _MyChatState();
}

class _MyChatState extends State<MyChat> {
  final TextEditingController chatController = TextEditingController();
  List<Chat> _chats = [];
  List<Message> messages = [];

  FilePickerResult? photo;

  _fetch() async {
    List<Chat> chats = await Chat.fetch();
    setState(() {
      _chats = chats;
      messages = _chats[0].message!;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  @override
  void dispose() {
    chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _chats.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(_chats[index].avatarUrl!),
                  ),
                  title: Text(_chats[index].name!),
                  subtitle: Text(_chats[index].subtitle!),
                  trailing: Text(_chats[index].time!),
                  onTap: () {
                    setState(() {
                      messages = _chats[index].message!;
                    });
                  },
                );
              },
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.photo),
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();

                    if (result != null) {
                      setState(() {
                        photo = result;
                      });
                    }
                  },
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: chatController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Type a message',
                        ),
                      ),
                      if (photo != null)
                        Container(
                          height: 100,
                          child: Image.memory(
                            photo!.files.first.bytes!,
                            fit: BoxFit.cover,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) => const Center(
                        child: const CircularProgressIndicator(),
                      ),
                    );
                    try {
                      String? photoUrl = photo != null
                          ? await Chat.upload(photo!.files.first.bytes!)
                          : null;
                      await Chat.send(Message(
                        content: chatController.text,
                        user_id: "1",
                        chat_id: "1",
                        photo: photoUrl,
                        time: DateTime.now(),
                      ));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                        ),
                      );
                    } finally {
                      Navigator.pop(context);
                      chatController.clear();
                      setState(() {
                        photo = null;
                      });
                      _fetch();
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
