# Proyecto IA

## Integrantes

- Jota E. López - 2259394
- Esmeralda Rivas Guzmán - 2259580

### Instalación

Tras clonar el repositorio, se debe instalar las dependencias del proyecto con el siguiente comando:

```bash
flutter pub get
```

### Ejecución

Para ejecutar el proyecto, se debe correr el siguiente comando:

```bash
flutter run
```
---

## Sobre el Proyecto  

Este proyecto implementa varios algoritmos de búsqueda clásica en grafos, adaptados para trabajar de manera integrada, los algoritmos que se incluyen son:  

- **Búsqueda en Profundidad**  
- **Búsqueda en Profundidad Limitada**
- **Búsqueda en Profundidad Iterativa**  
- **Búsqueda en Amplitud**  
- **Búsqueda de Costo Uniforme**  
- **Búsqueda Avara**  

### Idea Central

El objetivo es combinar estos algoritmos de búsqueda y limitarlos mediante un número máximo de iteraciones. El proceso funciona de la siguiente manera:

1. Cada algoritmo opera en niveles progresivos del árbol de búsqueda, siguiendo un esquema de incremento en el número de niveles explorados: `n += n`.  
   Por ejemplo:

   - Si el número máximo de iteraciones es 2, el primer algoritmo explora hasta el nivel 2.
   - El segundo explora hasta el nivel 4.
   - El tercero hasta el nivel 6, y así sucesivamente.

2. **Compartición del Contexto:**  
   Un desafío clave es permitir que los algoritmos compartan el estado del árbol de búsqueda. Esto no se limita a pasar el nodo actual en el que se encuentra 
   un algoritmo, sino que incluye todos los nodos no expandidos. De esta forma, los demás algoritmos pueden decidir estratégicamente qué camino tomar.

   - **Costo Uniforme y Avara:** seleccionan los nodos con menor costo o heurística.
   - **Amplitud:** verifica si el árbol está equilibrado. Si no, explora niveles inferiores para completar los nodos faltantes, manteniendo el comportamiento propio del algoritmo.
   - **Profundidad:** simplemente elige el nodo más a la izquierda dentro de su nivel.

Este enfoque permite que los algoritmos colaboren secuencialmente, compartiendo información del estado del árbol de búsqueda, de esta forma, cada algoritmo puede tomar decisiones más informadas basándose en los nodos explorados y no explorados por otros.



---

## Estructura de Carpetas

El proyecto está organizado en módulos, lo que facilita su mantenimiento y escalabilidad:

```
.
├── algorithms                     
│   ├── algorithms.dart
│   ├── breadth_first_search.dart
│   ├── depth_first_search.dart
│   ├── greedy_search.dart
│   ├── iterative_depth_search.dart
│   └── uniform_cost_search.dart
├── controllers                    
│   └── search_algorithm_controller.dart
├── extensions                     
│   └── graph_extension.dart
├── models                         
│   ├── base_node.dart
│   ├── cell.dart
│   └── search_algorithm.dart
├── provider                       
│   └── config_provider.dart
├── screens                        
│   ├── config_screen.dart
│   ├── file_upload_screen.dart
│   └── search_algorithm_screen.dart
├── utils                          
│   └── validate_number.dart
├── view                           
│   └── tree_view.dart
├── widgets                        
│   ├── config_board.dart
│   ├── config_cell_type.dart
│   ├── config_panel.dart
│   ├── custom_button.dart
│   ├── dragable_grid.dart
│   ├── file_uploader_to_board.dart
│   ├── grid_painter.dart
│   ├── iterations_input_prompt.dart
│   ├── node_widget.dart
│   └── widgets.dart
└── main.dart                      
```

Esta estructura modular permite una navegación sencilla y clara entre las diferentes partes del proyecto, desde los algoritmos hasta las interfaces de usuario.
