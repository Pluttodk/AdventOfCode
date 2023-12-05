{-# LANGUAGE OverloadedStrings #-}
import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import Data.Map (Map)
import qualified Data.Map as Map

-- Data types used
data Shifted = Shifted {
    original:: Int,
    shifted:: Int,
    amount:: Int
} deriving (Show)

data Instruction = Instruction { source :: T.Text
                               , destination :: T.Text
                               , spans :: [Shifted]
                               } deriving (Show)

-- Parsing
getShifted :: T.Text -> Shifted
getShifted x = Shifted original shifted amount
    where
        digits = map (\x -> read (T.unpack x)) (T.splitOn " " x)
        original = digits !! 1
        shifted = digits !! 0
        amount = digits !! 2

convertSpans :: [T.Text] -> [Shifted] -> [Shifted]
convertSpans [] acc = acc
convertSpans (x:xs) acc = getShifted x:(convertSpans xs acc)

ordersSplit :: [T.Text] -> [T.Text] -> [Instruction]
ordersSplit top acc
    | null top = [Instruction sourceName destName instructionSpan]
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


-- Part 1:
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

fetchSeeds :: T.Text -> [Int]
fetchSeeds line = map (\x -> read (T.unpack x)) (T.splitOn " " digits)
    where digits = T.splitOn ": " line !! 1

genericSolution :: T.Text -> Int -> Map T.Text Instruction -> Instruction -> Int
genericSolution stopID seed instructionMap instruction
    | destination instruction == stopID = nextSeed
    | otherwise = genericSolution stopID nextSeed instructionMap (instructionMap Map.! destination instruction)
        where
            nextSeed = findShifted seed (spans instruction)

part1Sol :: Int -> Map T.Text Instruction -> Instruction -> Int
part1Sol = genericSolution "location"


-- Part 2: We reverse the search and go from location to seed and see if those are within our seed span

reverseShifted :: [Shifted] -> [Shifted]
reverseShifted [] = []
reverseShifted ((Shifted org shift amoun):xs) = Shifted shift org amoun:reverseShifted xs

reverseInstruction :: [Instruction] -> [Instruction]
reverseInstruction [] = []
reverseInstruction ((Instruction s d span):xs) = Instruction d s (reverseShifted span):reverseInstruction xs

reverseInteractionMap :: [Instruction] -> Map T.Text Instruction
reverseInteractionMap instructions = Map.fromList [(source x, x) | x <- instructions]

part2Sol :: Int -> Map T.Text Instruction -> Instruction -> Int
part2Sol = genericSolution "seed"

isValidPart2 :: Int -> [Int] -> Bool
isValidPart2 val [] = False
isValidPart2 val (start:span:rest)
    | val < start+span && val >= start = True
    | otherwise = isValidPart2 val rest

locationValues :: Instruction -> [Int]
locationValues (Instruction _ _ values) = concat $ getSpan values
    where getSpan = map (\(Shifted a b c) -> [b, b+c])

solveSimple :: [Int] -> [Int] -> Map T.Text Instruction -> Instruction -> Int
solveSimple [] _ _ _ = -1
solveSimple (x:seeds) seedValues alteredInstructionMap instruct
    | isValidPart2 solution seedValues = x
    | otherwise = solveSimple seeds seedValues alteredInstructionMap instruct
        where solution = part2Sol x alteredInstructionMap (alteredInstructionMap Map.! "location")

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
    print (minimum part1)
    let revOrders = reverseInstruction orders
    let alteredInstructionMap = reverseInteractionMap revOrders
    let locationVals = locationValues $ alteredInstructionMap Map.! "location"
    let part2 = solveSimple [0..] seeds alteredInstructionMap (alteredInstructionMap Map.! "location")
    print part2