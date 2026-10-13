# Game Design — Vertical Slice 01

**Projeto:** RPG 2D Top-Down  
**Versão:** 0.1  
**Escopo:** Primeira entrega jogável  
**Status:** Em definição

---

## 1. Objetivo do documento

Este documento define a primeira entrega jogável do projeto, denominada **Vertical Slice 01**.

A Vertical Slice não tem como objetivo representar todo o jogo final. Seu propósito é validar, em uma pequena experiência completa, os principais fundamentos de gameplay, narrativa e arquitetura do projeto.

A primeira entrega deverá permitir que o jogador inicie o jogo, controle o protagonista, explore os cenários disponíveis, interaja com personagens, participe de diálogos e escolhas, entre em combate, utilize personagens aliados e avance uma missão narrativa com consequências diferentes de acordo com suas decisões.

A implementação deve ser deliberadamente pequena. Sistemas que não são necessários para proporcionar essa experiência não fazem parte desta entrega, mesmo que já estejam previstos para versões futuras.

---

# 2. Visão da primeira entrega

A primeira versão apresenta o protagonista em uma pequena região onde ele encontra um homem idoso desesperado porque sua filha foi sequestrada por piratas.

O jogador pode decidir se deseja ajudar o homem. Caso aceite, recebe a indicação da localização da caverna onde os piratas estão.

Ao chegar à caverna, o protagonista descobre que o sequestro está relacionado à localização de um tesouro. Nesse momento surge a principal decisão da Vertical Slice:

- enfrentar os piratas para resgatar a garota;
- ou se aliar aos piratas e participar do plano para capturar o pai da garota.

As duas escolhas conduzem a acontecimentos diferentes.

Na rota de resgate, o protagonista enfrenta os piratas, salva a garota e descobre informações sobre o verdadeiro interesse do pai e sobre um misterioso tesouro que consiste em uma fruta capaz de conceder poderes.

Na rota de aliança, o protagonista passa a atuar junto aos piratas, retornando à vila acompanhado de Johnny e Yosaku. O grupo é então surpreendido por uma emboscada preparada pelo pai da garota. Após o combate, surge uma pista relacionada ao tesouro.

A Vertical Slice termina nessa primeira parte da história, estabelecendo uma situação que poderá ser continuada posteriormente.

---

# 3. Experiência desejada

A pergunta central da Vertical Slice é:

> **"Como é jogar os primeiros minutos deste jogo?"**

A resposta esperada é:

O jogador controla o protagonista em uma perspectiva 2D top-down, desloca-se pelo cenário, entra em um estabelecimento, conversa com um personagem, recebe uma missão, desloca-se até outro local e encontra um grupo de inimigos.

Ao chegar ao local dos piratas, o jogador descobre que existe mais informação por trás da situação apresentada inicialmente. Em vez de simplesmente receber uma missão linear de combate, ele precisa tomar uma decisão.

A partir dessa decisão, o jogo apresenta uma consequência narrativa diferente.

Portanto, a experiência fundamental da primeira entrega é:

**Explorar → Interagir → Descobrir → Escolher → Combater → Observar a consequência da escolha.**

Essa sequência representa o núcleo que deverá ser validado antes da expansão do projeto.

---

# 4. Objetivos da Vertical Slice

A primeira entrega deve validar os seguintes elementos:

### 4.1 Controle do personagem

O jogador deve conseguir movimentar o protagonista livremente pelo cenário utilizando teclado.

### 4.2 Exploração

O jogador deve conseguir percorrer os cenários e encontrar os personagens e locais importantes sem depender de uma sequência rígida de telas.

### 4.3 Interação

O jogador deve conseguir iniciar interações com personagens e objetos utilizando uma ação de interação.

### 4.4 Diálogo

O jogo deve apresentar diálogos entre personagens utilizando uma interface própria de diálogo.

### 4.5 Escolhas

O jogador deve conseguir tomar decisões durante determinados diálogos.

Essas decisões devem alterar o fluxo da missão.

### 4.6 Missões

O jogo deve possuir um estado de missão que acompanhe o progresso do jogador.

### 4.7 Combate

O jogador deve conseguir participar de combates utilizando o sistema de decisões simultâneas definido para o projeto.

### 4.8 Grupo

