---
layout: post
title: "monty hall problem"
category: 
tags: [math, teaching, interesting]
---

this is a fun problem, especially for those that have not seen it
before.

imagine you are a contestant on the game show, *Lets Make a Deal*,
with host, monty hall. in the game you are playing, you are presented with
three doors. behind one of the doors is a prize and behind the other
two are goats (non-prizes, unless you really like goats). you, the
contestant, are then to select one of the doors. after you have made
your choice, monty hall then opens one of the other doors revealing a
goat and asks you whether you would like to keep the door you
originally selected or if you would like to change to the other door.
what should you do?

when i taught this to fourth grade students, we played this game a
number of times for them to get a feel for how it works. they got the
hang of it very quickly. after a while, i asked what strategy did they
adopt to win. most knew that the game did not really begin until monty
hall revealed a door, but almost everyone thought the game was an even
chance of winning or losing.

to help them a little bit, we kept a tally of who switched doors and
won, who switched doors and lost, who stayed doors and won, and who
stayed doors and lost. they had expected all the numbers to come about
equal, but what they found was that amongst people that switched
doors, more of them won than lost, and those that stayed, more of them
lost than won.

at this point, they were starting to catch on but there were still a
few students that were not convinced that after removing a door the
odds were not even. so i changed the game a little. this time, instead
of three doors, there were 1000 doors. after picking a door, monty
hall would remove 998 of doors which did not contain a prize. this
left only two doors. at this point, the students knew that switching
was the better strategy. they explained, that when picking the first
door, there was a 1/1000 chance of selecting the door with the prize,
and a 999/1000 chance it was in one of the other doors. when we
removed 998 doors, the odds did not change to 50%, instead, the one
door remaining assumed the 999/1000 chance of containing the prize.

after this change in the game, all the students understood the
original game. they correctly found that there was a 2/3
chance the prize was in the other door.

to work it out more rigorously, we set up a sample space $\Omega = \left\\{ \left( w_1, w_2 \right) \mid w_i \in \left\\{1,2,3\right\\} \right\\}$ where $w_1$ is the door the prize is behind and $w_2$ is the door monty hall opens. Let $A_i = \left\\{w_1 = i\right\\}$ be the event the prize is behind door $i$
