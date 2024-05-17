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

giDurArr[] fillarray 1, 2, 3, 4, 6, 8, 12, 16, 24, 32
giDurMin init .25

chn_a "fftA", 2
chn_a "fftB", 2
chn_k "FftModType", 2


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
endop

instr additive_my
    seed 0
    iAmp = p4
    iFrq = p5
    
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
    
    spatial_my(aMono)
endin

instr SubstrPoly
    seed 0
    
    a0 pinker
    a0 *= ampdb(-12)
    //iFrqBase = random:i(220., 880.)
    iAmp = p4
    iFrqBase = p5
    
    kFreqs[] fillarray 400, 1400, 3000, 4400, 8000, 12000
    kQs[] fillarray    10,    20,   10,   20,   10,    20
    kV = ampdb(18)
    
    aMono polyseq lenarray(kFreqs), "rbjeq", a0, (kFreqs/400)*iFrqBase, kV, kQs, 1, 8
    aMono *= linsegr:a(0, 0.05, iAmp, 0.05, 0)
    
    //outs aMono, aMono
    spatial_my(aMono)
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


/*
== Temporythm == ++

tempo +
porto +
pauses +

===============================================================================
                    tempo          porto               pauses
===============================================================================             
1   short slow      low            low                 frequently--middle, long
2   long  slow      low            long                middle--rare, short
3   short fast      high           low                 rare, short
===============================================================================
*/

/*
== Transpose == 

narrow
wide
*/

/*
== Samples == 

dry low
dry normal

dry + fft(low, normal)
dry + fft(normal, low)

fft(low, normal)
fft(normal, low)
*/

/*
== FFt mode type ==
(kModType)

    0   pvsfilter drone
    1   pvscross light
    2   pvscross harshy
    3   pvsvoc no scale
    4   pvsvoc scale    
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


/*
== Spatial ==
concentred
wider
widest
*/

instr part_sample
    kPortam init p4
    kTempo init p5
    kFlag init 1
    kFftModType init 0
    kNoteCnt init 0
    kPauseCnt init 0
    kMuteFlag init 0
    kNoteCntMax init 8
    kPauseCntMax init 4
    chnset kFftModType, "FftModType"
    
    if kFlag==1 then
        kDur = giMaxDur*expcurve(kTempo, giMaxDur)
        kDurVarMax = 1.5 * kDur
        kDurVarMix = .5 * kDur
        if kDur<giMinDur then
            kDur=giMinDur
            kDurVarMin = kDur
        endif
        kNoteLen = kDur * kPortam
        S_path = "C:\\home\\chernenko\\src\\csound\\dev2\\csound\\dev_stohastic\\"
        printk(.2, kDur)
        kFlag = 0
    endif
    
    kTrig metro 1/kDur
    
    if kTrig==1 then
    
        printks "kMuteFlag = %f, kNoteCnt = %f, kPauseCnt = %f\n", .1, kMuteFlag, kNoteCnt, kPauseCnt
    
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
        
        kSampleIndx = floor(random:k(0, 6.5))
        //kSampleIndx = floor(random:k(7, 13.5))
        //printk 0, kSampleIndx
        //kSampleIndx = 13
        kSendMain = 0
        kSendFft = 1
        kFftChn = 0
        kTranspose = 1
        
        kTranspose = random:k(.8, 2)
        //event "i", "play_sample", 0,  kDur*.8, kSampleIndx, 0.5, 1, 0, kTranspose
        
        if kMuteFlag==0 then
            event "i", "play_sample", 0,  kNoteLen, kSampleIndx, kSendMain, kSendFft, kFftChn, kTranspose
            //kNoteCnt += 1
        else
            //kPauseCnt += 1
        endif
        
        //kSampleIndx = floor(random:k(0, 6.5))
        kSampleIndx = floor(random:k(7, 13.5))
        kSendMain = 0
        kSendFft = 1
        kFftChn = 1
        kTranspose = 1
        //event "i", "play_sample", 0,  kDur*.8, kSampleIndx, 0, 1, 1, 1
        
        if kMuteFlag==0 then
            event "i", "play_sample", 0,  kNoteLen, kSampleIndx, kSendMain, kSendFft, kFftChn, kTranspose
            kNoteCnt += 1
        else
            kPauseCnt += 1
        endif
        
        kDur = random:k(kDurVarMin, kDurVarMax)
        kNoteLen = kDur * kPortam
        //printk(.1, kDur)
    endif
endin


instr play_sample
    iSampleIndx = p4
    iSendMain = p5
    iSendFft = p6
    iFftChn = p7
    iTranspose = p8
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


//                              kPortamInit     Tempo
i "part_sample"     0   480     .8              .2
i "fft_global" 0 480
i "limiter" 0 480
//i "dump_file" 0 20
i "master_out" 0 480
</CsScore>
</CsoundSynthesizer>