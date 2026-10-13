# Eventos, Diálogos e Missões — Vertical Slice 01

**Projeto:** RPG 2D Top-Down  
**Versão:** 0.1  
**Escopo:** Primeira entrega jogável  
**Status:** Em definição

---

# 1. Objetivo do documento

Este documento define a estrutura narrativa executável da Vertical Slice 01.

Seu objetivo é transformar a história em um conjunto de:

- estados;
- eventos;
- gatilhos;
- condições;
- transições;
- diálogos;
- escolhas;
- consequências;
- combates;
- movimentações automáticas;
- mudanças no estado do mundo.

O documento deve permitir que a implementação seja realizada sem que a lógica narrativa precise ser inventada durante a programação.

---

# 2. Princípio da missão

A missão não deve ser tratada apenas como uma sequência fixa de diálogos.

Ela representa um **estado persistente do mundo**.

O jogador pode:

- aceitar ou recusar o pedido inicial;
- escolher uma rota;
- perder um combate;
- tentar novamente;
- continuar uma rota já escolhida;
- alterar a relação de determinados personagens com o protagonista.

Portanto, o jogo precisa saber não apenas **onde o jogador está**, mas também **o que já aconteceu**.

---

# 3. Missão principal

**Nome:** O Sequestro da Filha do Velho

A missão começa quando o jogador aceita ajudar o velho.

Antes disso, o encontro com o velho é apenas um evento disponível no mundo.

---

# 4. Estado da missão

O estado conceitual da missão será:

```text
NÃO INICIADA
     ↓
ACEITA
     ↓
CAVERNA
     ↓
ESCOLHA
   ┌─┴──────────┐
   ↓            ↓
RESGATE      ALIANÇA
   ↓            ↓
COMBATE      RETORNO
   ↓            ↓
GAROTA       EMBOSCADA
   ↓            ↓
CONCLUSÃO    PISTA
   └────┬───────┘
        ↓
PRIMEIRA PARTE CONCLUÍDA
```

A nomenclatura técnica exata dos estados poderá ser adaptada durante a implementação, mas a distinção conceitual deve permanecer.

---

# 5. Estados narrativos

A missão possui os seguintes estados conceituais:

### 5.1 Não iniciada

O jogador ainda não aceitou ajudar o velho.

### 5.2 Missão aceita

O jogador aceitou ajudar.

A caverna passa a ser o destino narrativo.

### 5.3 Encontro na caverna

Zoro chegou à caverna e encontrou os piratas.

### 5.4 Rota de resgate

O jogador decidiu enfrentar os piratas.

### 5.5 Resgate concluído

Os piratas foram derrotados e a garota foi libertada.

### 5.6 Rota de aliança

O jogador decidiu colaborar com os piratas.

### 5.7 Retorno ao bar

Zoro, Johnny e Yosaku retornaram ao bar.

### 5.8 Emboscada

O velho revela sua intenção e inicia o combate.

### 5.9 Pista encontrada

A gangue foi derrotada e o papel relacionado ao tesouro foi encontrado.

### 5.10 Primeira parte concluída

A primeira parte da história terminou.

---

# 6. Evento 01 — Conversa com o velho

## Local

Bar.

## Gatilho

O jogador controla Zoro, aproxima-se do velho e pressiona **E**.

## Pré-condição

O evento ainda não foi concluído ou a missão ainda não iniciou uma etapa incompatível com ele.

## Comportamento

O controle do jogador é bloqueado.

Zoro e o velho permanecem no local.

O velho se orienta para Zoro.

O diálogo começa.

---

# 7. Diálogo — Evento 01

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

Ao final do diálogo, o jogo apresenta a escolha:

```text
Você irá atrás dos bandidos?

[ SIM ]
[ NÃO ]
```

---

# 8. Escolha — Não

Caso o jogador escolha não ajudar:

**Zoro:**

