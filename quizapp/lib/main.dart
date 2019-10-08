import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:quizapp/quiz.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Quiz App",
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.black,
          brightness: Brightness.dark,
          backgroundColor: Colors.black),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Quiz quiz;
  List<Results> results;
  Future<void> fetchQuestions() async {
    var res = await http.get("https://opentdb.com/api.php?amount=20");
    var decRes = jsonDecode(res.body);
    print(decRes);
    quiz = Quiz.fromJson(decRes);
    results = quiz.results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz App"),
        elevation: 1.0,
      ),
      body: RefreshIndicator(
        onRefresh: fetchQuestions,
        child: FutureBuilder(
          future: fetchQuestions(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Text("Press button to START");
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                );
              case ConnectionState.done:
                if (snapshot.hasError) return errorData(snapshot);
                return questionList();
            }
            return null;
          },
        ),
      ),
    );
  }

  Padding errorData(AsyncSnapshot snapshot) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: Column(
        children: <Widget>[
          Text("Error: ${snapshot.error}"),
          SizedBox(
            height: 20.0,
          ),
          RaisedButton(
            onPressed: () {
              fetchQuestions();
              setState(() {});
            },
            child: Text("Try Again"),
          )
        ],
      ),
    );
  }

  ListView questionList() {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) => Card(
            color: Colors.black,
            elevation: 2.0,
            child: ExpansionTile(
              title: Padding(
                padding: EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      results[index].question,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FilterChip(
                            backgroundColor: Colors.white,
                            label: Text(
                              results[index].category,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            onSelected: (b) {},
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          FilterChip(
                            backgroundColor: Colors.white,
                            label: Text(
                              results[index].difficulty,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            onSelected: (b) {},
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              leading: CircleAvatar(
                child: Text(
                  results[index].type.startsWith("m") ? "M" : "B",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.white,
              ),
              children: results[index].allAnswers.map((m) {
                return AnswerWidget(results, index, m);
              }).toList(),
            ),
          ),
    );
  }
}

class AnswerWidget extends StatefulWidget {
  final List<Results> results;
  final int index;
  final String m;
  AnswerWidget(this.results, this.index, this.m);
  @override
  _AnswerListState createState() => _AnswerListState();
}

class _AnswerListState extends State<AnswerWidget> {
  var c = Colors.white;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        setState(() {
          if (widget.m == widget.results[widget.index].correctAnswer) {
            c = Colors.green;
          } else {
            c = Colors.red;
          }
        });
      },
      title: Text(
        widget.m,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, color: c),
      ),
    );
  }
}
