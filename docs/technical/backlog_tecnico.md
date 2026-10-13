
# Backlog Técnico — Vertical Slice 01

## 1. Objetivo

Este documento transforma a **Especificação Técnica — Vertical Slice 01** em um backlog de implementação.

O objetivo não é simplesmente listar funcionalidades. O backlog deve permitir que o projeto seja construído de forma incremental, com cada etapa produzindo um sistema funcional e verificável.

A Vertical Slice 01 deverá permitir executar integralmente a primeira parte da história:

> **Bar → conversa com o velho → decisão → deslocamento → caverna → escolha de rota → combate → consequência narrativa → conclusão da primeira parte.**

O backlog deve respeitar quatro princípios:

1. **Implementar somente o necessário para a Vertical Slice.**
2. **Manter as regras do jogo fora da interface.**
3. **Permitir testes independentes dos sistemas principais.**
4. **Construir o jogo de forma incremental, evitando esperar que toda a arquitetura esteja pronta antes de executar alguma coisa.**

---

# 2. Estratégia de implementação

Embora a arquitetura esteja organizada em camadas, a implementação não deve seguir simplesmente uma abordagem:

```text
fazer todo Domain
→ fazer toda Application
→ fazer toda Presentation
→ fazer toda Infrastructure
```

Isso produziria muitos componentes isolados antes de existir algo jogável.

A implementação deve combinar **dependências arquiteturais** com **fatias verticais funcionais**.

A sequência recomendada é:

```text
Fundação
    ↓
GameState
    ↓
Movimentação
    ↓
Interação
    ↓
Diálogo
    ↓
Primeiro fluxo jogável
    ↓
Eventos/Missão
    ↓
Combate
    ↓
Party
    ↓
Segunda rota
    ↓
Persistência
    ↓
Integração completa
    ↓
Testes e estabilização
```

A cada etapa deve existir algo executável.

---

# 3. Convenções do backlog

## 3.1 Tipos

| Tipo | Significado |
|---|---|
| `FOUNDATION` | Fundação técnica |
| `DOMAIN` | Regra ou modelo do domínio |
| `APPLICATION` | Caso de uso/orquestração |
| `PRESENTATION` | Interface e entrada |
| `INFRASTRUCTURE` | Persistência ou acesso a recursos |
| `CONTENT` | Conteúdo específico do jogo |
| `TEST` | Testes |
| `INTEGRATION` | Integração entre sistemas |
| `POLISH` | Ajustes finais |

## 3.2 Prioridade

| Prioridade | Significado |
|---|---|
| `P0` | Obrigatório para a Vertical Slice |
| `P1` | Importante, mas pode ser implementado posteriormente |
| `P2` | Futuro / fora do escopo atual |

O backlog deste documento concentra-se em `P0`.

---

# 4. EPIC 01 — Fundação do projeto

## BACK-001 — Criar estrutura inicial do projeto

**Tipo:** `FOUNDATION`  
**Prioridade:** P0  
**Dependências:** nenhuma

### Objetivo

Criar a estrutura inicial do projeto de acordo com a arquitetura definida na especificação técnica.

### Escopo

Criar separação inicial entre:

```text
Domain
Application
Presentation
Infrastructure
```

A estrutura exata de diretórios/pacotes dependerá da tecnologia/engine escolhida.

### Critérios de aceite

- Projeto inicia corretamente.
- Estrutura arquitetural está definida.
- Domain não depende de Presentation.
- Domain não depende de Infrastructure.
- Existe uma forma clara de adicionar novos sistemas.

---

## BACK-002 — Definir regras de dependência arquitetural

**Tipo:** `FOUNDATION`  
**Prioridade:** P0  
**Dependências:** BACK-001

### Objetivo

Evitar que a arquitetura se degrade durante a implementação.

### Regra

A direção conceitual das dependências deverá ser:

```text
Presentation
      ↓
Application
      ↓
Domain

Infrastructure → abstrações utilizadas pela Application/Domain
```

Infrastructure não deve fazer com que as regras de negócio dependam de detalhes de armazenamento.

### Critérios de aceite

- As regras estão documentadas.
- Novos componentes conseguem identificar claramente onde devem ser implementados.
- Não existem dependências diretas desnecessárias do domínio para UI ou armazenamento.

---

# 5. EPIC 02 — Estado central do jogo

## BACK-003 — Criar GameState

**Tipo:** `DOMAIN`  
**Prioridade:** P0  
**Dependências:** BACK-001

### Objetivo

Criar o estado central da execução do jogo.

### Estrutura conceitual

```text
GameState
 ├── player
 ├── world
 ├── party
 ├── mission
 ├── currentScene
 └── saveMetadata
```

### Critérios de aceite

- GameState pode representar uma sessão completa.
- O estado não depende da interface.
- O estado pode ser serializado posteriormente.
- Sistemas diferentes conseguem consultar/modificar o estado através de casos de uso apropriados.

---

## BACK-004 — Criar PlayerState

**Tipo:** `DOMAIN`  
**Prioridade:** P0  
**Dependências:** BACK-003

### Dados mínimos

```text
characterId
position
sceneId
attributes
direction
```

### Atributos

```text
HP
Energy
Strength
Defense
Speed
Luck
```

### Critérios de aceite

- O jogador possui estado persistente.
- A posição pode ser alterada.
- A cena atual pode ser identificada.
- Os atributos podem ser utilizados pelo sistema de combate.

---

## BACK-005 — Criar WorldState

**Tipo:** `DOMAIN`  
**Prioridade:** P0  
**Dependências:** BACK-003

### Objetivo

Representar estados relevantes do mundo.

Exemplos:

```text
oldManTalked
missionAccepted
pirateChoiceMade
girlRescued
barAmbushCompleted
clueFound
```

