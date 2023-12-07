{-# LANGUAGE OverloadedStrings #-}
import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import Data.List ( sort, sortBy, elemIndices, group )

data Deck = Deck {
    cards :: [Char],
    bid :: Int
} deriving (Show)

instance Eq Deck where
    (==) :: Deck -> Deck -> Bool
    (Deck cards _) == (Deck cards2 _) = cards == cards2

scoreDeck :: [Char] -> Int
scoreDeck cards
    | maximumOccurences == 5 = 0
    | maximumOccurences == 4 = 1
    | length occurences == 2 = 2 -- Full house
    | maximumOccurences == 3 = 3
    | length (filter (== 2) occurences) == 2 = 4 -- Two pair
    | maximumOccurences == 2 = 5
    | otherwise = 6
    where
        occurences = map length (group $ sort cards)
        maximumOccurences = maximum occurences

convertVals :: [T.Text] -> [Deck]
convertVals [] = []
convertVals (x:xs) = Deck (head line) (read (line !! 1)):convertVals xs
    where
        line = map T.unpack (T.splitOn " " x)

compareSingleCards :: [Char] -> [Char] -> Ordering
compareSingleCards [] [] = EQ
compareSingleCards (x:xs) (y:ys)
    | x == y = compareSingleCards xs ys
    | x == 'A' = GT
    | y == 'A' = LT
    | x == 'K' = GT
    | y == 'K' = LT
    | x == 'Q' = GT
    | y == 'Q' = LT
    | y == 'J' = GT -- Revert these two lines for part 1
    | x == 'J' = LT -- Revert these two lines for part 1
    | x == 'T' = GT
    | y == 'T' = LT
    | x < y = LT
    | x > y = GT
    | otherwise = compareSingleCards xs ys

compareDecks :: Deck -> Deck -> Ordering
compareDecks (Deck cards bid) (Deck cards2 bid2)
    | score < score2 = GT
    | score > score2 = LT
    | otherwise = compareSingleCards cards cards2
    where
        score = scoreDeck cards
        score2 = scoreDeck cards2

part1 :: [Deck] -> Int -> [Int]
part1 [] _ = []
part1 (x:xs) pos = (bid x * (pos+1)):part1 xs (pos+1)

replace :: [Char] -> Char -> Char -> [Char]
replace [] _ _ = []
replace (x:xs) c replaceWith
    | x == c = replaceWith:replace xs c replaceWith
    | otherwise = x:replace xs c replaceWith

findBestCardWithJoker :: [Char] -> [Char]
findBestCardWithJoker card = possibleDecks !! head (elemIndices (minimum score) score)
    where
        possibleCards = "123456789TQKA"
        possibleDecks = map (replace card 'J') possibleCards
        score = map scoreDeck possibleDecks

compareDecksWithJoker :: Deck -> Deck -> Ordering
compareDecksWithJoker (Deck cards bid) (Deck cards2 bid2)
    | score < score2 = GT
    | score > score2 = LT
    | otherwise = compareSingleCards cards cards2
    where
        score
            | 'J' `elem` cards = scoreDeck (findBestCardWithJoker cards)
            | otherwise = scoreDeck cards
        score2
            | 'J' `elem` cards2 = scoreDeck (findBestCardWithJoker cards2)
            | otherwise = scoreDeck cards2

main :: IO()
main = do
    -- Parsing
    contents <- TIO.readFile "7.in"
    let vals = T.lines contents
    let decks = convertVals vals

    -- Part 1
    let scores = sortBy compareDecks decks
    let p1 = part1 scores 0
    print (sum p1)

    -- Part 2
    let scores2 = sortBy compareDecksWithJoker decks
    let p2 = part1 scores2 0
    print (sum p2)