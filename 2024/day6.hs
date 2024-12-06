{-# LANGUAGE OverloadedStrings #-}

import Data.List (nub)
import Data.Text qualified as T
import Data.Text.IO qualified as TIO

data Direction = North | East | South | West deriving (Show, Eq)

move :: Int -> Int -> Direction -> Int
move width location direction
  | direction == North = location - width
  | direction == East = location + 1
  | direction == South = location + width
  | direction == West = location - 1

turn :: Direction -> Direction
turn North = East
turn East = South
turn South = West
turn West = North

convertValueToCoordinate :: Int -> Int -> (Int, Int)
convertValueToCoordinate width value = (value `mod` width, value `div` width)

convertCoordinateToValue :: Int -> (Int, Int) -> Int
convertCoordinateToValue width (x, y) = y * width + x

isValidMove :: Int -> Int -> Direction -> T.Text -> Bool
isValidMove guard width direction room = guardX >= 0 && guardX < width && guardY >= 0 && guardY < T.length room `div` width
  where
    guardX = guard `mod` width
    guardY = guard `div` width

hasReachedBorder :: Int -> Int -> Direction -> T.Text -> Bool
hasReachedBorder guard width North _ = guard < width
hasReachedBorder guard width East room = guard `mod` width >= width - 1
hasReachedBorder guard width South room = guard >= T.length room - width
hasReachedBorder guard width West room = guard `mod` width == 0

moveGuard :: Int -> Int -> Direction -> T.Text -> [Int]
moveGuard guard width direction room
  | hasReachedBorder guard width direction room = [guard]
  | isValidMove nextMove width direction room && T.index room nextMove == '#' = moveGuard guard width (turn direction) room
  | otherwise = guard : moveGuard (move width guard direction) width direction room
  where
    nextMove = move width guard direction

moveGuardIsLoop :: Int -> Int -> Direction -> T.Text -> Int -> Bool
moveGuardIsLoop guard width direction room count
  | count > 10000 = True
  | hasReachedBorder guard width direction room = False
  | isValidMove nextMove width direction room && T.index room nextMove == '#' = moveGuardIsLoop guard width (turn direction) room (count + 1)
  | otherwise = moveGuardIsLoop (move width guard direction) width direction room (count + 1)
  where
    nextMove = move width guard direction

posToCreateLoop :: Int -> Int -> Direction -> T.Text -> [Int] -> Int
posToCreateLoop _ _ _ _ [] = 0
posToCreateLoop guard width direction room (orgPos : xs)
  | isALoop = 1 + posToCreateLoop guard width direction room xs
  | otherwise = posToCreateLoop guard width direction room xs
  where
    (before, after) = T.splitAt orgPos room
    newMap = T.concat [before, T.singleton '#', T.drop 1 after]
    isALoop = moveGuardIsLoop guard width direction newMap 0

main :: IO ()
main = do
  contents <- TIO.readFile "6.in"
  -- find the "^" icon
  let width = length (T.unpack (head (T.lines contents)))
  let contentsWithoutNewLine = T.filter (/= '\n') contents
  let (Just start) = T.findIndex (== '^') contentsWithoutNewLine
  let guardsPositions = moveGuard start width North contentsWithoutNewLine
  let distinctGuardsPosition = nub guardsPositions
  -- count length of distinct guards
  print (length guardsPositions)
  print (length distinctGuardsPosition)
  print "Part 1"

  let part2 = posToCreateLoop start width North contentsWithoutNewLine (drop 1 distinctGuardsPosition)
  print part2
  print "Part 2"