> "Quem sabe uma hora minha lâmina decida brincar com esses bandidos, por ora terá de aguardar ai, velho"

O evento termina.

O controle retorna ao jogador.

A missão permanece não iniciada.

Nenhuma alteração relevante de estado é realizada.

---

# 9. Escolha — Sim

Caso o jogador aceite:

**Zoro:**

> "Vou dar uma volta, quem sabe não encontre alguns bandidos para testar minha lâmina nova. Me aponte onde posso achar algumas cobaias, velho"

**Velho:**

> "Em uma caverna a nordeste daqui, encrustada em uma montanha, e logo após um pequeno lago... não sei como lhe pagar meu jovem..."

**Zoro:**

> "Você saberá..."

O estado da missão muda para:

**MISSÃO ACEITA**

A caverna passa a ser o próximo objetivo narrativo.

O controle retorna ao jogador.

---

# 10. Evento 02 — Entrada na caverna

## Local

Caverna dos Piratas.

## Gatilho

Zoro entra na caverna enquanto a missão está no estado correspondente.

## Comportamento

O controle do jogador é bloqueado.

O jogo executa uma movimentação automática.

Zoro caminha até a posição determinada para o início da cena.

Ao chegar:

- Zoro para;
- os personagens se posicionam;
- os personagens se orientam;
- começa o diálogo.

---

# 11. Diálogo — Encontro com os piratas

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

Depois do diálogo, o jogador recebe a escolha principal da missão.

---

# 12. Escolha principal

```text
O que Zoro fará?

[ RESGATAR A GAROTA ]
[ ALIAR-SE AOS PIRATAS ]
```

Essa escolha define a rota da missão.

Depois dessa escolha, o jogo não deve apresentar novamente a decisão.

A rota escolhida fica persistida no estado da missão.

---

# 13. Regra de permanência da rota

Depois que a escolha é realizada:

```text
RESGATE
```

ou:

```text
ALIANÇA
```

torna-se uma propriedade do progresso da missão.

Uma derrota em combate não permite escolher novamente.

Exemplo:

```text
Escolheu RESGATE
       ↓
Perdeu
       ↓
Retorna
       ↓
Continua na rota RESGATE
```

Isso evita que o jogador altere a história simplesmente perdendo um combate.

---

# 14. Rota A — Resgate

Ao escolher resgatar a garota, inicia-se o diálogo.

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

O diálogo termina.

O sistema inicia o combate.

---

# 15. Combate — Rota de resgate

Participantes:

```text
Zoro
    VS
Líder dos Piratas
Johnny
Yosaku
Pirata A
Pirata B
```

O resultado do combate será devolvido ao sistema narrativo.

---

# 16. Derrota — Rota de resgate

Se Zoro for derrotado:

- o combate termina;
- a rota continua sendo RESGATE;
- o jogador retorna ao estado definido para uma nova tentativa.

Na nova tentativa, não é apresentada novamente a escolha entre resgate e aliança.

Ao reencontrar os piratas:

**Chefe dos Piratas:**

> "Olha quem voltou...."

**Yosaku:**

> "Não cansou de apanhar? Vamos tirar mais do que seu dinheiro dessa vez, seu pirata de merda"

**Zoro:**

> "Me distrai da outra vez.... agora a luta é séria..."

O combate é iniciado novamente.

---

# 17. Vitória — Rota de resgate

Após a vitória:

**Zoro:**

> "Não deram nem para o cheiro... bando fracote que acha que pode fazer o que quer..."

**Girl:**

> "Brigada... eu acho... mas, você estava falando sério sobre... ca-sar....?"

**Zoro:**

> "Não se ache você também garota.... seu velho está te esperando... anda logo..."

**Girl:**

> "Ele te prometeu alguma coisa?"

**Zoro:**

> "Disse que tinha uma recompensa, mas não ligo pra essas coisas.... foi um bom exercício esse, pra mim me basta"

A garota então revela a verdadeira situação.

