# CallLog Guard

Aplicación Android desarrollada en Flutter para registrar, consultar y administrar llamadas salientes de forma local.  
La app permite sincronizar llamadas salientes desde el registro del teléfono, guardarlas en SQLite y excluir números o prefijos definidos por el usuario.

## Descripción corta

**CallLog Guard** es una aplicación móvil enfocada en el registro local de llamadas salientes.  
Permite visualizar el historial almacenado, buscar llamadas, eliminar registros locales y administrar una lista de números excluidos por privacidad.

Los datos se almacenan únicamente en el dispositivo.

## Funcionalidades principales

- Registro local de llamadas salientes.
- Consulta de llamadas almacenadas en SQLite.
- Búsqueda reactiva en historial.
- Búsqueda por nombre, número, estado, fecha, hora y duración.
- Soporte de búsqueda omitiendo el prefijo `+57`.
- Lista local de números excluidos.
- Exclusión por número exacto.
- Exclusión por prefijo.
- Prevención de duplicados usando `timestamp + número`.
- Eliminación de registros solo de la base de datos local.
- Interfaz con Material Design 3.
- Tema oscuro.
- Navegación inferior entre:
  - Historial
  - Excluidos

## Tecnologías usadas

- Flutter
- Dart
- Material Design 3
- SQLite
- sqflite
- MethodChannel Flutter/Android
- Kotlin para lectura del registro de llamadas
- flutter_launcher_icons
- flutter_native_splash

## Permisos usados

La aplicación utiliza permisos sensibles de Android para poder leer el registro de llamadas y asociar nombres de contactos cuando estén disponibles.

### `READ_CALL_LOG`

Permite leer el registro de llamadas del dispositivo.

Se usa para obtener:

- Número telefónico.
- Fecha de la llamada.
- Hora de la llamada.
- Duración.
- Tipo de llamada.
- Timestamp.

La app filtra únicamente llamadas salientes.

### `READ_CONTACTS`

Permite acceder a la información de contactos del dispositivo.

Se usa para obtener el nombre del contacto cuando el número de teléfono existe en la agenda.

## Declaración de privacidad

La aplicación no envía información a servidores externos.

Toda la información se guarda localmente en SQLite dentro del dispositivo del usuario.

La eliminación de registros desde la app solo borra información de la base de datos local.  
No elimina llamadas del registro real del teléfono.

## Base de datos local

La app usa SQLite con dos tablas principales.

### Tabla `llamadas_salientes`

| Campo | Tipo | Descripción |
|---|---|---|
| id | INTEGER PRIMARY KEY | Identificador único |
| fecha | DATE | Fecha de la llamada |
| hora | TIME | Hora de la llamada |
| numero | TEXT | Número de destino |
| nombre_contacto | TEXT | Nombre del contacto |
| duracion | INTEGER | Duración en segundos |
| estado | TEXT | Estado de la llamada |
| timestamp | INTEGER | Marca de tiempo de Android |

### Tabla `numeros_excluidos`

| Campo | Tipo | Descripción |
|---|---|---|
| id | INTEGER PRIMARY KEY | Identificador único |
| numero | TEXT | Número o prefijo excluido |
| tipo | TEXT | Tipo de exclusión: exacto o prefijo |

## Archivos importantes fuera de `lib` y `pubspec.yaml`

Además de la carpeta `lib` y el archivo `pubspec.yaml`, el proyecto requiere cambios en archivos nativos de Android y assets.

### AndroidManifest.xml

Ruta:

```text
android/app/src/main/AndroidManifest.xml
```

Permisos agregados:

```xml
<uses-permission android:name="android.permission.READ_CALL_LOG" />
<uses-permission android:name="android.permission.READ_CONTACTS" />
```

También se puede cambiar el nombre visible de la app en:

```xml
<application
    android:label="CallLog Guard"
    android:name="${applicationName}"
    android:icon="@mipmap/ic_launcher">
```

### MainActivity.kt

Ruta:

```text
android/app/src/main/kotlin/com/example/llamadas_salientes/MainActivity.kt
```

Este archivo contiene la integración nativa Android mediante `MethodChannel`.

Responsabilidades principales:

- Solicitar permisos en tiempo de ejecución.
- Leer el registro de llamadas usando `CallLog.Calls`.
- Filtrar llamadas salientes.
- Enviar los datos obtenidos a Flutter.
- Retornar número, contacto, fecha, hora, duración, estado y timestamp.

Canal usado:

```text
registro_llamadas/call_log
```

Métodos disponibles:

```text
requestCallPermissions
getOutgoingCalls
```

### Assets del icono

Ruta sugerida:

```text
assets/icon/app_icon.png
```

Este archivo se usa para generar el icono de la aplicación con `flutter_launcher_icons`.

### Assets del splash screen

Ruta sugerida:

```text
assets/splash/splash.png
```

Este archivo se usa para generar la pantalla inicial nativa con `flutter_native_splash`.

## Configuración del icono de la app

El proyecto usa `flutter_launcher_icons`.

Comando para generar el icono:

```bash
dart run flutter_launcher_icons
```

Si el icono no cambia en Android, se recomienda desinstalar la app del dispositivo y volver a ejecutarla.

## Configuración del splash screen

El proyecto usa `flutter_native_splash`.

Comando para generar el splash screen:

```bash
dart run flutter_native_splash:create
```

Si el splash screen no se actualiza, ejecutar:

```bash
flutter clean
flutter pub get
flutter run
```

## Instalación y ejecución

Clonar el repositorio:

```bash
git clone <url-del-repositorio>
```

Entrar al proyecto:

```bash
cd llamadas_salientes
```

Instalar dependencias:

```bash
flutter pub get
```

Generar iconos:

```bash
dart run flutter_launcher_icons
```

Generar splash screen:

```bash
dart run flutter_native_splash:create
```

Ejecutar la app:

```bash
flutter run
```

## Pruebas recomendadas

1. Ejecutar la app en un dispositivo Android físico.
2. Aceptar permisos de llamadas y contactos.
3. Ir a la pantalla Historial.
4. Usar el menú de tres puntos.
5. Seleccionar sincronizar llamadas.
6. Verificar que se guarden llamadas salientes.
7. Sincronizar nuevamente y comprobar que no se dupliquen registros.
8. Agregar un número a excluidos.
9. Confirmar que ese número no se vuelva a guardar.
10. Probar búsqueda usando números con y sin `+57`.

## Consideraciones importantes

- El acceso al registro de llamadas puede estar limitado por políticas de Android y Google Play.
- Algunos estados de llamada pueden no estar disponibles en todos los dispositivos.
- La app debe probarse preferiblemente en un teléfono Android real.
- En algunos casos, el sistema puede requerir que la aplicación tenga permisos especiales o justificación clara para acceder al registro de llamadas.
- Esta app está pensada para almacenamiento local, no para sincronización en la nube.

## Estado actual

La aplicación cuenta con:

- Interfaz principal terminada.
- Pantalla Historial.
- Pantalla Excluidos.
- Persistencia local con SQLite.
- Sincronización manual de llamadas salientes.
- Exclusión por número exacto y prefijo.
- Búsqueda reactiva.
- Icono personalizado.
- Splash screen personalizado.

## Autor

Proyecto desarrollado como aplicación Android en Flutter para registro local de llamadas salientes.