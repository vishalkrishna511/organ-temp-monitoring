import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';

import 'package:intl/intl.dart';
import 'package:organ_temperature_monitoring/models/dataModel.dart';
import 'package:organ_temperature_monitoring/services/plot.dart';
import 'package:organ_temperature_monitoring/views/login.dart';
import 'package:permission_handler/permission_handler.dart';

class DashboardMain extends StatefulWidget {
  const DashboardMain({super.key});

  @override
  State<DashboardMain> createState() => _DashboardMainState();
}

class _DashboardMainState extends State<DashboardMain> {
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
      getTempData();
    });
  }

  // a future method that fetch data from API
  Future<void> getTempData() async {
    var url = Uri.parse('https://organ-gamma.vercel.app/fetchespdata');

    final response = await http.get(url);
    final databody = json.decode(response.body).last;
    // print(databody);

    DataModel dataModel = DataModel.fromJson(databody);

    // add API response to stream controller sink
    _streamController.sink.add(dataModel);
  }

  @override
  Widget build(BuildContext context) {
    getCSV() async {
      var url = Uri.parse('https://organ-gamma.vercel.app/fetchespdata');
      final response = await http.get(url);
      final databody = json.decode(response.body);

      int index = databody.length;
      List<List<String>> records = <List<String>>[];
      List<String> row = <String>[];
      var directory;
      records.add(['Temperature', 'Time Stamp', 'Battery']);
      for (int i = 0; i < index; i++) {
        row.add(databody[i]['Temperature'].toString());
        row.add(databody[i]['Timestamp'].toString());
        row.add(databody[i]['Battery'].toString());
        records.add(row);
        row = [];
      }
      print(records);
      if (await Permission.storage.request().isGranted) {
        String csvData = const ListToCsvConverter().convert(records);

        try {
          if (await Permission.manageExternalStorage.request().isGranted) {
            directory = (await DownloadsPath.downloadsDirectory())?.path ??
                "Downloads path doesn't exist";
          }
          directory = (await DownloadsPath.downloadsDirectory())?.path ??
              "Downloads path doesn't exist";

          // var dirType = DownloadDirectoryTypes.dcim;
          // downloadsPath = (await DownloadsPath.downloadsDirectory(dirType: dirType))?.path ?? "Downloads path doesn't exist";
        } catch (e) {
          directory = 'Failed to get downloads paths';
        }
        print(directory);
        final path =
            "$directory/csv-${DateFormat("dd-MM-yyyy_HH:mm:ss").format(DateTime.now())}.csv";
        final File file = File(path);
        await file.writeAsString(csvData);
      }
      Map<Permission, PermissionStatus> statuses = await [
        // Permission.location,
        Permission.storage,
      ].request();
      // print(statuses[Permission.location]);
    }

    var currentIndex = 0;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/Swasth.png'),
                    fit: BoxFit.scaleDown)),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: () {
                getCSV();
              },
            )
          ]),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black,
              Colors.black45,
              Color.fromARGB(255, 8, 106, 218),
            ],
          ),
        ),
        child: StreamBuilder<DataModel>(
          stream: _streamController.stream,
          builder: (context, snapdata) {
            switch (snapdata.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              default:
                if (snapdata.hasError) {
                  return const Text('Please Wait....');
                } else {
                  return buildTemperatureWidget(snapdata.data!);
                }
            }
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        selectedItemColor: Colors.cyan[50],
        unselectedLabelStyle:
            const TextStyle(color: Colors.white, fontSize: 14),
        unselectedItemColor: Colors.white,
        currentIndex: currentIndex,
        items: [
          const BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home_rounded),
          ),
          BottomNavigationBarItem(
            label: 'Plot',
            icon: Icon(
              Icons.stacked_line_chart_rounded,
              color: Colors.cyan[50],
            ),
          ),
          BottomNavigationBarItem(
            label: 'Logout',
            icon: Icon(
              Icons.logout_rounded,
              color: Colors.cyan[50],
            ),
          ),
        ],
        onTap: (int index) {
          switch (index) {
            // case 0:
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (BuildContext context) => const Dashboard(),
            //     ),
            //   );
            //   break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const LinePlot(),
                ),
              );
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const loginPage(),
                ),
              );
              break;
          }
        },
      ),
    );
  }

  Widget buildTemperatureWidget(DataModel dataModel) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, top: 8.0),
      child: ListView(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(children: [
                  const Text(
                    'Temperature: ',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                  Text(
                    dataModel.Temperature,
                    style: const TextStyle(fontSize: 25, color: Colors.white),
                  ),
                  const Text(
                    ' °C',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ]),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const Text(
                      'Time: ',
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                    Text(
                      dataModel.Timestamp,
                      style: const TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const Text(
                      'Battery: ',
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                    Text(
                      dataModel.Battery,
                      style: const TextStyle(fontSize: 25, color: Colors.white),
                    ),
                    const Text(
                      ' %',
                      style: const TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
