import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flip_flutter/splashwidget.dart';
import 'package:pigment/pigment.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  MyAppState createState() => new MyAppState();
}

class MyAppState extends State<MyApp>{
  ThemeData _appTheme = new ThemeData.fallback();

  initPrefs() async{
    bool useDarkTheme = false;
    SharedPreferences.getInstance().then((SharedPreferences value) {
      if (value.getBool("use_dark_theme") == null){
        useDarkTheme = false;
      } else if (value.getBool("use_dark_theme") == null){
        useDarkTheme = false;
      } else{
        useDarkTheme = value.getBool("use_dark_theme");
      }
      updateTheme(useDarkTheme);
    });
  }

  void updateTheme(bool isDark) {
    setState(() {
      if (isDark == true){ //use the Dark theme
        _appTheme = new ThemeData(
          primarySwatch: Colors.amber,
          primaryColor: Colors.amber.shade700,
          accentColor: Colors.amberAccent.shade400,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Pigment.fromString("#212121"),
          dialogBackgroundColor: Pigment.fromString("#303030"),
          bottomAppBarColor: Pigment.fromString("#212121"),
          dividerColor: Pigment.fromString("#FFFFFF0F"),
        );
      } else { //use the default Light theme
        _appTheme = new ThemeData(
          primarySwatch: Colors.amber,
          primaryColor: Colors.amber.shade700,
          accentColor: Colors.amberAccent.shade400,
          brightness: Brightness.light,
          scaffoldBackgroundColor: Pigment.fromString("#FAFAFA"),
          dialogBackgroundColor: Pigment.fromString("#FFFFFF"),
          bottomAppBarColor: Pigment.fromString("#FAFAFA"),
          dividerColor: Pigment.fromString("#0000000F"),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flip',
      theme: _appTheme,
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

class _MyHomePageState extends State<MyHomePage>
    with TickerProviderStateMixin {
  int index = 0;
  double appbarElevationScale = 0.0;

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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: appbarElevationScale * 4,
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.settings, color: Theme.of(context).textTheme.title.color,), tooltip: 'Settings', onPressed: (){
            Navigator.push(
                context,
                new MaterialPageRoute(builder: (BuildContext context) => new SettingsPage())
            );
          }),
        ],
      ),
      bottomNavigationBar: new BottomAppBar(
        elevation: appbarElevationScale * 8,
        hasNotch: false,
        color: Theme.of(context).bottomAppBarColor,
        child: new BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(icon: const Icon(Icons.casino), title: const Text('Dice'),),
            const BottomNavigationBarItem(icon: const Icon(Icons.account_circle), title: const Text('Coin')),
            const BottomNavigationBarItem(icon: const Icon(Icons.format_list_bulleted), title: const Text('List')),
            const BottomNavigationBarItem(icon: const Icon(Icons.assistant), title: const Text('Custom dice')),
          ], currentIndex: index, onTap: (int index) {
          switch(index){
            case 2:
              setState(() {
                this.index = index;
                this.appbarElevationScale = 1.0;
              });
              break;
            default:
              setState(() {
                this.index = index;
                this.appbarElevationScale = 0.0;
              });
          }
        },
        ),
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
              child: new CoinPage()
          ),
          new Offstage(
            offstage: index != 2,
            child: new ListPage(),
          ),
          new Offstage(
            offstage: index != 3,
            child: new D20Page(),
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

  int diceNumber = randomize();
  GlobalKey<SplashWidgetState> splashWidgetKey = new GlobalKey<SplashWidgetState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: new Align(
          alignment: new FractionalOffset(0.5,0.30),
          child: new SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80.0),
            child: new SplashWidget(
              key: splashWidgetKey,
              size: 150.0,
              child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Text('You rolled a', style: Theme.of(context).textTheme.title.copyWith(color: Theme.of(context).textTheme.display1.color, fontFamily: 'ProductSans')),
                    const SizedBox(height:8.0),
                    new Text(diceNumber.toString(), style: Theme.of(context).textTheme.display2.copyWith(color: Theme.of(context).primaryColor, fontFamily: 'ProductSans')),
                  ]
              ),
            ),
          ),
        ),
        floatingActionButton: new FloatingActionButton.extended(
          onPressed: onPressed,
          icon: const Icon(Icons.casino,),
          label: const Text('Roll'),
          elevation: 4.0,
          highlightElevation: 8.0,
        ),

    );
  }
  static int randomize(){
    final random = new Random();
    return 1 + random.nextInt(6);
  }

  void onPressed(){
    splashWidgetKey.currentState.splash();
    setState((){
      diceNumber = randomize();
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
  String coinString = 'Nothing';
  GlobalKey<SplashWidgetState> splashWidgetKey = new GlobalKey<SplashWidgetState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: new Align(
          alignment: new FractionalOffset(0.5,0.30),
          child: new SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80.0),
            child: new SplashWidget(
              key: splashWidgetKey,
              size: 200.0,
              child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Text('You flipped', style: Theme.of(context).textTheme.title.copyWith(color: Theme.of(context).textTheme.display1.color, fontFamily: 'ProductSans')),
                    const SizedBox(height:8.0),
                    new Text(coinString, style: Theme.of(context).textTheme.display2.copyWith(color: Theme.of(context).primaryColor, fontFamily: 'ProductSans')),
                  ]
              ),
            ),
          ),
        ),
      floatingActionButton: new FloatingActionButton.extended(
        onPressed: _onPressed,
        icon: const Icon(Icons.casino,),
        label: const Text('Flip'),
        elevation: 4.0,
        highlightElevation: 8.0,
      ),
    );
  }

  static int _randomize(){
    final random = new Random();
    return random.nextInt(2);
  }

  void _onPressed(){
    splashWidgetKey.currentState.splash();
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

  List<String> _itemsList;
  SharedPreferences _prefs;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    initList();
    initPrefs();
  }

  initPrefs() async{
    SharedPreferences.getInstance().then((SharedPreferences value) {
      _prefs = value;
      if (_prefs.getStringList("itemsList") != null){
        setState(() {
          _itemsList = _prefs.getStringList("itemsList");
        });
      }
    });
  }

  void initList(){
    _itemsList = [
      "NewThing",
      "MyThing",
      "HelloThing",
      "if you see this text, something went wrong"
    ];
  }

  void dialogNewItem(BuildContext context){
    String text = "Blank Thing";
    TextField textField = new TextField(
      decoration: const InputDecoration(
        hintText: "Name your Thing",
      ),
      onChanged: (String value){
        text = value;
      },
    );
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context){
        return new AlertDialog(
          title: const Text("Add a Thing"),
          content: textField,
          actions: <Widget>[
            new FlatButton(
              child: const Text("Cancel"),
              textColor: Theme.of(context).primaryColor,
              onPressed: (){
                Navigator.of(context).pop();
              },
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(6.0)),
            ),
            new RaisedButton(
              child: const Text("Add"),
              textColor: Theme.of(context).dialogBackgroundColor,
              color: Theme.of(context).primaryColor,
              elevation: 0.0,
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(6.0)),
              onPressed: (){
                setState((){
                  _itemsList.insert(_itemsList.length - 1, text);
                  _prefs.setStringList("itemsList", _itemsList);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_itemsList == null){
      initList();
    }

    return new Scaffold(
      key: _scaffoldKey,
      body: new Stack(children: <Widget>[
        new Offstage( //Show this if there are no items in the list
          offstage: _itemsList.length > 1,
          child: new TickerMode(
            enabled: _itemsList.length == 1,
            child: new Align(
              alignment: new FractionalOffset(0.5,0.40),
              child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text("There's nothing here", style: Theme.of(context).textTheme.headline.copyWith(fontSize: 20.0, color: Theme.of(context).textTheme.display1.color, fontFamily: 'ProductSans')),
                    const SizedBox(height:16.0),
                    new RaisedButton.icon(
                      onPressed: (){ dialogNewItem(context); },
                      icon: const Icon(Icons.add),
                      label: const Text("Add a Thing"),
                      color: Theme.of(context).accentColor,
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(6.0)),
                    )
                  ]
              ),
            ),
          ),
        ),
        new Offstage( //show this if there are items in the list
          offstage: _itemsList.length == 1,
          child: new TickerMode(
            enabled: _itemsList.length > 1,
            child: new Scaffold(
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
              floatingActionButton: new FloatingActionButton.extended(
                onPressed: (){
                  if (_itemsList.length > 0){
                    showDialog(context: context, barrierDismissible: true, builder: (BuildContext context) {
                      return new AlertDialog(
                        title: const Text('Item selected from the list'),
                        content: new Text(
                            _itemsList[new Random().nextInt(_itemsList.length - 1)]),
                        actions: <
                            Widget>[ //AlertDialog with no buttons makes me nut but that's bad ux so i gotta abstain
                          new FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(6.0)),
                            child: const Text("OK"),
                            textColor: Theme.of(context).primaryColor,
                          ),
                        ],
                      );}
                    );
                  } else {
                    Scaffold.of(context).showSnackBar(const SnackBar(content: const Text("There's nothing to pick from!")));
                  }
                },
                icon: const Icon(Icons.casino,),
                label: const Text('Pick'),
                elevation: 4.0,
                highlightElevation: 8.0,
              ),
              body: new Scrollbar(child:
              new ListView.builder(
                padding: const EdgeInsets.only(top: 8.0, bottom: 80.0),
                itemCount: _itemsList.length,
                itemBuilder: (context, index){
                  Color shadeColor;
                  if (!index.isEven){
                    //shadeColor = const Color(0x11000000);
                    shadeColor = Theme.of(context).dividerColor;
                  }
                  String _label = _itemsList[index];
                  int _rememberIndex = index;
                  return new ListItem(
                    label: _label,
                    index: index,
                    shadeColor: shadeColor,
                    listLength: _itemsList.length,
                    actionCallback: index != _itemsList.length - 1
                        ? (){ //this is a regular list item
                      setState((){ _itemsList.removeAt(index); });
                      _prefs.setStringList("itemsList", _itemsList);

                      //show a Snackbar with an Undo button
                      _scaffoldKey.currentState.showSnackBar(
                          new SnackBar(
                            content: new Text(_label + " removed"),
                            action: new SnackBarAction(
                                label: "Undo",
                                onPressed: (){
                                  setState(() {
                                    _itemsList.insert(_rememberIndex, _label);
                                  });
                                  _prefs.setStringList("itemsList", _itemsList);
                                }
                            ),
                          )
                      );
                    }
                        : (){ //this is the end item, prompt to add an item
                      dialogNewItem(context);
                    },
                  );
                },
              )
              ),
            ),
          ),
        ),
      ],
      )
    );
  }
}

