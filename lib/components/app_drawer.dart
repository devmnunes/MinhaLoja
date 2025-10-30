import 'package:flutter/material.dart';
import 'package:loja/models/auth.dart';
import 'package:loja/utils/app_routes.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    final isAdmin = auth.isAdmin; // Supondo que você tenha essa propriedade no seu model Auth

    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text(
              'HIGH DROPER',
              style: TextStyle(
                color: Colors.white,
                fontSize: 29,
                fontFamily: 'Lato',
              ),
            ),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Loja'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.AUTH_OR_HOME);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Pedidos'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.ORDERS);
            },
          ),
          const Divider(),
          // Correção da sintaxe do if
          if (isAdmin) ...[
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Gerenciar Produtos'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed(AppRoutes.PRODUCTS);
              },
            ),
            const Divider(),
          ],
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Sair'),
            onTap: () {
              Provider.of<Auth>(context, listen: false).logout();
              Navigator.of(context).pushReplacementNamed(AppRoutes.AUTH_OR_HOME);
            },
          ),
        ],
      ),
    );
  }
}