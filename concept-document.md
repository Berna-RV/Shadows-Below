# Shadows Below: Concept Document
## Pitch Line

Embark on a perilous journey as a knight exploring a treacherous dungeon in search of the legendary "Holy Fire," a flame imbued with immense magical power.

## Introduction

Shadows Below is a dungeon-exploration game set in a dark, ominous underground world. Players take on the role of a brave knight tasked with navigating through danger-filled corridors, battling enemies, and strategically acquiring power-ups to grow stronger. The game's tactical elements encourage thoughtful decision-making, as reckless combat leads to certain death. The journey culminates in finding the "Holy Fire," granting victory and the salvation of the realm.

## Demographic Breakdown

+ Target Audience: Casual players with an interest in exploration, light strategy, and action.
+ Genre: Dungeon exploration with tactical combat elements.
+ Intended Platform(s): Digital game for PC.

## Feature List

+ Tile-based dungeon exploration.
+ Dynamic enemy combat system.
+ Power-ups to enhance player abilities.
+ Tactical gameplay requiring strategic thinking.
+ Simple and intuitive controls (e.g., mouse and keyboard inputs).

## Feature List Breakout

### Tile-Based Dungeon Exploration
The game features a structured dungeon divided into tiles, providing a clear and navigable environment for players to explore. Each tile may contain enemies, treasures, or power-ups, keeping the gameplay varied and engaging.

### Dynamic Enemy Combat
Players can attack enemies using left-click actions. Enemy placement and AI ensure that combat is challenging and tactical, encouraging players to plan their approach.

### Power-Ups and Growth
As the game progresses, players can collect potions and other items to grow stronger. These enhancements are critical to overcoming tougher enemies and challenges deeper in the dungeon. (Chests are opened with E)

### Tactical Gameplay
The game rewards thoughtful play over reckless behavior. Players must evaluate the risk of engaging enemies directly versus searching for power-ups to improve their odds.

### Simple Controls
Easy-to-learn inputs include movement (WASD or arrow keys), attacking (left-click), and interacting with objects such as chests (E).

## Implementation Reference
### Game State

Managed via a central game loop that tracks player health, inventory, and dungeon progression.
Tile-based map system stores tile data, including whether a tile contains enemies, items, or obstacles.

### Player Actions

+ Movement: Triggers tile interactions and updates the game state.
+ Attack: Calculates damage based on player power-ups and enemy defenses.
+ Interact: Allows opening chests or collecting items on the tile.

### Game Setup

+ Dungeon layout is pre-designed or procedurally generated at the start.
+ Player spawns at the dungeon entrance with basic stats and abilities.

### Victory Conditions

+ The game ends in victory when the player reaches the tile containing the "Holy Fire." Reaching this tile triggers a win screen or cinematic.

### Progression of Play

+ The player navigates the dungeon in turns, encountering enemies, traps, and treasures.
+ As power-ups are collected, the player becomes stronger, allowing for deeper dungeon exploration.

### Game Views

+ Top-down view for clear visibility of the dungeon layout.
+ UI elements include a health bar.

## Technical Details

+ Engine: Godot.
+ Assets: Tile-based graphics for the dungeon and characters. Enemies, chests, and items are 2D sprites with simple animations.
+ Constraints: The game is designed for single-session play and is intentionally limited in complexity to provide an accessible and enjoyable experience for casual players.