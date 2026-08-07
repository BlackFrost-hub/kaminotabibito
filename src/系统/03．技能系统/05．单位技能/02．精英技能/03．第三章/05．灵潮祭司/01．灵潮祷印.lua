local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.02．精英技能.03．第三章.05．灵潮祭司.00．配置")
local _____7075_6F6E_796D_53F8_914D_7F6E = ____00_FF0E_914D_7F6E["灵潮祭司配置"]
local ____01_FF0E_5171_4EAB = require("系统.03．技能系统.05．单位技能.01．杂鱼技能.03．第三章.00．封印守卫战公共.01．共享")
local _____5355_4F4D_5904_4E8E_786C_63A7_5236 = ____01_FF0E_5171_4EAB["单位处于硬控制"]
local _____547D_4EE4_653B_51FB_76EE_6807 = ____01_FF0E_5171_4EAB["命令攻击目标"]
local _____53D6_5355_4F4DX = ____01_FF0E_5171_4EAB["取单位X"]
local _____53D6_5355_4F4DY = ____01_FF0E_5171_4EAB["取单位Y"]
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____01_FF0E_5171_4EAB["读取单位攻击力"]
local _____8BFB_53D6_5355_4F4D_751F_547D = ____01_FF0E_5171_4EAB["读取单位生命"]
local _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D = ____01_FF0E_5171_4EAB["读取单位最大生命"]
local _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_5217_8868 = ____01_FF0E_5171_4EAB["读取封印守卫战敌人列表"]
local _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55 = ____01_FF0E_5171_4EAB["读取封印守卫战敌人记录"]
local _____8BFB_53D6_5C01_5370_5B88_536B_6218_73A9_5BB6_82F1_96C4_5217_8868 = ____01_FF0E_5171_4EAB["读取封印守卫战玩家英雄列表"]
local _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B = ____01_FF0E_5171_4EAB["封印守卫战单位存活"]
local _____662F_5C01_5370_5B88_536B_6218_73A9_5BB6_82F1_96C4 = ____01_FF0E_5171_4EAB["是封印守卫战玩家英雄"]
local _____521B_5EFA_5C01_5370_5B88_536B_6218_70B9_7279_6548 = ____01_FF0E_5171_4EAB["创建封印守卫战点特效"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统")
local _____5F00_59CB_5145_80FD = ____require_result_0["开始充能"]
local _____505C_6B62_5355_4F4D_5145_80FD = ____require_result_0["停止单位充能"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_1["创建技能提示圈"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.07．机制连线.01．持续单位连线")
local _____521B_5EFA_6301_7EED_5355_4F4D_8FDE_7EBF = ____require_result_2["创建持续单位连线"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.17．闪电效果代码")
local _____95EA_7535_6548_679C_4EE3_7801 = ____require_result_3["闪电效果代码"]
local ____require_result_4 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_4["造成单体技能伤害"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____65BD_52A0_5FEB_901F_51CF_901FBuff = ____require_result_5["施加快速减速Buff"]
local ____require_result_6 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local doHeal = ____require_result_6.doHeal
local ____require_result_7 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_7.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_7["移除单位指定Buff"]
local ____require_result_8 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_8.getServerTime
local jass = require("jass.common")
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____7075_6F6E_796D_53F8BuffID = {["祷印减速"] = "SGW6", ["潮蚀护持"] = "SGW7"}
local function _____83B7_53D6_796D_53F8_9644_52A0_72B6_6001(record)
    if record["附加状态"] == nil then
        record["附加状态"] = {}
    end
    return record["附加状态"]
end
local function _____9009_62E9_6700_5BC6_96C6_73A9_5BB6_4F4D_7F6E()
    local heroes = _____8BFB_53D6_5C01_5370_5B88_536B_6218_73A9_5BB6_82F1_96C4_5217_8868()
    local bestCount = 0
    local best
    do
        local i = 0
        while i < #heroes do
            do
                local center = heroes[i + 1]
                if not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(center) then
                    goto __continue6
                end
                local count = 0
                do
                    local j = 0
                    while j < #heroes do
                        do
                            local target = heroes[j + 1]
                            if not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(target) then
                                goto __continue9
                            end
                            local dx = _____53D6_5355_4F4DX(target) - _____53D6_5355_4F4DX(center)
                            local dy = _____53D6_5355_4F4DY(target) - _____53D6_5355_4F4DY(center)
                            if dx * dx + dy * dy <= _____7075_6F6E_796D_53F8_914D_7F6E["祷印半径"] * _____7075_6F6E_796D_53F8_914D_7F6E["祷印半径"] then
                                count = count + 1
                            end
                        end
                        ::__continue9::
                        j = j + 1
                    end
                end
                if count > bestCount then
                    bestCount = count
                    best = {
                        ["目标X"] = _____53D6_5355_4F4DX(center),
                        ["目标Y"] = _____53D6_5355_4F4DY(center)
                    }
                end
            end
            ::__continue6::
            i = i + 1
        end
    end
    return best
end
local function _____7075_6F6E_7977_5370_5145_80FD_5468_671F(unit, chargeId)
    local record = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55(unit)
    if record == nil or record["类型"] ~= "灵潮祭司" or record["充能ID"] ~= chargeId then
        return
    end
    if _____5355_4F4D_5904_4E8E_786C_63A7_5236(unit) then
        _____505C_6B62_5355_4F4D_5145_80FD(unit)
    end
end
local function _____7075_6F6E_7977_5370_5145_80FD_5B8C_6210(unit, chargeId)
    local record = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55(unit)
    if record == nil or record["类型"] ~= "灵潮祭司" or record["充能ID"] ~= chargeId then
        return
    end
    record["充能ID"] = 0
    local ____opt_9 = record["附加状态"]
    local state = ____opt_9 and ____opt_9["灵潮祷印"]
    if state == nil then
        return
    end
    _____521B_5EFA_5C01_5370_5B88_536B_6218_70B9_7279_6548({
        ["模型路径"] = _____7075_6F6E_796D_53F8_914D_7F6E["爆发特效"],
        X = state["目标X"],
        Y = state["目标Y"],
        Z = 0,
        ["缩放"] = 1,
        ["持续秒"] = 1.5
    })
    local heroes = _____8BFB_53D6_5C01_5370_5B88_536B_6218_73A9_5BB6_82F1_96C4_5217_8868()
    local damage = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(unit) * _____7075_6F6E_796D_53F8_914D_7F6E["祷印伤害攻击力比例"]
    do
        local i = 0
        while i < #heroes do
            do
                local target = heroes[i + 1]
                if not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(target) or not _____662F_5C01_5370_5B88_536B_6218_73A9_5BB6_82F1_96C4(target) then
                    goto __continue20
                end
                local dx = _____53D6_5355_4F4DX(target) - state["目标X"]
                local dy = _____53D6_5355_4F4DY(target) - state["目标Y"]
                if dx * dx + dy * dy > _____7075_6F6E_796D_53F8_914D_7F6E["祷印半径"] * _____7075_6F6E_796D_53F8_914D_7F6E["祷印半径"] then
                    goto __continue20
                end
                _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
                    ["来源"] = unit,
                    ["目标"] = target,
                    ["伤害"] = damage,
                    ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                    attack = false,
                    ranged = true,
                    attackType = ATTACK_TYPE_NORMAL,
                    weaponType = WEAPON_TYPE_WHOKNOWS,
                    ["来源类型"] = "单位技能",
                    ["标签"] = "第三章-灵潮祭司-灵潮祷印",
                    ["参与技能伤害加成"] = false
                })
                _____65BD_52A0_5FEB_901F_51CF_901FBuff(
                    unit,
                    target,
                    0,
                    _____7075_6F6E_796D_53F8_914D_7F6E["祷印减速比例"],
                    _____7075_6F6E_796D_53F8_914D_7F6E["祷印减速秒"],
                    "灵潮祭司-灵潮祷印",
                    "技能",
                    _____7075_6F6E_796D_53F8BuffID["祷印减速"]
                )
            end
            ::__continue20::
            i = i + 1
        end
    end
    if record["附加状态"] ~= nil then
        __TS__Delete(record["附加状态"], "灵潮祷印")
        record["附加状态"]["灵潮祷印冷却毫秒"] = getServerTime() + _____7075_6F6E_796D_53F8_914D_7F6E["祷印冷却毫秒"]
    end
end
local function _____7075_6F6E_7977_5370_5145_80FD_7ED3_675F(unit, reason, chargeId)
    local record = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55(unit)
    if record == nil or record["类型"] ~= "灵潮祭司" then
        return
    end
    if record["充能ID"] == chargeId then
        record["充能ID"] = 0
    end
    if record["附加状态"] ~= nil then
        __TS__Delete(record["附加状态"], "灵潮祷印")
    end
    if reason ~= "完成" then
        _____83B7_53D6_796D_53F8_9644_52A0_72B6_6001(record)["灵潮祷印冷却毫秒"] = getServerTime() + _____7075_6F6E_796D_53F8_914D_7F6E["祷印冷却毫秒"]
    end
end
____exports["尝试释放灵潮祷印"] = function(record)
    if record["充能ID"] ~= 0 or _____5355_4F4D_5904_4E8E_786C_63A7_5236(record["单位"]) then
        return false
    end
    local state = _____9009_62E9_6700_5BC6_96C6_73A9_5BB6_4F4D_7F6E()
    if state == nil then
        return false
    end
    local now = getServerTime()
    local ____opt_11 = record["附加状态"]
    local ____temp_13 = ____opt_11 and ____opt_11["灵潮祷印冷却毫秒"]
    if ____temp_13 == nil then
        ____temp_13 = 0
    end
    if ____temp_13 > now then
        return false
    end
    _____83B7_53D6_796D_53F8_9644_52A0_72B6_6001(record)["灵潮祷印"] = state
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "圆形",
        X = state["目标X"],
        Y = state["目标Y"],
        ["半径"] = _____7075_6F6E_796D_53F8_914D_7F6E["祷印半径"],
        ["持续时间"] = _____7075_6F6E_796D_53F8_914D_7F6E["祷印预警秒"],
        ["来源单位"] = record["单位"]
    })
    _____521B_5EFA_5C01_5370_5B88_536B_6218_70B9_7279_6548({
        ["模型路径"] = _____7075_6F6E_796D_53F8_914D_7F6E["祷印特效"],
        X = state["目标X"],
        Y = state["目标Y"],
        Z = 0,
        ["缩放"] = 0.9,
        ["持续秒"] = _____7075_6F6E_796D_53F8_914D_7F6E["祷印预警秒"] + 0.1
    })
    local id = _____5F00_59CB_5145_80FD(record["单位"], {
        ["持续时间"] = _____7075_6F6E_796D_53F8_914D_7F6E["祷印预警秒"],
        ["强制硬直"] = true,
        ["显示进度条特效"] = true,
        ["周期回调间隔"] = 0.1,
        ["周期回调"] = _____7075_6F6E_7977_5370_5145_80FD_5468_671F,
        ["充能完成回调"] = _____7075_6F6E_7977_5370_5145_80FD_5B8C_6210,
        ["结束回调"] = _____7075_6F6E_7977_5370_5145_80FD_7ED3_675F
    })
    record["充能ID"] = id
    return id > 0
end
local function _____662F_7075_6F6E_796D_53F8_7CBE_82F1(_____7C7B_578B)
    return _____7C7B_578B == "碎礁投石手" or _____7C7B_578B == "灵潮祭司" or _____7C7B_578B == "金鳞执刑官" or _____7C7B_578B == "深渊鳞将"
end
local function _____9009_62E9_6F6E_8680_62A4_6301_76EE_6807(source)
    local list = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_5217_8868()
    local eliteTarget = nil
    local eliteRatio = 999999
    local normalTarget = nil
    local normalRatio = 999999
    do
        local i = 0
        while i < #list do
            do
                local record = list[i + 1]
                if record == source or not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(record["单位"]) then
                    goto __continue36
                end
                local dx = _____53D6_5355_4F4DX(record["单位"]) - _____53D6_5355_4F4DX(source["单位"])
                local dy = _____53D6_5355_4F4DY(record["单位"]) - _____53D6_5355_4F4DY(source["单位"])
                if dx * dx + dy * dy > _____7075_6F6E_796D_53F8_914D_7F6E["支持范围"] * _____7075_6F6E_796D_53F8_914D_7F6E["支持范围"] then
                    goto __continue36
                end
                local maxLife = _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D(record["单位"])
                local ratio = maxLife > 0 and _____8BFB_53D6_5355_4F4D_751F_547D(record["单位"]) / maxLife or 1
                if _____662F_7075_6F6E_796D_53F8_7CBE_82F1(record["类型"]) and ratio < eliteRatio then
                    eliteRatio = ratio
                    eliteTarget = record["单位"]
                elseif record["类型"] == "潮蚀巡鳞者" and ratio < normalRatio then
                    normalRatio = ratio
                    normalTarget = record["单位"]
                end
            end
            ::__continue36::
            i = i + 1
        end
    end
    local ____eliteTarget_14 = eliteTarget
    if ____eliteTarget_14 == nil then
        ____eliteTarget_14 = normalTarget
    end
    return ____eliteTarget_14
end
local function _____7ED3_675F_6F6E_8680_62A4_6301(record, reason)
    local ____opt_15 = record["附加状态"]
    local state = ____opt_15 and ____opt_15["潮蚀护持"]
    if state == nil then
        return
    end
    if state["连线"] ~= nil then
        local ____self_17 = state["连线"]
        ____self_17["停止"](____self_17, reason)
    end
    if _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(state["目标"]) then
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(state["目标"], _____7075_6F6E_796D_53F8BuffID["潮蚀护持"])
    end
    if record["附加状态"] ~= nil then
        __TS__Delete(record["附加状态"], "潮蚀护持")
    end
end
local function _____6F6E_8680_62A4_6301_5468_671F(source, target)
    local record = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55(source)
    if record == nil or record["类型"] ~= "灵潮祭司" then
        return
    end
    local ____opt_18 = record["附加状态"]
    local state = ____opt_18 and ____opt_18["潮蚀护持"]
    if state == nil or state["目标"] ~= target then
        return
    end
    local now = getServerTime()
    if not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(target) or now >= state["结束毫秒"] or _____5355_4F4D_5904_4E8E_786C_63A7_5236(source) then
        _____7ED3_675F_6F6E_8680_62A4_6301(record, "条件中断")
        return
    end
    local dx = _____53D6_5355_4F4DX(source) - _____53D6_5355_4F4DX(target)
    local dy = _____53D6_5355_4F4DY(source) - _____53D6_5355_4F4DY(target)
    if dx * dx + dy * dy > _____7075_6F6E_796D_53F8_914D_7F6E["护持断开距离"] * _____7075_6F6E_796D_53F8_914D_7F6E["护持断开距离"] then
        _____7ED3_675F_6F6E_8680_62A4_6301(record, "距离断开")
        return
    end
    if now >= state["下次治疗毫秒"] then
        local heal = _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D(target) * _____7075_6F6E_796D_53F8_914D_7F6E["护持每秒治疗比例"]
        if heal > 0 then
            doHeal({
                HealSource = source,
                HealTarget = target,
                HealAmount = heal,
                ItemHeal = false,
                HealEffect = false
            })
            _____521B_5EFA_5C01_5370_5B88_536B_6218_70B9_7279_6548({
                ["模型路径"] = _____7075_6F6E_796D_53F8_914D_7F6E["回灌特效"],
                X = _____53D6_5355_4F4DX(target),
                Y = _____53D6_5355_4F4DY(target),
                Z = 0,
                ["缩放"] = 0.55,
                ["持续秒"] = 0.8
            })
        end
        state["下次治疗毫秒"] = now + 1000
    end
end
local function _____6F6E_8680_62A4_6301_8FDE_7EBF_65AD_5F00(_reason)
end
local function _____91CA_653E_6F6E_8680_62A4_6301(record)
    local ____opt_20 = record["附加状态"]
    if (____opt_20 and ____opt_20["潮蚀护持"]) ~= nil or _____5355_4F4D_5904_4E8E_786C_63A7_5236(record["单位"]) then
        return false
    end
    local target = _____9009_62E9_6F6E_8680_62A4_6301_76EE_6807(record)
    if not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(target) then
        return false
    end
    local now = getServerTime()
    local ____opt_22 = record["附加状态"]
    local ____temp_24 = ____opt_22 and ____opt_22["潮蚀护持冷却毫秒"]
    if ____temp_24 == nil then
        ____temp_24 = 0
    end
    if ____temp_24 > now then
        return false
    end
    local state = {
        ["祭司"] = record["单位"],
        ["目标"] = target,
        ["连线"] = nil,
        ["结束毫秒"] = now + _____7075_6F6E_796D_53F8_914D_7F6E["护持持续秒"] * 1000,
        ["下次治疗毫秒"] = now + 1000
    }
    _____83B7_53D6_796D_53F8_9644_52A0_72B6_6001(record)["潮蚀护持"] = state
    registerManualBuff(
        target,
        _____7075_6F6E_796D_53F8BuffID["潮蚀护持"],
        _____7075_6F6E_796D_53F8_914D_7F6E["护持持续秒"],
        _____7075_6F6E_796D_53F8_914D_7F6E["护持减伤比例"],
        {sourceUnit = record["单位"], effectSourceName = "灵潮祭司-潮蚀护持", effectSourceType = "技能"}
    )
    state["连线"] = _____521B_5EFA_6301_7EED_5355_4F4D_8FDE_7EBF({
        ["名称"] = "第三章-灵潮祭司-潮蚀护持",
        ["起点单位"] = record["单位"],
        ["终点单位"] = target,
        ["闪电代码"] = _____95EA_7535_6548_679C_4EE3_7801["蓝色细束"],
        ["持续秒"] = _____7075_6F6E_796D_53F8_914D_7F6E["护持持续秒"],
        ["断开距离"] = _____7075_6F6E_796D_53F8_914D_7F6E["护持断开距离"],
        ["Tick间隔毫秒"] = 50,
        ["on周期"] = _____6F6E_8680_62A4_6301_5468_671F,
        ["on断开"] = _____6F6E_8680_62A4_6301_8FDE_7EBF_65AD_5F00
    })
    if state["连线"] == nil then
        _____7ED3_675F_6F6E_8680_62A4_6301(record, "创建失败")
        return false
    end
    _____83B7_53D6_796D_53F8_9644_52A0_72B6_6001(record)["潮蚀护持冷却毫秒"] = now + _____7075_6F6E_796D_53F8_914D_7F6E["护持冷却毫秒"]
    return true
end
____exports["修正潮蚀护持减伤"] = function(context)
    local ____opt_result_27
    if context ~= nil then
        ____opt_result_27 = context.target
    end
    local target = ____opt_result_27
    if not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(target) then
        return context.currentDamage
    end
    local list = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_5217_8868()
    local now = getServerTime()
    do
        local i = 0
        while i < #list do
            local ____opt_28 = list[i + 1]["附加状态"]
            local state = ____opt_28 and ____opt_28["潮蚀护持"]
            if state ~= nil and state["目标"] == target and now < state["结束毫秒"] then
                return context.currentDamage * (1 - _____7075_6F6E_796D_53F8_914D_7F6E["护持减伤比例"])
            end
            i = i + 1
        end
    end
    return context.currentDamage
end
____exports["刷新灵潮祭司AI"] = function(record, _____5F53_524D_6BEB_79D2)
    if record["充能ID"] ~= 0 or _____5F53_524D_6BEB_79D2 < record["下次AI毫秒"] then
        return
    end
    record["下次AI毫秒"] = _____5F53_524D_6BEB_79D2 + _____7075_6F6E_796D_53F8_914D_7F6E["AI刷新毫秒"]
    local ____opt_30 = record["附加状态"]
    local support = ____opt_30 and ____opt_30["潮蚀护持"]
    if support ~= nil and (_____5F53_524D_6BEB_79D2 >= support["结束毫秒"] or not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(support["目标"]) or _____5355_4F4D_5904_4E8E_786C_63A7_5236(record["单位"])) then
        _____7ED3_675F_6F6E_8680_62A4_6301(record, "条件中断")
    end
    local ____5F53_524D_6BEB_79D2_35 = _____5F53_524D_6BEB_79D2
    local ____opt_32 = record["附加状态"]
    local ____temp_34 = ____opt_32 and ____opt_32["灵潮祷印冷却毫秒"]
    if ____temp_34 == nil then
        ____temp_34 = 0
    end
    if ____5F53_524D_6BEB_79D2_35 >= ____temp_34 and ____exports["尝试释放灵潮祷印"](record) then
        return
    end
    local ____5F53_524D_6BEB_79D2_39 = _____5F53_524D_6BEB_79D2
    local ____opt_36 = record["附加状态"]
    local ____temp_38 = ____opt_36 and ____opt_36["潮蚀护持冷却毫秒"]
    if ____temp_38 == nil then
        ____temp_38 = 0
    end
    if ____5F53_524D_6BEB_79D2_39 >= ____temp_38 and _____91CA_653E_6F6E_8680_62A4_6301(record) then
        return
    end
    local target = _____8BFB_53D6_5C01_5370_5B88_536B_6218_73A9_5BB6_82F1_96C4_5217_8868()[1]
    if _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(target) then
        record["当前目标"] = target
        _____547D_4EE4_653B_51FB_76EE_6807(record["单位"], target)
    end
end
____exports["清理灵潮祭司机制"] = function(record)
    if record["充能ID"] ~= 0 and _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(record["单位"]) then
        _____505C_6B62_5355_4F4D_5145_80FD(record["单位"])
    end
    record["充能ID"] = 0
    _____7ED3_675F_6F6E_8680_62A4_6301(record, "机制清理")
    record["当前目标"] = nil
    if record["附加状态"] ~= nil then
        __TS__Delete(record["附加状态"], "灵潮祷印")
    end
end
return ____exports
