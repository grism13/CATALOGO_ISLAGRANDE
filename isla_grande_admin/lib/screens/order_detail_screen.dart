import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/inventory_provider.dart';
import '../models/sistema_inventario.dart';
import '../theme/app_theme.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pedido =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    Color statusBgColor;
    Color statusTextColor;
    String statusText = pedido['estado'].toString().capitalize();

    if (pedido['estado'] == 'pendiente') {
      statusBgColor = const Color(0xFFFFF4D2);
      statusTextColor = AppTheme.lightYellow;
    } else if (pedido['estado'] == 'concretado') {
      statusBgColor = const Color(0xFFD5F5E3);
      statusTextColor = const Color(0xFF27AE60);
    } else {
      statusBgColor = const Color.fromARGB(255, 251, 170, 30);
      statusTextColor = AppTheme.rechazado;
    }

    final Pedido pedidoBD = pedido['_modelo_original'] as Pedido;

    final List<Map<String, dynamic>> mockArticulos = pedidoBD.articulos.map((art) => {
      'nombre': art.nombre,
      'cantidad': art.cantidad,
      'precioUnitario': art.precioUnitario,
      'subtotal': art.subtotal,
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColorLight,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom Header
            Container(
              padding: const EdgeInsets.only(
                top: 50,
                left: 20,
                right: 20,
                bottom: 30,
              ),
              decoration: const BoxDecoration(
                color: AppTheme.darkBlue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppTheme.lightYellow,
                    ),
                  ),
                  Image.asset(
                    'assets/images/logotipo.png',
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Título y Estado
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'DETALLE DE PEDIDO',
                    style: TextStyle(
                      color: AppTheme.darkBlue,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusBgColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      statusText.toUpperCase(),
                      style: TextStyle(
                        color: statusTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _InfoBox(title: 'CLIENTE', value: pedido['cliente']),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _InfoBox(
                      title: 'HORA',
                      value: pedido['hora'] ?? '00:00',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _InfoBox(
                      title: 'FECHA',
                      value: pedido['fecha'] ?? '00/00/0000',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

      
            Center(
              child: Text(
                '#${pedido['id']}',
                style: const TextStyle(
                  color: AppTheme.darkBlue,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Artículos del Pedido',
                style: TextStyle(
                  color: AppTheme.darkBlue,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15),

            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: mockArticulos.length,
              itemBuilder: (context, index) {
                final art = mockArticulos[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            art['nombre'],
                            style: const TextStyle(
                              color: AppTheme.darkBlue,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'x${art['cantidad']} × \$${art['precioUnitario'].toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '\$${art['subtotal'].toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(color: Colors.grey, thickness: 0.5),
            ),
            const SizedBox(height: 15),

            // Total
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      color: AppTheme.darkBlue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\$${pedido['total'].toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            
            if (pedido['estado'] == 'pendiente')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.rechazado,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                    onPressed: () async {
                      final provider = Provider.of<InventoryProvider>(context, listen: false);
                      await provider.actualizarEstadoPedido(pedidoBD.codigoCorto, 'rechazado');
                      if (context.mounted) Navigator.pop(context);
                    },
                    child: const Text('RECHAZAR', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.concretado,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                    onPressed: () async {
                      final provider = Provider.of<InventoryProvider>(context, listen: false);
                      await provider.actualizarEstadoPedido(pedidoBD.codigoCorto, 'concretado');
                      if (context.mounted) Navigator.pop(context);
                    },
                    child: const Text('CONCRETAR', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  ),
                ],
              ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String title;
  final String value;

  const _InfoBox({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.lightYellow,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
