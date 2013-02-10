---
title: MiniMax and AlphaBeta Search
layout: post
featured: true
---

[zero sum]: http://en.wikipedia.org/wiki/Zero-sum
[perfect information]: http://en.wikipedia.org/wiki/Perfect_information

Though they are quite different from each other Chess, Checkers, Go, Othello, Connect-4
and Tic-Tac-Toe also have similarities. They are all two-player [zero sum][]
[perfect information][] games. The
term *two-player* just means that there must be two opposing sides (football is
considered two-player, for example). A *zero sum* game is one where an advantage
for one player is an equally large disadvantage for the other. *Perfect
information* basically rules out any game that has an element of chance. Yatzee? Right
out the window. Poker? Forget about it. Jenga? Not even *close*.

For games that have these properties it is possible to set up a game tree to aid in the
selection of the next move. For simplicity, consider the starting state of Tic-Tac-Toe to
be the root of a tree. The root has nine branches, each leading to a successor state. Each
of these has 8 branches leading to *its* successor states and so on. Some of the
paths through the tree will end before others (a winning state is reached before all the
slots have been filled) but some paths continue until depth 9 (or *ply* 9 in
game-tree terminology), when all the slots have been filled.

After having exhausted the search space of the game, it is easy to find the paths that
will lead to victory for either player. Knowing the path that X can take to the fastest
victory is generally of little use, however, because O can thwart X's plans of a swift
victory any time it is her turn to move. Instead of traversing the path leading to the
fastest possible victory, X's best aim is to pick a path where her *worst* outcome
will be victory (the *best worst-case* path). The Minimax game-tree search
algorithm is designed to do just this, and alpha-beta pruning improves on it. This article
tries to explain how both works.

## The Minimax algorithm

