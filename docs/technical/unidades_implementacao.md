
# Unidades de Implementação e Contrato para Agentes
## Vertical Slice 01

## 1. Objetivo

Este documento define como as tarefas do **Backlog Técnico — Vertical Slice 01** devem ser transformadas em unidades de implementação.

O objetivo é permitir que uma pessoa humana conduza o desenvolvimento utilizando agentes de inteligência artificial sem perder:

- controle arquitetural;
- rastreabilidade;
- qualidade;
- testabilidade;
- consistência do código;
- compreensão do estado atual do projeto.

O agente não deve receber uma tarefa vaga como:

> "Implemente o sistema de combate."

Essa tarefa é grande demais, ambígua e difícil de validar.

Em vez disso, o agente deve receber uma unidade delimitada:

> "Implemente o modelo `CombatAction`, contendo ator, ação, alvo e parâmetros. Não implemente execução, cálculo de dano ou UI. Crie os testes correspondentes."

A diferença é fundamental.

O objetivo deste documento é estabelecer essa granularidade.

---

# 2. Princípio fundamental

O agente deve ser tratado como um **executor técnico dentro de uma arquitetura previamente definida**, e não como o responsável por decidir sozinho a arquitetura do projeto.

A divisão de responsabilidades é:

```text
HUMANO
 │
 ├── define produto
 ├── define escopo
 ├── aprova arquitetura
 ├── toma decisões ambíguas
 └── valida mudanças importantes
 │
 ▼
AGENTE
 │
 ├── analisa contexto
 ├── implementa tarefa
 ├── cria testes
 ├── executa validações
 └── relata alterações
```

O agente pode sugerir melhorias.

Ele não deve introduzi-las silenciosamente.

---

# 3. O que constitui uma unidade de implementação

Cada unidade deve possuir:

```text
Implementation Unit
├── ID
├── Nome
├── Tipo
├── Objetivo
├── Contexto
├── Dependências
├── Escopo
├── Fora do escopo
├── Componentes envolvidos
├── Regras
├── Restrições arquiteturais
├── Critérios de aceite
├── Testes obrigatórios
└── Resultado esperado
```

Essa estrutura deve ser suficientemente pequena para que o agente consiga terminar a tarefa em uma única execução controlada.

---

# 4. Regra de tamanho

Uma tarefa deve ser dividida quando ocorrer qualquer uma destas situações:

### 4.1 Possui mais de uma responsabilidade

Exemplo ruim:

```text
Criar sistema de combate completo.
```

Exemplo melhor:

```text
Criar CombatAction.
Criar CombatState.
Criar cálculo de dano.
Criar cálculo de acerto.
Criar execução de ações.
Criar interface de combate.
```

---

### 4.2 Envolve várias camadas

Exemplo ruim:

```text
Criar diálogo completo.
```

Essa tarefa envolve:

```text
Domain
Application
Presentation
Content
```

Deve ser dividida.

---

### 4.3 Possui múltiplos critérios de aceite independentes

Se uma parte da tarefa pode ser concluída e testada independentemente de outra, provavelmente existem duas tarefas.

---

### 4.4 O agente precisaria tomar uma decisão de arquitetura

Esse é um dos sinais mais importantes.

Se a tarefa exige que o agente escolha entre:

```text
Repository
Service
Factory
Strategy
Event
State Machine
```

sem essa decisão estar documentada, a tarefa está mal especificada.

Primeiro deve-se tomar a decisão arquitetural.

Depois delegar a implementação.

---

# 5. Contrato geral de execução do agente

Toda unidade deve ser executada seguindo este ciclo:

```text
READ
  ↓
UNDERSTAND
  ↓
PLAN
  ↓
IMPLEMENT
  ↓
TEST
  ↓
VALIDATE
  ↓
REPORT
```

---

# 6. READ — leitura do contexto

Antes de modificar qualquer arquivo, o agente deve identificar:

- arquitetura;
- estrutura do projeto;
- documentação relevante;
- tarefa atual;
- dependências;
- código existente relacionado;
- testes existentes.

O agente não deve assumir que o projeto está exatamente como descrito na documentação.

A documentação define a intenção.

O código representa o estado atual.

Ambos precisam ser considerados.

---

# 7. UNDERSTAND — compreensão

O agente deve conseguir responder internamente:

