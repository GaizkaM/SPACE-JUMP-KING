# Space-Jump King

Welcome to **Space-Jump King**, an exciting video game developed in assembly language for the Motorola 68000 microprocessor using the EASy68k environment! This project was created as the final assignment for the **Computer Architecture II** course and combines peripheral management, graphics, and sounds to deliver a unique retro experience.

## 📖 Description

**Space-Jump King** is a game where the main objective is to guide your character through platforms, jumping upwards while avoiding falling into the void. Each level increases the difficulty, introducing enemies and new mechanics to challenge your skills.

## 🎮 How to Play

1. **Starting the Game**:
   - At the start, you will see an introduction screen with the title and a button to begin.
   - Before starting, basic instructions for the game are displayed.

2. **Character Controls**:
   - Use the **arrow keys** to move the character left and right.
   - If the character reaches the edge of the screen, it will reappear on the opposite side.

3. **Level Progression**:
   - **Level 1**: Jump from platform to platform. Complete 50 jumps to proceed to the next level.
   - **Level 2**: In addition to platforms, enemies will appear. Avoid or eliminate them by shooting with the **spacebar**.
   - **Level 3**: Tougher enemies appear. This time you can’t shoot them, so you'll need to dodge them.

4. **Winning and Losing Conditions**:
   - Complete all 3 levels successfully to win and receive a congratulatory message along with your final score.
   - If you fall into the void or are hit by an enemy, you lose but can view your previous score.

## 🗂 Project Structure

The code is organized into several folders:
- **FILE**: Contains the score storage file.
- **SND**: Sound files in `.wav` format.
- **LIB**: Libraries for memory management, agents, and file operations.
- **GAME**: Main game code divided into modules for managing enemies, platforms, player, scores, and game states.
- **IMAGE**: Contains the routine to display images on screen, such as the victory trophy.

## ✨ Key Features

- **Mouse Interaction**: State transitions triggered by mouse clicks.
- **Score Management**: Reads and writes scores to a binary file.
- **Image Rendering**: Graphic representation of processed images.

## 📢 Authors

- **Gaizka Medina Gordo**  
- **Joaquín Esperon Solari**
