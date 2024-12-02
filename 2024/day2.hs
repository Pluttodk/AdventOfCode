{-# LANGUAGE OverloadedStrings #-}

import Control.Exception (try)
import Data.Text qualified as T
import Data.Text.IO qualified as TIO

isReportSafe :: (Int -> Int -> Bool) -> [Int] -> Bool
isReportSafe comp (a : b : bs) = comp a b && abs (b - a) < 4 && isReportSafe comp (b : bs)
isReportSafe _ _ = True

tryReportSafeWithComb :: (Int -> Int -> Bool) -> Int -> [Int] -> Bool
tryReportSafeWithComb comp idx xs
  | removedOne = True
  | idx == length xs = False
  | otherwise = tryReportSafeWithComb comp (idx + 1) xs
  where
    removedOne = isReportSafe comp (take idx xs ++ drop (idx + 1) xs)

main :: IO ()
main = do
  contents <- TIO.readFile "2.in"
  let reports = T.lines contents
  --   each report has digit split by space
  let toInt = map (read . T.unpack)
  let reports_split = map (toInt . T.splitOn " ") reports
  let part1 = map (\x -> isReportSafe (<) x || isReportSafe (>) x) reports_split
  print part1
  print $ length $ filter id part1
  let part2 = map (\x -> isReportSafe (<) x || isReportSafe (>) x || tryReportSafeWithComb (<) 0 x || tryReportSafeWithComb (>) 0 x) reports_split
  print part2
  print $ length $ filter id part2