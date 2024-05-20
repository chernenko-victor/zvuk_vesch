<CsoundSynthesizer>
<CsOptions>
-n -d 
</CsOptions>
<CsInstruments>
; Initialize the global variables. 
ksmps = 32
nchnls = 8
0dbfs = 1

giOutChn_1 = 1
giOutChn_2 = 2
giOutChn_3 = 3
giOutChn_4 = 4
giOutChn_5 = 5
giOutChn_6 = 6
giOutChn_7 = 7
giOutChn_8 = 8

gS_dump_file = "C:\\home\\chernenko\\src\\csound\\tmp\\zvuk_vesch.wav"


gaDumpOut[] init 8
gaSpatialOut[] init 8

//gaReverSend init 0

giDurArr[] fillarray 1, 2, 3, 4, 6, 8, 12, 16, 24, 32
giDurMin init .25

chn_a "fftA", 2
chn_a "fftB", 2
chn_k "FftModType", 2

giSampleBank[] init 4, 2

giSampleBank[0][0] = 0
giSampleBank[0][1] = 6

giSampleBank[1][0] = 7
giSampleBank[1][1] = 13

giSampleBank[2][0] = -1
giSampleBank[2][1] = -1

giSampleBank[3][0] = -1
giSampleBank[3][1] = -1


gS_path1 = "C:\\home\\chernenko\\src\\csound\\dev2\\csound\\dev_stohastic\\soundin."
gS_filename_arr[] init 14
gS_filename_arr[0] = strcatk(gS_path1, "1")
gS_filename_arr[1] = strcatk(gS_path1, "2")
gS_filename_arr[2] = strcatk(gS_path1, "3")
gS_filename_arr[3] = strcatk(gS_path1, "4")
gS_filename_arr[4] = strcatk(gS_path1, "10")
gS_filename_arr[5] = strcatk(gS_path1, "14")
gS_filename_arr[6] = strcatk(gS_path1, "14")

gS_filename_arr[7] = strcatk(gS_path1, "5")
gS_filename_arr[8] = strcatk(gS_path1, "7")
gS_filename_arr[9] = strcatk(gS_path1, "15")
gS_filename_arr[10] = strcatk(gS_path1, "14")
gS_filename_arr[11] = strcatk(gS_path1, "21")
gS_filename_arr[12] = strcatk(gS_path1, "22")
gS_filename_arr[13] = strcatk(gS_path1, "23")


giSampleOffset[] fillarray 3, 0.5, 0, .33, 2, 3.4, 4.4,         0, 0, 0, 0, 0, 0, 0
giSampleSpeed[] fillarray .05, .1, .1, .1, .1, .1, .1,          1, 1, 1, 1, 1, 1, 1
giSampleGain[] fillarray  2, 3, 20, 1, 1, 2, 2,                 1, 1, 1, 1, 1, 1, 1
giSampleVolAfterComp[] fillarray  2, 3, 2.5, 1, 6, 1, 1,        .5, 1, .5, .5, .5, .5, .5


giMaxDur = 60.
giMinDur = .2

/*
D:\src\csound\edu\sa\csound_edu\lsn10\cl_solo_am.wav S
D:\src\csound\edu\sa\csound_edu\lsn9\loop.wav S
D:\src\csound\edu\sa\csound_edu\lsn9\Stairwell.wav M
D:\src\csound\edu\sa\csound_edu\lsn9\dish.wav    M
D:\src\csound\edu\sa\csound_edu\lsn8\BratscheMono.wav M
D:\src\csound\edu\sa\2020_2021\lsn8\fox.wav     M
D:\src\csound\edu\sa\csound_edu\lsn8\cl_solo_a1_mono.wav M
D:\src\csound\edu\sa\2022_23\lsn8\ClassGuit.wav M
D:\src\csound\edu\sa\2022_23\lsn8\339324__inspectorj__stream-water-c-mono.wav M
D:\\tmp\\__music\\sample\\edu\\68444__pinkyfinger__piano-eb.wav ?
*/

seed 0

//opcode exp_scale

gS_instr_name[] init 8
gS_instr_name[0] = "additive_my"
gS_instr_name[1] = "SubstrPoly"
gS_instr_name[2] = "play_sample" //fft
gS_instr_name[3] = "play_sample" //no fft
gS_instr_name[4] = "closed_hihat"
gS_instr_name[5] = "snare"
gS_instr_name[6] = "bass_drum"
gS_instr_name[7] = "additive_my_harmonic"

