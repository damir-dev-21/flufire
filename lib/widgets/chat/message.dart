import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flufire_chat/widgets/chat/message_bubble.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(builder: (ctx, futureSnapshot) {
      if (futureSnapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chat')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
            if (chatSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final chatDocs = chatSnapshot.data!.docs;

            return ListView.builder(
                reverse: true,
                itemCount: chatSnapshot.data!.docs.length,
                itemBuilder: (ctx, index) => MessageBubble(
                      message: chatDocs[index]['text'],
                      userName: chatDocs[index]['username'],
                      userImage: chatDocs[index]['userImage'],
                      isMe: chatDocs[index]['userId'] ==
                          FirebaseAuth.instance.currentUser!.uid,
                    ));
          });
    });
  }
}
