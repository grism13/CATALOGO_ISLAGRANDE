# CATALOGO PARA BODEGON ISLA GRANDE
**Proyecto**: Isla Grande - Sistema Centralizado Click & Collect

# Plataforma: Aplicación Móvil (Administrador) y Entorno Web (Cliente)

***IMPPRTANTE**: En La rama Main se escuentra unicamente la documentacion, en la rama de App se escuentra la app de administrador y en la de web se encuentra el catalogo

- **INTEGRANTES**:

- GRISANGELY MARTINEZ
- ROAND RODRIGUEZ
- ELIEZER RODRIGUEZ

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


3. **Equipo de Ingeniería**
El escuadrón de desarrollo de Ingeniería de Sistemas está distribuido bajo las siguientes responsabilidades operativas:

Grisangely María (Frontend & UI/UX Lead): Construcción de vistas en Flutter, manejo de navegación profunda, control del ThemeData corporativo y experiencia de usuario.

Eliezer (Logic & Providers Lead): Manejo del ciclo de vida de los datos, consumo de Firebase vía peticiones REST asíncronas, y algoritmos de actualización de inventario.

Roand (Backend & Web Lead): Diseño del árbol relacional JSON en Firebase, configuración de reglas de seguridad y estructuración de la interfaz responsiva del cliente.

Para la creacion de la web nos apoyamos del uso de la IA, de resto fue para entender las conexiones y de ayuda para hacer correcta implementacion de los elementos

