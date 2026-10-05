# Scouting de baloncesto

Aplicación web para etiquetar y recortar vídeos de partidos de baloncesto, inspirada en Nacsport, LongoMatch y similares.
Funciona en el navegador: el vídeo no se sube a ningún servidor.

## Uso

Abre `index.html` en el navegador (o publícalo con GitHub Pages) y carga un vídeo MP4 o WebM.

- Botonera personalizable con atajos de teclado
- Clips automáticos con segundos antes y después de cada etiqueta
- Línea de tiempo por tipo de acción, con zoom
- Filtros por equipo, dorsal y acción, y reproducción de los clips filtrados
- Exportación a CSV y proyectos en JSON

## Paneles acoplables

La botonera y los eventos son paneles que se pueden arrastrar por la cabecera:
soltarlos en el borde izquierdo, derecho o inferior los ancla; en cualquier otro sitio quedan flotantes.
Se pueden redimensionar, minimizar (quedan en una bandeja), maximizar (doble clic en la cabecera) y ocultar.
Posición, tamaño y estado se recuerdan. «Paneles y diseño» ofrece diseños predefinidos y permite guardar los propios.

## Botonera, cuartos y jugadoras

La botonera solo lleva el selector de equipo. El **cuarto** se elige en la cabecera (o con Mayús+1…5). Las **plantillas** (número y nombre de cada jugadora) se pegan en «Editar botonera → Equipos y páginas»; la jugadora se asigna al calificar el clip o desde su detalle, y se puede buscar y filtrar por ella.

## Categorías y descriptores

La **categoría** agrupa las acciones de la botonera (Ataque, Defensa…). El **descriptor** califica un clip una vez
etiquetado: pulsas la acción y, en la franja «Calificar», eliges por ejemplo el resultado, la defensa rival o la
valoración. Cada grupo de descriptores es de elección única o múltiple y puede tener teclas propias (actúan sobre el
último clip). «Editar botonera» tiene cuatro pestañas sencillas: Botones (nombre, categoría, tecla, tiempos y color;
lo demás está en «Más opciones»), Categorías, Descriptores y Equipos y páginas.

## Biblioteca

La **Biblioteca** contiene solo los clips. Una caja de búsqueda (nombre, tipo, categoría, etiquetas, descriptores,
comentario, jugadora, `#número`…), un orden y un desplegable **Filtros** (equipo, periodo, jugadora, tipo, categoría y descriptor).
Los clips se añaden a una playlist con «+» o arrastrándolos.

## Mesa de producción

Botón superior **Mesa de producción**: se abre en **otra ventana** para trabajar con calma, con su propia lista de
clips disponibles, con buscador y filtros desplegables (categoría, acción, jugadora y cada grupo de descriptores), y la
secuencia de la playlist en líneas de texto (arrastra o usa ▲ ▼ para ordenar; muestra la duración total y resalta el clip
que suena). Se añaden con «+», doble clic, arrastrando o «Añadir todos» (solo los que ves filtrados). Reproducir, exportar y el teclado funcionan
desde esa ventana. «Volver a la ventana principal» la acopla dentro; cerrarla la hace desaparecer. Si el navegador
bloquea las ventanas emergentes, la mesa se abre acoplada arriba y se avisa.

## Freeze frame y telestración

Con el vídeo en pausa, pulsa **Freeze frame** (Mayús+F). Herramientas: flecha, línea, curva, círculo, rectángulo, texto,
resaltador, spotlight, lupa, numeración, cono, zona, trayectoria y movimiento. Las figuras se mueven, redimensionan,
duplican, borran y cambian de color y grosor. Cada dibujo está ligado a un instante del vídeo: al reproducir por ese punto
se congela la imagen (1, 2, 3, 5, 10 s o personalizado) o se superpone el dibujo. «Guardar como clip» lo convierte en clip.

## Atajos

| Tecla | Acción |
|---|---|
| Espacio | Reproducir / pausar |
| ← → | Fotograma anterior / siguiente |
| Mayús + ← → | ∓1 s |
| Ctrl/Cmd + ← → | ∓5 s |
| `,` `.` | Fotograma anterior / siguiente |
| `[` `]` | Velocidad |
| `0` | Cambiar de equipo |
| Mayús + 1…5 | Periodo (1C, 2C, 3C, 4C, PR) |
| Mayús + M | Añadir marcador |
| Mayús + F | Freeze frame y dibujo |
| Ctrl/Cmd + Z / Mayús + Z | Deshacer / rehacer |
| Supr | Borrar el clip seleccionado (en modo dibujo, la figura seleccionada) |
| Esc | Restaurar panel maximizado / parar clip / quitar selección / salir de una herramienta de dibujo |
| Intro | (en modo dibujo) cerrar una zona |
| Teclas de la botonera | Etiquetar (configurables) |
| Teclas de un descriptor | Califican el clip seleccionado (opcionales, configurables) |

## Limitaciones actuales

- La exportación descarga el archivo en una página normal (GitHub Pages) y en claude.ai usa su guardado.
- Los datos se guardan en el navegador. Al recargar hay que volver a abrir el mismo vídeo; las etiquetas se recuperan solas. Guarda el proyecto en JSON de vez en cuando como copia de seguridad.
- Los clips todavía no se exportan como archivo de vídeo, solo sus datos (CSV y JSON).
- Cada playlist pertenece al vídeo en el que se crea.
- Formatos de vídeo: MP4 (H.264) y WebM. MKV y AVI hay que convertirlos antes.

## Hoja de ruta

- [x] Fase 1: paneles acoplables, botonera avanzada (páginas, subcategorías, iconos, tamaños), periodos, línea de tiempo (zoom, selección, ajuste de clips, marcadores), fotograma a fotograma, deshacer/rehacer
- [x] Fase 2: biblioteca de clips, playlists, freeze frame, dibujo y telestración
- [x] Mejoras intermedias: categorías y descriptores, buscador y filtros, mesa de producción (acoplable y en otra ventana)
- [ ] Fase 3: pizarra, animaciones, crear jugada desde vídeo, playbook
- [ ] Fase 4: estadísticas conectadas con el vídeo, jugadores, equipos, scouting
- [ ] Fase 5: análisis con IA, informes y PDF
