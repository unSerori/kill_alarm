import 'package:flutter/material.dart';

// ページ遷移先をインポート
import 'screens/account.dart';
import 'screens/alarm.dart';
import 'screens/friends.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyStatefulWidget(),
    );
  }
}
class ClassName {
  static final square = Container(
    width: 200,
    height: 200,
    decoration: BoxDecoration(
      color: Color(0xFFFBFFFD),
      borderRadius: BorderRadius.circular(16.0),
    ),
  );
}



class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  static const _screens = [
    ScreenFriends(),
    ScreenAlarm(),
    ScreenAccount(),
  ];


  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFAEEEEA),
          //backgroundColor: Colors.blue,
        ),
        body: _screens[_selectedIndex],
        
        bottomNavigationBar: BottomNavigationBar(

          currentIndex: _selectedIndex,
          onTap: _onItemTapped,

          backgroundColor: const Color(0xFFAEEEEA),

          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'フレンド'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'アラーム設定'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'アカウント'),
          ],
          type: BottomNavigationBarType.fixed,
        ));
  }
}