---

# 18. Revelação do velho

**Girl:**

> "Não acredite em nada do que ele fala... ele é um covarde... também quer saber a localização do tesouro e só por isso deve ter mandado você aqui... ele é cheio de capangas, mas deve ter tido medo de perder eles pra vir me resgatar"

Esse diálogo altera o conhecimento do protagonista.

Zoro passa a saber que o velho também possui interesse no tesouro.

---

# 19. Revelação do tesouro

**Zoro:**

> "Então essa é a situação.... e o que você irá fazer garota?"

**Girl:**

> "Eu voltarei pra lá, minha mãe e minha irmã precisam de mim... eu nunca falei do tesouro pra ele por que sei que vai ser muito ruim pra Vila se ele conseguir..."

**Zoro:**

> "O que é esse tesouro?"

**Girl:**

> "Uma fruta... que da poderes a quem come-la.... não sei que tipo de poderes, mas a pessoa que me contou disse pode ser qualquer coisa"

**Zoro:**

> "E quem é essa pessoa?"

**Girl:**

> "Não conheço, nunca tinha visto ele nas redondezas antes... deve ser de fora que nem você..."

A identidade dessa pessoa permanece desconhecida.

Esse personagem não é apresentado na Vertical Slice.

---

# 20. Informação sobre a localização

A garota continua:

> "de qualquer forma, já sei o que vou fazer.... você merece uma recompensa de verdade, meu pai provavelmente só iria te roubar se você voltasse lá comigo... o tesouro fica no Sul da vila, perto da praia tem uns rochedos, vai estar em um lago que se formou por ali, você terá de atravessar a nado..."

A informação sobre a localização é registrada narrativamente.

A implementação completa da área do tesouro não pertence à Vertical Slice 01.

---

# 21. Relação entre a fruta e a pessoa desconhecida

A história estabelece:

```text
Pessoa desconhecida
        ↓
Revelou existência da fruta
        ↓
Garota conhece o tesouro
        ↓
Garota protege a informação
```

A identidade e as motivações dessa pessoa permanecem em aberto.

Não deve ser criada uma resolução artificial para esse mistério nesta versão.

---

# 22. Final da rota de resgate

A garota decide retornar sozinha.

**Zoro:**

> "É o que vou fazer. Te levarei pelo menos até perto da Vila..."

**Girl:**

> "Não falei hahahaha ainda está se preocupando comigo. Não precisa, esses piratas só me pegaram por que eu estava protegendo minha irmã... eu sei me defender"

**Zoro:**

> "Se é o que diz... vê se fica mais forte então, quem sabe você não possa me distrair no futuro..."

**Girl:**

> "O que??? Como assim??? Eu... você.... ahh, você quer dizer lutar.... é, quem sabe..."

A garota deixa o local.

O controle retorna ao jogador.

A rota de resgate é concluída para fins da primeira parte.

---

# 23. Rota B — Aliança

Ao escolher aliar-se aos piratas, inicia-se o diálogo:

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

---

# 24. Alteração de estado — Aliança

Ao término do diálogo:

```text
Johnny → Aliado
Yosaku → Aliado
```

Eles deixam de ser personagens inimigos e passam a fazer parte do grupo.

A missão muda para o estado:

**RETORNO AO BAR**

O controle volta ao jogador.

---

# 25. Evento 03 — Retorno ao bar

O jogador retorna ao bar controlando:

- Zoro;
- Johnny;
- Yosaku.

Ao entrar no bar, inicia-se automaticamente a próxima cena.

O controle é bloqueado.

O cenário é preparado para a emboscada.

Participam da cena:

- Zoro;
- Johnny;
- Yosaku;
- garota;
- velho;
- líder dos piratas;
- quatro membros da gangue.

---

# 26. Diálogo — Emboscada

**Zoro:**

> "Onde está você, velho? Trouxe a sua filha..."

**Girl:**