Let us use Tic-Tac-Toe as an example when explaining how the Minimax algorithm works. The
player whose turn it is to move at the root is called Max, and all even plies in the
game-tree (i.e. the states where it is Max' turn to move) are labelled accordingly. Max'
opponent is called Min. These names are adapted from their actions; Max is always trying
to maximise her score, Min is always trying to minimise Max' score.

To determine who won, a function to evaluate a game state is needed. The evaluation
function takes a game state as its argument and should return a value indicating whether
the state is a win, loss or draw for the player whose turn it is at that state. The
function could for example return 1 if the state is a win, -1 if the state is a loss and
zero if the state is a draw. The evaluation function is applied to all the leaf states.
Leafs are game states without children, i.e. either a draw, or a win for one of the
players.

After exhausting the tree and evaluating all leaf states, Minimax values are assigned to
the internal states (all non-leaf states) of the game-tree. The Minimax values found in
the leaf nodes are inverted and returned to their parent. Each parent picks the highest
value returned to it, negates it, then returns the result to its parent, et cetera. The
Minimax values returned to the root denote Max' worst outcome for each corresponding move.
All that remains for Max is to pick a move where her worst outcome is a win (if such a
move exists--it does not in Tic-Tac-Toe).

The following method shows how the Minimax algorithm can be implemented in Objective-C. A
noticeable difference from the description above is that the Minimax value is negated on
return from the recursive call instead of before the return; this is how the Minimax
algorithm is normally implemented.

    -(int)minimaxWithState:(id)state player:(int)player
    {
        if ([state isEndOfGame])
            return [state evaluateWithPlayer:player];
        int score = -1; // value for loss
        NSArray *moves = [state movesAvailable];
        id enumerator = [moves objectEnumerator];
        for (id m; m = [enumerator nextObjnextObject]; ) {
            id s2 = [state successorStateWithMove:m];
            int sc = -[self minimaxWithState:s2 player:3 - player];
            if (sc > score)
                score = sc;
        }
        return score;
    }

The next listing shows the special Minimax function applied to the root of the tree (i.e.
the position for which a move is sought). In discussions of the algorithm the notion of
any special treatment of the root is often omitted; it is included here for the sake of
completeness.

    -(id)minimaxRootWithState:(id)state player:(int)player
    {
        id bestmove = nil;
        int score = -1; // value for loss
        NSArray *moves = [state movesAvailable];
        id enumerator = [moves objectEnumerator];
        for (id m; m = [enumerator nextObject]; ) {
            id s2 = [state successorStateWithMove:m];
            int sc = -[self minimaxWithState:s2 player:3 - player];
            if (sc > score) {
                bestmove = m;
                score = sc;
            }
        }
        return bestmove;
    }

## Depth-limited Minimax

Only when the search space is sufficiently small, like in our Tic-Tac-Toe example, is it
possible to exhaust it fully using the Minimax algorithm. For practical applications this
is almost never the case. Computers are not powerful enough to exhaust game-trees for
practical applications where game-tree search would be desired. For example, it has been
claimed that the game of Chess has more states than there are atoms in the known universe.
Suffice to say that waiting for a search of that magnitude to finish becomes impractical.

A simple way of ensuring that the search will terminate in a practical timespan is to set
a maximum limit on the depth of the search. The following method shows how the Minimax
algorithm presented earlier can be amended to unconditionally stop after reaching a
certain depth. Notice that the initial value for score has changed.

    -(int)minimaxWithState:(id)state player:(int)player ply:(int)ply
    {
        if (!ply || [state isEndOfGame])
            return [state evaluateWithPlayer:player];
        int score = -1000; // value for loss
        NSArray *moves = [state movesAvailable];
        id enumerator = [moves objectEnumerator];
        for (id m; m = [enumerator nextObject]; ) {
            id s2 = [state successorStateWithMove:m];
            int sc = -[self minimaxWithState:s2 player:3 - player];
            if (sc > score)
                score = sc;
        }
        return score;
    }

Since the search may be terminated before it has reached the leaf nodes, the end states of
many paths are lost. Thus the evaluation function will have to be enhanced: it must now be
able to indicate how good non-terminal states in the game-tree are, in contrast to simply
determining a win, loss or draw for an end state. Instead of returning -1, 0 or 1 the
evaluation function must now return a value in a certain range (say, -1000 to 1000)
indicating how good the state is. Performance of depth-limited Minimax algorithms greatly
depends on how well the evaluation function identifies strong states.

## Alpha-Beta pruning

In the late 50s it was realised that it was not necessary to visit all the nodes in a
game-tree to correctly deduce its Minimax value. Uninteresting branches of the tree can be
pruned away. Remember that the Minimax algorithm produces the value of the best
worst-case. Alpha-Beta pruning terminates the search of a subtree as soon as it knows that
the worst-case for the subtree is worse than previously searched paths. The idea is that
if a path is worse than the current best path, time is not wasted trying to find out
*how* bad it is.

To accomplish the pruning mentioned above two bounds are passed to a modified Minimax
algorithm. The bounds are the highest (beta) and lowest (alpha) value that can affect the
Minimax value at that point, and are continually updated as the search progresses. Since
the Minimax value is negated at each step, the states of the bounds must also be negated
and their states switched as they are passed on to the next level. If the Minimax value
returned from a path is greater than or equal to the high bound, the path is pruned.
Here's an example:

    -(int)alphaBetaWithState:(id)state
                      player:(int)player
                         ply:(int)ply
                       alpha:(int)alpha
                        beta:(int)beta
    {
        if (!ply || [state isEndOfGame])
            return [state evaluateWithPlayer:player];
        NSArray *moves = [state movesAvailable];
        id enumerator = [moves objectEnumerator];
        for (id m; m = [enumerator nextObject]; ) {
            id s2 = [state successorStateWithMove:m];
            int sc = -[self alphaBetaWithState:s2
                                        player:3 - player
                                           ply:ply-1
                                         alpha:-beta
                                          beta:-alpha];
            if (sc > alpha)
                alpha = sc;
            if (alpha >= beta)
                break;  // prune branch.
        }
        return alpha;
    }

In a worst-ordered tree (where the paths are ordered so that no pruning occurs) the
Alpha-Beta algorithm visits the same number of leaf nodes as Minimax. On average it
performs a lot better. Given a perfectly ordered tree, where the branches are pruned as
early as possible, the Alpha-Beta algorithm can search twice as deep as the Minimax
algorithm in the same timespan.

*This post has been adapted from a section of my 2003 BSc Artificial Intelligence report
on Generalised Game-Tree Search at the University of Westminster.*
