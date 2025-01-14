{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

{-# HLINT ignore "Use lambda-case" #-}

import Data.Char (digitToInt)
import Data.List (find, group, groupBy, nub, nubBy, sort, sortBy)
import Data.Set (Set)
import Data.Set qualified as Set
import Data.Text qualified as T
import Data.Text.IO qualified as TIO

data Direction = North | East | South | West deriving (Show, Eq)

data Node = Node
  { location :: Int,
    adjacent :: [Int],
    value :: Char
  }
  deriving (Show)

opposite :: Direction -> Direction
opposite North = South
opposite East = West
opposite South = North
opposite West = East

turn90Degree :: Direction -> Direction
turn90Degree North = East
turn90Degree East = South
turn90Degree South = West
turn90Degree West = North

turn270Degree :: Direction -> Direction
turn270Degree North = West
turn270Degree East = North
turn270Degree South = East
turn270Degree West = South

move :: Int -> Int -> Direction -> Int
move width location direction
  | direction == North = location - width
  | direction == East = location + 1
  | direction == South = location + width
  | direction == West = location - 1

convertDigitToXY :: Int -> (Int, Int) -> (Int, Int)
convertDigitToXY loc (width, height) = (loc `mod` width, loc `div` width)

convertBoardToDigit :: [T.Text] -> [Int]
convertBoardToDigit = concatMap (map digitToInt . T.unpack)

isValidMove :: Int -> Int -> Int -> Int -> Bool
isValidMove from width height loc
  | loc >= 0 && loc < width * height && abs (toX - fromX) <= 1 = True
  | otherwise = False
  where
    (fromX, fromY) = convertDigitToXY from (width, height)
    (toX, toY) = convertDigitToXY loc (width, height)

convertBoardToNode :: [Char] -> Int -> (Int, Int) -> [Node]
convertBoardToNode board loc (width, height)
  | loc < width * height = Node loc areAdjecentIncreasing (board !! loc) : convertBoardToNode board (loc + 1) (width, height)
  | otherwise = []
  where
    (x, y) = convertDigitToXY loc (width, height)
    moveNorth = move width loc North
    moveEast = move width loc East
    moveSouth = move width loc South
    moveWest = move width loc West
    validMoves = filter (isValidMove loc width height) [moveNorth, moveEast, moveSouth, moveWest]
    areAdjecentIncreasing = filter (\x -> (board !! loc) == board !! x) validMoves

findAllAdjecent :: [Node] -> Int -> Set Int -> Set Int
findAllAdjecent nodes loc acc
  | null (adjacent (nodes !! loc)) || null notVisited = Set.insert loc acc
  | otherwise = foldr (\x a -> findAllAdjecent nodes x (Set.insert loc a)) acc notVisited
  where
    notVisited = filter (`Set.notMember` acc) (adjacent (nodes !! loc))

groupNodes :: [Node] -> [Node] -> Set Int -> [[Node]]
groupNodes _ [] _ = []
groupNodes org (n : ns) visited
  | location n `Set.member` visited = groupNodes org ns visited
  | otherwise =
      let adjNodes = Set.toList $ findAllAdjecent org (location n) Set.empty
       in map (org !!) adjNodes : groupNodes org ns (Set.union visited (Set.fromList adjNodes))

calcPerimeter :: [Node] -> Int
calcPerimeter = foldr (\n -> (+) (4 - length (adjacent n))) 0

calcDirection :: Int -> Int -> Int -> Direction
calcDirection width from to
  | from - to == width = North
  | from - to == -width = South
  | from - to == 1 = West
  | from - to == -1 = East

-- Calculates the move going through from and to
calculateSquare :: Direction -> Direction -> Direction
calculateSquare from to
  | from == North && to == East = South
  | from == North && to == West = East
  | from == East && to == North = West
  | from == East && to == South = North
  | from == South && to == East = North
  | from == South && to == West = East
  | from == West && to == North = East
  | from == West && to == South = North

calcDegrees :: [Node] -> Int -> Int -> Int -> Int -> Int -> Int
calcDegrees org width height from current to
  | from == to = 0
  | directionFrom == directionTo = 0
  | directionFrom == opposite directionTo = 0
  | (directionFrom == turn90Degree directionTo || directionFrom == turn270Degree directionTo) && hasLoop = 1
  | directionFrom == turn90Degree directionTo || directionFrom == turn270Degree directionTo = 2
  | otherwise = 0
  where
    directionFrom = calcDirection width from current
    directionTo = calcDirection width current to
    doubleMove = move width (move width current directionFrom) directionTo
    toAdj = adjacent (org !! to)
    fromAdj = adjacent (org !! current)
    hasLoop = any (\x -> x `elem` toAdj && x /= current) fromAdj

moveDiagonally :: Int -> Int -> Direction -> Int
moveDiagonally width location direction
  | direction == North = location - width - 1
  | direction == East = location + 1 + width
  | direction == South = location + width + 1
  | direction == West = location - 1 - width

-- Traverse a Node and if it turns 90 or 270 degrees add 2 corners to the corners
countCorners :: [Node] -> [Node] -> Int -> Int -> Int
countCorners org [] _ _ = 0
countCorners org (n : ns) width height
  | length adj == 2 = calcDegrees org width height (head adj) (location n) (last adj) + countCorners org ns width height
  | length adj == 4 = 4 + countCorners org ns width height
  | length adj == 1 = 2 + countCorners org ns width height
  | length adj == 3 = calcDegrees org width height (head adj) (location n) (last adj) + calcDegrees org width height (head adj) (location n) (adj !! 1) + calcDegrees org width height (adj !! 1) (location n) (last adj) + countCorners org ns width height
  | null adj = 4 + countCorners org ns width height
  -- If below, left and right and
  | otherwise = countCorners org ns width height
  where
    adj = adjacent n
    loc = location n

getValue :: [Node] -> Int -> Char
getValue nodes loc = value (nodes !! loc)

-- Find all nodes that have no adjecent north nodes
findNorthNodes :: [Node] -> Int -> [Node]
findNorthNodes nodes width = filter (\x -> not (any (\y -> y == move width (location x) North) (adjacent x))) nodes

updateAdjWithOnlyNodes :: [Node] -> [Int] -> [Node]
updateAdjWithOnlyNodes [] _ = []
updateAdjWithOnlyNodes (n : ns) onlyNodes = Node (location n) adjInOnlyNodes (value n) : updateAdjWithOnlyNodes ns onlyNodes
  where
    adjInOnlyNodes = filter (`elem` onlyNodes) (adjacent n)

findSouthNodes :: [Node] -> Int -> [Node]
findSouthNodes nodes width = filter (\x -> not (any (\y -> y == move width (location x) South) (adjacent x))) nodes

findEastNodes :: [Node] -> Int -> [Node]
findEastNodes nodes width = filter (\x -> not (any (\y -> y == move width (location x) East) (adjacent x))) nodes

findWestNodes :: [Node] -> Int -> [Node]
findWestNodes nodes width = filter (\x -> not (any (\y -> y == move width (location x) West) (adjacent x))) nodes

findAllUniqueYs :: [Node] -> Int -> [Int]
findAllUniqueYs nodes width = nub $ map ((\x -> snd (convertDigitToXY x (width, length nodes))) . location) nodes

findAllUniqueXs :: [Node] -> Int -> [Int]
findAllUniqueXs nodes width = nub $ map ((\x -> fst (convertDigitToXY x (width, length nodes))) . location) nodes

findAllUniqueNorthFacingSides :: [Node] -> Int -> Int
findAllUniqueNorthFacingSides nodes width = do
  let allNorth = findNorthNodes nodes width
  let newNodes = updateAdjWithOnlyNodes allNorth (map location allNorth)
  let newLocations = map location newNodes
  let fillEmptyNewNodes = [if x `elem` newLocations then find (\y -> location y == x) newNodes else Just (Node (x) [] ' ') | x <- [0 .. (maximum newLocations)]]
  let removeMaybe = map (\x -> case x of Just y -> y; Nothing -> Node 0 [] ' ') fillEmptyNewNodes
  let p2 = groupNodes removeMaybe removeMaybe Set.empty
  let removeValueEmpty = filter (not . null) $ map (filter (\y -> value y /= ' ')) p2
  length removeValueEmpty

findAllUniqueSouthFacingSides :: [Node] -> Int -> Int
findAllUniqueSouthFacingSides nodes width = do
  let allSouth = findSouthNodes nodes width
  let newNodes = updateAdjWithOnlyNodes allSouth (map location allSouth)
  let newLocations = map location newNodes
  let fillEmptyNewNodes = [if x `elem` newLocations then find (\y -> location y == x) newNodes else Just (Node (x) [] ' ') | x <- [0 .. (maximum newLocations)]]
  let removeMaybe = map (\x -> case x of Just y -> y; Nothing -> Node 0 [] ' ') fillEmptyNewNodes
  let p2 = groupNodes removeMaybe removeMaybe Set.empty
  let removeValueEmpty = filter (not . null) $ map (filter (\y -> value y /= ' ')) p2
  length removeValueEmpty

findAllUniqueEastFacingSides :: [Node] -> Int -> Int
findAllUniqueEastFacingSides nodes width = do
  let allEast = findEastNodes nodes width
  let newNodes = updateAdjWithOnlyNodes allEast (map location allEast)
  let newLocations = map location newNodes
  let fillEmptyNewNodes = [if x `elem` newLocations then find (\y -> location y == x) newNodes else Just (Node (x) [] ' ') | x <- [0 .. (maximum newLocations)]]
  let removeMaybe = map (\x -> case x of Just y -> y; Nothing -> Node 0 [] ' ') fillEmptyNewNodes
  let p2 = groupNodes removeMaybe removeMaybe Set.empty
  let removeValueEmpty = filter (not . null) $ map (filter (\y -> value y /= ' ')) p2
  length removeValueEmpty

findAllUniqueWestFacingSides :: [Node] -> Int -> Int
findAllUniqueWestFacingSides nodes width = do
  let allWest = findWestNodes nodes width
  let newNodes = updateAdjWithOnlyNodes allWest (map location allWest)
  let newLocations = map location newNodes
  let fillEmptyNewNodes = [if x `elem` newLocations then find (\y -> location y == x) newNodes else Just (Node (x) [] ' ') | x <- [0 .. (maximum newLocations)]]
  let removeMaybe = map (\x -> case x of Just y -> y; Nothing -> Node 0 [] ' ') fillEmptyNewNodes
  let p2 = groupNodes removeMaybe removeMaybe Set.empty
  let removeValueEmpty = filter (not . null) $ map (filter (\y -> value y /= ' ')) p2
  length removeValueEmpty

findAllUniqueSides :: Int -> [Node] -> Int
findAllUniqueSides width n = findAllUniqueNorthFacingSides n width + findAllUniqueSouthFacingSides n width + findAllUniqueEastFacingSides n width + findAllUniqueWestFacingSides n width

main :: IO ()
main = do
  contents <- TIO.readFile "12.in"
  let board = T.lines contents
  let width = length $ T.unpack (head board)
  let height = length board
  let boardChar = concatMap T.unpack board
  let nodes = convertBoardToNode boardChar 0 (width, height)
  print (length nodes)
  print $ findAllAdjecent nodes 0 Set.empty

  let grouped = groupNodes nodes nodes Set.empty
  --   let distincedGroups = map (nubBy (\x y -> location x == location y)) grouped
  --   let values = (map (\x -> calcPerimeter x * length x) distincedGroups)
  --   print values
  --   print $ sum values
  --   print "Part 1"
  --   print (grouped !! 0)
  --   let g1 = (grouped !! 0) !! 0
  --   let adj = adjacent g1
  --   print ((head adj), (location g1), (last adj))
  --   print (calcDegrees nodes width height (head adj) (location g1) (last adj))
  --   let g1 = (grouped !! 0) !! 1
  --   let adj = adjacent g1
  --   print ((head adj), (location g1), (last adj))
  --   print (calcDegrees nodes width height (head adj) (location g1) (last adj))
  --   let g1 = (grouped !! 0) !! 2
  --   let adj = adjacent g1
  --   print ((head adj), (location g1), (last adj))
  --   print (calcDegrees nodes width height (head adj) (location g1) (last adj))
  --   let g1 = (grouped !! 0) !! 3
  --   let adj = adjacent g1
  --   print ((head adj), (location g1), (last adj))
  --   print (calcDegrees nodes width height (head adj) (location g1) (last adj))

  --   let from = 0
  --   let current = 4
  --   let to = 5
  --   print $ calcDegrees nodes width height 0 4 5
  --   print $ calcDirection width from current
  --   print $ calcDirection width current to
  --   let squareMove = calculateSquare (calcDirection width from current) (calcDirection width current to)
  --   print squareMove
  --   let allInSquare = filter (from ==) (adjacent (nodes !! move width to squareMove))
  --   print allInSquare
  -- let allNorth = findNorthNodes (grouped !! 0) width
  -- let newNodes = updateAdjWithOnlyNodes allNorth (map location allNorth)
  -- let newLocations = map location newNodes
  -- let fillEmptyNewNodes = [if x `elem` newLocations then find (\y -> location y == x) newNodes else Just (Node (x) [] ' ') | x <- [0 .. (maximum newLocations)]]
  -- let removeMaybe = map (\x -> case x of Just y -> y; Nothing -> Node 0 [] ' ') fillEmptyNewNodes
  -- let p2 = groupNodes removeMaybe removeMaybe Set.empty
  -- let removeValueEmpty = filter (not . null) $ map (filter (\y -> value y /= ' ')) p2
  -- print removeValueEmpty
  -- print $ length removeValueEmpty
  let p2 = map (\x -> findAllUniqueSides width x * length x) grouped
  print p2
  print $ sum p2
  print "Part 2"