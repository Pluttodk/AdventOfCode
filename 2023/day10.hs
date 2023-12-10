import qualified Data.Map as Map
import qualified Data.Set as Set
import Data.List (maximumBy)
import Data.Ord (comparing)

parseNodes :: [[Char]] -> Int -> Int -> [(Int, Int, Char)]
parseNodes input col row 
    | row < length x-1 = (col, row, x !! row):parseNodes input col (row+1)
    | col < length input-1 = (col, row, x !! row):parseNodes input (col+1) 0
    | otherwise = [(col, row, x !! row)]
    where x = input !! col

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
    | notElem (row-1, col, depth+1) acc && (row-1) >= 0 && input !! (row-1) !! col `elem` "|7FLJ" = 
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

main :: IO()
main = do
    -- Parsing
    contents <- readFile "10.in"
    let vals = lines contents
    let start = findStart vals 0 0
    let neighbors = startNeighbors vals start []
    let directions = map (start, ) neighbors
    print (neighbors)
    -- part 1
    let part1 = parseToInt vals directions []
    let bestPart = maximumBy (comparing (\(_, _, x) -> x)) part1
    -- print part1
    print (bestPart)