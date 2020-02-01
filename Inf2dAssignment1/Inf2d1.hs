-- Inf2d Assignment 1 2017-2018
-- Matriculation number:
-- {-# OPTIONS -Wall #-}


module Inf2d1 where

import Data.List (sortBy)
import Debug.Trace
import ConnectFour

-- user-defined imports
import Data.Ord

gridLength_search::Int
gridLength_search = 6
gridWidth_search :: Int
gridWidth_search = 6

{- NOTES:

-- DO NOT CHANGE THE NAMES OR TYPE DEFINITIONS OF THE FUNCTIONS!
You can write new auxillary functions, but don't change the names or type definitions
of the functions which you are asked to implement.

-- Comment your code.

-- You should submit this file, and only this file, when you have finished the assignment.

-- The deadline is the 3pm Tuesday 13th March 2018.

-- See the assignment sheet and document files for more information on the predefined game functions.

-- See www.haskell.org for haskell revision.

-- Useful haskell topics, which you should revise:
-- Recursion
-- The Maybe monad
-- Higher-order functions
-- List processing functions: map, fold, filter, sortBy ...

-- See Russell and Norvig Chapters 3 for search algorithms,
-- and Chapter 5 for game search algorithms.

-}

-- Section 1: Uniform Search

-- 6 x 6 grid search states

-- The Node type defines the position of the robot on the grid.
-- The Branch type synonym defines the branch of search through the grid.
type Node = (Int,Int)
type Branch = [(Int,Int)]

-- |next function
-- The next function should return all the possible continuations of input search branch through the grid.
-- Remember that the robot can only move up, down, left and right, and can't move outside the grid.
-- The current location of the robot is the head of the input branch.
-- Your function should return an empty list if the input search branch is empty.
-- This implementation of next function does not backtrace branches.
--List comprehension  appending the valid ajacent nodes to the branch search
next::Branch-> [Branch]
next [] = []
next branch =[(x,y): branch | (x,y) <- next_help (next_real(next_node(head(branch)))) branch ]


-- |The checkArrival function
--should return true if the current location of the robot is the destination, and false otherwise.
--Checks weather the destination node is equal to the current node
checkArrival::Node-> Node-> Bool
checkArrival destination curNode | destination == curNode = True
                                 | otherwise = False

-- Section 3 Uniformed

-- | Breadth-First Search
-- The breadthFirstSearch function should use the next function to expand a node,
-- and the checkArrival function to check whether a node is a destination position.
-- The function should search nodes using a breadth first search order.
-- Base case is if the list of branches is empty then there is no solution
-- First checks the first head node branch and checks wheather its the destination Node
--otherwise it adds the node onto the exploredList and the uses next onto the branch and appends
-- it to branches  and filters out the explored nodes
breadthFirstSearch::Node-> (Branch-> [Branch])-> [Branch]->[Node]-> Maybe Branch
breadthFirstSearch destination next [] exploredList = Nothing
breadthFirstSearch destination next (b:branches) exploredList
  |checkArrival destination (head(b)) = Just b
  |otherwise = breadthFirstSearch destination next branchexp (head(b):exploredList)
   where branchexp = branches ++ filter(\b-> notElem (head(b)) exploredList) (next(b))

-- |The depthFirstSearch function
-- is similiar to the breadthFirstSearch function,
-- except it searches nodes in a depth first search order.
--First checks wheather the braches is a empty list, if it is then return nothing
--Checks wheather the head branch node is the destination
--If it is then calls function recusively where it appends this node to the explored List
-- Branchexp is equal to next of the head branch filtering and nodes from exploredList appended with branches
depthFirstSearch::Node-> (Branch-> [Branch])-> [Branch]-> [Node]-> Maybe Branch
depthFirstSearch destination next [] exploredList = Nothing
depthFirstSearch destination next (b:branches) exploredList
  |checkArrival destination (head(b)) = Just b
  |otherwise = depthFirstSearch destination next branchexp (head(b):exploredList)
   where branchexp = filter(\b-> notElem (head(b)) exploredList) (next(b)) ++ branches



-- | Depth-Limited Search
-- The depthLimitedSearch function is similiar to the depthFirstSearch function,
-- except its search is limited to a pre-determined depth, d, in the search tree.
--Checks wheather the depth is 0, if itChecks wheather the head branch node is the destination is check wheather the head brach Node
-- is the destination node and returns the soloution otherwise returns Nothing
-- If not checks wheather the current head branch node is the destination Node
-- else calls the function recusively with d-1 until a soloution is found.
--Branchexp is equal to next of the head branch filtering and nodes from exploredList appended with branches
depthLimitedSearch::Node-> (Branch-> [Branch])-> [Branch]-> Int-> [Node]-> Maybe Branch
depthLimitedSearch destination next [] d exploredList = Nothing
depthLimitedSearch destination next (b:branches) d exploredList
  | checkArrival destination (head(b)) = Just b
  | length b > d = depthLimitedSearch destination next branches d exploredList
  | otherwise = depthLimitedSearch destination next branchexp d (head(b): exploredList)
    where branchexp = filter(\b-> notElem (head(b)) exploredList) (next(b)) ++ branches

-- | Iterative-deepening search
-- The iterDeepSearch function should initially search nodes using depth-first to depth d,
-- and should increase the depth by 1 if search is unsuccessful.
-- This process should be continued until a solution is found.
-- Checks whether the inital node is the destination Node , if it is then returns a branch with just the inital Node
-- Does depthLimitedSearch search till depth d. If it returns nothing then it recursivley calls the function again with
-- depth of d + 1
-- otherwise do the depthLimitedSearch on the next of the branches
iterDeepSearch:: Node-> (Branch-> [Branch])-> Node-> Int-> Maybe Branch
iterDeepSearch destination next initialNode d
   | checkArrival destination initialNode = Just [initialNode]
   | depthLimitedSearch destination next branchexp d [] == Nothing = iterDeepSearch destination next initialNode (d + 1)
   | otherwise = depthLimitedSearch destination next branchexp d []
    where branchexp = next [initialNode]


-- | Section 4: Informed search

-- Manhattan distance heuristic
-- This function should return the manhattan distance between the current position and the destination position.
--Takes the absolute values of the difference of x plus the absolute value of the difference of y
manhattan::Node -> Node -> Int
manhattan position destination = abs(fst(position)-fst(destination)) +abs(snd(position) -snd(destination))


-- | Best-First Search
-- The bestFirstSearch function uses the checkArrival function to check whether a node is a destination position,
-- and the heuristic function (of type Node->Int) to determine the order in which nodes are searched.
-- Nodes with a lower heuristic value should be searched before nodes with a higher heuristic value.
--Checks wheather the head of thr first branch is equal to the destination node , if it is return that branch
-- otherwise calls the function recursively adding the first node to the explored list
-- here branchexp is the branches given by calculating_heuristic and next of b while filtering out explored nodes  added to the list of branches
bestFirstSearch:: Node -> (Branch -> [Branch])-> (Node ->Int) -> [Branch] -> [Node] -> Maybe Branch
bestFirstSearch _ _ _ [] _ = Nothing
bestFirstSearch destination next heuristic (b:branches) exploredList
 |  checkArrival destination (head(b)) = Just b
 |  otherwise = bestFirstSearch destination next heuristic branchexp ((head b): exploredList)
  where branchexp = filter(\b-> notElem (head b) exploredList) [(calculating_heuristic heuristic (next b))] ++ branches


-- | A* Search
-- The aStarSearch function is similar to the bestFirstSearch function
-- except it includes the cost of getting to the state when determining the value of the node.
-- Checks wheather the head branch node is the destination
-- otherwise calls the function recusively while adding the head branch node to the exploredList
-- here branchexp is sorting the branches by the cost and sorting it by the heuristic fucntion
aStarSearch:: Node-> (Branch-> [Branch])-> (Node->Int)-> (Branch-> Int)-> [Branch]-> [Node]-> Maybe Branch
aStarSearch _ _ _ _ [] _ = Nothing
aStarSearch destination next heuristic cost (b:branches) exploredList
 |  checkArrival destination (head(b)) = Just b
 |  otherwise = aStarSearch destination next heuristic cost branchexp ((head b): exploredList)
    where branchexp = map fst (sortBy (comparing snd) (zip (branchexp1) [cost branch | branch <- branchexp1] ))
            where branchexp1 = (filter(\b-> notElem (head b) exploredList) [(calculating_heuristic heuristic (next b))] ++ branches)


-- | The cost function calculates the current cost of a trace, where each movement from one state to another has a cost of 1.
-- calulates the length of a branch
cost :: Branch-> Int
cost branch = length (branch)


-- In this section, the function determines the score of a terminal state, assigning it a value of +1, -1 or 0:
--if goal state and max player then minimax value = 1
--if goal state and min player then minimax value = -1
-- else 0
eval :: Game-> Int
eval game
 | terminal game && checkWin game maxPlayer = 1
 | terminal game && checkWin game minPlayer = -1
 | terminal game = 0

-- | The minimax function should return the minimax value of the state (without alphabeta pruning).
-- The eval function should be used to get the value of a terminal state.
---- if its a terminal state then return the evaluation
---- if the player is maxplayer then do the maximum of the next moves and call minimax recursively
---- if the player is minplayer then do th minimum of the next moves and call minimax recsively.
minimax:: Role-> Game-> Int
minimax player game
 | terminal game = eval game
 | player == maxPlayer = maximum mm
 | player == minPlayer = minimum mm
    where mm = [minimax (switch player) game | game <- moves game player]

-- | The alphabeta function should return the minimax value using alphabeta pruning.
-- The eval function should be used to get the value of a terminal state.
--checks 3 conditions
-- if the player is the human player then go to maxValue
-- if the player is the computer player then go to minValue
alphabeta:: Role-> Game-> Int
alphabeta player game
 | terminal game = eval game
 | player == maxPlayer = maxValue (-2) 2 (-2) player game
 | player == minPlayer = minValue (-2) 2 2 player game


{- Auxiliary Functions
-- Include any auxiliary functions you need for your algorithms below.
-- For each function, state its purpose and comment adequately.
-- Functions which increase the complexity of the algorithm will not get additional scores
-}

--helper function for next
--Appending the valid nodes to the input branch
next_help :: Branch -> Branch -> Branch
next_help [] ys = []
next_help (x:xs) ys | x `elem` ys = next_help xs ys
                    | otherwise = x : (next_help xs ys)

--helper function for next
--Finding all the adjacent nodes around the head of the input branch
next_node :: Node -> Branch
next_node (x,y) = [(x,y-1)] ++ [(x,y+1)] ++ [(x+1, y)] ++ [(x-1, y)]
--next_node (x,y) = [(x,y-1)] ++ [(x+1,y)] ++ [(x, y+1)] ++ [(x-1, y)]

--helper function for next
--Finding out what ajacent nodes are valid to use
next_real :: Branch -> Branch
next_real xs = [(x,y) | (x,y) <- xs , x > 0 && x< 7 && y>0 && y<7]


--helper function for bestFirstSearch and A* search
--takes a heuristic and a list of branches
-- creates a list of tuples with the branch and calculating the heuristic of the branch.
-- it then sorts out the branches by the lowest heuristic value and returns the lowest heuristic branch
calculating_heuristic :: (Node -> Int) -> [Branch] -> Branch
calculating_heuristic heuristic branches = fst $ head (sortBy (comparing snd) (zip (branches) [heuristic (head b) | b <- branches]))

--helper function for alphabeta
--checks wheather the game has ended otherwise calls setMax which determines alpha
maxValue::Int -> Int -> Int-> Role -> Game -> Int
maxValue alpha beta v player game
 | terminal game =  eval game
 | otherwise = setMax alpha beta v player (moves game player)

--helper function for alphabeta
--checks wheather the game has ended otherwise calls setMin which determines beta
minValue ::Int-> Int-> Int-> Role -> Game -> Int
minValue alpha beta v player game
 | terminal game = eval game
 | otherwise = setMin alpha beta v player (moves game player)

--helper function for alphabeta
-- checks wheather new v is greater or equal to beta then return new_v
-- here new_v takes updated v as maximum of v and minValue of the a game in list
--games
--otherwise calls setMax recursively on the list of games
setMax::Int -> Int -> Int-> Role -> [Game] -> Int
setMax alpha beta v player [] = v
setMax alpha beta v player (g:games)
 |new_v >= beta = new_v
 |otherwise = setMax (max new_v alpha) beta new_v player games
    where new_v = max v (minValue  (max v alpha) beta v (switch player) g)

--helper function for alphabeta
-- checks wheather new v is less  to alpha then return new_v
-- here new_v takes updated v as minimum of v and minValue of the a game in list
--games
-- otherwise calls setMin recursively on the list of games
setMin::Int -> Int -> Int -> Role -> [Game] -> Int
setMin alpha beta v player [] = v
setMin alpha beta v player (g:games)
 |new_v <= alpha = new_v
 |otherwise = setMin alpha (min new_v beta) new_v player games
    where new_v = min v (maxValue alpha  beta v (switch player) g)
