{-# LANGUAGE OverloadedStrings #-}
import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import qualified Data.Map as Map
import Data.Map (Map)

data Node = Node {
    left :: T.Text,
    right :: T.Text,
    value :: T.Text
} deriving (Show)

convertMap :: [T.Text] -> [(T.Text, Node)]
convertMap [] = []
convertMap (x:xs) = (ownValue, Node left right ownValue):convertMap xs
    where
        equalSign = T.splitOn " = " x
        ownValue = head equalSign
        directions = T.splitOn ", " (equalSign !! 1)
        left = T.pack $ drop 1 (T.unpack $ head directions)
        right = T.pack $ take 3 (T.unpack $ last directions)

traverseMapPart1 :: [Char] -> Int -> T.Text -> Map T.Text Node -> (T.Text, Int)
traverseMapPart1 _ acc "ZZZ" _ = ("ZZZ", acc)
traverseMapPart1 (op:ops) acc value map
    | op == 'L' = traverseMapPart1 (ops ++ ['L']) (acc+1) (left node) map
    | op == 'R' = traverseMapPart1 (ops ++ ['R']) (acc+1) (right node) map
    where
        node = map Map.! value

allOperationsThatEndsWithZ :: [T.Text] -> [T.Text]
allOperationsThatEndsWithZ [] = []
allOperationsThatEndsWithZ (x:xs)
    | last (T.unpack x) == 'A' = x:allOperationsThatEndsWithZ xs
    | otherwise = allOperationsThatEndsWithZ xs


-- Naive way. Should NOT be used since it never completes
traverseMapPart2 :: [Char] -> Int -> [T.Text] -> Map T.Text Node -> ([T.Text], Int)
traverseMapPart2 (op:ops) acc value mapSand
    | length endsWithZ == length value = (value, acc)
    | op == 'L' = traverseMapPart2 (ops ++ ['L']) (acc+1) leftNode mapSand
    | op == 'R' = traverseMapPart2 (ops ++ ['R']) (acc+1) rightNode mapSand
    where
        endsWithZ = filter (\x -> last (T.unpack x) == 'Z') value
        nodes = map (mapSand Map.!) value
        leftNode = map left nodes
        rightNode = map right nodes

traverseMap:: [Char] -> Int -> T.Text -> Map T.Text Node -> Int
traverseMap (op:ops) acc value map
    | lastValue == 'Z' = acc
    | op == 'L' = traverseMap (ops ++ ['L']) (acc+1) (left node) map
    | op == 'R' = traverseMap (ops ++ ['R']) (acc+1) (right node) map
    where
        node = map Map.! value
        lastValue = last (T.unpack value)

main :: IO()
main = do
    -- Parsing
    contents <- TIO.readFile "8.in"
    let vals = T.lines contents
    let operations = T.unpack $ head vals

    -- Part 1
    let decks = Map.fromList $ convertMap $ drop 2 vals
    print "Part 1"
    print (traverseMapPart1 operations 0 "AAA" decks)

    -- Part 2
    let allStartingOperations = allOperationsThatEndsWithZ $ Map.keys decks
    let part2Space = map (\x -> traverseMap operations 0 x decks) allStartingOperations
    print "Part 2"
    print $ foldl1 lcm part2Space