giRythmArr1[] fillarray 1, 2, 3, 4, 6, 8, 12, 16, 24, 32
giRythmArr1Weight[] fillarray 50, 40, 30, 50, 30, 40, 10, 10, 5, 5
//print sumarray(giRythmArr1Weight)
giRythmArr1Weight = giRythmArr1Weight/sumarray(giRythmArr1Weight)
//print sumarray(giRythmArr1Weight)
//printarray(giRythmArr1Weight)



//===========================================================================
//====================      LIBS, OPCODEs       ============================
//===========================================================================


#include "C:\\home\\chernenko\\src\\csound\\dev2\\csound\\include\\math\\stochastic\\distribution3.inc.csd"

opcode spatial_my, 0, a
    aIn xin 
    
    iAzimuthB = random:i(0., 360)
    iAzimuthE = random:i(0., 360)
     
    iAltitudeB = random:i(0., 360)
    iAltitudeE = random:i(0., 360)
    
    
    //spatialization
    aSpatialOut[] init 8
    aBform[] init 4
    
    kalpha line iAzimuthB, p3, iAzimuthE
    kbeta line iAltitudeB, p3, iAltitudeE
    
    //azimuth, altitude
    aBform bformenc1 aIn, kalpha, kbeta
    aSpatialOut bformdec1 5, aBform
    
    //send
    gaSpatialOut += aSpatialOut
    gaDumpOut += aSpatialOut
    
    //chnmix    aSpatialOut*iRvbSendAmt, "ReverbSend"
endop


//===========================================================================
//====================      INSTRUMENTS =====================================
//===========================================================================

instr additive_my
    //seed 0
    iAmp = p4
    iFrq = p5
    iSendMain = p6
    iSendFft = p7
    iFftChn = p8
    iRvbSendAmt = p9
    
    iAzimuthB = random:i(0., 360)
    iAzimuthE = random:i(0., 360)
     
    iAltitudeB = random:i(0., 360)
    iAltitudeE = random:i(0., 360)

    kFrqMod[] poly 8, "rspline", .995, 1.005, 1, 10

    kFreqs[] fillarray 1., 1.5, 2.09, 2.7, 3.33, 5, 7.48, 9
    aOut[] poly 8, "oscili", iAmp/8, kFreqs * kFrqMod * iFrq
    
    aMono sumarray aOut
    aMono *= linsegr:a(0, 0.05, 1, 0.05, 0)
    //aMono *= adsr:a(.2, .1, 1, .2)
    
    //spatial_my(aMono)
    //outs aMono, aMono
    outs aMono*iSendMain, aMono*iSendMain
    
    if iFftChn==0 then
        chnset aMono*iSendFft, "fftA"
    else
        chnset aMono*iSendFft, "fftB"
    endif
    
    chnmix    aMono*iRvbSendAmt, "ReverbSend"
endin


instr additive_my_harmonic
    //seed 0
    iAmp = p4
    iFrq = p5
    iSendMain = p6
    iSendFft = p7
    iFftChn = p8
    iRvbSendAmt = p9
    
    iAzimuthB = random:i(0., 360)
    iAzimuthE = random:i(0., 360)
     
    iAltitudeB = random:i(0., 360)
    iAltitudeE = random:i(0., 360)

    kFrqMod[] poly 8, "rspline", .995, 1.005, 1, 10

    kFreqs[] fillarray 1, 2, 3, 4, 5, 6, 7, 8
    kAmps[] fillarray 1, 1/2, 1/3, 1/4, 1/5, 1/6, 1/7, 1/8
    aOut[] poly 8, "oscili", kAmps/sumarray(kAmps), kFreqs * kFrqMod * iFrq
    
    aMono sumarray aOut
    aMono *= linsegr:a(0, 0.05, 1, 0.05, 0)
    //aMono *= adsr:a(.2, .1, 1, .2)
    
    //spatial_my(aMono)
    //outs aMono, aMono
    outs aMono*iSendMain, aMono*iSendMain
    
    if iFftChn==0 then
        chnset aMono*iSendFft, "fftA"
    else
        chnset aMono*iSendFft, "fftB"
    endif
    
    chnmix    aMono*iRvbSendAmt, "ReverbSend"
