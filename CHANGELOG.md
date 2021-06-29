# Changelog
All notable changes will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.3] - 2021-06-29
### Added:
* downscroll
* all keys can be binded now
* page indicator for options
* now you can know what keys to press within freeplay and options
* you can now fullscreen in the title screen
* [EXPERIMENTAL] Mod support, not like Polymod
* you can now see out of date screens in future builds (present in this version, will be seen when updated more)
* anticheat for when you do cheat :)
* FPS+'s offset menu, located inside of the note offset option
* FPS+'s Guitar Hero sutain note deletion, that actually works unlike in the AGOTI hotfix
* menu music can be infinite and whatever you want, with you baing able to out your own bpm as well
* new options: 5k switch
* new options: note speed for more note control
* new options: game over skip
* new options: cutscene skip after an amount of deaths
* character offsets are now read through text files like in week 7
* death counter
* note splashes
* hscript modcharts
* you can use your center keybind to scroll through options and modifiers faster
* new modifier: Boyfriend Must Die
* new option: combo health
* freeplay can now have neat colors for every single song
* new hue setting, like in week 7 + left and right on the title screen will change it
* new option: distraction switch
* difficulty page in freeplay's pause menu
* new type of notes: mine notes
* autoplay like stepmania, wihch can be switched on or off in options
* hitsounds and its own hitsound volume options, you can put as many as you like
* chromakey options for easy greenscreen, courtesy of TentaRJ
* restart function for the title screen (CTRL + R)
* new option: background alpha
* new chart types: dual arrow, dual chaos, wave
* more easter eggs
* leftscroll and rightscroll
* new option: enemy note alpha (for leftscroll and rightscroll)
* new option: auto pause, like in week 7
* new option: pause countdown
* new option: note splash switch
* new option: reset button switch
* new option: cheat button switch
* new option: note glow for the player
* new option: note glow for the enemy
* you can now loop songs, and AB repeat them in freeplay and charting
* new modifier: jacktastic (PREPARE FOR JACKS)
* new option: miss animations
* there's now fallback support for frozen and worried sprites which means they are completely optional
* health bar can be now colored based on the most dominant color for an icon
* new option: health icon switch
* new option: health icon animations switch
* you can now switch icon styles to anything you want

### Changed:
* ranking sprites are cleaner looking in freeplay and story menu
* buttons for the options menu are now smaller
* monster sprites are now updated to how it looked, similarly to Winter Horrorland's
* modifier sprites are now smaller and more compact so you can see more options available
* sustain notes wiggle around on beat
* input system is much more generous when it comes to hitting notes
* window's resizable now
* icons no longer look bad, drawn by Sector03
* resolution option supports monitors with lower resolution
* chaos charts are now seed-based
* portrait mode pixel scaling now will detect under a smaller portrait resolution
* allow for chart loading thru modsystem
* intro text now supports up to three lines
* window, icon and title shenanigans in thorns
* all characters are positioned properly throughout stages
* philly has been changed to philly nice
* satin panties and winter horrorland have spaces in them
* allow for 1-10 combo showing
* icons now work as week 7 does, with separate grids for each characters, with fallback support
* new ranking sprites, courtesy of Sector03
* character limit for preset saving has been raised to 30
* title now contains 'Engine' in it

### Fixed:
* enemy idles no longer stop when raching the ranking screen
* bpm no longer changes on the title screen if you had different menu music
* input system should be better
* girlfriend is put behind the limo in week 4
* fixed a bug where values ended up something like 14.99999999 for example
* json loading through the chart menu actually works
* some fix to fullscreen not working properly
* modifier menu doesn't have weird camera now
* fixed charts on endless mode loading too early on future loops, as well as the countdown skip
* gameplay customization should work properly
* third tracks of story mode should display now
* fixed minor spelling mistakes
* spirit's face should be in front of a dialogue portrait in thorns
* syncing issues for lower framerates
* fix stuttering on non bf characters when they are selected as player 1
* fix combo being offset by 1
* mirror and upside down should be working at all times

## [2.0.2] - 2021-05-05
### Added:
* new options page for clearing out your config and save
* new options: **menu music**, **rainbow fps** and Kade Engine's **Late Damage**
* new modes: **marathon** and **endless**
* endless mode bug called "pause countdown skip" that was definitely intentional, yeah...
* an image-based watermark which can be switched on and off in the options
* new accuracy type: **rating-based**
* more intro texts, and with that, probably more easter eggs
* new options page for miscallaneous stuff which includes gameplay customization like in Kade Engine, charting and animation debug
* new load button for charting so that you can open any json as long as it works

### Changed:
* icon grid has been updated not only graphically but now also has winning sprites

### Fixed:
* if an enemy misses a note, it shouldn't affect your health
* fixed easter egg images disappearing

## [2.0.1] - 2021-04-27
### Added:
* added Ash237 to the credits
* new chart type: **Stair** - stairs for every chart
* new option: **cutscene toggle**
* new dialogue variable: interruptions
* ranks save now and can be visible both in Story Mode and Freeplay
* little cues of motivation when getting ranked

### Changed:
* camera zoom on tutorial is way smoother
* character in Story Mode menu has been pushed up a bit
* freeze, lights Out and blinding overlays have been put on a new camera layer
* camera speed from character to character has been slowed down
* changed the way shake time, delay, flash time and delay work

### Fixed:
* input system no longer eats inputs and is a wee bit more reminiscent of Kade Engine's input
* timing shown didn't disappear sometimes, so now it does

## [2.0] - 2021-04-25
### Added:
* multi-preset naming system for modifiers
* _easter eggs_
* some Kade Engine features
* buffed up dialogue system, everything is **customizable** with **no limits**
* _some leaks_
* more options for you to mess with, **and I mean way more**
* a couple of new modifiers

### Changed:
* **pretty much everything, all recoded and redesigned for a new graphical and functional style, for the most part.**

## [1.0] - 2021-02-15
### Added
* Uh, everything
