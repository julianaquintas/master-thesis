using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WindTrigger : MonoBehaviour
{
    CsoundUnity csoundUnity;
    public string channel1;             //First Csound channel
    public float enterValue1;           //Value for the first channel when within the Trigger area
    public float exitValue1 = 0;        //Value for the first channel after leaving the  Trigger area
    public string channel2;             //Second Csound channel
    public float enterValue2;           //Value for the second channel when within the Trigger area
    public float exitValue2 = 0;        //Value for the second channel after leaving the  Trigger area

    void Awake()
    {
        //Finds the CsoundUnity Component attached to the MainCamera Game Oject
        csoundUnity = GameObject.Find("MainCamera").GetComponent<CsoundUnity>(); 
    }

    void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "Player")
            {
            //If a Game Object with the "Player" tag enters this  Game bject's trigger collider:
            //send the entry values for two channels to the CsoundUnity script in MainCamera.
            csoundUnity.setChannel(channel1, enterValue1);
            csoundUnity.setChannel(channel2, enterValue2);
        }
    }

    void OnTriggerExit(Collider other)
    {
        if (other.gameObject.tag == "Player") //Once
        {
            //If a Game Object with the "Player" tag leaves the trigger collider: 
           //Send the exit value for the same channels to the CsoundUnity script in Main Camera.
            csoundUnity.setChannel(channel1, exitValue1);
            csoundUnity.setChannel(channel2, exitValue2);
        }
    }
}
