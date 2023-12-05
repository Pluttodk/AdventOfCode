{-# LANGUAGE OverloadedStrings #-}
import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import Data.Map (Map)
import qualified Data.Map as Map

data Shifted = Shifted {
    original:: Int,
    shifted:: Int,
    amount:: Int
} deriving (Show)

-- Create data type of a source (String), destination (String), and three [Int]s
data Instruction = Instruction { source :: T.Text
                               , destination :: T.Text
                               , spans :: [Shifted]
                               } deriving (Show)

findValue :: Int -> Shifted -> Int
findValue val (Shifted original shifted amount)
    | val < original+amount && val >= original = shifted + (val-original)
    | otherwise = val

findShifted :: Int -> [Shifted] -> Int
findShifted val [] = val
findShifted val (x:xs) 
    | nextValue == val = findShifted val xs
    | otherwise = findValue val x
    where 
        nextValue = findValue val x

-- Convert lines of "Start ActualValue Iterations" to override spans
-- 50 98 2 => [49, 98, 99, 52]
overrideSpans :: T.Text -> [Int] -> [Int]
overrideSpans x oldSpan = take (start) oldSpan ++ values ++ tailOldSpan
    where
        digits = map (\x -> read (T.unpack x)) (T.splitOn " " x)
        actualValue = digits !! 0
        start = digits !! 1
        iterations = digits !! 2 - 1
        values = [actualValue .. (actualValue + iterations)]
        tailOldSpan = drop (start + iterations + 1) oldSpan

getShifted :: T.Text -> Shifted
getShifted x = Shifted original shifted amount
    where
        digits = map (\x -> read (T.unpack x)) (T.splitOn " " x)
        original = digits !! 1
        shifted = digits !! 0
        amount = digits !! 2

-- Convert lines to spans
convertSpans :: [T.Text] -> [Shifted] -> [Shifted]
convertSpans [] acc = acc
convertSpans (x:xs) acc = getShifted x:(convertSpans xs acc)

ordersSplit :: [T.Text] -> [T.Text] -> [Instruction]
ordersSplit top acc
    | top == [] = [Instruction sourceName destName instructionSpan]
    | x == "" = Instruction sourceName destName instructionSpan:ordersSplit xs []
    | otherwise = ordersSplit xs (acc++[x])
    where 
        x = head top
        xs = tail top
        mapNames = T.splitOn " " (head acc) !! 0
        sourceName = T.splitOn "-" mapNames !! 0
        destName = T.splitOn "-" mapNames !! 2
        instructionSpan = convertSpans (tail acc) []

splitSeedsAndInstruction :: [T.Text] -> (T.Text, [T.Text])
splitSeedsAndInstruction (a:b:xs) = (a, xs)

createMap :: [Instruction] -> Map T.Text Instruction
createMap instructions = Map.fromList [(source x, x) | x <- instructions]

fetchSeeds :: T.Text -> [Int]
fetchSeeds line = map (\x -> read (T.unpack x)) (T.splitOn " " digits)
    where digits = T.splitOn ": " line !! 1

part1Sol :: Int -> Map T.Text Instruction -> Instruction -> Int
part1Sol seed instructionMap instruction
    | destination instruction == "location" = nextSeed
    | otherwise = part1Sol nextSeed instructionMap (instructionMap Map.! destination instruction)
        where
            nextSeed = findShifted seed (spans instruction)

getSeedsPart2 :: [Int] -> [[Int]]
getSeedsPart2 [] = []
getSeedsPart2 (a:b:xs) = [a..a+b-1]:(getSeedsPart2 xs)

part1WithMemory :: Int -> Map T.Text Instruction -> Instruction -> Map Int (Map T.Text Int) -> (Int, Map Int (Map T.Text Int))
part1WithMemory seed instructionMap instruction memory
    | Map.member seed memory && Map.member (destination instruction) (memory Map.! seed) = ((memory Map.! seed) Map.! (destination instruction), memory)
    | destination instruction == "location" = (nextSeed, memory)
    | otherwise = part1WithMemory nextSeed instructionMap (instructionMap Map.! destination instruction) newMemory
        where
            nextSeed = findShifted seed (spans instruction)
            newMemory = Map.insert seed (Map.insert (destination instruction) nextSeed (memory Map.! seed)) memory


main :: IO()
main = do
    contents <- TIO.readFile "5.in"
    let vals = T.lines contents
    let seedsAndInstruction = splitSeedsAndInstruction vals
    let seeds = fetchSeeds (fst seedsAndInstruction)
    let instructions = snd seedsAndInstruction
    let orders = ordersSplit instructions []
    let instructionMap = createMap orders
    let part1 = map (\x -> part1Sol x instructionMap (instructionMap Map.! "seed")) seeds
    print part1
    print (foldr1 min part1)
    let seedsPart2 = concat (getSeedsPart2 seeds)
    print (length seedsPart2)
    let part2 = map (\x -> part1Sol x instructionMap (instructionMap Map.! "seed")) seedsPart2
    print (foldr1 min part2) 