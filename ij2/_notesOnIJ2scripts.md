Notes for ImageJ2 scripts
========================

Note: [The Fiji Wiki](http://fiji.sc/Javascript_Scripting) notes that

> Unlike ImageJ 1.x, ImageJ2 (and therefore Fiji) does not automatically import any classes. Consequently, scripts written for ImageJ 1.x will not run in ImageJ2 without adding the proper imports. The rationale is that the auto-import feature is not safe. What if two classes of the same name live in two different packages? Or if a new class is introduced that makes formerly unique names ambiguous? All of a sudden, all of the scripts that reference the original class no longer work. In short: auto-imports are dangerously imprecise.