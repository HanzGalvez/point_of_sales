import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/sales_model.dart';

class SalesChart extends StatelessWidget {
  SalesChart({
    required this.data,
    required this.title,
    Key? key,
  }) : super(key: key);
  String title;
  List<Sales> data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.all(8),
          height: 300,
          child: SfCartesianChart(
            title: ChartTitle(
              textStyle: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.green[700],
              ),
              text: title,
            ),
            primaryXAxis: CategoryAxis(),
            plotAreaBorderColor: Colors.green[700],
            borderColor: Color.fromRGBO(56, 142, 60, 1),
            margin: EdgeInsets.all(10),
            series: <LineSeries<Sales, String>>[
              LineSeries<Sales, String>(
                dataSource: data,
                xValueMapper: (Sales sales, _) => sales.name,
                yValueMapper: (Sales sales, _) => sales.sales,
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  color: Colors.green[700],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
