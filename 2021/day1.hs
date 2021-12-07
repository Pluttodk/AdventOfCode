f :: [String] -> [Integer]
f = map read

main :: IO()
main = do
    contents <- readFile "data/day1.txt"
    let numbers = f contents
    print numbers