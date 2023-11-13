import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:point_of_sales/components/search_product_component.dart';
import 'package:point_of_sales/helpers/invoicedb.dart';
import 'package:point_of_sales/models/product_model.dart';
import 'package:point_of_sales/screen/category_screen.dart';
import 'package:point_of_sales/screen/product_screen.dart';
import 'package:point_of_sales/screen/sales_screen.dart';
import 'package:point_of_sales/screen/transaction_screen.dart';
import '../components/bottom_navbar_component.dart';
import '../components/change_user_modal_component.dart';
import '../components/drawer_component.dart';
import '../components/floating_action_order_component.dart';
import '../components/grid_navbar_component.dart';
import '../components/most_latest_product_card_component.dart';
import '../components/most_popular_product_card_component.dart';
import '../helpers/invoicelinedb.dart';
import '../helpers/productdb.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _controller;
  List<Product> _productlist = [];
  List<Map<String, dynamic>> _popular = [];
  List<Product> _searchList = [];
  bool isSearch = false;
  bool _isLoading = true;
  int totalSoldItem = 0;
  double salesToday = 0;
  void _loadData() async {
    final result = await InvoiceLineDBHelper.getPopularProduct();
    final listofInvoice = await InvoiceDBHelper.getList();
    final listofInvoiceLine = await InvoiceLineDBHelper.getList();
    final data = await ProductDBHelper.getList();
    setState(() {
      _productlist = data;
      _popular = result;
      listofInvoice.forEach((element) {
        final date = DateTime.now();
        final productDate = DateTime.parse(element.date);
        int yearToday = date.year;
        int monthToday = date.month;
        int productYear = productDate.year;
        int productMonth = date.month;
        if (yearToday == productYear) {
          if (monthToday == productMonth) {
            if (date.day == productDate.day) {
              salesToday += element.totalAmount;
            }
          }
        }
      });
      listofInvoiceLine.forEach((element) {
        totalSoldItem += element.qty;
      });
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    bool showFab = MediaQuery.of(context).viewInsets.bottom == 0;
    double width = MediaQuery.of(context).size.width;
    return _isLoading
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Center(
                child: CircularProgressIndicator(
              color: Colors.green[700],
            )),
          )
        : Scaffold(
            backgroundColor: Colors.green[800],
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return ChangeUser();
                      },
                    );
                  },
                  icon: Icon(Icons.data_usage_rounded),
                ),
              ],
              centerTitle: true,
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
                "iTrack",
                style: GoogleFonts.poppins(
                  fontSize: 30,
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
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  child: Container(
                    color: Colors.green[800],
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [],
                    ),
                  ),
                ),
                isSearch
                    ? Expanded(
                        child: Container(
                            color: Colors.white,
                            child: SearchList(searchList: _searchList)),
                      )
                    : Expanded(
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 10,
                                ),
                                child: GridView(
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 5 / 2,
                                    crossAxisSpacing: 10,
                                  ),
                                  children: [],
                                ),
                              ),
                              if (!isSearch)
                                Container(
                                  height: 200,
                                  child: Card(
                                    elevation: 5,
                                    margin: const EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 15, left: 25),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Today's sales:",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 12),
                                                    child: Text(
                                                      "P${salesToday}", // Peso sign
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                          color: Colors.white,
                                          child: GridView(
                                            shrinkWrap: true,
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 4,
                                              childAspectRatio: 3 / 2,
                                            ),
                                            children: [
                                              gridNavBArCard(
                                                goto: ProductScreen(),
                                                icon: Icons.view_list_outlined,
                                                title: "",
                                              ),
                                              gridNavBArCard(
                                                goto: CategoryScreen(),
                                                icon: Icons.category_outlined,
                                                title: "",
                                              ),
                                              gridNavBArCard(
                                                goto: TransactionScreen(),
                                                icon:
                                                    Icons.card_travel_outlined,
                                                title: "",
                                              ),
                                              gridNavBArCard(
                                                goto: SalesScreen(),
                                                icon: Icons.money_outlined,
                                                title: "",
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                "Products", // Peso sign
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                "Category", // Peso sign
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                "Transaction", // Peso sign
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                "Reports", // Peso sign
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 15, left: 15),
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextField(
                                    style: GoogleFonts.poppins(
                                      fontSize: 17,
                                      color: Colors.white,
                                    ),
                                    onChanged: (value) {
                                      _searchList = [];
                                      if (value == "") {
                                        isSearch = false;
                                        setState(() {});
                                      } else {
                                        isSearch = true;
                                        _productlist.forEach((element) {
                                          if (element.name
                                              .toLowerCase()
                                              .contains(value.toLowerCase())) {
                                            _searchList.add(element);
                                          }
                                        });
                                        setState(() {});
                                      }
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Search Product...",
                                      hintStyle: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 15.0),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              TabBar(
                                indicatorColor: Colors.green[700],
                                padding: EdgeInsets.symmetric(vertical: 5),
                                labelStyle: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                labelColor: Colors.black,
                                controller: _controller, // length of tabs
                                tabs: [
                                  Tab(text: 'Popular Product'),
                                  Tab(text: 'Latest Product'),
                                ],
                              ),
                              Expanded(
                                child: TabBarView(
                                  controller: _controller,
                                  children: [
                                    _popular.isEmpty
                                        ? Center(
                                            child: Text(
                                              "Data is empty",
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18,
                                                color:
                                                    Color.fromRGBO(0, 0, 0, .7),
                                              ),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: _popular.length,
                                              itemBuilder: (context, index) {
                                                var product =
                                                    _productlist.singleWhere(
                                                  (element) =>
                                                      element.id ==
                                                      _popular[index]
                                                          ['product_id'],
                                                  orElse: () {
                                                    return Product(
                                                        barcode: "",
                                                        name:
                                                            "<Product Not Found>",
                                                        catId: 0,
                                                        description: "",
                                                        price: 0,
                                                        measurement: "",
                                                        retailPrice: 0);
                                                  },
                                                );
                                                return PopularProductCard(
                                                  product: product,
                                                  totalsales: double.parse(
                                                      _popular[index]
                                                              ['totalSales']
                                                          .toString()),
                                                  totalsold: _popular[index]
                                                      ['total'],
                                                );
                                              },
                                            ),
                                          ),
                                    _productlist.isEmpty
                                        ? Center(
                                            child: Text(
                                              "No item",
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18,
                                                color:
                                                    Color.fromRGBO(0, 0, 0, .7),
                                              ),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ListView.builder(
                                              itemCount:
                                                  _productlist.length >= 3
                                                      ? 3
                                                      : _productlist.length,
                                              itemBuilder: (context, index) {
                                                return LatestProductCard(
                                                    product:
                                                        _productlist[index]);
                                              },
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
            drawer: MyDrawer(),
            floatingActionButton:
                Visibility(visible: showFab, child: MyFloatingActionOrder()),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomNavBar(active: 0),
          );
  }
}
