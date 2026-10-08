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

## Botonera

Tres zonas ordenadas: **Categorías** (botones de color; cada uno muestra cuántos clips lleva, ×N), **Descriptores**
(agrupados por rótulo: Resultado, Defensa rival, Valoración…) y **Jugadoras** (una pestaña por equipo, con número y nombre).
Las categorías se desplazan dentro de su zona y los descriptores y las jugadoras quedan siempre a la vista. Anclada abajo
(panel ancho), las categorías pasan a un lado y los descriptores y jugadoras al otro.

Pulsas una categoría para crear el clip y después, si quieres, sus descriptores y la jugadora (pulsar una jugadora asigna
también su equipo). Cada zona tiene su «+» para crear categorías, descriptores y jugadoras (con «Añadir varias a la vez» para
pegar una plantilla). **Editar** (o clic derecho) abre un editor rápido: nombre, color, segundos antes y después y **tamaño**
del botón (pequeño: media columna, normal: una, grande: toda la fila); borrar pide pulsar dos veces. **A− / A+** cambia el
tamaño de toda la botonera (se recuerda). El equipo de las acciones (tecla 0) y el cuarto (Mayús+1…5) están en la cabecera.

«Editar botonera» abre el editor completo, con tres pestañas: **Categorías** (nombre, tecla, segundos antes y después, puntos,
tamaño, color, visible, orden), **Descriptores** (grupos de elección única o múltiple y teclas propias) y **Jugadoras**
(nombres de los equipos y plantillas).

## Biblioteca

Los clips son una **tabla de colores** (#, categoría, descriptores, inicio) con cabeceras que ordenan, un filtro de
categoría, buscador (nombre, categoría, descriptores, jugadora, `#número`…) y un desplegable **Filtros**. Pulsar un clip lo
reproduce; «+» lo añade a la playlist. El tiempo de un clip se ajusta arrastrando sus bordes en la línea de tiempo.

## Mesa de producción

Botón superior **Mesa de producción**: se abre en **otra ventana** para trabajar con calma, con su propia lista de
clips disponibles, con buscador y filtros desplegables (categoría, jugadora y cada grupo de descriptores), y la
secuencia de la playlist en líneas de texto (arrastra o usa ▲ ▼ para ordenar; muestra la duración total y resalta el clip
que suena). Se añaden con «+», doble clic, arrastrando o «Añadir todos» (solo los que ves filtrados). «Volver a la ventana
principal» la acopla dentro; cerrarla la hace desaparecer. Si el navegador bloquea las ventanas emergentes, la mesa se abre
acoplada arriba y se avisa.

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
