import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:telegram_clone/main.dart';
import 'package:telegram_clone/models/message.dart';
import 'package:telegram_clone/providers/auth.dart';
import '../models/chat.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _addChatController = TextEditingController();

  List<Chat> chats = [];
  bool isLoading = true;
  Chat? selectedChat;
  String? selectedChatName;

  int? selectedChatIndex;
  final TextEditingController messageController = TextEditingController();

  FilePickerResult? _pickedFile;

  String? userId;

  _loadUserId() async {
    String? _userId = await AuthServices.getUserId();

    setState(() {
      userId = _userId;
    });
  }

  _loadChats() async {
    List<Chat> _chats = await Chat.fetch();

    setState(() {
      chats = _chats;
      isLoading = false;
      selectedChat =
          selectedChatIndex != null ? chats[selectedChatIndex!] : null;
      selectedChatName =
          selectedChat?.isGroup != null && selectedChat!.isGroup! == 1
              ? selectedChat!.name
              : userId == selectedChat?.members![0].id.toString()
                  ? selectedChat?.members![1].name
                  : selectedChat?.members![0].name;
    });
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback? onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildChatItem(Chat chat) {
    String chatName = chat.isGroup != null && chat.isGroup! == 1
        ? chat.name!
        : userId == chat.members![0].id.toString()
            ? chat.members![1].name!
            : chat.members![0].name!;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: ListTile(
        leading: chat.avatarUrl != null
            ? CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(chat.avatarUrl ?? ''),
              )
            : CircleAvatar(
                radius: 25,
                child: Text(
                  chatName[0],
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                chatName,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadChats();
    _loadUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2936),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2936),
        title: selectedChat == null
            ? const Text(
                'Telegram',
                style: TextStyle(color: Colors.white, fontSize: 20),
              )
            : Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: selectedChat!.avatarUrl != null
                        ? NetworkImage(selectedChat!.avatarUrl!)
                        : null,
                    child: selectedChat!.avatarUrl == null
                        ? Text(
                            selectedChatName?[0] ?? '',
                            style: const TextStyle(color: Colors.white),
                          )
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      selectedChatName ?? '',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
        leading: selectedChat == null
            ? Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  setState(() {
                    selectedChat = null;
                  });
                },
              ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(context: context, delegate: ChatSearchDelegate());
            },
          ),
        ],
      ),
      drawer: selectedChat == null
          ? Drawer(
              backgroundColor: const Color(0xFF1E2936),
              child: ListView(
                children: [
                  DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E2936),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.blue,
                          child: Text(
                            'P',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'p',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '+62 822 90228100',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildDrawerItem(Icons.person_outline, 'My Profile', () {}),
                  _buildDrawerItem(Icons.group_outlined, 'New Group', () {}),
                  _buildDrawerItem(
                      Icons.person_add_outlined, 'Contacts', () {}),
                  _buildDrawerItem(Icons.phone_outlined, 'Calls', () {}),
                  _buildDrawerItem(
                      Icons.bookmark_border, 'Saved Messages', () {}),
                  _buildDrawerItem(Icons.settings_outlined, 'Settings', () {}),
                  _buildDrawerItem(
                      Icons.person_add_alt_1_outlined, 'Invite Friends', () {}),
                  _buildDrawerItem(
                      Icons.help_outline, 'Telegram Features', () {}),
                  _buildDrawerItem(Icons.help_outline, 'Log out', () {
                    AuthServices.logout();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()));
                  }),
                ],
              ),
            )
          : null,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : chats.isEmpty
              ? const Center(child: Text('No Chats'))
              : selectedChat == null
                  ? RefreshIndicator(
                      onRefresh: () async {
                        _loadChats();
                        setState(() {});
                      },
                      child: ListView.builder(
                        itemCount: chats.length,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedChatIndex = index;
                              selectedChat = chats[index];
                              _loadChats();
                            });
                          },
                          child: _buildChatItem(chats[index]),
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/background.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                    child: RefreshIndicator(
                                  onRefresh: () async {
                                    _loadChats();
                                    setState(() {});
                                  },
                                  child: ListView.builder(
                                    reverse: true,
                                    itemCount: selectedChat!.message!.length,
                                    itemBuilder: (context, index) {
                                      final msg =
                                          selectedChat!.message!.length > 0
                                              ? selectedChat!.message![
                                                  selectedChat!
                                                          .message!.length -
                                                      index -
                                                      1]
                                              : selectedChat!.message![index];
                                      return Align(
                                        alignment: msg.user_id == userId
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 6),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 14),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
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
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                      )
                                                    : SizedBox(height: 0),
                                                Text(
                                                  msg.content ?? '',
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  msg.time!.day.toString() +
                                                      '/' +
                                                      msg.time!.month
                                                          .toString() +
                                                      '/' +
                                                      msg.time!.year.toString(),
                                                  style: const TextStyle(
                                                    color: Colors.black,
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
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          color: const Color(0xFF1E2936),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.attach_file,
                                    color: Colors.grey),
                                onPressed: () async {
                                  final FilePickerResult? result =
                                      await FilePicker.platform.pickFiles(
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
                                    print('Error memilih media: $e');
                                  }
                                },
                              ),
                              Expanded(
                                child: Container(
                                  color: Colors.transparent,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      TextField(
                                        controller: messageController,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.transparent,
                                          hintText: 'Message',
                                          hintStyle: const TextStyle(
                                              color: Colors.grey),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide.none,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 16),
                                        ),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      if (_pickedFile != null)
                                        Container(
                                          height: 50,
                                          width: 50,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              image: DecorationImage(
                                                image: MemoryImage(_pickedFile!
                                                    .files.first.bytes!),
                                              )),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.mic, color: Colors.grey),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.send, color: Colors.blue),
                                onPressed: () async {
                                  String? photo = null;

                                  if (messageController.text.isEmpty &&
                                      _pickedFile == null) {
                                    return;
                                  }

                                  try {
                                    if (_pickedFile != null) {
                                      photo = await Chat.upload(
                                          _pickedFile!.files.first.bytes!);
                                    }

                                    if (userId == null) {
                                      throw Exception('User ID not found');
                                    }

                                    await Chat.send(Message(
                                      content: messageController.text,
                                      user_id: userId,
                                      chat_id: selectedChat!.id.toString(),
                                      photo: photo,
                                      time: DateTime.now(),
                                    ));

                                    // Reset form setelah berhasil kirim
                                    setState(() {
                                      _pickedFile = null;
                                      messageController.clear();
                                    });

                                    // Refresh chat list
                                    _loadChats();
                                  } catch (e) {
                                    print('Error mengirim pesan: $e');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('Gagal mengirim pesan: $e')),
                                    );
                                  }
                                },
                              ),
                            ],
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
                            try {
                              await Chat.addChat(_addChatController.text);
                              _addChatController.clear();

                              Navigator.pop(context);
                            } catch (e) {
                              Navigator.pop(context);
                              print(e);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Gagal menambahkan chat: $e')),
                              );
                            }
                            _loadChats();
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

class ChatSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(); // Implement search results
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(); // Implement search suggestions
  }
}
