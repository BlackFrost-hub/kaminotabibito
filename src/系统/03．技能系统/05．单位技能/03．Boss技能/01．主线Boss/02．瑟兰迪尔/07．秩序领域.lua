local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8DDD_79BB_5E73_65B9 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位间距离平方"]
local _____53D6_5355_4F4DID = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["取单位ID"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.02．数值与表现配置")
local _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["瑟兰迪尔数值与表现配置"]
local ____require_result_0 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_0.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_0["移除单位指定Buff"]
local ____require_result_1 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_1["获取Boss技能敌对英雄列表"]
local ____require_result_2 = require("lib.扩展函数.Star扩展函数.00．SGSS")
local SGSS_SetState = ____require_result_2.SGSS_SetState
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_5355_4F4D_5750_6807_8DDF_968F_7279_6548 = ____require_result_3["创建单位坐标跟随特效"]
local _____83B7_53D6_5355_4F4D_5750_6807_8DDF_968F_7279_6548 = ____require_result_3["获取单位坐标跟随特效"]
local _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548 = ____require_result_3["销毁单位坐标跟随特效"]
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitName = jass.GetUnitName
local GetHandleId = jass.GetHandleId
local _____9886_57DF_7279_6548_952E = "thranduil-order-aura"
local _____653B_901F_5C5E_6027ID = 10
local _____79E9_5E8F_9886_57DF_5F71_54CD_5C42_6570_8868 = {}
local _____79E9_5E8F_9886_57DF_5F71_54CD_5355_4F4D_8868 = {}
local _____79E9_5E8F_9886_57DF_6765_6E90_540D_79F0_8868 = {}
local _____79E9_5E8F_9886_57DF_7279_6548_7F29_653E_8868 = {}
local function _____786E_4FDDBoss_81EA_8EAB_9886_57DF_8868_73B0(boss)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["秩序领域"]
    local bossId = _____53D6_5355_4F4DID(boss)
    local effect = _____83B7_53D6_5355_4F4D_5750_6807_8DDF_968F_7279_6548(boss, _____9886_57DF_7279_6548_952E)
    if effect ~= nil and effect ~= 0 and _____79E9_5E8F_9886_57DF_7279_6548_7F29_653E_8868[bossId] ~= config["特效缩放"] then
        _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548(boss, _____9886_57DF_7279_6548_952E)
        effect = nil
    end
    if effect == nil or effect == 0 then
        effect = _____521B_5EFA_5355_4F4D_5750_6807_8DDF_968F_7279_6548(
            boss,
            config["特效"],
            _____9886_57DF_7279_6548_952E,
            config["特效缩放"],
            50
        )
    end
    if effect ~= nil and effect ~= 0 then
        _____79E9_5E8F_9886_57DF_7279_6548_7F29_653E_8868[bossId] = config["特效缩放"]
    end
end
local function _____8C03_6574_79E9_5E8F_9886_57DF_5F71_54CD_5C42_6570(unit, delta)
    if delta == 0 or unit == nil or unit == 0 then
        return
    end
    SGSS_SetState(unit, _____653B_901F_5C5E_6027ID, -_____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["秩序领域"]["攻击速度降低"] * delta)
end
local function _____540C_6B65_79E9_5E8F_9886_57DF_5F71_54CD(next)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["秩序领域"]
    for id in pairs(_____79E9_5E8F_9886_57DF_5F71_54CD_5C42_6570_8868) do
        if next[id] == nil then
            next[id] = 0
        end
    end
    for id in pairs(next) do
        local oldCount = _____79E9_5E8F_9886_57DF_5F71_54CD_5C42_6570_8868[id] or 0
        local newCount = next[id] or 0
        local unit = _____79E9_5E8F_9886_57DF_5F71_54CD_5355_4F4D_8868[id]
        if oldCount ~= newCount then
            _____8C03_6574_79E9_5E8F_9886_57DF_5F71_54CD_5C42_6570(unit, newCount - oldCount)
        end
        if newCount > 0 then
            _____79E9_5E8F_9886_57DF_5F71_54CD_5C42_6570_8868[id] = newCount
            registerManualBuff(
                unit,
                config.BuffID,
                config["Tick秒"] + 0.3,
                config["攻击速度降低"] * 100,
                {sourceName = _____79E9_5E8F_9886_57DF_6765_6E90_540D_79F0_8868[id], iconOverride = "BuffIcon\\Boss\\Thranduil\\zhixulingyu.blp"}
            )
        else
            _____79FB_9664_5355_4F4D_6307_5B9ABuff(unit, config.BuffID)
            __TS__Delete(_____79E9_5E8F_9886_57DF_5F71_54CD_5C42_6570_8868, id)
            __TS__Delete(_____79E9_5E8F_9886_57DF_5F71_54CD_5355_4F4D_8868, id)
            __TS__Delete(_____79E9_5E8F_9886_57DF_6765_6E90_540D_79F0_8868, id)
        end
    end
end
____exports["刷新瑟兰迪尔秩序领域"] = function(context)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["秩序领域"]
    local boss = context["Boss单位"]
    if boss == nil or boss == 0 then
        return
    end
    _____786E_4FDDBoss_81EA_8EAB_9886_57DF_8868_73B0(boss)
    local next = {}
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    local radius2 = config["半径"] * config["半径"]
    do
        local i = 0
        while i < #heroes do
            do
                local target = heroes[i + 1]
                if _____8DDD_79BB_5E73_65B9(boss, target) <= radius2 then
                    local targetId = _____53D6_5355_4F4DID(target)
                    if targetId == 0 then
                        goto __continue20
                    end
                    next[targetId] = 1
                    _____79E9_5E8F_9886_57DF_5F71_54CD_5355_4F4D_8868[targetId] = target
                    _____79E9_5E8F_9886_57DF_6765_6E90_540D_79F0_8868[targetId] = GetUnitName(boss)
                end
            end
            ::__continue20::
            i = i + 1
        end
    end
    _____540C_6B65_79E9_5E8F_9886_57DF_5F71_54CD(next)
end
____exports["清理瑟兰迪尔秩序领域"] = function(boss)
    if boss ~= nil and boss ~= 0 then
        __TS__Delete(
            _____79E9_5E8F_9886_57DF_7279_6548_7F29_653E_8868,
            _____53D6_5355_4F4DID(boss)
        )
        _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548(boss, _____9886_57DF_7279_6548_952E)
    end
    local next = {}
    _____540C_6B65_79E9_5E8F_9886_57DF_5F71_54CD(next)
end
return ____exports
