{-# LANGUAGE OverloadedStrings #-}
import qualified Data.Text as T
import qualified Data.List as D
import qualified Data.Text.IO as TIO
import Data.Char (isDigit, digitToInt)

board :: [[Char]]
board = ["467..114..","...*......","..35..633.","......#...","617*......",".....+.58.","..592.....","......755.","...$.*....",".664.598.."]


-- Get all the digits from a single line, seperated by column, row (digit, column, row)
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

checkDigit :: [[Char]] -> (Int, Int, Int) -> Int
checkDigit b (val, col, row)
    | b !! col !! row == '.' = val
        where 
            minCol = max [col-1, 0]
            maxCol = min [col+1, length b]
            minRow = max [row+length (show val), length (head b)]
            maxRow = min [row-1, 0]

checkAbove :: [[Char]] -> Int -> Int -> Bool
checkAbove board col row
    | row <= 0 = False
    | otherwise = not (isDigitOrDot aboveField)
    where
        aboveField = board !! (col-1) !! row
        isDigitOrDot c = c `elem` ['0'..'9'] || c == '.'

isTextValid :: T.Text -> [[Char]] -> Int -> Int -> Int
isTextValid value charBoard col row
    | value == "" = 0
    | any (\r -> checkAbove charBoard col r) rows = read (T.unpack value)
    | otherwise = 0
    where 
        rows = [col .. T.length value + col]

-- Returns -1 if no adjacent dots in the board is a symbol
isLineValid :: [[T.Text]] -> [[Char]] -> Int -> Int -> Int
isLineValid board charBoard col row
    | checkAbove charBoard col row = read (T.unpack pos)
    where 
        pos = board !! col !! row



main :: IO()
main = do
    contents <- TIO.readFile "3.in"
    let symbolsBoard = T.lines contents
    let board = D.map (T.splitOn ".") symbolsBoard
    let charBoard = D.map T.unpack symbolsBoard
    let value = isLineValid board charBoard 0 0
    print value