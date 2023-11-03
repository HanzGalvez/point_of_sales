import 'package:point_of_sales/helpers/invoicelinedb.dart';
import 'package:point_of_sales/models/invoice_model.dart';

class InvoiceLine {
  String invoiceId;
  int productId;
  double productPrice;
  int qty;
  InvoiceLine({
    this.invoiceId = "",
    required this.productId,
    required this.productPrice,
    required this.qty,
  });

  double subTotal() {
    return productPrice * qty;
  }

  Map<String, dynamic> toMap() {
    return {
      InvoiceLineDBHelper.colInvoiceID: invoiceId,
      InvoiceLineDBHelper.colProductId: productId,
      InvoiceLineDBHelper.colPrice: productPrice,
      InvoiceLineDBHelper.colQty: qty,
    };
  }
}
