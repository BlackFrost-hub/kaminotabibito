local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local getServerTime = ____require_result_0.getServerTime
local _____5355_76EE_6807_5468_671F_6548_679C_5217_8868 = {}
local _____5DF2_6CE8_518C_5355_76EE_6807_5468_671F_6548_679C_9A71_52A8 = false
local function ____on_5355_76EE_6807_5468_671F_6548_679CTick()
    local now = getServerTime()
    do
        local i = #_____5355_76EE_6807_5468_671F_6548_679C_5217_8868 - 1
        while i >= 0 do
            do
                local record = _____5355_76EE_6807_5468_671F_6548_679C_5217_8868[i + 1]
                if record == nil or now >= record["结束时间"] then
                    __TS__ArraySplice(_____5355_76EE_6807_5468_671F_6548_679C_5217_8868, i, 1)
                    goto __continue4
                end
                if now < record["下次时间"] then
                    goto __continue4
                end
                record["下次时间"] = now + record["间隔毫秒"]
                record["on周期"]({["来源"] = record["来源"], ["目标"] = record["目标"], ["数值"] = record["数值"], ["额外"] = record["额外"]})
            end
            ::__continue4::
            i = i - 1
        end
    end
end
local function _____786E_4FDD_5355_76EE_6807_5468_671F_6548_679C_9A71_52A8()
    if _____5DF2_6CE8_518C_5355_76EE_6807_5468_671F_6548_679C_9A71_52A8 then
        return
    end
    _____5DF2_6CE8_518C_5355_76EE_6807_5468_671F_6548_679C_9A71_52A8 = true
    addPeriodicCallback(50, ____on_5355_76EE_6807_5468_671F_6548_679CTick)
end
____exports["添加单目标周期效果"] = function(_____53C2_6570)
    if not (_____53C2_6570["持续毫秒"] > 0) or not (_____53C2_6570["间隔毫秒"] > 0) then
        return
    end
    local now = getServerTime()
    _____5355_76EE_6807_5468_671F_6548_679C_5217_8868[#_____5355_76EE_6807_5468_671F_6548_679C_5217_8868 + 1] = __TS__ObjectAssign({}, _____53C2_6570, {["结束时间"] = now + _____53C2_6570["持续毫秒"], ["下次时间"] = now + (_____53C2_6570["首跳延迟毫秒"] or _____53C2_6570["间隔毫秒"])})
    _____786E_4FDD_5355_76EE_6807_5468_671F_6548_679C_9A71_52A8()
end
return ____exports
