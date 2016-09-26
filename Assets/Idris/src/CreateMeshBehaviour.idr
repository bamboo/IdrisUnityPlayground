|||
||| Demonstrates procedural mesh generation using the primitive array FFI.
|||
||| Based on example found at https://blog.nobel-joergensen.com/2010/12/25/procedural-generated-mesh-in-unity/
|||
||| Unfortunately the Unity Editor can't currently handle this beauty
||| so you need to build a standalone executable to see it run.
||| Not that there's much to see anyay.
|||
module CreateMeshBehaviour

import Data.Vect
import UnityEngine

doto : o -> List (o -> CIL_IO ()) -> CIL_IO ()
doto obj = traverse_ (\op => op obj)

vertices : CIL_IO Vector3Array
vertices = do
  p0 <- vec3 0 0 0
  p1 <- vec3 1 0 0
  p2 <- vec3 (cast 0.5) 0 !(Sqrt $ cast 0.75)
  p3 <- vec3 (cast 0.5) !(Sqrt $ cast 0.75) (!(Sqrt $ cast 0.75) / 3)
  arrayOf Vector3Ty [ p0, p1, p2
                    , p0, p2, p3
                    , p2, p1, p3
                    , p0, p3, p1 ]

triangles : CIL_IO Int32Array
triangles =
  arrayOf CILTyInt32 [ 0, 1, 2
                     , 3, 4, 5
                     , 6, 7, 8
                     , 9, 10, 11 ]

uv : CIL_IO Vector2Array
uv = do
  uv1  <- vec2 (cast 0.5) 0
  uv0  <- vec2 (cast 0.25) (!(Sqrt $ cast 0.75) / 2)
  uv2  <- vec2 (cast 0.75) (!(Sqrt $ cast 0.75) / 2)
  uv3a <- vec2 0 0
  uv3b <- vec2 (cast 0.5)  !(Sqrt $ cast 0.75)
  uv3c <- vec2 1 0
  arrayOf Vector2Ty [ uv0, uv1, uv2
                    , uv0, uv2, uv3b
                    , uv0, uv1, uv3a
                    , uv1, uv2, uv3c ]

Start : GameObject -> CIL_IO ()
Start go = do

  meshFilter <- go `GetComponent` MeshFilterTy
  meshFilter `set_mesh` !(new (CIL_IO Mesh))

  mesh <- sharedMesh meshFilter
  doto mesh
       [ flip set_vertices !vertices
       , flip set_triangles !triangles
       , flip set_uv !uv
       , RecalculateNormals
       , RecalculateBounds
       , Optimize
       ]

  Log "Mesh complete."

Update : GameObject -> CIL_IO ()
Update go = do
  origin <- vec3 0 0 0
  axis   <- vec3 (cast 0.5) (cast 0.5) (cast 0.5)
  RotateAround !(transform go) origin axis (180 * !deltaTime)

exports : FFI_Export FFI_CIL "CreateMeshBehaviour" []
exports =
  Fun Start CILDefault $
  Fun Update CILDefault
  End
