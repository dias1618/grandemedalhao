# ADR-001 — Godot 4.7, camadas e greenfield

## Status

ACCEPTED

## Context

O repositório já abre no Godot 4.7 com GDScript, mas a especificação técnica deixava a engine em aberto. O protótipo atual (menu, vila, jogador, inventário, medalhão e save) não implementa a Vertical Slice descrita em `docs/game-design/`. Sem uma decisão explícita, um agente pode escolher outra stack, estender o protótipo ou misturar as camadas com `scripts/` e `autoload/`.

## Decision

A Vertical Slice 01 será implementada em Godot 4.7 com GDScript.

A árvore nova é:

```text
domain/            regras e estado; sem nós de cena
application/       casos de uso
presentation/      cenas, input de teclado, câmera, colisão visual
infrastructure/    arquivos, load de recurso, save futuro
tests/domain/      testes de domínio
tests/run_domain_tests.gd
```

O domínio pode usar tipos de valor do Godot (`Vector2`, `StringName`). Não pode estender `Node`, ler `Input`, carregar cenas nem depender de `presentation/` ou `infrastructure/`.

`project.godot` continua sendo o arquivo de projeto. A cena principal e os autoloads passam a apontar só para o que a unidade de implementação em curso autorizar.

O protótipo já presente no repositório não é fonte de verdade. Não migrar inventário, vila, medalhão, `GameManager` nem o jogador atual. A IU-001 substitui o fluxo executável e remove esse código do caminho de execução.

Identificadores de código ficam em inglês. Os documentos de game design permanecem em português.

Testes de domínio são scripts `tests/domain/*_test.gd` com `run() -> bool`, executados por:

```text
godot --headless --path . -s res://tests/run_domain_tests.gd
```

A importação do projeto é:

```text
godot --headless --path . --import --quit
```

Se o binário não se chamar `godot`, definir a variável de ambiente `GODOT`.

## Alternatives Considered

### Alternative A

Manter a engine indefinida até a IU-001.

Isso devolve a escolha de stack para cada agente.

### Alternative B

Evoluir o protótipo atual até a arquitetura da especificação.

O protótipo não separa domínio de apresentação e inclui sistemas fora da Vertical Slice.

## Consequences

### Positive

- A IU-001 tem pastas, comandos e uma regra de descarte.
- Regras de domínio podem ser testadas sem abrir a árvore de cena.

### Negative

- O protótipo atual deixa de ser executável quando a IU-001 for implementada.
- Tipos de valor do Godot entram no domínio.

## Scope

This decision applies to:

- stack, pastas e testes do marco M01 em diante;
- o que pode ser reutilizado do código já commitado.

It does not apply to:

- o formato dos dados de diálogo, missão e evento (fica para o marco em que esse conteúdo for implementado);
- escolha de plugin externo de teste.

## Date

2026-10-12
