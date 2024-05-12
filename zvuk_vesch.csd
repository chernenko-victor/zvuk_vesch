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

/*
instr convolve_my
    S_sample_file_name = "C:\\home\\chernenko\\audio\\cons\\env\\reaper_stems_bbc.wav"
    //S_file_name = "D:\\src\\csound\\edu\\sa\\csound_edu\\lsn10\\cl_solo_am.wav"
    S_impls_file_name = "D:\\src\\csound\\edu\\sa\\csound_edu\\lsn9\\dish.wav" 
    aIn[] diskin S_sample_file_name
    //iLenArr = lenarray(aIn)
    //print(iLenArr)
    //aConv[] pconvolve aIn[0], "D:\\src\\csound\\edu\\sa\\csound_edu\\lsn9\\dish.wav"
    ipartitionsize  =     256
    aconv[]           pconvolve aIn[0], "D:\\src\\csound\\edu\\sa\\csound_edu\\lsn9\\dish.wav", ipartitionsize
    //spatial_my(aConv[0])
endin
*/

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


instr part_str
    /*
    kDur init .5
    kFileA init 1
    kFileB init 1
    kCnt init 0
    kFlag init 1
    iNumberOfFiles init 0
    
    if kFlag==1 then
        S_path = "D:\\src\\csound\\dev2\\csound\\dev_stohastic"
        SFilenames[] init 30
        SFilenames[0] = "lkjljljlkjl"
        SFilenames[1] = "kjlk99999888888"
        SFilenames[1] = "k--ggg88"
        kNumberOfFiles lenarray SFilenames
        //print kNumberOfFiles
        kFlag = 0
    endif
    
    kTrig metro 1/kDur
    
    
    if kTrig==1 then
        printf "Filename = %s \n", kTrig, SFilenames[kCnt]
        kCnt += 1
    endif
    
    
    
    if kTrig==1 && kCnt<iNumberOfFiles then
        //printks "test kCnt = %d\n", .1, kCnt
        S_file_name strcatk SFilenames[1], " == \n"
        printks S_file_name, .1
        kCnt += 1
    endif
    */
    
    /*
    S_instr_name = {{ play_sample }}
    S_path = "D:\\src\\csound\\dev2\\csound\\dev_stohastic"
    iCnt init 0
    SFilenames[] directory S_path
    iNumberOfFiles lenarray SFilenames

    S_scoreline strcatk "i ", S_instr_name
    S_scoreline strcatk S_scoreline, " 0 3 "
    S_scoreline strcatk S_scoreline, " 0 3 "
    scoreline_i  S_scoreline

    until iCnt>=iNumberOfFiles do
        printf_i "Filename = %s \n", 1, SFilenames[iCnt]
        
        S_scoreline strcatk "i ", S_instr_name
        scoreline_i  S_scoreline
        iCnt = iCnt+1
    od
    */
endin


instr play_sample
    asig[] diskin p4, 1, 0, 1 
    outs asig[0]*.8, asig[0]*.8
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

i "part_str" 0 10
i "limiter" 0 20
//i "dump_file" 0 20
i "master_out" 0 120
</CsScore>
</CsoundSynthesizer>