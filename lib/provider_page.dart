import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'main.dart';
//アプリ起動画面　chatページを呼び出す
// ファイル分けしてみる
//最初のWidgetを ProviderScope() の子Widgetとし、データの受け渡しが可能な状態にする
//StateProvider を使い受け渡すデータを定義する
//ConsumerWidget を使いデータを受け取る
//StateProvider を使い変更可能なデータを渡す
//StreamProvider を使いStreamも扱うことができる
//.autoDispose を付けることで値を自動的にリセットできる
//引数からユーザー情報を渡す処理が不要になった 🤩

// StateProviderを使い受け渡すデータを定義する
// ※ Providerの種類は複数あるが、ここではデータを更新できるStateProviderを使う

//以下受け渡しを行うprovider
//ユーザー情報
final userProvider = StateProvider((ref) {
  return FirebaseAuth.instance.currentUser;
});

//エラー情報
final infoTextProvider = StateProvider.autoDispose((ref) {
  return '';
});

//メールアドレス　　＊1 autoDisposeをつけることで自動的に値をリセットできる
final emailProvider = StateProvider.autoDispose((ref) {
  return '';
});

//パスワード *1
final passwordProvider = StateProvider.autoDispose((ref) {
  return '';
});

//メッセージ　＊1
final messageTextProvider = StateProvider.autoDispose((ref) {
  return '';
});

//StreamProviderを使うことでStreamも扱うことができる　*1
final postsQueryProvider = StreamProvider.autoDispose((ref) {
  return FirebaseFirestore.instance
      .collection('posts')
      .orderBy('date')
      .snapshots();
});
