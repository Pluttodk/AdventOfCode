{-# LANGUAGE OverloadedStrings #-}

import Data.ByteString (find)
import Data.Text qualified as T
import Data.Text.IO qualified as TIO

checkHorizontal :: [[Char]] -> String -> (Int, Int) -> Int
checkHorizontal grid word (x, y)
  | take 4 (drop x (grid !! y)) == word = 1
  | otherwise = 0

flipGrid :: [[Char]] -> [[Char]]
flipGrid grid = [map (!! i) grid | i <- [0 .. length (head grid) - 1]]

risingDiagonal :: [[Char]] -> [[Char]]
risingDiagonal grid =
  [ [grid !! (i - k) !! (j + k) | k <- [0..min i (width - j - 1)]] | i <- [0 .. height - 1], j <- [0 .. width - 1], j == 0 || i == height - 1]
  where
    height = length grid
    width = length (head grid)
fallingDiagonal :: [[Char]] -> [[Char]]
fallingDiagonal grid =
  [ [grid !! (i + k) !! (j + k) | k <- [0..min (height - i - 1) (width - j - 1)]] | i <- [0 .. height - 1], j <- [0 .. width - 1], j == 0 || i == 0]
  where
    height = length grid
    width = length (head grid)

part1 :: [[Char]] -> String -> (Int, Int) -> Int
part1 grid word (x, y)
  | y == length grid = 0
  | x == length (grid !! y) = part1 grid word (0, y + 1)
  | otherwise = checkHorizontal grid word (x, y) + part1 grid word (x + 1, y)

part2 :: [[Char]] -> (Int, Int) -> Int -> Int
part2 grid (x, y) acc
  | (y + 1) >= length grid = acc
  | (x + 1) >= length (head grid) = part2 grid (1, y + 1) acc
  | grid !! y !! x == 'A'
    && length (filter id [masDiagDown, masDiagUp, masDiagDownRev, masDiagUpRev]) >= 2 = part2 grid (x + 1, y) (acc + 1)
  | otherwise = part2 grid (x + 1, y) acc
    where
        masDiagUp = grid !! (y - 1) !! (x - 1) == 'M' && grid !! (y + 1) !! (x + 1) == 'S'
        masDiagDown = grid !! (y + 1) !! (x - 1) == 'M' && grid !! (y - 1) !! (x + 1) == 'S'
        masDiagUpRev = grid !! (y - 1) !! (x + 1) == 'M' && grid !! (y + 1) !! (x - 1) == 'S'
        masDiagDownRev = grid !! (y + 1) !! (x + 1) == 'M' && grid !! (y - 1) !! (x - 1) == 'S'

main :: IO ()
main = do
  contents <- TIO.readFile "4.in"
  let lines = map T.unpack (T.lines contents)
  let verticalGrid = flipGrid lines
  -- Concat to large line
  let allLines = lines ++ verticalGrid ++ risingDiagonal lines ++ fallingDiagonal lines
  let p1 = part1 allLines "XMAS" (0, 0) + part1 allLines "SAMX" (0, 0)
  let p2 = part2 lines (1, 1) 0
  print p1
  print "Part 1"
  print p2
  print "Part 2"