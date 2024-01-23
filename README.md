# Dungeon Generator Sketchpad

Welcome to a little scratch pad of sorts for generating 2D dungeons, for use in rougelikes, dungeon crawlers, etc. This is more of an experiment in procedural animation, adaptive UI, and messing with dungeon generators for a dungeon crawler project I've been working on. Its been coded in a way to be very modular to drag and drop into said project.

![Image of a series of coloured rectangles joined by lines representing a top down dungeon](https://img.itch.zone/aW1hZ2UvMjQ4NTk1OS8xNDc2NzIyOS5wbmc=/original/7989cT.png)

## Summary

This project implements a procedural dungeon generator in a very modular manner. Specifically, the two algorithms that have been implemented currently are an algorithm making use of binary space partitioning, and a bespoke algorithm liking randomly placed dungeon rooms together by their two nearest neighbours. Each generation mode has different properties in their respective foldout menus that you can play around with to see how they effect the resulting dungeon. For more information on what these properties do and how each algorithm works, there is an information button on the top right with a more detailed rundown of what is happening.

## How to Download

To look at this project in the editor, just download the repo to the same folder, then you should be able to import the project into the Godot editor. This project was developed with Godot 4.2.1, so while you may be able to open it in other versions, I can not vouch for the project's stability.

## Looking Back

I am very happy with this project, but most happy to see the back of it.  This is the most work I've put into a personal project and one of the most complete projects I've made. I'm really happy with how modular I've managed to make it. However, near the end of this project I really ran out of energy, and so its not as clean or elegant as I wanted it to be. Room to improve for next project I suppose.

If I were to expand this project, I would refactor the messy bits of my code, and add small quality of life changes. For instance, I have the infrastructure to add an animation speed slider,  but I have yet to add a slider to control this. Small things like this would really help this project pop. I would also like to add other algorithms to the list of possible generators, but this would take a lot of time to implement.

## Links

 - Itch.io Page: https://tresilloeffect.itch.io/dungeon-generator-scratchpad
 - Binary Space Partition Algorithm Inspiration: https://www.roguebasin.com/index.php/Basic_BSP_Dungeon_generation
 - Folding UI Base: https://forum.godotengine.org/t/how-to-make-folding-menu/24416
