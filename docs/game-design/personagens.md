# Personagens — Vertical Slice 01

**Projeto:** RPG 2D Top-Down  
**Versão:** 0.1  
**Escopo:** Primeira entrega jogável  
**Status:** Em definição

---

# 1. Objetivo do documento

Este documento define os personagens necessários para a Vertical Slice 01.

O objetivo é estabelecer:

- quem são os personagens;
- qual é seu papel narrativo;
- em quais eventos participam;
- quando podem ser controlados;
- quando participam de combate;
- quais relações possuem entre si;
- quais informações são conhecidas pelo jogador;
- quais informações permanecem ocultas;
- quais características devem ser consideradas no sistema de combate.

Este documento não define ainda as fórmulas ou valores definitivos do sistema de combate.

---

# 2. Classificação dos personagens

Os personagens da Vertical Slice serão divididos em quatro categorias:

| Categoria | Função |
|---|---|
| Protagonista | Personagem principal controlado pelo jogador |
| Aliado | Personagem que pode integrar o grupo e ser controlado |
| NPC narrativo | Personagem controlado pelo jogo durante a exploração e eventos |
| Inimigo | Personagem que participa de combates contra o grupo |

A classificação pode mudar conforme o estado da missão.

Por exemplo, Johnny e Yosaku começam como NPCs narrativos na caverna e posteriormente tornam-se aliados controláveis.

---

# 3. Personagens da Vertical Slice

A primeira entrega possui os seguintes personagens:

### Protagonista

- Zoro

### Aliados

- Johnny
- Yosaku

### Personagens narrativos

- Velho
- Garota
- Líder dos Piratas

### Inimigos

- Piratas
- Membros da gangue do velho

---

# 4. Protagonista — Zoro

## 4.1 Papel

Zoro é o protagonista da Vertical Slice.

O jogador controla Zoro durante a exploração.

Durante determinados eventos narrativos, o controle é temporariamente assumido pelo jogo para permitir movimentações e diálogos automáticos.

---

# 5. Características de Zoro

Zoro deve ser apresentado como um personagem:

- confiante;
- direto;
- provocador;
- interessado em testar suas habilidades;
- pouco interessado em recompensas materiais;
- disposto a enfrentar situações perigosas;
- orgulhoso de sua força e de suas espadas.

Seu comportamento durante os diálogos deve transmitir segurança, mesmo quando ele está diante de situações desconhecidas.

Zoro não deve ser apresentado como um herói tradicional que sempre toma decisões moralmente corretas.

Isso é importante para a estrutura da Vertical Slice.

Ele pode:

- ajudar a garota;
- provocar os piratas;
- lutar;
- ou se aliar aos piratas para atingir um objetivo próprio.

A personalidade do protagonista deve permitir que as duas escolhas sejam coerentes com o personagem.

---

# 6. Motivação inicial

No início da Vertical Slice, Zoro não possui uma relação pessoal com o velho ou com a garota.

Ele encontra a situação por acaso.

Sua motivação para aceitar a missão não deve ser apresentada como uma obrigação moral.

Na própria fala inicial, Zoro demonstra interesse em utilizar a situação como oportunidade para testar sua nova lâmina.

Isso estabelece uma característica importante:

> Zoro pode ajudar alguém, mas não necessariamente porque se considera responsável por salvar essa pessoa.

---

# 7. Participação de Zoro na história

Zoro participa de todos os eventos principais.

Sua sequência de participação é:

```text
Exploração
   ↓
Bar
   ↓
Velho
   ↓
Decisão
   ↓
Caverna
   ↓
Piratas
   ↓
Escolha
 ┌─┴──────────┐
 ↓            ↓
Resgate     Aliança
 ↓            ↓
Combate      Johnny/Yosaku
 ↓            ↓
Garota       Retorno ao bar
 ↓            ↓
Tesouro      Emboscada
              ↓
            Pista
```

---

# 8. Zoro e a escolha narrativa

A Vertical Slice não deve tratar a escolha entre resgate e aliança como uma escolha entre:

**"opção correta"**

e

**"opção errada".**

As duas alternativas devem ser apresentadas como possibilidades legítimas para o jogador.

O jogador pode decidir:

