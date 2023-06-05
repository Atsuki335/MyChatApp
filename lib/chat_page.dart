import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:mychatapp/login_page.dart';
import 'post_page.dart';
//body部分

class ChatPage extends StatelessWidget {
  ChatPage(this.user); //引数からユーザー情報を受け取れるようにする
  final User user; //ユーザー情報
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('チャット'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.logout),
                onPressed: () async {
                  //ログアウト処理
                  //内部で保持しているログイン情報等が初期化される
                  //チャット画面に遷移＋ログイン画面を破棄
                  await FirebaseAuth.instance.signOut();
                  await Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (context) {
                    return LoginPage();
                  }));
                }),
          ],
        ),
        body: Center(
          child: Text('ログイン情報 : ${user.email}'),
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