> "Papai, cuidado, eles estão atrás do tesouro..."

**Old man:**

> "Eu sei minha filha, vi os novos amigos dele... Você me traiu, e quer agora o tesouro pra você"

**Zoro:**

> "Então realmente você sabia que tinha um tesouro em jogo.... bem que desconfiei que aquele velho estava escondendo alguma coisa"

**Old man:**

> "Quem disse que não quero o bem da minha filha?"

**Zoro:**

> "Tente pegar algum idiota da próxima vez... estou vendo que estamos cercados por sua gangue... você iria me cercar e me roubar assim que eu trouxesse ela, não é?"

**Old man:**

> "Você irá se arrepender. Homens, ataquem!"

O velho e a garota deixam a cena.

O combate começa.

---

# 27. Combate — Emboscada

Participantes:

```text
Zoro
Johnny
Yosaku

      VS

Gangue 1
Gangue 2
Gangue 3
Gangue 4
```

O jogador controla os três personagens.

A IA controla os quatro membros da gangue.

---

# 28. Derrota — Emboscada

Caso o grupo seja derrotado, o sistema deverá aplicar a consequência definida para derrota.

A missão permanece na rota de aliança.

A decisão de aliança não pode ser revertida.

A implementação da recuperação deverá garantir que o jogador não seja colocado em um estado narrativo impossível.

---

# 29. Vitória — Emboscada

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

> "Até parece que eu precisava da sua ajuda"

**Pirate leader:**

> "Vamos parar com isso! Precisamos encontra-los"

O líder então determina:

> "Revistem tudo, talvez haja alguma pista por ai"

O controle retorna ao jogador.

---

# 30. Estado após a emboscada

O bar volta a ser explorável.

Os personagens permanecem no cenário.

O jogador precisa encontrar o papel relacionado ao tesouro.

O papel está localizado no ponto em que a garota estava anteriormente.

Não existe marcador indicando sua posição.

---

# 31. Evento 04 — Descoberta da pista

## Gatilho

Zoro aproxima-se do papel e pressiona **E**.

O evento é iniciado.

---

# 32. Diálogo — Pista

**Zoro:**

> "Encontrei algo aqui... um mapa?"

**Yosaku:**

> "Deixa eu ver... sim, é um mapa... conheço essa formação. Isso deve ser ao sul daqui... talvez seja onde fica o tesouro."

**Zoro:**

> "(Então ela já tinha esse mapa... por que estava carregando algo assim consigo?)"

O diálogo estabelece que o mapa já existia antes do confronto.

O mapa não foi criado naquele momento.

---

# 33. Origem da pista

A pista estava em posse da garota.

Ela possuía uma representação rudimentar da região relacionada ao tesouro.

Essa informação está ligada à pessoa desconhecida que anteriormente revelou a existência da fruta.

Durante a fuga no bar, o papel ficou para trás.

A garota não o deixou deliberadamente para Zoro.

Essa regra é importante para manter a coerência narrativa.

---

# 34. O que o mapa revela

O mapa não revela uma coordenada precisa.

Ele contém uma representação de uma formação geográfica.

Yosaku reconhece a formação e conclui que ela provavelmente corresponde a uma região ao sul.

Portanto:

```text
Mapa encontrado
      ↓
Reconhecimento da formação
      ↓
Região provável ao sul
      ↓
Não existe localização exata
```

O jogador não recebe um marcador automático para o tesouro.

---

# 35. Continuação do evento

**Pirate leader:**

> "Vão vocês três, nós continuaremos explorando aqui... talvez tenha mais alguma coisa de valor"

**Zoro:**

> "Vamos logo, não quero perder mais tempo"

**Johnny:**

> "Digo o mesmo, não nos atrase"

O evento termina.

Zoro, Johnny e Yosaku deixam o bar.

---

# 36. Final da Vertical Slice

O estado da primeira parte passa para:

**PRIMEIRA PARTE CONCLUÍDA**

