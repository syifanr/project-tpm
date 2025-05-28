import 'package:flutter/material.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({Key? key}) : super(key: key);

  final String jeslynComment =
      "Ini bisa diisi kesan pesan. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
  final String syifaComment =
      "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Color(0xFFE6E6FA)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _commentCard(
                name: 'Jeslyn Vicky Hanjaya',
                comment: jeslynComment,
                isSender: false,
              ),
              const SizedBox(height: 20),
              _commentCard(
                name: 'Syifa Nur Ramadhani',
                comment: syifaComment,
                isSender: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _commentCard({
    required String name,
    required String comment,
    required bool isSender,
  }) {
    // Warna balon berdasarkan pengirim
    final bubbleColor = isSender ? Colors.pink.shade100 : Colors.pink.shade50;
    final textColor = isSender ? Colors.white : Colors.pink.shade900;

    return Row(
      mainAxisAlignment:
          isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isSender)
          CircleAvatar(
            backgroundColor: Colors.pink.shade200,
            child: Text(
              name.split(' ').map((e) => e[0]).take(2).join(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        if (!isSender) const SizedBox(width: 12),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft:
                    isSender
                        ? const Radius.circular(20)
                        : const Radius.circular(4),
                bottomRight:
                    isSender
                        ? const Radius.circular(4)
                        : const Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: bubbleColor.withOpacity(0.5),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(comment, style: TextStyle(fontSize: 15, color: textColor)),
              ],
            ),
          ),
        ),
        if (isSender) const SizedBox(width: 12),
        if (isSender)
          CircleAvatar(
            backgroundColor: Colors.pink.shade400,
            child: Text(
              name.split(' ').map((e) => e[0]).take(2).join(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}
