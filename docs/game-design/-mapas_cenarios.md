# Mapas e Cenários — Vertical Slice 01

**Projeto:** RPG 2D Top-Down  
**Versão:** 0.1  
**Escopo:** Primeira entrega jogável  
**Status:** Em definição

---

# 1. Objetivo do documento

Este documento define os cenários físicos utilizados pela Vertical Slice 01.

Seu objetivo é estabelecer:

- quais cenários existem;
- como o jogador acessa cada cenário;
- quais personagens podem aparecer em cada um;
- como a câmera funciona;
- quais elementos possuem colisão;
- quais elementos são apenas visuais;
- onde os eventos narrativos acontecem;
- como o jogador transita entre os cenários.

O documento não define o mapa completo do jogo.

A primeira entrega deve possuir somente os espaços necessários para executar a primeira parte da história.

---

# 2. Princípio de construção dos cenários

A Vertical Slice deve utilizar **poucos cenários, mas cenários suficientemente funcionais para representar a experiência de exploração**.

Não será criado um mapa grande apenas para transmitir a sensação de mundo aberto.

O espaço disponível deverá existir por uma razão:

> permitir que o jogador controle o personagem, explore, encontre o local necessário e participe dos eventos da missão.

Assim, a primeira versão será composta essencialmente por:

1. área externa mínima;
2. bar;
3. caverna dos piratas.

A área externa existe apenas como espaço de deslocamento entre os locais necessários.

---

# 3. Estrutura espacial

A estrutura geral será:

```text
                    ÁREA EXTERNA
                         │
              ┌──────────┴──────────┐
              │                     │
              ▼                     ▼
             BAR          ENTRADA DA CAVERNA
                                    │
                                    ▼
                           CAVERNA DOS PIRATAS
```

O jogador não deverá possuir acesso a outras regiões relevantes do mundo nesta versão.

Locais como:

- outras casas;
- florestas extensas;
- base da Marinha;
- outras ilhas;
- praias exploráveis;
- cavernas secundárias;
- áreas de tesouro;

ficam fora da Vertical Slice.

---

# 4. Área externa

A área externa funciona como o espaço de exploração e deslocamento entre os pontos narrativos.

Ela não precisa representar uma vila completa.

Seu propósito é fornecer ao jogador a sensação mínima de estar em um ambiente explorável.

## 4.1 Funções

A área externa deve permitir:

- movimentação livre;
- acesso ao bar;
- acesso à região da caverna;
- utilização do sistema de câmera;
- teste de colisões;
- teste de corrida;
- deslocamento entre eventos.

## 4.2 Elementos

Podem existir elementos visuais como:

- terreno;
- árvores;
- pedras;
- vegetação;
- relevo;
- água;
- estruturas simples.

Entretanto, esses elementos devem ser utilizados somente quando forem necessários para compor visualmente o espaço.

Não devem possuir sistemas próprios nesta versão.

Por exemplo, uma árvore pode bloquear a passagem, mas não precisa ser cortável ou destrutível.

---

# 5. Limites do mundo

O cenário possui limites físicos.

O jogador não pode sair da área definida para o mapa.

Quando a câmera estiver próxima dos limites do cenário, poderá existir uma área escura ou vazia além do limite físico do mundo.

O objetivo é deixar claro que o cenário termina naquele ponto.

O personagem nunca deve conseguir atravessar o limite.

---

# 6. Câmera

A câmera utiliza uma perspectiva:

**2D top-down com perspectiva.**

A câmera acompanha o personagem durante a exploração.

O protagonista deverá permanecer aproximadamente no centro da área útil da tela enquanto houver espaço suficiente no cenário para isso.

Próximo aos limites do mapa, a câmera poderá deixar de centralizar completamente o personagem para impedir que revele regiões fora do cenário.

---

# 7. Resolução de referência

A resolução de referência da primeira versão será:

**1280 × 720**

O cenário deverá ser desenvolvido considerando essa área de visualização.

A resolução não deve ser utilizada como justificativa para criar um mapa excessivamente grande.

O importante é que a área visível seja suficiente para:

- movimentação;
- identificação dos elementos;
- navegação;
- interação;
- leitura dos eventos.

---

# 8. Zoom

Não haverá zoom durante a exploração.

A escala visual deverá permanecer constante.

Isso simplifica:

- câmera;
- colisões;
- posicionamento;
- composição dos cenários;
- testes.

O comportamento poderá ser reconsiderado em versões futuras.

---