O jogador deve poder controlar mais de um personagem quando a narrativa determinar que aliados se juntaram ao grupo.

### 4.9 Consequências

As decisões tomadas pelo jogador devem alterar acontecimentos posteriores.

### 4.10 Persistência

O jogador deve conseguir salvar e carregar o estado do jogo.

---

# 5. Escopo funcional

A Vertical Slice será composta pelos seguintes sistemas.

## 5.1 Controle

O protagonista poderá:

- andar;
- correr;
- interagir;
- avançar diálogos;
- pausar o jogo.

Os controles definidos são:

| Ação | Controle |
|---|---|
| Movimento | WASD / Setas |
| Interagir | E |
| Correr | SHIFT |
| Avançar diálogo | SPACE |
| Pausar | ESC |

Menus poderão ser navegados pelo teclado ou mouse.

| Ação | Controle |
|---|---|
| Navegação | WASD / Setas |
| Confirmar | E / Clique |
| Voltar | R |

---

# 6. Estrutura da primeira entrega

A Vertical Slice será composta por um pequeno conjunto de cenários.

O escopo visual inicial deverá permanecer reduzido, contendo apenas os locais necessários para executar a primeira parte da história.

Os dois locais principais são:

1. **Bar**
2. **Caverna dos Piratas**

Não deverão ser criados outros locais apenas para preencher o mapa.

Elementos de cenário que não possuem função na Vertical Slice poderão ser utilizados apenas como elementos visuais, desde que não criem sistemas adicionais desnecessários.

---

# 7. Fluxo principal

O fluxo geral da Vertical Slice é:

```text
INÍCIO
  │
  ▼
CONTROLE DO PROTAGONISTA
  │
  ▼
ENTRADA NO BAR
  │
  ▼
CONVERSA COM O VELHO
  │
  ├───────────────┐
  │               │
  ▼               ▼
  NÃO             SIM
  │               │
  │               ▼
  │        MISSÃO INICIADA
  │               │
  │               ▼
  │       CAVERNA DOS PIRATAS
  │               │
  │               ▼
  │        CONVERSA COM PIRATAS
  │               │
  │        ┌──────┴──────┐
  │        │             │
  │        ▼             ▼
  │      RESGATE      ALIANÇA
  │        │             │
  │        ▼             ▼
  │      COMBATE       JOHNNY +
  │        │           YOSAKU
  │        ▼             │
  │      RESGATE         ▼
  │        │            BAR
  │        │             │
  │        │             ▼
  │        │           EMBOSCADA
  │        │             │
  │        │             ▼
  │        │           COMBATE
  │        │             │
  │        │             ▼
  │        │          ENCONTRA PISTA
  │        │
  │        ▼
  │   INFORMAÇÕES SOBRE
  │     O TESOURO
  │
  ▼
 FIM DA PRIMEIRA PARTE
```

A recusa inicial em ajudar não encerra o jogo. O jogador simplesmente retorna ao controle normal, sem iniciar a missão naquele momento.

---

# 8. Evento inicial — O pedido de ajuda

O jogador entra no bar e encontra o velho.

Ao aproximar-se dele e pressionar **E**, o controle passa temporariamente para o sistema de eventos.

O protagonista e o velho permanecem parados enquanto o diálogo acontece.

### Diálogo

**Velho:**

> "Sniff.... Sniff.... Não sei o que fazer agora, minha pequena foi levada por aqueles fdp."

**Zoro:**

> "Não cai bem para alguém da sua idade estar chorando assim..."

**Velho:**

> "Você diz isso por que não deve ter filhos, não há tristeza maior... você parece um jovem forte, me ajude a resgata-la."

**Zoro:**

> "Se é algo importante pra você não deveria deixar nas mãos de um estranho, nem que levassem seus braços e pernas você deveria toma-la de volta custe o que custar"

**Velho:**

> "Pedir ajuda a um estranho como você é a prova do meu desespero... acha que não tentei resgata-la? Acha que eu deixaria minha menina ir sem fazer nada? Tomei uma surra deles, e só estou vivo por que querem me ver humilhado... meu corpo não tem mais nenhuma força.... sozinho não consigo fazer mais nada...."

Depois do diálogo, o jogador deverá escolher se deseja ir atrás dos bandidos.

