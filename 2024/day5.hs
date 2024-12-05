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

part1Middle :: [Bool] -> [[Int]] -> Int
part1Middle [] _ = 0
part1Middle (isValid:restValid) (x:xs)
    | isValid && middleIndex < length x = (x !! middleIndex) + part1Middle restValid xs
    | otherwise = part1Middle restValid xs
    where 
        middleIndex = length x `div` 2

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