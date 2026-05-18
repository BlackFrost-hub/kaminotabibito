local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_0.YDWETimerDestroyEffectSafe
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.08．无敌帧")
local _____5F00_59CB_65E0_654C_5E27 = ____require_result_1["开始无敌帧"]
local ____require_result_2 = require("系统.02．物品系统.13．物品名反查")
local resolveItemIdByName = ____require_result_2.resolveItemIdByName
local ____require_result_3 = require("lib.扩展函数.物品相关函数.物品累伤次数函数")
local _____5355_4F4D_7269_54C1_7D2F_4F24_6B21_6570 = ____require_result_3["单位物品累伤次数"]
local _____83B7_53D6_5355_4F4D_6307_5B9A_88C5_5907 = ____require_result_3["获取单位指定装备"]
local ____require_result_4 = require("系统.02．物品系统.15．装备技能.02．累计伤害.01．累计伤害配置表")
local _____56DE_6C99_4E4B_4E66_7D2F_8BA1_914D_7F6E = ____require_result_4["回沙之书累计配置"]
local ____require_result_5 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_5.stringToFourCCSafe
local ____require_result_6 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local doHeal = ____require_result_6.doHeal
local GetHandleId = jass.GetHandleId
local CreateTimer = jass.CreateTimer
local GetExpiredTimer = jass.GetExpiredTimer
local DestroyTimer = jass.DestroyTimer
local TimerStart = jass.TimerStart
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local _____56DE_6C99CD_8868 = {}
local _____56DE_6C99CD_8BA1_65F6_5668_8868 = {}
local _____56DE_6C99_514D_75AB_5F00_542F_8BA1_65F6_5668_8868 = {}
local _____56DE_6C99_4E4B_4E66ID = stringToFourCCSafe(resolveItemIdByName(_____56DE_6C99_4E4B_4E66_7D2F_8BA1_914D_7F6E["物品名"]))
local function _____56DE_6C99CD_7ED3_675F()
    local timer = GetExpiredTimer()
    local timerId = GetHandleId(timer)
    local hid = _____56DE_6C99CD_8BA1_65F6_5668_8868[timerId]
    __TS__Delete(_____56DE_6C99CD_8BA1_65F6_5668_8868, timerId)
    DestroyTimer(timer)
    if hid ~= nil then
        __TS__Delete(_____56DE_6C99CD_8868, hid)
    end
end
local function _____56DE_6C99_514D_75AB_5F00_542F()
    local timer = GetExpiredTimer()
    local timerId = GetHandleId(timer)
    local hid = _____56DE_6C99_514D_75AB_5F00_542F_8BA1_65F6_5668_8868[timerId]
    __TS__Delete(_____56DE_6C99_514D_75AB_5F00_542F_8BA1_65F6_5668_8868, timerId)
    DestroyTimer(timer)
    if hid == nil then
        return
    end
    local unit = hid
    _____5F00_59CB_65E0_654C_5E27(unit, 1.25)
end
____exports["处理回沙之书累计"] = function(target, _attacker, applied)
    if target == nil or target == 0 or not (applied > 0) then
        return
    end
    local item = _____83B7_53D6_5355_4F4D_6307_5B9A_88C5_5907(target, _____56DE_6C99_4E4B_4E66ID)
    if item == nil then
        return
    end
    local _____8FBE_5230_9608_503C = _____5355_4F4D_7269_54C1_7D2F_4F24_6B21_6570(
        target,
        _____56DE_6C99_4E4B_4E66_7D2F_8BA1_914D_7F6E["物品名"],
        applied,
        1,
        _____56DE_6C99_4E4B_4E66_7D2F_8BA1_914D_7F6E["累计阈值"],
        {
            ["是否在CD中"] = _____56DE_6C99CD_8868[GetHandleId(target)] == true,
            ["达到阈值后重置"] = true
        }
    )
    local gain = applied * _____56DE_6C99_4E4B_4E66_7D2F_8BA1_914D_7F6E["法力恢复倍率"]
    if gain > 0 then
        doHeal({
            HealSource = target,
            HealTarget = target,
            HealAmount = 0,
            HealManaAmount = gain,
            ItemHeal = true,
            HealEffect = false,
            ManaEffect = true,
            ManaShowText = true
        })
    end
    if _____8FBE_5230_9608_503C then
        local hid = GetHandleId(target)
        if _____56DE_6C99CD_8868[hid] then
            return
        end
        local eff = AddSpecialEffectTarget(_____56DE_6C99_4E4B_4E66_7D2F_8BA1_914D_7F6E["特效路径"], target, "overhead")
        if eff ~= nil then
            YDWETimerDestroyEffectSafe(_____56DE_6C99_4E4B_4E66_7D2F_8BA1_914D_7F6E["特效持续时间"], eff)
        end
        if not _____56DE_6C99CD_8868[hid] then
            _____56DE_6C99CD_8868[hid] = true
            local timer = CreateTimer()
            local timerId = GetHandleId(timer)
            _____56DE_6C99CD_8BA1_65F6_5668_8868[timerId] = hid
            TimerStart(timer, _____56DE_6C99_4E4B_4E66_7D2F_8BA1_914D_7F6E["冷却时间"], false, _____56DE_6C99CD_7ED3_675F)
        end
        local immuneTimer = CreateTimer()
        local immuneTimerId = GetHandleId(immuneTimer)
        _____56DE_6C99_514D_75AB_5F00_542F_8BA1_65F6_5668_8868[immuneTimerId] = target
        TimerStart(immuneTimer, 0.5, false, _____56DE_6C99_514D_75AB_5F00_542F)
    end
end
return ____exports
