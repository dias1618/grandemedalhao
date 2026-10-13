# Especificação Técnica — Vertical Slice 01

**Projeto:** RPG 2D Top-Down  
**Versão:** 0.1  
**Escopo:** Primeira entrega jogável  
**Status:** Especificação técnica

---

# 1. Objetivo

Este documento transforma a definição de Game Design da Vertical Slice 01 em uma especificação técnica orientada à implementação.

Os documentos anteriores definiram:

- a experiência desejada;
- os cenários;
- os personagens;
- o combate;
- os eventos e a missão;
- a interface e a persistência.

Este documento define como esses elementos deverão ser organizados tecnicamente.

O objetivo é permitir que a implementação seja iniciada com responsabilidades claras, baixo acoplamento e uma ordem de desenvolvimento controlada.

---

# 2. Princípio arquitetural

A implementação deve separar claramente:

```text
REGRAS DO JOGO
      ↓
ESTADO DO JOGO
      ↓
SISTEMAS DE JOGO
      ↓
APRESENTAÇÃO
      ↓
INFRAESTRUTURA
```

A lógica responsável por determinar o que acontece no jogo não deve depender diretamente da interface gráfica.

Da mesma forma, a interface não deve ser responsável por decidir regras de negócio.

---

# 3. Objetivo arquitetural da Vertical Slice

A primeira entrega não precisa possuir uma arquitetura excessivamente sofisticada.

Entretanto, ela também não deve ser construída como um conjunto de scripts específicos para cada cena.

O objetivo é encontrar um equilíbrio:

> **arquitetura suficiente para permitir evolução, sem criar infraestrutura que a Vertical Slice ainda não necessita.**

A estrutura deve permitir posteriormente adicionar:

- novas missões;
- novos personagens;
- novos cenários;
- novos combates;
- novos tipos de interação;
- novos sistemas de progressão.

---

# 4. Macroarquitetura

A aplicação poderá ser organizada conceitualmente nas seguintes áreas:

```text
┌──────────────────────────────────────────────┐
│                 APRESENTAÇÃO                 │
│                                              │
│ UI / Cenas / Input / Renderização / Áudio*  │
└───────────────────────┬──────────────────────┘
                        │
                        ▼
┌──────────────────────────────────────────────┐
│              SISTEMAS DE JOGO                │
│                                              │
│ Game Flow                                    │
│ Dialogue                                     │
│ Mission                                      │
│ Combat                                       │
│ Interaction                                  │
│ Party                                        │
│ Save/Load                                    │
└───────────────────────┬──────────────────────┘
                        │
                        ▼
┌──────────────────────────────────────────────┐
│                  DOMÍNIO                     │
│                                              │
│ Character                                    │
│ Combat                                       │
│ Mission                                      │
│ Event                                        │
│ World State                                  │
│ Game State                                   │
└───────────────────────┬──────────────────────┘
                        │
                        ▼
┌──────────────────────────────────────────────┐
│                INFRAESTRUTURA                │
│                                              │
│ Arquivos / Save / Loading / Recursos        │
└──────────────────────────────────────────────┘

* Áudio fora do escopo da Vertical Slice.
```

Essa representação é conceitual.

A implementação concreta dependerá da engine escolhida.

---

# 5. Princípio de dependência

A regra principal é:

> **Sistemas centrais não devem depender de elementos específicos de apresentação.**

Por exemplo, o sistema de missão deve conseguir representar:

```text
missão → rota de aliança
```

sem precisar conhecer:

- qual painel está aberto;
- qual sprite está sendo exibido;
- qual posição a caixa de diálogo ocupa.

Da mesma maneira, a interface deve consultar o estado do jogo para descobrir o que precisa apresentar.

---

# 6. Camadas conceituais

A implementação será organizada em quatro camadas principais.

## 6.1 Domínio

Representa conceitos e regras fundamentais do jogo.

Exemplos:

- personagem;
- atributos;
- combate;
- missão;
- estado de missão;
- ação de combate;
- resultado de combate;
- estado do mundo.

O domínio não deve depender da engine de apresentação.

---

