{-# LANGUAGE OverloadedStrings #-}
import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import Data.Char (isSpace)

trimLeadingSpaces :: String -> String
trimLeadingSpaces = dropWhile isSpace

getNumbers :: [T.Text] -> Int -> [[Int]]
getNumbers draw pos = map (map (read . trimLeadingSpaces . T.unpack) . trimmed) values
    where
        trimmed x = filter (/= "") (T.splitOn " " x)
        values = map (\x -> T.splitOn " | " x !! pos) draw

mapGames :: [Int] -> [Int] -> [Int]
mapGames winningNumbers = filter (`elem` winningNumbers)

part1Sol :: [[Int]] -> [[Int]] -> [Int]
part1Sol [] [] = []
part1Sol (x:xs) (y:ys) 
    | numberMatches >= 0 = numberMatches:part1Sol xs ys 
    | otherwise = -1:part1Sol xs ys 
    where 
        matchesRound = mapGames x y
        numberMatches = length matchesRound-1

countInstances :: [Int] -> [Int] -> [Int]
countInstances [] acc = acc
countInstances (winRound:resRounds) (xacc:acc) = xacc:countInstances resRounds (addCopies ++ oldCopies)
    where
        copies = winRound+1
        addCopies = map (+xacc) (take copies acc)
        oldCopies = drop copies acc

main :: IO()
main = do
    contents <- TIO.readFile "4.in"
    let vals = T.lines contents
    let turns = map (\x -> T.splitOn ": " x !! 1) vals
    let winningNumbers = getNumbers turns 0
    let ownNumbers = getNumbers turns 1
    let correctNumbers = part1Sol winningNumbers ownNumbers
    let part1 = map (2^) (filter (>=0) correctNumbers)
    print (sum part1)
    print "------------------------------"
    let part2 = countInstances correctNumbers (map (const 1) correctNumbers)
    print (sum part2)