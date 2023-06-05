import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mychatapp/main.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'chat_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'provider_page.dart';

//ConsumerWidgetでProviderから値を受け渡す
class LoginPage extends ConsumerWidget {
//Riverpodの作成者は　ScopedReader を WidgetRef に変更した
//他、アプデにより変更点あり、パッケージ変更履歴に記載
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Providerから値を受け取る
    final infoText = ref.watch(infoTextProvider);
    final email = ref.watch(emailProvider);
    final password = ref.watch(passwordProvider);

    return Scaffold(
        body: Center(
            child: Container(
                padding: EdgeInsets.all(24),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                          autocorrect: false, //英語が予測変換されて嫌だったので入れた（chatGPT)
                          decoration: InputDecoration(labelText: 'メールアドレス'),
                          onChanged: (String value) {
                            //Providerから値を更新
                            ref.read(emailProvider.notifier).state = value;
                          }),
                      TextFormField(
                          autocorrect: false,
                          decoration: InputDecoration(labelText: 'パスワード'),
                          obscureText: true,
                          onChanged: (String value) {
                            ref.read(passwordProvider.notifier).state = value;
                          }),
                      Container(
                        padding: EdgeInsets.all(8),
                        child: Text(infoText),
                      ),
                      Container(
                          width: double.infinity,
                          child: ElevatedButton(
                              child: Text('ユーザー登録'),
                              onPressed: () async {
                                try {
                                  //tryとcatchはセット
                                  final FirebaseAuth auth =
                                      FirebaseAuth.instance;
                                  final result =
                                      await auth.createUserWithEmailAndPassword(
                                          email: email, password: password);
                                  //ユーザー登録に成功した場合チャット画面に遷移＋ログイン画面を破棄
                                  ref.read(userProvider.notifier).state =
                                      result.user!;
                                  await Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                    builder: (context) {
                                      return ChatPage();
                                      /*pushReplacement:一方通行の画面遷移のとき（ログイン）
                  現在のルートがスタックから完全に削除され新しいルートがスタックにプッシュされる
                  新しいルートが現在のアクティブなルートになり戻るボタンを使用して
                  前のルートに戻ることができなくなる*/
                                    },
                                  ));
                                } catch (e) {
                                  //ユーザー登録に失敗した場合

                                  ref.read(infoTextProvider.notifier).state =
                                      "登録に失敗しました : ${e.toString()}";
                                }
                              })),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        child: OutlinedButton(
                          child: Text('ログイン'),
                          onPressed: () async {
                            try {
                              final FirebaseAuth auth = FirebaseAuth.instance;
                              //signInに変更

                              await auth.signInWithEmailAndPassword(
                                  email: email, password: password);

                              await Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) {
                                  return ChatPage();
                                },
                              ));
                            } catch (e) {
                              ref.read(infoTextProvider.notifier).state =
                                  "ログインに失敗しました : ${e.toString()}";
                            }
                          },
                        ),
                      )
                    ]))));
  }
}
