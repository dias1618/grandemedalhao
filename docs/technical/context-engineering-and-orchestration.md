# Context Engineering e Orquestração
## Harness de Desenvolvimento — Vertical Slice 01

## 1. Objetivo

O harness já possui:

- regras globais;
- arquitetura;
- papéis de agentes;
- workflows;
- templates;
- gates;
- unidades de implementação.

Agora precisamos resolver uma questão central:

> **Como entregar ao agente o contexto correto para executar uma tarefa sem obrigá-lo a conhecer o projeto inteiro?**

O objetivo desta camada é construir um mecanismo de **contexto progressivo e direcionado**.

O agente deverá receber:

```text
Implementation Unit
        ↓
Contexto da tarefa
        ↓
Documentação relevante
        ↓
Código relevante
        ↓
Testes relevantes
        ↓
Agente
```

Em vez de:

```text
Agente
  ↓
"Leia tudo"
  ↓
centenas de arquivos
  ↓
contexto excessivo
  ↓
decisões ruins
```

---

# 2. Princípio do contexto mínimo suficiente

O agente deve receber:

> **todo o contexto necessário para tomar uma decisão correta, mas somente o contexto necessário.**

Isso é diferente de simplesmente reduzir tokens.

O objetivo não é:

```text
menos contexto
```

O objetivo é:

```text
contexto relevante
```

Um agente implementando `CombatAction` precisa conhecer:

- arquitetura;
- especificação do combate;
- contrato de `CombatAction`;
- modelos relacionados;
- testes existentes relacionados.

Ele não precisa necessariamente ler:

- mapa;
- história completa;
- sistema de save;
- documentos de UI.

---

# 3. Contexto em camadas

O contexto será dividido em níveis.

```text
                    CONTEXTO
                       │
          ┌────────────┴────────────┐
          ▼                         ▼
       GLOBAL                    TASK
          │                         │
          ▼                         ▼
      PROJECT                  SPECIFIC
          │                         │
          └────────────┬────────────┘
                       ▼
                    CODE
                       │
                       ▼
                    TESTS
```

---

# 4. Nível 0 — Regras globais

Todo agente deve conhecer um conjunto pequeno de regras que nunca muda durante a execução.

Exemplo:

```text
.cursor/rules/00-core.mdc
.cursor/rules/01-architecture.mdc
.cursor/rules/05-agents.mdc
```

Esse contexto é:

```text
GLOBAL
```

Ele define **como o agente deve trabalhar**.

Não define detalhes de uma funcionalidade específica.

---

# 5. Nível 1 — Contexto do projeto

O agente recebe um resumo do projeto.

Exemplo:

```text
.cursor/context/project.md
.cursor/context/current-state.md
```

Esse contexto responde:

> "Em que projeto estou trabalhando e onde estamos?"

Não deve conter todos os detalhes do jogo.

---

# 6. Nível 2 — Contexto arquitetural

Quando a tarefa envolve código, o agente recebe:

```text
.cursor/context/architecture.md
```

e, quando necessário:

```text
docs/technical/especificacao_tecnica.md
```

A diferença é importante.

`architecture.md` é o **resumo operacional**.

A especificação técnica é a **fonte detalhada**.

O agente consulta a especificação quando precisar de detalhes.

---

# 7. Nível 3 — Contexto da tarefa

Esse é o contexto principal.

Exemplo:

```text
docs/technical/implementation-units/IU-002-game-state.md
```

A tarefa deve ser autocontida o suficiente para que o agente saiba:

```text
O que fazer
Por que fazer
Onde fazer
O que não fazer
Como validar
```

---

# 8. Nível 4 — Documentos relacionados

Uma tarefa pode declarar explicitamente suas referências.

Exemplo:

```md
## References

- docs/technical/especificacao_tecnica.md
- docs/game-design/eventos_dialogos_missoes.md
- docs/game-design/personagens.md
```

Isso evita que o agente precise adivinhar quais documentos são relevantes.

---

# 9. Nível 5 — Código relacionado

O agente deve descobrir o código relacionado utilizando a tarefa e as referências.

Por exemplo:

```text
IU-006 Dialogue
        ↓
Dialogue specification
        ↓
search: Dialogue
        ↓
DialogueController
DialogueView
DialogueTest
```

Não devemos depender exclusivamente de caminhos fixos.

