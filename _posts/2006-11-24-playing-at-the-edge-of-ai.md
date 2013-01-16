---
layout: post
title: Playing at the Edge of AI
---

*The article below is old, and rife with broken links. Sorry about that. Maybe I'll get around to cleaning those up one day.*

Reading <a href="http://www.amazon.co.uk/dp/1558607838">Blondie24</a>, where I got the title of this post from, got me exited about <a href="http://en.wikipedia.org/wiki/Neural_network">neural nets</a> and <a href="http://en.wikipedia.org/wiki/Genetic_algorithm">genetic algorithms</a> again. I always did found them fascinating, but I didn't really have any practical use for them myself&mdash;until now.



My goal for the <a href="http://brautaset.org/svn/Cocoa/trunk/">Cocoa games</a> project, and <a href="http://brautaset.org/files/ggtl/doc/">ggtl</a> before it, has always been to make building of decent computer game AIs very easy (for two-player <a href="http://en.wikipedia.org/wiki/Zero-sum_game">zero-sum</a> <a href="http://en.wikipedia.org/wiki/Perfect_information">perfect information</a> games, at least, which is actually a rather large group). My focus has been on the scaffolding&mdash;encapsulating the <a href="http://en.wikipedia.org/wiki/Alpha-beta_pruning">Alpha-Beta</a> algorithm and letting developers focus on implementing its key components: detecting legal moves, applying a move to a state, and the evaluation function.



While the first two are quite uninteresting (they're just <em>game-specific</em> scaffolding), the evaluation function is what really makes or breaks the resulting AI. Given an arbitrary state, this function must determine its <em>fitness</em>; how good or bad the state is. If you are an experienced player you might instinctively know if a given state is good, but it may not be a simple task to translate that to computer code. While computer games AIs have traditionally relied on exploiting knowledge provided by human experts, David Fogel and Kumar Chellapilla set out to see if they could create a program that could learn to play checkers on its own. To achieve this they used a genetic algorithm to evolve a neural net which they used as their program's evaluation function.



David and Kumar were remarkably successful: Blondie learned to play checkers to a human Master level. If I could reproduce their results in a way that would work for a broader range of games, my goal of making board-game AI creation very simple would be largely achieved.



Fast forward a few months. I have implemented a neural net evaluation function for my <a href="http://brautaset.org/files/CocoaGames/Puck.dmg">Connect 4</a> game. The net is somewhat simpler in construction than Blondie's, though I copied the techniques used for evolving it straight from the book. After 25 generations I stopped the evolution and played a game against the best neural net so far; it beat me hands down. Unfortunately, after 100 generations my best neural net still haven't been able to beat the hand-rolled evaluation function I wrote for the game originally (I must have had a stroke of genius back then).



This is where I am currently at. I don't want to release a game with an AI inferior to that in the previous version (it is available from <a href="http://brautaset.org/svn/Cocoa/branches/nn/">subversion</a> though), and I am currently experimenting with a few possible ways to improve the training of the neural net. Rest assured any progress I make will be the topic of future posts.
