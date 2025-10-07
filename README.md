# Reto Mobile – ToDo App

## Objetivo
Crear una app móvil sencilla de lista de tareas en Flutter, cumpliendo los requisitos del reto previo de Adopta un Junior.

## Requisitos implementados (planificados)
- Pantalla de lista de tareas (ToDo)
- Añadir nueva tarea (título + descripción)
- Mostrar tareas en una lista
- Marcar tareas como completadas

<!-- ## Extras planeados
- Persistencia local usando SharedPreferences
- Diseño básico pero cuidado -->

## Plan de desarrollo paso a paso
1. Crear el modelo `Task` con título, descripción y estado de completada.
2. Pantalla principal (`HomeScreen`) con lista de tareas.
3. Función para añadir tareas mediante `AddTaskScreen`.
4. Marcar tareas como completadas desde la lista.
5. Persistencia local de tareas usando SharedPreferences.
6. Mejorar diseño y experiencia de usuario básica.
7. Añadir capturas o GIFs del funcionamiento para el README final.

## Estructura de la app

```bash
HomeScreen
 ├─ AppBar
 ├─ ListView (lista de tareas)
 │   └─ TaskTile (cada tarea)
 └─ FloatingActionButton (añadir tarea)
      └─ AddTaskScreen
          ├─ TextField (título)
          ├─ TextField (descripción)
          └─ ElevatedButton (guardar tarea)
```
- `HomeScreen`: Pantalla principal donde se muestran todas las tareas.

- `ListView` + `TaskTile`: Cada tarea se muestra en un widget TaskTile, con título, descripción y checkbox para marcar como completada.

- `FloatingActionButton`: Botón flotante para abrir la pantalla de añadir tarea (`AddTaskScreen`).

- `AddTaskScreen`: Pantalla con campos para título y descripción, y botón para guardar la tarea en la lista.

## Cómo ejecutar la app
1. Clonar el repositorio:
```bash
git clone https://github.com/violetacf/reto_auj_mobile.git
```

2. Entrar en la carpeta del proyecto: 
```bash
cd reto_auj_mobile
```

3. Instalar dependencies:
```bash
flutter pub get
```

4. Abrir el simulador:
```bash
open -a Simulator
```

5. Ver los dispositivos disponibles:
```bash
flutter devices
```

4. Ejecutar la app en el simulador:
```bash
flutter run -d <device_id_del_simulador>
```


<!-- TODO: ## Capturas de pantalla -->