O código pode mudar de organização.

---

# 10. Nível 6 — Testes relacionados

Os testes fazem parte do contexto, não apenas da validação.

Se estamos alterando:

```text
CombatEngine
```

devemos procurar:

```text
CombatEngineTest
DamageCalculatorTest
CombatIntegrationTest
```

ou os equivalentes existentes.

Isso permite ao agente entender o comportamento atual antes de alterá-lo.

---

# 11. O manifesto da Implementation Unit

Para facilitar a resolução de contexto, cada unidade terá uma seção adicional:

```md
## Context

### Required Documents

- docs/technical/especificacao_tecnica.md

### Relevant Specifications

- CombatAction
- CombatState

### Relevant Components

- CombatEngine
- CharacterStats

### Relevant Tests

- CombatActionTest
- CombatEngineTest

### Related Decisions

- ADR-001
```

Isso transforma a tarefa em um pequeno **manifesto de contexto**.

---

# 12. Exemplo completo

Uma tarefa poderia ser:

```md
# IU-032 — CombatAction

## Objective

Create the domain model representing a combat action.

## Scope

The model must represent:

- actor;
- action type;
- target;
- parameters.

## Out of Scope

- action execution;
- damage calculation;
- hit calculation;
- UI;
- AI.

## References

### Required Documents

- docs/technical/especificacao_tecnica.md
- docs/game-design/combates.md

### Related Components

- CharacterStats
- Combatant

### Related Tests

- CombatActionTest

### Related Decisions

None

## Acceptance Criteria

- CombatAction represents ATTACK.
- CombatAction represents DEFEND.
- CombatAction represents FLEE.
- Actor is identified.
- Target can be represented when required.
- Domain has no presentation dependency.
```

O agente já recebe um mapa de navegação.

---

# 13. Context Resolver

O harness terá conceitualmente um componente chamado:

```text
Context Resolver
```

Sua responsabilidade será transformar:

```text
IU-032
```

em:

```text
Execution Context
```

---

# 14. Execution Context

O resultado será conceitualmente:

```text
ExecutionContext
│
├── Global Rules
├── Project Context
├── Current State
├── Architecture
├── Task
├── Referenced Documents
├── Relevant Code
├── Relevant Tests
└── Relevant Decisions
```

Esse objeto não precisa necessariamente existir como uma classe.

Inicialmente pode ser um processo baseado em arquivos e instruções do Cursor.

O importante é definir o contrato.

---

# 15. Context Resolver — algoritmo

O processo será:

```text
1. Ler Implementation Unit
        ↓
2. Validar task
        ↓
3. Ler contexto global
        ↓
4. Ler referências explícitas
        ↓
5. Identificar componentes relacionados
        ↓
6. Buscar código
        ↓
7. Buscar testes
        ↓
8. Buscar ADRs relacionados
        ↓
9. Montar Execution Context
        ↓
10. Entregar ao agente
```

---

# 16. Passo 1 — Ler a tarefa

Primeiro o agente deve conhecer:

```text
IU-XXX
```

Não deve começar pelo código.

Isso é importante porque o código mostra:

> "como está."

A tarefa mostra:

> "o que precisa ser feito."

---

# 17. Passo 2 — Verificar se a tarefa está pronta

Antes de procurar código, o agente verifica:

```text
[ ] objetivo
[ ] escopo
[ ] fora do escopo
[ ] dependências
[ ] critérios de aceite
[ ] referências
```

Se faltar algo essencial:

```text
TASK_NOT_READY
```

---

# 18. Passo 3 — Contexto global

Carregar:

```text
.cursor/rules/00-core.mdc
.cursor/rules/01-architecture.mdc
.cursor/rules/05-agents.mdc
```

Isso define o comportamento do agente.

---

# 19. Passo 4 — Contexto específico

Depois:

```text
.cursor/context/project.md
.cursor/context/current-state.md
```

Isso responde:

```text
Qual projeto?
Qual milestone?
O que já foi feito?
O que está acontecendo agora?
```

---

# 20. Passo 5 — Referências explícitas

A própria tarefa informa:

```text
References
```

Esses documentos são carregados primeiro.

Isso é importante porque referências explícitas têm maior confiabilidade do que inferências feitas pelo agente.

---

# 21. Passo 6 — Descoberta de código

