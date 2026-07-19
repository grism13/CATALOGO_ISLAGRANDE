import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/sistema_inventario.dart';

class InventoryProvider extends ChangeNotifier {
  final String _baseUrl = 'https://catalogo-25a73-default-rtdb.firebaseio.com';
  
  SistemaInventario? sistema;
  List<Producto> productos = [];
  List<Producto> lowStockProductos = [];
  
  String categoriaSeleccionada = 'TODOS';
  String searchQuery = '';

  int pedidosPendientes = 0;
  int pedidosConcretados = 0;
  double ingresos = 0.0;

  bool isLoading = true;
  bool mostrarEnBolivares = false;

  List<Producto> get productosFiltrados {
    List<Producto> filtrados = productos;
    
    if (categoriaSeleccionada != 'TODOS') {
      filtrados = filtrados.where((p) => p.categoria.toUpperCase() == categoriaSeleccionada).toList();
    }
    
    if (searchQuery.isNotEmpty) {
      filtrados = filtrados.where((p) => p.nombre.toLowerCase().contains(searchQuery.toLowerCase())).toList();
    }
    
    return filtrados;
  }

  void setCategoria(String categoria) {
    categoriaSeleccionada = categoria;
    notifyListeners();
  }

  void setBusqueda(String query) {
    searchQuery = query;
    notifyListeners();
  }

  void toggleMoneda() {
    mostrarEnBolivares = !mostrarEnBolivares;
    notifyListeners();
  }

  InventoryProvider() {
    cargarDatos();
  }

  Future<void> actualizarTasaBCV() async {
    try {
      final response = await http.get(Uri.parse('https://raw.githubusercontent.com/enzonotario/dolarapi.com/main/datos/ve/v1/dolares/oficial/index.json'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final double promedio = (data['promedio'] ?? 0.0).toDouble();
        final String fechaAct = data['fechaActualizacion'] ?? DateTime.now().toIso8601String();

        if (promedio > 0) {
          final patchResponse = await http.patch(
            Uri.parse('$_baseUrl/configuracion.json'),
            body: json.encode({
              "tasaBcv": promedio,
              "fechaActualizacion": fechaAct,
            }),
          );

          if (patchResponse.statusCode == 200 && sistema != null) {
            sistema!.configuracion.tasaBcv = promedio;
            sistema!.configuracion.fechaActualizacion = DateTime.parse(fechaAct);
            notifyListeners();
          }
        }
      }
    } catch (e) {
    }
  }

  Future<String?> subirImagenImgBB(String imagePath) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse('https://api.imgbb.com/1/upload?key=77e66b2f24cb4f177a1c1a71bd7207ca'));
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
      
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final decoded = json.decode(responseData);
        return decoded['data']['display_url'];
      }
    } catch (e) {
    }
    return null;
  }

  Future<void> cargarDatos() async {
    isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse('$_baseUrl/.json');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = json.decode(response.body);
        sistema = SistemaInventario.fromJson(decodedData);
        
        productos = [];
        if (sistema?.productos != null) {
          sistema!.productos.forEach((key, value) {
            value.id = key; 
            productos.add(value);
          });
        }
        
        lowStockProductos = productos.where((p) => p.stock < 3).toList();

        pedidosPendientes = 0;
        pedidosConcretados = 0;
        ingresos = 0.0;
        
        if (sistema?.pedidos != null) {
          sistema!.pedidos.forEach((key, pedido) {
            if (pedido.estado == 'pendiente') {
              pedidosPendientes++;
            } else if (pedido.estado == 'finalizado' || pedido.estado == 'concretado') {
              pedidosConcretados++;
              ingresos += pedido.totalDivisas;
            }
          });
        }
        
        if (pedidosConcretados == 0 && ingresos == 0.0) {
          if (sistema?.metricas != null) {
            final now = DateTime.now();
            final mesStr = "${now.year}-${now.month.toString().padLeft(2, '0')}";
            final metricaMes = sistema!.metricas[mesStr];
            if (metricaMes != null) {
              ingresos = metricaMes.ingresosMensualesDivisas;
              pedidosConcretados = metricaMes.totalPedidosMes;
            }
          }
        }

        actualizarTasaBCV();
      }
    } catch (e) {
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> actualizarProducto(Producto producto) async {
    try {
      final url = Uri.parse('$_baseUrl/productos/${producto.id}.json');
      final response = await http.patch(
        url,
        body: json.encode({
          "nombre": producto.nombre,
          "categoria": producto.categoria,
          "precio": producto.precio,
          "stock": producto.stock,
          "descripcion": producto.descripcion,
          "disponible": producto.disponible,
          "url": producto.url,
        }),
      );

      if (response.statusCode == 200) {
        await cargarDatos();
        return true;
      }
    } catch (e) {
    }
    return false;
  }

  Future<bool> crearProducto(Producto producto) async {
    try {
      final url = Uri.parse('$_baseUrl/productos.json');
      final response = await http.post(
        url,
        body: json.encode({
          "nombre": producto.nombre,
          "categoria": producto.categoria,
          "precio": producto.precio,
          "stock": producto.stock,
          "descripcion": producto.descripcion,
          "disponible": producto.disponible,
          "estado": producto.estado,
          "imagen": producto.imagen,
          "url": producto.url,
        }),
      );

      if (response.statusCode == 200) {
        await cargarDatos();
        return true;
      }
    } catch (e) {
    }
    return false;
  }

  Future<bool> eliminarProducto(String id) async {
    try {
      final url = Uri.parse('$_baseUrl/productos/$id.json');
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        await cargarDatos();
        return true;
      }
    } catch (e) {
    }
    return false;
  }

  Future<bool> actualizarEstadoPedido(String codigoCorto, String nuevoEstado) async {
    try {
      final url = Uri.parse('$_baseUrl/pedidos/$codigoCorto.json');
      final response = await http.patch(
        url,
        body: json.encode({"estado": nuevoEstado}),
      );

      if (response.statusCode == 200) {
        await cargarDatos(); 
        return true;
      }
    } catch (e) {
    }
    return false;
  }
}
