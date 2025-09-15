import 'package:flutter/material.dart';
import 'package:loja/components/app_drawer.dart';
import 'package:loja/components/order.dart';
import 'package:loja/models/order_list.dart';
import 'package:loja/models/product_list.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key}) : super(key: key);

  Future<void> _refreshProducts(BuildContext context) {
    return Provider.of<ProductList>(context, listen: false).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final OrderList orders = Provider.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Meus Pedidos')),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: orders.itemsCount,
            itemBuilder: (ctx, i) => OrderWidget(order: orders.items[i]),
          ),
        ),
      ),
    );
  }
}