```text
O que preciso construir?

Por que isso existe?

Onde isso pertence?

Do que depende?

Quem utilizará isso?

O que não devo modificar?

Como vou saber que terminei?
```

Se essas respostas não forem possíveis, a tarefa não está suficientemente especificada.

---

# 8. PLAN — planejamento

Antes de alterar código, o agente deve determinar:

```text
Arquivos a criar
Arquivos a alterar
Testes a criar
Testes a alterar
Dependências necessárias
```

O planejamento deve ser curto.

Não deve produzir uma arquitetura paralela.

---

# 9. IMPLEMENT — implementação

O agente deve implementar somente o escopo da tarefa.

Uma regra importante:

> **Não resolver problemas futuros durante uma tarefa atual.**

Se o agente encontrar algo como:

```text
"Para fazer isso seria interessante criar um sistema genérico de plugins..."
```

isso não deve ser implementado automaticamente.

Deve ser registrado como sugestão.

---

# 10. TEST — testes

Toda unidade que introduzir comportamento deve possuir testes adequados.

Não significa que todo arquivo precisa necessariamente ter um teste próprio.

O critério é:

> O comportamento introduzido pela tarefa precisa ser verificável.

Exemplo:

```text
CombatAction
```

pode ter testes de construção e validação.

Já:

```text
CombatEngine
```

precisa de testes comportamentais muito mais completos.

---

# 11. VALIDATE — validação

O agente deve executar as validações disponíveis.

Dependendo da tarefa:

```text
unit tests
integration tests
lint
type checking
build
```

Não é suficiente afirmar:

> "O código parece correto."

---

# 12. REPORT — relatório

Ao terminar, o agente deve informar:

```text
Implementado:
- ...

Arquivos criados:
- ...

Arquivos alterados:
- ...

Testes:
- ...

Validações:
- ...

Problemas encontrados:
- ...

Decisões que ficaram pendentes:
- ...
```

Esse relatório será importante para o humano e para outros agentes.

---

# 13. Estados das tarefas

Cada unidade deve possuir um estado:

```text
BACKLOG
   ↓
READY
   ↓
IN_PROGRESS
   ↓
IMPLEMENTED
   ↓
TESTED
   ↓
VALIDATED
   ↓
DONE
```

Também podem existir:

```text
BLOCKED
CANCELLED
NEEDS_REVIEW
```

---

# 14. BACKLOG

A tarefa existe, mas ainda não está pronta para implementação.

Pode faltar:

- dependência;
- decisão;
- especificação;
- contexto.

---

# 15. READY

A tarefa está suficientemente especificada para ser entregue a um agente.

Uma tarefa `READY` deve ter:

- objetivo claro;
- dependências resolvidas;
- escopo definido;
- critérios de aceite;
- testes esperados.

---

# 16. IN_PROGRESS

Um agente está trabalhando nela.

Idealmente apenas um agente deve possuir responsabilidade de escrita sobre uma unidade específica simultaneamente.

---

# 17. IMPLEMENTED

A implementação existe.

Ainda não significa que está correta.

---

# 18. TESTED

Os testes específicos da tarefa foram executados.

---

# 19. VALIDATED

A tarefa foi validada considerando também seu impacto no restante do sistema.

---

# 20. DONE

Somente depois de:

```text
implementação
+
testes
+
validação
+
critérios de aceite
```

---

# 21. Primeiras unidades de implementação

Os contratos executáveis do marco M01 estão em `docs/technical/implementation-units/`. Quando o rascunho desta seção divergir do arquivo da unidade, o arquivo individual prevalece.

A partir do backlog anterior, as primeiras unidades podem ser definidas assim.

---

# IU-001 — Estrutura inicial do projeto

**Backlog:** BACK-001

### Objetivo

Criar a estrutura arquitetural inicial.

### Contexto

O projeto precisa separar claramente:

```text
Domain
Application
Presentation
Infrastructure
```

### Escopo

Criar somente a estrutura necessária para iniciar o desenvolvimento.

### Fora do escopo

- sistemas de jogo;
- UI;
- persistência;
- combate;
- movimentação.

### Critérios de aceite

- projeto compila;
- projeto inicia;
- estrutura arquitetural existe;
- não há dependência de Presentation em Domain.

### Testes

Executar:

```text
build
```

e testes básicos do projeto, caso existam.

---

# IU-002 — GameState

**Backlog:** BACK-003

### Objetivo

Criar o objeto que representa o estado global da sessão.

