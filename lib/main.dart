import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:test_future_init/my_home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This could be a network request to load a remote configuration file.
  Future<String> futureConfigurationString() {
    return Future.delayed(Duration(seconds: 4), () => 'Future configuration!');
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: Future.delayed(Duration(seconds: 3), () => 'Future Builder Return Value'),
        builder: (context, AsyncSnapshot<String> snapshot) {
          // This checks to see what state of the future we're in
          if (snapshot.hasData) {
            return homeView(snapshot.data);
          } else if (snapshot.hasError) {
            return errorView();
          } else {
            return loadingView(context);
          }
        });
  }

  Widget homeView(String data) {
    return MultiProvider(
        providers: <SingleChildWidget>[
          FutureProvider.value(value: futureConfigurationString()),
        ],
        child: MaterialApp(
          // this child is rendered IMMEDIATELY, but the value(s) provided will be updated and rebuilt
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: MyHomePage(title: data),
        ));
  }

  Widget errorView() {
    return MaterialApp(
        home: Center(
            child: Icon(
      Icons.error,
      color: Colors.red,
      size: 96,
    )));
  }

  Widget loadingView(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Center(
                child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(
        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)),
        width: 60,
        height: 60,
      ),
      Text(
        'Waiting for future builder',
        textAlign: TextAlign.center,
      ),
    ]))));
  }
}
