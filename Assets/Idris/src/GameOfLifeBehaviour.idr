module GameOfLifeBehaviour

import UnityEngine
import GameOfLife

||| Projects a cell into 3D space.
position : Cell -> CIL_IO Vector3
position (x, y) = vec3 (cast x) (cast y) 1

||| Instantiate a prefab at the given cell position.
instantiate : UnityObject -> Cell -> CIL_IO UnityObject
instantiate prefab cell = Instantiate prefab !(position cell) !identity

record Game where
  constructor MkGame
  model : Cells
  view  : List UnityObject

start : CIL_IO Game
start = do
  Log "starting..."
  return $ MkGame gosperGun []

update : UnityObject -> Game -> CIL_IO Game
update prefab (MkGame model view) = do
  view' <- for model (instantiate prefab)
  for_ view Destroy
  -- limit the size of the model
  -- otherwise stack overflow ensues
  let model' = take 61 $ tick model
  return $ MkGame model' view'

exports : FFI_Export FFI_CIL "GameOfLifeBehaviour" []
exports =
  Data Game "Game" $
  Fun start CILDefault $
  Fun update CILDefault
  End