endin


instr SubstrPoly
    //iFrqBase = random:i(220., 880.)
    iAmp = p4
    iFrqBase = p5
    iSendMain = p6
    iSendFft = p7
    iFftChn = p8
    iRvbSendAmt = p9
    
    //seed 0
    
    a0 pinker
    a0 *= ampdb(-12)
    
    kFreqs[] fillarray 400, 1400, 3000, 4400, 8000, 12000
    kQs[] fillarray    10,    20,   10,   20,   10,    20
    kV = ampdb(18)
    
    kFrqMod[] poly 6, "rspline", .99, 1.01, 1, 10
    kQMod[] poly 6, "rspline", .9, 1.1, 1, 10
    
    
    aMono polyseq lenarray(kFreqs), "rbjeq", a0, (kFreqs/400)*iFrqBase*kFrqMod, kV, kQs*kQMod, 1, 8
    aMono *= linsegr:a(0, 0.05, iAmp, 0.05, 0)
    
    //outs aMono, aMono
    //spatial_my(aMono)
    
    outs aMono*iSendMain, aMono*iSendMain
    
    if iFftChn==0 then
        chnset aMono*iSendFft, "fftA"
    else
        chnset aMono*iSendFft, "fftB"
    endif
    
    chnmix    aMono*iRvbSendAmt, "ReverbSend"
endin

instr fft_global
    /*
    kModType
    0   pvsfilter drone
    1   pvscross light
    2   pvscross harshy
    3   pvsvoc no scale
    4   pvsvoc scale
    */

    aInA chnget "fftA"
    aInB chnget "fftB" 
    kFftModType chnget "FftModType"
    //kFftModType = 4
    //printk 1, kFftModType
    
    gifftsiz  =         pow(2, 10)//1024
    gioverlap =         gifftsiz/2//256
    giwintyp  =         1 ;von hann window
    
    fSigAL      pvsanal   aInA, gifftsiz, gioverlap, gifftsiz*2, giwintyp
    fSigBL      pvsanal   aInB, gifftsiz, gioverlap, gifftsiz*2, giwintyp
    fSigALScale = pvscale(fSigAL, expseg:k(.2, p3, 2.))
    fSigBLScale = pvscale(fSigBL, expseg:k(2., p3, .2))
    
    kRvbSendAmt = rspline(0.01, 0.55, .1, 2)
    
    
    if kFftModType==0 then
        //fMod = pvsfilter(fSigALScale, fSigBLScale, oscili:k(0.49, .5) + .5)
        fMod = pvsfilter(fSigAL, fSigBL, rspline:k(0.9, .2, .5, 2) ) //drone
    elseif kFftModType==1 then
        //fMod = pvscross(fSigALScale, fSigBLScale, oscili:k(0.49, .5, -1) + .5, oscili:k(0.49, .5, -1, .5) + .5) //light
        fMod = pvscross(fSigAL, fSigBLScale, oscili:k(0.49, .5, -1) + .5, oscili:k(0.49, .5, -1, .5) + .5) //light more interesting
    elseif kFftModType==2 then
        fMod = pvscross(fSigAL, fSigBL, rspline:k(0.9, .2, .5, 2), rspline:k(0.9, .2, .5, 2)) //harshy
    elseif kFftModType==3 then
        fMod = pvsvoc(fSigAL, fSigBL, 1, 1) //good
    else
        fMod = pvsvoc(fSigAL, fSigBLScale, 1, 1) // Scale with no scale - good
    endif
    
    aOut pvsynth fMod
    
    kthreshold = 0.3
    icomp1 = .1
    icomp2 = 2
    irtime = 0.01
    iftime = 0.5
    aOut dam aOut, kthreshold, icomp1, icomp2, irtime, iftime
    aOut = aOut * 5
    
    
    aOut butterhp aOut, 50
    
    aOut  = limit(aOut, -0.99, .99)
    
    //spatial_my(aIn[0])
    outs aOut, aOut
    
    chnclear "fftA"
    chnclear "fftB"
    
    chnmix    aOut*kRvbSendAmt, "ReverbSend"
endin

