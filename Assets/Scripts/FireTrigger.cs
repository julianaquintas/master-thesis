using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FireTrigger : MonoBehaviour
{
    CsoundUnity csound;
    ParticleSystem ps;
    ParticleSystem embers;

    private int interval = 2;
    float size;
    public float min = 1;
    public float max = 5;
    float dustDensity;

    void Awake()
    {
        csound = GetComponent<CsoundUnity>();
        ps = GetComponent<ParticleSystem>();
        embers = GameObject.Find("Embers").GetComponent<ParticleSystem>();
        //the fire particle system
        var main = ps.main;
        //the embers particle system                         
        var emission = ps.emission;

        //the size of the flames is a random value with a user-defined range
        size = Random.Range(min, max);
        // the density of the embers is proportional to the size of flames          
        dustDensity = Random.Range(min*10, max*10);    
        main.startSize = size;
    }

    void Update()
    {
        //the particle system values are updated every other frame
        if (Time.frameCount % interval == 0)        
        { 
            var dust = embers.main;
            var main = ps.main;
            var density = embers.emission;

            //sets the rate over time of the 
            density.rateOverTime = dustDensity;
            main.startSize = size;

            //Scales the following Csound channels according to the size of the main particle system
            csound.setChannel("FlameGain", size/5f);
            csound.setChannel("CrackleGain", size / 10);
            csound.setChannel("LapModFreq", size * 100);
            //scales the Dust Crackling parameters according to the rate over time of the Embers particle system
            csound.setChannel("DustGain", dustDensity / 10f);
            csound.setChannel("DustDensity", dustDensity);
        } 
    }
}
