import Data.Char (isDigit, digitToInt)

findLastDigit :: [Char] -> Char
findLastDigit a = if isDigit (last a)
                    then last a
                    else findLastDigit (init a)

findFirstDigit :: [Char] -> Char
findFirstDigit (x:xs) = if isDigit x
                    then x
                    else findFirstDigit xs

solveSingleLine :: [Char] -> Int
solveSingleLine line = read dig :: Int
    where dig :: String = [findFirstDigit line, findLastDigit line]

part1Sol :: [String] -> Int -> Int
part1Sol [] acc = acc
part1Sol (firstLine:xs) acc = part1Sol xs (acc + oneLine)
    where oneLine = solveSingleLine firstLine

mapWords :: [Char] -> Char
mapWords ('o':'n':'e':xs) = '1'
mapWords ('t':'w':'o':xs) = '2'
mapWords ('t':'h':'r':'e':'e':xs) = '3'
mapWords ('f':'o':'u':'r':xs) = '4'
mapWords ('f':'i':'v':'e':xs) = '5'
mapWords ('s':'i':'x':xs) = '6'
mapWords ('s':'e':'v':'e':'n':xs) = '7'
mapWords ('e':'i':'g':'h':'t':xs) = '8'
mapWords ('n':'i':'n':'e':xs) = '9'
mapWords x = '0'

findFirstDigitWithWords :: [Char] -> Char
findFirstDigitWithWords a
  | mapWords a /= '0' = mapWords a
  | isDigit (head a) = head a
  | otherwise = findFirstDigitWithWords (tail a)

takeLast :: Int -> [Char] -> [Char]
takeLast n xs = drop (length xs - n) xs

findLastDigitWithWords :: [Char] -> Int -> Char
findLastDigitWithWords a n
  | mapWords (takeLast n a) /= '0' = mapWords (takeLast n a)
  | isDigit (a !! (length a - n)) = a !! (length a - n)
  | otherwise = findLastDigitWithWords a (n+1)

solveSingleLineWithWords :: [Char] -> Int
solveSingleLineWithWords x = read dig :: Int
    where dig = [findFirstDigitWithWords x, findLastDigitWithWords x 1]

part2Sol :: [String] -> Int -> Int
part2Sol [] acc = acc
part2Sol (firstLine:xs) acc = part2Sol xs (acc + oneLine)
    where oneLine = solveSingleLineWithWords firstLine

main :: IO()
main = do
    contents <- readFile "1.in"
    let vals = lines contents
    let part1 = part1Sol vals 0
    print (show part1)
    let part2 = part2Sol vals 0
    print (show part2)