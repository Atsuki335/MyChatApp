import 'package:flutter/material.dart';
import 'package:mychatapp/login_page.dart';
import 'post_page.dart';
//body部分

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('チャット'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () async {
                  //チャット画面に遷移＋ログイン画面を破棄
                  await Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (context) {
                    return LoginPage();
                  }));
                }),
          ],
        ),
        //actionsの外側に置くことで下に来る
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async {
              await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return AddPostPage();
              }));
            }));
  }
}