class ListItem extends StatefulWidget {
  ListItem({this.label, this.shadeColor, this.index, this.listLength, this.actionCallback})
      : assert(label != null), assert(index != null);

  final String label;
  final int index;
  final int listLength;
  final Color shadeColor;
  final VoidCallback actionCallback;

  @override
  _ListItemState createState() => new _ListItemState();
}

class _ListItemState extends State<ListItem> {

  @override
  Widget build(BuildContext context){
    return new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0), //Padding for outside the item
        child: widget.index == widget.listLength - 1
            ? new Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: new OutlineButton.icon(
            onPressed: widget.actionCallback,
            icon: const Icon(Icons.add),
            label: const Text("Add a Thing"),
            textColor: Theme.of(context).primaryColor,
            highlightElevation: 0.0,
            highlightedBorderColor: Colors.transparent,
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(6.0)),
          )
        )
            : new DecoratedBox(
          decoration: new BoxDecoration(color: widget.shadeColor, borderRadius: new BorderRadius.circular(6.0)),
          child: new Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0, right: 8.0, bottom: 8.0), //Padding for the label and button
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Expanded(
                  child: new Text(widget.label, style: Theme.of(context).textTheme.subhead.copyWith(color: Theme.of(context).textTheme.display1.color)),
                ),
                new IconButton(
                    icon: new Icon(Icons.close, color: Theme.of(context).textTheme.display1.color,),
                    tooltip: 'Remove this Thing',
                    onPressed: (){widget.actionCallback();}
                )
              ],
            ),
          ),
        )
    );
  }
}

