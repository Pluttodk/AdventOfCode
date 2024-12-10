{-# LANGUAGE OverloadedStrings #-}

import Data.List (nub, group, elemIndex)
import Data.Text qualified as T
import Data.Text.IO qualified as TIO
import Data.Char (digitToInt)
import qualified Data.Map as M

-- Part 1
moveFilesCount :: [Int] -> [Int] -> Int -> [Int]
moveFilesCount [] _ _ = []
moveFilesCount _ [] _ = []
moveFilesCount org revFiltered blank
    | all (== -1) org = []
    | head org == -1 = moveFilesCount (tail org) revFiltered (blank+1)
    | null (drop blank revFiltered) = take blank revFiltered
    | otherwise = take blank revFiltered ++ [head org] ++ moveFilesCount (tail org) (init $ drop blank revFiltered) 0

-- Part 2

removeValue :: [Int] -> Int -> [Int]
removeValue [] _ = []
removeValue (r:rs) value
    | r == value = -1:removeValue rs value
    | otherwise = r:removeValue rs value

moveFilesReverse :: [Int] -> [(Int, [Int])] -> Int -> M.Map Int Int -> [Int]
moveFilesReverse system [] _ _ = system
moveFilesReverse system ((fileIdx, file):files) idx lengthMap
    | idx >= length system = moveFilesReverse system files 0 lengthMap
    | idx < fileIdx && all (== -1) (take vals_behind currentSystem) && M.member (length nextFile) lengthMap = moveFilesReverse newSystem files minimumIdx updatedMap
    | idx < fileIdx && all (== -1) (take vals_behind currentSystem) = moveFilesReverse newSystem files 0 updatedMap
    | otherwise = moveFilesReverse system ((fileIdx, file):files) (idx+1) lengthMap
    where
        removedSystem = removeValue system (head file)
        currentSystem = drop idx system
        vals_behind = length file
        newSystem = take idx removedSystem ++ file ++ drop (idx + vals_behind) removedSystem
        (_, nextFile) = head files
        minimumIdx = lengthMap M.! length nextFile
        updatedMap = M.insert (length file) idx lengthMap

rev :: (Eq a, Num a) => [a] -> [a]
rev a = reverse (filter (/= -1) a)

convertDiskMap :: [Int] -> Int -> Int -> [Int]
convertDiskMap [] _ _ = []
convertDiskMap (r:rs) iteration position
    | even position = replicate (read (show r)) iteration ++ convertDiskMap rs iteration (position+1)
    | otherwise = replicate (read (show r)) (-1) ++ convertDiskMap rs (iteration+1) (position+1)


calcCheckSum :: [Int] -> Int -> Int
calcCheckSum [] _ = 0
calcCheckSum (-1:rs) position = calcCheckSum rs (position+1)
calcCheckSum (r:rs) position = r*position + calcCheckSum rs (position+1)

inputTest :: [Int]
inputTest = [2,3,3,3,1,3,3,1,2,1,4,1,4,1,3,1,4,0,2]

findIndex :: [[Int]] -> [Int] -> [(Int, [Int])]
findIndex [] _ = []
findIndex (file:files) system = (pos, file):findIndex files system
    where
        (Just pos) = elemIndex (head file) system

main :: IO ()
main = do
    -- Load data
  contents <- TIO.readFile "9.in"
  let vals = map digitToInt (T.unpack contents)
  let solutionP1 = convertDiskMap vals 0 0
  let moveBlocks = moveFilesCount solutionP1 (rev solutionP1) 0
  let checkSum = calcCheckSum moveBlocks 0
  print checkSum
  print "Part 2"
  let groups = findIndex (group (rev solutionP1)) solutionP1
  let p2 = moveFilesReverse solutionP1 groups 0 M.empty
  print (length p2)
  print $ calcCheckSum p2 0