instr fft_my
    //S_sample_file_nameA = "C:\\home\\chernenko\\audio\\cons\\env\\reaper_stems_bbc.wav"
    S_sample_file_nameA = "D:\\src\\csound\\dev2\\csound\\dev_stohastic\\soundin.1"
    //S_sample_file_nameA = "D:\\src\\csound\\dev2_export\\dev_stohastic\\soundin.29"
    //S_sample_file_nameB = "D:\\src\\csound\\edu\\sa\\csound_edu\\lsn9\\dish.wav"
    
    S_sample_file_nameB = "D:\\src\\csound\\dev2\\csound\\dev_stohastic\\soundin.3"
    
    aIn[] diskin S_sample_file_nameA, 1, 0, 1 
    //iLenArr = lenarray(aIn)
    //print(iLenArr)
    aInB[] diskin S_sample_file_nameB, 1, 0, 1 
    
    
    gifftsiz  =         pow(2, 10)//1024
    gioverlap =         gifftsiz/2//256
    giwintyp  =         1 ;von hann window
    
    fSigAL      pvsanal   aIn[0], gifftsiz, gioverlap, gifftsiz*2, giwintyp
    fSigBL      pvsanal   aInB[0], gifftsiz, gioverlap, gifftsiz*2, giwintyp
    fSigALScale = pvscale(fSigAL, expseg:k(.2, p3, 2.))
    fSigBLScale = pvscale(fSigBL, expseg:k(2., p3, .2))
    //fMod = pvsfilter(fSigALScale, fSigBLScale, oscili:k(0.49, .5) + .5)
    //fMod = pvscross(fSigALScale, fSigBLScale, oscili:k(0.49, .5, -1) + .5, oscili:k(0.49, .5, -1, .5) + .5)
    fMod = pvsvoc(fSigAL, fSigBL, 1, 1)
    aIn[0] pvsynth fMod
    
    
    kthreshold = 0.6
    icomp1 = .2
    icomp2 = 2
    irtime = 0.01
    iftime = 0.5
    aIn[0] dam aIn[0], kthreshold, icomp1, icomp2, irtime, iftime
    aIn[0] = aIn[0] * 5
    //spatial_my(aIn[0])
    
    outs aIn[0], aIn[0]
endin


instr bass_drum ; sound 1 - bass drum
iamp        random      0, 0.5               ; amplitude randomly chosen
p3          =           0.2                  ; define duration for this sound
aenv        line        1,p3,0.001           ; amplitude envelope (percussive)
icps        exprand     30                   ; cycles-per-second offset
kcps        expon       icps+120,p3,20       ; pitch glissando
aSig        oscil       aenv*0.5*iamp,kcps,-1//giSine  ; oscillator
            outs        aSig, aSig           ; send audio to outputs
//gaRvbSend   =           gaRvbSend + (aSig * giRvbSendAmt) ; add to send
  endin

  instr snare ; sound 3 - snare
iAmp        random     0, 0.5                  ; amplitude randomly chosen
p3          =          0.3                     ; define duration
aEnv        expon      1, p3, 0.001            ; amp. envelope (percussive)
aNse        noise      1, 0                    ; create noise component
iCps        exprand    20                      ; cps offset
kCps        expon      250 + iCps, p3, 200+iCps; create tone component gliss
aJit        randomi    0.2, 1.8, 10000         ; jitter on freq.
aTne        oscil      aEnv, kCps*aJit, -1//giSine ; create tone component
aSig        sum        aNse*0.1, aTne          ; mix noise and tone components
aRes        comb       aSig, 0.02, 0.0035      ; comb creates a 'ring'
aSig        =          aRes * aEnv * iAmp      ; apply env. and amp. factor
            outs       aSig, aSig              ; send audio to outputs
//gaRvbSend   =          gaRvbSend + (aSig * giRvbSendAmt); add to send
  endin

  instr closed_hihat ; sound 4 - closed hi-hat
iAmp        random      0, 1.5               ; amplitude randomly chosen
p3          =           0.1                  ; define duration for this sound
aEnv        expon       1,p3,0.001           ; amplitude envelope (percussive)
aSig        noise       aEnv, 0              ; create sound for closed hi-hat
aSig        buthp       aSig*0.5*iAmp, 12000 ; highpass filter sound
aSig        buthp       aSig,          12000 ; -and again to sharpen cutoff
            outs        aSig, aSig           ; send audio to outputs
