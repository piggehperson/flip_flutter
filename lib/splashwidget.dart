import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

class SplashWidget extends StatefulWidget {
  SplashWidget({Key key, this.size, this.child}) : assert(size != null), super(key: key);
  double size;
  Widget child;

  @override
  SplashWidgetState createState() => new SplashWidgetState();
}

class SplashWidgetState extends State<SplashWidget>
    with SingleTickerProviderStateMixin {
  Animation<double> sizeAnimation;
  Animation<double> opacityAnimation;
  AnimationController controller;
  CurvedAnimation curvedAnimation;

  @override
  initState() {
    super.initState();
    controller = new AnimationController(
        duration: const Duration(milliseconds: 250), vsync: this);
    /*sizeAnimation = new Tween(begin: 0.0, end: widget.size).chain(
        new CurveTween(
          curve: Curves.easeInOut,
        )
    ).animate(controller)
      ..addListener((){
        setState(() {

        });
      })
    ;*/
    opacityAnimation = new CurvedAnimation(parent: controller, curve: Curves.easeIn);
  }

  void splash(){
    controller.reset();
    controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context){
    return new Container(
        width:widget.size,
        height: widget.size,
        child: new Stack(children: <Widget>[
          new Container(
              width:widget.size,
              height: widget.size,
              child: new Opacity(
                opacity: 1 -opacityAnimation.value,
                child: new DecoratedBox(decoration: new BoxDecoration(
                  color: Theme.of(context).accentColor,
                  shape: BoxShape.circle,
                ),),
              )
          ),
          new Center(child: widget.child),
        ],)
    );
  }
}