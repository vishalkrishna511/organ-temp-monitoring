import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:organ_temperature_monitoring/models/dataModel.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import '../views/dashboardMain.dart';
import '../views/login.dart';

class LinePlot extends StatefulWidget {
  const LinePlot({super.key});

  @override
  State<LinePlot> createState() => _LinePlotState();
}

class _LinePlotState extends State<LinePlot> {
  List<TemperatureData> chartData = [];
  TooltipBehavior _tooltipBehavior = TooltipBehavior();
  late ChartSeriesController _chartSeriesController;

  @override
  void initState() {
    chartData = getChartData();
    Timer.periodic(const Duration(seconds: 1), updateDataSource);
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var currentIndex = 1;
    return SafeArea(
      child: Scaffold(
        body: SfCartesianChart(
          title: ChartTitle(text: 'Time vs Temperature!'),
          legend: Legend(isVisible: true),
          tooltipBehavior: _tooltipBehavior,
          series: <ChartSeries<TemperatureData, String>>[
            LineSeries<TemperatureData, String>(
              onRendererCreated: (ChartSeriesController controller) {
                _chartSeriesController = controller;
              },
              dataSource: chartData,
              name: 'Temperature °C',
              xValueMapper: (TemperatureData obj, _) => obj.time,
              yValueMapper: (TemperatureData obj, _) => obj.temp,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              enableTooltip: true,
            )
          ],
          primaryXAxis: CategoryAxis(
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            title: AxisTitle(text: 'Time'),
          ),
          primaryYAxis: NumericAxis(
              title: AxisTitle(text: 'Temperature °C'),
              labelFormat: '{value}°C',
              edgeLabelPlacement: EdgeLabelPlacement.hide),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
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
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const DashboardMain(),
                  ),
                );
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const LinePlot(),
                  ),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const loginPage(),
                  ),
                );
                break;
            }
          },
        ),
      ),
    );
  }

  List<TemperatureData> getChartData() {
    final List<TemperatureData> chartsData = [
      // TemperatureData('500', 31),
      // TemperatureData('501', 38),
      // TemperatureData('502', 33),
      // TemperatureData('503', 52),
      // TemperatureData('504', 15),
      TemperatureData('Null', 0.0),
    ];
    return chartsData;
  }

  Future<void> updateDataSource(Timer timer) async {
    var url = Uri.parse('https://organ-gamma.vercel.app/fetchespdata');

    final response = await http.get(url);
    final databody = json.decode(response.body).last;
    // print(databody);

    DataModel dataModel = DataModel.fromJson(databody);
    print(dataModel.Temperature);

    chartData.add(TemperatureData(
        dataModel.Timestamp, double.parse(dataModel.Temperature)));
    // chartData.removeAt(0);
    _chartSeriesController.updateDataSource(
      addedDataIndex: chartData.length - 1,
    );
  }
}

class TemperatureData {
  String time;
  double temp;

  TemperatureData(this.time, this.temp) {
    temp = temp;
    time = time;
  }
}
