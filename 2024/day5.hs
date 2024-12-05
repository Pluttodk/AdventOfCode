{-# LANGUAGE OverloadedStrings #-}

import Data.Text qualified as T
import Data.Text.IO qualified as TIO

isUpdateInRule :: T.Text -> [T.Text] -> Bool
isUpdateInRule check [] = False
isUpdateInRule check (x:xs)
    | check == x = True
    | otherwise = isUpdateInRule check xs

compareUpdate :: Int -> Int -> [Int] -> [T.Text] -> Bool
compareUpdate idxMain idxComp values rules
    | idxMain >= length values = True
    | idxComp >= length values = compareUpdate (idxMain+1) 0 values rules
    | isUpdateInRule asRule rules && idxMain > idxComp = False
    | otherwise = compareUpdate idxMain (idxComp+1) values rules
    where
        valueMain = values !! idxMain
        valuesComp = values !! idxComp
        asRule = T.intercalate "|" [T.pack (show valueMain), T.pack (show valuesComp)]

updatesToInt :: [[T.Text]] -> [[Int]]
updatesToInt = foldr ((:) . map (read . T.unpack)) [[]]

findMiddle :: [[Int]] -> Int
findMiddle []  = 0
findMiddle (x:xs)
    | middleIndex < length x = (x !! middleIndex) + findMiddle xs
    | otherwise = findMiddle xs
    where
        middleIndex = length x `div` 2

part1Middle :: [Bool] -> [[Int]] -> Int
part1Middle [] _ = 0
part1Middle (isValid:restValid) (x:xs)
    | isValid && middleIndex < length x = (x !! middleIndex) + part1Middle restValid xs
    | otherwise = part1Middle restValid xs
    where
        middleIndex = length x `div` 2

part2Filter :: [Bool] -> [[Int]] -> [[Int]]
part2Filter [] _ = []
part2Filter (isValid:restValid) (x:xs)
    | isValid = part2Filter restValid xs
    | otherwise = x : part2Filter restValid xs

swap :: Int -> Int -> [Int] -> [Int]
swap i j xs = 
    let elemI = xs !! i
        elemJ = xs !! j
    in take i xs ++ [elemJ] ++ drop (i + 1) (take j xs ++ [elemI] ++ drop (j + 1) xs)

flipValues :: Int -> Int -> [Int] -> [T.Text] -> [Int]
flipValues idxMain idxComp values rules
    | idxMain >= length values = values
    | idxComp >= length values = flipValues (idxMain+1) 0 values rules
    | isUpdateInRule asRule rules && idxMain > idxComp = flipValues 0 0 swappedValues rules
    | otherwise = flipValues idxMain (idxComp+1) values rules
    where
        valueMain = values !! idxMain
        valuesComp = values !! idxComp
        asRule = T.intercalate "|" [T.pack (show valueMain), T.pack (show valuesComp)]
        swappedValues = swap idxComp idxMain values

main :: IO ()
main = do
  contents <- TIO.readFile "5.in"
  let [rules, updates] = T.splitOn "\n\n" contents
  let rulesMap = T.lines rules
  let updatesLines = T.lines updates
  let updatesValues = updatesToInt (map (T.splitOn ",") updatesLines)
  let part1 = map (\x -> compareUpdate 0 0 x rulesMap) updatesValues
  let part1Score = part1Middle part1 updatesValues
  print part1
  print part1Score
  print "Part 1"

  let part2 = part2Filter part1 updatesValues
  let part2Values = map (\x -> flipValues 0 0 x rulesMap) part2
  let part2Middle = map (\x -> x !! length x `div` 2) part2Values
  print part2Values
  print (findMiddle part2Values)
  print "Part 2"