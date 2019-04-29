
<CsoundUnity>
active(0) alpha(0) bounds(0, 0, 0, 0) surrogatelinenumber(0) visible(0)
bounds(0, 0, 0, 0)
form caption("Gunfire") size(650, 690),
button bounds(50, 92, 169, 56) channel("Trigger") text("Trigger", "Trigger") popuptext("One-shot Trigger") colour:0(97, 1, 1, 255) colour:1(97, 1, 1, 255)
label bounds(50, 198, 168, 30) text("Shell")
rslider bounds(52, 238, 90, 90) range(0, 0.5, 0.01, 1, 0.001) text("Chirp time") channel("chirpTime") popuptext("Chirp time") alpha(0.96) valuetextbox(1) value(0.05)
vslider bounds(166, 238, 50, 90) range(0, 1, 1, 1, 0.001) channel("shellGain") value(1)
label bounds(278, 100, 165, 30) text("Barrel")	
rslider bounds(278, 144, 90, 90) range(0, 1, 0.028, 1, 0.001) text("Duration") channel("barrelDur") value(0.028) alpha(0.88) valuetextbox(1)
rslider bounds(278, 244, 91, 90) range(0.001, 1, 0.014, 1, 0.001) channel("barrelDel") text("Delay") value(0.014) alpha(0.84) valuetextbox(1)
vslider bounds(394, 144, 50, 189) range(0, 1, 1, 1, 0.1) channel("barrelGain") value(1) 
label bounds(468, 102, 165, 30) text("Exc. Noise") popuptext("Excitation Noise")
rslider bounds(468, 146, 90, 90) range(0, 1.5, 0.9642, 1, 0.001) channel("noiseDur") text("Duration") value(0.9642) valuetextbox(1)
rslider bounds(468, 242, 90, 90) range(0.001, 0.7, 0.053, 1, 0.001) channel("noiseDel") text("Delay") value(0.053) valuetextbox(1)
vslider bounds(576, 146, 50, 186) range(0, 1, 1, 1, 0.001) value(1) channel("noiseGain")
label bounds(28, 356, 602, 24) text("Body Formant Filters")
rslider bounds(160, 386, 102, 63) range(20, 500, 500, 1, 0.001) channel("Freq1") value(500) valuetextbox(1)
rslider bounds(290, 386, 102, 60) range(400, 1000, 1329, 1, 0.001) channel("Freq2") value(1329) valuetextbox(1)
rslider bounds(410, 386, 108, 60) range(2000, 4000, 1682, 1, 0.001) channel("Freq3") value(1682) valuetextbox(1)
rslider bounds(538, 386, 88, 60) range(4000, 9000, 6000, 1, 0.001) channel("Freq4") value(6000) alpha(0.88) valuetextbox(1)
rslider bounds(28, 388, 110, 60) range(0, 10, 5, 1, 0.001) channel("Qfactor") value(5) trackercolour(0, 65, 118, 255) alpha(0.96) valuetextbox(1)
</CsoundUnity>
<CsoundSynthesizer>
<CsOptions>
-n -d --displays
</CsOptions>
<CsInstruments>.
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

instr 1 ;TRIGGER
   
    kTrigger chnget	"Trigger"

    if changed(kTrigger)==1 then
        event "i", 2, 0, -1     
 		
    endif   
   
endin

instr 2 ;GUN

;2.1.SHELL
    
    iChirpTime chnget "chirpTime" 
    iShellGain chnget "shellGain"
    
    kSwipe linseg 1000, iChirpTime, 100
    aShellSig oscil 1, kSwipe
    kShellEnv linseg iShellGain, iChirpTime, 0
    
    aShell = aShellSig*kShellEnv
                                                
;2.2.BARREL

    iBarrelDur chnget "barrelDur"
    iBarrelDel chnget "barrelDel"
    iBarrelGain chnget "barrelGain" 
    

    aBarrelEnv linseg 1, iBarrelDur, 0 
    aBarrelSwipe linseg 150, iBarrelDur, 0
    aBarrelOsc poscil aBarrelEnv, aBarrelSwipe          
    aBarrelSig delay aBarrelOsc, iBarrelDel 
    
    aBarrel = aBarrelSig*iBarrelGain

;2.3.EXCITATION NOISE

    iNoiseDur chnget "noiseDur"
    iNoiseDel chnget "noiseDel"
    iNoiseGain chnget "noiseGain"

    aExcEnv linseg 1, iNoiseDur, 0
    
    aNoise pinker
    aNoiseSig delay aNoise*aExcEnv, iNoiseDel  
    aExcNoise = aNoiseSig*iNoiseGain
                   
;2.4.BODY FORMANT

    kQ chnget "Qfactor" 
     
    aLP1,aHP1,aBP1 svfilter aShell+aBarrel+aExcNoise, chnget:k("Freq1"), kQ
    aLP2,aHP2,aBP2 svfilter aShell+aBarrel+aExcNoise, chnget:k("Freq2"), kQ 
    aLP3,aHP3,aBP3 svfilter aShell+aBarrel+aExcNoise, chnget:k("Freq3"), kQ
    aLP4,aHP4,aBP4 svfilter aShell+aBarrel+aExcNoise, chnget:k("Freq4"), kQ
  
    aShot sum aBP1, aBP2, aBP3, aBP4, aExcNoise
    
    	outs aShot, aShot 
endin 

instr 99

 aL, aR monitor
 
 fout "Gunshot.wav", 14, aL, aR
 
endin
</CsInstruments>
<CsScore>
i 1 0 z
</CsScore>
</CsoundSynthesizer> 