Os nomes exatos das flags podem ser definidos durante a implementação dos eventos.

### Critérios de aceite

- O estado de mundo não depende de elementos visuais.
- Eventos podem alterar o estado.
- O estado pode ser salvo.

---

## BACK-006 — Criar GameMode

**Tipo:** `DOMAIN`  
**Prioridade:** P0  
**Dependências:** BACK-003

### Estados

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

- O jogo possui um estado de execução claramente identificável.
- A entrada do jogador pode ser restringida conforme o GameMode.
- Durante diálogo, por exemplo, movimentação livre não ocorre.

---

# 6. EPIC 03 — Cenas e exploração

## BACK-007 — Criar sistema de cenas

**Tipo:** `DOMAIN / APPLICATION`  
**Prioridade:** P0  
**Dependências:** BACK-003

### Cenas necessárias

```text
OUTSIDE
BAR
PIRATE_CAVE
```

### Critérios de aceite

- O jogo consegue identificar a cena atual.
- É possível entrar e sair de uma cena.
- Cada cena possui sua configuração própria.
- A troca de cena não altera indevidamente o estado da missão.

---

## BACK-008 — Implementar carregamento de cena

**Tipo:** `PRESENTATION / INFRASTRUCTURE`  
**Prioridade:** P0  
**Dependências:** BACK-007

### Objetivo

Carregar visualmente a cena correspondente ao estado do jogo.

### Critérios de aceite

- OUTSIDE carrega.
- BAR carrega.
- PIRATE_CAVE carrega.
- O jogador aparece em uma posição válida.
- A cena atual do GameState corresponde à cena visual carregada.

---

## BACK-009 — Implementar câmera

**Tipo:** `PRESENTATION`  
**Prioridade:** P0  
**Dependências:** BACK-008

### Regras

- Resolução base: `1280x720`.
- Câmera acompanha o protagonista.
- Sem zoom.
- Limites físicos da área.
- Não permitir que o personagem ultrapasse os limites.

### Critérios de aceite

- A câmera acompanha o personagem.
- O personagem não consegue sair do mapa.
- O comportamento é consistente nas três cenas.

---

## BACK-010 — Implementar movimentação

**Tipo:** `PRESENTATION / APPLICATION`  
**Prioridade:** P0  
**Dependências:** BACK-004, BACK-008

### Controles

```text
W / ↑ → cima
S / ↓ → baixo
A / ← → esquerda
D / → → direita
SHIFT → correr
```

### Critérios de aceite

- Zoro movimenta-se.
- A movimentação altera a posição no GameState.
- A movimentação é bloqueada durante diálogos.
- A movimentação é bloqueada durante combate.
- A movimentação respeita colisões.

---

## BACK-011 — Implementar colisões

**Tipo:** `PRESENTATION`  
**Prioridade:** P0  
**Dependências:** BACK-010

### Escopo

Somente colisões necessárias para a Vertical Slice:

- limites do mapa;
- paredes;
- objetos estruturais;
- elementos necessários das cenas.

### Fora do escopo

- destruição de árvores;
- destruição de pedras;
- física avançada;
- água navegável;
- natação.

### Critérios de aceite

- O jogador não atravessa obstáculos.
- Colisões não produzem travamentos.
- O personagem não consegue sair da área jogável.

---

# 7. EPIC 04 — Input

## BACK-012 — Criar abstração de input

**Tipo:** `PRESENTATION / APPLICATION`  
**Prioridade:** P0  
**Dependências:** BACK-001

### Ações

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

### Critérios de aceite

Os sistemas não precisam conhecer diretamente teclas específicas para executar suas regras.

Por exemplo:

```text
DialogueSystem
```

deve trabalhar com:

```text
CONFIRM
```

e não diretamente com:

```text
SPACE
```

---

## BACK-013 — Implementar mapeamento de teclado

**Tipo:** `PRESENTATION`  
**Prioridade:** P0  
**Dependências:** BACK-012

### Mapeamento

| Ação | Tecla |
|---|---|
| Movimento | WASD / setas |
| Interagir | E |
| Correr | SHIFT |
| Confirmar diálogo | SPACE |
| Pausa | ESC |
| Voltar | R |

### Critérios de aceite

- Todas as ações são reconhecidas.
- O sistema permite trocar o mapeamento posteriormente sem modificar regras de domínio.

---

# 8. EPIC 05 — Interação

## BACK-014 — Criar modelo de interação

**Tipo:** `DOMAIN`  
**Prioridade:** P0  
**Dependências:** BACK-003

### Objetivo

Representar algo que possa ser acionado pelo jogador.

Exemplos:

```text
OldMan
BarEntrance
PirateCaveEntrance
Clue
```

### Regra

Não utilizar marcadores visuais obrigatórios.

O jogador deve:

```text
aproximar-se
+
pressionar E
```

### Critérios de aceite

- Sistema identifica alvo válido.
- Sistema dispara interação.
- Interação não é executada fora do alcance.

---

## BACK-015 — Implementar interação com NPC

**Tipo:** `APPLICATION / PRESENTATION`  
**Prioridade:** P0  
**Dependências:** BACK-014, BACK-017

### Critérios de aceite

Ao pressionar `E` próximo ao velho:

```text
GameMode → DIALOGUE
```

e o diálogo correspondente é iniciado.

---

# 9. EPIC 06 — Sistema de diálogo

## BACK-016 — Criar modelo de diálogo

**Tipo:** `DOMAIN`  
**Prioridade:** P0  
**Dependências:** BACK-003

### Modelo conceitual

```text
Dialogue
 ├── speaker
 ├── portrait
 ├── text
 ├── type
 └── next
```

### Tipos

```text
NORMAL
THOUGHT
NARRATION
```

### Critérios de aceite

