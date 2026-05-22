local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____00_FF0E_914D_7F6E_8868 = require("系统.01．单位系统.05．单位狂暴.01．死亡触发Boss.00．配置表")
local _____6B7B_4EA1_89E6_53D1Boss_914D_7F6E_8868 = ____00_FF0E_914D_7F6E_8868["死亡触发Boss配置表"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_0.registerDeathListener
local ____require_result_1 = require("系统.09．表现系统.06．广播提示消息.index")
local _____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_1["广播单位提示"]
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_2.addDelayedCallback
local getServerTime = ____require_result_2.getServerTime
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换")
local stringToFourCC = ____require_result_3.stringToFourCC
local ____require_result_4 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_4.YDUserDataGetSafe
local ____require_result_5 = require("系统.01．单位系统.08．单位配置表.00．杂鱼配置表")
local _____6309_540D_5B57_53CD_67E5_6742_9C7C_5355_4F4DID = ____require_result_5["按名字反查杂鱼单位ID"]
local ____require_result_6 = require("系统.01．单位系统.08．单位配置表.01．精英配置表")
local _____6309_540D_5B57_53CD_67E5_7CBE_82F1_5355_4F4DID = ____require_result_6["按名字反查精英单位ID"]
local ____require_result_7 = require("系统.01．单位系统.08．单位配置表.02．Boss配置表")
local _____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID = ____require_result_7["按名字反查Boss单位ID"]
local ____require_result_8 = require("系统.01．单位系统.08．单位配置表.03．异界Boss配置表")
local _____6309_540D_5B57_53CD_67E5_5F02_754CBoss_5355_4F4DID = ____require_result_8["按名字反查异界Boss单位ID"]
local AddSpecialEffect = jass.AddSpecialEffect
local CreateUnit = jass.CreateUnit
local DestroyEffect = jass.DestroyEffect
local GetHeroLevel = jass.GetHeroLevel
local GetOwningPlayer = jass.GetOwningPlayer
local GetRandomInt = jass.GetRandomInt
local GetUnitFacing = jass.GetUnitFacing
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GroupAddUnit = jass.GroupAddUnit
local IsUnitType = jass.IsUnitType
local _____5DF2_89E3_6790_914D_7F6E_8868 = {}
local _____6B7B_4EA1_7D2F_8BA1_8868 = {}
local _____5DF2_89E6_53D1_914D_7F6E_8868 = {}
local ____Boss_5EF6_8FDF_8BF4_8BDD_961F_5217 = {}
local function _____6309_540D_5B57_53CD_67E5_4EFB_610F_5355_4F4DID(name)
    return _____6309_540D_5B57_53CD_67E5_6742_9C7C_5355_4F4DID(name) or _____6309_540D_5B57_53CD_67E5_7CBE_82F1_5355_4F4DID(name) or _____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID(name) or _____6309_540D_5B57_53CD_67E5_5F02_754CBoss_5355_4F4DID(name)
end
local function _____521D_59CB_5316_914D_7F6E_7F13_5B58()
    if #_____5DF2_89E3_6790_914D_7F6E_8868 > 0 then
        return
    end
    do
        local i = 0
        while i < #_____6B7B_4EA1_89E6_53D1Boss_914D_7F6E_8868 do
            do
                local _____914D_7F6E = _____6B7B_4EA1_89E6_53D1Boss_914D_7F6E_8868[i + 1]
                local _____89E6_53D1_5355_4F4DID = _____6309_540D_5B57_53CD_67E5_4EFB_610F_5355_4F4DID(_____914D_7F6E["触发单位名"])
                local ____Boss_5355_4F4DID = _____6309_540D_5B57_53CD_67E5_4EFB_610F_5355_4F4DID(_____914D_7F6E["Boss单位名"])
                if _____89E6_53D1_5355_4F4DID == nil or ____Boss_5355_4F4DID == nil then
                    goto __continue6
                end
                _____5DF2_89E3_6790_914D_7F6E_8868[#_____5DF2_89E3_6790_914D_7F6E_8868 + 1] = __TS__ObjectAssign(
                    {},
                    _____914D_7F6E,
                    {
                        ["触发单位类型ID"] = stringToFourCC(_____89E6_53D1_5355_4F4DID),
                        ["Boss单位类型ID"] = stringToFourCC(____Boss_5355_4F4DID)
                    }
                )
            end
            ::__continue6::
            i = i + 1
        end
    end
end
local function _____53D6_51FA_73B0_5750_6807(_____914D_7F6E, dyingUnit, killingUnit)
    if _____914D_7F6E["出现位置类型"] == "固定坐标" then
        return {_____914D_7F6E["固定X"] or 0, _____914D_7F6E["固定Y"] or 0}
    end
    if _____914D_7F6E["出现位置类型"] == "死亡单位当前位置" or killingUnit == nil or killingUnit == 0 then
        return {
            GetUnitX(dyingUnit),
            GetUnitY(dyingUnit)
        }
    end
    return {
        GetUnitX(killingUnit),
        GetUnitY(killingUnit)
    }
end
local function _____53D6_51FA_73B0_671D_5411(_____914D_7F6E, dyingUnit, killingUnit)
    if _____914D_7F6E["固定朝向"] ~= nil then
        return _____914D_7F6E["固定朝向"]
    end
    if killingUnit ~= nil and killingUnit ~= 0 then
        return GetUnitFacing(killingUnit)
    end
    return GetUnitFacing(dyingUnit)
end
local function _____52A0_5165_8840_6761Boss_7EC4(unit)
    local bossGroup = YDUserDataGetSafe("string", "血条Boss", "单位组", "group")
    if bossGroup == nil or bossGroup == 0 then
        return
    end
    GroupAddUnit(bossGroup, unit)
end
local function _____5904_7406Boss_5EF6_8FDF_8BF4_8BDD_961F_5217()
    local now = getServerTime()
    local writeIndex = 0
    do
        local i = 0
        while i < #____Boss_5EF6_8FDF_8BF4_8BDD_961F_5217 do
            do
                local _____8BB0_5F55 = ____Boss_5EF6_8FDF_8BF4_8BDD_961F_5217[i + 1]
                if now >= _____8BB0_5F55["到期时间"] then
                    _____5E7F_64AD_5355_4F4D_63D0_793A(_____8BB0_5F55["Boss单位"], _____8BB0_5F55["文本"], _____8BB0_5F55["持续时间Ms"])
                    goto __continue18
                end
                ____Boss_5EF6_8FDF_8BF4_8BDD_961F_5217[writeIndex + 1] = _____8BB0_5F55
                writeIndex = writeIndex + 1
            end
            ::__continue18::
            i = i + 1
        end
    end
    do
        local i = #____Boss_5EF6_8FDF_8BF4_8BDD_961F_5217 - 1
        while i >= writeIndex do
            table.remove(____Boss_5EF6_8FDF_8BF4_8BDD_961F_5217)
            i = i - 1
        end
    end
end
local function _____5B89_6392Boss_5EF6_8FDF_8BF4_8BDD(boss, _____914D_7F6E)
    local _____5EF6_8FDFMs = _____914D_7F6E["Boss说话延迟Ms"] or 0
    if _____5EF6_8FDFMs <= 0 then
        _____5E7F_64AD_5355_4F4D_63D0_793A(boss, _____914D_7F6E["Boss说话文本"], _____914D_7F6E["广播持续时间Ms"])
        return
    end
    ____Boss_5EF6_8FDF_8BF4_8BDD_961F_5217[#____Boss_5EF6_8FDF_8BF4_8BDD_961F_5217 + 1] = {
        ["到期时间"] = getServerTime() + _____5EF6_8FDFMs,
        ["Boss单位"] = boss,
        ["文本"] = _____914D_7F6E["Boss说话文本"],
        ["持续时间Ms"] = _____914D_7F6E["广播持续时间Ms"]
    }
    addDelayedCallback(_____5EF6_8FDFMs, _____5904_7406Boss_5EF6_8FDF_8BF4_8BDD_961F_5217)
end
local function _____5E7F_64ADBoss_51FA_73B0_6587_672C(boss, _____914D_7F6E)
    _____5E7F_64AD_5355_4F4D_63D0_793A(boss, _____914D_7F6E["出现提示文本"], _____914D_7F6E["广播持续时间Ms"])
    _____5B89_6392Boss_5EF6_8FDF_8BF4_8BDD(boss, _____914D_7F6E)
end
local function _____521B_5EFABoss_5E76_5E7F_64AD(_____914D_7F6E, dyingUnit, killingUnit)
    local _____51FA_73B0_5750_6807 = _____53D6_51FA_73B0_5750_6807(_____914D_7F6E, dyingUnit, killingUnit)
    local x = _____51FA_73B0_5750_6807[1]
    local y = _____51FA_73B0_5750_6807[2]
    local facing = _____53D6_51FA_73B0_671D_5411(_____914D_7F6E, dyingUnit, killingUnit)
    local owner = GetOwningPlayer(dyingUnit)
    local boss = CreateUnit(
        owner,
        _____914D_7F6E["Boss单位类型ID"],
        x,
        y,
        facing
    )
    if boss == nil or boss == 0 then
        return
    end
    if _____914D_7F6E["需要加入血条Boss组"] ~= false then
        _____52A0_5165_8840_6761Boss_7EC4(boss)
    end
    if _____914D_7F6E["出场特效模型"] ~= nil and _____914D_7F6E["出场特效模型"] ~= "" then
        local effect = AddSpecialEffect(_____914D_7F6E["出场特效模型"], x, y)
        if effect ~= nil and effect ~= 0 then
            DestroyEffect(effect)
        end
    end
    _____5E7F_64ADBoss_51FA_73B0_6587_672C(boss, _____914D_7F6E)
    if _____914D_7F6E["只触发一次"] ~= false then
        _____5DF2_89E6_53D1_914D_7F6E_8868[_____914D_7F6E["配置ID"]] = true
    end
end
local function _____6EE1_8DB3_6982_7387_89E6_53D1_6761_4EF6(_____914D_7F6E, killingUnit)
    if _____5DF2_89E6_53D1_914D_7F6E_8868[_____914D_7F6E["配置ID"]] == true and _____914D_7F6E["只触发一次"] ~= false then
        return false
    end
    if killingUnit == nil or killingUnit == 0 then
        return false
    end
    if not IsUnitType(killingUnit, jass.UNIT_TYPE_HERO) then
        return false
    end
    local heroLevel = GetHeroLevel(killingUnit)
    if _____914D_7F6E["击杀者最低英雄等级"] ~= nil and heroLevel < _____914D_7F6E["击杀者最低英雄等级"] then
        return false
    end
    if _____914D_7F6E["击杀者最高英雄等级"] ~= nil and heroLevel > _____914D_7F6E["击杀者最高英雄等级"] then
        return false
    end
    local chance = _____914D_7F6E["出现概率"] or 0
    if chance <= 0 then
        return false
    end
    return GetRandomInt(1, 100) <= chance
end
local function _____5904_7406_7D2F_8BA1_89E6_53D1(_____914D_7F6E, dyingUnit, killingUnit)
    if _____5DF2_89E6_53D1_914D_7F6E_8868[_____914D_7F6E["配置ID"]] == true and _____914D_7F6E["只触发一次"] ~= false then
        return
    end
    local nextCount = (_____6B7B_4EA1_7D2F_8BA1_8868[_____914D_7F6E["配置ID"]] or 0) + 1
    _____6B7B_4EA1_7D2F_8BA1_8868[_____914D_7F6E["配置ID"]] = nextCount
    if nextCount < (_____914D_7F6E["累计数量"] or 0) then
        return
    end
    _____6B7B_4EA1_7D2F_8BA1_8868[_____914D_7F6E["配置ID"]] = 0
    _____521B_5EFABoss_5E76_5E7F_64AD(_____914D_7F6E, dyingUnit, killingUnit)
end
local function _____5904_7406_6982_7387_89E6_53D1(_____914D_7F6E, dyingUnit, killingUnit)
    if not _____6EE1_8DB3_6982_7387_89E6_53D1_6761_4EF6(_____914D_7F6E, killingUnit) then
        return
    end
    _____521B_5EFABoss_5E76_5E7F_64AD(_____914D_7F6E, dyingUnit, killingUnit)
end
local function onDeath(dyingUnit, killingUnit)
    if dyingUnit == nil or dyingUnit == 0 then
        return
    end
    _____521D_59CB_5316_914D_7F6E_7F13_5B58()
    local dyingTypeId = GetUnitTypeId(dyingUnit)
    do
        local i = 0
        while i < #_____5DF2_89E3_6790_914D_7F6E_8868 do
            do
                local _____914D_7F6E = _____5DF2_89E3_6790_914D_7F6E_8868[i + 1]
                if _____914D_7F6E["触发单位类型ID"] ~= dyingTypeId then
                    goto __continue46
                end
                if _____914D_7F6E["触发类型"] == "累计数量" then
                    _____5904_7406_7D2F_8BA1_89E6_53D1(_____914D_7F6E, dyingUnit, killingUnit)
                    goto __continue46
                end
                if _____914D_7F6E["触发类型"] == "概率" then
                    _____5904_7406_6982_7387_89E6_53D1(_____914D_7F6E, dyingUnit, killingUnit)
                end
            end
            ::__continue46::
            i = i + 1
        end
    end
end
registerDeathListener(onDeath)
return ____exports
