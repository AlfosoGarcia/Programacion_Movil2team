// Factor de conversión: $1.00 USD = 1,000,000 micro-unidades
const int FACTOR_MICRO = 1000000;

// 1. Convertir de double a micro-unidades (enteros)
int doubleToMicro(double amount) {
  return (amount * FACTOR_MICRO).round();
}

// 2. Convertir de micro-unidades (enteros) a double
double microToDouble(int micro) {
  return micro / FACTOR_MICRO;
}

// 3. Cálculo de comisiones usando SOLO aritmética de enteros (Punto Fijo)
int calcularComisionPuntoFijo(int montoMicro, bool esInternacional) {
  int comision = 0;

  // Límites en micro-unidades ($1,000 y $50,000 USD)
  int limite1000 = 1000 * FACTOR_MICRO;
  int limite50000 = 50000 * FACTOR_MICRO;

  // Cuotas fijas en micro-unidades ($5 y $25 USD)
  int cuota5USD = 5 * FACTOR_MICRO;
  int cuota25USD = 25 * FACTOR_MICRO;

  // Tier 1: Monto <= $1,000 -> 1.5% de comisión
  if (montoMicro <= limite1000) {
    comision = (montoMicro * 15) ~/ 1000; // 15/1000 = 1.5%
  }
  // Tier 2: $1,000 < Monto <= $50,000 -> 1.0% + $5 USD
  else if (montoMicro <= limite50000) {
    comision = ((montoMicro * 10) ~/ 1000) + cuota5USD; // 10/1000 = 1.0%
  }
  // Tier 3: Monto > $50,000 -> 0.5% + $25 USD
  else {
    comision = ((montoMicro * 5) ~/ 1000) + cuota25USD; // 5/1000 = 0.5%
  }

  // Recargo por transacción internacional (+1.25%)
  if (esInternacional) {
    comision += (montoMicro * 125) ~/ 10000; // 125/10000 = 1.25%
  }

  return comision;
}

// 4. Cálculo tradicional usando double (para comparar imprecisión)
double calcularComisionDouble(double monto, bool esInternacional) {
  double comision = 0.0;

  if (monto <= 1000.0) {
    comision = monto * 0.015;
  } else if (monto <= 50000.0) {
    comision = (monto * 0.010) + 5.0;
  } else {
    comision = (monto * 0.005) + 25.0;
  }

  if (esInternacional) {
    comision += monto * 0.0125;
  }

  return comision;
}

// 5. Rutina de auditoría: compara el desvío/error entre double y punto fijo
void auditoriaDePrecision() {
  print("=== PRUEBA DE AUDITORÍA DE PRECISIÓN ===");

  double monto = 100.33; // Monto con decimales propensos a error flotante
  int repeticiones = 1000; // 1000 transacciones acumuladas

  double totalDouble = 0.0;
  int totalPuntoFijoMicro = 0;

  int montoMicro = doubleToMicro(monto);

  // Simular acumulación de miles de transacciones
  for (int i = 0; i < repeticiones; i++) {
    totalDouble += calcularComisionDouble(monto, true);
    totalPuntoFijoMicro += calcularComisionPuntoFijo(montoMicro, true);
  }

  double totalPuntoFijoConvertido = microToDouble(totalPuntoFijoMicro);
  double desvio = (totalDouble - totalPuntoFijoConvertido).abs();

  print("Total acumulado en Double: \$$totalDouble");
  print("Total acumulado en Punto Fijo: \$$totalPuntoFijoConvertido");
  print("Desvío acumulado (error de redondeo): \$$desvio USD");
}

void main() {
  // Pruebas sencillas
  double montoPrueba = 50000.0; // $50,000 USD (Entra en Tier 3)
  bool internacional = true; // Transacción internacional

  print("=== PRUEBA INDIVIDUAL ===");
  print("Monto original: \$$montoPrueba USD");

  // Conversión
  int montoEnMicro = doubleToMicro(montoPrueba);
  print("Monto en micro-unidades: $montoEnMicro");

  // Cálculo de comisión
  int comisionMicro = calcularComisionPuntoFijo(montoEnMicro, internacional);
  double comisionFinal = microToDouble(comisionMicro);

  print("Comisión calculada: \$$comisionFinal USD\n");

  // Ejecutar la auditoría
  auditoriaDePrecision();
}