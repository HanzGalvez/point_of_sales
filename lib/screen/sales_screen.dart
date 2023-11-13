import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sales/models/sales_model.dart';

import '../components/bottom_navbar_component.dart';
import '../components/drawer_component.dart';
import '../components/floating_action_order_component.dart';
import '../components/sales_chart_component.dart';
import '../helpers/invoicedb.dart';
import '../helpers/invoicelinedb.dart';
import '../models/invoice_line_model.dart';
import '../models/invoice_model.dart';

class SalesScreen extends StatefulWidget {
  SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  double salesToday = 0;
  double salesMontly = 0;
  double overAllSales = 0;
  List<Sales> weekly = [
    Sales(name: 'Mon', sales: 0),
    Sales(name: 'Tue', sales: 0),
    Sales(name: 'Wed', sales: 0),
    Sales(name: 'Thu', sales: 0),
    Sales(name: 'Fri', sales: 0),
    Sales(name: 'Sat', sales: 0),
    Sales(name: 'Sun', sales: 0),
  ];
  List<Sales> weeklyMonth = [
    Sales(name: 'Week 1', sales: 0),
    Sales(name: 'Week 2', sales: 0),
    Sales(name: 'Week 3', sales: 0),
    Sales(name: 'Week 4', sales: 0),
  ];

  List<Sales> monthly = [
    Sales(name: 'Jan', sales: 0),
    Sales(name: 'Feb', sales: 0),
    Sales(name: 'Mar', sales: 0),
    Sales(name: 'Apr', sales: 0),
    Sales(name: 'May', sales: 0),
    Sales(name: 'Jul', sales: 0),
    Sales(name: 'Aug', sales: 0),
    Sales(name: 'Sep', sales: 0),
    Sales(name: 'Oct', sales: 0),
    Sales(name: 'Nov', sales: 0),
    Sales(name: 'Dec', sales: 0),
  ];
  List<Sales> yearlySales = [
    Sales(name: '2023', sales: 0),
    Sales(name: '2024', sales: 0),
    Sales(name: '2025', sales: 0),
    Sales(name: '2026', sales: 0),
    Sales(name: '2027', sales: 0),
    Sales(name: '2028', sales: 0),
    Sales(name: '2029', sales: 0),
    Sales(name: '2030', sales: 0),
  ];
  List<Invoice> _invoiceList = [];
  bool _isLoading = true;
  double SalesComputed(List<Sales> data) {
    double total = 0;
    data.forEach((element) {
      total += element.sales;
    });
    return total;
  }

