# DevLog

## My Roguelike needed Fog of War.

### Script

1. My roguelike haquelike needed exploration
2. I started by downloading an implementation of Mingos' Restrictive Precise Angle Shadowcasting from the Godot Asset Library.
3. I use this to calculate how many tiles away the hero can see and if walls are blocking the view.
4. Then I used this to flag my tiles as visible or explored.
5. Tiles are invisible until you explore them and
6. Explored walls will show up as a dark outline when the Hero walks away
7. I expanded autotiling to make the visible and explored walls connect and
8. I drew custom wall outlines for each of my tilesets and drew a new empty tile
9. Finally, I made it so that actors are only visible when standing on a visible tile

### Clips

1. pre-changes clip
2. Mingos' Restrictive Precise Angle Shadowcasting text on screen
3. Clip of the code that sets up the fov
4. In progress clip of visible and explored tiles
5. Continued
6. Continued
7. Final clip
8. Layer multiple tilesets vertically
9. Continued
