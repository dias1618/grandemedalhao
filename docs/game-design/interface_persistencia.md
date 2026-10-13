# Interface e Persistência — Vertical Slice 01

**Projeto:** RPG 2D Top-Down  
**Versão:** 0.1  
**Escopo:** Primeira entrega jogável  
**Status:** Em definição

---

# 1. Objetivo do documento

Este documento define as interfaces e o sistema de persistência necessários para a Vertical Slice 01.

A interface deverá permitir que o jogador compreenda e opere os sistemas definidos nos documentos anteriores:

- exploração;
- interação;
- diálogos;
- escolhas;
- combate;
- grupo;
- pausa;
- salvamento;
- carregamento.

A interface deve ser simples e funcional.

A primeira entrega não busca definir o design visual definitivo do jogo.

---

# 2. Princípio da interface

A interface deve apresentar somente informações necessárias para a atividade atual.

Durante exploração, o jogador deve enxergar principalmente o mundo.

Durante diálogo, a prioridade deve ser o texto e os personagens.

Durante combate, a prioridade deve ser a tomada de decisão e o resultado das ações.

Portanto, não deverá existir uma HUD excessivamente carregada.

---

# 3. Estados principais da interface

A interface possui quatro contextos principais:

```text
MENU
  │
  ▼
EXPLORAÇÃO
  │
  ├──► DIÁLOGO
  │
  └──► COMBATE
          │
          ▼
       RESULTADO
          │
          ▼
      EXPLORAÇÃO
```

Além desses estados, existe a interface de pausa.

---

# 4. Menu inicial

O menu inicial deverá possuir somente quatro opções:

```text
INICIAR
SALVAR
CARREGAR
SAIR
```

Não haverá:

- configurações;
- opções gráficas;
- controles;
- áudio;
- idioma;
- créditos;
- extras.

Esses elementos ficam para versões futuras.

---

# 5. Iniciar

A opção **INICIAR** cria uma nova sessão de jogo.

O jogo deverá inicializar:

- estado inicial do mundo;
- personagem protagonista;
- posição inicial;
- estado inicial da missão;
- estado inicial dos cenários;
- estado inicial dos personagens.

A missão começa como:

**NÃO INICIADA**

---

# 6. Carregar

A opção **CARREGAR** deverá permitir recuperar um estado salvo anteriormente.

Se existir um salvamento válido:

```text
Carregar
   ↓
Restaurar estado
   ↓
Reconstruir mundo
   ↓
Continuar jogo
```

Se não existir salvamento válido, o sistema deverá informar ao jogador que não existe jogo salvo disponível.

---

# 7. Salvar

A opção **SALVAR** grava o estado atual do jogo.

O salvamento deve representar o estado lógico do jogo, e não apenas a posição do personagem.

Devem ser preservadas informações suficientes para reconstruir a experiência.

---

# 8. Pausa

Durante a exploração, o jogador pode pressionar:

**ESC**

para abrir o menu de pausa.

A interface de pausa deverá possuir, no mínimo:

```text
CONTINUAR
SALVAR
CARREGAR
SAIR
```

A opção **SAIR** deverá retornar ao menu inicial ou encerrar a sessão conforme o fluxo definido pela implementação.

Antes de abandonar um jogo não salvo, poderá existir uma confirmação.

---

# 9. Pausa durante eventos

O comportamento da pausa durante diálogos, escolhas e eventos automáticos deverá ser controlado pelo estado atual.

Na primeira versão, recomenda-se que:

- diálogos possam ser pausados;
- exploração possa ser pausada;
- combate possa ser pausado;
- escolhas não possam ser perdidas por uma pausa;
- movimentações automáticas sejam interrompidas de forma segura.

O sistema não deve permitir que uma pausa cause inconsistência no estado de um evento.

---

# 10. Interface de exploração

Durante a exploração, a interface deve permanecer mínima.

A tela deverá conter:

- mundo;
- personagem;
- elementos de cenário;
- eventualmente informações essenciais de estado.

Não haverá uma HUD complexa nesta versão.

Não haverá:

- minimapa;
- mapa completo;
- marcador de missão;
- marcador sobre NPC;
- marcador sobre objetos;
- minimapa de objetivos;
- bússola;
- lista permanente de missões.

---

# 11. Informação sobre missão

Embora não exista um marcador visual permanente, o sistema deve manter internamente o estado da missão.

A interface poderá apresentar informações contextuais quando necessário.

Entretanto, o jogador deverá obter as informações principalmente através dos diálogos.

