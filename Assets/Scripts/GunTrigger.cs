using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GunTrigger : MonoBehaviour
{

    CsoundUnity csound;
    float a = 1f;

    void Awake()
    {
        csound = GetComponent<CsoundUnity>();
    }

    void Start()
    {
        #region csoundSetChannels
        csound.setChannel("chirpTime", 0.015f);
        csound.setChannel("shellGain", 0.5f);
        csound.setChannel("barrelDur", 0.014f);
        csound.setChannel("barrelDel", 0.014f);
        csound.setChannel("barrelGain", 0.4f);
        csound.setChannel("noiseDur", 0.976f);
        csound.setChannel("noiseDel", 0.03f);
        csound.setChannel("noiseGain", 0.8f);
        csound.setChannel("Qfactor", 2f);
        csound.setChannel("Freq1", 467f);
        csound.setChannel("Freq2", 953f);
        csound.setChannel("Freq3", 3468f);
        csound.setChannel("Freq4", 6640f);
        #endregion
    }
    void Update()
    {
        if (Input.GetButtonDown("Fire1"))
        {
            csound.setChannel("Trigger", a++);
        }

        if (Input.GetKeyDown(KeyCode.Alpha1))
        {
            #region Gun1
            csound.setChannel("chirpTime", 0.015f);
            csound.setChannel("shellGain", 0.5f);
            csound.setChannel("barrelDur", 0.014f);
            csound.setChannel("barrelDel", 0.014f);
            csound.setChannel("barrelGain", 0.4f);
            csound.setChannel("noiseDur", 0.976f);
            csound.setChannel("noiseDel", 0.03f);
            csound.setChannel("noiseGain", 0.8f);
            csound.setChannel("Qfactor", 2f);
            csound.setChannel("Freq1", 467f);
            csound.setChannel("Freq2", 953f);
            csound.setChannel("Freq3", 3468f);
            csound.setChannel("Freq4", 6640f);
            #endregion
        }

        if (Input.GetKeyDown(KeyCode.Alpha2))
        {
            #region Gun2
            csound.setChannel("chirpTime", 0.024f);
            csound.setChannel("shellGain", 0.736f);
            csound.setChannel("barrelDur", 0.122f);
            csound.setChannel("barrelDel", 0.014f);
            csound.setChannel("barrelGain", 0.976f);
            csound.setChannel("noiseDur", 0.976f);
            csound.setChannel("noiseDel", 0.05f);
            csound.setChannel("noiseGain", 0.982f);
            csound.setChannel("Qfactor", 1f);
            csound.setChannel("Freq1", 136f);
            csound.setChannel("Freq2", 450f);
            csound.setChannel("Freq3", 1334f);
            csound.setChannel("Freq4", 4860f);
            #endregion
        }
        if (Input.GetKeyDown(KeyCode.Alpha3))
        {
            #region Gun3;
            csound.setChannel("chirpTime", 0.5f);
            csound.setChannel("shellGain", 1f);
            csound.setChannel("barrelGain", 0f);
            csound.setChannel("noiseGain", 0f);
            csound.setChannel("Qfactor", 5f);
            csound.setChannel("Freq1", 336f);
            csound.setChannel("Freq2", 738f);
            csound.setChannel("Freq3", 1142f);
            csound.setChannel("Freq4", 4000f);
            #endregion 
        }
        if (Input.GetKeyDown(KeyCode.Alpha4))
        {
            #region Gun4;
            csound.setChannel("shellGain", 0f);
            csound.setChannel("barrelDur", 0.414f);
            csound.setChannel("barrelDel", 0.01f);
            csound.setChannel("barrelGain", 0.9f);
            csound.setChannel("noiseDur", 1f);
            csound.setChannel("noiseDel", 0.025f);
            csound.setChannel("noiseGain", 0.7f);
            csound.setChannel("Qfactor", 3f);
            csound.setChannel("Freq1", 182f);
            csound.setChannel("Freq2", 628f);
            csound.setChannel("Freq3", 2354f);
            csound.setChannel("Freq4", 7820f);
            #endregion
        }
    }

}