A história termina nesse ponto.

A busca física pelo tesouro não será implementada nesta Vertical Slice.

A próxima parte da história será responsável por desenvolver:

- exploração ao sul;
- localização do tesouro;
- região dos rochedos;
- lago;
- fruta;
- acontecimentos posteriores.

---

# 37. Máquina narrativa

A estrutura geral da missão pode ser representada por:

```text id="6d8f3s"
                    NÃO INICIADA
                         │
                    aceita missão
                         │
                         ▼
                       ACEITA
                         │
                   entra na caverna
                         │
                         ▼
                     ESCOLHA
                   ┌─────┴─────┐
                   │           │
                RESGATE      ALIANÇA
                   │           │
                   ▼           ▼
                COMBATE     RETORNO
                   │           │
              ┌────┴────┐      ▼
              │         │   EMBOSCADA
           derrota    vitória    │
              │         │        ▼
              │         │     COMBATE
              │         │        │
              │         │     vitória
              │         │        │
              │         │        ▼
              │         │      PISTA
              │         │        │
              │         └────────┤
              │                  │
              ▼                  ▼
          NOVA TENTATIVA    PRIMEIRA PARTE
              │              CONCLUÍDA
              │
              └──► combate novamente
```

---

# 38. Separação entre evento e estado

Os eventos representam acontecimentos.

Os estados representam a situação persistente da missão.

Por exemplo:

**Evento:**

> Zoro encontra a garota na caverna.

**Estado:**

> A missão está na rota de resgate.

Outro exemplo:

**Evento:**

> Zoro encontra o mapa.

**Estado:**

> A pista foi encontrada.

Essa separação é fundamental para salvar e carregar corretamente o jogo.

---

# 39. Eventos automáticos

Os seguintes eventos são automáticos depois de seu gatilho:

- entrada na caverna;
- aproximação inicial dos piratas;
- início do diálogo na caverna;
- retorno ao bar na rota de aliança;
- emboscada;
- início dos combates;
- diálogo após os combates.

O jogador controla a movimentação apenas nos momentos explicitamente definidos.

---

# 40. Eventos controlados pelo jogador

O jogador possui controle durante:

- exploração;
- deslocamento até a caverna;
- retorno ao bar;
- procura pela pista.

As interações com personagens e objetos são realizadas utilizando **E**.

---

# 41. Bloqueio de controle

Durante eventos automáticos:

```text
Controle do jogador
       ↓
      OFF
       ↓
Evento executado
       ↓
Evento concluído
       ↓
      ON
```

O sistema não deve devolver o controle no meio de uma sequência obrigatória.

---

# 42. Persistência dos eventos

O estado da missão deve ser salvo.

Isso significa que o jogo não deve depender de "lembrar" que determinado diálogo já aconteceu apenas durante a execução atual.

Exemplo:

```text
Salvar:
Rota = ALIANÇA
Johnny = ALIADO
Yosaku = ALIADO
Emboscada = CONCLUÍDA
Pista = ENCONTRADA
```

Ao carregar:

```text
Rota = ALIANÇA
Johnny = ALIADO
Yosaku = ALIADO
Emboscada = CONCLUÍDA
Pista = ENCONTRADA
```

O mundo deverá ser reconstruído de acordo com esse estado.

---

# 43. Idempotência dos eventos

Eventos que representam mudanças permanentes devem possuir proteção contra execução duplicada.

Por exemplo:

Se Johnny já foi adicionado ao grupo, o evento não deve adicioná-lo novamente.

Se a emboscada já foi concluída, ela não deve ser executada novamente simplesmente porque o jogador entrou no bar.

Se a pista já foi encontrada, o evento de descoberta não deve ser reiniciado.

---

# 44. Condições de eventos

Todo evento importante deverá possuir:

### Gatilho

O que faz o evento ser considerado.

### Pré-condição

O que precisa ser verdadeiro para o evento poder acontecer.

