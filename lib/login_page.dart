import 'package:flutter/material.dart';
import 'chat_page.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
              child: Text('ログイン', style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 205, 204, 204)),
              onPressed: () async {
                //チャット画面に遷移＋ログイン画面を破棄
                await Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) {
                  /*pushReplacement:一方通行の画面遷移のとき（ログイン）
                  現在のルートがスタックから完全に削除され新しいルートがスタックにプッシュされる
                  新しいルートが現在のアクティブなルートになり戻るボタンを使用して
                  前のルートに戻ることができなくなる*/
                  return ChatPage();
                }));
              })
        ],
      ),
    ));
  }
}
