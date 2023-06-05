import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'chat_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String infoText = '';
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
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
                  setState(() {
                    email = value;
                  });
                }),
            TextFormField(
              autocorrect: false,
              decoration: InputDecoration(labelText: 'パスワード'),
              obscureText: true,
              onChanged: (String value) {
                setState(() {
                  password = value;
                });
              },
            ),
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
                        final FirebaseAuth auth = FirebaseAuth.instance;
                        final UserCredential result =
                            await auth.createUserWithEmailAndPassword(
                                email: email, password: password);
                        //ユーザー登録に成功した場合チャット画面に遷移＋ログイン画面を破棄
                        await Navigator.of(context)
                            .pushReplacement(MaterialPageRoute(
                          builder: (context) {
                            /*pushReplacement:一方通行の画面遷移のとき（ログイン）
                  現在のルートがスタックから完全に削除され新しいルートがスタックにプッシュされる
                  新しいルートが現在のアクティブなルートになり戻るボタンを使用して
                  前のルートに戻ることができなくなる*/
                            return ChatPage(result.user!);
                          },
                        ));
                      } catch (e) {
                        //ユーザー登録に失敗した場合
                        setState(() {
                          infoText = "登録に失敗しました : ${e.toString()}";
                        });
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
                    final UserCredential result = //追加（resultにエラーが出た））
                        await auth.signInWithEmailAndPassword(
                            email: email, password: password);
                    await Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(
                      builder: (context) {
                        return ChatPage(result.user!);
                      },
                    ));
                  } catch (e) {
                    setState(() {
                      infoText = "ログインに失敗しました : ${e.toString()}";
                    });
                  }
                },
              ),
            )
          ],
        ),
      ),
    ));
  }
}