### Deve conter

```text
player
world
party
mission
currentScene
saveMetadata
```

### Fora do escopo

- persistência;
- serialização;
- UI;
- regras de missão.

### Critérios de aceite

É possível criar um GameState representando uma sessão inicial.

---

# IU-003 — PlayerState

**Backlog:** BACK-004

### Objetivo

Representar o estado persistente do protagonista.

### Dados

```text
characterId
position
sceneId
attributes
direction
```

### Critérios de aceite

O PlayerState pode:

- armazenar posição;
- armazenar cena;
- armazenar atributos;
- identificar o personagem.

---

# IU-004 — WorldState

**Backlog:** BACK-005

### Objetivo

Representar estados relevantes do mundo.

### Regra

O sistema deve permitir registrar estados narrativos sem criar dependência com UI.

### Fora do escopo

Não criar ainda um sistema genérico excessivamente complexo de scripting.

---

# IU-005 — GameMode

**Backlog:** BACK-006

### Objetivo

Representar o estado operacional do jogo.

### Valores

```text
MAIN_MENU
EXPLORATION
DIALOGUE
CHOICE
COMBAT
PAUSE
LOADING
SAVING
```

### Critérios de aceite

O estado atual pode ser consultado e alterado por meio de mecanismos apropriados da arquitetura.

---

# 22. Exemplo de tarefa inadequada

Um agente não deve receber:

```text
Faça o sistema de diálogo.
```

Essa instrução permite que ele invente:

- arquitetura;
- modelo;
- fluxo;
- armazenamento;
- UI;
- comportamento;
- sistema de eventos.

O resultado provavelmente será inconsistente.

---

# 23. Exemplo de tarefa adequada

Uma unidade melhor seria:

```text
IU-006 — Modelo de Dialogue

Objetivo:
Criar o modelo de domínio responsável por representar uma linha
de diálogo.

Dados:
- speaker
- portrait
- text
- type
- next

Tipos:
- NORMAL
- THOUGHT
- NARRATION

Fora do escopo:
- UI
- input
- avanço do diálogo
- carregamento de arquivos
- execução de eventos

Critérios:
- modelo pode representar os três tipos;
- domínio não possui dependência da UI;
- testes cobrem criação e propriedades.
```

Essa tarefa é muito mais segura para delegar.

---

# 24. Unidade de implementação não é necessariamente um commit

Uma unidade pode resultar em:

```text
1 commit
```

mas não deve existir uma regra rígida.

Uma unidade pode exigir:

```text
vários commits
```

durante seu desenvolvimento.

O importante é que a unidade seja uma unidade lógica de trabalho.

---

# 25. Estratégia de commits

Sempre que possível, os commits devem representar mudanças semanticamente compreensíveis.

Exemplos:

```text
feat(domain): add GameState
feat(domain): add PlayerState
feat(dialogue): add Dialogue model
feat(combat): add CombatAction
test(combat): add damage calculation tests
```

Evitar:

```text
fix
changes
stuff
update
AI changes
```

---

# 26. Regra de isolamento

Uma unidade deve modificar o menor conjunto possível de componentes.

Por exemplo:

```text
IU-006
Dialogue model
```

não deveria alterar:

```text
Combat
Save
Scene
Player
```

sem necessidade.

Quanto maior o raio de alteração:

```text
          pequeno
             ↓
        ┌─────────┐
        │ tarefa  │
        └─────────┘
             ↓
       poucos arquivos
             ↓
        fácil validar
```

melhor.

---

# 27. Regra de descoberta de escopo

Durante a implementação, o agente pode descobrir que:

```text
"Esta tarefa depende de X."
```

Existem três possibilidades.

### Caso A — X já existe

Utilizar X.

### Caso B — X é uma dependência prevista

Criar a dependência se ela estiver dentro da tarefa ou solicitar que a dependência seja liberada.

### Caso C — X não estava previsto

Não criar automaticamente uma grande solução.

Registrar:

```text
BLOCKED / NEEDS_DECISION
```

ou criar uma sugestão de nova tarefa.

---

# 28. Regra contra expansão automática

O agente não deve transformar:

```text
"implementar SaveData"
```

em:

```text
SaveData
+
cloud save
+
multiple slots
+
backup
+
compression
+
encryption
+
version migration
```

O escopo atual é:

```text
um slot
estado da Vertical Slice
versão do save
```