//gaRvbSend   =           gaRvbSend + (aSig * giRvbSendAmt) ; add to send
  endin



instr play_sample
    iSampleIndx = p4
    iSendMain = p5
    iSendFft = p6
    iFftChn = p7
    iTranspose = p8    
    iRvbSendAmt = p9
    
    iAtt = 1.5
    iRel = 0.5
    iEnvType init 0
    if (iAtt + iRel) > p3 then
        //iDelta = iAtt + iRel - p3
        //iAtt = iAtt - iDelta*.7
        //iRel = iRel - iDelta*.3
        iEnvType = 1
    endif
    
    asig[] diskin gS_filename_arr[iSampleIndx], giSampleSpeed[iSampleIndx]*iTranspose, giSampleOffset[iSampleIndx], 1
    
   
    if iEnvType==0 then
        kEnvAmp adsr iAtt, 0, 1, iRel
    else 
        kEnvAmp linsegr 0, p3/2., .2, 0.001, .2, p3/2.-0.001, 0
    endif
    
    
    //kEnvAmp transeg 0.01, p3*0.75, -2, 1, p3*0.25, 2, 0.01
    
    asig[0] = asig[0] * giSampleGain[iSampleIndx]
    /*
    kthreshold = 0.6
    icomp1 = .2
    icomp2 = 2
    irtime = 0.01
    iftime = 0.5
    asig[0] dam asig[0], kthreshold, icomp1, icomp2, irtime, iftime
    
    asig[0] = asig[0] * 2
    */
    
    kthresh = 0
    kloknee = 60
    khiknee = 80
    kratio  = 4
    katt    = 0.1
    krel    = .5
    ilook   = .02
    asig[0]  compress asig[0], asig[0], kthresh, kloknee, khiknee, kratio, katt, krel, ilook
    asig[0] = asig[0] * giSampleVolAfterComp[iSampleIndx]
    
    
    asig[0] butterhp asig[0], 50
    
    asig[0]  = limit(asig[0], -0.99, .99) 
    
    outs asig[0]*kEnvAmp*iSendMain, asig[0]*kEnvAmp*iSendMain
    
    if iFftChn==0 then
        chnset asig[0]*kEnvAmp*iSendFft, "fftA"
    else
        chnset asig[0]*kEnvAmp*iSendFft, "fftB"
    endif
    
    chnmix    asig[0]*kEnvAmp*iRvbSendAmt, "ReverbSend"
endin



//===========================================================================
//====================      EFFECTS     =====================================
//===========================================================================


instr rever
    iPan = .2
    aInSig       chnget    "ReverbSend"   ; read audio from the named channel
    kTime        init      4              ; reverb time
    kHDif        init      0.5            ; 'high frequency diffusion' (0 - 1)
    aRvb         nreverb   aInSig, kTime, kHDif ; create reverb signal
    outs         aRvb*iPan, aRvb*(1-iPan)               ; send audio to outputs
    chnclear  "ReverbSend"   ; clear the named channel
endin

instr limiter
    gaSpatialOut poly 8, "limit", gaSpatialOut, -.97, .97
    gaDumpOut poly 8, "limit", gaDumpOut, -.97, .97
endin

instr master_out
    outch \ 
        giOutChn_1, gaSpatialOut[0], \ 
        giOutChn_2, gaSpatialOut[1], \
        giOutChn_3, gaSpatialOut[2], \
        giOutChn_4, gaSpatialOut[3], \
        giOutChn_5, gaSpatialOut[4], \
        giOutChn_6, gaSpatialOut[5], \
        giOutChn_7, gaSpatialOut[6], \
        giOutChn_8, gaSpatialOut[7]
        
    gaSpatialOut[0] = 0 
    gaSpatialOut[1] = 0
    gaSpatialOut[2] = 0
    gaSpatialOut[3] = 0
    gaSpatialOut[4] = 0
    gaSpatialOut[5] = 0
    gaSpatialOut[6] = 0
    gaSpatialOut[7] = 0
endin