- agir contra os piratas;
- ou utilizar os próprios piratas para alcançar seus objetivos.

As consequências são diferentes, mas ambas fazem parte da experiência planejada.

---

# 9. Zoro em combate

Zoro é o personagem principal do sistema de combate.

Ele poderá:

- atacar;
- defender;
- tentar fugir.

Seu conjunto específico de ataques será definido no Documento 04.

A implementação inicial não deverá exigir habilidades especiais complexas.

Elementos como:

- Haki;
- técnicas especiais;
- poderes de Akuma no Mi;

não fazem parte da primeira entrega.

---

# 10. Johnny

## 10.1 Papel

Johnny é inicialmente um dos piratas presentes na caverna.

Durante a rota de aliança, ele passa a acompanhar Zoro.

A partir desse momento, deixa de ser apenas um NPC e torna-se membro do grupo.

---

# 11. Personalidade de Johnny

Johnny deve ser representado como:

- confiante;
- provocador;
- malandro;
- competitivo;
- interessado em demonstrar força;
- pouco paciente com provocações.

Sua personalidade deve gerar pequenas tensões com Zoro.

Johnny não deve ser tratado como um simples personagem obediente.

Ele acompanha Zoro porque existe um acordo temporário com os piratas.

---

# 12. Relação entre Johnny e Yosaku

Johnny e Yosaku possuem uma relação de companheirismo.

Os dois são integrantes do grupo de piratas e possuem familiaridade entre si.

Eles podem provocar um ao outro, discutir e fazer comentários durante determinadas situações.

Essa relação deve continuar existindo mesmo quando ambos passam a acompanhar Zoro.

---

# 13. Johnny como aliado

Johnny se torna aliado somente na rota de aliança.

Na rota de resgate, permanece inimigo.

Isso significa que o mesmo personagem possui papéis diferentes dependendo da decisão do jogador.

```text
Caverna
   │
   ├── Resgate → Johnny = Inimigo
   │
   └── Aliança → Johnny = Aliado
```

Essa característica é importante para o modelo de estado do jogo.

---

# 14. Johnny em combate

Quando aliado, Johnny participa do combate da emboscada.

O jogador poderá selecionar suas ações.

Ele deve possuir:

- HP;
- força;
- defesa;
- velocidade;
- sorte;
- ataques próprios.

Os valores e ataques serão definidos posteriormente.

Johnny não deverá utilizar o mesmo conjunto de atributos de Zoro apenas por simplificação.

Sua função é representar um personagem diferente dentro do grupo.

---

# 15. Yosaku

## 15.1 Papel

Yosaku é outro integrante do grupo de piratas.

Assim como Johnny, ele inicialmente aparece como inimigo na caverna.

Na rota de aliança, passa a integrar o grupo de Zoro.

---

# 16. Personalidade de Yosaku

Yosaku deve ser representado como:

- confiante;
- provocador;
- malandro;
- competitivo;
- falastrão;
- disposto a questionar Zoro.

Ele demonstra interesse em provar que é forte.

Sua relação com Zoro deve conter uma competição informal.

---

# 17. Relação entre Yosaku e Zoro

Yosaku não deve assumir imediatamente que Zoro é superior a ele.

Isso aparece diretamente no diálogo da aliança:

> "Acha mesmo que é mais forte que todos nós juntos..."

Essa postura deverá continuar durante a primeira parte da história.

Após o combate da emboscada, Yosaku inclusive afirma:

> "Eu te salvei pelo menos umas duas vezes"

Zoro responde minimizando sua participação.

Esse tipo de interação ajuda a estabelecer a personalidade dos dois.

---

# 18. Yosaku como aliado

Assim como Johnny, Yosaku possui dois papéis possíveis.

```text
Caverna
   │
   ├── Resgate → Yosaku = Inimigo
   │
   └── Aliança → Yosaku = Aliado
```

Na rota de aliança, Yosaku participa do combate contra os quatro membros da gangue.

---

# 19. Yosaku em combate

Yosaku será um personagem controlável.

Ele deverá possuir atributos e ataques próprios.

Além da participação em combate, Yosaku também possui uma função narrativa importante:

> interpretar a pista encontrada no bar.

Isso significa que sua presença não serve apenas para aumentar a quantidade de personagens no combate.