Qualquer coisa além disso é futuro.

---

# 29. Regra contra abstração prematura

Também não devemos criar abstrações apenas porque elas poderiam ser úteis no futuro.

Exemplo:

```text
ICharacterRepository
IWorldRepository
ICombatRepository
IAssetRepository
IGameRepository
```

não devem existir apenas porque "Clean Architecture recomenda".

A abstração deve existir quando houver uma necessidade concreta.

Clean Architecture não significa:

> criar interfaces para tudo.

Significa:

> proteger as regras importantes contra detalhes que não deveriam controlá-las.

---

# 30. Agente implementador

O agente responsável por uma unidade deve possuir uma missão limitada:

```text
Você é responsável por implementar uma unidade específica.
Não altere arquitetura fora do escopo.
Não invente requisitos.
Não implemente funcionalidades futuras.
Não altere contratos existentes sem justificativa.
Crie testes para o comportamento introduzido.
Execute as validações disponíveis.
Reporte qualquer ambiguidade.
```

---

# 31. Agente revisor

O revisor possui uma função diferente.

Ele não deve simplesmente perguntar:

> "O código funciona?"

Deve verificar:

```text
Arquitetura
Escopo
Corretude
Testabilidade
Acoplamento
Regressão
Critérios de aceite
```

---

# 32. Separação entre implementador e revisor

Um fluxo interessante para desenvolvimento assistido por agentes é:

```text
             ┌──────────────┐
             │   BACKLOG    │
             └──────┬───────┘
                    │
                    ▼
             ┌──────────────┐
             │    AGENTE    │
             │ IMPLEMENTADOR│
             └──────┬───────┘
                    │
                    ▼
             ┌──────────────┐
             │    TESTES    │
             └──────┬───────┘
                    │
                    ▼
             ┌──────────────┐
             │    AGENTE    │
             │   REVISOR    │
             └──────┬───────┘
                    │
              ┌─────┴─────┐
              │           │
            ACEITO      REJEITADO
              │           │
              ▼           ▼
             DONE      CORREÇÃO
```

Isso permite que o mesmo agente não seja o único juiz do próprio trabalho.

---

# 33. Agente arquiteto

Um terceiro papel pode existir para tarefas que envolvam decisões arquiteturais:

```text
ARCHITECT
```

Ele não deve sair implementando tudo.

Sua responsabilidade é:

- analisar decisões;
- avaliar impacto;
- propor contratos;
- identificar acoplamento;
- manter coerência arquitetural.

O humano continua sendo a autoridade final.

---

# 34. Papéis dos agentes

Para este projeto, uma configuração inicial pode ser:

```text
Human
 │
 ├── Product / Game Design
 ├── Architecture approval
 └── Final review
       │
       ├───────────────┐
       ▼               ▼
   Architect       Implementer
                       │
                       ▼
                    Tester
                       │
                       ▼
                    Reviewer
```

Esses papéis não necessariamente precisam ser quatro agentes diferentes.

Podem ser **personas/contextos diferentes de um mesmo sistema de agentes**.

---

# 35. Contexto mínimo de cada agente

O agente não precisa carregar toda a documentação do projeto em toda tarefa.

Ele deve receber contexto proporcional à tarefa.

Por exemplo, para:

```text
IU-006 — Dialogue
```

o contexto necessário provavelmente inclui:

```text
Arquitetura
+
Especificação técnica de Dialogue
+
Backlog da tarefa
+
Código relacionado
+
Convenções do projeto
```

Não precisa necessariamente carregar:

```text
todo o documento de combate
todo o roteiro
todo o backlog
```

Isso reduz ruído e aumenta a precisão.

---

# 36. Fonte de verdade

O projeto deve possuir uma hierarquia explícita de autoridade.

Sugestão:

```text
1. Decisão humana explícita
          ↓
2. Especificação técnica aprovada
          ↓
3. Backlog aprovado
          ↓
4. Código atual
          ↓
5. Sugestões do agente
```

O agente não deve tratar uma sugestão própria como requisito.

---

# 37. Conflitos

Se o agente encontrar:

```text
Documentação diz A
Código atual faz B
```

ele não deve simplesmente escolher B.

Deve identificar o conflito.

Exemplo:

```text
CONFLICT

Especificação:
Combat usa três ações.

Código:
Combat possui quatro ações.

Ação recomendada:
Solicitar decisão antes de alterar o contrato.
```