- Diálogos podem ser representados sem UI.
- É possível identificar o personagem que fala.
- É possível representar pensamentos de Zoro.
- Narrador não precisa de retrato.

---

## BACK-017 — Implementar DialogueController

**Tipo:** `APPLICATION`  
**Prioridade:** P0  
**Dependências:** BACK-016

### Responsabilidades

- iniciar diálogo;
- avançar texto;
- detectar final;
- retornar controle ao sistema anterior;
- impedir movimentação durante diálogo.

### Critérios de aceite

O fluxo:

```text
Exploração
→ E
→ Diálogo
→ SPACE
→ SPACE
→ fim
→ Exploração
```

funciona corretamente.

---

## BACK-018 — Implementar interface de diálogo

**Tipo:** `PRESENTATION`  
**Prioridade:** P0  
**Dependências:** BACK-017

### Elementos

- caixa inferior;
- nome do personagem;
- retrato;
- texto.

### Regra

`SPACE`:

1. primeiro pressionamento completa o texto atual;
2. segundo pressionamento avança.

### Critérios de aceite

- Texto aparece corretamente.
- Speaker correto aparece.
- Retrato correto aparece.
- Pensamento possui diferenciação adequada.
- Controle retorna ao jogador ao final.

---

# 10. EPIC 07 — Sistema de escolhas

## BACK-019 — Criar modelo de Choice

**Tipo:** `DOMAIN`  
**Prioridade:** P0  
**Dependências:** BACK-016

### Estrutura

```text
Choice
 ├── text
 ├── condition
 └── consequence
```

### Critérios de aceite

Uma escolha pode:

```text
ser exibida
→ ser selecionada
→ executar consequência
→ alterar GameState
```

---

## BACK-020 — Implementar ChoiceController

**Tipo:** `APPLICATION`  
**Prioridade:** P0  
**Dependências:** BACK-019

### Controles

```text
W / ↑
S / ↓
E / mouse
```

### Critérios de aceite

- O jogador consegue selecionar uma opção.
- Apenas opções válidas podem ser escolhidas.
- A consequência é executada.
- A escolha fica registrada quando necessário.

---

## BACK-021 — Implementar interface de escolhas

**Tipo:** `PRESENTATION`  
**Prioridade:** P0  
**Dependências:** BACK-020

### Critérios de aceite

- Opções são visualmente distintas.
- Seleção funciona por teclado.
- Seleção funciona por mouse.
- A interface não contém regras narrativas.

---

# 11. EPIC 08 — Eventos

## BACK-022 — Criar modelo de Event

**Tipo:** `DOMAIN`  
**Prioridade:** P0  
**Dependências:** BACK-005

### Estrutura conceitual

```text
Event
 ├── Preconditions
 ├── Actions
 └── Consequences
```

### Critérios de aceite

Eventos podem representar:

```text
entrada na caverna
início automático de diálogo
entrada no bar após aliança
emboscada
descoberta do mapa
```

---

## BACK-023 — Criar EventExecutor

**Tipo:** `APPLICATION`  
**Prioridade:** P0  
**Dependências:** BACK-022

### Responsabilidades

- verificar pré-condições;
- executar ações;
- aplicar consequências;
- registrar evento concluído.

### Regra

Eventos devem ser **idempotentes** quando isso for necessário.

Um evento já concluído não deve executar novamente por acidente.

---

# 12. EPIC 09 — Sistema de missão

## BACK-024 — Criar MissionState

**Tipo:** `DOMAIN`  
**Prioridade:** P0  
**Dependências:** BACK-005

### Informações

```text
missionId
currentStage
route
completedEvents
```

### Rotas

```text
RESCUE
ALLIANCE
```

### Critérios de aceite

- O estado da missão pode ser consultado.
- A rota escolhida permanece registrada.
- A derrota em combate não altera indevidamente a rota.

---

## BACK-025 — Implementar transições da missão

**Tipo:** `APPLICATION`  
**Prioridade:** P0  
**Dependências:** BACK-024, BACK-023

### Fluxo

```text
NOT_STARTED
    ↓
ACCEPTED
    ↓
CAVE
    ↓
CHOICE
   ↙   ↘
RESCUE ALLIANCE
```

### Rescue

```text
RESCUE
 ↓
COMBAT
 ↓
GIRL_RESCUED
 ↓
TREASURE_INFORMATION
 ↓
FIRST_PART_COMPLETE
```

### Alliance

```text
ALLIANCE
 ↓
RETURN_TO_BAR
 ↓
AMBUSH
 ↓
COMBAT
 ↓
CLUE_FOUND
 ↓
FIRST_PART_COMPLETE
```

### Critérios de aceite

- Todas as transições são válidas.
- Transições inválidas são rejeitadas.
- Rota não pode ser trocada posteriormente.

---

# 13. EPIC 10 — Conteúdo da missão

## BACK-026 — Cadastrar personagens

**Tipo:** `CONTENT`  
**Prioridade:** P0  
**Dependências:** BACK-004

### Personagens

```text
Zoro
Johnny
Yosaku
OldMan
Girl
PirateLeader
Pirate1
Pirate2
Gang1
Gang2
Gang3
Gang4
```

O personagem desconhecido que revelou informações à garota não precisa ser implementado como personagem jogável ou NPC nesta Vertical Slice.

### Critérios de aceite

Todos os personagens necessários aos eventos existem como dados.

---

## BACK-027 — Cadastrar diálogos do velho

**Tipo:** `CONTENT`  
**Prioridade:** P0  
**Dependências:** BACK-018

### Conteúdo

Implementar integralmente o diálogo definido para:

```text
Event 01 — Conversa com o velho
```

Incluindo:

- conversa inicial;
- escolha aceitar/recusar;
- diálogo de aceite;
- diálogo de recusa.

