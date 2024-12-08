{-# LANGUAGE OverloadedStrings #-}

import Data.Text qualified as T
import Data.Text.IO qualified as TIO

data Point = Point {
    x ::Int,
    y :: Int
 } deriving (Show, Eq)

findCoordinates :: Char -> [T.Text] -> [(Int, Int)]
findCoordinates value textGrid =
    concatMap findInRow (zip [0..] textGrid)
  where
    findInRow (rowIndex, line) =
        [(rowIndex, colIndex) | (colIndex, char) <- zip [0..] (T.unpack line), char == value]

moveCoordinates :: (Int, Int) -> (Int, Int) -> (Int, Int)
moveCoordinates (fromX, fromY) (toX, toY) = (toX+distX, toY+distY)
    where
        distX = toX - fromX
        distY = toY - fromY

isValidPoint :: Int -> Int -> (Int, Int) -> Bool
isValidPoint width height (x,y) = x>=0 && x < width && y>=0 && y < height

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


main :: IO ()
main = do
  contents <- TIO.readFile "8.in"
  let lines = map T.unpack (T.lines contents)
  let characters = ['0'..'9'] ++ ['a'..'z'] ++ ['A'..'Z']
  let coordinates = map (\x -> findCoordinates x (T.lines contents)) characters
  let checkValid = isValidPoint (length lines) (length (head lines))
  let p1 = concatMap (findAllPoints checkValid) coordinates
  print coordinates
  print p1
  print "Part 1"