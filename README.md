# BTG Fondos - Aplicación de Manejo de Fondos

Aplicación Flutter para la gestión de fondos de inversión (FPV/FIC) para clientes BTG Pactual.

## 📱 Características

✅ **Visualización de Fondos**: Lista completa de fondos disponibles (FPV y FIC)  
✅ **Suscripción**: Suscríbete a fondos cumpliendo con el monto mínimo  
✅ **Cancelación**: Cancela participaciones y recupera tu saldo  
✅ **Historial**: Visualiza todas tus transacciones organizadas por fecha  
✅ **Notificaciones**: Selecciona entre Email o SMS al suscribirte  
✅ **Validaciones**: Mensajes de error claros para saldo insuficiente  
✅ **Diseño Responsivo**: UI/UX adaptada a diferentes tamaños de pantalla

## 🏗️ Arquitectura

- **Framework**: Flutter 3.0+
- **Manejo de Estado**: Riverpod 2.5.1
- **Navegación**: Flutter Navigator

## 📂 Estructura del Proyecto

```
lib/
├── main.dart                    # Punto de entrada de la aplicación
├── models/                      # Modelos de datos
│   ├── fondo.dart              # Modelo de Fondo
│   ├── transaccion.dart        # Modelo de Transacción
│   └── usuario.dart            # Modelo de Usuario
├── providers/                   # Providers de Riverpod
│   └── app_providers.dart      # Gestión de estado global
├── services/                    # Capa de servicios
│   └── fondos_service.dart     # Servicio simulado de API
├── screens/                     # Pantallas de la app
│   ├── home_screen.dart        # Pantalla principal
│   ├── fondos_screen.dart      # Lista de fondos
│   └── historial_screen.dart   # Historial de transacciones
└── widgets/                     # Widgets reutilizables
    ├── fondo_card.dart         # Tarjeta de fondo
    └── suscripcion_dialog.dart # Diálogo de suscripción
```

## 💰 Fondos Disponibles

| ID  | Nombre                      | Monto Mínimo | Categoría |
| --- | --------------------------- | ------------ | --------- |
| 1   | FPV_BTG_PACTUAL_RECAUDADORA | $75.000      | FPV       |
| 2   | FPV_BTG_PACTUAL_ECOPETROL   | $125.000     | FPV       |
| 3   | DEUDAPRIVADA                | $50.000      | FIC       |
| 4   | FDO-ACCIONES                | $250.000     | FIC       |
| 5   | FPV_BTG_PACTUAL_DINAMICA    | $100.000     | FPV       |

**Saldo inicial del usuario**: COP $500.000

## 🚀 Instalación y Ejecución

### Requisitos Previos

- Flutter SDK 3.0 o superior
- Dart SDK 3.0 o superior
- Android Studio / VS Code con extensiones de Flutter
- Emulador Android o dispositivo físico (para Android)
- Xcode (para iOS, solo en macOS)

### Pasos de Instalación

1. **Clonar el repositorio**

```bash
git clone <URL_DEL_REPOSITORIO>
cd prueba-tecnica-fondos
```

2. **Instalar dependencias**

```bash
flutter pub get
```

3. **Verificar instalación de Flutter**

```bash
flutter doctor
```

4. **Ejecutar la aplicación**

```bash
# En modo debug
flutter run

# Para web
flutter run -d chrome

# Para release
flutter run --release
```

### Ejecutar en diferentes plataformas

```bash
# Android
flutter run -d android

# iOS (solo macOS)
flutter run -d ios

# Web
flutter run -d chrome

# Windows
flutter run -d windows

# macOS
flutter run -d macos
```

## 🧪 Pruebas

El proyecto incluye la estructura para pruebas unitarias:

```bash
# Ejecutar todas las pruebas
flutter test

# Ejecutar con cobertura
flutter test --coverage
```

## 🎨 Características Técnicas Implementadas

### ✅ Requisitos Funcionales

- [x] Visualizar lista de fondos disponibles
- [x] Suscribirse a un fondo con monto mínimo
- [x] Cancelar participación en un fondo
- [x] Ver saldo actualizado en tiempo real
- [x] Visualizar historial de transacciones
- [x] Seleccionar método de notificación (Email/SMS)
- [x] Mensajes de error para saldo insuficiente

### ✅ Requisitos Técnicos

- [x] Framework Flutter
- [x] Buenas prácticas de UI/UX
- [x] Manejo de estado con Riverpod
- [x] Validaciones de formularios
- [x] Diseño responsivo
- [x] Datos mock simulando API REST
- [x] Manejo de errores y loading states
- [x] Feedback visual (SnackBars, Diálogos)
- [x] Código limpio y comentado

### 🌟 Extras Implementados

- [x] Componentes y widgets reutilizables
- [x] Navegación entre pantallas
- [x] Formateo de moneda (COP)
- [x] Agrupación de transacciones por fecha
- [x] Animaciones y transiciones suaves
- [x] Iconografía y diseño moderno
- [x] Estados vacíos informativos

## 📸 Capturas de Pantalla

La aplicación incluye:

- **Pantalla Principal**: Dashboard con saldo y accesos rápidos
- **Fondos**: Lista de fondos con información detallada
- **Suscripción**: Formulario con validaciones y selector de notificación
- **Historial**: Transacciones organizadas cronológicamente

## 🎯 Casos de Uso

### 1. Suscribirse a un fondo

1. Navega a "Fondos Disponibles"
2. Selecciona un fondo y presiona "Suscribirse"
3. Ingresa el monto deseado (mayor o igual al mínimo)
4. Selecciona método de notificación (Email o SMS)
5. Confirma la operación

### 2. Cancelar suscripción

1. En "Fondos Disponibles", identifica fondos con etiqueta "Suscrito"
2. Presiona "Cancelar"
3. Confirma la cancelación
4. El saldo se acredita automáticamente

### 3. Ver historial

1. Navega a "Historial de Transacciones"
2. Visualiza todas las operaciones agrupadas por fecha
3. Identifica suscripciones (verde) y cancelaciones (naranja)

## 🔧 Tecnologías Utilizadas

- **Flutter**: Framework UI multiplataforma
- **Riverpod**: Gestión de estado reactiva y robusta
- **Intl**: Formateo de fechas y monedas
- **Material Design 3**: Sistema de diseño moderno

## 📝 Notas Técnicas

- **No requiere backend**: Toda la lógica está en el frontend
- **No requiere autenticación**: Usuario único predefinido
- **Datos persistentes en memoria**: Los datos se reinician al cerrar la app
- **API simulada**: Servicio con delays para simular llamadas HTTP

## 👨‍💻 Desarrollo

### Agregar nuevos fondos

Edita el archivo `lib/services/fondos_service.dart`:

```dart
final _fondosMock = [
  Fondo(
    id: 6,
    nombre: 'NUEVO_FONDO',
    montoMinimo: 100000,
    categoria: 'FPV',
  ),
  // ... otros fondos
];
```

### Modificar saldo inicial

Edita `lib/providers/app_providers.dart`:

```dart
UsuarioNotifier()
    : super(Usuario(
        nombre: 'Usuario BTG',
        saldo: 1000000, // Nuevo saldo
      ));
```

## 📄 Licencia

Este proyecto es una prueba técnica con fines educativos y de demostración.

## 🤝 Contribuciones

Este es un proyecto de prueba técnica. No se aceptan contribuciones externas.

---

**Desarrollado con ❤️ para BTG Pactual**
