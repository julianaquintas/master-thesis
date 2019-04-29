<Cabbage>  bounds(0, 0, 0, 0)
form caption("Fire Generator") size(900, 900)
rslider bounds(14, 138, 100, 102) range(0, 1, 0.516, 1, 0.001) channel("HissGain")   text("Hissing Gain") value(0.516) textboxcolour(255, 255, 255, 255) trackercolour(89, 0, 0, 255)
rslider bounds(14, 22, 100, 100) range(800, 2000, 1006.67, 1, 0.001) channel("HissFreq") text("Hissing Frequency")  value(1006.67) trackercolour(89, 0, 0, 255)
rslider bounds(128, 22, 100, 100) range(15, 250, 25, 1, 0.001) text("Flames filter") value(25) trackercolour(89, 0, 0, 255) channel("FlameFreq")
rslider bounds(126, 136, 98, 101), channel("FlameGain"), range(0, 1, 0.59, 1, 0.001),  trackercolour(89, 0, 0, 255), 
rslider bounds(242, 20, 101, 102) range(50, 300, 150, 1, 0.001) channel("CrackleFilter") text("Crackle filter") value(0.52)
rslider bounds(236, 136, 104, 103) range(0, 1, 0, 1, 0.001) channel("CrackleGain") text("Crackle Gain")
rslider bounds(360, 20, 104, 102) range(0, 50, 10, 1, 1) channel("DustDensity") increment(1) text("Dust Density") value(10)
rslider bounds(356, 134, 108, 106) range(0, 1, 0, 1, 0.001) channel("DustGain") text("Dust Gain")
rslider bounds(482, 18, 98, 107) range(0, 250, 200, 1, 0.001) channel("LappingRange") value(200) text("LapRange")
rslider bounds(482, 134, 102, 104) range(0, 500, 100, 1, 0.001) value(25) text("Cycles") channel("LapModFreq")
</Cabbage>
<CsoundSynthesizer>

-odac
</CsOptions>
<CsInstruments>
; Initialize the global variables. 
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

instr 1 ;FLAME NOISE

    kGain chnget "FlameGain"
    kRange chnget "LappingRange"
    kRate chnget "LapModFreq" 

    kFreq gaussi kRange, 1, kRate
    aFlame oscili 0.6, kFreq, 1
        
         outs aFlame*kGain, aFlame*kGain
endin

instr 2 ;HISSING

    kGain2 chnget "HissGain"
    kFreq2 chnget "HissFreq"
    
    gaPinkNoise pinker
    
    aLOpink lowpass2 gaPinkNoise, 1, 5
    aLOpinkSQ mac aLOpink, aLOpink
    aHIpink buthp gaPinkNoise, kFreq2 
    aHissing mac aLOpinkSQ, aHIpink
        
        outs aHissing*kGain2, aHissing*kGain2
endin

instr 3 ;CRACKLING

    kGain3 chnget "CrackleGain"
    kFreq3 chnget "CrackleFilter"
    
    aLowPink lowpass2 gaPinkNoise, 10, 25
    kRMS rms aLowPink

    if (kRMS > 0.51 && kRMS < 0.52 ) then
        kRandAmp linrand .7
        kRandFreq linrand 300
        endif

    aCracks noise kRandAmp, 0 
    aSound1 butterbp aLowPink, kRandFreq, 10
	aCrackling mac aCracks, aSound1
	asig eqfil aCrackling, kFreq3, 100, 5
    aOut clip asig, 1, 0.2
    kenv linsegr 0,0.1,1,0.5,0
        
        outs aOut*kenv*kGain3, aOut*kenv*kGain3
endin 

instr 4 ;DUST CRACKLING
   
    kDustDensity chnget "DustDensity"
    kGain3 chnget "DustGain"

    a1 dust2 kGain3, kDustDensity
    aDust eqfil a1, 250, 100, 10
        
        outs aDust, aDust
endin
 
</CsInstruments>
<CsScore>
f 1 0 16384 10 1
i 1 0 z
i 2 0 z
i 3 0 z
i 4 0 z
</CsScore>
</CsoundSynthesizer>