Agora entra a pesquisa no projeto.

O agente deve procurar:

```text
nomes de componentes
nomes de classes
interfaces
funções
testes
```

relacionados à tarefa.

Por exemplo:

```text
IU-032
CombatAction
```

pode gerar buscas por:

```text
CombatAction
CombatActionTest
ActionType
Combatant
```

---

# 22. Não confiar apenas no nome

Busca textual não é suficiente.

Por exemplo, uma implementação pode chamar-se:

```text
BattleCommand
```

enquanto a especificação chama:

```text
CombatAction
```

Por isso o agente deve combinar:

```text
nome
+
referências
+
imports
+
uso
+
testes
```

---

# 23. Descoberta por dependência

Suponha:

```text
CombatEngine
```

depende de:

```text
CombatAction
Combatant
CombatState
```

Ao modificar `CombatAction`, precisamos conhecer os consumidores relevantes.

Portanto:

```text
CombatAction
     ↓
usado por
     ↓
CombatEngine
     ↓
usado por
     ↓
CombatController
```

O agente deve conhecer pelo menos o primeiro nível de consumidores quando estiver alterando um contrato.

---

# 24. Regra de raio de impacto

Podemos definir três níveis:

### Radius 0

Arquivo diretamente alterado.

### Radius 1

Componentes que dependem diretamente dele.

### Radius 2

Componentes que dependem dos consumidores.

Normalmente:

```text
Radius 0 + Radius 1
```

é suficiente para implementação.

Radius 2 pode ser usado para análise de risco.

---

# 25. Exemplo

Alterando:

```text
CharacterStats
```

### Radius 0

```text
CharacterStats
```

### Radius 1

```text
Combatant
PlayerState
DamageCalculator
SpeedCalculator
```

### Radius 2

```text
CombatEngine
CombatController
SaveMapper
```

O agente não precisa necessariamente carregar tudo.

Mas deve saber que existe.

---

# 26. Contexto por risco

Nem todas as tarefas precisam da mesma profundidade.

Podemos classificar:

```text
LOW
MEDIUM
HIGH
```

### LOW

Exemplo:

```text
criar enum
```

Contexto:

```text
task
+
architecture
+
relevant code
```

### MEDIUM

Exemplo:

```text
criar DialogueController
```

Contexto:

```text
task
+
architecture
+
spec
+
related code
+
tests
```

### HIGH

Exemplo:

```text
alterar GameState
```

Contexto:

```text
task
+
architecture
+
all references
+
consumers
+
tests
+
ADRs
+
integration risks
```

---

# 27. Classificação de risco

A própria Implementation Unit terá:

```md
## Risk

LOW
```

ou:

```md
## Risk

MEDIUM
```

ou:

```md
## Risk

HIGH
```

---

# 28. Tarefas de alto risco

Para:

```text
GameState
MissionState
CombatState
SaveData
public contracts
```

o workflow será diferente.

Em vez de:

```text
Implementer
→ Reviewer
```

teremos:

```text
Architect
→ Human approval
→ Implementer
→ Tester
→ Reviewer
```

---

# 29. Mudança arquitetural

Se o agente descobrir durante uma tarefa que precisa alterar uma fronteira arquitetural:

```text
STOP
```

Não deve simplesmente fazer.

Deve produzir:

```text
ARCHITECTURE_CHANGE_REQUIRED
```

com:

```text
Current architecture
Proposed change
Reason
Alternatives
Impact
```

Isso pode gerar um ADR.

---

# 30. ADR como memória coletiva dos agentes

Essa é uma das partes mais importantes do harness.

Imagine que o agente A decide:

> "Combat actions serão objetos imutáveis."

Se isso ficar apenas no histórico daquela conversa, o agente B não sabe.

Se virar:

```text
ADR-004
```

então:

```text
Agent A
   ↓
ADR-004
   ↓
Agent B
   ↓
Agent C
```

Todos passam a conhecer a decisão.

---

# 31. Decisões como contratos

As decisões não devem ser apenas textos históricos.

Devem responder:

```text
O que foi decidido?
Por quê?
Onde se aplica?
Onde não se aplica?
```

Isso evita extrapolação.

---

# 32. Current State como checkpoint

O arquivo:

```text
.cursor/context/current-state.md
```

funcionará como um checkpoint.

