import 'package:chatapp/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  Messages({Key? key}) : super(key: key);

  final userID = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("chat")
          .orderBy(
            "createdAt",
            descending: true,
          )
          .snapshots(),
      builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDoc = snapshot.data!.docs;
        return ListView.builder(
          itemCount: chatDoc.length,
          reverse: true,
          itemBuilder: (ctx, index) {
            return MessageBubble(
              message: chatDoc[index]["text"],
              isMe: chatDoc[index]["userId"] == userID,
              username: chatDoc[index]["username"],
              userImage: chatDoc[index]["userImage"],
              key: ValueKey(chatDoc[index].id),
            );
          },
        );
      },
    );
  }
}
