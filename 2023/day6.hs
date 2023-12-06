{-# LANGUAGE OverloadedStrings #-}
import qualified Data.Text as T
import qualified Data.Text.IO as TIO

getDigits :: T.Text -> [Int]
getDigits x = map (read . T.unpack) digits
    where
        space = T.splitOn " " x
        digits = filter (/= "") (drop 1 space)

isValidSolution :: (Int, Int) -> Int -> Bool
isValidSolution (time, record) holdTime
    | (time - holdTime) * holdTime > record = True
    | otherwise = False

-- Naive solution
solveForOneRace :: (Int, Int) -> [Int]
solveForOneRace (time, record) = filter (isValidSolution (time, record)) [1..time]

lowerBound :: (Int, Int) -> Int -> Int
lowerBound (time, record) holdTime
    | isValidSolution (time, record) holdTime = holdTime
    | otherwise = lowerBound (time, record) (holdTime+1)

upperBound :: (Int, Int) -> Int -> Int
upperBound (time, record) holdTime
    | isValidSolution (time, record) holdTime = upperBound (time, record) (holdTime+1)
    | otherwise = holdTime

main :: IO()
main = do
    contents <- TIO.readFile "6.in"
    let vals = T.lines contents
    let digits = map getDigits vals
    let rounds = zip (head digits) (digits !! 1)
    let part1 = map (length . solveForOneRace) rounds
    print "Part 1"
    print (product part1)
    -- Part 2
    let part2Rounds = map (\x -> concat (map show x)) digits
    let part2Digit = map (\x -> read x :: Int) part2Rounds
    let part2 = (head part2Digit, part2Digit !! 1)
    let lowerBounds = lowerBound part2 1
    let upperBounds = upperBound part2 lowerBounds
    print "Part 2"
    print (upperBounds-lowerBounds)