Isso é especialmente importante em desenvolvimento multiagente.

---

# 38. Registro de decisões

Decisões arquiteturais importantes devem ser registradas.

Exemplo:

```text
ADR-001 — Combat Actions

Contexto:
A Vertical Slice necessita apenas de Attack, Defend e Flee.

Decisão:
O modelo inicial terá somente essas três ações.

Consequência:
Movement e habilidades especiais ficam para versões futuras.
```

Isso impede que um agente posteriormente "melhore" o sistema e introduza funcionalidades que foram deliberadamente adiadas.

---

# 39. Quando utilizar múltiplos agentes

Múltiplos agentes são mais úteis quando existe **paralelismo real**.

Exemplo:

```text
             BACKLOG
                │
        ┌───────┼────────┐
        ▼       ▼        ▼
     Dialogue Combat   Save
        │       │        │
        ▼       ▼        ▼
      Agent   Agent    Agent
```

Isso só é seguro se as tarefas possuírem contratos suficientemente independentes.

---

# 40. Quando NÃO utilizar múltiplos agentes

Não é recomendável colocar três agentes simultaneamente modificando:

```text
GameState
```

ou:

```text
CombatEngine
```

sem coordenação.

Isso cria:

```text
Agent A
   ↓
modifica contrato

Agent B
   ↓
assume contrato antigo

Agent C
   ↓
corrige parcialmente
```

O ganho de paralelismo desaparece.

---

# 41. Estratégia de paralelismo para este projeto

Uma estratégia adequada seria:

```text
                GameState
                    │
        ┌───────────┼───────────┐
        │           │           │
        ▼           ▼           ▼
     Dialogue    Combat      Scenes
        │           │           │
        ▼           ▼           ▼
     Agent A     Agent B     Agent C
```

Somente depois:

```text
         Integration Agent
                 │
                 ▼
          Vertical Slice
```

---

# 42. Regra de integração

Nenhuma implementação paralela deve ser considerada pronta apenas porque:

```text
"meu agente terminou."
```

Ela precisa ser integrada e validada.

O estado real é:

```text
IMPLEMENTED
```

e não:

```text
DONE
```

até passar pela integração.

---

# 43. Critério de qualidade para uma tarefa

Uma tarefa está tecnicamente boa quando:

```text
[ ] Escopo pequeno
[ ] Objetivo claro
[ ] Dependências conhecidas
[ ] Arquitetura respeitada
[ ] Código implementado
[ ] Testes criados/atualizados
[ ] Testes executados
[ ] Critérios de aceite atendidos
[ ] Nenhuma funcionalidade futura adicionada
[ ] Alterações reportadas
```

---

# 44. Critério de qualidade para o agente

O agente está funcionando bem quando:

- produz mudanças pequenas;
- não inventa requisitos;
- respeita os contratos;
- identifica ambiguidades;
- escreve testes;
- não tenta redesenhar o sistema inteiro;
- consegue explicar suas alterações;
- deixa o projeto em estado verificável.

O melhor agente não é aquele que escreve mais código.

É aquele que **produz a menor mudança correta necessária para atingir o objetivo**.

---

# 45. Primeiro conjunto de tarefas para execução

O projeto não deve começar com todos os `BACK-*` simultaneamente.

O primeiro lote recomendado é:

```text
IU-001  Estrutura inicial
IU-002  GameState
IU-003  PlayerState
IU-004  WorldState
IU-005  GameMode
```

Depois:

```text
IU-006  Scene
IU-007  Input
IU-008  Movement
IU-009  Collision
```

Depois:

```text
IU-010  Interaction
IU-011  Dialogue
IU-012  DialogueController
IU-013  Dialogue view
```

A escolha sim/não não é a IU-013. O contrato em `docs/technical/implementation-units/IU-013-dialogue-view.md` prevalece sobre este rascunho.

O M03 fica nestes contratos, que prevalecem sobre a lista antiga:

```text
IU-014  Choice
IU-015  MissionState
IU-016  Old man choice
IU-017  Choice view
```

O M04 fica nestes contratos, que prevalecem sobre o diagrama do marco:

```text
IU-018  Combatant
IU-019  Combat round
IU-020  Combat session
IU-021  Combat view
```

Isso produz uma progressão muito mais segura.

---

# 46. Primeiro marco técnico

O primeiro marco deve ser:

## M01 — Empty Playable Shell

