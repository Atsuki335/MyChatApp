import 'package:flutter/material.dart';
import 'chat_page.dart';

class AddPostPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('チャット投稿'),
      ),
      body: Center(
          child: ElevatedButton(
        child: Text('戻る', style: TextStyle(color: Colors.black)),
        style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 205, 204, 204)),
        onPressed: () {
          Navigator.of(context).pop();
        },
      )),
    );
  }
}
