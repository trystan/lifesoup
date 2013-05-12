lifesoup
========

Exploring random artificial life ideas with Ruby.

Currently there's a bunch of creatures that randomly bounce around. Each creature has several body parts:
* green parts supply a small amount of energy each turn
* red parts increase how much energy it takes from others when they collide
* yellow parts decrease how much energy is taken when others collide with it
* blue parts do nothing

When the creature has enough energy it creates offspring. Offspring have the same parts as their parent except one part will be randomly changed into something else. Creatures die when they get too old or when they run out of energy.

Populations tend to follow a boom and bust cycle. Creatures with many green parts will reproduce the most and quickly dominate. As it gets more crowded, collisions become more common and reds will begin to dominate. If yellows also increase quick enough then the population can stay fairly stable. Eventually attacking others will become the most successfull strategy; reds will almost completely dominate and infighting will decimate the population. Sometimes there's enough greens for a small group of survivors to restart the cycle but sometimes it crashes so quickly that they all die off.

If you think of the different body parts as alleles, then it's a neat example of how crowding can affects allele frequency.

Future ideas:
* other body parts
* creatures that control where they move
* neural nets?
* climate
* geography
* user interaction
* a world larger than the screen