# 9. Colisões

Os cenários deverão possuir colisões físicas.

O personagem não poderá atravessar elementos definidos como obstáculos.

Entre os possíveis obstáculos estão:

- paredes;
- estruturas;
- pedras;
- árvores;
- móveis;
- barris;
- objetos do cenário.

Não é necessário implementar colisão em elementos puramente decorativos.

A regra é:

> se o elemento visual representa fisicamente algo que deveria impedir a passagem, ele deve possuir colisão.

---

# 10. Bar

O bar é o primeiro cenário narrativo importante da Vertical Slice.

É onde o protagonista encontra o velho e recebe a missão.

Também é o local onde ocorre a segunda grande sequência da rota de aliança.

Portanto, o bar é utilizado duas vezes durante a mesma missão.

---

# 11. Funções do bar

O bar precisa suportar três situações principais.

### Situação 1 — Primeiro encontro

O protagonista entra no bar e encontra o velho.

Ao aproximar-se dele e pressionar **E**, inicia-se o diálogo da missão.

### Situação 2 — Retorno pela rota de aliança

Zoro retorna ao bar acompanhado de:

- Johnny;
- Yosaku.

A garota e os piratas também participam da cena.

O velho está acompanhado por quatro membros de sua gangue.

O evento da emboscada é iniciado.

### Situação 3 — Investigação da pista

Depois do combate da emboscada, o jogador recupera o controle.

O bar permanece explorável.

O jogador precisa localizar a pista deixada no local onde a garota estava anteriormente.

Ao interagir com ela, inicia-se o evento que encerra a primeira parte da história.

---

# 12. Estrutura física do bar

O bar deve possuir uma estrutura simples.

Elementos mínimos:

- entrada;
- área principal;
- balcão;
- mesas;
- cadeiras;
- área onde o velho pode permanecer;
- área onde a garota pode permanecer durante os eventos;
- espaço suficiente para os combates;
- espaço para os personagens se posicionarem durante os diálogos.

Não é necessário implementar:

- cozinha funcional;
- banheiro;
- quartos;
- estoque;
- NPCs clientes;
- funcionários;
- objetos interativos secundários.

---

# 13. Posição do velho

Durante o primeiro evento, o velho deverá estar em uma posição facilmente acessível ao jogador.

O objetivo é que o jogador consiga perceber que existe um personagem relevante no ambiente sem utilizar marcadores ou indicadores artificiais.

O jogador se aproxima e pressiona:

**E**

Isso inicia a interação.

Durante o evento:

- o jogador perde o controle;
- Zoro permanece na posição definida;
- o velho se orienta em direção a Zoro;
- o diálogo é executado;
- ao término, o controle retorna ao jogador.

---

# 14. Posição da pista

Na rota de aliança, a pista deverá estar no ponto onde a garota estava durante a cena anterior.

Esse detalhe é importante porque estabelece uma relação espacial entre:

**garota → mapa → tesouro**

A pista não deve aparecer aleatoriamente em outro ponto do bar.

Depois da batalha, o jogador deverá ter liberdade para procurar a pista.

A interação ocorre quando o jogador se aproxima e pressiona **E**.

---

# 15. Combate no bar

O bar precisa possuir espaço suficiente para o combate:

**Zoro + Johnny + Yosaku**

contra:

**quatro membros da gangue.**

O combate não deve exigir um cenário especial.

O próprio bar funciona como arena.

Isso ajuda a validar que o sistema de combate consegue utilizar diferentes cenários sem depender de uma arena dedicada.

---

# 16. Caverna dos Piratas

A caverna é o segundo cenário principal.

Ela representa a base dos piratas e é o local onde ocorre a principal decisão narrativa da Vertical Slice.

O jogador chega até ela após aceitar a missão do velho.

---

# 17. Entrada da caverna

A entrada da caverna deverá estar localizada na área externa.

O jogador pode chegar até ela utilizando controle normal.

Ao entrar, o jogo identifica a mudança de cenário.

A transição pode ser simples.

Não é necessário implementar:

- animação elaborada de entrada;
- carregamento visual complexo;
- tela de loading personalizada.

A prioridade é que a transição seja funcional e rápida.

---

# 18. Estrutura da caverna

A caverna deverá possuir uma área principal suficientemente grande para:

- entrada do protagonista;
- movimentação automática durante o evento;
- posicionamento dos piratas;
- posicionamento da garota;
- diálogo;
- combate.

A área deve transmitir a ideia de uma pequena base pirata, e não de uma enorme rede de cavernas.