Exemplo:

```md
# Current Project State

## Milestone

M03 — First Narrative Branch

## Current Task

IU-016 — Mission transitions

## Completed

- IU-001
- IU-002
- IU-003
- IU-006
- IU-010
- IU-011
- IU-012
- IU-013
- IU-014
- IU-015

## In Progress

- IU-016

## Blocked

None

## Recent Decisions

- ADR-002 — Mission route is immutable after choice.

## Known Problems

- None
```

---

# 33. Nunca usar Current State como fonte de verdade histórica

O `current-state.md` é operacional.

Não deve tentar registrar tudo.

A fonte histórica é:

```text
Git
+
ADRs
+
documentation
```

O `current-state.md` apenas responde:

> "Onde estamos agora?"

---

# 34. Contexto de execução

Quando o agente iniciar uma tarefa, podemos visualizar:

```text
┌──────────────────────────────┐
│       IMPLEMENTATION UNIT    │
│           IU-016             │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│       GLOBAL RULES           │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│      PROJECT CONTEXT         │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│      ARCHITECTURE            │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│     TASK REFERENCES          │
└──────────────┬───────────────┘
               │
          ┌────┴─────┐
          ▼          ▼
       SOURCE      TESTS
          │          │
          └────┬─────┘
               ▼
        ┌──────────────┐
        │    AGENT     │
        └──────────────┘
```

---

# 35. Shared context entre agentes

Quando o Implementer terminar, o Reviewer não deve receber apenas:

> "O agente terminou a tarefa."

Ele deve receber:

```text
Task
+
Implementation report
+
Git diff
+
Tests
+
Relevant specification
+
Architecture
+
ADRs
```

Assim o Reviewer consegue trabalhar independentemente da interpretação do Implementer.

---

# 36. O diff é parte do contexto

O Reviewer deve analisar o **diff real**.

Não confiar apenas no relatório.

Fluxo:

```text
Implementer
      ↓
changes
      ↓
git diff
      ↓
Reviewer
```

Isso reduz o risco de:

```text
"Implementei apenas X"
```

quando na realidade o agente modificou:

```text
X
Y
Z
```

---

# 37. Handoff entre agentes

Precisamos de um formato padronizado.

Exemplo:

```md
# Handoff

## Task

IU-016

## Status

IMPLEMENTED

## Changes

- Created MissionState
- Added route transition logic
- Added transition validation

## Files

- ...
- ...

## Tests

- ...
- ...

## Validation

- Unit tests: PASS
- Build: PASS

## Decisions

None

## Concerns

None

## Reviewer Context

Pay particular attention to:

- route immutability;
- invalid transitions;
- mission state persistence.
```

Isso é muito melhor do que simplesmente passar o histórico inteiro da conversa de um agente para outro.

---

# 38. Estado da tarefa como máquina de estados

Podemos formalizar:

```text
BACKLOG
   │
   ▼
READY
   │
   ▼
IN_PROGRESS
   │
   ├───────────────┐
   ▼               ▼
BLOCKED         IMPLEMENTED
                   │
                   ▼
                 TESTED
                   │
                   ▼
                REVIEWING
              ┌────┴────┐
              ▼         ▼
          APPROVED   CHANGES
              │         │
              ▼         │
             DONE ◄──────┘
```

---

# 39. BLOCKED

Uma tarefa deve entrar em `BLOCKED` quando:

- falta decisão humana;
- dependência não existe;
- documentação conflita;
- contrato precisa mudar;
- arquitetura precisa ser alterada;
- requisito é ambíguo de forma relevante.

Não devemos usar `BLOCKED` para:

> "O agente encontrou um bug simples."

Bug simples é responsabilidade de implementação.

---

# 40. Multiagente e concorrência

Agora chegamos a um problema crítico.

Imagine:

```text
Agent A → GameState
Agent B → SaveData
Agent C → PlayerState
```

Todos podem tocar em:

```text
GameState
```

Isso gera conflitos.

O harness deve possuir uma ideia de:

```text
OWNERSHIP
```

---

# 41. Ownership

Cada tarefa declara os componentes que pode modificar.

Exemplo:

```md
## Write Scope

Allowed:

- src/domain/combat/CombatAction.*

Forbidden:

- src/domain/save/*
- src/presentation/*
- src/domain/mission/*
```

