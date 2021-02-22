import 'package:curatech_ecom/view/cart_listing_view.dart';
import 'package:curatech_ecom/viewModel/products_view_model.dart';
import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class ProductListingView extends StatelessWidget {
  const ProductListingView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Curatech Ecom'),
        ),
        body: ProductsPage(),
        floatingActionButton: Stack(
          children: [_getCartFloatingButton(context), _getCartBadge()],
        ));
  }

  Positioned _getCartBadge() {
    return Positioned(
      right: 1,
      top: -3,
      child: Container(
        padding: EdgeInsets.all(6),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red,
        ),
        child: StateBuilder<ProductViewModel>(
            observe: () => RM.get<ProductViewModel>(),
            builder: (context, model) {
              return Text(
                '${model.state.getSelectedProduct.length}',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              );
            }),
      ),
    );
  }

  FloatingActionButton _getCartFloatingButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.shopping_cart),
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => CartListingScreen()));
      },
    );
  }
}

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key key}) : super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
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
          onData: (model) => ListView.builder(
              itemCount: model.getProductList.length,
              itemBuilder: (context, index) =>
                  _getProductCard(model, index, constraints))),
    );
  }

  Widget _getProductCard(
      ProductViewModel model, int index, BoxConstraints constraints) {
    return Container(
      child: Card(
        elevation: 4,
        child: Row(
          children: [
            _getItemImage(model, index),
            _getTitlePrice(model, index),
            _getAddToCartButton(model, index),
          ],
        ),
      ),
    );
  }

  Flexible _getAddToCartButton(ProductViewModel model, int index) {
    return Flexible(
      flex: 1,
      child: IconButton(
        icon: Icon(
          Icons.add_shopping_cart,
          color: Colors.black,
        ),
        onPressed: () {
          RM.get<ProductViewModel>().setState((s) =>
              s.addToCart(model.getProductList.elementAt(index)).then((value) {
                if (!value) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("Already added to the cart."),
                  ));
                }
              }));
        },
      ),
    );
  }

  Flexible _getItemImage(ProductViewModel model, int index) {
    return Flexible(
      flex: 2,
      child: Container(
        padding: EdgeInsets.all(8),
        width: 120,
        height: 120,
        child: Image.network(
          '${model.getProductList.elementAt(index).image}',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Expanded _getTitlePrice(ProductViewModel model, int index) {
    return Expanded(
      flex: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              '${model.getProductList.elementAt(index).title}',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: 4),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: Text('\$${model.getProductList.elementAt(index).price}',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
          ),
        ],
      ),
    );
  }
}
