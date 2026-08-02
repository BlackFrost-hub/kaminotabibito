local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_0.getServerTime
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.17．周期机制调度器")
local _____521B_5EFA_81EA_9002_5E94_5171_4EAB_5468_671F_9A71_52A8 = ____require_result_1["创建自适应共享周期驱动"]
local _____5355_76EE_6807_5468_671F_6548_679C_5217_8868 = {}
local _____5355_76EE_6807_5468_671F_6548_679C_9A71_52A8
local function ____on_5355_76EE_6807_5468_671F_6548_679CTick(now)
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
local function _____53D6_5355_76EE_6807_5468_671F_6548_679C_5EFA_8BAE_68C0_67E5_95F4_9694(_nowMs)
    local _____6700_77ED_95F4_9694 = 0
    do
        local i = 0
        while i < #_____5355_76EE_6807_5468_671F_6548_679C_5217_8868 do
            local _____95F4_9694 = _____5355_76EE_6807_5468_671F_6548_679C_5217_8868[i + 1]["间隔毫秒"]
            if _____95F4_9694 > 0 and (_____6700_77ED_95F4_9694 == 0 or _____95F4_9694 < _____6700_77ED_95F4_9694) then
                _____6700_77ED_95F4_9694 = _____95F4_9694
            end
            i = i + 1
        end
    end
    return _____6700_77ED_95F4_9694
end
local function _____786E_4FDD_5355_76EE_6807_5468_671F_6548_679C_9A71_52A8()
    if _____5355_76EE_6807_5468_671F_6548_679C_9A71_52A8 == nil then
        _____5355_76EE_6807_5468_671F_6548_679C_9A71_52A8 = _____521B_5EFA_81EA_9002_5E94_5171_4EAB_5468_671F_9A71_52A8({["名称"] = "单目标周期效果驱动", ["最大检查间隔毫秒"] = 50, ["取建议检查间隔毫秒"] = _____53D6_5355_76EE_6807_5468_671F_6548_679C_5EFA_8BAE_68C0_67E5_95F4_9694, onTick = ____on_5355_76EE_6807_5468_671F_6548_679CTick})
    end
    _____5355_76EE_6807_5468_671F_6548_679C_9A71_52A8["刷新"](_____5355_76EE_6807_5468_671F_6548_679C_9A71_52A8)
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