instr dump_file
    fout gS_dump_file, 14, gaDumpOut
    
    gaDumpOut[0] = 0
    gaDumpOut[1] = 0
    gaDumpOut[2] = 0
    gaDumpOut[3] = 0
    gaDumpOut[4] = 0
    gaDumpOut[5] = 0
    gaDumpOut[6] = 0
    gaDumpOut[7] = 0
endin


instr part
    kDur init 1.5
    kDurEnvDistrType init 1
    S_instr_name = p4
    kFlag init 1
    if kFlag==1 then
        kDurMin = .25
        kDurMax = 5.5
        kFlag = 0
    endif
    
    //timeinstr
    
    
    kTrig metro 1/kDur
    kTrigDurEnv metro 0.05
    
    
    if kTrig==1 then
        kLen = rspline:k(.25, .8, .05, 1) * kDur
        kAmp = .2
        kFrq = random:k(220., 880.)
        event "i", S_instr_name, 0, kLen, kAmp, kFrq
        kDur = random:k(kDurMin, kDurMax)
        printks "kDur = %f\n", .5, kDur
    endif
    
    if kTrigDurEnv==1 then
        kDurEnvDistrType = ceil(random:k(0, 3.5))
        printks "kDurEnvDistrType = %f\n", .1, kDurEnvDistrType
        
        if kDurEnvDistrType == 1 then
            kDurMin = .25
            kDurMax = 1.5
        elseif kDurEnvDistrType == 2 then
            kDurMin = 1.
            kDurMax = 3.5
        elseif kDurEnvDistrType == 3 then
            kDurMin = .25
            kDurMax = 5.5
        else
            kDurMin = 3.
            kDurMax = 6.
        endif
    endif
    
endin 




//===========================================================================
//====================      ALGO SCORE   =====================================
//===========================================================================

/*
== Transpose == !!!!

narrow
wide

continuesly -- discrete

*/

/*
== Samples == ++

dry low
dry normal

dry + fft(low, normal)
dry + fft(normal, low)

fft(low, normal)
fft(normal, low)
*/

/*
Rever Echo
*/

/*
== Spatial ==
concentred
wider
widest
*/



//===================================================
//===============       process     =================
//===================================================
/*
random
periodical
part-lenght
*/

/*
static
slow
fast
momentary
*/




