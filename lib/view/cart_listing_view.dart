import 'package:curatech_ecom/viewModel/products_view_model.dart';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class CartListingScreen extends StatelessWidget {
  const CartListingScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Cart')),
      body: LayoutBuilder(
        builder: (context, constraints) => WhenRebuilder<ProductViewModel>(
            observe: () =>
                RM.get<ProductViewModel>()..setState((s) => s.fetchProducts()),
            onWaiting: () => Center(
                  child: CircularProgressIndicator(),
                ),
            onIdle: () => Center(
                  child: CircularProgressIndicator(),
                ),
            onError: (error) => Center(child: Text("$error")),
            onData: (model) {
              if (model.getSelectedProduct.isNotEmpty) {
                return ListView.builder(
                    itemCount: model.getSelectedProduct.length,
                    itemBuilder: (context, index) =>
                        _getProductCard(model, index, constraints));
              } else {
                return _getEmptyCart();
              }
            }),
      ),
      bottomNavigationBar: _getBottomNavigation(),
    );
  }

  Center _getEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 200,
            width: 200,
            child: Image.asset('lib/assets/images/img_empty.gif',
                fit: BoxFit.contain),
          ),
          Text('Cart is empty',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600))
        ],
      ),
    );
  }

  StateBuilder<ProductViewModel> _getBottomNavigation() {
    return StateBuilder<ProductViewModel>(
      observe: () => RM.get<ProductViewModel>(),
      builder: (context, model) => Container(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 32),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
            Text(
              '\$ ${model.state.getSelectedProduct.map((e) => e.price).fold<double>(0, (previousValue, element) => previousValue + element).ceil()}',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            )
          ],
        ),
      ),
    );
  }

  Widget _getProductCard(
      ProductViewModel model, int index, BoxConstraints constraints) {
    return Container(
      child: Card(
        elevation: 4,
        child: ListTile(
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Text(
              '${model.getSelectedProduct.elementAt(index).title}',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
          subtitle: Text('\$${model.getSelectedProduct.elementAt(index).price}',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
          leading: AspectRatio(
            aspectRatio: 1,
            child: Image.network(
              '${model.getSelectedProduct.elementAt(index).image}',
              fit: BoxFit.cover,
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.remove_circle_outline,
              color: Colors.red,
            ),
            onPressed: () {
              Future.delayed(Duration(milliseconds: 100), () {
                RM.get<ProductViewModel>().setState((s) => s
                    .removeFromCart(model.getSelectedProduct.elementAt(index)));
              });
            },
          ),
        ),
      ),
    );
  }
}