Por exemplo, depois de aceitar a missão, o velho informa verbalmente onde está a caverna.

Não será criado automaticamente um ícone apontando para ela.

---

# 12. Interação

A interação utiliza:

**E**

Quando o jogador estiver próximo de um personagem ou objeto interativo, poderá pressionar E.

Não haverá ícone flutuante obrigatório.

O jogador deverá compreender a possibilidade de interação através do contexto.

---

# 13. Interface de diálogo

A caixa de diálogo ficará localizada na parte inferior da tela.

Conceitualmente:

```text
┌───────────────────────────────────────────────┐
│                                               │
│                 CENÁRIO                       │
│                                               │
│                                               │
├──────────────┬────────────────────────────────┤
│   RETRATO    │ NOME                           │
│              │                                │
│              │ Texto do diálogo...            │
│              │                                │
└──────────────┴────────────────────────────────┘
```

A disposição visual definitiva poderá ser ajustada posteriormente.

---

# 14. Elementos do diálogo

A interface deverá apresentar:

- retrato;
- nome do personagem;
- texto;
- indicação de continuação quando necessário.

O retrato é opcional para:

- narrador;
- pensamentos do protagonista.

Pensamentos poderão ser visualmente diferenciados do diálogo normal.

---

# 15. Avanço do diálogo

O controle principal para avançar o diálogo será:

**SPACE**

O comportamento será:

### Primeiro SPACE

Conclui a exibição do texto atual caso ele ainda esteja sendo apresentado progressivamente.

### Segundo SPACE

Avança para o próximo diálogo.

Se o texto já estiver completamente visível, um único pressionamento poderá avançar diretamente.

---

# 16. Bloqueio durante diálogo

Enquanto o diálogo estiver ativo:

- movimentação do personagem fica bloqueada;
- interações externas ficam bloqueadas;
- eventos paralelos não devem interferir na sequência.

O sistema de diálogo possui controle temporário sobre a experiência.

Ao terminar:

```text
Diálogo
   ↓
Evento concluído
   ↓
Controle devolvido
```

---

# 17. Interface de escolhas

As escolhas serão apresentadas dentro do contexto do diálogo.

Exemplo:

```text
Você irá atrás dos bandidos?

> SIM
  NÃO
```

O jogador poderá utilizar:

- WASD;
- setas;
- E;
- mouse.

---

# 18. Escolha principal da caverna

A escolha mais importante da Vertical Slice será:

```text
O que Zoro fará?

> RESGATAR A GAROTA
  ALIAR-SE AOS PIRATAS
```

A seleção deve ser claramente visível.

Depois da confirmação, a escolha é registrada no estado da missão.

---

# 19. Confirmação de escolha

Não deverá existir confirmação adicional desnecessária.

Quando o jogador confirmar:

```text
Escolha
   ↓
Estado registrado
   ↓
Evento continua
```

A escolha passa a fazer parte do estado persistente da missão.

---

# 20. Interface de combate

A interface de combate deve permitir que o jogador compreenda:

- quem está lutando;
- HP dos participantes;
- personagens disponíveis;
- ação atual;
- alvo;
- resultado das ações.

Um modelo conceitual:

```text
┌───────────────────────────────────────────────┐
│                  INIMIGOS                     │
│                                               │
│ Pirata 1     HP  50 / 50                     │
│ Pirata 2     HP  24 / 50                     │
│ Pirata 3     HP  80 / 80                     │
│                                               │
├───────────────────────────────────────────────┤
│                   GRUPO                       │
│                                               │
│ Zoro         HP  80 / 100                    │
│                                               │
├───────────────────────────────────────────────┤
│ AÇÕES                                         │
│                                               │
│ > ATACAR                                      │
│   DEFENDER                                    │
│   FUGIR                                       │
└───────────────────────────────────────────────┘
```

O layout é conceitual.

O design visual definitivo não faz parte desta documentação.

---

# 21. Seleção de personagem

No combate da caverna existe apenas Zoro.

Portanto, a interface é simples.

No combate da emboscada existem:

- Zoro;
- Johnny;
- Yosaku.

O sistema deve permitir que o jogador percorra os personagens vivos e escolha uma ação para cada um.

---

# 22. Fluxo de decisão do combate

O jogador seleciona:

```text
Personagem
    ↓
Ação
    ↓
Alvo
```

Por exemplo:

```text
Zoro
 ↓
ATACAR
 ↓
Pirata 2
```

Depois:

```text
Johnny
 ↓
DEFENDER
```