## 6.2 Aplicação

Coordena os casos de uso do jogo.

Exemplos:

- iniciar jogo;
- iniciar missão;
- iniciar diálogo;
- executar escolha;
- iniciar combate;
- concluir combate;
- salvar jogo;
- carregar jogo;
- adicionar personagem ao grupo.

A camada de aplicação coordena o domínio.

---

## 6.3 Apresentação

Responsável por mostrar informações e receber comandos.

Exemplos:

- menu;
- HUD;
- diálogo;
- escolha;
- combate;
- telas de resultado;
- controles.

A apresentação não deve conter regras fundamentais do jogo.

---

## 6.4 Infraestrutura

Responsável por recursos externos ao núcleo do jogo.

Exemplos:

- arquivos;
- sistema de salvamento;
- carregamento de recursos;
- armazenamento local.

---

# 7. Estado global do jogo

O jogo precisa possuir uma representação central do estado atual.

Conceitualmente:

```text
GameState
├── player
├── world
├── party
├── mission
├── currentScene
└── saveMetadata
```

Esse estado não deve ser confundido com a interface.

A interface representa o estado.

O estado é a fonte de verdade.

---

# 8. Estado do jogador

O estado do jogador deverá conter informações como:

```text
PlayerState
├── characterId
├── position
├── sceneId
├── attributes
└── direction
```

Na primeira versão, o personagem principal é Zoro.

A estrutura não deve ser criada de forma que o nome "Zoro" seja uma dependência estrutural.

Isso é importante porque o protagonista poderá ser substituído futuramente por um personagem customizável.

---

# 9. Estado da party

O grupo deverá possuir uma estrutura própria.

Conceitualmente:

```text
PartyState
├── members
│   ├── characterId
│   ├── status
│   └── combatState
└── activeMembers
```

Na Vertical Slice:

### Inicialmente

```text
Zoro
```

### Rota de resgate

```text
Zoro
```

### Rota de aliança

```text
Zoro
Johnny
Yosaku
```

---

# 10. Estado da missão

A missão deverá possuir um estado independente.

Conceitualmente:

```text
MissionState
├── missionId
├── currentStage
├── route
└── completedEvents
```

Isso permite que a missão seja persistida e reconstruída.

---

# 11. Estado do mundo

O mundo deverá possuir somente os estados relevantes.

Exemplos:

```text
WorldState
├── oldManConversationCompleted
├── caveEncounterCompleted
├── allianceEstablished
├── ambushCompleted
└── clueFound
```

Não é necessário persistir cada objeto visual do cenário.

Somente aquilo que possui significado para a lógica do jogo precisa fazer parte do estado.

---

# 12. Estados de aplicação

Além do estado do mundo, o jogo precisa saber **em que modo está operando**.

Exemplo:

```text
GameMode

MAIN_MENU
EXPLORATION
DIALOGUE
CHOICE
COMBAT
PAUSE
LOADING
SAVING
```

Isso permite controlar quais sistemas podem receber entrada do jogador.

---

# 13. Máquina de estados principal

A aplicação poderá utilizar uma máquina de estados para controlar o fluxo geral:

```text
MAIN_MENU
    │
    ├── Start ───────► EXPLORATION
    │
    └── Load ────────► EXPLORATION
                         │
                         ├── interação ──► DIALOGUE
                         │
                         ├── escolha ────► CHOICE
                         │
                         └── combate ────► COMBAT
                                            │
                                            ▼
                                         RESULTADO
                                            │
                                            ▼
                                       EXPLORATION
```

O menu de pausa funciona como um estado temporário sobre o fluxo atual.

---

# 14. Sistema de cenas

Os cenários deverão ser identificados por IDs.

Exemplo conceitual:

```text
BAR
OUTSIDE
PIRATE_CAVE
```

A lógica do jogo não deve depender diretamente do nome do arquivo da cena.

O sistema de cenas deverá fornecer operações equivalentes a:

```text
loadScene(sceneId)
unloadScene(sceneId)
getCurrentScene()
```

---

# 15. Responsabilidade do sistema de cenas

