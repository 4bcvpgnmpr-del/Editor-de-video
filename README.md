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
| Ctrl/Cmd + Z / Mayús + Z | Deshacer / rehacer |
| Supr | Borrar la etiqueta seleccionada |
| Esc | Restaurar panel maximizado / parar clip / quitar selección |
| Teclas de la botonera | Etiquetar (configurables) |

## Hoja de ruta

- [x] Fase 1: paneles acoplables, botonera avanzada (páginas, subcategorías, iconos, tamaños), periodos, línea de tiempo (zoom, selección, ajuste de clips, marcadores), fotograma a fotograma, deshacer/rehacer
- [ ] Fase 2: biblioteca de clips, playlists, freeze frame, dibujo y telestración
- [ ] Fase 3: pizarra, animaciones, crear jugada desde vídeo, playbook
- [ ] Fase 4: estadísticas conectadas con el vídeo, jugadores, equipos, scouting
- [ ] Fase 5: análisis con IA, informes y PDF
