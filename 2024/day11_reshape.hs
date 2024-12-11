import Data.Map.Strict qualified as M

type Memo = M.Map (Int, Int) Integer

inputValue :: [Int]
inputValue = [64599, 31, 674832, 2659361, 1, 0, 8867, 321]

nStones :: Int -> Int -> Memo -> (Integer, Memo)
nStones v 0 memo = (1, memo)
nStones v n memo =
  case M.lookup (v, n) memo of
    Just result -> (result, memo)
    Nothing ->
      let (result, memo') = computeNStones v n memo
          memo'' = M.insert (v, n) result memo'
       in (result, memo'')

computeNStones :: Int -> Int -> Memo -> (Integer, Memo)
computeNStones v n memo
  | v == 0 =
      nStones 1 (n - 1) memo
  | even (numDigits v) =
      let (left, right) = splitNumber v
          (nLeft, memo1) = nStones left (n - 1) memo
          (nRight, memo2) = nStones right (n - 1) memo1
       in (nLeft + nRight, memo2)
  | otherwise =
      nStones (2024 * v) (n - 1) memo

numDigits :: Int -> Int
numDigits v = length (show v)

splitNumber :: Int -> (Int, Int)
splitNumber v = (read leftPart, read rightPart)
  where
    s = show v
    half = length s `div` 2
    (leftPart, rightPart) = splitAt half s

calculateTotalStones :: [Int] -> Int -> Integer
calculateTotalStones initialValues totalBlinks =
  let (total, _) = foldl accum (0, M.empty) initialValues
      accum (acc, memo) v =
        let (ns, memo') = nStones v totalBlinks memo
         in (acc + ns, memo')
   in total

p1 :: Integer
p1 = calculateTotalStones inputValue 25

p2 :: Integer
p2 = calculateTotalStones inputValue 75