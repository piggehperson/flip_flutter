import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
        primaryColor: Colors.amber.shade700,
        accentColor: Colors.amberAccent.shade400,
        brightness: Brightness.light,
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
        title: new Text(widget.title, style: Theme.of(context).textTheme.title,),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.settings, color: Theme.of(context).textTheme.title.color,), tooltip: 'Settings', onPressed: (){
            Navigator.of(context).pushNamed('/settings');
          })
        ],
      ),
      bottomNavigationBar: new BottomNavigationBar(
          type: BottomNavigationBarType.fixed,

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
              child: new ListPage(),
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: new Align(
          alignment: new FractionalOffset(0.5,0.25),
          child: new Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text('You rolled a', style: new TextStyle(fontSize: 24.0, fontFamily: 'ProductSans',)),
                new Text(diceNumber.toString(), style: new TextStyle(fontSize: 48.0, color: Colors.amber.shade700, fontFamily: 'ProductSans',)),
              ]
          ),
        ),
        floatingActionButton: new FloatingActionButton.extended(
          onPressed: _onPressed,
          icon: const Icon(Icons.casino,),
          label: new Text('ROLL'),
        ),
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: new Align(
          alignment: new FractionalOffset(0.5,0.25),
          child: new Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text('You flipped', style: new TextStyle(fontSize: 24.0, fontFamily: 'ProductSans',)),
                new Text(coinString, style: new TextStyle(fontSize: 48.0, color: Colors.amber.shade700, fontFamily: 'ProductSans',)),
              ]
          ),
        ),
      floatingActionButton: new FloatingActionButton.extended(
        onPressed: _onPressed,
        icon: const Icon(Icons.casino,),
        label: new Text('FLIP'),
      ),
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

class ListPage extends StatefulWidget {
  const ListPage();

  @override
  _ListPageState createState() => new _ListPageState();
}

class _ListPageState extends State<ListPage> {

  int fakeListLength = 100;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Divider(height: 1.0,), //Adds a thin divider line below the App Bar
          new Expanded(child:
          new Scrollbar(child:
          new ListView.builder(
            itemCount: fakeListLength,
            itemBuilder: (BuildContext context, int index) {
              return new ListItem(index: index, listLength: fakeListLength, widget: new Text('Dummy text $index', style: Theme.of(context).textTheme.subhead));
            },
          )
          )
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: new FloatingActionButton.extended(
        onPressed: (){},
        icon: const Icon(Icons.casino,),
        label: new Text('PICK'),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  ListItem({this.widget, this.shaded, this.index, this.listLength});

  final bool shaded;
  Widget widget;
  final int index;
  final int listLength;
  Color _shadeColor = Colors.transparent;

  @override
  Widget build(BuildContext context){
    if (shaded == null && index != null){
      if (!index.isEven){
        _shadeColor = Colors.grey.shade200;
      }
    }

    EdgeInsets outerPadding;
    if (index == 0){
      outerPadding = const EdgeInsets.fromLTRB(8.0,8.0,4.0,0.0);
    } else if (index == listLength - 1){
      outerPadding = const EdgeInsets.fromLTRB(8.0,0.0,4.0,88.0);
    } else {
      outerPadding = const EdgeInsets.fromLTRB(8.0,0.0,4.0,0.0)
    }


    return new Padding(
      padding: outerPadding, //Padding for the Material itself
        /*padding: new EdgeInsets.fromLTRB(16.0,8.0,4.0,8.0),*/
      child: new Material(
        elevation: 0.0,
        color: _shadeColor,
        borderRadius: new BorderRadius.all(const Radius.circular(8.0)),
        child: new Padding(
            padding: new EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 8.0), //Padding for the stuff inside the Material
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Expanded(
                child: widget,
              ),
              new IconButton(
                  icon: new Icon(Icons.close, color: Theme.of(context).textTheme.body1.color,),
                  tooltip: 'Remove item',
                  onPressed: (){}
              )
            ],
          ),
        )
      )
    );
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new ListView(
        children: <Widget>[
          new AppBar(
            leading: new IconButton(icon: new Icon(Icons.arrow_back, color: Theme.of(context).primaryColor,), onPressed: (){Navigator.of(context).pop(false);}),
            title: new Text('Settings', style: new TextStyle(color: Theme.of(context).primaryColor),),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
          ),
          new Padding(
            padding: new EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: new Row(
              children: <Widget>[
                new Icon(Icons.brightness_3, color: Theme.of(context).textTheme.title.color,),
                new Padding(padding: new EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0)),
                new Expanded(
                  child: new Text('Dark theme',
                    style: Theme.of(context).textTheme.subhead),
                ),
                new Switch(
                    value: useDarkTheme,
                    onChanged: (bool value){
                      switchTheme(value);
                      setState((){useDarkTheme = value;});
                    }
                )
              ],
            ),
          )
        ],
      )
    );
  }

  void switchTheme(bool isDark){
    switch (isDark){
      case true:

        break;
      case false:

        break;
    }
        () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('use_dark_theme', isDark);
      print('stored ' + isDark.toString() + ' to SharedPrefs');
    };
  }
}