Depois:

```text
Yosaku
 ↓
ATACAR
 ↓
Pirata 4
```

Quando todas as decisões estiverem definidas:

```text
CONFIRMAR
   ↓
EXECUÇÃO
```

---

# 23. Indicador de personagem ativo

Durante a fase de decisão, a interface deve deixar claro qual personagem está recebendo a ação.

Exemplo:

```text
> ZORO
  Johnny
  Yosaku
```

Depois da decisão de Zoro:

```text
  Zoro       ATACAR → Pirata 2
> Johnny
  Yosaku
```

Isso evita confusão em batalhas com vários personagens.

---

# 24. Estado dos personagens

A interface deverá diferenciar personagens vivos e derrotados.

Exemplo:

```text
Zoro       HP 80/100
Johnny     HP 45/70
Yosaku     DERROTADO
```

Personagens derrotados não podem receber novas ações.

---

# 25. Resultado das ações

Após a fase de decisão, o jogo apresenta os resultados.

Exemplo:

```text
Zoro atacou Pirata 2.
Acerto!
Dano: 18.

Pirata 1 atacou Zoro.
Acerto!
Dano: 9.

Yosaku atacou Pirata 4.
O ataque errou.
```

A apresentação poderá ocorrer em sequência.

---

# 26. Registro de combate

A interface deverá manter um registro temporário das ações.

Esse registro não precisa ser salvo como histórico permanente.

Seu objetivo é ajudar o jogador a compreender o que ocorreu na rodada.

O registro poderá desaparecer ou ser substituído pela próxima rodada.

---

# 27. Tela de resultado

Ao final do combate, o jogo poderá apresentar uma pequena indicação:

```text
VITÓRIA
```

ou:

```text
DERROTA
```

ou:

```text
FUGA
```

Essa informação não precisa abrir uma tela complexa.

Após uma breve confirmação, o jogo retorna ao cenário ou ao fluxo narrativo correspondente.

---

# 28. Interface de derrota

Quando o jogador perde um combate, o sistema deverá informar claramente que o grupo foi derrotado.

A interface não deverá apresentar recompensas ou inventário, pois esses sistemas estão fora do escopo.

O fluxo será:

```text
DERROTA
   ↓
Mensagem/resultado
   ↓
Recuperação
   ↓
Continuação da missão
```

A forma exata de retorno será definida pela implementação do estado da missão.

---

# 29. Interface de salvamento

Ao selecionar **SALVAR**, o sistema deverá fornecer uma confirmação visual.

Exemplo:

```text
Jogo salvo com sucesso.
```

Em caso de erro:

```text
Não foi possível salvar o jogo.
```

A primeira versão não necessita de:

- múltiplos slots;
- nomes de save;
- miniaturas;
- data formatada;
- descrição manual.

Um único estado de salvamento é suficiente para a Vertical Slice.

---

# 30. Interface de carregamento

Ao selecionar **CARREGAR**, caso exista um salvamento:

```text
Carregando jogo...
```

Depois:

```text
Estado restaurado.
```

Se não existir:

```text
Nenhum jogo salvo encontrado.
```

A implementação deve impedir carregamento de dados inválidos.

---

# 31. Persistência

O sistema de persistência deverá salvar o **estado lógico do jogo**.

Não deve simplesmente salvar uma posição e assumir que o restante da história será reconstruído automaticamente.

---

# 32. Estado mínimo persistido

O Save Game deverá possuir informações equivalentes a:

```text
GameState
├── player
│   ├── position
│   ├── currentScene
│   └── attributes
│
├── mission
│   ├── currentState
│   └── selectedRoute
│
├── party
│   ├── members
│   └── memberStates
│
└── world
    ├── completedEvents
    └── relevantWorldStates
```

A estrutura final dependerá da arquitetura utilizada na implementação.

---

# 33. Posição do jogador

A posição do jogador deverá ser salva quando necessário.

Devem ser considerados:

- cenário;
- posição X;
- posição Y;
- orientação, caso necessária.

Isso permite que o jogo seja retomado de maneira coerente.

---

# 34. Cenário atual

O salvamento deverá indicar em qual cenário o jogador estava.

Exemplo:

```text
currentScene = BAR
```

ou:

```text
currentScene = PIRATE_CAVE
```

Isso permite reconstruir corretamente o cenário ao carregar.

---

# 35. Estado da missão

O estado da missão é uma das informações mais importantes do Save Game.

Exemplo:

```text
mission.state = ALLIANCE
```

ou:

```text
mission.state = CLUE_FOUND
```

Isso determina como o mundo deverá ser reconstruído.

---

# 36. Rota escolhida

A rota deverá ser persistida separadamente quando necessário.

Exemplo:

```text
route = RESCUE
```

ou:

```text
route = ALLIANCE
```

A rota não deve ser inferida exclusivamente pela posição do jogador.

---

# 37. Estado dos personagens

O sistema deverá preservar o papel atual dos personagens relevantes.

Exemplo:

```text
Johnny = ALLY
Yosaku = ALLY
```

ou:

```text
Johnny = ENEMY
Yosaku = ENEMY
```

Isso é necessário porque os mesmos personagens possuem papéis diferentes dependendo da rota.

---

# 38. Eventos concluídos

O sistema deverá registrar eventos que produzem mudanças permanentes.

Exemplos:

```text
oldManConversationCompleted
caveChoiceMade
allianceEstablished
ambushCompleted
clueFound
```

Os nomes são conceituais.

A implementação poderá utilizar outra estrutura.

---

# 39. Reconstrução do mundo

Ao carregar o jogo, o mundo não deverá ser simplesmente colocado na posição salva.

Ele deverá ser reconstruído a partir do estado.

Por exemplo:

```text
Salvar
  ↓
Rota = ALIANÇA
Johnny = ALIADO
Emboscada = CONCLUÍDA
Pista = ENCONTRADA
  ↓
CARREGAR
  ↓
Construir mundo
  ↓
Johnny acompanha Zoro
Velho não inicia novamente a missão
Emboscada não acontece novamente
Pista já foi encontrada
```

---

# 40. Salvamento durante combate

A primeira versão deverá evitar salvar no meio da fase de execução de uma batalha.

O salvamento durante combate deve ser bloqueado.

Isso evita a necessidade de persistir:

- ações escolhidas;
- ordem parcialmente executada;
- ações pendentes;
- estados intermediários;
- resultados parcialmente aplicados.

O jogador poderá salvar antes ou depois do combate, conforme o estado do jogo.

---

# 41. Salvamento durante eventos automáticos

Da mesma forma, recomenda-se bloquear o salvamento durante sequências automáticas.

Por exemplo:

- movimentação automática;
- diálogo em andamento;
- transição de cenário;
- execução de evento;
- animação obrigatória.

O salvamento deverá ocorrer em estados estáveis.

---

# 42. Estado estável

Um estado estável é aquele em que o sistema pode interromper a execução sem perder uma operação lógica em andamento.

Exemplos:

### Estado estável

```text
Jogador controlando Zoro no bar.
```

### Estado instável

```text
Evento executando:
Zoro caminhando automaticamente até o líder.
```

O sistema deverá preferir salvar no primeiro caso.

---

# 43. Integridade do Save Game

O jogo deverá verificar se o salvamento possui estrutura válida.

Caso um arquivo esteja:

- incompleto;
- corrompido;
- incompatível;
- ilegível;

o sistema não deverá carregá-lo parcialmente.

A primeira versão poderá simplesmente informar que o salvamento é inválido.

---

# 44. Compatibilidade futura

Não é necessário criar um sistema completo de migração de versões nesta primeira entrega.

Entretanto, o Save Game deverá possuir uma identificação de versão.

Conceitualmente:

```text
saveVersion = 1
```

Isso permitirá futuramente distinguir estruturas antigas de estruturas novas.

---

# 45. Separação entre Save Game e domínio

O estado persistido não deve obrigar os objetos internos do jogo a possuírem exatamente a mesma estrutura.

Conceitualmente:

```text
Jogo
  ↓
Estado do domínio
  ↓
Save Model
  ↓
Arquivo
```

Ao carregar:

```text
Arquivo
  ↓
Save Model
  ↓
Estado do domínio
  ↓
Jogo
```

Essa separação permite modificar detalhes internos sem necessariamente quebrar o formato do salvamento.

---

# 46. O que não será salvo

A primeira versão não precisa persistir:

- histórico completo de diálogos;
- histórico de combates;
- configurações;
- áudio;
- preferências gráficas;
- inventário;
- equipamentos;
- dinheiro;
- mapa completo;
- missões secundárias.

Esses sistemas não fazem parte da Vertical Slice.

---

# 47. Relação entre UI e estado do jogo

A interface não deve ser responsável por armazenar o estado da missão.

Por exemplo, a tela de diálogo não deve decidir que:

```text
Johnny = aliado
```

Ela apenas apresenta o evento.

O sistema de missão altera o estado.

