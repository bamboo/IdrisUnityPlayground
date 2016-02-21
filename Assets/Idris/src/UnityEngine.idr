module UnityEngine

import public CIL.FFI

%access public export

unityStruct : String -> CILTy
unityStruct typeName = CILTyVal "UnityEngine" ("UnityEngine." ++ typeName)

unityClass : String -> CILTy
unityClass typeName = CILTyRef "UnityEngine" ("UnityEngine." ++ typeName)

Vector3Ty : CILTy
Vector3Ty = unityStruct "Vector3"

Vector3 : Type
Vector3 = CIL $ Vector3Ty

QuaternionTy : CILTy
QuaternionTy = unityStruct "Quaternion"

Quaternion : Type
Quaternion = CIL QuaternionTy

UnityObjectTy : CILTy
UnityObjectTy = unityClass "Object"

UnityObject : Type
UnityObject = CIL UnityObjectTy

GameObjectTy : CILTy
GameObjectTy = unityClass "GameObject"

GameObject : Type
GameObject = CIL GameObjectTy

Transform : Type
Transform = CIL $ unityClass "Transform"

vec3 : Float -> Float -> Float -> CIL_IO Vector3
vec3 = new (Float -> Float -> Float -> CIL_IO Vector3)

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

RotateAround : Transform -> (origin : Vector3) -> (axis : Vector3) -> (angle : Double) -> CIL_IO ()
RotateAround =
  invoke (CILInstance "RotateAround")
         (Transform -> Vector3 -> Vector3 -> Double -> CIL_IO ())

transform : GameObject -> CIL_IO Transform
transform =
  invoke (CILInstance "get_transform")
         (GameObject -> CIL_IO Transform)

Log : o -> CIL_IO ()
Log obj =
  invoke (CILStatic (unityClass "Debug") "Log")
         (Object -> CIL_IO ())
         (believe_me obj)

deltaTime : CIL_IO Double
deltaTime =
  invoke (CILStatic (unityClass "Time") "get_deltaTime")
         (CIL_IO Double)