### Critérios de aceite

O diálogo implementado corresponde ao roteiro definido no documento de eventos.

---

## BACK-028 — Implementar entrada na caverna

**Tipo:** `CONTENT / INTEGRATION`  
**Prioridade:** P0  
**Dependências:** BACK-008, BACK-023

### Comportamento

Ao entrar na caverna:

```text
controle do jogador
→ evento automático
→ movimentação automática de Zoro
→ posicionamento dos personagens
→ diálogo
→ escolha
```

### Critérios de aceite

A entrada na caverna sempre produz o encontro narrativo esperado quando a missão estiver na etapa correta.

---

## BACK-029 — Implementar escolha da caverna

**Tipo:** `CONTENT / INTEGRATION`  
**Prioridade:** P0  
**Dependências:** BACK-020, BACK-025

### Opções

```text
Resgatar garota
Aliar-se aos piratas
```

### Critérios de aceite

- Escolha é registrada.
- Rota é bloqueada após escolha.
- Cada rota produz consequência diferente.

---

# 14. EPIC 11 — Sistema de combate

## BACK-030 — Criar modelo de CharacterStats

**Tipo:** `DOMAIN`  
**Prioridade:** P0  
**Dependências:** BACK-004

### Atributos

```text
maxHp
maxEnergy
strength
defense
speed
luck
```

---

## BACK-031 — Criar Combatant

**Tipo:** `DOMAIN`  
**Prioridade:** P0  
**Dependências:** BACK-030

### Objetivo

Representar uma entidade durante um combate.

Deve ser possível transformar o estado persistente de um personagem em um estado temporário de combate.

### Critérios de aceite

- Combatant possui HP atual.
- Combatant pode estar vivo ou derrotado.
- Combatant possui atributos necessários ao cálculo.

---

## BACK-032 — Criar CombatAction

**Tipo:** `DOMAIN`  
**Prioridade:** P0  
**Dependências:** BACK-031

### Ações da Vertical Slice

```text
ATTACK
DEFEND
FLEE
```

### Critérios de aceite

Cada ação possui:

```text
actor
actionType
target
parameters
```

quando aplicável.

---

## BACK-033 — Implementar fase de decisão

**Tipo:** `DOMAIN / APPLICATION`  
**Prioridade:** P0  
**Dependências:** BACK-032

### Regra

Primeiro todos escolhem suas ações.

```text
Player
   ↓
seleciona ações

AI
   ↓
seleciona ações

somente depois:
   ↓
execução
```

### Critérios de aceite

Nenhuma ação é executada imediatamente após sua seleção.

---

## BACK-034 — Implementar cálculo de ordem

**Tipo:** `DOMAIN`  
**Prioridade:** P0  
**Dependências:** BACK-030, BACK-033

### Regra

A execução considera a velocidade efetiva.

A relação entre:

```text
Speed
+
HP atual
```

deve ser aplicada conforme a regra definida para o combate.

A fórmula matemática exata deve ser definida antes da implementação definitiva caso ainda não tenha sido formalizada.

### Critérios de aceite

- Combatentes são ordenados.
- Alterações de estado podem alterar a ordem.
- A ordem é determinística para os mesmos dados.

---

## BACK-035 — Implementar cálculo de acerto

**Tipo:** `DOMAIN`  
**Prioridade:** P0  
**Dependências:** BACK-030, BACK-034

### Considerar

- atributos do atacante;
- velocidade do alvo;
- HP/estado do alvo;
- Luck;
- demais modificadores definidos para a Vertical Slice.

### Critérios de aceite

- Ataque pode acertar.
- Ataque pode errar.
- Resultado é calculável sem depender da UI.

---

## BACK-036 — Implementar cálculo de dano

**Tipo:** `DOMAIN`  
**Prioridade:** P0  
**Dependências:** BACK-030, BACK-035

### Considerar

- força/poder do atacante;
- defesa do alvo;
- fator aleatório;
- modificadores aplicáveis.

### Critérios de aceite

- Dano nunca gera HP inválido.
- HP é reduzido corretamente.
- Ataques podem resultar em derrota.

---

## BACK-037 — Implementar Defesa

**Tipo:** `DOMAIN`  
**Prioridade:** P0  
**Dependências:** BACK-032, BACK-036

### Regra

Defender reduz o dano recebido durante o ciclo correspondente.

### Critérios de aceite

- Defesa é registrada como ação.
- Dano é reduzido corretamente.
- Estado defensivo é encerrado no momento correto.

---

## BACK-038 — Implementar Fuga

**Tipo:** `DOMAIN`  
**Prioridade:** P0  
**Dependências:** BACK-032

### Regra

Fuga pode:

```text
SUCESSO
ou
FALHA
```

Em caso de falha:

```text
ação é consumida
```

### Critérios de aceite

- Fuga pode encerrar combate.
- Fuga pode falhar.
- Falha não encerra combate.

---

## BACK-039 — Implementar IA de combate

**Tipo:** `DOMAIN`  
**Prioridade:** P0  
**Dependências:** BACK-033

### Objetivo

Criar uma IA mínima baseada em comportamento.

A IA recebe o estado do combate e escolhe uma ação.

Ela não deve alterar diretamente o estado do combate.

### Critérios de aceite

```text
AI
 ↓
recebe CombatState
 ↓
escolhe CombatAction
 ↓
CombatEngine executa
```

---

## BACK-040 — Implementar ciclo completo de combate

**Tipo:** `DOMAIN / APPLICATION`  
**Prioridade:** P0  
**Dependências:** BACK-033 até BACK-039

### Ciclo

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
    ↓
Victory / Defeat / Flee
    ↓
