import Data.Char (isDigit, digitToInt)
import Data.List (group, sort, groupBy)

board :: [[Char]]
board = ["467..114..","...*......","..35..633.","......#...","617*......",".....+.58.","..592.....","......755.","...$.*....",".664.598.."]

getDigits :: [Char] -> [Char] -> Int -> [(Int, Int)]
getDigits [] [] _ = []
getDigits [] possibleDigit row = [(read possibleDigit, row - length possibleDigit)]
getDigits (x:xs) possibleDigit row
    | not (isDigit x) && null possibleDigit = getDigits xs possibleDigit (row+1)
    | not (isDigit x) = (read possibleDigit, row-length possibleDigit):getDigits xs [] (row+1)
    | otherwise = getDigits xs (possibleDigit++[x]) (row+1)

findDigitsOnBoard :: [[Char]] -> [[(Int, Int)]]
findDigitsOnBoard = map (\x -> getDigits x [] 0)

addColToDigits :: [[(Int, Int)]] -> Int -> [[(Int, Int, Int)]]
addColToDigits [] col = []
addColToDigits (x:xs) col = map (\y -> (fst y, col, snd y)) x:addColToDigits xs (col+1)

digitsOnBoard :: [[(Int, Int, Int)]]
digitsOnBoard = addColToDigits rowDigit 0
    where rowDigit = findDigitsOnBoard board

checkLocation :: [[Char]] -> (Int, Int) -> Bool
checkLocation b (col, row)
    | not (locVal == '.' || isDigit locVal) = True
    | otherwise = False
    where locVal = b !! col !! row

checkDigit :: [[Char]] -> (Int, Int, Int) -> Int
checkDigit b (val, col, row)
    | any (checkLocation b) locations = val
    | otherwise = 0
        where 
            minCol = max (col-1) 0
            maxCol = min (col+1) (length b - 1)
            minRow = max (row-1) 0
            maxRow = min (row+length (show val)) (length (head b) - 1)
            locations = [(x,y) | x <- [minCol..maxCol], y <- [minRow..maxRow]]

part1Sol :: [[Char]] -> Int
part1Sol board = sum $ map (checkDigit board) (concat digitsOnBoard)
    where 
        rowDigit = findDigitsOnBoard board
        digitsOnBoard = addColToDigits rowDigit 0

part1 :: Int
part1 = sum $ map (checkDigit board) (concat digitsOnBoard)


-- Part 2

findAllStarSymbols:: [[Char]] -> (Int, Int, Int) -> [(Int, Int, Int)]
findAllStarSymbols b (val, col, row) = filter (\(x, y, _) -> (b !! x !! y) == '*') locations
    where 
        minCol = max (col-1) 0
        maxCol = min (col+1) (length b - 1)
        minRow = max (row-1) 0
        maxRow = min (row+length (show val)) (length (head b) - 1)
        locations = [(x,y,val) | x <- [minCol..maxCol], y <- [minRow..maxRow]]

allStarLocations :: [[Char]] -> [(Int, Int, Int)]
allStarLocations b = concat $ map (findAllStarSymbols b) (concat digitsOnBoard)
    where 
        rowDigit = findDigitsOnBoard b
        digitsOnBoard = addColToDigits rowDigit 0

removeDuplicates :: [(Int, Int, Int)] -> [[(Int, Int, Int)]]
removeDuplicates tuples = filter (\g -> length g > 1) $ groupBy (\(a, b, _) (c, d, _) -> a == c && b == d) $ sort tuples

part2Sol :: [[Char]] -> Int
part2Sol board = sum $ map (\x -> product $ map (\(_,_,val) -> val) x) (removeDuplicates (allStarLocations board)) 

main :: IO()
main = do
    contents <- readFile "3.in"
    let vals = lines contents
    let part1 = part1Sol vals
    print (show part1)
    let part2 = part2Sol vals
    print (show part2)