//Custom Dice page widget
class D20Page extends StatefulWidget {
  const D20Page();

  @override
  D20PageState createState() => new D20PageState();
}

class D20PageState extends State<D20Page> {
  int min = 1;
  int max = 20;
  int diceNumber = randomize(1, 20);
  /* Create a Key for the Form that controls the TextFields. We're gonna need
     this to validate the form when the FAB is clicked. */
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  /* Create a Key for the Scaffold that holds everything. The Snackbar we show
     if there's an error needs to be shown on this Widget's Scaffold so it can
     move the FAB out of the way. */
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<SplashWidgetState> _splashWidgetKey = new GlobalKey<SplashWidgetState>();

  //These functions validate the TextFields that control Min and Max variables.
  String validateMin(String value){
    if (value.isEmpty){
      return "Please enter a number!";
    }
    try {
      int intValue = int.parse(value);
      if (intValue.isNegative){
        return "Number can't be negative!";
      }
      if (intValue > 4294967296){
        return "Number must be less than 4294967296!";
      }
      min = intValue;
      return null;
    } catch (FormatException){
      return "That's not a number!";
    }
  }
  String validateMax(String value){
    if (value.isEmpty){
      return "Please enter a number!";
    }
    try {
      int intValue = int.parse(value);
      if (intValue.isNegative){
        return "Number can't be negative!";
      }
      if (intValue > 4294967296){
        return "Number must be less than 4294967296!";
      }
      max = intValue;
      return null;
    } catch (FormatException){
      return "That's not a number!";
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: new FloatingActionButton.extended(
        icon: const Icon(Icons.casino),
        label: const Text("Roll"),
        elevation: 4.0,
        highlightElevation: 8.0,
        onPressed: (){ onPressed(); },
      ),
      body: new Scrollbar(
        child: new SingleChildScrollView(
            padding: const EdgeInsets.only(left: 32.0, top: 16.0, right: 32.0, bottom: 80.0),
            child: new Form(
              key: _formKey,
              autovalidate: true,
              child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[new Column(
                      children: <Widget>[
                        new SplashWidget(
                          key: _splashWidgetKey,
                          size: 150.0,
                          child: new Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                new Text('You rolled', style: Theme.of(context).textTheme.title.copyWith(color: Theme.of(context).textTheme.display1.color, fontFamily: 'ProductSans')),
                                const SizedBox(height:8.0),
                                new Text(diceNumber.toString(), style: Theme.of(context).textTheme.display2.copyWith(color: Theme.of(context).primaryColor, fontFamily: 'ProductSans')),
                              ]
                          ),
                        ),
                      ],),],),
                    const SizedBox(height: 32.0),
                    new Text('From', style: Theme.of(context).textTheme.subhead.copyWith(color: Theme.of(context).textTheme.display1.color, fontFamily: 'ProductSans')),
                    new TextFormField(
                      decoration: new InputDecoration(hintText: "Small number"),
                      keyboardType: TextInputType.number,
                      //controller: new TextEditingController(text: min.toString()),
                      validator: validateMin,
                      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                      initialValue: min.toString(),
                    ),
                    const SizedBox(height: 8.0),
                    new Text('to', style: Theme.of(context).textTheme.subhead.copyWith(color: Theme.of(context).textTheme.display1.color, fontFamily: 'ProductSans')),
                    new TextFormField(
                      decoration: new InputDecoration(hintText: "Big number"),
                      keyboardType: TextInputType.number,
                      //controller: new TextEditingController(text: max.toString()),
                      validator: validateMax,
                      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                      initialValue: max.toString(),
                    ),
                  ],
                ),
            )
        ),
      ),
    );
  }

  static int randomize(int min, int max){
    final random = new Random();
    return min > max ? max + random.nextInt(min) : min + random.nextInt(max);
  }

  void onPressed(){
    if (_formKey.currentState.validate()){
      _splashWidgetKey.currentState.splash();
      setState(() {
        diceNumber = randomize(min, max);
      });
    } else {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(content: const Text("Something's wrong with your numbers!"), backgroundColor: Colors.red.shade800, duration: new Duration(seconds:3),));
    }
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
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  SharedPreferences _prefs;
  bool _wasDark = false;

  initPrefs() async{
    useDarkTheme = false;
    SharedPreferences.getInstance().then((SharedPreferences value) {
      _prefs = value;
      setState(() {
        if (value.getBool("use_dark_theme") == null){
          useDarkTheme = false;
        } else if (value.getBool("use_dark_theme") == null){
          useDarkTheme = false;
        } else{
          useDarkTheme = value.getBool("use_dark_theme");
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
  }


  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark){ _wasDark = true; }

    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text('Settings', style: new TextStyle(color: Theme.of(context).primaryColor),),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Theme.of(context).primaryColor,),
            onPressed: (){ Navigator.pop(context); },
        ),
      ),
      body: new ListTile(
        leading: new Icon(Icons.brightness_3, color: Theme.of(context).textTheme.title.color,),
        title: const Text('Dark theme (requires restart)'),
        subtitle: new Text(useDarkTheme ? "App will use a dark theme next time you open it" : "App will use a light theme next time you open it"),
        trailing: new Switch(
            value: useDarkTheme,
            onChanged: (bool value){
              switchTheme(value);
            }
        ),
        onTap: (){ switchTheme(!useDarkTheme); },
      ),
    );
  }

  void switchTheme(bool isDark){
    setState(() {
      useDarkTheme = isDark;
    });
    _prefs.setBool('use_dark_theme', isDark);
    if (_wasDark != isDark){
      _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(useDarkTheme
          ? "Close and reopen Flip to apply the dark theme!"
          : "Close and reopen Flip to apply the light theme!"
      )) );
    }
  }
}