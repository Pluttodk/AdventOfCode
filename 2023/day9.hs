{-# LANGUAGE OverloadedStrings #-}
import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import qualified Text.Read as T.Read

convertToInt :: [[T.Text]] -> [[Int]]
convertToInt = map (map (\ x -> read (T.unpack x) :: Int))

findDifference :: [Int] -> [Int]
findDifference x = zipWith (-) (tail x) x

predictForwards :: [Int] -> Int
predictForwards line
    | sum line == 0 = 0
    | otherwise = last line + predictForwards (findDifference line)

predictBackwards :: [Int] -> Int
predictBackwards line
    | sum line == 0 = 0
    | otherwise = head line - predictBackwards (findDifference line)

main :: IO()
main = do
    -- Parsing
    contents <- TIO.readFile "9.in"
    let vals = convertToInt $ map (T.splitOn " ") (T.lines contents)
    
    -- Part 1
    let part1 = sum $ map predictForwards vals
    print part1

    -- Part 2
    let part2 = sum $ map predictBackwards vals
    print part2