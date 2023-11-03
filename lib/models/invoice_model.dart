import 'package:point_of_sales/helpers/invoicedb.dart';

class Invoice {
  String id;
  double custumerPayAmount;
  double totalAmount;
  String date;
  Invoice({
    required this.id,
    required this.custumerPayAmount,
    this.totalAmount = 0,
    this.date = "",
  });

  Map<String, dynamic> toMap() {
    return {
      InvoiceDBHelper.colId: id,
      InvoiceDBHelper.colPay: custumerPayAmount,
      InvoiceDBHelper.colTotalAmount: totalAmount,
      InvoiceDBHelper.colDate: DateTime.now().toString(),
    };
  }
}