Ele possui conhecimento suficiente para reconhecer a representação geográfica encontrada.

---

# 20. Velho

## 20.1 Papel

O velho é o pai da garota sequestrada.

Ele inicia a missão.

Inicialmente é apresentado ao jogador como um homem desesperado procurando ajuda para resgatar sua filha.

Entretanto, posteriormente fica evidente que ele possui interesses relacionados ao tesouro.

---

# 21. Primeira impressão do velho

No primeiro encontro, o jogador deve perceber:

- desespero;
- fragilidade;
- sofrimento;
- incapacidade física de enfrentar os piratas.

O velho afirma ter tentado resgatar a filha e ter sido espancado.

Ele solicita ajuda porque não possui mais forças para agir sozinho.

---

# 22. Verdadeira motivação do velho

O velho também sabe da existência do tesouro.

Seu interesse não é exclusivamente salvar a filha.

Na rota de aliança, fica evidente que ele preparou uma armadilha para utilizar Zoro e os piratas e posteriormente tomar o controle da situação.

Ele possui uma gangue de quatro homens.

---

# 23. Função narrativa do velho

O velho cumpre três funções:

1. iniciar a missão;
2. induzir o jogador a acreditar inicialmente em uma situação simples de resgate;
3. revelar posteriormente que existe uma segunda camada de interesse relacionada ao tesouro.

Ele é, portanto, um personagem que apresenta uma informação incompleta ou manipulada ao protagonista.

---

# 24. Velho em combate

O velho não participa diretamente do combate da Vertical Slice.

Na rota de aliança, ele ordena o ataque da gangue e abandona a cena.

Sua função é narrativa.

---

# 25. Garota

## 25.1 Papel

A garota é a filha do velho e a pessoa sequestrada pelos piratas.

Ela é inicialmente apresentada como vítima do sequestro.

Entretanto, possui informações fundamentais sobre o tesouro.

---

# 26. Conhecimento da garota

A garota sabe:

- que existe um tesouro;
- que o tesouro está relacionado a uma fruta;
- que a fruta concede poderes;
- que não sabe exatamente qual poder será concedido;
- que uma pessoa desconhecida revelou essa informação;
- que essa pessoa aparentemente não pertence à região.

Ela também conhece uma referência da localização relacionada ao tesouro.

Essa informação está associada ao mapa/papel que ela carregava.

---

# 27. Relação da garota com o tesouro

A garota não deseja entregar a localização do tesouro ao pai.

Ela acredita que isso será prejudicial para a vila.

Essa é uma das razões pelas quais ela se recusa a fornecer a informação aos piratas.

---

# 28. Relação com o pai

A garota possui uma relação negativa com o pai.

Ela o considera covarde e desconfia de suas intenções.

Depois de ser resgatada, ela alerta Zoro:

> "Não acredite em nada do que ele fala..."

Ela também acredita que o pai provavelmente tentaria roubar a recompensa de Zoro caso ele retornasse com ela.

---

# 29. Relação com a família

A garota afirma que precisa retornar porque:

- sua mãe precisa dela;
- sua irmã precisa dela.

Ela havia sido capturada enquanto protegia a irmã.

Esse detalhe ajuda a caracterizar a garota como alguém que possui responsabilidades familiares além do conflito envolvendo o tesouro.

---

# 30. Garota em combate

A garota não participa dos combates da Vertical Slice.

Ela é uma personagem narrativa.

Seu papel é:

- motivar o conflito inicial;
- fornecer informações;
- revelar parte da verdade sobre o tesouro;
- fornecer a conexão narrativa com o misterioso desconhecido;
- deixar a pista relacionada ao tesouro disponível na rota de aliança.

---

# 31. Líder dos Piratas

## 31.1 Papel

O líder dos piratas comanda o grupo responsável pelo sequestro.

Ele é o principal antagonista da cena da caverna.

Seu nome ainda não está definido.

O personagem deverá ser identificado provisoriamente como:

**Líder dos Piratas**

até que um nome seja definido.

---

# 32. Personalidade do líder

O líder deve demonstrar:

- autoridade;
- confiança;
- interesse financeiro;
- capacidade de liderança;
- disposição para negociar;
- desconfiança em relação a estranhos.

