import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'provider_page.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPostPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final messageText = ref.watch(messageTextProvider);

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
                            ref.read(messageTextProvider.notifier).state =
                                value;
                          }),

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
