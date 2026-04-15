//对应LOCALSET
#ifndef STAR_YD_H
#define STAR_YD_H
    globals 
        integer StarLuaKey = 0
        integer StarBlockKey = 0

        integer G_LIndex = 0
        integer G_SIndex = 0
        integer G_LastSIndex = 0
        integer G_LastLIndex = 0


        integer G_SIndex3=0
        integer G_SIndex4=0
    endglobals
    function StarYDGetIndex takes trigger trg returns integer
        local integer hd = GetHandleId(trg)
        return hd*LoadInteger(YDLOC, hd, 0xCFDE6C76)  + 3
    endfunction
    function YDGetStep2 takes string str,integer step returns integer
        call BJDebugMsg("Error at function YDGetStep2")
        return 0
    endfunction 
    function YDGetStep takes trigger trg,integer step returns integer
        call BJDebugMsg("Error at function YDGetStep")
        return 0
    endfunction 
    #define StarDelLoc(t,s) RemoveSavedHandle(YDLOC,GetHandleId(##t),<?=StringHash(##s)?>)
    
    #define DELLOC1(s)  RemoveSavedHandle(YDLOC,GetHandleId(GetTriggeringTrigger())*ydl_localvar_step,<?=StringHash(##s)?>)
    
    #define StarIndex1 GetHandleId(GetTriggeringTrigger()) * ydl_localvar_step

    #define StarIndex2 GetHandleId(GetExpiredTimer())

    #define StarIndex3 GetHandleId(GetTriggeringTrigger())
    
    #define StarIndex4 YDHashH2I(GetTriggeringTrigger())*YDHashGet(YDLOC, integer, YDHashH2I(GetTriggeringTrigger()), 0xECE825E7)
    
    //获取事件名的code(字符串哈希)
    #define SUTL_GetHashCode(s) <?= StringHash(#s)?>

   
    


#endif

 

