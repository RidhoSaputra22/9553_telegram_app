import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telegram_clone/models/message.dart';
import 'package:telegram_clone/providers/auth.dart';

import 'web_profile_screen.dart';

import '../models/chat.dart';
import 'dart:typed_data';
import 'package:dio/dio.dart';

class WebHomeScreen extends StatefulWidget {
  const WebHomeScreen({super.key});

  @override
  State<WebHomeScreen> createState() => _WebHomeScreenState();
}

class _WebHomeScreenState extends State<WebHomeScreen> {
  // Tambahkan variabel untuk menyimpan file yang dipilih
  final TextEditingController messageController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final TextEditingController _addChatController = TextEditingController();
  final TextEditingController _addChatNameController = TextEditingController();

  FilePickerResult? _pickedFile;

  String _searchQuery = '';
  bool isLoading = true;
  List<Chat> chats = [];
  Chat? selectedChat;

  String? userId;

  bool isFirstInit = false;

  _loadChat() async {
    List<Chat> _chats = await Chat.fetch();

    setState(() {
      isLoading = false;
      chats = _chats;
      selectedChat = _chats[0];
    });
  }

  _loadUserId() async {
    String? _userId = await AuthServices.getUserId();

    setState(() {
      userId = _userId;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadChat();
    _loadUserId();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : chats.isEmpty
              ? const Center(
                  child: Text(
                    'No Chats',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                )
              : Row(
                  children: [
                    Container(
                      width: 360,
                      color: const Color(0xFF2C2C2C),
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                color: const Color(0xFF2C2C2C),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.menu,
                                          color: Colors.white),
                                      onPressed: () {
                                        showMenu<void>(
                                          context: context,
                                          position: RelativeRect.fromLTRB(
                                              0, 60, 0, 0),
                                          color: const Color(0xFF2C2C2C)
                                              .withOpacity(0.8),
                                          items: <PopupMenuEntry<void>>[
                                            PopupMenuItem<void>(
                                              height: 40,
                                              onTap: () {
                                                Navigator.pop(context);
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const WebProfileScreen(),
                                                  ),
                                                );
                                              },
                                              child: Row(
                                                children: [
                                                  const CircleAvatar(
                                                    radius: 13,
                                                    backgroundColor:
                                                        Colors.blue,
                                                    child: Text(
                                                      'p',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  const Text(
                                                    'p',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                      Icons.person_add_outlined,
                                                      color: Colors.white),
                                                  const SizedBox(width: 12),
                                                  const Text(
                                                    'Add Account',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                      Icons.bookmark_border,
                                                      color: Colors.white),
                                                  const SizedBox(width: 12),
                                                  const Text(
                                                    'Saved Messages',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.history,
                                                      color: Colors.white),
                                                  const SizedBox(width: 12),
                                                  const Text(
                                                    'My Stories',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.contacts,
                                                      color: Colors.white),
                                                  const SizedBox(width: 12),
                                                  const Text(
                                                    'Contacts',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                      Icons.settings_outlined,
                                                      color: Colors.white),
                                                  const SizedBox(width: 12),
                                                  const Text(
                                                    'Settings',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.more_horiz,
                                                      color: Colors.white),
                                                  const SizedBox(width: 12),
                                                  const Text(
                                                    'More',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                    Expanded(
                                      child: TextField(
                                        controller: _searchController,
                                        onChanged: (value) {
                                          setState(() {
                                            _searchQuery = value;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: const Color(0xFF1F1F1F),
                                          hintText: 'Search',
                                          hintStyle: const TextStyle(
                                              color: Colors.grey),
                                          prefixIcon: IconButton(
                                            icon: const Icon(Icons.search,
                                                color: Colors.grey),
                                            onPressed: () {
                                              setState(() {
                                                _searchQuery =
                                                    _searchController.text;
                                              });
                                            },
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            borderSide: BorderSide.none,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            borderSide: BorderSide.none,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 10),
                                        ),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: chats.length,
                                  itemBuilder: (context, index) {
                                    final Chat chat = chats[index];

                                    return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        child: // Di dalam ListView.builder, pada widget ListTile
                                            ListTile(
                                          onTap: () {
                                            setState(() {
                                              selectedChat = chat;
                                            });
                                          },
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 8),
                                          leading: selectedChat!.avatarUrl !=
                                                  null
                                              ? CircleAvatar(
                                                  radius: 30,
                                                  backgroundImage: NetworkImage(
                                                    chat.avatarUrl ?? '',
                                                  ))
                                              : CircleAvatar(
                                                  radius: 30,
                                                  child: Text(
                                                    chat.name?[0] ?? '',
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20),
                                                  ),
                                                ),
                                          title: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  chat.name ?? '',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          16), // Mengubah dari 14 ke 16
                                                ),
                                              ),
                                            ],
                                          ),
                                          subtitle: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  chat.subtitle ?? '',
                                                  style: TextStyle(
                                                      color: Colors.grey[400],
                                                      fontSize:
                                                          14), // Mengubah dari 13 ke 14
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Text(
                                                chat.time ?? '',
                                                style: TextStyle(
                                                    color: Colors.grey[400],
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ));
                                  },
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            right: 20,
                            bottom: 20,
                            child: FloatingActionButton(
                              backgroundColor: const Color(0xFF2AABEE),
                              onPressed: () {
                                // Implementasi logika untuk membuat chat baru
                              },
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: selectedChat == null
                          ? Container(
                              decoration: const BoxDecoration(
                                color: Color(0xFF2C2C2C),
                                image: DecorationImage(
                                  image: AssetImage('assets/background.png'),
                                  repeat: ImageRepeat.repeat,
                                  opacity: 0.5,
                                ),
                              ),
                            )
                          : Container(
                              color: const Color(0xFF2C2C2C),
                              child: Column(
                                children: [
                                  // Header chat
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF2C2C2C),
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.black26)),
                                    ),
                                    child: Row(
                                      children: [
                                        selectedChat!.avatarUrl != null
                                            ? CircleAvatar(
                                                radius: 20,
                                                backgroundImage: NetworkImage(
                                                  selectedChat!.avatarUrl!,
                                                ))
                                            : CircleAvatar(
                                                radius: 20,
                                                child: Text(
                                                  selectedChat!.name![0],
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                selectedChat!.name!,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16),
                                              ),
                                              const Text(
                                                'last seen recently',
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 13),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.search,
                                              color: Colors.white),
                                          onPressed: () {},
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.more_vert,
                                              color: Colors.white),
                                          onPressed: () {},
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Area chat
                                  Expanded(
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/background.png'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Expanded(
                                              child: RefreshIndicator(
                                            onRefresh: () async {
                                              _loadChat();
                                              setState(() {});
                                            },
                                            child: ListView.builder(
                                              reverse: true,
                                              itemCount:
                                                  selectedChat!.message!.length,
                                              itemBuilder: (context, index) {
                                                final msg = selectedChat!
                                                    .message![selectedChat!
                                                        .message!.length -
                                                    index -
                                                    1];
                                                return Align(
                                                  alignment: msg.user_id ==
                                                          userId
                                                      ? Alignment.centerRight
                                                      : Alignment.centerLeft,
                                                  child: Container(
                                                    margin: const EdgeInsets
                                                        .symmetric(vertical: 6),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10,
                                                        horizontal: 14),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: Container(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          msg.photo != null
                                                              ? Container(
                                                                  width: 300,
                                                                  height: 300,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    image:
                                                                        DecorationImage(
                                                                      image: NetworkImage(
                                                                          msg.photo!),
                                                                      fit: BoxFit
                                                                          .contain,
                                                                    ),
                                                                  ),
                                                                )
                                                              : SizedBox(
                                                                  height: 0),
                                                          Text(
                                                            msg.content!,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 4),
                                                          Text(
                                                            msg.time!.day
                                                                    .toString() +
                                                                '/' +
                                                                msg.time!.month
                                                                    .toString() +
                                                                '/' +
                                                                msg.time!.year
                                                                    .toString(),
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Input chat
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    color: const Color(0xFF2C2C2C),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                              Icons.emoji_emotions_outlined,
                                              color: Colors.grey),
                                          onPressed: () {},
                                        ),
                                        IconButton(
                                            icon: const Icon(Icons.attach_file,
                                                color: Colors.grey),
                                            onPressed: () async {
                                              final FilePickerResult? result =
                                                  await FilePicker.platform
                                                      .pickFiles(
                                                          type: FileType.image,
                                                          allowMultiple: false,
                                                          withData: true);

                                              try {
                                                if (result != null) {
                                                  setState(() {
                                                    _pickedFile = result;
                                                  });
                                                }
                                              } catch (e) {
                                                print(
                                                    'Error memilih media: $e');
                                              }
                                            }),
                                        Expanded(
                                            child: Container(
                                          color: Color(0xFF1F1F1F),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              TextField(
                                                controller: messageController,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  hintText: 'Message',
                                                  fillColor: Color(0xFF1F1F1F),
                                                  hintStyle: const TextStyle(
                                                      color: Colors.grey),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 16),
                                                ),
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                              if (_pickedFile != null)
                                                Container(
                                                  height: 50,
                                                  width: 50,
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16),
                                                  decoration: BoxDecoration(
                                                      color: Color(0xFF1F1F1F),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      image: DecorationImage(
                                                        image: MemoryImage(
                                                            _pickedFile!.files
                                                                .first.bytes!),
                                                      )),
                                                ),
                                            ],
                                          ),
                                        )),
                                        IconButton(
                                          icon: const Icon(Icons.mic,
                                              color: Colors.grey),
                                          onPressed: () {},
                                        ),
                                        // Tambahkan tombol kirim
                                        IconButton(
                                            icon: const Icon(Icons.send,
                                                color: Colors.blue),
                                            onPressed: () async {
                                              String? photo = null;

                                              if (messageController
                                                      .text.isEmpty &&
                                                  _pickedFile == null) {
                                                return;
                                              }

                                              try {
                                                if (_pickedFile != null) {
                                                  photo = await Chat.upload(
                                                      _pickedFile!
                                                          .files.first.bytes!);
                                                }

                                                if (userId == null) {
                                                  throw Exception(
                                                      'User ID not found');
                                                }

                                                await Chat.send(Message(
                                                  content:
                                                      messageController.text,
                                                  user_id: userId,
                                                  chat_id: selectedChat!.id
                                                      .toString(),
                                                  photo: photo,
                                                  time: DateTime.now(),
                                                ));

                                                // Reset form setelah berhasil kirim
                                                setState(() {
                                                  _pickedFile = null;
                                                  messageController.clear();
                                                });

                                                // Refresh chat list
                                                _loadChat();
                                              } catch (e) {
                                                print(
                                                    'Error mengirim pesan: $e');
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                      content: Text(
                                                          'Gagal mengirim pesan: $e')),
                                                );
                                              }
                                            }),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
      floatingActionButton: selectedChat == null
          ? FloatingActionButton(
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) => Container(
                    color: Color(0xFF1F1F1F),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Add Chat',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _addChatNameController,
                          decoration: InputDecoration(
                            labelText: 'Nama',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _addChatController,
                          decoration: InputDecoration(
                            labelText: 'No Hp',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            minimumSize: const Size(double.infinity, 40),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            await Chat.addChat(_addChatController.text,
                                _addChatNameController.text);

                            Navigator.pop(context);
                          },
                          child: const Text('Add'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : null,
    );
  }
}