NewRound
```

### Critérios de aceite

É possível executar um combate completo sem depender da narrativa.

---

# 15. EPIC 12 — Interface de combate

## BACK-041 — Criar interface mínima de combate

**Tipo:** `PRESENTATION`  
**Prioridade:** P0  
**Dependências:** BACK-040

### Exibir

- personagens;
- inimigos;
- HP;
- ações;
- seleção de alvo;
- resultados.

### Não implementar

- animações de ataque;
- efeitos visuais complexos;
- habilidades especiais;
- itens.

---

## BACK-042 — Implementar seleção de ação

**Tipo:** `PRESENTATION`  
**Prioridade:** P0  
**Dependências:** BACK-041

### Opções

```text
Attack
Defend
Flee
```

### Critérios de aceite

O jogador consegue selecionar a ação de cada personagem controlado.

---

## BACK-043 — Implementar seleção de alvo

**Tipo:** `PRESENTATION`  
**Prioridade:** P0  
**Dependências:** BACK-042

### Critérios

- Apenas alvos válidos podem ser selecionados.
- Personagens derrotados não podem ser escolhidos como alvo quando a regra não permitir.
- A seleção gera um CombatAction.

---

## BACK-044 — Exibir resultados do combate

**Tipo:** `PRESENTATION`  
**Prioridade:** P0  
**Dependências:** BACK-040

### Exemplos

```text
Zoro atacou.
Zoro causou 15 de dano.
Pirata errou o ataque.
Yosaku defendeu.
Pirata foi derrotado.
```

Não é necessário utilizar animação.

---

# 16. EPIC 13 — Party

## BACK-045 — Criar PartyState

**Tipo:** `DOMAIN`  
**Prioridade:** P0  
**Dependências:** BACK-003

### Estrutura

```text
members
activeMembers
status
```

---

## BACK-046 — Implementar adição e remoção de membros

**Tipo:** `DOMAIN / APPLICATION`  
**Prioridade:** P0  
**Dependências:** BACK-045

### Caso necessário

Após a aliança:

```text
Zoro
Johnny
Yosaku
```

passam a formar o grupo controlado.

### Critérios de aceite

- Johnny pode entrar no grupo.
- Yosaku pode entrar no grupo.
- Grupo pode ser consultado pelo combate.

---

## BACK-047 — Integrar Party ao combate

**Tipo:** `INTEGRATION`  
**Prioridade:** P0  
**Dependências:** BACK-046, BACK-040

### Combate necessário

```text
Zoro
+
Johnny
+
Yosaku

VS

4 membros da gangue
```

### Critérios de aceite

Todos os três personagens são controláveis durante a fase de decisão.

---

# 17. EPIC 14 — Rota de resgate

## BACK-048 — Implementar combate contra cinco piratas

**Tipo:** `CONTENT / INTEGRATION`  
**Prioridade:** P0  
**Dependências:** BACK-040

### Participantes

```text
Zoro

VS

PirateLeader
Johnny
Yosaku
Pirate1
Pirate2
```

### Critérios de aceite

- Combate inicia automaticamente após diálogo.
- Vitória leva ao diálogo de resgate.
- Derrota permite nova tentativa.
- A rota permanece RESCUE.

---

## BACK-049 — Implementar derrota e retry do resgate

**Tipo:** `APPLICATION / CONTENT`  
**Prioridade:** P0  
**Dependências:** BACK-048

### Critérios de aceite

Após derrota:

```text
retorno ao fluxo definido
→ diálogo de retorno
→ novo combate
```

A escolha da rota não reaparece.

---

## BACK-050 — Implementar diálogo pós-resgate

**Tipo:** `CONTENT`  
**Prioridade:** P0  
**Dependências:** BACK-048

### Conteúdo

Implementar integralmente o diálogo definido após a vitória:

- agradecimento;
- casamento;
- recompensa;
- revelação sobre o velho;
- fruta;
- pessoa desconhecida;
- localização ao sul;
- decisão da garota;
- saída da garota.

### Critérios de aceite

O diálogo termina com a primeira parte da rota de resgate concluída.

---

# 18. EPIC 15 — Rota de aliança

## BACK-051 — Implementar entrada de Johnny e Yosaku no grupo

**Tipo:** `CONTENT / INTEGRATION`  
**Prioridade:** P0  
**Dependências:** BACK-046

### Critérios de aceite

Após a escolha:

```text
Party = [Zoro, Johnny, Yosaku]
```

---

## BACK-052 — Implementar retorno ao bar

**Tipo:** `CONTENT / INTEGRATION`  
**Prioridade:** P0  
**Dependências:** BACK-051, BACK-008

### Fluxo

```text
Caverna
→ saída
→ área externa
→ bar
```

### Critérios de aceite

- O grupo permanece intacto.
- A missão continua na rota ALLIANCE.
- Ao chegar ao bar, evento de emboscada é iniciado.

---

## BACK-053 — Implementar emboscada do velho

**Tipo:** `CONTENT / INTEGRATION`  
**Prioridade:** P0  
**Dependências:** BACK-052, BACK-023

### Participantes

```text
Zoro
Johnny
Yosaku

VS

