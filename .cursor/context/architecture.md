# Architecture Context

## Stack

Godot 4.7 and GDScript. See `docs/decisions/ADR/ADR-001-godot-stack-e-greenfield.md`.

The legacy prototype under `scripts/`, `scenes/world/`, and `autoload/game_manager.gd` is not the architecture to extend.

## Layers

Presentation
    ↓
Application
    ↓
Domain

Infrastructure provides technical implementations.

## Domain

Contains game rules and state.

## Application

Coordinates use cases and systems.

## Presentation

Handles input, rendering and UI.

## Infrastructure

Handles persistence and technical details.

## Core Rule

Game rules must not depend on presentation details.

## Testing Principle

Core game rules must be testable independently of rendering.