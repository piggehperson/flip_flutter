import 'package:flutter/material.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flip',
      theme: new ThemeData(
        primaryColor: Colors.amber,
        accentColor: Colors.amberAccent,
      ),
      home: new MyHomePage(title: 'Flip'),
      routes: <String, WidgetBuilder> {
        '/home': (BuildContext context) => new MyHomePage(),
        '/settings' : (BuildContext context) => new SettingsPage()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.settings), tooltip: 'Settings', onPressed: (){
            Navigator.of(context).pushNamed('/settings');
          })
        ],
      ),
      bottomNavigationBar: new BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          fixedColor: Colors.amber.shade700,
          items: <BottomNavigationBarItem>[
            new BottomNavigationBarItem(icon: new Icon(Icons.casino), title: new Text('Dice'), backgroundColor: Colors.red, ),
            new BottomNavigationBarItem(icon: new Icon(Icons.account_circle), title: new Text('Coin'), backgroundColor: Colors.blue, ),
            new BottomNavigationBarItem(icon: new Icon(Icons.format_list_bulleted), title: new Text('List'), backgroundColor: Colors.green, ),
            new BottomNavigationBarItem(icon: new Icon(Icons.assistant), title: new Text('Custom dice'), backgroundColor: Colors.deepPurple, ),
          ], currentIndex: index, onTap: (int index) { setState((){ this.index = index; }); },
      ),
      body: new Stack(
        children: <Widget>[
          new Offstage(
            offstage: index != 0,
            child: new TickerMode(
              enabled: index == 0,
              child: new DicePage(),
            ),
          ),
          new Offstage(
            offstage: index != 1,
            child: new TickerMode(
              enabled: index == 1,
              child: new CoinPage(),
            ),
          ),
          new Offstage(
            offstage: index != 2,
            child: new TickerMode(
              enabled: index == 2,
              child: new Placeholder(color: Colors.blue),
            ),
          ),
          new Offstage(
            offstage: index != 3,
            child: new TickerMode(
              enabled: index == 3,
              child: new Placeholder(color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }
}
class DicePage extends StatefulWidget {
  const DicePage();

  @override
  _DicePageState createState() => new _DicePageState();
}

class _DicePageState extends State<DicePage> {

  int diceNumber = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Align(alignment: new Alignment(0.0,-0.3), child:
      new Column(children: <Widget>[
        new Text('You rolled a', style: new TextStyle(fontSize: 24.0)),
        new Text(diceNumber.toString(), style: new TextStyle(fontSize: 48.0, color: Colors.amber.shade700)),
      ])),
      floatingActionButton: new FloatingActionButton(onPressed: _onPressed, child: new Icon(Icons.casino), tooltip: 'Roll',),
    );
  }
  int _randomize(){
    final random = new Random();
    return 1 + random.nextInt(6);
  }

  void _onPressed(){
    setState((){
      diceNumber = _randomize();
    });
  }
}

class CoinPage extends StatefulWidget {
  const CoinPage();

  @override
  _CoinPageState createState() => new _CoinPageState();
}

class _CoinPageState extends State<CoinPage> {

  int coinNumber = 0;
  String coinString = '0';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Align(alignment: new Alignment(0.0,-0.3), child:
      new Column(children: <Widget>[
        new Text('You flipped', style: new TextStyle(fontSize: 24.0)),
        new Text(coinString, style: new TextStyle(fontSize: 48.0, color: Colors.amber.shade700)),
      ])),
      floatingActionButton: new FloatingActionButton(onPressed: _onPressed, child: new Icon(Icons.casino), tooltip: 'Flip',),
    );
  }
  int _randomize(){
    final random = new Random();
    return random.nextInt(2);
  }

  void _onPressed(){
    setState((){
      coinNumber = _randomize();
      switch (coinNumber){
        case 0:
          coinString = 'Heads';
          break;
        case 1:
          coinString = 'Tails';
          break;
        default:
          coinString = 'error';
          break;
      }
    });
  }
}

//here's the Settings page from the gear on the toolbar
class SettingsPage extends StatefulWidget {
  const SettingsPage();

  @override
  _SettingsPageState createState() => new _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool useDarkTheme = false;
  Color _backgroundColor = new Color.fromARGB(255, 250, 250, 250);
  Color _appBarColor = new Color.fromARGB(255, 255, 255, 255);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: _backgroundColor,
      appBar: new AppBar(title: new Text('Settings', style: new TextStyle(inherit: true, color: Colors.amber.shade700),),
        backgroundColor: _appBarColor,
        leading: new IconButton(icon: new Icon(Icons.arrow_back), tooltip: 'Back', color: Colors.amber.shade700, onPressed: (){
          Navigator.of(context).pop(false);
        }),),
      body: new ListView(padding: new EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0), children: <Widget>[new Row(children: <Widget>[
        new Expanded(child: new Row(children: <Widget>[new Icon(Icons.brightness_low, semanticLabel: 'Moon icon',),
        new Padding(padding: new EdgeInsets.symmetric(horizontal: 16.0)),
        new Text('Dark theme', style: new TextStyle(fontSize: 16.0),),
       ],)),
        new Switch(value: useDarkTheme, onChanged: (bool value){
          setState((){
            useDarkTheme = value;
            switch (value){
              case true:
                _backgroundColor = new Color.fromARGB(255, 30, 30, 30);
                _appBarColor = new Color.fromARGB(255, 48, 48, 48);
                break;
              case false:
                _backgroundColor = new Color.fromARGB(255, 250, 250, 250);
                _appBarColor = new Color.fromARGB(255, 255, 255, 255);
                break;
            }
                () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setBool('use_dark_theme', value);
                  print('stored ' + value.toString() + ' to SharedPrefs');
            };
          });
        },),
      ],)],),
    );
  }


}