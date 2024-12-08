{-# LANGUAGE OverloadedStrings #-}

import Data.List (nub)
import Data.Text qualified as T
import Data.Text.IO qualified as TIO

-- General helper functions for finding coordinates
findCoordinates :: Char -> [T.Text] -> [(Int, Int)]
findCoordinates value textGrid =
    concatMap findInRow (zip [0..] textGrid)
  where
    findInRow (rowIndex, line) =
        [(rowIndex, colIndex) | (colIndex, char) <- zip [0..] (T.unpack line), char == value]

-- Move coordinates to a new location
moveCoordinates :: (Int, Int) -> (Int, Int) -> (Int, Int)
moveCoordinates (fromX, fromY) (toX, toY) = (toX+distX, toY+distY)
    where
        distX = toX - fromX
        distY = toY - fromY

-- Check the validity for location. Is used partially later on when parsing
isValidPoint :: Int -> Int -> (Int, Int) -> Bool
isValidPoint width height (x,y) = x>=0 && x < width && y>=0 && y < height

-- Part 1
findAllPoints :: ((Int, Int) -> Bool) -> [(Int, Int)] -> [(Int, Int)]
findAllPoints checkValid (a:b:rs)
    | aValid && bValid = aMove:bMove:rest
    | aValid = aMove:rest
    | bValid = bMove:rest
    | otherwise = rest
    where
        aMove = moveCoordinates a b
        bMove = moveCoordinates b a
        aValid = checkValid aMove
        bValid = checkValid bMove
        rest = findAllPoints checkValid (a:rs) ++ findAllPoints checkValid (b:rs)
findAllPoints _ _ = []

-- Part 2
moveCoordinatesAll :: ((Int, Int) -> Bool) -> (Int, Int) -> (Int, Int) -> [(Int, Int)]
moveCoordinatesAll checkValid a b
    | checkValid movePoint = a:b:movePoint : moveCoordinatesAll checkValid b movePoint
    | otherwise = []
    where movePoint = moveCoordinates a b

findAllPointsP2 :: ((Int, Int) -> Bool) -> [(Int, Int)] -> [(Int, Int)]
findAllPointsP2 checkValid (a:b:rs) = aMove ++ bMove ++ rest
    where
        aMove = moveCoordinatesAll checkValid a b
        bMove = moveCoordinatesAll checkValid b a
        rest = findAllPointsP2 checkValid (a:rs) ++ findAllPointsP2 checkValid (b:rs)
findAllPointsP2 _ (a:rs) = [a]
findAllPointsP2 _ _ = []

main :: IO ()
main = do
    -- Load data
  contents <- TIO.readFile "8.in"
  let lines = map T.unpack (T.lines contents)
  let characters = ['0'..'9'] ++ ['a'..'z'] ++ ['A'..'Z']
  let coordinates = map (\x -> findCoordinates x (T.lines contents)) characters
  let checkValid = isValidPoint (length lines) (length (head lines))
  -- Part 1
  let p1 = nub $ concatMap (findAllPoints checkValid) coordinates
  print coordinates
  print $ length p1
  print "Part 1"
  -- Part 2
  let p2 = nub (concatMap (findAllPointsP2 checkValid) coordinates)
  print $ length p2
  print "part 2"