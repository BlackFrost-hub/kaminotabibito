
local jass = require 'jass.common'

jass.DisplayTextToPlayer(jass.Player(0),0,0,"init")

local hook = require 'jass.hook' 
local g = require 'jass.globals'

function hook.TimerStart(t,n,boo,scriptcode)
    print("start");
    jass.TimerStart(t,n,boo,scriptcode);
    jass.SaveTimerHandle(g.SDR_HT,g.SDR_Index,0,t);
    jass.SaveInteger(g.SDR_HT,jass.GetHandleId(t),0,g.SDR_Index);
    jass.SaveReal(g.SDR_HT,jass.GetHandleId(t),1,time);
    jass.SaveBoolean(g.SDR_HT,jass.GetHandleId(t),2,isloop);
    jass.SaveStr(g.SDR_HT,jass.GetHandleId(t),3,Target);
    g.SDR_Index = g.SDR_Index + 1;
end

-- function hook.DestroyTimer(t)
--     print("des")
--     local id;
--     local tr;
--     jass.DestroyTimer(t)
--     if( jass.HaveSavedInteger(g.SDR_HT,jass.GetHandleId(t),0) )
--     {
--         id = jass.LoadInteger(g.SDR_HT,jass.GetHandleId(t),0);
--         if(id!=(g.SDR_Index-1))
--         {
--             tr = jass.LoadTimerHandle(g.SDR_HT,g.SDR_Index,0);
--             --//交换数据
--             jass.SaveTimerHandle(g.SDR_HT,id,0,tr);
--             jass.SaveInteger(g.SDR_HT,jass.GetHandleId(tr),0,id);
--             --//清除旧计时器引用
--             jass.FlushChildHashtable(g.SDR_HT,jass.GetHandleId(t));
--         }
--         g.SDR_Index=g.SDR_Index-1;
--     }
--     tr = null;
-- end