import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _color= Colors.blue;
  var _width = 200.0;
  var _height = 200.0;
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: Icon(Icons.accessibility),
            elevation: 10.0,
            expandedHeight: 300.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "HelloWorld",
                //style: TextStyle(backgroundColor: Colors.black),
              ),
              background: Image.network(
                "https://images.squarespace-cdn.com/content/v1/5c3cfc14ee1759db7c445e26/1560382055230-N0M27Y9BQPSSROXQBZVL/ke17ZwdGBToddI8pDm48kDHPSfPanjkWqhH6pl6g5ph7gQa3H78H3Y0txjaiv_0fDoOvxcdMmMKkDsyUqMSsMWxHk725yiiHCCLfrh8O1z4YTzHvnKhyp6Da-NYroOW3ZGjoBKy3azqku80C789l0mwONMR1ELp49Lyc52iWr5dNb1QJw9casjKdtTg1_-y4jz4ptJBmI9gQmbjSQnNGng/Panda.jpg?format=2500w",
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Hero(
                    tag: 'this',
                    child: GestureDetector(
                      child: FlutterLogo(
                        size: 100,
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Photo()));
                      },
                    ),
                  ),
                  Text(
                    'You have pushed the button this many times:',
                  ),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.display1,
                  ),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        _color = _color == Colors.red?Colors.blue:Colors.red;
                        _width = _width == 300.0?200.0:300.0;
                         _height = _height == 300.0?200.0:300.0;
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      curve: Curves.easeIn,
                      child: Material(
                        borderRadius: BorderRadius.all(Radius.circular(200.0)),
                        color: _color,
                        child: Container(
                          width: _width,
                          height: _height,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class Photo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          tag: 'this',
          child: FlutterLogo(
            size: 200,
          ),
        ),
      ),
    );
  }
}
