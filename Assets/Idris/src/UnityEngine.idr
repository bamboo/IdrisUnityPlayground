module UnityEngine

import public CIL.FFI
import public CIL.FFI.Array
import public CIL.FFI.Single

%access public export

unityStruct : String -> CILTy
unityStruct typeName = CILTyVal "UnityEngine" ("UnityEngine." ++ typeName)

unityClass : String -> CILTy
unityClass typeName = CILTyRef "UnityEngine" ("UnityEngine." ++ typeName)

Vector2Ty : CILTy
Vector2Ty = unityStruct "Vector2"

Vector2 : Type
Vector2 = CIL Vector2Ty

vec2 : Single -> Single -> CIL_IO Vector2
vec2 = new (Single -> Single -> CIL_IO Vector2)

Vector2Array : Type
Vector2Array = TypedArrayOf Vector2Ty

Vector3Ty : CILTy
Vector3Ty = unityStruct "Vector3"

Vector3 : Type
Vector3 = CIL Vector3Ty

vec3 : Single -> Single -> Single -> CIL_IO Vector3
vec3 = new (Single -> Single -> Single -> CIL_IO Vector3)

Vector3Array : Type
Vector3Array = TypedArrayOf Vector3Ty

QuaternionTy : CILTy
QuaternionTy = unityStruct "Quaternion"

Quaternion : Type
Quaternion = CIL QuaternionTy

UnityObjectTy : CILTy
UnityObjectTy = unityClass "Object"

UnityObject : Type
UnityObject = CIL UnityObjectTy

ComponentTy : CILTy
ComponentTy = unityClass "Component"

Component : Type
Component = CIL ComponentTy

GameObjectTy : CILTy
GameObjectTy = unityClass "GameObject"

GameObject : Type
GameObject = CIL GameObjectTy

Transform : Type
Transform = CIL $ unityClass "Transform"

MeshFilterTy : CILTy
MeshFilterTy = unityClass "MeshFilter"

MeshFilter : Type
MeshFilter = CIL MeshFilterTy

IsA Component MeshFilter where {}

MeshTy : CILTy
MeshTy = unityClass "Mesh"

Mesh : Type
Mesh = CIL MeshTy

set_mesh : MeshFilter -> Mesh -> CIL_IO ()
set_mesh =
  invoke (CILInstance "set_mesh")
         (MeshFilter -> Mesh -> CIL_IO ())

sharedMesh : MeshFilter -> CIL_IO Mesh
sharedMesh =
  invoke (CILInstance "get_sharedMesh")
         (MeshFilter -> CIL_IO Mesh)

Clear : Mesh -> Bool -> CIL_IO ()
Clear =
  invoke (CILInstance "Clear")
         (Mesh -> Bool -> CIL_IO ())

RecalculateNormals : Mesh -> CIL_IO ()
RecalculateNormals =
  invoke (CILInstance "RecalculateNormals")
         (Mesh -> CIL_IO ())

RecalculateBounds : Mesh -> CIL_IO ()
RecalculateBounds =
  invoke (CILInstance "RecalculateBounds")
         (Mesh -> CIL_IO ())

Optimize : Mesh -> CIL_IO ()
Optimize =
  invoke (CILInstance "Optimize")
         (Mesh -> CIL_IO ())

set_uv : Mesh -> Vector2Array -> CIL_IO ()
set_uv =
  invoke (CILInstance "set_uv")
         (Mesh -> Vector2Array -> CIL_IO ())

set_vertices : Mesh -> Vector3Array -> CIL_IO ()
set_vertices =
  invoke (CILInstance "set_vertices")
         (Mesh -> Vector3Array -> CIL_IO ())

set_triangles : Mesh -> Int32Array -> CIL_IO ()
set_triangles =
  invoke (CILInstance "set_triangles")
         (Mesh -> Int32Array -> CIL_IO ())

%inline
GetComponent : IsA Component (CIL ty) => GameObject -> (ty : CILTy) -> CIL_IO (CIL ty)
GetComponent go ty =
  invoke (CILInstanceCustom "GetComponent" [RuntimeTypeTy] ComponentTy)
         (GameObject -> RuntimeType -> CIL_IO (CIL ty))
         go !(typeOf ty)

Instantiate : (prefab   : UnityObject) ->
              (position : Vector3) ->
              (rotation : Quaternion) ->
              CIL_IO UnityObject
Instantiate =
  invoke (CILStatic UnityObjectTy "Instantiate")
         (UnityObject -> Vector3 -> Quaternion -> CIL_IO UnityObject)

Destroy : UnityObject -> CIL_IO ()
Destroy =
  invoke (CILStatic UnityObjectTy "Destroy")
         (UnityObject -> CIL_IO ())

identity : CIL_IO Quaternion
identity =
  invoke (CILStatic QuaternionTy "get_identity")
         (CIL_IO Quaternion)

RotateAround : Transform -> (origin : Vector3) -> (axis : Vector3) -> (angle : Single) -> CIL_IO ()
RotateAround =
  invoke (CILInstance "RotateAround")
         (Transform -> Vector3 -> Vector3 -> Single -> CIL_IO ())

transform : GameObject -> CIL_IO Transform
transform =
  invoke (CILInstance "get_transform")
         (GameObject -> CIL_IO Transform)

Log : o -> CIL_IO ()
Log obj =
  invoke (CILStatic (unityClass "Debug") "Log")
         (Object -> CIL_IO ())
         (believe_me obj)

deltaTime : CIL_IO Single
deltaTime =
  invoke (CILStatic (unityClass "Time") "get_deltaTime")
         (CIL_IO Single)

namespace Mathf

  Sqrt : Single -> CIL_IO Single
  Sqrt = invoke (CILStatic (unityStruct "Mathf") "Sqrt") (Single -> CIL_IO Single)