Ele não deve atacar Zoro imediatamente.

Primeiro tenta compreender suas intenções.

Essa característica é importante para tornar a possibilidade de aliança plausível.

---

# 33. Relação do líder com Zoro

Na rota de resgate, Zoro torna-se inimigo dos piratas.

Na rota de aliança, o líder aceita temporariamente Zoro como aliado.

A aliança é baseada em interesse comum, não em confiança.

O próprio líder deixa isso explícito:

> "se tentar nos trair você não sai com vida"

Essa relação deve permanecer instável.

---

# 34. Líder em combate

Na rota de resgate, o líder participa do combate contra Zoro.

O combate envolve cinco piratas no total.

Na rota de aliança, o líder não participa do combate contra a gangue no bar.

Ele permanece como personagem narrativo.

Após a vitória, ele orienta a busca por pistas.

---

# 35. Piratas

## 35.1 Quantidade

A cena da caverna possui cinco piratas:

- líder;
- Johnny;
- Yosaku;
- dois outros piratas.

Quando Zoro escolhe a rota de resgate, os cinco participam do combate.

---

# 36. Papel dos dois piratas adicionais

Os dois piratas que não possuem nomes são utilizados como combatentes do grupo.

Eles não precisam possuir desenvolvimento narrativo significativo na Vertical Slice.

Sua função é:

- completar o grupo inimigo;
- participar do combate;
- fornecer variedade ao sistema de batalha.

Podem possuir características diferentes no combate, mesmo sem possuir personalidade narrativa desenvolvida.

---

# 37. Membros da gangue

A gangue é formada por quatro combatentes contratados pelo velho.

Eles aparecem somente na rota de aliança.

O grupo enfrenta:

**Zoro + Johnny + Yosaku**

contra:

**quatro membros da gangue.**

---

# 38. Função da gangue

A gangue existe para revelar a verdadeira intenção do velho.

O conflito não é iniciado aleatoriamente.

O velho pretendia:

1. deixar Zoro retornar com a garota;
2. cercar o grupo;
3. utilizar sua gangue;
4. eliminar ou enfraquecer os piratas;
5. tomar para si a informação sobre o tesouro.

A batalha serve como consequência direta dessa estratégia.

---

# 39. Gangue em combate

Os quatro membros da gangue participam diretamente do combate.

Cada membro deverá ser tratado como um combatente independente pelo sistema.

Eles poderão possuir pequenas diferenças de atributos ou comportamento.

A definição dessas diferenças pertence ao Documento 04.

---

# 40. Relações entre os personagens

A estrutura inicial de relações pode ser representada assim:

```text
                 VELHO
                   │
                pai de
                   │
                   ▼
                 GAROTA
                   │
          conhece informação
                   │
                   ▼
               TESOURO
                   ▲
                   │
        ┌──────────┴──────────┐
        │                     │
      PIRATAS               ZORO
        │                     │
        ├── líder             │
        ├── Johnny ───────────┤
        └── Yosaku ───────────┤
                              │
                        jogador controla
```

Na rota de resgate:

```text
Zoro
  │
  ├── enfrenta → Piratas
  │
  └── salva → Garota
```

Na rota de aliança:

```text
Zoro
  │
  ├── alia-se → Piratas
  │
  ├── recebe → Johnny
  │             Yosaku
  │
  └── enfrenta → Gangue do velho
```

---

# 41. Mudança de papel dos personagens

Uma característica importante da Vertical Slice é que o papel de um personagem não precisa ser permanente.

Johnny e Yosaku demonstram isso claramente.

Antes da escolha:

```text
Johnny = NPC / Pirata
Yosaku = NPC / Pirata
```

Após a escolha de resgate:

```text
Johnny = Inimigo
Yosaku = Inimigo
```

Após a escolha de aliança:

```text
Johnny = Aliado
Yosaku = Aliado
```

Essa mudança deve ser tratada pelo estado da missão e não pela criação de personagens diferentes.

---

# 42. Personagem e estado narrativo

O comportamento dos personagens deverá depender do estado atual da missão.

Por exemplo, o velho não deve continuar iniciando a missão depois que a história já avançou para uma etapa incompatível com esse evento.