instr part_sample
    kPortam init p4
    kTempo init p5
    kInstrIndx = p6
    
    kSendMain1 = p7 
    kSendFft1 = p8
    kFftChn1 = p9
    
    kSendMain2 = p10
    kSendFft2 = p11
    kFftChn2 = p12
    
    
    kForm = p13
    //kFftModType init 0
    kFftModType = p14
    
    kSampleBank0 = p15
    kSampleBank1 = p16
    
    kFlag init 1
    kNoteCnt init 0
    kPauseCnt init 0
    kMuteFlag init 0
    kNoteCntMax init 8
    kPauseCntMax init 4
    
    kDurMinDiscr init .2
    
    chnset kFftModType, "FftModType"
  
    /*
    == Temporythm == ++

    tempo +
    porto +
    pauses +

    ===============================================================================
                        tempo          porto               pauses
    ===============================================================================             
    1   short slow      low            short               frequently--middle, long
    2   long  slow      low            long                middle--rare, short
    3   short fast      high           short               rare, short
    ===============================================================================
    */    
  
    if kFlag==1 then
        kTempo = 1.1 - kForm
        
        if kForm < .3 then
            kPortam = .5
        elseif kForm >= .3 && kForm < .6  then
            kPortam = .99
        else
            kPortam = .5
        endif
        
        kDur = giMaxDur*expcurve(kTempo, giMaxDur)
        kDurVarMax = 1.5 * kDur
        kDurVarMix = .5 * kDur
        if kDur<giMinDur then
            kDur=giMinDur
            kDurVarMin = kDur
        endif
        kNoteLen = kDur * kPortam
        
        kDurMinDiscr = kDur
        
        S_path = "C:\\home\\chernenko\\src\\csound\\dev2\\csound\\dev_stohastic\\"
        printk(.2, kDur)
        kFlag = 0
    endif
    
    kAmp = rspline(0.01, 0.95, .1, 2)
    kRevLev = 1. - kAmp
    
    kRevLevSample = rspline(0.01, 0.55, .1, 2)
    
    kTrig metro 1/kDur
    
    if kTrig==1 then
        //seed 0
    
        //printks "kMuteFlag = %f, kNoteCnt = %f, kPauseCnt = %f\n", .1, kMuteFlag, kNoteCnt, kPauseCnt
        printks "kTempo = %f, kDur = %f, kNoteLen = %f, kAmp = %f, kRevLev = %f\n", .1, kTempo, kDur, kNoteLen, kAmp, kRevLev
    
        if kNoteCnt > kNoteCntMax then
            kMuteFlag = 1
            kNoteCnt = 0
        endif
        
        if kPauseCnt > kPauseCntMax then
            kMuteFlag = 0
            kPauseCnt = 0
        endif
        //S_filename = S_path + "\\soundin.1"
        //gS_filename strcatk S_path, "soundin.1"
        
        
        //==    SampleBank0 ==
        kSampleIndx = floor(random:k(giSampleBank[kSampleBank0][0], giSampleBank[kSampleBank0][1] + .5))
        //kSampleIndx = floor(random:k(0, 6.5))
        //kSampleIndx = floor(random:k(7, 13.5))
        //printk 0, kSampleIndx
        //kSampleIndx = 13
        
        /*
        kSendMain1 = 0
        kSendFft1 = 1
        kFftChn1 = 0
        */
        kTranspose = 1
        //kAmp = random:k(0.1, 0.8)
        kFrq = random:k(110, 1100)
        
        kTranspose = random:k(.8, 2)
        //event "i", "play_sample", 0,  kDur*.8, kSampleIndx, 0.5, 1, 0, kTranspose
        
        //2DO: fft sample + synth
        
        if kMuteFlag==0 then
            if kInstrIndx==0 || kInstrIndx==1 then
                event "i", gS_instr_name[kInstrIndx], 0, kNoteLen, kAmp, kFrq, kSendMain1, kSendFft1, kFftChn1, kRevLev
            elseif kInstrIndx==2 || kInstrIndx==3 then
                event "i", gS_instr_name[kInstrIndx], 0,  kNoteLen, kSampleIndx, kSendMain1, kSendFft1, kFftChn1, kTranspose, kRevLevSample
            else
                event "i", gS_instr_name[kInstrIndx], 0, kNoteLen, kAmp, kFrq, kSendMain1, kSendFft1, kFftChn1, kRevLev
            endif
            //kNoteCnt += 1
        else
            //kPauseCnt += 1
        endif
        
        
        //==    SampleBank1 ==
        kSampleIndx = floor(random:k(giSampleBank[kSampleBank1][0], giSampleBank[kSampleBank1][1] + .5))
        //kSampleIndx = floor(random:k(0, 6.5))
        //kSampleIndx = floor(random:k(7, 13.5))
        
        /*
        kSendMain2 = 0
        kSendFft2 = 1
        kFftChn2 = 1
        */
        
        kTranspose = 1
        //event "i", "play_sample", 0,  kDur*.8, kSampleIndx, 0, 1, 1, 1
        
        if kMuteFlag==0 then
            if kInstrIndx==0 || kInstrIndx==1 then
                event "i", gS_instr_name[kInstrIndx], 0, kNoteLen, kAmp, kFrq, kSendMain2, kSendFft2, kFftChn2, kRevLev
            elseif kInstrIndx==2 || kInstrIndx==3 then
                event "i", gS_instr_name[kInstrIndx], 0,  kNoteLen, kSampleIndx, kSendMain2, kSendFft2, kFftChn2, kTranspose, kRevLevSample
            else
                event "i", gS_instr_name[kInstrIndx], 0, kNoteLen, kAmp, kFrq, kSendMain2, kSendFft2, kFftChn2, kRevLev
            endif
            kNoteCnt += 1
        else
            kPauseCnt += 1
        endif
        
        
        /*
        2DO:
            strict -- free rythm
        */
        
        //continues -- discrete
        //if floor(random:k(0, 1.5))==0 then
        if kForm < .6 then
            kDur = random:k(kDurVarMin, kDurVarMax) 
        else
            iSeedType = 0
            kTypeOfDistribDiscr = 1 //uniform
            kMinDiscr = 0
            kMaxDiscr = 1
            kDistribDepthDiscr = 1
            kLineDiscr[] = giRythmArr1Weight
            kDurInxDiscr = get_discr_distr_k(iSeedType, kTypeOfDistribDiscr, kMinDiscr, kMaxDiscr, kDistribDepthDiscr, kLineDiscr)
            kDur = kDurMinDiscr*giRythmArr1[kDurInxDiscr]
            printks "DISCRETE :: kDurInxDiscr = %d, kDur = %f", .1, kDurInxDiscr, kDurMinDiscr*giRythmArr1[kDurInxDiscr]
        endif
       
        kNoteLen = kDur * kPortam
        //printk(.1, kDur)
        
        //===================   DEBUG       ======================
        //kDur = 1
        //kNoteLen = .8
    endif
