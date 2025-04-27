class FlowstockConstants {
  // Configuración de Moneda

  static const String currencySymbol = '\$';
  static const String currencyCode = 'MXN';
  static const String currencyName = 'Peso Mexicano';

  // Métodos de pago disponibles
  static const Map<String, String> paymentMethods = {
    'credit_card': 'Tarjeta de Crédito',
    'debit_card': 'Tarjeta de Débito',
    'paypal': 'PayPal',
    'bank_transfer': 'Transferencia Bancaria'
  };

  // Mensajes de error
  static const String errorGeneral =
      "Ha ocurrido un error. Por favor intenta nuevamente";
  static const String errorConnection =
      "Error de conexión.  Verifica tu conexión a internet.";
  static const String errorPayment =
      "Error al procesar el pago.  Intenta con otro método de pago";
  static const String errorDatabase =
      "Error en la base de datos.  Contacta al soporte técnico";

  // Títulos de pantalla
  static const String titleHome = "Flow Stock";
  static const String titleUsuario = "Usuarios";
  static const String titleSucursal = "Sucursales";
  static const String titleProducto = "Productos";
  static const String titleInventario = "Inventario";
  static const String titleCliente = "Clientes";
  static const String titleVenta = "Ventas";
  static const String titleDetVenta = "Detalle de la venta";
  static const String titleReporte = "Reportes";
  static const String titleReporteInv = "Reporte de Inventario";
  static const String titleReporteVta = "Reporte de Ventas";

  static const String titleNewUsuario = "Nuevo Usuario";
  static const String titleNewSucursal = "Nueva Sucursal";
  static const String titleNewProducto = "Nuevo Producto";
  static const String titleNewCliente = "Nuevo Cliente";
  static const String titleNewInventario = "Nuevo Inventario";
  static const String titleNewVenta = "Registrar Venta";
  static const String titleNewPayment = "Nuevo pago";

  static const String titleEditUsuario = "Editar Usuario";
  static const String titleEditSucursal = "Editar Sucursal";
  static const String titleEditProducto = "Editar Producto";
  static const String titleEditCliente = "Editar Cliente";
  static const String titleEditInventario = "Editar Inventario";
  static const String titleEditVenta = "Editar Venta";
  static const String titleEditPayment = "Editar pago";

  static const String titleSave = "Guardar";
  static const String titleCancel = "Cancelar";
}
