<Cabbage>
bounds(0, 0, 0, 0)
form caption("Wind") size(600, 600),  pluginid("wind")
rslider bounds(62, 64, 146, 133) range(0, 0.1, 0.01, 1, 0.001) channel("Speed") value(0.01) text("Windspeed") valuetextbox(1)
vslider bounds(408, 42, 50, 150) range(0, 1, 0.2, 0.5, 0.001) channel("WindGain") text("Ambient Wind Gain") valuetextbox(1) value(0.2)
rslider bounds(68, 240, 126, 130) range(100, 500, 200, 1, 0.001) channel("LowFreq") text("Bandpass 1")  valuetextbox(1) value(200)
rslider bounds(220, 240, 147, 125) range(500, 1000, 800, 1, 0.001) text("Bandpass 2") channel("MidFreq") value(800)
rslider bounds(386, 236, 119, 129) range(1000, 3000, 2000, 1, 0.001) channel("HiFreq") text("Bandpass 3") valuetextbox(1) value(2000)
vslider bounds(318, 40, 44, 150) range(0, 1, 0, 0.5, 0.001) channel("WiresGain") text("Whistling Gain") valuetextbox(1)
vslider bounds(234, 40, 50, 150) range(0, 1, 0, 0.5, 0.001) channel("HowlGain") text("Howl Gain") valuetextbox(1)
rslider bounds(72, 392, 152, 127) range(0, 300, 100, 1, 0.001) channel("LowPass") value(100) text("Lowpass Freq")
rslider bounds(470, 34, 106, 100) range(0, 100, 30, 1, 0.001) channel("HowlFreq") value(30) text("Howl Freq")
</Cabbage>
<CsoundSynthesizer> bounds(0, 0, 0, 0)
<CsOptions>
-n -d -+rtmidi=NULL -M0 -m0d 
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

instr 1 ;AMBIENT WIND

    kSpeed chnget "Speed"
    kWindGain chnget "WindGain"
    kLowFreq chnget "LowFreq"
    kMidFreq chnget "MidFreq"
    kHiFreq chnget "HiFreq"
    kLowPass chnget "LowPass"

    gaWindSpeed poscil 1, kSpeed

    gaNoise noise 1, -0.999
    aLowPass butterlp gaNoise, kLowPass
    aLowFreq butterbp gaNoise, kLowFreq, 100
    aMidFreq butterbp gaNoise, kMidFreq, 400
    aHiFreq butterbp gaNoise, kHiFreq, 800
    
    aFilNoise = aLowFreq+aMidFreq+aHiFreq
    aWindRise maca gaWindSpeed, aFilNoise
    aWind sum aWindRise, aLowPass

        outs aWind*kWindGain, aWind*kWindGain     
    
endin
  
instr 2 ;WHISTLING WIRES 

    kWireGain chnget "WiresGain"
    krand randi 200, 1
    aWfilter1 resonr gaNoise, (gaWindSpeed*400)+600+krand, 60 
    aWire1 maca gaWindSpeed, aWfilter1   
    aWfilter2 resonr gaNoise, (gaWindSpeed*1000)+800+krand, 60 
    aWire2 maca gaWindSpeed, aWfilter2   
    
    aWire sum aWire1, aWire2
    aWires clip aWire, 0, 0.3
    
        outs aWires*(kWireGain), aWires*(kWireGain)
        
endin

instr 3 ;HOWLS
 
    kHowlGain chnget "HowlGain"
    kHowlFreq chnget "HowlFreq"
 
    a1CtrlSigDel delay gaWindSpeed, 0.1
    a1CtrlSigClip clip a1CtrlSigDel, 0, 0.2 
    a1CtrlLP butterlp a1CtrlSigClip, 0.5
    
    a1CtrlFreq = (a1CtrlLP * 200) + kHowlFreq
    a1CtrlHowl poscil 0.3, a1CtrlFreq
    
    a1NoiseBP resonr gaNoise, 400, 10
    a1Howl = a1NoiseBP * a1CtrlHowl
    
    a2CtrlSigDel delay gaWindSpeed, 0.3
    a2CtrlSigClip clip a2CtrlSigDel, 0, 0.1
    a2CtrlLP butterlp a2CtrlSigClip, 0.25
    
    a2CtrlFreq = (a2CtrlLP * 100) + kHowlFreq
    a2CtrlHowl poscil 0.3, a2CtrlFreq
    
    a2NoiseBP resonr gaNoise, 300, 5
    a2Howl = a2NoiseBP * a2CtrlHowl 
    
    aHowls = a1Howl*0.02 + a2Howl*0.02
    outs aHowls*(kHowlGain/10), aHowls*(kHowlGain/10)
    
endin    
    
/*instr 99 
 aL, aR monitor
	fout "wind_04.wav", 14, aL, aR
          
endin */
</CsInstruments>
<CsScore>
i 1 0 z
i 2 0 z
i 3 0 z
;i 99 0 10
</CsScore>
</CsoundSynthesizer>