endin



instr score
    kStartDelta init 120.
    kStartDeltaMin init 60*.5
    kStartDeltaMax init 60*10
    kPartDancity init .99
    
    kSampleBank0 init 0
    kSampleBank1 init 1
    
    kForm = rspline:k(0.1, 1., 1/(2), 1/(5))
    kForm = (kForm>1?1:kForm)
    kForm = (kForm<.1?.1:kForm)
    
    kStartDelta = kStartDeltaMax * expcurve((1.11 - kForm), 10) + kStartDeltaMin
    kStartDelta /= 4
    //kForm .1 kPartDancity = 0.95 | kForm .9 kPartDancity = 2.
    kPartDancity = 1.2 * expcurve(kForm, 10) + .9
    kPartLen = kPartDancity * kStartDelta
    
    kTrig metro 1/kStartDelta
    
    if kTrig == 1 then
        printks "===============================\nkForm = %f, kStartDelta = %f, kPartLen = %f\n===============================\n", 2, kForm, kStartDelta, kPartLen
    
        kPortamInit = .8
        kTempo = .2
        kInstrIndex = floor(random:k(0, lenarray(gS_instr_name)-.5))
        
        //===================   DEBUG       ======================
        //kInstrIndex = 7
        
        /*
        == FFt mode type == ++
        (kModType)

            0   pvsfilter drone
            1   pvscross light
            2   pvscross harshy
            3   pvsvoc no scale
            4   pvsvoc scale    
        */

        kFftModType = floor(random:k(0, 4.5))
        
        if kInstrIndex==0 || kInstrIndex==1 then
            kSendMain1 = 1
            kSendFft1 = 0
            kFftChn1 = 0
        
            kSendMain2 = 0
            kSendFft2 = 0
            kFftChn2 = 0
        elseif kInstrIndex==2 then
            kSendMain1 = 0
            kSendFft1 = 1
            kFftChn1 = 0
        
            kSendMain2 = 0
            kSendFft2 = 1
            kFftChn2 = 1
        elseif kInstrIndex==3 then
            kSendMain1 = 1
            kSendFft1 = 0
            kFftChn1 = 0
        
            kSendMain2 = 0
            kSendFft2 = 0
            kFftChn2 = 1
        endif
        
        
        kSampleBankSel = floor(random:k(0, 1.5))
        
        if kSampleBankSel==0 then
            kSampleBank0 = 0
            kSampleBank1 = 1
        else
            kSampleBank0 = 1
            kSampleBank1 = 0
        endif
        
        event "i", "part_sample", 0, kPartLen, kPortamInit, kTempo, kInstrIndex, \
            kSendMain1, \ 
            kSendFft1, \
            kFftChn1, \
            kSendMain2, \ 
            kSendFft2, \
            kFftChn2, \
            kForm, \
            kFftModType, \
            kSampleBank0, \
            kSampleBank1
    endif
endin

</CsInstruments>
<CsScore>
/*
i "SubstrPoly" 0 2 .2 440
i "SubstrPoly" 2 . .2 220
i "SubstrPoly" 5 . .2 440
i "SubstrPoly" 6 . .2 220
*/
//i "additive_my" 0 20
//i "part" 0 120 "additive_my"
//i "convolve_my" 0 10
//i "fft_my" 0 20
//i "part" 0 120 "SubstrPoly"

//                              kPortamInit     Tempo       kInstrIndex
//i "part_sample"     0   480     .8              .2          2
i "score" 0 -1
i "fft_global" 0 -1
i "rever" 0 -1
i "limiter" 0 -1
//i "dump_file" 0 -1
i "master_out" 0 -1
f0 z
</CsScore>
</CsoundSynthesizer>