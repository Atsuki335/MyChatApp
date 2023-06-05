import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:mychatapp/login_page.dart';
import 'main.dart';
import 'post_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'provider_page.dart';
//body部分

// ConsumerWidgetでProviderから値を受け渡す
class ChatPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Providerから値を受け取る
    final User user = ref.watch(userProvider)!;
    final AsyncValue<QuerySnapshot> asyncPostsQuery =
        ref.watch(postsQueryProvider);

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
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              child: Text('ログイン情報: ${user.email}'),
            ),
            Expanded(
                // FutureBuilder→stream
                // 非同期処理の結果を元にWidgetを作れる
                child: asyncPostsQuery.when(
                    // 投稿メッセージ一覧を取得（非同期処理）
                    // 投稿日時でソート
                    data: (QuerySnapshot query) {
              return ListView(
                children: query.docs.map((document) {
                  return Card(
                      child: ListTile(
                    title: Text(document['text']),
                    subtitle: Text(document['email']),
                    //自分の投稿メッセージの場合は削除ボタンを表示
                    trailing: document['email'] == user.email
                        ? IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              //投稿メッセージのドキュメントを削除
                              await FirebaseFirestore.instance
                                  .collection('posts')
                                  .doc(document.id)
                                  .delete();
                            },
                          )
                        : null,
                  ));
                }).toList(),
              );
            }, loading: () {
              return Center(
                child: Text('読込中...'),
              );
            }, error: (e, stackTrace) {
              return Center(
                child: Text(e.toString()),
              );
            }))
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
