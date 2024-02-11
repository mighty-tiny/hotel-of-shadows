using System.Collections;
using System.Collections.Generic;
using UnityEngine;
public class Flashlight : MonoBehaviour
{
	public Light flashlightLightSource;
	bool lightOn = true;
    float lightDrain = 0.1f;
    private static float batteryLife = 0;
	float maxBatteryLife = 2.0f;
    
    private static float batteryPower = 1;

	float barDisplay = 0;
	Vector2 pos = new Vector2(20,40);
	Vector2 size = new Vector2(60,20);
	Texture2D progressBarEmpty;
	Texture2D progressBarFull;

	AudioClip soundTurnOn;
	AudioClip soundTurnOff;
    
    
    void Start()
	{
		batteryLife = maxBatteryLife;
        flashlightLightSource = GetComponent<Light>();
    }


	static void AlterEnergy(int amount)
	{
		batteryLife = Mathf.Clamp(batteryLife + batteryPower, 0, 100);

	}



	void Update()
	{

		//BATTERY LIFE BRIGHTNESS//////////
		if (lightOn && batteryLife >= 0)
		{
			batteryLife -= Time.deltaTime * lightDrain;
		}
		if (lightOn && batteryLife <= 0.4)
		{
			flashlightLightSource.intensity = 5;
		}
		if (lightOn && batteryLife <= 0.3)
		{
			flashlightLightSource.intensity = 4;
		}
		if (lightOn && batteryLife <= 0.2)
		{
			flashlightLightSource.intensity = 3;
		}
		if (lightOn && batteryLife <= 0.1)
		{
			flashlightLightSource.intensity = 2;
		}
		if (lightOn && batteryLife <= 0)
		{
			flashlightLightSource.intensity = 0;
		}



		barDisplay = batteryLife;

		if (batteryLife <= 0)
		{
			batteryLife = 0;
			lightOn = false;
		}

		if (Input.GetKeyUp(KeyCode.F))
		{
			toggleFlashlight();
			toggleFlashlightSFX();

			if (lightOn)
			{
				lightOn = false;
			}
			else if (!lightOn && batteryLife >= 0)
			{
				lightOn = true;
			}
		}
	}

	/////// PIC  ///////////
	void OnGUI()
	{

		//// draw the background:
		//GUI.BeginGroup(new Rect(pos.x, pos.y, size.x, size.y));
		//GUI.Box(Rect(0, 0, size.x, size.y), progressBarEmpty);

		//// draw the filled-in part:
		//GUI.BeginGroup(new Rect(0, 0, size.x * barDisplay, size.y));
		//GUI.Box(Rect(0, 0, size.x, size.y), progressBarFull);
		//GUI.EndGroup();

		//GUI.EndGroup();

	}

	void toggleFlashlight()
	{
		if (lightOn)
		{
			flashlightLightSource.enabled = false;
		}
		else
		{
			flashlightLightSource.enabled = true;
		}
	}
	void toggleFlashlightSFX()
	{
		if (flashlightLightSource.enabled)
		{
			GetComponent<AudioSource>().clip = soundTurnOn;
		}
		else
		{
			GetComponent<AudioSource>().clip = soundTurnOff;
		}
		GetComponent<AudioSource>().Play();

	}







}
