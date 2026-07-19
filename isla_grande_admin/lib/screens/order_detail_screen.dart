import 'package:flutter/material.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Pedido'),
      ),
      body: const Center(
        child: Text('Pantalla Detalle de Pedido'),
      ),
    );
  }
}
