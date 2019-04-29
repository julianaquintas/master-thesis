<Cabbage>
bounds(0, 0, 0, 0)
form caption("Wind") size(600, 600),  pluginid("wind")
rslider bounds(46, 32, 126, 130) range(400, 1200, 800, 1, 0.001) channel("GustFreq") text("Gust LowPass Freq")  valuetextbox(1) value(800)
vslider bounds(240, 42, 50, 150) range(0, 1, 0, 1, 0.001) text("Gust Gain") channel("GustGain") popuptext("Gust Gain") valuetextbox(1)
vslider bounds(306, 54, 50, 150) range(0, 1, 0, 1, 0.001) channel("SquallGain") text("Squall Gain") valuetextbox(1)
vslider bounds(366, 48, 50, 150) range(0, 1, 0, 1, 0.001) channel("HowlGain") text("Howl Gain") valuetextbox(1)
vslider bounds(446, 56, 50, 150) range(0, 1, 0, 1, 0.001) channel("TreeGain") text("Tree Leaves Gain") alpha(0.8) valuetextbox(1)
vslider bounds(252, 252, 50, 150) range(0, 1, 0, 1, 0.001) channel("WiresGain") text("Whistling Wires gain") valuetextbox(1)
rslider bounds(54, 242, 146, 133) range(0, 0.2, 0.01, 1, 0.001) channel("Speed") value(0.01) text("Windspeed") valuetextbox(1)
vslider bounds(346, 256, 50, 150) range(0, 1, 0.5, 1, 0.001) channel("WindGain") text("Wind Gain") valuetextbox(1) value(0.5)
</Cabbage>
<CsoundSynthesizer> bounds(0, 0, 0, 0)
<CsOptions>
-n -d 
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 16
nchnls = 2
0dbfs = 1


instr 1 ;AMBIENT WIND

    kSpeed chnget "Speed"
    kWindGain chnget "WindGain"
    gaNoise pinker
    kFreq chnget "GustFreq"
    kLpan = 0.25
    kRpan = 0.75

  
    gaWindSpeed poscil 0.6, kSpeed
    
    aBPnoise butterbp gaNoise, kFreq, 800
    aWindNoise maca gaWindSpeed+0.2, gaNoise
   
    
    aWind sum aWindNoise, aBPnoise
      outs aWind*kWindGain, aWind*kWindGain
     ;outs (aWindNoise-aRzero)*0.6, (aWindNoise-aRzero)*0.6 ;Output
    
endin
  
instr 2 ;WHISTLING WIRES 

    kWireGain chnget "WiresGain"

    aWfilter1 resonr gaNoise, (gaWindSpeed*400)+600, 60 ; experimentar numeros aleatorios com range pequeno em freq
    aWspeedsq maca gaWindSpeed+0.12, gaWindSpeed+0.12    
    aWire1 maca aWfilter1, aWspeedsq   
    aWfilter2 resonr gaNoise, (gaWindSpeed*1000)+1000,60 ; experimentar numeros aleatorios com range pequeno em freq   
    aWire2 maca aWspeedsq, aWfilter2   
    aWires sum aWire1*1.2, aWire2*2
    
        outs aWires*kWireGain, aWires*kWireGain 
    
    
endin

instr 3 ;TREE LEAVES

    kTreeGain chnget "TreeGain"

    aCtrlSigDel delay gaWindSpeed, 2
    aCtrlSigLP lowpass2 aCtrlSigDel, 0.1, 100   
    aLeafCtrlSig = 0-(aCtrlSigLP*0.5)+0.3
    aLeaves1 max gaNoise, aLeafCtrlSig
    aLeaves2 = (aLeaves1-aLeafCtrlSig) * aLeafCtrlSig
    aLeavesHP butterhp aLeaves2, 200
    aLeavesLP butterlp aLeavesHP, 4000 
    aTreeLeaves maca aLeavesLP, aCtrlSigLP
    
        outs aLeavesLP*kTreeGain, aLeavesLP*kTreeGain

endin
instr 4 ;HOWLS
 
    kHowlGain chnget "HowlGain"
 
    a1CtrlSigDel delay gaWindSpeed, 0.1
    a1CtrlSigClip clip a1CtrlSigDel, 0, 0.6
    a1CtrlSig = ((a1CtrlSigClip -0.35) * 2) - 0.25
    a1CtrlLP butterlp cos(a1CtrlSig), 0.5
    a1CtrlFreq = (a1CtrlLP * 200) + 30
    a1CtrlHowl poscil 0.5, a1CtrlFreq
    a1NoiseBP resonr gaNoise, 400, 10
    a1Howl = (a1NoiseBP * a1CtrlLP) * 2 * a1CtrlHowl
    
    a2CtrlSigDel delay gaWindSpeed, 0.3
    a2CtrlSigClip clip a2CtrlSigDel, 0, 0.5
    a2CtrlSig = ((a2CtrlSigClip -0.25) * 2) - 0.25
    a2CtrlLP butterlp cos(a2CtrlSig), 0.1
    a2CtrlFreq = (a2CtrlLP * 100) + 20
    a2CtrlHowl poscil 0.5, a2CtrlFreq
    a2NoiseBP resonr gaNoise, 200, 5
    a2Howl = (a2NoiseBP * a2CtrlLP) * 2 * a1CtrlHowl
    
    aHowls = a1Howl*0.1 + a2Howl*0.1
    outs aHowls*kHowlGain, aHowls*kHowlGain
        ;outs (a1Howl+a*kHowlGain, (a1Howl+a2Howl)*kHowlGain ; implementar controlo de ganhos e evitar stuttering
    
endin
</CsInstruments>
<CsScore>
i 1 0 z
i 2 0 z
i 3 0 z
i 4 0 z

</CsScore>
</CsoundSynthesizer>