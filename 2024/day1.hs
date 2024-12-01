import System.IO (readFile)
import Data.List (sort, group)
import Data.Char (isDigit)

getFirstTwoDigit :: String -> [String]
getFirstTwoDigit = take 2 . words . filter (\c -> isDigit c || c == ' ')

toPair :: [String] -> (Int, Int)
toPair [a, b] = (read a, read b)

similarityScore :: [Int] -> [Int] -> Int
similarityScore l r = sum [li * count li r | li <- l]
    where
        count x = length . filter (== x)

main :: IO ()
main = do
    content <- readFile "1.in"
    let linesOfFile = lines content
        firstTwoDigit = map (toPair . getFirstTwoDigit) linesOfFile

    let (l, r) = unzip firstTwoDigit

    let dist = sum $ zipWith (\lowL lowR -> abs (lowR - lowL)) (sort l) (sort r)
    putStrLn $ "Distance: " ++ show dist

    let smScore = similarityScore l r
    putStrLn $ "Similarity Score: " ++ show smScore