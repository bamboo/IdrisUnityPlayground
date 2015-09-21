using UnityEngine;

public class GameOfLife : MonoBehaviour {
	
	public GameObject prefab;
	
	Game state;
	
	void Start () {
		state = GameOfLifeBehaviour.start ();
	}
	
	void Update () {
		state = GameOfLifeBehaviour.update (prefab, state);
	}
}
