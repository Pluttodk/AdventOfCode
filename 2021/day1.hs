f :: [String] -> [Integer]
f = map read

par1 :: [Integer] -> Integer -> Integer
par1 [x] acc = acc
par1 (x:xs:xss) acc 
    | xs > x = par1 (xs:xss) acc+1
    | otherwise = par1 (xs:xss) acc

par2 :: [Integer] -> Integer -> Integer
par2 [x] acc = acc
par2 (x:y:z:w:xss) acc 
    | x+y+z < y+z+w = par2 (y:z:w:xss) acc+1
    | otherwise = par2 (y:z:w:xss) acc
par2 (x:xss) acc = acc

main :: IO()
main = do
    contents <- readFile "data/day1.txt"
    let get_words = words contents
    let numbers = f get_words
    let part1 = par1 numbers 0
    print part1
    let part2 = par2 numbers 0
    print part2