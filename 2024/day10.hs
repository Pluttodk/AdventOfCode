{-# LANGUAGE OverloadedStrings #-}

import Data.Char (digitToInt)
import Data.List (group, groupBy, nub, sort, sortBy)
import Data.Text qualified as T
import Data.Text.IO qualified as TIO

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

-- Good old classic DFS. Finds all path from a zero to a nine
findAllAdjecent :: [Node] -> Int -> [Int] -> [Int]
findAllAdjecent nodes loc acc
  | null (adjacent (nodes !! loc)) && value (nodes !! loc) == 9 = acc ++ [loc]
  | null (adjacent (nodes !! loc)) = []
  | otherwise = concatMap (\x -> findAllAdjecent nodes x (acc ++ [loc])) (adjacent (nodes !! loc))

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
  let allPath = map (\x -> findAllAdjecent nodes x []) allZeros

  -- For each path count the number of allNines that are
  let doesNineExist = map (\x -> sum $ map (\y -> if y `elem` x then 1 else 0) allNines) allPath :: [Int]
  --   let p1 = map (\x )
  print doesNineExist
  print $ sum doesNineExist
  print "Part 1"

  let allNodes = map (map (nodes !!)) allPath
  let sortedNodes = map (sortBy (\a b -> compare (location a) (location b))) allNodes
  let groupedNodes = map (groupBy (\a b -> location a == location b)) sortedNodes
  let largestGroup = map (maximum . map length) groupedNodes
  print largestGroup
  print $ sum largestGroup
  print "Part 2"
