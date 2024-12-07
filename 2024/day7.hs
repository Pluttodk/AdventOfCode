{-# LANGUAGE OverloadedStrings #-}

import Data.Text qualified as T
import Data.Text.IO qualified as TIO

recursiveCallibration :: Int -> [Int] -> Bool -> Bool
recursiveCallibration testValue [a] isPart2 = testValue == a
recursiveCallibration testValue (a:b:xs) isPart2
    | isPart2 = add || mult || con
    | otherwise = add || mult
    where
        add = recursiveCallibration testValue (a+b:xs) isPart2
        mult = recursiveCallibration testValue (a*b:xs) isPart2
        c = read (show a ++ show b) :: Int 
        con = recursiveCallibration testValue (c:xs) isPart2

solution :: Bool -> T.Text-> Int
solution  isPart2 lines
    | recursiveCallibration testValue calibration isPart2 = testValue
    | otherwise = 0
    where
        [value, numbers] = T.splitOn ": " lines
        testValue = read (T.unpack value)
        calibration = map (read . T.unpack) (T.splitOn " " numbers)

main :: IO ()
main = do
  contents <- TIO.readFile "7.in"
  let lines = T.lines contents
  let p1 = map (solution False) lines
  print (sum p1)
  print "Part 1"
  let p2 = map (solution True) lines
  print (sum p2)
  print "Part 2"