  void _getList() async {
    final list = await InvoiceDBHelper.getList();
    setState(() {
      _invoiceList = list;
      _invoiceList.forEach((element) {
        final date = DateTime.now();
        final productDate = DateTime.parse(element.date);
        int yearToday = date.year;
        int monthToday = date.month;
        int productYear = productDate.year;
        int productMonth = date.month;
        overAllSales += element.totalAmount;
        if (yearToday == productYear) {
          if (monthToday == productMonth) {
            //compute daily sales
            if (date.day == productDate.day) {
              salesToday += element.totalAmount;
            }
            //compute sales of the month
            salesMontly += element.totalAmount;
            //for weekly
            int weeKofYearToday = getWeekOfYear(date.toString());
            int ProductWeekOfYear = getWeekOfYear(productDate.toString());
            if (weeKofYearToday == ProductWeekOfYear) {
              int day = productDate.weekday;
              weekly[day - 1].sales += element.totalAmount;
            }
            //for week of month
            int wom = productDate.weekOfMonth;
            weeklyMonth[wom - 1].sales += element.totalAmount;
          }
          // montly
          monthly[productMonth - 1].sales += element.totalAmount;
        }
        yearlySales[productYear - 2023].sales += element.totalAmount;
      });
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getList();
  }

  int getWeekOfYear(String date) {
    final now = DateTime.parse(date);
    final firstJan = DateTime(now.year, 1, 1);
    final weekNumber = weeksBetween(firstJan, now);
    return weekNumber;
  }

  int weeksBetween(DateTime from, DateTime to) {
    from = DateTime.utc(from.year, from.month, from.day);
    to = DateTime.utc(to.year, to.month, to.day);
    return (to.difference(from).inDays / 7).ceil();
  }

  //all data presented is just tempory
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [Tab(text: "Sales"), Tab(text: "Profit")],
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.topRight,
                colors: [
                  Color.fromRGBO(45, 161, 95, 100),
                  Colors.green
                ], // Adjust the colors as needed
              ),
            ),
          ),
          title: Text(
            "Sales Information",
            style: GoogleFonts.lato(
              fontSize: 23,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          toolbarHeight: 60,
          elevation: 0,
          iconTheme: const IconThemeData(
            size: 30,
            color: Colors.white,
          ),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                color: Color.fromRGBO(213, 236, 223, 100),
              ))
            : TabBarView(children: [
                //Sales
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: Colors.white,
                        ),
                        Card(
                          child: Text(
                            "List of total sales",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        ListTile(
                          tileColor: Color.fromRGBO(213, 236, 223, 100),
                          title: Text(
                            "Today",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          trailing: Text(
                            "P${salesToday}",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        ListTile(
                          tileColor: Color.fromRGBO(213, 236, 223, 100),
                          title: Text(
                            "This Week",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          trailing: Text(
                            "P${SalesComputed(weekly)}",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        ListTile(
                          tileColor: Color.fromRGBO(213, 236, 223, 100),
                          title: Text(
                            "This Month",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          trailing: Text(
                            "P${salesMontly}",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        ListTile(
                          tileColor: Color.fromRGBO(213, 236, 223, 100),
                          title: Text(
                            "This Year",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          trailing: Text(
                            "P${SalesComputed(monthly)}",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        ListTile(
                          tileColor: Color.fromRGBO(213, 236, 223, 100),
                          title: Text(
                            "Overall Sales",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              color: Colors.black,
                            ),
                          ),
                          trailing: Text(
                            "P${overAllSales}",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SalesChart(
                          title: "Sales this week",
                          data: weekly,
                        ),
                        SalesChart(
                          title: "Weekly sales of the month",
                          data: weeklyMonth,
                        ),
                        SalesChart(
                          title: "Monthly sales of the year",
                          data: monthly,
                        ),
                        SalesChart(title: "Yearly Sales", data: yearlySales),
                      ],
                    ),
                  ),
                ),

//Profit

                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: Colors.white,
                        ),
                        Card(
                          child: Text(
                            "List of total profit",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        ListTile(
                          tileColor: Color.fromRGBO(213, 236, 223, 100),
                          title: Text(
                            "Today",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          trailing: Text(
                            "P${salesToday}",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        ListTile(
                          tileColor: Color.fromRGBO(213, 236, 223, 100),
                          title: Text(
                            "This Week",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          trailing: Text(
                            "P${SalesComputed(weekly)}",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        ListTile(
                          tileColor: Color.fromRGBO(213, 236, 223, 100),
                          title: Text(
                            "This Month",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          trailing: Text(
                            "P${salesMontly}",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        ListTile(
                          tileColor: Color.fromRGBO(213, 236, 223, 100),
                          title: Text(
                            "This Year",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          trailing: Text(
                            "P${SalesComputed(monthly)}",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        ListTile(
                          tileColor: Color.fromRGBO(213, 236, 223, 100),
                          title: Text(
                            "Overall Profit",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              color: Colors.black,
                            ),
                          ),
                          trailing: Text(
                            "P${overAllSales}",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SalesChart(
                          title: "Profit this week",
                          data: weekly,
                        ),
                        SalesChart(
                          title: "Weekly profit of the month",
                          data: weeklyMonth,
                        ),
                        SalesChart(
                          title: "Monthly profit of the year",
                          data: monthly,
                        ),
                        SalesChart(title: "Yearly profit", data: yearlySales),
                      ],
                    ),
                  ),
                ),
              ]),
        drawer: MyDrawer(),
        floatingActionButton: MyFloatingActionOrder(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavBar(active: -1),
      ),
    );
  }
}

extension DateTimeExtension on DateTime {
  int get weekOfMonth {
    var wom = 0;
    var date = this;

    while (date.month == month) {
      wom++;
      date = date.subtract(const Duration(days: 7));
    }
    return wom;
  }
}