O sistema de cenas é responsável por:

- carregar o cenário;
- posicionar entidades;
- configurar colisões;
- identificar pontos de entrada;
- informar a cena atual;
- permitir transições.

Ele não deve decidir a progressão da missão.

Por exemplo, entrar na caverna pode disparar um evento, mas o sistema de cenas não deve ser responsável por decidir o conteúdo narrativo.

---

# 16. Sistema de input

O input deverá possuir uma camada de abstração.

A lógica do jogo deverá receber ações como:

```text
MOVE_UP
MOVE_DOWN
MOVE_LEFT
MOVE_RIGHT
INTERACT
RUN
CONFIRM
BACK
PAUSE
```

Em vez de depender diretamente de:

```text
Keyboard.W
Keyboard.E
Keyboard.Space
```

Essa separação permitirá futuramente:

- controle;
- remapeamento;
- outras plataformas.

---

# 17. Contextos de input

O mesmo botão pode ter funções diferentes dependendo do estado do jogo.

Exemplo:

```text
Exploração:
E → Interagir

Menu:
E → Confirmar

Diálogo:
SPACE → Avançar

Combate:
E → Confirmar ação
```

O sistema de input deverá encaminhar a ação ao contexto ativo.

---

# 18. Sistema de interação

O sistema de interação deverá determinar qual entidade pode ser interagida.

Fluxo:

```text
Jogador
   ↓
Pressiona INTERACT
   ↓
InteractionSystem
   ↓
Encontra alvo válido
   ↓
Executa interação
```

O sistema deverá considerar:

- distância;
- direção;
- tipo de entidade;
- estado da missão;
- disponibilidade da interação.

---

# 19. Interação contextual

A interação não deverá simplesmente executar uma ação fixa.

Por exemplo:

```text
INTERACT
```

próximo ao velho pode iniciar:

```text
OldManConversationEvent
```

Enquanto a mesma ação próxima à pista pode iniciar:

```text
ClueDiscoveryEvent
```

A entidade define qual interação possui.

---

# 20. Sistema de diálogo

O sistema de diálogo deverá ser independente da apresentação visual.

Conceitualmente:

```text
Dialogue
├── speaker
├── portrait
├── text
├── type
└── next
```

O sistema de apresentação recebe essas informações e monta a caixa de diálogo.

---

# 21. Tipos de diálogo

A Vertical Slice necessita de pelo menos:

```text
NORMAL
THOUGHT
NARRATION
```

### NORMAL

Diálogo de um personagem.

### THOUGHT

Pensamento do protagonista.

### NARRATION

Texto que não pertence diretamente a um personagem.

---

# 22. Fluxo do diálogo

O sistema deverá controlar:

```text
StartDialogue
      ↓
ShowLine
      ↓
WaitInput
      ↓
Advance
      ↓
NextLine
      ↓
EndDialogue
```

Ao terminar:

```text
DialogueSystem
      ↓
EventSystem
```

O evento continua sua execução.

---

# 23. Sistema de escolhas

As escolhas devem ser representadas como dados.

Conceitualmente:

```text
Choice
├── text
├── condition
└── consequence
```

Exemplo:

```text
"Resgatar a garota"
"Aliar-se aos piratas"
```

Cada escolha produz uma consequência no estado da missão.

---

# 24. Sistema de eventos

Os eventos são responsáveis por coordenar sequências narrativas.

Um evento poderá executar:

- diálogo;
- movimentação;
- mudança de estado;
- escolha;
- início de combate;
- mudança de cenário;
- adição de personagem ao grupo.

---

# 25. Estrutura conceitual de evento

```text
GameEvent
├── Preconditions
├── Actions
└── Consequences
```

Um evento não deve precisar conhecer detalhes de implementação da interface.

---

# 26. Exemplo — evento do velho

```text
OldManEvent

Precondition:
mission = NOT_STARTED

Actions:
1. bloquear controle
2. posicionar personagens
3. executar diálogo
4. apresentar escolha

Consequences:
SIM → mission = ACCEPTED
NÃO → nenhuma alteração
```

---