Da mesma forma, Johnny e Yosaku não devem permanecer simultaneamente como NPCs da caverna e membros do grupo.

O estado narrativo determina:

- onde o personagem está;
- qual papel possui;
- quais diálogos pode executar;
- se pode ser controlado;
- se pode participar de combate.

---

# 43. Atributos conceituais

Todos os personagens que participam de combate deverão possuir uma estrutura de atributos compatível.

Os atributos previstos para a primeira versão são:

- HP;
- Energia;
- Força;
- Defesa;
- Velocidade;
- Sorte.

Outros atributos poderão existir no sistema futuro.

A definição dos valores iniciais ainda não pertence a este documento.

---

# 44. Identidade versus estado

O sistema deve separar:

**quem é o personagem**

de:

**qual é o estado atual desse personagem.**

Por exemplo:

```text
Personagem:
Johnny

Estado:
- presente na caverna
- inimigo
```

pode posteriormente se tornar:

```text
Personagem:
Johnny

Estado:
- integrante do grupo
- aliado
- controlável
```

O personagem continua sendo Johnny.

Somente seu estado dentro da experiência mudou.

Essa separação será importante para a implementação futura.

---

# 45. Informações conhecidas pelo jogador

Nem tudo que o personagem sabe deve ser apresentado imediatamente ao jogador.

No início:

### Jogador sabe

- a garota foi sequestrada;
- os piratas estão envolvidos;
- o velho pede ajuda.

### Jogador descobre na caverna

- a garota possui informação sobre um tesouro;
- os piratas querem essa informação.

### Jogador descobre na rota de resgate

- o velho também possui interesse no tesouro;
- o tesouro é uma fruta;
- a fruta concede poderes;
- uma pessoa desconhecida forneceu a informação.

### Jogador descobre na rota de aliança

- o velho preparou uma emboscada;
- a garota carregava uma pista relacionada ao tesouro;
- a região indicada está provavelmente ao sul.

Essa progressão de conhecimento deve ser preservada.

---

# 46. Personagem desconhecido

Existe uma pessoa que revelou à garota informações sobre o tesouro.

Essa pessoa:

- não é apresentada nesta Vertical Slice;
- não possui identidade definida;
- aparentemente não pertence à região;
- conhece a existência da fruta;
- forneceu alguma referência relacionada à localização.

Esse personagem não deverá ser inventado ou revelado prematuramente.

Ele funciona como um gancho narrativo para uma continuação futura.

---

# 47. Princípio de design dos personagens

Os personagens da primeira entrega não devem existir apenas para preencher o mapa.

Cada personagem precisa possuir uma função clara:

| Personagem | Função |
|---|---|
| Zoro | Protagonista e jogador |
| Velho | Inicia o conflito e oculta sua verdadeira motivação |
| Garota | Vítima, fonte de informações e conexão com o tesouro |
| Líder | Antagonista da caverna e potencial aliado temporário |
| Johnny | Inimigo ou aliado |
| Yosaku | Inimigo ou aliado e intérprete da pista |
| 2 piratas | Combatentes |
| 4 membros da gangue | Combatentes da emboscada |

---

# 48. Critério de conclusão

O documento de personagens será considerado suficientemente definido quando for possível responder, para cada personagem:

- quem ele é;
- qual sua função;
- onde aparece;
- com quem se relaciona;
- o que sabe;
- o que o jogador sabe sobre ele;
- quando pode ser controlado;
- quando participa de combate;
- em que condições seu papel muda.

Os valores numéricos e fórmulas de combate serão definidos separadamente.

---

# 49. Relação com o próximo documento

Este documento define **quem participa da experiência**.

O próximo documento, **Documento 04 — Sistema de Combate**, deverá definir **como esses personagens lutam**.

Ele deverá especificar:

- estrutura da batalha;
- fases;
- ações;
- atributos;
- ordem de execução;
- velocidade;
- HP;
- dano;
- defesa;
- acerto;
- esquiva;
- sorte;
- IA;
- ataques;
- defesa;
- fuga;
- vitória;
- derrota;
- experiência;
- comportamento dos aliados;
- comportamento dos inimigos.

A partir desse documento será possível transformar os personagens definidos aqui em combatentes com regras concretas.