using UnityEngine;

[RequireComponent (typeof(MeshFilter))]
[RequireComponent (typeof(MeshRenderer))]
public class CreateMesh : MonoBehaviour {

  public void Start () {
    CreateMeshBehaviour.Start (gameObject);
  }

  public void Update () {
    CreateMeshBehaviour.Update (gameObject);
  }
}