# 27. Exemplo — escolha na caverna

```text
CaveChoiceEvent

Precondition:
mission = CAVE_ENCOUNTER

Actions:
1. diálogo
2. apresentar escolha

Consequences:

RESGATE:
route = RESCUE

ALIANÇA:
route = ALLIANCE
Johnny = ALLY
Yosaku = ALLY
```

---

# 28. Sistema de missão

O sistema de missão é responsável por:

- manter o estado da missão;
- validar transições;
- registrar a rota;
- determinar eventos disponíveis;
- aplicar consequências;
- informar o progresso.

Ele não deve ser responsável por renderizar diálogos ou controlar sprites diretamente.

---

# 29. Transições da missão

As transições devem possuir condições claras.

Exemplo:

```text
NOT_STARTED
    │
    └── aceitar
          ↓
       ACCEPTED
          │
          └── entrar na caverna
                 ↓
             CAVE_ENCOUNTER
```

A missão deve impedir transições inválidas.

---

# 30. Sistema de combate

O sistema de combate deverá ser independente do sistema narrativo.

A missão solicita:

```text
StartCombat(encounter)
```

O sistema de combate executa a batalha.

Ao terminar, retorna:

```text
VICTORY
DEFEAT
FLEE
```

A missão decide o que fazer com esse resultado.

---

# 31. Modelo de encontro

Um combate deverá ser configurável por dados.

Conceitualmente:

```text
CombatEncounter
├── playerParticipants
├── enemyParticipants
├── location
└── rules
```

Isso evita criar um código específico para:

```text
PirateCaveCombat
```

e outro para:

```text
GangCombat
```

---

# 32. Participantes do combate

O sistema deverá receber IDs de personagens.

Exemplo:

```text
playerParticipants:
[ZORO]

enemyParticipants:
[PIRATE_LEADER, JOHNNY, YOSAKU, PIRATE_A, PIRATE_B]
```

Na segunda batalha:

```text
playerParticipants:
[ZORO, JOHNNY, YOSAKU]

enemyParticipants:
[GANG_A, GANG_B, GANG_C, GANG_D]
```

---

# 33. Separação entre personagem e combatente

O personagem é uma entidade persistente.

O combatente é uma representação temporária do personagem dentro da batalha.

Conceitualmente:

```text
Character
    ↓
Combatant
```

O combatente possui:

- HP atual;
- energia atual;
- estado;
- ação escolhida;
- modificadores temporários.

Isso evita poluir o estado permanente do personagem com informações específicas de uma batalha.

---

# 34. Ciclo do combate

O sistema deverá possuir:

```text
CombatStart
    ↓
DecisionPhase
    ↓
ResolveOrder
    ↓
ExecutionPhase
    ↓
CheckResult
    │
    ├── Victory
    ├── Defeat
    ├── Flee
    └── NewRound
```

---

# 35. Sistema de atributos

Os atributos dos personagens devem ser dados configuráveis.

Exemplo:

```text
CharacterStats
├── maxHp
├── maxEnergy
├── strength
├── defense
├── speed
└── luck
```

Os valores não devem estar espalhados pelo código de combate.

---

# 36. Sistema de ações

As ações de combate deverão ser representadas de forma genérica.

Exemplo:

```text
CombatAction
├── actor
├── actionType
├── target
└── parameters
```

Tipos da primeira versão:

```text
ATTACK
DEFEND
FLEE
```

---

# 37. Ataques

Os ataques devem ser dados configuráveis.

Exemplo:

```text
AttackDefinition
├── id
├── name
├── power
├── accuracy
├── energyCost
└── type
```

A primeira versão pode possuir poucos ataques.

Não é necessário implementar um sistema complexo de habilidades.

---

# 38. Resolução do ataque

O fluxo deverá ser:

```text
AttackAction
    ↓
Validate
    ↓
CalculateHit
    ↓
Miss?
 ┌──┴──┐
SIM   NÃO
 │     │
 ▼     ▼
Fim  CalculateDamage
          ↓
      ApplyDamage
          ↓
      UpdateState
```

---

# 39. Sistema de IA