---

# 9. Decisão inicial

## 9.1 Jogador aceita

**Zoro:**

> "Vou dar uma volta, quem sabe não encontre alguns bandidos para testar minha lâmina nova. Me aponte onde posso achar algumas cobaias, velho"

**Velho:**

> "Em uma caverna a nordeste daqui, encrustada em uma montanha, e logo após um pequeno lago... não sei como lhe pagar meu jovem..."

**Zoro:**

> "Você saberá..."

A missão é iniciada.

O jogo passa a reconhecer a caverna como o próximo objetivo narrativo.

O controle retorna ao jogador.

---

## 9.2 Jogador recusa

**Zoro:**

> "Quem sabe uma hora minha lâmina decida brincar com esses bandidos, por ora terá de aguardar ai, velho"

O controle retorna ao jogador.

A missão não é iniciada.

---

# 10. Entrada na Caverna dos Piratas

Quando o jogador entra na caverna, o controle passa novamente ao sistema de eventos.

O protagonista é movimentado automaticamente até a posição definida para a cena.

No local estão:

- líder dos piratas;
- Johnny;
- Yosaku;
- dois outros piratas;
- garota sequestrada.

O cenário deverá representar um pequeno acampamento pirata.

Podem existir visualmente:

- tendas;
- bancos;
- barris;
- objetos roubados;
- outros elementos decorativos.

Esses elementos não possuem sistemas próprios na Vertical Slice.

Após o protagonista chegar à posição determinada, inicia-se o diálogo.

---

# 11. Descoberta sobre o sequestro

**Menina:**

> "Socorro, por favor me ajuda..."

**Johnny:**

> "Cala a boca, menina... ou teremos que cortar sua lingua?"

**Yosaku:**

> "Sem língua ai que não conseguiremos a localização do tesouro com ela, seu idiota..."

**Johnny:**

> "Quem é idiota aqui? Quer morrer?"

**Líder dos Piratas:**

> "Calem a boca! Querem que nosso convidado aqui pense que somos mal educados? Diga forasteiro, o que quer?"

Pensamento de Zoro:

> "(Então não é um simples sequestro, a garota sabe a localização de um tesouro... bem que achei que aquele velho estava escondendo alguma coisa)"

Nesse momento, o jogador precisa tomar uma decisão.

---

# 12. Escolha principal da Vertical Slice

O jogador terá duas opções:

### Opção A — Resgatar a garota

O protagonista se coloca contra os piratas.

Isso inicia imediatamente um combate.

### Opção B — Aliar-se aos piratas

O protagonista passa a colaborar com os piratas.

Essa escolha altera completamente o fluxo seguinte da missão.

Essa decisão é o principal mecanismo de ramificação narrativa da Vertical Slice.

---

# 13. Rota de resgate

O diálogo da escolha é:

**Zoro:**

> "Por acaso achei essa menina bonitinha e quero me casar com ela... tenho de leva-la ao pai para pedi-la em casamento"

**Menina:**

> "Eu não... como assim?.... O que quer dizer com....."

**Chefe dos Piratas:**

> "Achei que diria algo mais interessante, mas é só um perdido sem graça.... Saia daqui logo antes que vire um cadáver"

**Zoro:**

> "Realmente não acho que vá demorar muito para eu sair, mas terá cinco cadaveres antes disso acontecer"

**Chefe dos Piratas:**

> "Cansei de você, homens, matem ele!"

O jogo inicia um combate contra os cinco piratas.

---

# 14. Resultado do combate — resgate

Caso o protagonista vença:

**Zoro:**

> "Não deram nem para o cheiro... bando fracote que acha que pode fazer o que quer..."

**Girl:**

> "Brigada... eu acho... mas, você estava falando sério sobre... ca-sar....?"

**Zoro:**

> "Não se ache você também garota.... seu velho está te esperando... anda logo..."

A garota então questiona Zoro sobre a recompensa prometida pelo pai.

O diálogo revela progressivamente que:

1. o pai conhece a existência do tesouro;
2. o pai não estava interessado apenas no resgate da filha;
3. o pai pretendia utilizar Zoro para recuperar o tesouro;
4. a garota desconfia das intenções do pai;
5. a garota conhece a localização do tesouro;
6. o tesouro é uma fruta capaz de conceder poderes;
7. ela não sabe qual poder a fruta concede;
8. a informação originalmente veio de uma pessoa desconhecida;
9. essa pessoa aparentemente não pertence à região.

A garota decide retornar para a vila por conta própria.

A sequência termina com a garota deixando a caverna.

O jogo então devolve o controle ao jogador.

---

# 15. Rota de aliança

Caso o jogador decida se aliar aos piratas, o diálogo será:

**Zoro:**

> "Pelo jeito vocês estão tendo problemas pra tirar uma simples informação dessa menina, tenho uma idéia que pode economizar o tempo de vocês"

**Chefe dos Piratas:**

> "E quem disse que precisamos de sua ajuda? Ou melhor, podemos ter melhor sorte em tirar informação de você do que dela"

**Zoro:**

> "Hahahahaha, minhas espadas adorariam que você tentasse uma burrice dessas... mas sei que não fará isso e que vai me ouvir"

**Chefe dos Piratas:**

> "Diga logo"

**Zoro:**

> "Essa menina tem um pai bem velho e frágil lá na vila, com ele de refém também, tenho certeza que ela abre o bico"

**Chefe dos Piratas:**

> "Sabemos dele, mas não temos força para ir contra todo o pessoal da vila e eles estão mais atentos depois que pegamos a menina"

**Zoro:**

> "Não tinham... sua força acabou de dobrar comigo"

**Yosaku:**

> "Acha mesmo que é mais forte que todos nós juntos, haahahah, não se ache novato, ou vai perder mais do que as espadas"

**Zoro:**

> "Se eu acabar com esse daqui, temos um trato?"

**Chefe dos Piratas:**

> "Parem os dois, não quero perder aliados hoje.... se quer colaborar mesmo, então aceito, mas saiba que a divisão aqui é igual para todos, se tentar nos trair você não sai com vida"

**Zoro:**

> "Então façam valer a pena minha lealdade..."

**Chefe dos Piratas:**

> "Johnny, Yosaku... acompanhem ele até aquele bar, tenho certeza que o pai dela estará lá enchendo a cara.... nós iremos escondidos, para não chamar muito a atenção"

**Zoro:**

> "Veja se não me atrasam...."

Ao final do diálogo:

- Johnny entra para o grupo;
- Yosaku entra para o grupo;
- ambos deixam de ser NPCs da cena;
- ambos passam a ser personagens controláveis;
- o próximo destino narrativo é o bar;
- o controle retorna ao jogador.

---

# 16. Retorno ao bar — rota de aliança

Ao chegar ao bar, o controle passa novamente para o sistema de eventos.

Os piratas e a garota também aparecem na cena.

O velho está acompanhado por quatro membros de sua gangue.

O diálogo é:

**Zoro:**

> "Onde está você, velho? Trouxe a sua filha..."

**Girl:**

> "Papai, cuidado, eles estão atrás do tesouro..."

**Old man:**

> "Eu sei minha filha, vi os novos amigos dele... Você me traiu, e quer agora o tesouro pra você"

**Zoro:**

> "Então realmente você sabia que tinha um tesouro em jogo.... bem que desconfiei que você não tava lamentando pela menina, e sim pelo que ela sabia"

**Old man:**

> "Quem disse que não quero o bem da minha filha?"

**Zoro:**

> "Tente pegar algum idiota da próxima vez... estou vendo que estamos cercados por sua gangue... você iria me cercar e me roubar assim que eu trouxesse ela, não é?"

**Old man:**

> "Você irá se arrepender. Homens, ataquem!"

O velho e a garota deixam a cena.

Inicia-se o combate.

---

# 17. Combate da emboscada

O grupo do jogador é:

- Zoro;
- Johnny;
- Yosaku.

Os inimigos são:

- quatro membros da gangue do velho.

O combate utiliza o mesmo sistema geral definido para a Vertical Slice.

Após a vitória:

**Zoro:**

> "Tsc... os dois fugiram..."

**Pirate leader:**

> "Você os deixou escapar"

**Zoro:**

> "Eu estava ocupado cuidando dos bandidos, enquanto você e seus lacaios estavam sofrendo"

**Yosaku:**

