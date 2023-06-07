import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mychatapp/main.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class AddPostPage extends StatefulWidget {
  AddPostPage();

  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  String messageText = ''; //入力した投稿メッセージ

  @override
  Widget build(BuildContext context) {
    final UserState userState = Provider.of<UserState>(context);
    final User user = userState.user!;
    return Scaffold(
        appBar: AppBar(
          title: Text('チャット投稿'),
        ),
        body: Center(
            child: Container(
                padding: EdgeInsets.all(32),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //投稿メッセージ入力
                      TextFormField(
                        decoration: InputDecoration(labelText: '投稿メッセージ'),
                        keyboardType: TextInputType.multiline, //複数行のテキスト入力
                        maxLines: 3, //最大行数
                        onChanged: (String value) {
                          setState(() {
                            messageText = value;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            child: Text('投稿'),
                            onPressed: () async {
                              final date = DateTime.now()
                                  .toLocal()
                                  .toIso8601String(); //現在の日時
                              final email = user.email; //AddPostPageのデータを参照
                              //投稿メッセージ用ドキュメント作成
                              await FirebaseFirestore.instance
                                  .collection('posts') //コレクションID指定
                                  .doc() //ドキュメントID自動生成
                                  .set({
                                'text': messageText,
                                'email': email,
                                'date': date
                              });
                              Navigator.of(context).pop();
                            },
                          ))
                    ]))));
  }
}
