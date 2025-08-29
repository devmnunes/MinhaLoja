import 'package:flutter/material.dart';
import 'package:loja/models/product.dart';


class ProductItem extends StatelessWidget {
  final Product product;
  const ProductItem({
   required this.product, 
    Key? key,
}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.name),
      trailing: Container(
        width: 96,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () {

              }),

              IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).colorScheme.secondary,
              onPressed: () {
                
              } )
          ],
        ),
      ),
    );
  }
}