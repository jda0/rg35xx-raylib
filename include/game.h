#ifndef GAME_H
#define GAME_H

#include "raylib.h"
#include "config.h"

// Helpers
#if __APPLE__
#define WITH_KEY_QUIT(fn) ((fn(KEY_LEFT_SUPER) || fn(KEY_RIGHT_SUPER)) && (fn(KEY_Q) || fn(KEY_W)))
#else
#define WITH_KEY_QUIT(fn) ((fn(KEY_LEFT_ALT) || fn(KEY_RIGHT_ALT)) && fn(KEY_F4))
#endif

// Game state structure
typedef struct
{
    Vector2 squarePosition;
    float squareSize;
    float rotation;
    int currentColorIndex;

    // Input state tracking for single press events
    double leftPressed;
    double rightPressed;
    double upPressed;
    double downPressed;
    double aPressed;
    double bPressed;

    bool useGamepad;
} GameState;

// Function declarations
void InitGame(GameState *game);
void UpdateGame(GameState *game);
void DrawGame(const GameState *game);
bool ShouldGameExit(void);

// Input handling
void HandleInput(GameState *game);
void UpdateInputState(GameState *game);

#endif // GAME_H
