{-# LANGUAGE OverloadedStrings #-}

import Control.Exception (try)
import Data.Text qualified as T
import Data.Text.IO qualified as TIO
import Text.Read (Lexeme (String))
import Text.Regex.TDFA

-- split on , and parse the digits between the brackets
multiplyValue :: T.Text -> Int
multiplyValue s = read fst * read lst
  where
    getLast = T.unpack . last . T.splitOn "("
    getFirst = T.unpack . head . T.splitOn ")"
    del = T.pack ","
    vals = T.splitOn del s
    fst = getLast (head vals)
    lst = getFirst (last vals)

part1 :: T.Text -> Int
part1 s = sum $ map multiplyValue textMatches
  where
    pat = "mul\\([0-9]{1,3},[0-9]{1,3}\\)" :: String
    matches = T.unpack s =~ pat :: [[String]]
    textMatches = map (T.pack . head) matches

doDont :: [Char] -> [Char] -> Bool -> Int
doDont ('d' : 'o' : '(' : ')' : xs) check val
  | val = doDont xs check True
  | otherwise = doDont xs [] True
doDont ('d' : 'o' : 'n' : '\'' : 't' : '(' : ')' : xs) check val
  | val = part1 (T.pack check) + doDont xs [] False
  | otherwise = doDont xs [] False
doDont (x : xs) check val
  | val = doDont xs (check ++ [x]) val
  | otherwise = doDont xs [] val
doDont [] check val
  | val = part1 (T.pack check)
  | otherwise = 0

main :: IO ()
main = do
  contents <- TIO.readFile "3.in"
  let p1 = part1 contents
  print p1
  let p2 = doDont (T.unpack contents) [] True
  print p2