> "Eu te salvei pelo menos umas duas vezes"

**Zoro:**

> "Até parece que eu precisava de sua ajuda"

**Pirate leader:**

> "Vamos parar com isso! Precisamos encontra-los"

O líder então ordena:

> "Revistem tudo, talvez haja alguma pista por ai"

O controle retorna ao jogador.

---

# 18. Descoberta da pista

A pista está localizada no bar, no ponto onde a garota estava anteriormente.

O jogador precisa se aproximar e pressionar **E**.

O jogo apresenta:

**Zoro:**

> "Encontrei algo aqui... um mapa?"

**Yosaku:**

> "Deixa eu ver... sim, é um mapa... acho que é a sul daqui... talvez eles tenham fugido pra lá, ou lá que tenha o tesouro"

Pensamento de Zoro:

> "(Mas por que ela iria rabiscar um mapa agora, sabendo que todo mundo está atrás disso?)"

**Pirate leader:**

> "Vão vocês três, nós continuaremos explorando aqui... talvez tenha mais alguma coisa de valor"

**Zoro:**

> "Vamos logo, não quero perder mais tempo"

**Johnny:**

> "Digo o mesmo, não nos atrase"

Ao final da cena:

- Zoro;
- Johnny;
- Yosaku

deixam o bar.

A primeira parte da história termina nesse ponto da Vertical Slice.

O mapa encontrado **não deve gerar automaticamente uma marca exata no mapa do jogo**.

Ele funciona como uma pista narrativa que indica uma possível direção para o sul.

A continuação dessa busca pertence a uma etapa posterior do projeto.

---

# 19. Sistema de diálogo

O diálogo deverá utilizar uma caixa localizada na parte inferior da tela.

Cada diálogo deverá apresentar:

- nome do personagem;
- retrato do personagem;
- texto;
- indicação visual do avanço, quando necessário.

O narrador ou pensamentos do protagonista não precisam utilizar retrato de personagem.

A interação com o texto segue:

1. pressionar **SPACE** para concluir o texto atualmente exibido;
2. pressionar **SPACE** novamente para avançar para o próximo diálogo.

Durante eventos narrativos automáticos, o controle do personagem fica temporariamente bloqueado.

Após o término do evento, o controle é devolvido ao jogador.

---

# 20. Sistema de escolhas

As escolhas são apresentadas durante o diálogo.

A Vertical Slice possui duas decisões principais:

### Decisão 1

Aceitar ou não ajudar o velho.

### Decisão 2

Na caverna, escolher entre:

- resgatar a garota;
- aliar-se aos piratas.

A segunda decisão é a mais importante.

Ela altera:

- o combate realizado;
- os personagens que acompanham o protagonista;
- os eventos seguintes;
- as informações descobertas;
- a relação do protagonista com os piratas;
- a sequência narrativa posterior.

As escolhas não devem produzir um estado impossível de continuar.

---

# 21. Sistema de combate

O combate seguirá o modelo de duas fases.

## Fase 1 — Decisão

O jogador escolhe as ações de seus personagens.

Ao mesmo tempo, a inteligência dos inimigos determina suas ações.

As ações ainda não são executadas imediatamente.

## Fase 2 — Execução

Depois que todas as decisões foram definidas, as ações são executadas em uma ordem determinada pelos atributos dos personagens.

O resultado de cada ação é apresentado ao jogador.

Nesta primeira entrega, **não serão implementadas animações de ataque**.

Em vez disso, o jogo apresentará informações textuais sobre o resultado.

Exemplo:

```text
Zoro atacou Pirata 2
Dano: 18
```

O objetivo é validar a lógica do sistema de combate antes de investir na apresentação visual das ações.

---

# 22. Ações de combate da Vertical Slice

O conjunto mínimo de ações será:

- Ataque;
- Defesa;
- Fuga.

Não haverá sistema de itens durante o combate.

O menu deverá ser reduzido ao necessário para essas ações.

---

# 23. Cálculo do combate

Apesar da apresentação simplificada, o combate deverá possuir cálculos reais.

O sistema deverá considerar os atributos definidos para os personagens.

Entre os fatores previstos estão:

- HP;
- força;
- defesa;
- velocidade;
- sorte;
- chance de acerto;
- chance de esquiva;
- dano.

