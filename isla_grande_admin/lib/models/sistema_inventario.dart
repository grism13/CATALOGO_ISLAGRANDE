import 'dart:convert';

SistemaInventario sistemaInventarioFromJson(String str) =>
    SistemaInventario.fromJson(json.decode(str));

String sistemaInventarioToJson(SistemaInventario data) =>
    json.encode(data.toJson());

class SistemaInventario {
  Configuracion configuracion;
  Map<String, MetricaMes> metricas;
  Map<String, Pedido> pedidos;
  Map<String, Producto> productos;

  SistemaInventario({
    required this.configuracion,
    required this.metricas,
    required this.pedidos,
    required this.productos,
  });

  factory SistemaInventario.fromJson(Map<String, dynamic> json) =>
      SistemaInventario(
        configuracion: Configuracion.fromJson(json["configuracion"] ?? {}),
        metricas: json["metricas"] != null
            ? Map.from(json["metricas"]).map((k, v) =>
                MapEntry<String, MetricaMes>(k, MetricaMes.fromJson(v)))
            : {},
        pedidos: json["pedidos"] != null
            ? Map.from(json["pedidos"]).map((k, v) =>
                MapEntry<String, Pedido>(k, Pedido.fromJson(v)))
            : {},
        productos: json["productos"] != null
            ? Map.from(json["productos"]).map((k, v) =>
                MapEntry<String, Producto>(k, Producto.fromJson(v)))
            : {},
      );

  Map<String, dynamic> toJson() => {
        "configuracion": configuracion.toJson(),
        "metricas": Map.from(metricas)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "pedidos": Map.from(pedidos)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "productos": Map.from(productos)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
      };
}

class Configuracion {
  DateTime fechaActualizacion;
  double tasaBcv;
  bool tiendaAbierta;

  Configuracion({
    required this.fechaActualizacion,
    required this.tasaBcv,
    required this.tiendaAbierta,
  });

  factory Configuracion.fromJson(Map<String, dynamic> json) => Configuracion(
        fechaActualizacion: json["fechaActualizacion"] != null
            ? DateTime.parse(json["fechaActualizacion"])
            : DateTime.now(),
        tasaBcv: json["tasaBcv"]?.toDouble() ?? 0.0,
        tiendaAbierta: json["tiendaAbierta"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "fechaActualizacion": fechaActualizacion.toIso8601String(),
        "tasaBcv": tasaBcv,
        "tiendaAbierta": tiendaAbierta,
      };
}

class MetricaMes {
  Map<String, MetricaDia> dias;
  double ingresosMensualesDivisas;
  int totalPedidosMes;

  MetricaMes({
    required this.dias,
    required this.ingresosMensualesDivisas,
    required this.totalPedidosMes,
  });

  factory MetricaMes.fromJson(Map<String, dynamic> json) => MetricaMes(
        dias: json["dias"] != null
            ? Map.from(json["dias"]).map((k, v) =>
                MapEntry<String, MetricaDia>(k, MetricaDia.fromJson(v)))
            : {},
        ingresosMensualesDivisas:
            json["ingresosMensualesDivisas"]?.toDouble() ?? 0.0,
        totalPedidosMes: json["totalPedidosMes"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "dias": Map.from(dias)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "ingresosMensualesDivisas": ingresosMensualesDivisas,
        "totalPedidosMes": totalPedidosMes,
      };
}

class MetricaDia {
  double ingresosDiariosDivisas;
  int totalPedidosDia;

  MetricaDia({
    required this.ingresosDiariosDivisas,
    required this.totalPedidosDia,
  });

  factory MetricaDia.fromJson(Map<String, dynamic> json) => MetricaDia(
        ingresosDiariosDivisas:
            json["ingresosDiariosDivisas"]?.toDouble() ?? 0.0,
        totalPedidosDia: json["totalPedidosDia"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "ingresosDiariosDivisas": ingresosDiariosDivisas,
        "totalPedidosDia": totalPedidosDia,
      };
}

class Pedido {
  List<Articulo> articulos;
  String cliente;
  String codigoCorto;
  String estado;
  DateTime fecha;
  double tasaUsada;
  double totalBs;
  double totalDivisas;

  Pedido({
    required this.articulos,
    required this.cliente,
    required this.codigoCorto,
    required this.estado,
    required this.fecha,
    required this.tasaUsada,
    required this.totalBs,
    required this.totalDivisas,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) => Pedido(
        articulos: json["articulos"] != null
            ? List<Articulo>.from(
                json["articulos"].map((x) => Articulo.fromJson(x)))
            : [],
        cliente: json["cliente"] ?? '',
        codigoCorto: json["codigoCorto"] ?? '',
        estado: json["estado"] ?? 'pendiente',
        fecha: json["fecha"] != null
            ? DateTime.parse(json["fecha"])
            : DateTime.now(),
        tasaUsada: json["tasaUsada"]?.toDouble() ?? 0.0,
        totalBs: json["totalBs"]?.toDouble() ?? 0.0,
        totalDivisas: json["totalDivisas"]?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "articulos": List<dynamic>.from(articulos.map((x) => x.toJson())),
        "cliente": cliente,
        "codigoCorto": codigoCorto,
        "estado": estado,
        "fecha": fecha.toIso8601String(),
        "tasaUsada": tasaUsada,
        "totalBs": totalBs,
        "totalDivisas": totalDivisas,
      };
}

class Articulo {
  int cantidad;
  String idProducto;
  String nombre;
  double precioUnitario;
  double subtotal;

  Articulo({
    required this.cantidad,
    required this.idProducto,
    required this.nombre,
    required this.precioUnitario,
    required this.subtotal,
  });

  factory Articulo.fromJson(Map<String, dynamic> json) => Articulo(
        cantidad: json["cantidad"] ?? 0,
        idProducto: json["idProducto"] ?? '',
        nombre: json["nombre"] ?? '',
        precioUnitario: json["precioUnitario"]?.toDouble() ?? 0.0,
        subtotal: json["subtotal"]?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "cantidad": cantidad,
        "idProducto": idProducto,
        "nombre": nombre,
        "precioUnitario": precioUnitario,
        "subtotal": subtotal,
      };
}

class Producto {
  String id; 
  String categoria;
  String descripcion;
  bool disponible;
  bool estado;
  String imagen;
  String nombre;
  double precio;
  int stock;
  String url;

  Producto({
    this.id = '',
    required this.categoria,
    required this.descripcion,
    required this.disponible,
    required this.estado,
    required this.imagen,
    required this.nombre,
    required this.precio,
    required this.stock,
    required this.url,
  });

  factory Producto.fromJson(Map<String, dynamic> json) => Producto(
        categoria: json["categoria"] ?? '',
        descripcion: json["descripcion"] ?? '',
        disponible: json["disponible"] ?? false,
        estado: json["estado"] ?? false,
        imagen: json["imagen"] ?? '',
        nombre: json["nombre"] ?? '',
        precio: json["precio"]?.toDouble() ?? 0.0,
        stock: json["stock"] ?? 0,
        url: json["url"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "categoria": categoria,
        "descripcion": descripcion,
        "disponible": disponible,
        "estado": estado,
        "imagen": imagen,
        "nombre": nombre,
        "precio": precio,
        "stock": stock,
        "url": url,
      };
}