A interface apenas representa o estado atual.

Conceitualmente:

```text
Sistema de Missão
       ↓
Estado
       ↓
Interface
```

e não:

```text
Interface
   ↓
Estado do jogo
```

---

# 48. Fluxo completo da interface

A experiência da primeira entrega deverá funcionar aproximadamente assim:

```text
MENU
 │
 ├── INICIAR
 │      ↓
 │   EXPLORAÇÃO
 │      │
 │      ├── INTERAÇÃO
 │      │      ↓
 │      │   DIÁLOGO
 │      │      ↓
 │      │   ESCOLHA
 │      │      ↓
 │      │   EVENTO
 │      │
 │      └── COMBATE
 │             ↓
 │         DECISÃO
 │             ↓
 │         EXECUÇÃO
 │             ↓
 │         RESULTADO
 │             ↓
 │         EVENTO
 │
 ├── CARREGAR
 │      ↓
 │   RESTAURAR ESTADO
 │
 └── SAIR
```

---

# 49. Requisitos de usabilidade

A primeira versão deve priorizar clareza.

O jogador precisa saber:

- qual personagem está controlando;
- quando pode agir;
- quando está em diálogo;
- quando precisa escolher;
- qual personagem está selecionando no combate;
- qual ação está escolhendo;
- quem é o alvo;
- quando a batalha terminou.

Não é necessário adicionar elementos visuais apenas para tornar a interface mais sofisticada.

---

# 50. Teclado e mouse

O teclado será o mecanismo principal de controle.

Os controles são:

| Ação | Controle |
|---|---|
| Movimento | WASD / Setas |
| Interagir | E |
| Correr | SHIFT |
| Avançar diálogo | SPACE |
| Pausar | ESC |
| Confirmar | E |
| Voltar | R |

O mouse poderá ser utilizado:

- para clicar em opções de menu;
- para selecionar opções de interface;
- para confirmar escolhas.

O mouse não é obrigatório para movimentação do personagem.

---

# 51. Consistência dos controles

A mesma ação deve possuir comportamento consistente.

Por exemplo:

**E** significa confirmação/interação.

Portanto:

- no mundo → interagir;
- no menu → confirmar;
- em uma escolha → confirmar;
- no combate → confirmar seleção.

Isso reduz a quantidade de controles que o jogador precisa memorizar.

---

# 52. Estados que bloqueiam movimentação

A movimentação do personagem fica indisponível durante:

- diálogo;
- escolha;
- execução de combate;
- eventos automáticos;
- telas de menu.

A movimentação retorna quando o jogo volta ao estado de exploração.

---

# 53. Estados que permitem movimentação

A movimentação fica disponível durante:

- exploração normal;
- deslocamento até objetivos;
- procura pela pista;
- deslocamento entre bar e caverna.

---

# 54. Critério de conclusão

A interface e a persistência serão consideradas suficientes quando o jogador conseguir:

- iniciar uma nova partida;
- controlar o personagem;
- interagir;
- conversar;
- escolher;
- combater;
- controlar aliados;
- observar resultados;
- pausar;
- salvar;
- sair;
- carregar;
- continuar de um estado anterior.

---

# 55. Critério de qualidade

A interface da Vertical Slice não será avaliada principalmente pela beleza.

Ela deverá ser avaliada pela capacidade de responder:

> **"O jogador sabe o que pode fazer, o que está acontecendo e qual consequência sua ação produziu?"**

Se a resposta for sim, a interface cumpre seu objetivo.

---

# 56. Conclusão da documentação da Vertical Slice

Com este documento, a primeira documentação da Vertical Slice possui as seis áreas fundamentais:

```text
01 — Game Design
      ↓
O QUE estamos construindo

02 — Mapas e Cenários
      ↓
ONDE acontece

03 — Personagens
      ↓
QUEM participa

04 — Sistema de Combate
      ↓
COMO os combates funcionam

05 — Eventos, Diálogos e Missões
      ↓
QUANDO e POR QUE as coisas acontecem

06 — Interface e Persistência
      ↓
COMO o jogador interage e COMO o estado é preservado
```

Esses documentos formam a especificação funcional da primeira entrega.

A partir daqui, o próximo passo não deveria ser imediatamente começar a programar.

Antes da implementação, ainda existe uma etapa importante: **transformar essa especificação em uma estrutura técnica de desenvolvimento**, identificando os sistemas, componentes, dependências e ordem de implementação necessários para construir a Vertical Slice sem começar a codar de forma desorganizada.