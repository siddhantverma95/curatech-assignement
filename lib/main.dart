import 'package:curatech_ecom/view/product_listing_view.dart';
import 'package:curatech_ecom/viewModel/products_view_model.dart';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Injector(
      inject: [Inject(() => ProductViewModel())],
      builder: (context) => MaterialApp(
        title: 'Curatech Assignment',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ProductListingView(),
      ),
    );
  }
}