### Execução

O que acontece durante o evento.

### Consequência

Qual estado muda depois.

Conceitualmente:

```text id="8f7q2m"
EVENTO
 ├── Trigger
 ├── Preconditions
 ├── Actions
 └── Consequences
```

---

# 45. Exemplo

O encontro com o velho:

```text id="v3a6pp"
Trigger:
Zoro pressiona E próximo ao velho.

Precondition:
Missão não iniciada.

Actions:
Executar diálogo.

Consequence:
Nenhuma se jogador recusar.
Missão aceita se jogador aceitar.
```

O encontro na caverna:

```text id="2y5f6m"
Trigger:
Zoro entra na caverna.

Precondition:
Missão aceita.

Actions:
Movimentação automática.
Diálogo.
Escolha.

Consequence:
Definir rota.
```

---

# 46. Estados que não podem ocorrer

O sistema deve impedir combinações incoerentes.

Exemplos:

```text
Johnny = aliado
+
Missão = rota de resgate
```

não deve acontecer.

Da mesma forma:

```text
Pista encontrada
+
Emboscada ainda não ocorreu
```

não deve acontecer.

Essas restrições são importantes para garantir consistência do estado salvo.

---

# 47. Consequências da escolha

A escolha principal produz consequências concretas.

## Resgate

- Johnny permanece inimigo;
- Yosaku permanece inimigo;
- os piratas são derrotados;
- garota é libertada;
- informações sobre o tesouro são reveladas;
- primeira parte termina.

## Aliança

- Johnny torna-se aliado;
- Yosaku torna-se aliado;
- garota continua com os piratas;
- ocorre retorno ao bar;
- velho prepara emboscada;
- gangue é enfrentada;
- pista é encontrada;
- primeira parte termina.

---

# 48. Não utilização de sistemas externos

Os eventos da Vertical Slice não deverão depender de:

- inventário;
- dinheiro;
- lojas;
- itens;
- equipamentos;
- sistema de reputação;
- quests secundárias;
- mapa completo;
- sistemas de relacionamento.

Toda consequência narrativa necessária deve ser representada pelo estado da missão e pelos personagens.

---

# 49. Critério de conclusão

O sistema de eventos e missões será considerado funcional quando for possível:

- iniciar a missão;
- recusá-la;
- aceitá-la;
- chegar à caverna;
- escolher uma rota;
- permanecer nessa rota;
- executar o combate correspondente;
- tratar derrota;
- continuar após vitória;
- alterar o papel de Johnny e Yosaku;
- executar a emboscada;
- encontrar a pista;
- encerrar a primeira parte;
- salvar e carregar qualquer um desses estados sem quebrar a narrativa.

---

# 50. Princípio final

O sistema narrativo deve tratar a história como **estado**, e não como uma sequência de telas.

O jogador não está simplesmente assistindo:

```text
Cena 1
→ Cena 2
→ Cena 3
```

Ele está alterando o estado do mundo:

```text
Escolha
   ↓
Estado
   ↓
Consequência
   ↓
Novo estado
   ↓
Próximo evento
```

Essa estrutura permitirá que o projeto cresça posteriormente para missões mais complexas sem transformar cada nova história em uma sequência rígida de scripts independentes.

---

# 51. Relação com o próximo documento

Os documentos anteriores definiram:

- **Documento 01:** o que é a Vertical Slice;
- **Documento 02:** onde ela acontece;
- **Documento 03:** quem participa;
- **Documento 04:** como os combates funcionam;
- **Documento 05:** como a história progride.

O próximo documento será o **Documento 06 — Interface e Persistência**.

Ele deverá especificar a camada que permite ao jogador visualizar e operar todos esses sistemas:

- menu inicial;
- HUD;
- diálogo;
- escolhas;
- combate;
- pausa;
- salvar;
- carregar;
- estado visual da missão;
- transição entre exploração e combate.