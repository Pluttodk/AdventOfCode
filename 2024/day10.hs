{-# LANGUAGE OverloadedStrings #-}

import Data.Char (digitToInt)
import Data.List (nub)
import Data.Sequence qualified as Seq
import Data.Set qualified as Set
import Data.Text qualified as T
import Data.Text.IO qualified as TIO
import GHC.CmmToAsm.AArch64.Instr (x0)

data Direction = North | East | South | West deriving (Show, Eq)

data Node = Node
  { location :: Int,
    adjacent :: [Int],
    value :: Int
  }
  deriving (Show)

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

convertBoardToNode :: [Int] -> Int -> (Int, Int) -> [Node]
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
    areAdjecentIncreasing = filter (\x -> (board !! loc) + 1 == board !! x) validMoves

findAllElementsOfIdx :: [Int] -> Int -> Int -> [Int]
findAllElementsOfIdx [] _ _ = []
findAllElementsOfIdx (x : xs) idx pos
  | x == idx = pos : findAllElementsOfIdx xs idx (pos + 1)
  | otherwise = findAllElementsOfIdx xs idx (pos + 1)

bfs :: [Node] -> Int -> Int -> Bool
bfs nodes start end = bfs' (Seq.singleton start) Set.empty
  where
    nodeMap = map (\node -> (location node, node)) nodes
    nodeLookup loc = lookup loc nodeMap
    bfs' Seq.Empty _ = False
    bfs' (current Seq.:<| queue) visited
      | current == end = True
      | current `Set.member` visited = bfs' queue visited
      | otherwise = case nodeLookup current of
          Nothing -> bfs' queue visited
          Just node -> bfs' (queue Seq.>< Seq.fromList (adjacent node)) (Set.insert current visited)

part1 :: [Node] -> Int -> [Int] -> Int
part1 _ _ [] = 0
part1 nodes start (end : ys)
  | bfs nodes start end = 1 + part1 nodes start ys
  | otherwise = part1 nodes start ys

findAllAdjecent :: [Node] -> Int -> [Int]
findAllAdjecent nodes loc
  | null (adjacent (nodes !! loc)) = []
  | otherwise = adjacent (nodes !! loc) ++ concatMap (findAllAdjecent nodes) (adjacent (nodes !! loc))

main :: IO ()
main = do
  contents <- TIO.readFile "10.in"
  let board = T.lines contents
  let width = length $ T.unpack (head board)
  let height = length board
  let boardAsDigit = convertBoardToDigit board
  let nodes = convertBoardToNode boardAsDigit 0 (width, height)
  let allZeros = findAllElementsOfIdx boardAsDigit 0 0
  let allNines = findAllElementsOfIdx boardAsDigit 9 0
  let p1 = map (\x -> part1 nodes x allNines) allZeros
  --   let possibleNodes = map (nodes !!) (findAllAdjecent nodes (allZeros !! 8))
  --   let filteredNodes = map (\x -> convertDigitToXY (location x) (width, height)) possibleNodes
  --   print (nub filteredNodes)

  --   print nodes
  --   print allZeros
  --   print allNines
  print p1
  print $ sum p1
  print "Part 1"
