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
		if (other.CompareTag( Player.tag)) //Checks if player is in trigger
		{
			audio.PlayOneShot(scareSound);

		}
	}
}