Isso é extremamente útil para multiagente.

---

# 42. Shared files

Alguns arquivos são naturalmente compartilhados:

```text
GameState
Project configuration
dependency files
routing
central registries
```

Eles devem ser classificados como:

```text
HIGH CONTENTION
```

Tarefas que modificam esses arquivos não devem ser executadas em paralelo sem coordenação.

---

# 43. Lock conceitual

O harness pode representar:

```text
GameState → LOCKED BY IU-002
```

Enquanto essa tarefa estiver sendo trabalhada:

```text
Agent B
```

não deve modificar o mesmo contrato sem coordenação.

Inicialmente podemos fazer isso apenas documentalmente.

Depois podemos automatizar.

---

# 44. Parallelism Matrix

Uma ferramenta útil será:

| Tarefa | Domain | Mission | Combat | UI | Save |
|---|---:|---:|---:|---:|---:|
| IU-010 | — | — | — | ✓ | — |
| IU-032 | ✓ | — | ✓ | — | — |
| IU-050 | — | ✓ | — | — | — |
| IU-060 | ✓ | — | — | — | ✓ |

Se duas tarefas possuem `✓` no mesmo componente crítico, precisamos avaliar paralelismo.

---

# 45. Regra de paralelismo

Duas tarefas podem rodar em paralelo quando:

```text
não compartilham contratos críticos
+
não modificam os mesmos arquivos
+
suas dependências estão concluídas
```

Caso contrário:

```text
SEQUENTIAL
```

---

# 46. Primeira versão do harness

O Harness V1 está materializado nestes caminhos:

```text
.cursor/
│
├── rules/
│   ├── 00-core.mdc
│   ├── 01-architecture.mdc
│   ├── 02-coding.mdc
│   ├── 03-testing.mdc
│   ├── 04-git.mdc
│   └── 05-agents.mdc
│
├── agents/
│   ├── architect.md
│   ├── implementer.md
│   ├── tester.md
│   └── reviewer.md
│
├── workflows/
│   ├── implement-task.md
│   ├── review-task.md
│   ├── fix-task.md
│   └── integrate-task.md
│
├── templates/
│   ├── implementation-task.md
│   ├── review-report.md
│   ├── handoff.md
│   └── decision.md
│
└── context/
    ├── project.md
    ├── architecture.md
    └── current-state.md
```

E:

```text
docs/
├── game-design/
├── technical/
│   ├── especificacao_tecnica.md
│   ├── backlog_tecnico.md
│   ├── unidades_implementacao.md
│   ├── context-engineering-and-orchestration.md
│   └── implementation-units/
│       └── IU-001-... até IU-009-...
└── decisions/
    └── ADR/
        └── ADR-001-godot-stack-e-greenfield.md

tools/harness/
├── gate.py
└── check_domain_boundaries.py

tests/run_domain_tests.gd
```

---

# 47. Harness V1

Os arquivos da seção 46 existem no repositório. O contexto de uma unidade é o próprio markdown em `docs/technical/implementation-units/`. O gate que impede `VALIDATED` sem contrato e sem os comandos declarados é:

```text
python3 tools/harness/gate.py IU-001
```

`gate.py --check-contract IU-001` confere só o contrato, sem Godot.

A camada de execução continua sendo o Cursor, com os papéis em `.cursor/agents/` e os workflows em `.cursor/workflows/`. Não há um servidor de orquestração.

O fluxo de uma unidade é:

```text
              HUMAN
                │
                ▼
          "Execute IU-001"
                │
                ▼
       ┌───────────────────┐
       │ TASK ORCHESTRATOR │
       └─────────┬─────────┘
                 │
       ┌─────────▼─────────┐
       │ CONTEXT RESOLVER  │
       └─────────┬─────────┘
                 │
                 ▼
             ARCHITECT
                 │
                 ▼
           IMPLEMENTER
                 │
                 ▼
              TESTER
                 │
                 ▼
             REVIEWER
                 │
          ┌──────┴──────┐
          ▼             ▼
       APPROVED       CHANGES
          │             │
          ▼             └──→ IMPLEMENTER
         DONE
```

Locks automáticos, matriz de paralelismo e o esquema de dados de diálogo e missão ficam para depois do shell do M01. O próximo passo de produto é executar `IU-001`, não redefinir o harness.