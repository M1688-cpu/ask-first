<p align="center"><img src="media/cover.png" alt="ask-first cover" width="800"></p>

# ask-first

[English](README.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md) | [Français](README.fr.md) | [Deutsch](README.de.md) | Español | [Português](README.pt.md)

Dos skills de agente que preguntan antes de actuar.

`clarify-first` te entrevista una pregunta a la vez hasta que la tarea es lo bastante concreta para construirla, y confirma un resumen escrito antes de empezar el trabajo. `knock-first` comprueba si estás en el ordenador y pide tu permiso antes de que el agente tome el escritorio para hacer pruebas, y te avisa en cuanto la máquina vuelve a ser tuya.

Los dos problemas se ven igual desde el lado de quien usa: el agente adivina, actúa según la adivinanza, y la adivinanza era incorrecta. Preguntar antes sale más barato que rehacer.

## Instalación

La [skills CLI](https://skills.sh) se encarga de detectar el host para Claude Code, Codex, Cursor, Gemini CLI, GitHub Copilot, opencode, Amp y el resto de hosts que admite:

```bash
npx skills add M1688-cpu/ask-first -g
```

O ejecuta el instalador de este repositorio, que detecta los agentes de tu máquina y copia en cada uno (`--all` para todos los admitidos, `--list` para previsualizar, `--remove` para desinstalar):

```bash
git clone https://github.com/M1688-cpu/ask-first.git
bash ask-first/install.sh
```

Claude Code también puede instalarlo como plugin:

```text
/plugin marketplace add M1688-cpu/ask-first
/plugin install ask-first@ask-first
```

Para copiar a mano, estas son las carpetas que lee cada agente:

| Agente | Carpeta de skills |
| --- | --- |
| Claude Code | `~/.claude/skills` |
| Codex | `~/.codex/skills` |
| Cursor | `~/.cursor/skills` |
| Gemini CLI | `~/.gemini/skills` |
| opencode | `~/.config/opencode/skill` |
| Amp | `~/.amp/skills` |
| OpenClaw | `~/.openclaw/skills` |
| ZCode | `~/.zcode/skills` |
| cualquier agente que lea el formato abierto | `~/.agents/skills` |

Tras instalarlas, las skills se activan solas cuando sus condiciones coinciden; también puedes invocarlas por su nombre.

## clarify-first

Un agente que adivina ante una petición vaga construye lo equivocado con confianza. Esta skill lo obliga a preguntar.

Se activa cuando el objetivo, el alcance, el entregable o una decisión clave de una petición pueden leerse de varias formas. Las peticiones claras, pequeñas y mecánicas pasan sin detenerse, con una línea que repite lo que el agente entendió.

La entrevista:

1. Una pregunta cada vez, cada una con 2-4 opciones y una respuesta recomendada; la mayoría de las respuestas son un clic.
2. Las preguntas de seguimiento nacen de tus respuestas, así la entrevista converge en vez de recorrer una lista fija.
3. Lo que el agente puede buscar en el código, la documentación o la web jamás se pregunta. Solo se te pregunta por intención, gusto y restricciones.
4. Unas 7 preguntas es el techo; pasando eso, el agente pregunta lo que no debe.
5. Al 95 % de confianza escribe un brief de tarea: objetivo, dentro, fuera, entregable, supuestos. El trabajo empieza tras tu aprobación.

```text
tú:     añade modo oscuro a mi sitio
agente: ¿Qué partes? ¿Todo el sitio, o primero las páginas de lectura?
        (recomendado: primero las páginas de lectura, concentran el 80 % del
        tiempo de lectura)
tú:     las páginas de lectura
agente: ¿Seguir el ajuste de apariencia del sistema, o añadir su propio
        interruptor? (recomendado: seguir el sistema, un componente menos que
        mantener)
tú:     seguir el sistema
agente: Brief: paleta oscura en las páginas de lectura, sigue la apariencia del
        sistema, zona de admin intacta, los tokens de paleta van en theme.css.
        ¿Empiezo? [sí / cambiar algo]
```

## knock-first

Las pruebas que mueven el ratón y teclean pueden chocar con la persona que usa la máquina. Una prueba fallida es lo más leve; una edición perdida o un clic torpe es peor. Esta skill hace que el agente compruebe, pregunte, ejecute y devuelva.

Se activa antes de cualquier toma del escritorio: capturas de pantalla, abrir la app recién compilada, simular entradas, redimensionar ventanas para una prueba.

El ciclo:

1. Detectar: un script lee el tiempo de inactividad de teclado y ratón, la app en primer plano y si hay una app de reunión o de medios reproduciéndose, y dice si parece que estás. Quien mira un vídeo sin tocar el teclado cuenta como presente.
2. Pedir: un solo diálogo indica lo que encontró la detección, la lista exacta de acciones previstas y una estimación de duración. Opciones: adelante, no preguntar más en esta sesión, o ahora no. El consentimiento vive solo en la conversación actual y no se escribe en ningún sitio.
3. Ejecutar: exactamente las acciones listadas. Cualquier cosa fuera de la lista vuelve a pasar por una pregunta.
4. Devolver: una notificación de macOS con sonido, más un resumen del resultado en el chat, para que sepas el momento en que la máquina vuelve a ser tuya.

```text
agente: Estás trabajando en Xcode ahora mismo (inactivo 40 s). Necesito el
        escritorio unos 3 minutos para: abrir la app compilada, redimensionarla
        a 1280x800, hacer 3 capturas y teclear una búsqueda. ¿Adelante?
        [adelante / no preguntar más esta sesión / ahora no]
tú:     adelante
        ... las pruebas corren ...
agente: Notificación enviada: "Pruebas terminadas: 3 capturas guardadas."
        En el chat: el fallo de búsqueda no se reprodujo, las capturas están en
        artifacts/. Tu ordenador vuelve a ser tuyo.
```

## Archivos

```text
skills/clarify-first/SKILL.md        la skill de entrevista
skills/knock-first/SKILL.md          la skill de consentimiento del escritorio
skills/knock-first/scripts/          comprobación de actividad y avisos (macOS)
install.sh                           detecta los agentes instalados y copia en cada uno
.claude-plugin/                      manifiesto de plugin de Claude Code
media/cover.html                     fuente de la imagen de portada
```

## Requisitos

`clarify-first` funciona en cualquier sitio donde el agente pueda preguntar; los hosts sin diálogo de preguntas pasan a preguntar en el chat. Los scripts de `knock-first` usan interfaces de macOS (`ioreg`, `lsappinfo`, `osascript`); en otras plataformas la detección responde "presente" y el agente pregunta cada vez. La captura de pantalla requiere permiso de grabación de pantalla para el terminal que aloja al agente.

## Licencia

MIT