---

# 19. Acampamento pirata

O interior deverá possuir elementos que caracterizem a presença dos piratas.

Podem existir:

- tendas;
- barris;
- bancos;
- caixas;
- objetos roubados;
- pequenos montes de tesouros;
- iluminação simples;
- elementos naturais da caverna.

Esses objetos são principalmente cenográficos.

Nesta versão, não haverá interação com eles.

---

# 20. Personagens na caverna

Antes da decisão do jogador, a caverna contém:

- líder dos piratas;
- Johnny;
- Yosaku;
- dois outros piratas;
- garota sequestrada.

Os personagens devem ser posicionados de maneira que o jogador compreenda visualmente a situação.

A garota deve estar claramente sob controle dos piratas.

O líder deve ocupar uma posição que transmita autoridade sobre o grupo.

Johnny e Yosaku devem estar próximos o suficiente para participar naturalmente da conversa.

---

# 21. Entrada de Zoro na caverna

Quando Zoro entra na caverna, o jogador perde o controle.

O jogo executa uma movimentação automática.

Zoro deve caminhar até uma posição previamente definida.

Quando chega ao ponto determinado:

1. Zoro para;
2. os personagens se orientam;
3. inicia-se o diálogo;
4. o jogador recebe a escolha entre resgate e aliança.

Essa sequência deve ser determinística.

O jogador não deve conseguir interromper o evento caminhando durante o diálogo.

---

# 22. Caverna como arena de combate

Na rota de resgate, a mesma área da caverna utilizada para o diálogo será utilizada para o combate.

Isso permite:

- manter continuidade espacial;
- evitar carregamento de uma arena separada;
- reforçar que o combate acontece naquele local.

A disposição dos personagens poderá ser reorganizada automaticamente quando o combate começar.

Não é necessário reproduzir exatamente as posições utilizadas durante o diálogo.

---

# 23. Estado da caverna após a aliança

Na rota de aliança, Johnny e Yosaku deixam de atuar como NPCs da caverna.

Eles passam a integrar o grupo do jogador.

Os demais piratas permanecem na caverna.

O líder também permanece.

A garota segue com o grupo dos piratas até o retorno ao bar.

A cena termina e o controle volta para o jogador.

---

# 24. Retorno para a área externa

Após a aliança, o jogador precisa retornar ao bar.

O caminho deve permanecer disponível.

Johnny e Yosaku acompanham o protagonista como membros do grupo.

O sistema de acompanhamento deverá garantir que os personagens não atrapalhem o controle do protagonista.

A implementação detalhada do comportamento dos seguidores será definida no documento de personagens e sistemas.

---

# 25. Transição entre cenários

As transições mínimas são:

```text
Área Externa
    │
    ├──► Bar
    │
    └──► Caverna
```

O bar e a caverna são cenários independentes.

Ao entrar em um deles, o jogo carrega o cenário correspondente.

Ao sair, retorna à área externa.

---

# 26. Estado do cenário

O cenário não deve ser tratado como uma imagem estática independente do estado da missão.

Determinados elementos podem depender do progresso narrativo.

Por exemplo:

### Antes da missão

O velho está disponível no bar para iniciar o diálogo.

### Após aceitar a missão

A caverna passa a representar o próximo objetivo.

### Após a aliança

Johnny e Yosaku passam a acompanhar Zoro.

### Após o retorno ao bar

A cena da emboscada é habilitada.

### Após a batalha

A pista passa a estar disponível para interação.

Isso significa que o cenário precisa conseguir responder ao estado atual da missão.

---

# 27. Interações espaciais

Nesta Vertical Slice, as interações relevantes são poucas.

## Bar

- velho;
- entrada/saída;
- pista.

## Caverna

- saída;
- personagens envolvidos nos eventos.

## Área externa

- entradas do bar e da caverna.

Não haverá sistema de interação genérico com todos os objetos do cenário.

---

# 28. Ausência de marcadores

O jogo não deverá utilizar:

- ícones flutuantes;
- pontos de exclamação;
- círculos sobre personagens;
- setas indicando objetivos;
- marcadores sobre objetos.

O jogador deverá descobrir as interações por proximidade e contexto.

A interação é realizada por:

**E**

---

# 29. Objetivos e navegação

Na primeira versão, a navegação narrativa deverá ser simples.

Quando o jogador aceita a missão, ele recebe verbalmente a localização da caverna:

> "Em uma caverna a nordeste daqui, encrustada em uma montanha, e logo após um pequeno lago..."

Essa informação deve ser suficiente para orientar o jogador.

O jogo não precisa criar um sistema completo de navegação.

Na rota de aliança, a pista encontrada posteriormente indica uma direção geral:

> "acho que é a sul daqui..."

Essa indicação também não gera um marcador automático.

---

# 30. Posição e orientação dos personagens

Durante diálogos automáticos, os personagens devem poder se orientar uns para os outros.

Por exemplo:

```text
Zoro  →  Velho
```

ou:

```text
Zoro  →  Líder
       Garota
       Piratas
```

Isso é importante para que as cenas não pareçam apenas personagens parados aleatoriamente no mapa.

A orientação visual deve acompanhar a lógica da conversa sempre que possível.

---

# 31. Movimentação automática durante eventos

Alguns eventos exigem que o jogo controle o personagem.

Durante esses momentos:

- entrada na caverna;
- aproximação do grupo de piratas;
- cenas do retorno ao bar;
- posicionamento para determinados diálogos;

o controle do jogador será temporariamente bloqueado.

Depois da conclusão do evento, o controle será devolvido.

A implementação deve garantir que um evento nunca devolva o controle antes de terminar suas ações obrigatórias.

---

# 32. Área jogável mínima

A área externa não precisa ser grande.

O tamanho deverá ser definido a partir da distância necessária para proporcionar:

- uma pequena sensação de exploração;
- deslocamento entre bar e caverna;
- teste da câmera;
- teste de colisão;
- teste de corrida.

Não será definido neste documento um número arbitrário de pixels ou tiles para o mapa.

O tamanho final deverá ser consequência da composição visual e da experiência desejada.

---

# 33. Elementos visuais sem função

É permitido utilizar elementos puramente decorativos.

Exemplos:

- vegetação;
- pedras;
- barris;
- móveis;
- objetos de cenário;
- detalhes da caverna.

Entretanto, esses elementos não devem induzir o jogador a acreditar que existe uma interação quando ela não existe.

Na primeira versão, simplicidade é preferível a excesso de objetos.

---

# 34. Elementos proibidos nesta versão

Não devem ser implementados como sistemas:

- árvores destrutíveis;
- mineração;
- coleta;
- baús;
- pesca;
- natação;
- barcos;
- portas com chaves;
- lojas;
- objetos coletáveis;
- itens escondidos;
- puzzles ambientais;
- mecanismos de cenário;
- passagens secretas.

Esses elementos podem fazer parte do projeto futuro, mas não são necessários para validar a Vertical Slice.

---

# 35. Considerações sobre a futura expansão

Embora o mapa da primeira entrega seja pequeno, a arquitetura dos cenários não deve ser construída de forma que impeça expansão futura.

A estrutura deve permitir posteriormente:

- novos cenários;
- novas ilhas;
- interiores;
- cavernas;
- regiões exploráveis;
- novas transições.

Porém, essa capacidade deve ser obtida pela estrutura do sistema, e não pela implementação antecipada de conteúdo.

---

# 36. Critério de conclusão do documento

O sistema de mapas e cenários da Vertical Slice será considerado suficientemente especificado quando for possível responder:

**Onde o jogador está?**

**Para onde ele pode ir?**

**Qual cenário está carregado?**

**Quais personagens estão presentes?**

**Quais elementos possuem colisão?**

**Quais elementos podem ser interagidos?**

**Qual evento acontece naquele local?**

**Quando o controle passa para o sistema?**

**Quando o controle retorna ao jogador?**

**Como o cenário muda de acordo com o estado da missão?**

Se essas perguntas puderem ser respondidas sem necessidade de inventar regras durante a implementação, o documento cumprirá seu objetivo.

---

# 37. Relação com o próximo documento

Este documento define **onde** os acontecimentos ocorrem.

O próximo documento deverá definir **quem participa desses acontecimentos**.

O **Documento 03 — Personagens** deverá especificar:

- protagonista;
- Johnny;
- Yosaku;
- velho;
- garota;
- líder dos piratas;
- piratas;
- membros da gangue;
- atributos;
- papéis;
- comportamentos;
- participação narrativa;
- participação em combate;
- diferenças entre NPC, aliado e inimigo.

A definição dos atributos de combate deverá ser feita de maneira suficiente para permitir posteriormente a elaboração do **Documento 04 — Sistema de Combate**, sem criar números arbitrários antes de sabermos o papel de cada personagem.