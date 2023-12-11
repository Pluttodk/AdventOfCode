import qualified Data.Map as Map
import qualified Data.Set as Set
import Data.List (maximumBy)
import Data.Ord (comparing)

findStart :: [[Char]] -> Int -> Int -> (Int, Int, Int)
findStart input col row 
    | row < length x && x !! row == 'S' = (col, row, 0)
    | row < length x = findStart input col (row+1)
    | col < length input-1 = findStart input (col+1) 0
    | otherwise = (-1,-1,-1)
    where x = input !! col

startNeighbors :: [[Char]] -> (Int, Int, Int) -> [(Int, Int, Int)] -> [(Int, Int, Int)]
startNeighbors input (row, col, depth) acc
    | notElem (row+1, col, depth+1) acc && (row+1) < length input && input !! (row+1) !! col `elem` "|LJ" = 
        startNeighbors input (row, col, depth) ((row+1, col, depth+1):acc)
    | notElem (row-1, col, depth+1) acc && (row-1) >= 0 && input !! (row-1) !! col `elem` "|7F" = 
        startNeighbors input (row, col, depth) ((row-1, col, depth+1):acc)
    | notElem (row, col-1, depth+1) acc && (col-1) >= 0 && input !! row !! (col-1) `elem` "-FL" = 
        startNeighbors input (row, col, depth) ((row, col-1, depth+1):acc)
    | notElem (row, col+1, depth+1) acc && (col+1) < length (head input) && input !! row !! (col+1) `elem` "-J7" = 
        startNeighbors input (row, col, depth) ((row, col+1, depth+1):acc)
    | otherwise = acc

mapDirection :: (Int, Int) -> (Int, Int) -> Char -> (Int, Int)
mapDirection (from_row, from_col) (at_row, at_col) 'J'
    | at_col - from_col == 1 = (at_row-1, at_col)
    | at_row - from_row == 1 = (at_row, at_col-1)
mapDirection (from_row, from_col) (at_row, at_col) 'L'
    | at_col - from_col == -1 = (at_row-1, at_col)
    | at_row - from_row == 1 = (at_row, at_col+1)
mapDirection (from_row, from_col) (at_row, at_col) '7'
    | at_col - from_col == 1 = (at_row+1, at_col)
    | at_row - from_row == -1 = (at_row, at_col-1)
mapDirection (from_row, from_col) (at_row, at_col) 'F'
    | at_col - from_col == -1 = (at_row+1, at_col)
    | at_row - from_row == -1 = (at_row, at_col+1)
mapDirection (from_row, from_col) (at_row, at_col) '|' = (at_row+(at_row-from_row), at_col)
mapDirection (from_row, from_col) (at_row, at_col) '-' = (at_row, at_col + (at_col-from_col))
mapDirection _ at _ = at

-- Currently does DFS we want to BFS
parseToInt :: [[Char]] -> [((Int, Int, Int),(Int, Int, Int))] -> [(Int, Int)] -> [(Int, Int, Int)]
parseToInt input (((from_row, from_col, from_depth),(at_row, at_col, at_depth)):res) seen
    | at_row >= length input || at_row < 0 = []
    | at_col >= length (head input) || at_col < 0 = []
    | (at_row, at_col) `elem` seen = []
    | otherwise = (at_row, at_col, at_depth):parseToInt input stillToVisit ((at_row, at_col):seen)
    where 
        value = input !! at_row !! at_col
        (nRow, nCol) = mapDirection (from_row, from_col) (at_row, at_col) value
        stillToVisit = res ++ [((at_row, at_col, at_depth),(nRow, nCol, at_depth+1))]

-- Not a coorect solution. Instead I should take a location that is not in the loop
-- And do graph traversal from any non loop to the outside. If possible that value is not inside. Else Inside
isInside :: [[Char]] -> (Int, Int) -> [(Int, Int)] -> Bool
isInside input (row, col) loop
    | (row, col) `elem` loop = False
    | checkRight > 0 && checkLeft > 0 && (checkRight `mod` 2 == 1 || checkLeft `mod` 2 == 1) = True
    | otherwise = False
    where 
        width = length input - 1
        width_inner = length (head input) - 1
        rightPath = [(row, x) | x <- [col .. width_inner]]
        leftPath = [(row, x) | x <- [0 .. col]]
        checkPath path = length (filter (`elem` loop) path)
        checkRight = checkPath rightPath
        checkLeft = checkPath leftPath

part2 :: [[Char]] -> (Int, Int) -> [(Int, Int)] -> Int -> Int
part2 input (row,col) loop score 
    | notElem (row, col) loop && isInside input (row,col) loop && shouldGoRight = part2 input (row, col+1) loop (score+1)
    | notElem (row, col) loop && isInside input (row,col) loop && shouldGoDown = part2 input (row+1, 0) loop (score+1)
    | otherwise = score
    where 
        shouldGoRight = col < length (head input)-1
        shouldGoDown = row < length input-1

main :: IO()
main = do
    -- Parsing
    contents <- readFile "10.in"
    let vals = lines contents
    let (start_row, start_col, start_depth) = findStart vals 0 0
    let start = (start_row, start_col, start_depth)
    let neighbors = startNeighbors vals start []
    let directions = map (start, ) neighbors
    let loop = parseToInt vals directions []
    -- part 1
    let bestPart = maximumBy (comparing (\(_, _, x) -> x)) loop
    print (bestPart)

    -- part 2
    let loopWithoutDepth = (start_row, start_col):map (\(x,y,_) -> (x,y)) loop
    let location = concat [[(x,y) | y <- [0..length (head vals)-1]] | x <- [0..length vals-1]]
    let insides = filter (\(col,row) -> isInside vals (col,row) loopWithoutDepth) location
    print (insides)
    print (length insides)
