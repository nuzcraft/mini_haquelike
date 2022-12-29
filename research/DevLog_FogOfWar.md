# DevLog

## Fog of War

Adding visibility to the Hero in my roguelike.
I started by downloading an implementation of Mingos' Restrictive Precise Angle Shadowcasting from the Godot Asset Library.
I use this to calculate how many tiles away the hero can see and if walls are blocking the view.
Then I used this to flag my tiles as visible or explored.
Tiles are invisible until you explore them and
Explored walls will show up as a dark outline when the Hero walks away