A velocidade deverá influenciar a ordem de execução das ações.

A sorte poderá influenciar os resultados probabilísticos do combate.

As fórmulas exatas e os valores numéricos dos atributos serão especificados no documento específico de combate.

Este documento define apenas o papel do combate dentro da Vertical Slice.

---

# 24. Derrota

A derrota em combate não deverá representar o encerramento definitivo da partida.

O comportamento geral previsto para o projeto é que o personagem retorne a um local de descanso.

Entretanto, como a Vertical Slice não possui ainda:

- sistema de dinheiro;
- inventário;
- economia;
- progressão completa;

esses efeitos deverão ser reduzidos ao mínimo necessário para a primeira entrega.

A implementação definitiva das consequências da derrota será especificada no documento do sistema de combate.

---

# 25. Personagens controláveis

A Vertical Slice inicia com apenas o protagonista.

Na rota de aliança, dois personagens entram para o grupo:

- Johnny;
- Yosaku.

Eles deixam de ser apenas personagens narrativos e passam a participar diretamente do sistema de combate.

O sistema deverá ser construído de maneira que a entrada de novos personagens não exija alterações estruturais no funcionamento básico do combate.

---

# 26. Progressão

A progressão completa do personagem está prevista para versões posteriores.

O projeto possui conceitos definidos para:

- XP;
- níveis;
- atributos;
- recompensas;
- aumento de atributos;
- escolha de atributo para bônus.

Porém, a Vertical Slice não deve implementar sistemas que não sejam necessários para validar sua experiência principal.

O sistema de progressão poderá existir apenas na medida necessária para que os cálculos de combate funcionem.

A implementação completa será especificada posteriormente.

---

# 27. Sistemas deliberadamente fora do escopo

Para manter a primeira entrega pequena e controlável, os seguintes sistemas **não fazem parte da Vertical Slice 01**:

- inventário;
- equipamentos;
- itens consumíveis;
- lojas;
- dinheiro;
- sistema econômico;
- baús;
- frutas como item funcional;
- poderes de Akuma no Mi;
- Haki;
- Rokushiki;
- barcos;
- natação;
- NPCs genéricos;
- missões secundárias;
- sistema completo de mapa;
- música;
- efeitos sonoros;
- configurações;
- animações de ataques;
- efeitos visuais complexos;
- sistema completo de progressão;
- sistema completo de recompensas;
- múltiplas ilhas;
- mundo aberto completo.

Esses elementos podem existir no planejamento futuro, mas não devem ser introduzidos na primeira implementação sem uma necessidade clara.

---

# 28. Menu inicial

O menu inicial deverá possuir somente:

```text
INICIAR
SALVAR
CARREGAR
SAIR
```

Durante o jogo, o menu de pausa poderá oferecer as operações necessárias de persistência.

Não haverá tela de configurações na Vertical Slice.

Não haverá música ou efeitos sonoros.

---

# 29. Persistência

O jogo deverá possuir um sistema básico de salvamento e carregamento.

O estado salvo deverá ser suficiente para que o jogador possa continuar a missão posteriormente.

Entre os dados que poderão fazer parte do estado estão:

- posição do jogador;
- cenário atual;
- estado da missão;
- decisões tomadas;
- personagens disponíveis;
- personagens integrantes do grupo;
- estado dos eventos;
- progresso da narrativa.

A estrutura definitiva do Save Game será especificada no documento de UI e Persistência.

---

# 30. Estado da missão

A missão precisa ser representada como um estado persistente do jogo.

O objetivo não é simplesmente verificar onde o jogador está fisicamente, mas saber **qual etapa narrativa já foi concluída**.

Exemplo conceitual:

```text
Missão não iniciada
        ↓
Pedido de ajuda aceito
        ↓
Caverna localizada
        ↓
Encontro com os piratas
        ↓
     ┌──┴──┐
     ↓     ↓
  Resgate Aliança
     ↓     ↓
 Resolução Resolução
     └──┬──┘
        ↓
Primeira parte concluída
```

Os nomes técnicos dos estados serão definidos no documento de Eventos e Missões.

---

# 31. Princípio de implementação

A Vertical Slice deverá priorizar **funcionalidade sobre apresentação**.

