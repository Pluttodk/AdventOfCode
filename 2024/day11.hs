import Data.Map (Map)
import Data.Map qualified as M

blink :: Int -> [Int]
blink 0 = [1]
blink n
  | even $ length stringN = [left, right]
  | otherwise = [n * 2024]
  where
    stringN = show n
    half = length stringN `div` 2
    left = read $ take half stringN
    right = read $ drop half stringN

values :: [Int]
values = [125, 17]

inputValue :: [Int]
inputValue = [64599, 31, 674832, 2659361, 1, 0, 8867, 321]

blinkSingleValue5Times :: [Int] -> Int -> [Int]
blinkSingleValue5Times value iteration
  | iteration >= 5 = value
  | otherwise = blinkSingleValue5Times (concatMap blink value) (iteration + 1)

blink25 :: [Int] -> Int -> Int -> Map Int [Int] -> [Int]
blink25 values iteration maxValue dpMap
  | iteration >= maxValue = values
  | otherwise = blink25 (presentValue ++ concatMap snd blink5) (iteration + 5) maxValue newMap
  where
    storedValues = filter (`M.member` dpMap) values
    notStoredValues = filter (\x -> not $ M.member x dpMap) values
    presentValue = concatMap (dpMap M.!) storedValues
    blink5 = map (\x -> (x, blinkSingleValue5Times [x] 0)) notStoredValues
    newMap = foldl (\acc (k, v) -> M.insert k v acc) dpMap blink5

blink25WithMap :: [Int] -> Int -> Int -> Map Int [Int] -> ([Int], Map Int [Int])
blink25WithMap values iteration maxValue dpMap
  | iteration >= maxValue = (values, dpMap)
  | otherwise = blink25WithMap (presentValue ++ concatMap snd blink5) (iteration + 5) maxValue newMap
  where
    storedValues = filter (`M.member` dpMap) values
    notStoredValues = filter (\x -> not $ M.member x dpMap) values
    presentValue = concatMap (dpMap M.!) storedValues
    blink5 = map (\x -> (x, blinkSingleValue5Times [x] 0)) notStoredValues
    newMap = foldl (\acc (k, v) -> M.insert k v acc) dpMap blink5

blink75UsingMap :: ([Int], Map Int [Int]) -> [Int]
blink75UsingMap ([], dpMap) = []
blink75UsingMap (r : rs, dpMap)
  | M.member r dpMap = dpMap M.! r ++ blink75UsingMap (rs, dpMap)
  | otherwise = newValues ++ blink75UsingMap (rs, newMap)
  where
    (newValues, newMap) = blink25WithMap [r] 0 25 dpMap

p1 = length $ blink25 inputValue 0 25 M.empty

p2 = length $ blink25 inputValue 0 75 M.empty