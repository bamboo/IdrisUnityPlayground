module GameOfLife

%default total

Cell : Type
Cell = (Int, Int)

Cells : Type
Cells = List Cell

isAlive : Cells -> Cell -> Bool
isAlive = flip elem

-- Any live cell with fewer than two live neighbours dies, as if caused by under-population.
-- Any live cell with two or three live neighbours lives on to the next generation.
-- Any live cell with more than three live neighbours dies, as if by overcrowding.
-- Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
-- https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life#Rules
neighbours : Cell -> List Cell
neighbours (x, y) = [(x,     y - 1), (x,     y + 1),
                     (x - 1, y - 1), (x + 1, y - 1),
                     (x - 1, y),     (x + 1, y),
                     (x - 1, y + 1), (x + 1, y + 1)]

liveNeighbours : Cells -> Cell -> List Cell
liveNeighbours cells = filter (isAlive cells) . neighbours

liveNeighboursLength : Cells -> Cell -> Nat
liveNeighboursLength cells = length . liveNeighbours cells

surviving : Cells -> Cells
surviving cells = filter survivor cells
  where survivor c = let n = liveNeighboursLength cells c
                     in n == 2 || n == 3

dead : Cells -> List Cell
dead cells = filter (not . isAlive cells) allNeighbours
  where allNeighbours = nub $ concatMap neighbours cells

newborn : Cells -> Cells
newborn cells = filter ((== 3) . liveNeighboursLength cells) (dead cells)

tick : Cells -> Cells
tick cells = nub (surviving cells `merge` newborn cells)

gosperGun : Cells
gosperGun =
  [(1,5),  (2,5),  (1,6),  (2,6),
   (11,5), (11,6), (11,7), (12,4), (12,8),
   (13,3), (14,3), (13,9), (14,9), (15,6),
   (16,4), (16,8), (17,5), (17,7), (17,6), (18,6),
   (21,3), (21,4), (21,5), (22,3), (22,4), (22,5),
   (23,2), (23,6), (25,2), (25,1), (25,6), (25,7),
   (35,3), (36,3), (35,4), (36,4)]
