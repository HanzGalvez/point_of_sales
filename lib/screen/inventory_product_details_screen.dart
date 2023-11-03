import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sales/components/sales_chart_component.dart';
import 'package:point_of_sales/helpers/invoicedb.dart';
import 'package:point_of_sales/models/sales_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/bottom_navbar_component.dart';
import '../components/drawer_component.dart';
import '../components/floating_action_order_component.dart';
import '../helpers/categorydb.dart';
import '../helpers/invoicelinedb.dart';
import '../models/invoice_line_model.dart';
import '../models/product_model.dart';

class InventoryDetailsScreen extends StatefulWidget {
  InventoryDetailsScreen({super.key, required this.product});
  Product product;

  @override
  State<InventoryDetailsScreen> createState() => _InventoryDetailsScreenState();
}

class _InventoryDetailsScreenState extends State<InventoryDetailsScreen> {
  late final SharedPreferences prefs;

  List<Sales> sales = [
    Sales(name: "Mon", sales: 0),
    Sales(name: "Tue", sales: 0),
    Sales(name: "Wed", sales: 0),
    Sales(name: "Thu", sales: 0),
    Sales(name: "Fri", sales: 0),
    Sales(name: "Sat", sales: 0),
    Sales(name: "Sun", sales: 0),
  ];
  var stockController = TextEditingController();
  var _category = [];

  List<InvoiceLine> _productOrderList = [];
  bool _isLoading = true;

  void _getList() async {
    final data = await CategoryDBHelper.getSingleList(widget.product.catId);
    final ss = await InvoiceLineDBHelper.getList();
    ss.forEach((element) {
      print(element);
    });

    final list =
        await InvoiceLineDBHelper.getListofSingleProduct(widget.product.id);
    setState(() {
      _productOrderList = list;
      _category = data;
      _productOrderList.forEach((element) {
        String date = "";
        print(element.invoiceId + "ol");
        InvoiceDBHelper.getTimeStamp(element.invoiceId).then(
          (value) {
            if (value != "") {
              final date = DateTime.now();
              final producDate = DateTime.parse(value);
              int weeKofYearToday = getWeekOfYear(date.toString());
              int ProductWeekOfYear = getWeekOfYear(value);
              if ((producDate.year == date.year &&
                      producDate.month == date.month) &&
                  (weeKofYearToday == ProductWeekOfYear)) {
                final productDate = DateTime.parse(value);
                int day = productDate.weekday;
                sales[day - 1].sales += element.subTotal();
                setState(() {});
              }
            }
          },
        );
      });
      _isLoading = false;
    });
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

  int _totalSold() {
    int total = 0;
    _productOrderList.forEach((element) {
      total += element.qty;
    });
    return total;
  }

  double _totalSales() {
    double total = 0;
    _productOrderList.forEach((element) {
      total += element.subTotal();
    });
    return total;
  }

  @override
  void initState() {
    super.initState();
    _getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text(
          "Inventory: ${widget.product.name}",
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
      body: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name: ${widget.product.name}",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.green[800],
                          ),
                        ),
                        Text(
                          "Price: ${widget.product.price}",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          "Stock: ${widget.product.stock}",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                          ),
                        ),
                        Column(
                          children: [
                            if (widget.product.stock >= 1 &&
                                widget.product.stock <= 5)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  "Almost out of stock",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            if (widget.product.stock == 0)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  "Out of stock",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "Overall Product Summary: ",
                    style: GoogleFonts.poppins(
                      fontSize: 19,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(0, 0, 0, .8),
                    ),
                  ),
                ),
                Card(
                  color: Colors.green[700],
                  child: Container(
                    padding: EdgeInsets.all(15),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total sold items: ${_totalSold()}",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Total Sales: ${_totalSales()}",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SalesChart(data: sales, title: "Daily Sales for this week"),
              ],
            ),
          ),
        ),
      ),
      drawer: const MyDrawer(),
      floatingActionButton: const MyFloatingActionOrder(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavBar(active: 1),
    );
  }
}
