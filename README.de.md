<p align="center"><img src="media/cover.png" alt="ask-first cover" width="800"></p>

# ask-first

[English](README.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md) | [Français](README.fr.md) | Deutsch | [Español](README.es.md) | [Português](README.pt.md)

Zwei Agent-Skills, die erst fragen und dann handeln.

`clarify-first` befragt dich Frage für Frage, bis die Aufgabe konkret genug zum Bauen ist, und bestätigt vor dem Beginn ein schriftliches Briefing. `knock-first` prüft, ob du am Rechner bist, und holt deine Erlaubnis ein, bevor der Agent für Tests den Desktop übernimmt, und meldet sich, sobald die Maschine wieder dir gehört.

Beide Probleme sehen aus Nutzersicht gleich aus: Der Agent rät, handelt nach dem Rate, und das Rate war falsch. Erst fragen ist billiger als neu bauen.

## Installation

Die [skills CLI](https://skills.sh) übernimmt die Host-Erkennung für Claude Code, Codex, Cursor, Gemini CLI, GitHub Copilot, opencode, Amp und die übrigen unterstützten Hosts:

```bash
npx skills add M1688-cpu/ask-first -g
```

Oder starte den Installer in diesem Repository; er erkennt die Agents auf deiner Maschine und kopiert in jeden hinein (`--all` für alle unterstützten Agents, `--list` zum Vorschauen, `--remove` zum Deinstallieren):

```bash
git clone https://github.com/M1688-cpu/ask-first.git
bash ask-first/install.sh
```

Claude Code kann es auch als Plugin installieren:

```text
/plugin marketplace add M1688-cpu/ask-first
/plugin install ask-first@ask-first
```

Beim manuellen Kopieren liest jeder Agent diese Ordner:

| Agent | Skills-Ordner |
| --- | --- |
| Claude Code | `~/.claude/skills` |
| Codex | `~/.codex/skills` |
| Cursor | `~/.cursor/skills` |
| Gemini CLI | `~/.gemini/skills` |
| opencode | `~/.config/opencode/skill` |
| Amp | `~/.amp/skills` |
| OpenClaw | `~/.openclaw/skills` |
| ZCode | `~/.zcode/skills` |
| jeder Agent, der das offene Format liest | `~/.agents/skills` |

Nach der Installation lösen sich die Skills von selbst aus, wenn ihre Bedingungen zutreffen; du kannst sie auch beim Namen aufrufen.

## clarify-first

Ein Agent, der bei einer vagen Anfrage rät, baut das Falsche mit Selbstvertrauen. Dieser Skill lässt ihn fragen.

Er greift, wenn Ziel, Umfang, Ergebnis oder eine wichtige Entscheidung einer Anfrage mehrfach lesbar sind. Klare, kleine, mechanische Anfragen laufen unverändert durch, mit einer einzeiligen Zusammenfassung dessen, was der Agent verstanden hat.

Das Interview:

1. Eine Frage nach der anderen, jede mit 2-4 Optionen und einer empfohlenen Antwort; die meisten Antworten sind ein Klick.
2. Nachfragen entstehen aus deinen Antworten, das Interview konvergiert, statt eine Checkliste abzuarbeiten.
3. Was der Agent in Code, Doku oder Web nachschlagen kann, wird nie gefragt. Gefragt wird nur nach Absicht, Geschmack und Rahmenbedingungen.
4. Etwa 7 Fragen sind die Obergrenze; darüber hinaus fragt der Agent das Falsche.
5. Bei 95 % Sicherheit schreibt er ein Aufgaben-Briefing: Ziel, im Umfang, außerhalb des Umfangs, Ergebnis, Annahmen. Die Arbeit beginnt nach deiner Freigabe.

```text
du:    füge Dark Mode zu meiner Seite hinzu
agent: Welche Teile? Die ganze Seite, oder zuerst die Leseseiten?
       (Empfohlen: Leseseiten zuerst, dort fallen 80 % der Lesezeit an)
du:    Leseseiten
agent: Der Einstellung des Systems folgen oder ein eigener Schalter?
       (Empfohlen: dem System folgen, ein Bauteil weniger zu pflegen)
du:    dem System folgen
agent: Briefing: dunkle Palette auf den Leseseiten, folgt der Systemdarstellung,
       Adminbereich unberührt, Paletten-Tokens nach theme.css. Starten?
       [ja / etwas ändern]
```

## knock-first

Tests, die die Maus bewegen und tippen, können mit der Person kollidieren, die gerade die Maschine benutzt. Ein misslungener Test ist der harmloseste Fall; eine verlorene Bearbeitung oder ein Fehlklick ist schlimmer. Dieser Skill lässt den Agenten prüfen, fragen, ausführen und zurückgeben.

Er greift vor jeder Übernahme des Desktops: Screenshots, Starten der frisch gebauten App, Simulieren von Eingaben, Ändern der Fenstergröße für einen Test.

Der Zyklus:

1. Prüfen: Ein Skript liest die Leerlaufzeit von Tastatur und Maus, die vorderste App und ob eine Meeting- oder Medien-App läuft, und meldet, ob du offenbar da bist. Wer ein Video schaut, ohne die Tastatur zu berühren, zählt als anwesend.
2. Fragen: Ein Dialog nennt das Ergebnis der Prüfung, die genaue Liste der geplanten Aktionen und eine Zeitschätzung. Optionen: loslegen, in dieser Sitzung nicht mehr fragen, jetzt nicht. Die Zustimmung existiert nur im aktuellen Gespräch und wird nirgendwo gespeichert.
3. Ausführen: genau die gelisteten Aktionen. Alles darüber hinaus kommt mit einer neuen Frage zurück.
4. Zurückgeben: eine macOS-Mitteilung mit Ton, plus Ergebniszusammenfassung im Chat, damit du den Moment weißt, in dem die Maschine wieder deine ist.

```text
agent: Du arbeitest gerade in Xcode (Leerlauf 40 s). Ich brauche den Desktop für
       etwa 3 Minuten: die gebaute App öffnen, auf 1280x800 skalieren, 3
       Screenshots machen, eine Suchanfrage eintippen. Loslegen?
       [loslegen / in dieser Sitzung nicht mehr fragen / jetzt nicht]
du:    loslegen
       ... Tests laufen ...
agent: Mitteilung gesendet: „Tests fertig: 3 Screenshots gespeichert."
       Im Chat: der Such-Crash trat nicht wieder auf, Screenshots liegen in
       artifacts/. Dein Rechner gehört wieder dir.
```

## Dateien

```text
skills/clarify-first/SKILL.md        der Interview-Skill
skills/knock-first/SKILL.md          der Desktop-Zustimmungs-Skill
skills/knock-first/scripts/          Aktivitätsprüfung und Benachrichtigung (macOS)
install.sh                           installierte Agents erkennen und kopieren
.claude-plugin/                      Claude-Code-Plugin-Manifest
media/cover.html                     Quelle des Titelbilds
```

## Voraussetzungen

`clarify-first` läuft überall, wo der Agent Fragen stellen kann; Hosts ohne Fragedialog fragen stattdessen im Chat. Die Skripte von `knock-first` nutzen macOS-Schnittstellen (`ioreg`, `lsappinfo`, `osascript`); auf anderen Plattformen meldet die Prüfung „anwesend" und der Agent fragt jedes Mal. Für Screenshots braucht das Terminal, das den Agent hostet, die Berechtigung zur Bildschirmaufnahme.

## Lizenz

MIT
