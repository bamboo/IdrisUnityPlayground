module RotateBehaviour

import UnityEngine

update : GameObject -> CIL_IO ()
update go = do
  origin <- vec3 0 0 0
  axis   <- vec3 1 0 0
  RotateAround !(transform go) origin axis (90 * !deltaTime)

exports : FFI_Export FFI_CIL "RotateBehaviour" []
exports =
  Fun update CILDefault
  End
