import 'package:flutter/material.dart';

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "업무문자해줘요",
      home: ColorfulPage(),
    );
  }
}

class ColorfulPage extends StatelessWidget {
  ColorfulPage({super.key});

  bool doMaintainLogin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 48, 48, 48),
      body: Center(
        child: Container(
          width: 535,
          height: 465,
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 0xef, 0xef, 0xef),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  '아이디',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    fillColor: Colors.white70,
                    focusColor: Colors.white70,
                    labelText: '아이디를 입력해주세요',
                    labelStyle: TextStyle(color: Colors.grey)),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Text(
                  '비밀번호',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    focusColor: Colors.white70,
                    fillColor: Colors.white70,
                    labelText: '비밀번호를 입력해주세요',
                    labelStyle: TextStyle(color: Colors.grey)),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: doMaintainLogin,
                    onChanged: (value) {
                      doMaintainLogin = value!;
                    },
                    checkColor: Colors.black,
                    focusColor: Colors.black,
                  ),
                  Text("로그인 유지",style: TextStyle(color: Colors.black, fontSize: 14),),
                ]
              ),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: Text(
                  '   아이디/아이디',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 55,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      )),
                  onPressed: () {
                    // 버튼 클릭 시 동작
                  },
                  child: Text(
                    '로그인',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('회원가입', style: TextStyle(color: Colors.grey, fontSize: 14),),
                  Text('/', style: TextStyle(color: Colors.grey, fontSize: 14)),
                  Text('아이디찾기', style: TextStyle(color: Colors.grey, fontSize: 14)),
                  Text('/', style: TextStyle(color: Colors.grey, fontSize: 14)),
                  Text('비밀번호찾기', style: TextStyle(color: Colors.grey, fontSize: 14)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