A IA deverá receber o estado atual do combate.

Ela deverá produzir uma ação:

```text
AI
 ↓
CombatState
 ↓
Decision
 ↓
CombatAction
```

A IA não deve modificar diretamente HP ou outros estados.

Ela somente decide.

A execução pertence ao sistema de combate.

---

# 40. Sistema de party

O sistema de grupo será responsável por:

- adicionar personagens;
- remover personagens;
- consultar membros;
- identificar personagens ativos;
- disponibilizar membros para combate.

Exemplo:

```text
PartyService.add(JOHNNY)
PartyService.add(YOSAKU)
```

---

# 41. Sistema de save/load

A persistência será tratada como um caso de uso próprio.

Fluxo de salvamento:

```text
GameState
   ↓
SaveMapper
   ↓
SaveData
   ↓
Storage
```

Fluxo de carregamento:

```text
Storage
   ↓
SaveData
   ↓
SaveMapper
   ↓
GameState
```

---

# 42. Storage

A primeira versão poderá utilizar armazenamento local em arquivo.

A tecnologia específica depende da engine.

O sistema de jogo não deve depender diretamente da API de arquivos.

Conceitualmente:

```text
SaveService
    ↓
Storage
```

---

# 43. Interface de armazenamento

O armazenamento deverá possuir uma abstração equivalente a:

```text
save(data)
load()
exists()
delete()
```

A primeira entrega pode possuir apenas um slot.

---

# 44. Sistema de recursos

Cenas, sprites, retratos, diálogos e definições de personagens deverão ser tratados como recursos.

A implementação deve evitar espalhar referências de recursos diretamente pelas regras de domínio.

Por exemplo:

```text
CharacterId = ZORO
```

é preferível a fazer a regra de negócio conhecer diretamente um arquivo de sprite.

---

# 45. Dados versus comportamento

Sempre que possível, valores configuráveis devem ficar separados da lógica.

Exemplos:

- atributos;
- ataques;
- personagens;
- encontros;
- diálogos;
- cenários.

Isso permitirá alterar conteúdo sem modificar a lógica fundamental.

---

# 46. Conteúdo narrativo como dados

Os diálogos não devem ser codificados diretamente dentro da lógica de movimentação.

O evento deve referenciar um diálogo.

Conceitualmente:

```text
OldManEvent
      ↓
DialogueId
      ↓
OldManConversation
```

Isso permite futuramente editar texto sem alterar a lógica do evento.

---

# 47. Conteúdo de missão como dados

Da mesma forma, as definições da missão devem ser separadas da execução.

Conceitualmente:

```text
MissionDefinition
├── id
├── stages
├── events
└── transitions
```

O sistema interpreta essas definições.

---

# 48. Orquestração

Deve existir um componente responsável por coordenar os sistemas de alto nível.

Conceitualmente:

```text
GameFlowController
```

Ele poderá coordenar:

- mudança de modo;
- início de eventos;
- transições;
- combate;
- diálogo;
- retorno à exploração.

Ele não deve conter todas as regras do jogo.

Seu papel é orquestrar.

---

# 49. Exemplo de fluxo completo

O jogador pressiona E próximo ao velho.

```text
Input
 ↓
InteractionSystem
 ↓
OldManInteraction
 ↓
Mission/Event System
 ↓
DialogueSystem
 ↓
ChoiceSystem
 ↓
MissionState
```

Se o jogador aceitar:

```text
MissionState = ACCEPTED
```

Depois o jogador entra na caverna:

```text
SceneSystem
 ↓
CaveLoaded
 ↓
MissionSystem
 ↓
CaveEncounterEvent
```

---

# 50. Fluxo de resgate

Na escolha:

```text
RESCUE
```

o sistema faz:

```text
MissionState.route = RESCUE
        ↓
StartCombat
        ↓
CombatResult
        ↓
Victory?
        │
        ├── Não → Recovery
        │
        └── Sim
             ↓
        RescueEvent
             ↓
        Dialogue
             ↓
        MissionComplete
```

---

# 51. Fluxo de aliança

Na escolha:

```text
ALLIANCE
```

o fluxo é:

```text
MissionState.route = ALLIANCE
        ↓
Party.add(JOHNNY)
Party.add(YOSAKU)
        ↓
ReturnToBar
        ↓
AmbushEvent
        ↓
StartCombat
        ↓
Victory
        ↓
ClueDiscovery
        ↓
MissionComplete
```

---

# 52. Dependências entre sistemas

A relação conceitual será:

```text
Input
  ↓
Presentation
  ↓
Application / Game Flow
  ↓
Mission / Combat / Dialogue
  ↓
Domain State
  ↓
Persistence
```

Os sistemas não devem criar dependências circulares.

---

# 53. Regra contra dependência circular

Evitar estruturas como:

```text
Combat → Mission
Mission → Combat
```

como dependências diretas permanentes.

Preferencialmente:

```text
GameFlow
 ├── Mission
 └── Combat
```

O GameFlow coordena os dois.

O combate retorna um resultado.

A missão interpreta o resultado.

---

# 54. Regra contra lógica na UI

A interface não deve possuir lógica como:

```text
if player chose alliance:
    add Johnny
```

Essa decisão pertence ao sistema de missão.

A UI apenas informa:

```text
player selected = ALLIANCE
```

O sistema de aplicação executa a consequência.

---

# 55. Regra contra lógica narrativa no combate

O sistema de combate não deve possuir lógica específica para a história.

Evitar:

```text
if caveBattle:
    ...
```

O encontro deve ser configurado externamente.

---

# 56. Regra contra lógica de apresentação no domínio

O domínio não deve executar diretamente:

```text
showDialogue()
playAnimation()
openPanel()
```

Ele deve produzir estados e resultados.

A apresentação reage a esses estados.

---

# 57. Testabilidade

Os sistemas centrais deverão ser implementados de maneira que possam ser testados sem executar o jogo visual completo.

Particularmente:

- cálculo de dano;
- chance de acerto;
- ordem de execução;
- fuga;
- transições de missão;
- escolhas;
- estado de party;
- serialização;
- carregamento.

---

# 58. Testes de domínio prioritários

Antes da integração visual, devem existir testes para:

### Combate

- dano;
- acerto;
- esquiva;
- defesa;
- velocidade;
- morte;
- vitória;
- derrota;
- fuga.

### Missão

- aceitar missão;
- recusar missão;
- escolher resgate;
- escolher aliança;
- impedir mudança de rota;
- adicionar aliados;
- concluir eventos;
- impedir eventos duplicados.

### Persistência

- salvar;
- carregar;
- preservar rota;
- preservar estágio;
- preservar party;
- rejeitar estado inválido.

---

# 59. Testes de integração

Depois dos testes de domínio, deverão ser validados fluxos completos.

Exemplo:

```text
Iniciar
 ↓
Explorar
 ↓
Interagir com velho
 ↓
Aceitar
 ↓
Ir à caverna
 ↓
Escolher aliança
 ↓
Johnny/Yosaku entram no grupo
 ↓
Retornar ao bar
 ↓
Combate
 ↓
Encontrar pista
 ↓
Concluir primeira parte
```

Outro fluxo:

```text
Iniciar
 ↓
Aceitar missão
 ↓
Caverna
 ↓
Resgate
 ↓
Combate
 ↓
Vitória
 ↓
Garota revela informações
 ↓
Concluir primeira parte
```

---

# 60. Critério de aceitação técnica

A Vertical Slice deverá ser considerada tecnicamente pronta quando:

- os sistemas principais estiverem separados;
- o fluxo completo puder ser executado;
- as duas rotas funcionarem;
- o combate funcionar nos dois encontros;
- Johnny e Yosaku puderem mudar de papel;
- a missão mantiver seu estado;
- o jogo puder ser salvo;
- o jogo puder ser carregado;
- os testes principais forem aprovados;
- não existirem dependências estruturais que impeçam a expansão futura.

---

# 61. Ordem recomendada de implementação

A implementação não deverá seguir simplesmente a ordem dos documentos.

A ordem técnica recomendada é:

```text
01. Fundação do projeto
        ↓
02. Game State
        ↓
03. Cenas e movimentação
        ↓
04. Input e interação
        ↓
05. Personagens
        ↓
06. Diálogo
        ↓
07. Eventos e missão
        ↓
08. Combate
        ↓
09. Party
        ↓
10. Save/Load
        ↓
11. UI completa
        ↓
12. Integração da Vertical Slice
        ↓
13. Testes
        ↓
14. Polimento
```

Essa ordem não significa que cada etapa deverá ser completamente finalizada antes de tocar na próxima.

A implementação deverá ocorrer em pequenos incrementos funcionais.

---

# 62. Primeiro incremento técnico

O primeiro incremento deve provar que a aplicação consegue:

```text
Iniciar
 ↓
Carregar cenário
 ↓
Criar protagonista
 ↓
Movimentar protagonista
```

Nada além disso é necessário inicialmente.

---

# 63. Segundo incremento

Adicionar:

```text
Interação
 ↓
NPC
 ↓
Diálogo
 ↓
Escolha
```

Neste momento já será possível validar o primeiro evento da missão.

---

# 64. Terceiro incremento

Adicionar:

```text
MissionState
 ↓
Caverna
 ↓
Evento automático
 ↓
Escolha de rota
```

Agora a estrutura narrativa começa a existir.

---

# 65. Quarto incremento

Implementar o núcleo do combate isoladamente.

Primeiro:

```text
CombatState
```

Depois:

```text
Action
↓
Order
↓
Hit
↓
Damage
↓
Death
```

Somente depois deve ser conectada a apresentação.

---

# 66. Quinto incremento

Adicionar:

```text
Johnny
Yosaku
   ↓
Party
   ↓
Controle múltiplo
```

Isso permite implementar a segunda batalha.

---

# 67. Sexto incremento

Implementar a rota completa de resgate.

Resultado esperado:

```text
Velho
 ↓
Caverna
 ↓
Resgate
 ↓
Combate
 ↓
Vitória
 ↓
Garota
 ↓
Fim
```

---

# 68. Sétimo incremento

Implementar a rota de aliança.

Resultado esperado:

```text
Caverna
 ↓
Aliança
 ↓
Johnny + Yosaku
 ↓
Bar
 ↓
Emboscada
 ↓
Combate
 ↓
Pista
 ↓
Fim
```

---

# 69. Oitavo incremento

Implementar Save/Load.

Testar especialmente:

- antes da missão;
- missão aceita;
- rota de resgate;
- rota de aliança;
- Johnny/Yosaku como aliados;
- após a emboscada;
- após encontrar a pista.

---

# 70. Nono incremento

Executar a Vertical Slice completa sem utilizar ferramentas de desenvolvimento.

O objetivo é verificar se a experiência funciona como um jogador comum experimentaria.

Nenhum estado deverá precisar ser alterado manualmente para terminar a missão.

---

# 71. Décimo incremento

Polimento mínimo:

- posicionamento;
- colisões;
- textos;
- transições;
- feedback;
- interface;
- tratamento de erros;
- pequenos ajustes de balanceamento.

O polimento deverá acontecer somente depois que o fluxo estiver funcional.

---

# 72. Definition of Done

A Vertical Slice somente deverá ser considerada pronta quando cumprir simultaneamente:

### Gameplay

- movimentação funciona;
- exploração funciona;
- interação funciona.

### Narrativa

- diálogos funcionam;
- escolhas funcionam;
- as duas rotas funcionam;
- consequências funcionam.

### Combate

- combate funciona;
- cálculo funciona;
- IA funciona;
- aliados funcionam;
- vitória e derrota funcionam.

### Persistência

- salvar funciona;
- carregar funciona;
- estados são reconstruídos corretamente.

### Qualidade

- testes críticos passam;
- não existem estados narrativos impossíveis conhecidos;
- o jogador consegue completar a experiência sem intervenção externa.

---

# 73. O que não implementar ainda

Mesmo durante a implementação, devem permanecer fora do escopo:

- inventário;
- equipamentos;
- itens;
- economia;
- lojas;
- Haki;
- Akuma no Mi funcional;
- mapa completo;
- NPCs genéricos;
- missões secundárias;
- música;
- efeitos sonoros;
- animações de ataque;
- sistema avançado de progressão;
- múltiplas ilhas.

Se uma dessas funcionalidades parecer necessária durante a implementação, primeiro deve-se verificar se realmente é uma dependência da Vertical Slice.

---

# 74. Regra para novas necessidades

Durante a implementação, será inevitável descobrir necessidades que não estavam previstas.

A regra deverá ser:

```text
Nova necessidade
      ↓
É necessária para a Vertical Slice?
      │
   ┌──┴──┐
   │     │
  NÃO   SIM
   │     │
   ▼     ▼
Adiar  Atualizar
       especificação
```

Não se deve adicionar uma funcionalidade simplesmente porque ela parece interessante.

---

# 75. Mudanças na especificação

Caso a implementação revele uma inconsistência:

1. identificar o problema;
2. verificar os documentos afetados;
3. decidir a alteração;
4. atualizar a documentação;
5. somente então alterar a implementação.

Isso evita que código e documentação evoluam em direções diferentes.

---

# 76. Princípio final da implementação

A implementação da Vertical Slice deverá seguir uma regra simples:

> **Primeiro validar o fluxo. Depois estruturar. Depois polir.**

Não devemos começar criando:

- sistemas genéricos para todos os tipos de RPG;
- framework próprio;
- editor de missões;
- sistema universal de habilidades;
- arquitetura para dezenas de tipos de personagem.

Devemos construir somente aquilo que a primeira entrega realmente exige, mas construir os componentes necessários de maneira suficientemente organizada para permitir evolução.

---

# 77. Visão final da arquitetura

Ao final da primeira implementação, a estrutura conceitual deverá ser próxima de:

```text
                    ┌───────────────┐
                    │     INPUT     │
                    └───────┬───────┘
                            │
                            ▼
                    ┌───────────────┐
                    │ PRESENTATION  │
                    │ UI / SCENES   │
                    └───────┬───────┘
                            │
                            ▼
                    ┌───────────────┐
                    │  GAME FLOW    │
                    └───────┬───────┘
                            │
             ┌──────────────┼──────────────┐
             ▼              ▼              ▼
        ┌─────────┐   ┌──────────┐   ┌──────────┐
        │ MISSION │   │ DIALOGUE │   │  COMBAT  │
        └────┬────┘   └─────┬────┘   └────┬─────┘
             │              │             │
             └──────────────┼─────────────┘
                            ▼
                    ┌───────────────┐
                    │   GAME STATE  │
                    └───────┬───────┘
                            │
             ┌──────────────┼──────────────┐
             ▼              ▼              ▼
        ┌─────────┐   ┌──────────┐   ┌──────────┐
        │  PARTY  │   │ CHARACT. │   │  WORLD   │
        └─────────┘   └──────────┘   └──────────┘
                            │
                            ▼
                    ┌───────────────┐
                    │  SAVE / LOAD  │
                    └───────────────┘
```

Esta estrutura representa o limite arquitetural desejado para a primeira entrega.

Ela é suficientemente estruturada para permitir evolução, mas deliberadamente não tenta antecipar toda a arquitetura do RPG futuro.

---

# 78. Resultado esperado

Com os seis documentos de Game Design e esta especificação técnica, o projeto deixa de estar apenas no nível de uma ideia narrativa.

Agora temos:

```text
IDEIA
  ↓
GAME DESIGN
  ↓
VERTICAL SLICE
  ↓
SISTEMAS
  ↓
ESTADOS
  ↓
FLUXOS
  ↓
ESPECIFICAÇÃO TÉCNICA
  ↓
IMPLEMENTAÇÃO
```

O próximo passo é transformar essa especificação em um **Backlog Técnico da Vertical Slice**, decompondo cada sistema em unidades implementáveis, ordenadas por dependência e com critérios objetivos de conclusão.

Esse backlog será a ponte entre a especificação e o desenvolvimento propriamente dito.