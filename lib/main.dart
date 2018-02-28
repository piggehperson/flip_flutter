import 'package:flutter/material.dart';

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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

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
        backgroundColor: new Color.fromARGB(0, 0, 0, 0),
        elevation: 0.0,
      ),
      bottomNavigationBar: new BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          fixedColor: Colors.amber.shade700,
          items: <BottomNavigationBarItem>[
            new BottomNavigationBarItem(icon: new Icon(Icons.casino), title: new Text('Dice'), backgroundColor: Colors.red, ),
            new BottomNavigationBarItem(icon: new Icon(Icons.account_circle), title: new Text('Coin'), backgroundColor: Colors.blue, ),
            new BottomNavigationBarItem(icon: new Icon(Icons.format_list_bulleted), title: new Text('List'), backgroundColor: Colors.green, ),
            new BottomNavigationBarItem(icon: new Icon(Icons.tune), title: new Text('Custom dice'), backgroundColor: Colors.deepPurple, ),
          ], currentIndex: index, onTap: (int index) { setState((){ this.index = index; }); },
      ),
      body: new Stack(
        children: <Widget>[
          new Offstage(
            offstage: index != 0,
            child: new TickerMode(
              enabled: index == 0,
              child: new Scaffold(backgroundColor: Colors.red.shade100,
                floatingActionButton: new FloatingActionButton(
                  onPressed: (){Scaffold.of(context).showSnackBar(new SnackBar(content: new Text('Hello World!')));},
                  backgroundColor: Colors.redAccent,
                  tooltip: 'Roll',
                  child: new Icon(Icons.casino),
                ),
                body: new FlutterLogo(size: 300.0,), //TODO: fill this with content
              ),
            ),
          ),
          new Offstage(
            offstage: index != 1,
            child: new TickerMode(
              enabled: index == 1,
              child: new Scaffold(backgroundColor: Colors.blue.shade100,
                floatingActionButton: new FloatingActionButton(
                  onPressed: _incrementCounter,
                  backgroundColor: Colors.blueAccent,
                  tooltip: 'Flip',
                  child: new Icon(Icons.casino),
                ),
              ),
            ),
          ),
          new Offstage(
            offstage: index != 2,
            child: new TickerMode(
              enabled: index == 3,
              child: new Scaffold(backgroundColor: Colors.green.shade100,
                floatingActionButton: new FloatingActionButton(
                  onPressed: _incrementCounter,
                  backgroundColor: Colors.greenAccent,
                  tooltip: 'Pick',
                  child: new Icon(Icons.casino),
                ),
              ),
            ),
          ),
          new Offstage(
            offstage: index != 3,
            child: new TickerMode(
              enabled: index == 3,
              child: new Scaffold(backgroundColor: Colors.deepPurple.shade100,
                floatingActionButton: new FloatingActionButton(
                  onPressed: _incrementCounter,
                  backgroundColor: Colors.deepPurpleAccent,
                  tooltip: 'Roll',
                  child: new Icon(Icons.casino),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
