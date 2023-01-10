import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/dataModel.dart';

class DashDash extends StatelessWidget {
  const DashDash({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //create stream
  final StreamController<DataModel> _streamController = StreamController();

  @override
  void dispose() {
    // stop streaming when app close
    _streamController.close();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // A Timer method that run every 3 seconds

    Timer.periodic(const Duration(seconds: 3), (timer) {
      getCryptoPrice();
    });
  }

  // a future method that fetch data from API
  Future<void> getCryptoPrice() async {
    var url = Uri.parse('https://organ-gamma.vercel.app/fetchespdata');

    final response = await http.get(url);
    final databody = json.decode(response.body).last;
    print("data");
    print(databody);

    DataModel dataModel = DataModel.fromJson(databody);

    // add API response to stream controller sink
    _streamController.sink.add(dataModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder<DataModel>(
          stream: _streamController.stream,
          builder: (context, snapdata) {
            switch (snapdata.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              default:
                if (snapdata.hasError) {
                  return const Text('Please Wait....');
                } else {
                  return BuildCoinWidget(snapdata.data!);
                }
            }
          },
        ),
      ),
    );
  }

  Widget BuildCoinWidget(DataModel dataModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${dataModel.Temperature} C',
            style: const TextStyle(fontSize: 25),
          ),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            '\$${dataModel.Timestamp}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
