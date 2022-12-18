import Data.List (sort)
paragraphs :: [String] -> Integer -> [Integer]
paragraphs [] acc = [acc]
paragraphs ("":tail) acc = acc : paragraphs tail 0
paragraphs (head:tail) acc = paragraphs tail (read head + acc)

take3 :: [Integer] -> Integer
take3 [a, b, c] = a+b+c
take3 (head:tail) = take3 tail
take3 _ = 0

main :: IO()
main = do
    contents <- readFile "1.in"
    let vals = lines contents
    let result = paragraphs vals 0
    let part1 = foldr1 (\x y -> if x >= y then x else y) result
    let part2 = (take3 . sort) result
    print part1
    print part2