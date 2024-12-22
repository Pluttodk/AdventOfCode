{-# LANGUAGE OverloadedStrings #-}

import Control.Exception (try)
import Data.Text qualified as T
import Data.Text.IO qualified as TIO

-- ax + by = c
a :: [Double]
a = [2,1,4]


b :: [Double]
b = [1,2,-1]

scale a = map (head a *)


replaceXWithY a b= drop 1 a++drop 1 b


moveLeftNonVar a = [head a-a!!2,last a- (a !! 1)]

solveForY :: [Double] -> Double
solveForY a = last a/head a

part1 :: ([Double],[Double]) -> [Double]
part1 (f1,f2) = [x,y]
    where
        form1 = [head f1,- (f1 !! 1), f1!!2]
        form2 = [head f2,- (f2 !! 1), f2!!2]
        scale1 = scale form1 form2
        scale2 = scale form2 form1
        replacedFormula = replaceXWithY scale1 scale2
        movedForY = moveLeftNonVar replacedFormula
        y = solveForY movedForY
        x = sum $ map (/ head form1) [form1 !! 1 * y, last form1]


parseInstructions :: [T.Text] -> [[Double]]
parseInstructions ins = xs
    where
        lines = map (T.splitOn "\n") ins
        parseX a = T.splitOn "," (last (T.splitOn "X" a))
        readX x = if head (T.unpack x) == '+' then read (tail $ T.unpack x) else read (T.unpack x) :: Double
        xs = map (map (readX . (head . T.splitOn "," . last . T.splitOn "X"))) (take 2 lines)

movedToFunctions ::  [([Double], [Double], [Double])] -> [([Double], [Double])]
movedToFunctions [] = []
movedToFunctions ((a,b,c):rs) = (a ++ [head c], b++[last c]):movedToFunctions rs

isWhole :: Double -> Bool
isWhole x = abs (x - fromIntegral (round x)) < 1e-2

part1Sum :: [Double] -> Double
part1Sum [] = 0
part1Sum (x:y:rs) = 3*x+y
part1Sum [x] = 0

part2Parsed :: [([Double], [Double])] -> [([Double], [Double])]
part2Parsed [] = []
part2Parsed (([x,y,z], [a,b,c]):xs) = ([x,y,z+10000000000000], [a,b,c+10000000000000]):part2Parsed xs

main :: IO ()
main = do
    contents <- TIO.readFile "13.in"

    let ins = T.splitOn "\n\n" contents
    let lines = map (T.splitOn "\n") ins
    let readDouble x = read (T.unpack x) :: Double
    let parseX = head . T.splitOn "," . last . T.splitOn "X"
    let parseY = last . T.splitOn "Y"
    let readX x = if head (T.unpack x) == '+' then read (tail $ T.unpack x) else read (T.unpack x) :: Double
    let xsparse = map (readX . parseX) . take 2
    let ysparse = map (readX . parseY) . take 2
    let resultLine = map (tail . T.splitOn "=" . T.replace ", Y" "" . last)
    let xAndY = map (map readDouble) (resultLine lines)
    let ys = map ysparse lines
    let xs = map xsparse lines
    let result = zip3 xs ys xAndY
    let parsed = movedToFunctions result
    let p1 = map (filter isWhole . part1) parsed
    let p2 = map (filter isWhole . part1) (part2Parsed parsed)

    let p1Result = map part1Sum p1
    let p2Result = map part1Sum p2
    print $ sum p1Result
    print $ round $ sum p2Result