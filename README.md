# CATALOGO PARA BODEGON ISLA GRANDE
**Proyecto**: Isla Grande - Sistema Centralizado Click & Collect

# Plataforma: Aplicación Móvil (Administrador) y Entorno Web (Cliente)

Versión: 1.0.0

1. **Visión y Propósito del Producto**

- **El Problema**: 

Las tiendas ubicadas en zonas turísticas de la Isla de Margarita enfrentan constantes barreras de idioma en el mostrador, lo que ralentiza el proceso de atención, genera confusiones en las órdenes y limita la exhibición completa de los productos a los visitantes internacionales.

- **La Solución**: 

Un sistema logístico de Reserva y Retira. El turista escanea un código QR en la tienda para acceder a un catálogo web visual en su idioma, donde arma su pedido de forma autónoma. Al finalizar, el sistema genera un número de orden. El turista se dirige a la caja física únicamente para dictar su código, realizar el pago presencial y retirar sus productos, mientras el administrador gestiona la cola de entregas desde una aplicación móvil centralizada.

**Fuera de Alcance**: Para garantizar un flujo ágil y evitar regulaciones fiscales complejas, el sistema NO procesa pagos electrónicos ni emite facturas fiscales. Es una herramienta estrictamente de gestión logística y comunicación multilingüe.

2. **Público Objetivo (User Personas)**

- **El Turista (Usuario Web)**: Busca rapidez, claridad visual de lo que está comprando y evitar la fricción del idioma al comunicarse con el cajero. Su interacción es de "solo lectura" (catálogo) y "escritura temporal" (emitir orden).

- **El Administrador / Cajero (Usuario App Móvil)**: Requiere una interfaz asimétrica, rápida y sin distracciones para despachar pedidos rápidamente, alertarse sobre falta de inventario y cerrar la tienda digitalmente cuando sea necesario.

3. **Requerimientos Funcionales (Épicas y Casos de Uso)**

- *Épica 1: Monitoreo y Métricas en Tiempo Real*

RF1.1 - **Dashboard de Estado**: El sistema debe calcular y mostrar en vivo la cantidad de pedidos en estado "Pendiente", pedidos "Concretados" y la sumatoria de ingresos en divisas generados en el día.

RF1.2 - **Alertas de Stock Crítico**: La aplicación debe filtrar el inventario y mostrar en un carrusel destacado (ej. CardSwiper) únicamente los productos cuya existencia en almacén sea menor a 5 unidades.

- *Épica 2: Gestión de Catálogo e Inventario*

RF2.1 - **Visualización y Búsqueda**: El administrador debe poder ver la lista completa de productos y filtrarlos en tiempo real utilizando un buscador nativo (SearchDelegate).

RF2.2 - **Mantenimiento Simplificado de Productos**: Creación y edición de productos con campos de Nombre, Precio, Stock, Imagen y Disponibilidad. Las categorías deben seleccionarse mediante un menú desplegable estático para optimizar el tiempo de operación.

- *Épica 3: Recepción de Órdenes y "Cierre de Caja"*

RF3.1 - **Cola de Trabajo**: Las órdenes entrantes deben encolarse en una pestaña de "Pendientes" mostrando claramente el Código Único (ej. #1045) y el nombre proporcionado por el turista.

RF3.2 - **Despacho (Concretar)**: Al aprobar un pedido, el sistema debe cambiar el estado a "Concretado" y deducir automáticamente las unidades vendidas del inventario maestro en la base de datos.

RF3.3 - **Abandono (Rechazar)**: Si un cliente no se presenta en mostrador, el administrador debe poder "Rechazar" el pedido. El sistema lo archivará en el historial sin alterar el stock de los productos.

- *Épica 4: Configuración Global y Requisitos Académicos*

RF4.1 - **Switch Maestro**: Un interruptor global que modifica el estado tiendaAbierta en la base de datos, habilitando o bloqueando la recepción de nuevas órdenes desde la web.

RF4.2 - **Auditoría de Desarrollo**: Inclusión de una sección visual con los avatares e información de los ingenieros responsables del sistema, cumpliendo con los lineamientos de evaluación académica.

4. **Requerimientos No Funcionales**

- RNF1 - **Usabilidad UI/UX**:

La interfaz móvil debe poseer un diseño moderno, asimétrico y corporativo, utilizando marcadores de posición (FadeInImage) para evitar cargas visuales bruscas o errores por imágenes inexistentes (Null Safety).

RNF2 - Arquitectura Limpia: Separación estricta de responsabilidades (Vistas, Modelos, Proveedores de estado, Rutas) y uso de "Archivos Barril" para las exportaciones.

RNF3 - Rendimiento de Red: Minimizar las lecturas a la base de datos centralizando la información en un estado global y calculando métricas de forma local.

5. Arquitectura y Stack Tecnológico
Frontend Móvil (Administrador): Flutter (Dart)

Frontend Web (Cliente): Flutter Web / HTML-JS (Responsivo)

Backend y Base de Datos: Firebase Realtime Database (Estructura JSON orientada a nodos: configuracion, productos, pedidos).

Gestión de Estado: Patrón Provider (^6.1.2).

Consumo de API: Paquete http (^1.2.0).

Herramientas de Soporte: Quicktype (Modelado de datos), WeasyPrint / Paquetes de Flutter PDF.

6. Equipo de Ingeniería
El escuadrón de desarrollo de Ingeniería de Sistemas está distribuido bajo las siguientes responsabilidades operativas:

Grisangelys María Martínez Rodríguez (Frontend & UI/UX Lead): Construcción de vistas en Flutter, manejo de navegación profunda, control del ThemeData corporativo y experiencia de usuario.

Eliezer (Logic & Providers Lead): Manejo del ciclo de vida de los datos, consumo de Firebase vía peticiones REST asíncronas, y algoritmos de actualización de inventario.

Roand (Backend & Web Lead): Diseño del árbol relacional JSON en Firebase, configuración de reglas de seguridad y estructuración de la interfaz responsiva del cliente.

Este PRD funciona como el contrato definitivo del producto. Delimita exactamente qué se va a programar, por qué se va a programar y quién es el responsable de cada engranaje, asegurando un desarrollo enfocado y libre de desviaciones.