O jogador precisa conseguir:

- iniciar;
- movimentar-se;
- explorar;
- interagir;
- conversar;
- escolher;
- combater;
- vencer ou perder;
- seguir diferentes caminhos;
- salvar;
- carregar;
- chegar ao final da primeira parte.

A qualidade visual deverá ser suficiente para compreender a experiência, mas não deverá bloquear a validação dos sistemas.

Da mesma forma, elementos de apresentação que não contribuem para a experiência principal não devem receber prioridade nesta etapa.

---

# 32. Critério de conclusão

A Vertical Slice será considerada concluída quando for possível realizar uma experiência jogável completa contendo:

### Fluxo inicial

- iniciar o jogo;
- controlar o protagonista;
- entrar no bar;
- conversar com o velho;
- aceitar ou recusar a missão.

### Rota de resgate

- chegar à caverna;
- conversar com os piratas;
- escolher resgatar a garota;
- realizar o combate;
- vencer;
- conversar com a garota;
- descobrir as informações sobre o tesouro;
- encerrar a primeira parte.

### Rota de aliança

- chegar à caverna;
- conversar com os piratas;
- escolher aliar-se;
- adicionar Johnny e Yosaku ao grupo;
- retornar ao bar;
- executar a cena da emboscada;
- combater a gangue;
- vencer;
- encontrar a pista;
- descobrir a indicação de direção;
- encerrar a primeira parte.

### Persistência

- salvar o jogo;
- sair;
- carregar o jogo;
- continuar do estado salvo.

---

# 33. O que esta Vertical Slice deve provar

Ao final da primeira entrega, o projeto deverá ter respondido positivamente às seguintes perguntas:

**O movimento e a exploração são funcionais?**

**O jogador consegue interagir com o mundo sem depender de interfaces excessivas?**

**O sistema de diálogo suporta cenas narrativas e pensamentos?**

**As escolhas conseguem alterar o estado da missão?**

**O sistema de combate consegue representar diferentes grupos e personagens?**

**É possível adicionar aliados durante uma missão?**

**O estado da missão consegue persistir entre sessões?**

**Uma mesma missão consegue possuir caminhos narrativos diferentes?**

**A arquitetura do jogo permite continuar adicionando conteúdo sem reescrever os sistemas fundamentais?**

Se essas respostas forem positivas, a primeira entrega terá cumprido seu objetivo principal.

---

# 34. Relação com os próximos documentos

Este documento é a visão geral da Vertical Slice.

Os próximos documentos deverão detalhar partes específicas sem duplicar integralmente o conteúdo aqui apresentado.

A divisão inicial será:

**Documento 02 — Mapas e Cenários**

Detalhará:

- bar;
- caverna;
- limites dos cenários;
- câmera;
- colisões;
- posicionamento dos personagens;
- transições entre cenários;
- elementos visuais.

**Documento 03 — Personagens**

Detalhará:

- protagonista;
- Johnny;
- Yosaku;
- velho;
- garota;
- líder dos piratas;
- piratas;
- membros da gangue;
- atributos;
- comportamentos;
- participação narrativa.

**Documento 04 — Sistema de Combate**

Detalhará:

- atributos;
- ações;
- velocidade;
- ordem de execução;
- acerto;
- esquiva;
- dano;
- defesa;
- sorte;
- IA;
- vitória;
- derrota;
- experiência.

**Documento 05 — Eventos, Diálogos e Missões**

Detalhará:

- eventos;
- gatilhos;
- estados;
- transições;
- diálogos completos;
- escolhas;
- consequências;
- controle automático;
- retorno ao controle do jogador.

**Documento 06 — Interface e Persistência**

Detalhará:

- menu;
- HUD;
- diálogo;
- escolhas;
- combate;
- pausa;
- salvar;
- carregar;
- estrutura do estado persistido.

---

# 35. Princípio geral da Vertical Slice 01

A primeira entrega não deve tentar provar que o jogo inteiro pode ser construído.

Ela deve provar algo mais importante:

> **Que o núcleo do jogo funciona.**

O núcleo validado nesta etapa é:

**Exploração + narrativa + escolha + consequência + combate + persistência.**

Todo elemento que não contribui diretamente para essa validação deve permanecer fora da primeira entrega.