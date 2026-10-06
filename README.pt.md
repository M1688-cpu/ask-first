<p align="center"><img src="media/cover.png" alt="ask-first cover" width="800"></p>

# ask-first

[English](README.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md) | [Français](README.fr.md) | [Deutsch](README.de.md) | [Español](README.es.md) | Português

Duas skills de agente que perguntam antes de agir.

`clarify-first` entrevista você uma pergunta por vez até a tarefa ficar concreta o bastante para construir, e confirma um resumo escrito antes de o trabalho começar. `knock-first` verifica se você está no computador e pede sua permissão antes de o agente assumir a área de trabalho para testes, e avisa no instante em que a máquina volta a ser sua.

Os dois problemas parecem o mesmo do lado de quem usa: o agente adivinha, age pelo palpite, e o palpite estava errado. Perguntar antes custa menos que refazer.

## Instalação

A [skills CLI](https://skills.sh) cuida da detecção de host para Claude Code, Codex, Cursor, Gemini CLI, GitHub Copilot, opencode, Amp e os demais hosts suportados:

```bash
npx skills add M1688-cpu/ask-first -g
```

Ou rode o instalador deste repositório, que detecta os agentes da sua máquina e copia em cada um (`--all` para todos os agentes suportados, `--list` para pré-visualizar, `--remove` para desinstalar):

```bash
git clone https://github.com/M1688-cpu/ask-first.git
bash ask-first/install.sh
```

O Claude Code também pode instalar como plugin:

```text
/plugin marketplace add M1688-cpu/ask-first
/plugin install ask-first@ask-first
```

Para copiar manualmente, estas são as pastas que cada agente lê:

| Agente | Pasta de skills |
| --- | --- |
| Claude Code | `~/.claude/skills` |
| Codex | `~/.codex/skills` |
| Cursor | `~/.cursor/skills` |
| Gemini CLI | `~/.gemini/skills` |
| opencode | `~/.config/opencode/skill` |
| Amp | `~/.amp/skills` |
| OpenClaw | `~/.openclaw/skills` |
| ZCode | `~/.zcode/skills` |
| qualquer agente que leia o formato aberto | `~/.agents/skills` |

Depois de instaladas, as skills disparam sozinhas quando suas condições batem; você também pode chamá-las pelo nome.

## clarify-first

Um agente que adivinha diante de um pedido vago constrói a coisa errada com confiança. Esta skill faz ele perguntar.

Dispara quando o objetivo, o escopo, a entrega ou uma decisão-chave do pedido admitem mais de uma leitura. Pedidos claros, pequenos e mecânicos passam direto, com uma linha repetindo o que o agente entendeu.

A entrevista:

1. Uma pergunta por vez, cada uma com 2-4 opções e uma resposta recomendada; a maioria das respostas é um clique.
2. As perguntas seguintes nascem das suas respostas, então a entrevista converge em vez de percorrer uma lista fixa.
3. O que o agente pode procurar no código, na documentação ou na web nunca é perguntado. Pergunta-se só sobre intenção, gosto e restrições.
4. Cerca de 7 perguntas é o teto; além disso, o agente está perguntando errado.
5. Com 95 % de confiança ele escreve um brief da tarefa: objetivo, dentro, fora, entrega, premissas. O trabalho começa depois da sua aprovação.

```text
você:   adicione modo escuro ao meu site
agente: Quais partes? O site todo, ou primeiro as páginas de leitura?
        (recomendado: páginas de leitura primeiro, elas concentram 80 % do
        tempo de leitura)
você:   as páginas de leitura
agente: Seguir a aparência do sistema, ou criar um botão próprio?
        (recomendado: seguir o sistema, um componente a menos para manter)
você:   seguir o sistema
agente: Brief: paleta escura nas páginas de leitura, segue a aparência do
        sistema, área admin intacta, tokens da paleta vão em theme.css. Começo?
        [sim / mudar algo]
```

## knock-first

Testes que movem o mouse e digitam podem colidir com quem está usando a máquina. Um teste que falha é o dano leve; uma edição perdida ou um clique errado é pior. Esta skill faz o agente verificar, perguntar, executar e devolver.

Dispara antes de qualquer assunção da área de trabalho: capturas de tela, abrir o app recém-compilado, simular entradas, redimensionar janelas para um teste.

O ciclo:

1. Detectar: um script lê o tempo ocioso de teclado e mouse, o app em primeiro plano e se há um app de reunião ou mídia rodando, e diz se você parece estar presente. Quem assiste a um vídeo sem tocar no teclado conta como presente.
2. Pedir: um único diálogo mostra o que a detecção encontrou, a lista exata das ações planejadas e uma estimativa de tempo. Opções: pode ir, não perguntar mais nesta sessão, ou agora não. O consentimento existe só na conversa atual e nunca é gravado em lugar nenhum.
3. Executar: exatamente as ações listadas. Qualquer coisa fora da lista volta para uma nova pergunta.
4. Devolver: uma notificação do macOS com som, mais um resumo do resultado no chat, para você saber o instante em que a máquina é sua de novo.

```text
agente: Você está no Xcode agora (ocioso 40 s). Preciso da área de trabalho por
        uns 3 minutos para: abrir o app compilado, redimensionar para 1280x800,
        tirar 3 capturas, digitar uma busca. Pode ir?
        [pode ir / não perguntar mais nesta sessão / agora não]
você:   pode ir
        ... os testes rodam ...
agente: Notificação enviada: "Testes concluídos: 3 capturas salvas."
        No chat: o travamento da busca não se reproduziu, as capturas estão em
        artifacts/. Seu computador é seu de novo.
```

## Arquivos

```text
skills/clarify-first/SKILL.md        a skill de entrevista
skills/knock-first/SKILL.md          a skill de consentimento da área de trabalho
skills/knock-first/scripts/          checagem de atividade e avisos (macOS)
install.sh                           detecta os agentes instalados e copia em cada um
.claude-plugin/                      manifesto de plugin do Claude Code
media/cover.html                     fonte da imagem de capa
```

## Requisitos

`clarify-first` funciona em qualquer lugar onde o agente consiga perguntar; hosts sem diálogo de perguntas caem para perguntas no chat. Os scripts de `knock-first` usam interfaces do macOS (`ioreg`, `lsappinfo`, `osascript`); nas outras plataformas a detecção responde "presente" e o agente pergunta toda vez. A captura de tela exige permissão de gravação de tela para o terminal que hospeda o agente.

## Licença

MIT
