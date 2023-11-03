import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sales/helpers/productdb.dart';
import 'package:point_of_sales/models/category_model.dart';
import 'package:point_of_sales/models/product_model.dart';
import 'package:point_of_sales/screen/product_details_screen.dart';
import '../components/bottom_navbar_component.dart';
import '../components/drawer_component.dart';
import '../components/floating_action_order_component.dart';

class CategoryProductList extends StatefulWidget {
  CategoryProductList({
    super.key,
    required this.category,
  });
  Category category;

  @override
  State<CategoryProductList> createState() => _CategoryProductListState();
}

class _CategoryProductListState extends State<CategoryProductList> {
  List<Product> catProduct = [];
  bool isLoading = true;

  void _getProducList() async {
    final data = await ProductDBHelper.getList();
    setState(() {
      data.forEach((element) {
        if (element.catId == widget.category.id) {
          catProduct.add(element);
        }
      });
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProducList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text(
          widget.category.title,
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
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.green[700],
            ))
          : catProduct.isEmpty
              ? Center(
                  child: Text(
                    'No item',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: catProduct.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return ProductDetailsScreen(
                                      product: catProduct[index]);
                                },
                              ),
                            );
                          },
                          title: Text(
                            catProduct[index].name,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.green[700],
                            ),
                          ),
                          subtitle: Text(
                            catProduct[index].description,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Text(
                            "Stock: ${catProduct[index].stock.toString()}",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
      drawer: MyDrawer(),
      floatingActionButton: MyFloatingActionOrder(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavBar(active: -1),
    );
  }
}