Gang1
Gang2
Gang3
Gang4
```

### Fluxo

```text
entrada no bar
→ diálogo
→ velho revela traição
→ velho e garota saem
→ combate
```

### Critérios de aceite

- Evento ocorre somente na rota ALLIANCE.
- Combate inicia corretamente.
- A fuga do velho e garota é registrada.

---

## BACK-054 — Implementar combate contra a gangue

**Tipo:** `CONTENT / INTEGRATION`  
**Prioridade:** P0  
**Dependências:** BACK-047, BACK-053

### Critérios de aceite

- Grupo controlado possui três membros.
- Quatro inimigos participam.
- Vitória retorna ao diálogo pós-combate.

---

## BACK-055 — Implementar descoberta do mapa

**Tipo:** `CONTENT / INTEGRATION`  
**Prioridade:** P0  
**Dependências:** BACK-054

### Regra narrativa

A garota já possuía um mapa relacionado à região do tesouro.

Ela não deixou o mapa propositalmente.

Durante a confusão, o papel fica para trás.

Após o combate:

```text
Zoro encontra o mapa
→ Yosaku analisa
→ reconhece a formação
→ infere região ao sul
```

### Pensamento de Zoro

```text
“(Então ela já tinha esse mapa... por que estava carregando algo assim consigo?)”
```

### Critérios de aceite

- O mapa é descoberto no local correto.
- Não é tratado como item de inventário.
- Não gera marcador automático.
- A informação de que a região provável é ao sul é registrada.

---

# 19. EPIC 16 — Interface geral

## BACK-056 — Implementar menu principal

**Tipo:** `PRESENTATION`  
**Prioridade:** P0

### Opções

```text
Iniciar
Salvar
Carregar
Sair
```

### Critérios de aceite

Todas as opções funcionam.

---

## BACK-057 — Implementar pausa

**Tipo:** `PRESENTATION`  
**Prioridade:** P0  
**Dependências:** BACK-056

### Opções

```text
Continuar
Salvar
Carregar
Sair
```

### Critérios de aceite

- ESC abre pausa.
- ESC não interfere durante estados em que a pausa não deve ser permitida.
- Retornar continua exatamente de onde estava.

---

# 20. EPIC 17 — Persistência

## BACK-058 — Criar SaveData

**Tipo:** `INFRASTRUCTURE`  
**Prioridade:** P0  
**Dependências:** BACK-003

### Dados mínimos

```text
GameState
saveMetadata
saveVersion
```

---

## BACK-059 — Criar SaveMapper

**Tipo:** `INFRASTRUCTURE`  
**Prioridade:** P0  
**Dependências:** BACK-058

### Fluxo

```text
GameState
   ↓
SaveMapper
   ↓
SaveData
   ↓
