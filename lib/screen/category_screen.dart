import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sales/components/edit_category_modal_component.dart';
import 'package:point_of_sales/helpers/categorydb.dart';
import 'package:point_of_sales/models/category_model.dart';

import 'package:point_of_sales/screen/category_product_list_screen.dart';
import '../components/add_category_modal_component.dart';
import '../components/bottom_navbar_component.dart';
import '../components/drawer_component.dart';
import '../components/floating_action_order_component.dart';

class CategoryScreen extends StatefulWidget {
  CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return FutureBuilder(
      future: CategoryDBHelper.getList(),
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> list) {
        if (list.hasData) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Colors.green[700],
              title: Text(
                "Category",
                style: GoogleFonts.lato(
                  fontSize: 23,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        int addedId = 0;
                        return AddCategoryModel(
                          add: (temp) async {
                            addedId = await CategoryDBHelper.insert(temp);
                            setState(() {});
                          },
                          undo: () {
                            if (addedId != 0) {
                              setState(() {
                                CategoryDBHelper.delete(addedId);
                              });
                            }
                          },
                        );
                      },
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 20),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.add,
                          size: 22,
                        ),
                        Text(
                          "Add item",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              toolbarHeight: 60,
              elevation: 0,
              iconTheme: const IconThemeData(
                size: 30,
                color: Colors.white,
              ),
            ),
            body: list.data!.isEmpty
                ? Center(
                    child: Text(
                      'Category is empty',
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
                      itemCount: list.data!.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Dismissible(
                            confirmDismiss: (direction) {
                              return showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Opps..'),
                                    content: Text(
                                        "Are you sure you want to delete ${list.data![index]['title']} ?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        child: Text(
                                          'Cancel',
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green[700],
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        },
                                        child: Text(
                                          "Ok",
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                            background: Container(
                              padding: EdgeInsets.only(left: 20),
                              alignment: Alignment.centerLeft,
                              child: const Icon(
                                Icons.delete,
                                color: Color.fromRGBO(229, 57, 53, 1),
                              ),
                            ),
                            key: ValueKey(list.data![index]),
                            direction: DismissDirection.startToEnd,
                            onDismissed: (direction) async {
                              await CategoryDBHelper.delete(
                                list.data![index]['id'],
                              );
                              setState(() {});
                            },
                            child: ListTile(
                              leading: icons[list.data![index]['icon']],
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return CategoryProductList(
                                        category: Category(
                                            id: list.data![index]['id'],
                                            title: list.data![index]['title'],
                                            description: list.data![index]
                                                ['desc'],
                                            icon: list.data![index]['icon']),
                                      );
                                    },
                                  ),
                                );
                              },
                              title: Text(
                                list.data![index]['title'],
                                style: GoogleFonts.poppins(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green[700],
                                ),
                              ),
                              subtitle: Text(
                                list.data![index]['desc'],
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.edit_note_outlined,
                                  color: Color.fromRGBO(56, 142, 60, 1),
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => EditCategoryModel(
                                      edit: (temp) {
                                        setState(() {
                                          CategoryDBHelper.update(temp);
                                        });
                                      },
                                      category: Category(
                                          id: list.data![index]['id'],
                                          title: list.data![index]['title'],
                                          description: list.data![index]
                                              ['desc'],
                                          icon: list.data![index]['icon']),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            drawer: MyDrawer(),
            floatingActionButton: MyFloatingActionOrder(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomNavBar(active: -1),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                  color: Color.fromRGBO(56, 142, 60, 1)),
            ),
          );
        }
      },
    );
  }
}