Ao concluir esse marco, o projeto deverá conseguir:

```text
abrir
 ↓
iniciar
 ↓
carregar cena externa
 ↓
criar GameState
 ↓
criar Zoro
 ↓
movimentar Zoro
 ↓
colidir com cenário
 ↓
encerrar
```

Ainda não haverá:

- combate;
- missão;
- diálogos;
- inventário;
- NPCs.

Esse marco é importante porque valida a fundação antes de adicionar complexidade.

---

# 47. Segundo marco técnico

## M02 — First Interaction

```text
M01
 ↓
Bar
 ↓
NPC
 ↓
E
 ↓
Dialogue
 ↓
SPACE
 ↓
retorno à exploração
```

Neste ponto já teremos:

```text
Scene
+
Input
+
Interaction
+
Dialogue
```

funcionando conjuntamente.

---

# 48. Terceiro marco técnico

## M03 — First Narrative Branch

```text
Dialogue
 ↓
Choice
 ↓
Event
 ↓
MissionState
```

O jogador já poderá aceitar ou recusar a missão.

---

# 49. Quarto marco técnico

## M04 — Combat Prototype

O combate deverá funcionar independentemente da história.

```text
CombatStart
 ↓
Decision
 ↓
Order
 ↓
Execution
 ↓
Result
```

Esse marco é importante porque o combate é um dos sistemas mais complexos da Vertical Slice.

---

# 50. Quinto marco técnico

## M05 — First Complete Route

Integrar:

```text
Mission
+
Dialogue
+
Choice
+
Combat
+
Scene
```

até concluir a rota RESCUE.

---

# 51. Sexto marco técnico

## M06 — Branching Route

Adicionar:

```text
Party
+
Alliance
+
Bar Ambush
+
Gang Combat
+
Clue
```

Agora as duas rotas estarão funcionando.

---

# 52. Sétimo marco técnico

## M07 — Persistence

Adicionar:

```text
Save
+
Load
+
GameState restoration
```

---

# 53. Oitavo marco técnico

## M08 — Vertical Slice Complete

Tudo integrado:

```text
                 ┌───────────────┐
                 │    MENU       │
                 └───────┬───────┘
                         ↓
                 ┌───────────────┐
                 │  EXPLORAÇÃO   │
                 └───────┬───────┘
                         ↓
                 ┌───────────────┐
                 │   DIÁLOGO     │
                 └───────┬───────┘
                         ↓
                 ┌───────────────┐
                 │    ESCOLHA    │
                 └───────┬───────┘
                    ┌────┴────┐
                    ↓         ↓
                 RESGATE   ALIANÇA
                    ↓         ↓
                 COMBATE   PARTY
                    ↓         ↓
                    └────┬────┘
                         ↓
                    CONSEQUÊNCIA
                         ↓
                       SAVE
                         ↓
                       LOAD
```

---

# 54. O papel deste documento no projeto

A partir daqui temos quatro níveis diferentes:

```text
DOCUMENTO DE GAME DESIGN
        │
        ▼
ESPECIFICAÇÃO TÉCNICA
        │
        ▼
BACKLOG TÉCNICO
        │
        ▼
UNIDADES DE IMPLEMENTAÇÃO
        │
        ▼
CÓDIGO
```

Cada nível responde a uma pergunta diferente:

| Artefato | Pergunta |
|---|---|
| Game Design | O que queremos que o jogador experimente? |
| Especificação Técnica | Como o sistema deve ser estruturado? |
| Backlog | O que precisa ser construído? |
| Unidade de Implementação | Qual mudança concreta deve ser feita agora? |
| Código | Como isso foi efetivamente implementado? |

Essa separação é especialmente importante quando agentes de IA participam do desenvolvimento.

---

# 55. Próxima etapa

Com o backlog e o contrato de implementação definidos, o próximo passo é criar o **ambiente de desenvolvimento do agente**.

Isso significa definir, antes de começar a codificar:

```text
AGENT HARNESS
├── regras globais
├── contexto do projeto
├── documentação obrigatória
├── definição de papéis
├── workflow de implementação
├── workflow de revisão
├── workflow de testes
├── regras de Git
├── controle de tarefas
├── critérios de parada
└── mecanismo de feedback
```

A partir desse ponto, o projeto deixa de ter apenas uma arquitetura de software e passa a ter também uma **arquitetura de desenvolvimento assistido por agentes**.