Storage
```

### Critérios de aceite

O estado de jogo pode ser convertido para o formato persistido sem que a estrutura de armazenamento seja conhecida pelo domínio.

---

## BACK-060 — Implementar Storage

**Tipo:** `INFRASTRUCTURE`  
**Prioridade:** P0  
**Dependências:** BACK-059

### Operações

```text
save
load
exists
delete
```

### Escopo

Apenas um slot é necessário.

---

## BACK-061 — Implementar Save

**Tipo:** `APPLICATION / INTEGRATION`  
**Prioridade:** P0  
**Dependências:** BACK-060

### Critérios de aceite

É possível salvar o jogo durante um estado permitido.

Não permitir salvar:

- durante execução de uma ação de combate;
- durante eventos automáticos instáveis;
- durante transições intermediárias.

---

## BACK-062 — Implementar Load

**Tipo:** `APPLICATION / INTEGRATION`  
**Prioridade:** P0  
**Dependências:** BACK-060

### Critérios de aceite

Após carregar:

- cena correta;
- posição correta;
- missão correta;
- rota correta;
- party correta;
- estados do mundo corretos.

---

# 21. EPIC 18 — Testes unitários

## BACK-063 — Testar GameState

**Tipo:** `TEST`  
**Prioridade:** P0

Testar:

- criação;
- alteração de estado;
- integridade básica.

---

## BACK-064 — Testar movimentação

**Tipo:** `TEST`  
**Prioridade:** P0

Testar:

- movimentação;
- bloqueio por colisão;
- limite do mapa.

---

## BACK-065 — Testar diálogos

**Tipo:** `TEST`  
**Prioridade:** P0

Testar:

- início;
- avanço;
- final;
- pensamentos;
- troca de controle.

---

## BACK-066 — Testar escolhas

**Tipo:** `TEST`  
**Prioridade:** P0

Testar:

- escolha RESCUE;
- escolha ALLIANCE;
- consequência;
- persistência da escolha.

---

## BACK-067 — Testar transições da missão

**Tipo:** `TEST`  
**Prioridade:** P0

Testar:

```text
NOT_STARTED → ACCEPTED
ACCEPTED → CAVE
CAVE → RESCUE
CAVE → ALLIANCE
RESCUE → COMPLETE
ALLIANCE → COMPLETE
```

E principalmente:

```text
RESCUE → ALLIANCE
```

deve ser inválido.

---

## BACK-068 — Testar cálculo de combate

**Tipo:** `TEST`  
**Prioridade:** P0

Testar:

- acerto;
- erro;
- dano;
- defesa;
- velocidade;
- derrota;
- fuga.

Os testes devem utilizar entradas controladas para permitir resultados determinísticos quando necessário.

---

## BACK-069 — Testar IA

**Tipo:** `TEST`  
**Prioridade:** P0

Verificar que:

- recebe estado;
- produz ação;
- não modifica diretamente o estado do combate.

---

## BACK-070 — Testar Party

**Tipo:** `TEST`  
**Prioridade:** P0

Testar:

- adicionar membro;
- remover membro;
- consultar membros;
- integração com combate.

---

## BACK-071 — Testar Save/Load

**Tipo:** `TEST`  
**Prioridade:** P0

Cenário principal:

```text
criar GameState
→ alterar missão
→ alterar party
→ alterar cena
→ salvar
→ destruir estado em memória
→ carregar
→ comparar estado
```

O estado restaurado deve representar corretamente o estado salvo.

---

# 22. EPIC 19 — Testes de integração

## BACK-072 — Testar fluxo de resgate

**Tipo:** `INTEGRATION / TEST`  
**Prioridade:** P0

Executar:

```text
Iniciar
→ Bar
→ Velho
→ Aceitar
→ Caverna
→ Resgate
→ Combate
→ Vitória
→ Diálogo
→ Conclusão
```

### Resultado esperado

Primeira parte da rota RESCUE concluída.

---

## BACK-073 — Testar fluxo de aliança

**Tipo:** `INTEGRATION / TEST`  
**Prioridade:** P0

Executar:

```text
Iniciar
→ Bar
→ Velho
→ Aceitar
→ Caverna
→ Aliança
→ Johnny/Yosaku
→ Bar
→ Emboscada
→ Combate
→ Vitória
→ Mapa
→ Conclusão
```

### Resultado esperado

Primeira parte da rota ALLIANCE concluída.

---

## BACK-074 — Testar derrota no combate da rota de resgate

**Tipo:** `INTEGRATION / TEST`  
**Prioridade:** P0

Verificar:

```text
escolhe RESCUE
→ perde
→ retorna
→ combate novamente
```

A escolha não deve reaparecer.

---

## BACK-075 — Testar Save/Load durante a missão

**Tipo:** `INTEGRATION / TEST`  
**Prioridade:** P0

Testar salvamento em diferentes pontos válidos:

```text
exploração
diálogo não ativo
antes da caverna
após escolha
após combate
```

Ao carregar, o fluxo deve continuar corretamente.

---

# 23. EPIC 20 — Integração final

## BACK-076 — Integrar fluxo completo da Vertical Slice

**Tipo:** `INTEGRATION`  
**Prioridade:** P0

Integrar todos os sistemas:

```text
GameState
+
Scenes
+
Input
+
Interaction
+
Dialogue
+
Choice
+
Events
+
Mission
+
Combat
+
Party
+
Save/Load
+
UI
```

### Critério principal

O jogo deve poder ser iniciado do menu e jogado até o encerramento da primeira parte da missão sem intervenção externa.

---

## BACK-077 — Validar estados impossíveis

**Tipo:** `INTEGRATION / TEST`  
**Prioridade:** P0

Verificar situações como:

```text
Johnny aliado sem escolha ALLIANCE
Yosaku aliado sem escolha ALLIANCE
combate de gangue sem rota ALLIANCE
mapa encontrado sem emboscada concluída
diálogo pós-resgate sem vitória
rota RESCUE alterada para ALLIANCE
```

Esses estados devem ser impossíveis ou tratados explicitamente.

---

## BACK-078 — Validar retorno de cena

**Tipo:** `INTEGRATION / TEST`  
**Prioridade:** P0

Verificar:

```text
OUTSIDE → BAR → OUTSIDE
OUTSIDE → CAVE → OUTSIDE
```

sem perda de estado.

---

# 24. EPIC 21 — Estabilização

## BACK-079 — Corrigir bugs funcionais

**Tipo:** `POLISH`  
**Prioridade:** P0

Corrigir problemas encontrados durante os testes integrados.

A regra é não adicionar novas funcionalidades durante essa etapa.

---

## BACK-080 — Validar todos os critérios de aceitação

**Tipo:** `POLISH / TEST`  
**Prioridade:** P0

Executar checklist completo dos critérios deste backlog.

Nenhum item P0 deve permanecer sem validação.

---

## BACK-081 — Executar playthrough completo

**Tipo:** `POLISH / TEST`  
**Prioridade:** P0

Executar manualmente:

### Rota RESCUE

```text
Menu
→ iniciar
→ explorar
→ entrar no bar
→ conversar
→ aceitar
→ ir para caverna
→ escolher resgate
→ vencer combate
→ concluir diálogo
→ finalizar
```

### Rota ALLIANCE

```text
Menu
→ iniciar
→ explorar
→ entrar no bar
→ conversar
→ aceitar
→ ir para caverna
→ escolher aliança
→ voltar ao bar
→ emboscada
→ vencer combate
→ encontrar mapa
→ finalizar
```

### Critério final

Não deve existir um bloqueio que impeça o jogador de completar nenhuma das duas rotas.

---

# 25. Ordem recomendada de execução

O backlog completo é grande, mas não deve ser executado simplesmente pela numeração.

A ordem recomendada é:

## Fase 1 — Fundação

```text
BACK-001
BACK-002
BACK-003
BACK-004
BACK-005
BACK-006
```

Resultado:

> Existe um núcleo capaz de representar o estado do jogo.

---

## Fase 2 — Primeiro ambiente jogável

```text
BACK-007
BACK-008
BACK-009
BACK-010
BACK-011
BACK-012
BACK-013
```

Resultado:

> É possível abrir o jogo e movimentar Zoro pelo ambiente.

---

## Fase 3 — Primeira interação

```text
BACK-014
BACK-015
BACK-016
BACK-017
BACK-018
```

Resultado:

> Zoro consegue entrar no bar, interagir com o velho e conversar.

---

## Fase 4 — Primeira decisão

```text
BACK-019
BACK-020
BACK-021
BACK-022
BACK-023
```

Resultado:

> O jogo já possui diálogo, escolha e eventos.

---

## Fase 5 — Primeira missão funcional

```text
BACK-024
BACK-025
BACK-026
BACK-027
BACK-028
BACK-029
```

Resultado:

> A missão consegue avançar até a escolha na caverna.

---

## Fase 6 — Combate isolado

```text
BACK-030
BACK-031
BACK-032
BACK-033
BACK-034
BACK-035
BACK-036
BACK-037
BACK-038
BACK-039
BACK-040
```

Resultado:

> Existe um sistema de combate funcional independente da história.

---

## Fase 7 — Combate jogável

```text
BACK-041
BACK-042
BACK-043
BACK-044
```

Resultado:

> O jogador consegue efetivamente jogar um combate.

---

## Fase 8 — Party

```text
BACK-045
BACK-046
BACK-047
```

Resultado:

> O sistema suporta múltiplos personagens controláveis.

---

## Fase 9 — Rota RESCUE

```text
BACK-048
BACK-049
BACK-050
```

Resultado:

> A primeira rota da história está completa.

---

## Fase 10 — Rota ALLIANCE

```text
BACK-051
BACK-052
BACK-053
BACK-054
BACK-055
```

Resultado:

> A segunda rota está completa.

---

## Fase 11 — Persistência

```text
BACK-058
BACK-059
BACK-060
BACK-061
BACK-062
```

Resultado:

> O progresso pode ser salvo e restaurado.

---

## Fase 12 — Interface geral

```text
BACK-056
BACK-057
```

Resultado:

> O jogo possui fluxo de inicialização, pausa, save e load.

---

## Fase 13 — Testes

```text
BACK-063
BACK-064
BACK-065
BACK-066
BACK-067
BACK-068
BACK-069
BACK-070
BACK-071
BACK-072
BACK-073
BACK-074
BACK-075
```

Resultado:

> Os sistemas principais e os dois caminhos narrativos estão validados.

---

## Fase 14 — Integração e estabilização

```text
BACK-076
BACK-077
BACK-078
BACK-079
BACK-080
BACK-081
```

Resultado:

> Vertical Slice 01 concluída.

---

# 26. Critério de conclusão da Vertical Slice

A Vertical Slice 01 somente deve ser considerada concluída quando o seguinte fluxo funcionar de ponta a ponta:

```text
                    ┌───────────────┐
                    │  MENU INICIAL │
                    └───────┬───────┘
                            │
                         Iniciar
                            │
                            ▼
                    ┌───────────────┐
                    │    EXTERIOR   │
                    └───────┬───────┘
                            │
                            ▼
                    ┌───────────────┐
                    │      BAR      │
                    └───────┬───────┘
                            │
                           E
                            │
                            ▼
                    ┌───────────────┐
                    │   DIÁLOGO     │
                    │   COM VELHO   │
                    └───────┬───────┘
                            │
                         ACEITAR
                            │
                            ▼
                    ┌───────────────┐
                    │    CAVERNA    │
                    └───────┬───────┘
                            │
                          ESCOLHA
                       ┌────┴────┐
                       │         │
                    RESGATE   ALIANÇA
                       │         │
                       ▼         ▼
                    COMBATE   JOHNNY/
                       │      YOSAKU
                       │         │
                       │         ▼
                       │        BAR
                       │         │
                       │      EMBOSCADA
                       │         │
                       │       COMBATE
                       │         │
                       │         ▼
                       │       MAPA
                       │         │
                       └────┬────┘
                            │
                            ▼
                    PRIMEIRA PARTE
                     CONCLUÍDA
