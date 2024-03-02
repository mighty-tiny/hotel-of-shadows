using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class enemysound : MonoBehaviour
{
	GameObject Player;
	[SerializeField] private AudioClip scareSound;
	private AudioSource audio;

	void OnTriggerEnter(Collider other)//Check if something has entered the trigger ( and declares this object in "other" )
	{
		if (other.CompareTag("Player")) //Checks if player is in trigger
		{
			PlayerMovement.Lost = true;
			audio.PlayOneShot(scareSound);
			Debug.Log("gg");
		}
	}
}
