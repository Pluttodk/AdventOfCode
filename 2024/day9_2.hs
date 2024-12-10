{-# LANGUAGE OverloadedStrings #-}

import Data.Text qualified as T
import Data.Text.IO qualified as TIO
import Data.Char (digitToInt)
import Data.List (elemIndex)

-- The none Naive way (but still slightly naive...)

vals :: [Int]
vals = [2,3,3,3,1,3,3,1,2,1,4,1,4,1,3,1,4,0,2] ++ [0]

valsWithIdx :: Int -> [Int] -> [(Int, Int)]
valsWithIdx _ [] = []
valsWithIdx pos [a] = [(pos,a)]
valsWithIdx pos (a:b:rs) = (pos, a):(-1, b):valsWithIdx (pos+1) rs

findSpace :: (Int, Int) -> [(Int,Int)] -> Int -> Int -> [(Int,Int)]
findSpace (scoreMove, length) ((score, filled):(_, free):rs) idx pos
    | idx == pos = (scoreMove, length):(-1, free):rs
    | free >= length = (score, filled):(-1,0):(scoreMove, length):(-1, free-length):rs
    | otherwise = (score, filled):(-1,free):findSpace (scoreMove, length) rs idx (pos+2)

replaceValue :: (Int, Int) -> [(Int,Int)] -> [(Int,Int)]
replaceValue (scoreA, lengthA) ((scoreR, lengthR):rs)
    | scoreA == scoreR = (-1, lengthA):rs
    | otherwise = (scoreR, lengthR):replaceValue (scoreA, lengthA) rs

moveAround :: Int -> [(Int, Int)] -> [(Int, Int)]
moveAround idx a = findSpace memory replaced idx 0
    where
        freeSpaceBehind = last a
        memory = last (init a)
        replaced = replaceValue memory a

replacedLocation :: [(Int, Int)] -> [(Int, Int)]
replacedLocation [] = []
replacedLocation (r:rs)
    | fst r == -1 = replacedLocation rs
    | otherwise = r:replacedLocation rs

solution :: [(Int, Int)] -> [(Int, Int)] -> [(Int, Int)]
solution [] board = board
solution locations board = solution (init locations) (findSpace elementToCheckFor replaced idx 0)
    where
        elementToCheckFor = last locations
        Just idx = elemIndex (last locations) board
        replaced = replaceValue elementToCheckFor board

checkSum :: [(Int, Int)] -> [Int]
checkSum [] =[]
checkSum ((-1, length):rs) = replicate length (-1) ++ checkSum rs
checkSum ((score, length):rs) = replicate length score ++ checkSum rs

calcCheckSum :: [Int] -> Int -> Int
calcCheckSum [] _ = 0
calcCheckSum (-1:rs) position = calcCheckSum rs (position+1)
calcCheckSum (r:rs) position = r*position + calcCheckSum rs (position+1)


main :: IO ()
main = do
    -- Load data
  contents <- TIO.readFile "9.in"
  let vals = map digitToInt (T.unpack contents) ++ [0]
  let board = valsWithIdx 0 vals
  let part2 = checkSum $ solution (replacedLocation board) board
  print $ calcCheckSum part2 0