```

Além disso:

- as duas rotas precisam funcionar;
- combate precisa utilizar as regras definidas;
- party precisa funcionar na rota de aliança;
- derrota precisa ser tratada;
- save/load precisa restaurar o estado;
- nenhum estado narrativo impossível pode ocorrer;
- a interface não deve conter regras de negócio;
- o sistema de combate não deve conhecer a história;
- o sistema de missão não deve depender da implementação visual da cena;
- os sistemas principais devem possuir testes automatizados.

---

# 27. O que deliberadamente NÃO está no backlog

Para evitar crescimento prematuro do projeto, os seguintes itens não fazem parte da Vertical Slice 01:

### Mundo

- mapa completo da ilha;
- minimapa;
- áreas adicionais;
- NPCs genéricos;
- barcos;
- natação;
- exploração marítima;
- destruição de objetos.

### Inventário

- inventário;
- equipamentos;
- armas como itens;
- itens de batalha;
- baús;
- lojas;
- dinheiro.

### Progressão

- sistema completo de XP;
- recompensa financeira;
- bounty;
- treinamento;
- evolução de atributos.

### Akuma no Mi

- consumo;
- poderes;
- habilidades;
- energia de habilidades;
- árvore de poderes.

Na Vertical Slice, a fruta existe apenas como **elemento narrativo**.

### Combate

- animações;
- efeitos especiais;
- Haki;
- ataques especiais;
- ataques combinados;
- sistema complexo de habilidades;
- armas como equipamento;
- efeitos de status.

### Áudio

- música;
- efeitos sonoros;
- voz.

### Interface

- configurações;
- mapa;
- minimapa;
- sistema de quests visual complexo;
- indicadores sobre NPCs;
- marcadores de objetivos.

Esses itens podem posteriormente entrar no backlog da próxima Vertical Slice.

---

# 28. Regra para expansão do backlog

Durante a implementação, novas necessidades inevitavelmente aparecerão.

Antes de adicionar uma nova tarefa, deve-se responder:

> **Isso é necessário para tornar a Vertical Slice 01 jogável, testável ou tecnicamente sustentável?**

Se a resposta for **não**, o item deve ser colocado no backlog futuro.

Se a resposta for **sim**, a especificação técnica deve ser atualizada antes da implementação.

Isso evita que o projeto evolua de:

```text
Vertical Slice
```

para:

```text
"vamos implementar o jogo inteiro antes de terminar a primeira missão"
```

---

# 29. Próximo artefato técnico

Com este backlog, o próximo passo não deve ser começar a implementar dezenas de tarefas simultaneamente.

A próxima etapa ideal é transformar cada item executável em **unidades de implementação para o agente de desenvolvimento**, contendo:

```text
Task
├── Contexto
├── Objetivo
├── Arquivos/componentes envolvidos
├── Dependências
├── Restrições arquiteturais
├── Implementação esperada
├── Critérios de aceite
└── Testes obrigatórios
```

Isso permitirá trabalhar posteriormente com **agentes de IA de forma controlada**, onde cada agente recebe uma tarefa pequena, implementa, testa e entrega uma mudança verificável sem precisar conhecer todo o projeto.