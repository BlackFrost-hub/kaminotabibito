local ____lualib = require("lualib_bundle")
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____6E05_7406_788E_7901_5F39_5E55_72B6_6001, _____6D3B_52A8_5F39_5E55ID_5217_8868, _____5F39_5E55_72B6_6001_8868
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.02．精英技能.03．第三章.04．碎礁投石手.00．配置")
local _____788E_7901_6295_77F3_624B_914D_7F6E = ____00_FF0E_914D_7F6E["碎礁投石手配置"]
local ____01_FF0E_5171_4EAB = require("系统.03．技能系统.05．单位技能.01．杂鱼技能.03．第三章.00．封印守卫战公共.01．共享")
local _____5355_4F4D_5904_4E8E_786C_63A7_5236 = ____01_FF0E_5171_4EAB["单位处于硬控制"]
local _____547D_4EE4_653B_51FB_76EE_6807 = ____01_FF0E_5171_4EAB["命令攻击目标"]
local _____53D6_5355_4F4DX = ____01_FF0E_5171_4EAB["取单位X"]
local _____53D6_5355_4F4DY = ____01_FF0E_5171_4EAB["取单位Y"]
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____01_FF0E_5171_4EAB["读取单位攻击力"]
local _____53D6_5355_4F4D_8DDD_79BB_5E73_65B9 = ____01_FF0E_5171_4EAB["取单位距离平方"]
local _____8BFB_53D6_5C01_5370_5B88_536B_6218_73A9_5BB6_82F1_96C4_5217_8868 = ____01_FF0E_5171_4EAB["读取封印守卫战玩家英雄列表"]
local _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55 = ____01_FF0E_5171_4EAB["读取封印守卫战敌人记录"]
local _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B = ____01_FF0E_5171_4EAB["封印守卫战单位存活"]
local _____662F_5C01_5370_5B88_536B_6218_73A9_5BB6_82F1_96C4 = ____01_FF0E_5171_4EAB["是封印守卫战玩家英雄"]
local _____521B_5EFA_5C01_5370_5B88_536B_6218_70B9_7279_6548 = ____01_FF0E_5171_4EAB["创建封印守卫战点特效"]
function _____6E05_7406_788E_7901_5F39_5E55_72B6_6001(barrageId)
    __TS__Delete(_____5F39_5E55_72B6_6001_8868, barrageId)
    local index = __TS__ArrayIndexOf(_____6D3B_52A8_5F39_5E55ID_5217_8868, barrageId)
    if index >= 0 then
        __TS__ArraySplice(_____6D3B_52A8_5F39_5E55ID_5217_8868, index, 1)
    end
end
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统")
local _____5F00_59CB_5145_80FD = ____require_result_0["开始充能"]
local _____505C_6B62_5355_4F4D_5145_80FD = ____require_result_0["停止单位充能"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_1["创建技能提示圈"]
local ____require_result_2 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_2["造成单体技能伤害"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____require_result_3["开始硬直"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口")
local _____521B_5EFA_539F_751F_5F39_5E55 = ____require_result_4["创建原生弹幕"]
local _____9500_6BC1_539F_751F_5F39_5E55 = ____require_result_4["销毁原生弹幕"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.01．轨迹.index")
local _____521B_5EFA_4E8C_9636_8D1D_585E_5C14_52A0_901F_5EA6_629B_7269_7EBF_8F68_8FF9 = ____require_result_5["创建二阶贝塞尔加速度抛物线轨迹"]
local ____require_result_6 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_6.getServerTime
local ____require_result_7 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_7.addDelayedCallback
local jass = require("jass.common")
local CreateDeadDestructable = jass.CreateDeadDestructable
local RemoveDestructable = jass.RemoveDestructable
local GetRandomReal = jass.GetRandomReal
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_8 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_8.stringToFourCCSafe
local _____5CA9_77F3_7269_7F16ID = stringToFourCCSafe(_____788E_7901_6295_77F3_624B_914D_7F6E["落地装饰物ID"])
_____6D3B_52A8_5F39_5E55ID_5217_8868 = {}
_____5F39_5E55_72B6_6001_8868 = {}
local _____5CA9_77F3_72B6_6001_5217_8868 = {}
local function _____53D6_6700_8FDC_73A9_5BB6_82F1_96C4(record)
    local heroes = _____8BFB_53D6_5C01_5370_5B88_536B_6218_73A9_5BB6_82F1_96C4_5217_8868()
    local target = nil
    local bestDistance = -1
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(hero) then
                    goto __continue4
                end
                local distance = _____53D6_5355_4F4D_8DDD_79BB_5E73_65B9(record["单位"], hero)
                if distance > bestDistance then
                    bestDistance = distance
                    target = hero
                end
            end
            ::__continue4::
            i = i + 1
        end
    end
    return target
end
local function _____6295_77F3_624B_88AB_8FD1_8EAB(record)
    local heroes = _____8BFB_53D6_5C01_5370_5B88_536B_6218_73A9_5BB6_82F1_96C4_5217_8868()
    do
        local i = 0
        while i < #heroes do
            if _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(heroes[i + 1]) and _____53D6_5355_4F4D_8DDD_79BB_5E73_65B9(record["单位"], heroes[i + 1]) <= _____788E_7901_6295_77F3_624B_914D_7F6E["近身禁止距离"] * _____788E_7901_6295_77F3_624B_914D_7F6E["近身禁止距离"] then
                return true
            end
            i = i + 1
        end
    end
    return false
end
local function _____5220_9664_788E_7901_5CA9_77F3(variable)
    local state = variable
    if state == nil then
        return
    end
    if state["岩石"] ~= nil and state["岩石"] ~= 0 then
        RemoveDestructable(state["岩石"])
    end
    local index = __TS__ArrayIndexOf(_____5CA9_77F3_72B6_6001_5217_8868, state)
    if index >= 0 then
        __TS__ArraySplice(_____5CA9_77F3_72B6_6001_5217_8868, index, 1)
    end
end
local function _____521B_5EFA_788E_7901_843D_5730_5CA9_77F3(x, y)
    if not (_____5CA9_77F3_7269_7F16ID > 0) then
        return
    end
    local rock = CreateDeadDestructable(
        _____5CA9_77F3_7269_7F16ID,
        x,
        y,
        GetRandomReal(0, 360),
        1,
        0
    )
    if rock == nil or rock == 0 then
        return
    end
    local state = {["岩石"] = rock, ["删除回调ID"] = 0}
    state["删除回调ID"] = addDelayedCallback(_____788E_7901_6295_77F3_624B_914D_7F6E["岩石删除秒"] * 1000, _____5220_9664_788E_7901_5CA9_77F3, state)
    _____5CA9_77F3_72B6_6001_5217_8868[#_____5CA9_77F3_72B6_6001_5217_8868 + 1] = state
end
local function _____788E_7901_6295_63B7_5230_8FBE_76EE_6807_70B9(barrageId, _reason)
    local state = _____5F39_5E55_72B6_6001_8868[barrageId]
    if state == nil or state["已结算"] then
        return
    end
    state["已结算"] = true
    local source = state["来源"]
    _____521B_5EFA_5C01_5370_5B88_536B_6218_70B9_7279_6548({
        ["模型路径"] = _____788E_7901_6295_77F3_624B_914D_7F6E["落地特效"],
        X = state["目标X"],
        Y = state["目标Y"],
        Z = 0,
        ["缩放"] = 0.85,
        ["持续秒"] = 1.4
    })
    _____521B_5EFA_788E_7901_843D_5730_5CA9_77F3(state["目标X"], state["目标Y"])
    local heroes = _____8BFB_53D6_5C01_5370_5B88_536B_6218_73A9_5BB6_82F1_96C4_5217_8868()
    local damage = _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(source) and _____8BFB_53D6_5355_4F4D_653B_51FB_529B(source) * _____788E_7901_6295_77F3_624B_914D_7F6E["伤害攻击力比例"] or 0
    do
        local i = 0
        while i < #heroes do
            do
                local target = heroes[i + 1]
                if not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(target) or not _____662F_5C01_5370_5B88_536B_6218_73A9_5BB6_82F1_96C4(target) then
                    goto __continue21
                end
                local dx = _____53D6_5355_4F4DX(target) - state["目标X"]
                local dy = _____53D6_5355_4F4DY(target) - state["目标Y"]
                if dx * dx + dy * dy > _____788E_7901_6295_77F3_624B_914D_7F6E["伤害半径"] * _____788E_7901_6295_77F3_624B_914D_7F6E["伤害半径"] then
                    goto __continue21
                end
                _____5F00_59CB_786C_76F4(target, _____788E_7901_6295_77F3_624B_914D_7F6E["硬直秒"])
                _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
                    ["来源"] = source,
                    ["目标"] = target,
                    ["伤害"] = damage,
                    ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                    attack = false,
                    ranged = true,
                    attackType = ATTACK_TYPE_NORMAL,
                    weaponType = WEAPON_TYPE_WHOKNOWS,
                    ["来源类型"] = "单位技能",
                    ["标签"] = "第三章-碎礁投石手-碎礁投掷",
                    ["参与技能伤害加成"] = false
                })
            end
            ::__continue21::
            i = i + 1
        end
    end
    _____6E05_7406_788E_7901_5F39_5E55_72B6_6001(barrageId)
end
local function _____788E_7901_6295_63B7_7ED3_675F(reason, barrageId)
    if reason == "完成" or reason == "距离结束" then
        return
    end
    _____6E05_7406_788E_7901_5F39_5E55_72B6_6001(barrageId)
end
local function _____788E_7901_6295_63B7_5145_80FD_5468_671F(unit, chargeId)
    local record = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55(unit)
    if record == nil or record["类型"] ~= "碎礁投石手" or record["充能ID"] ~= chargeId then
        return
    end
    if _____5355_4F4D_5904_4E8E_786C_63A7_5236(unit) or _____6295_77F3_624B_88AB_8FD1_8EAB(record) then
        _____505C_6B62_5355_4F4D_5145_80FD(unit)
    end
end
local function _____788E_7901_6295_63B7_5145_80FD_5B8C_6210(unit, chargeId)
    local record = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55(unit)
    if record == nil or record["类型"] ~= "碎礁投石手" or record["充能ID"] ~= chargeId then
        return
    end
    record["充能ID"] = 0
    local target = record["当前目标"]
    record["当前目标"] = nil
    if not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(target) or _____6295_77F3_624B_88AB_8FD1_8EAB(record) then
        return
    end
    local startX = _____53D6_5355_4F4DX(unit)
    local startY = _____53D6_5355_4F4DY(unit)
    local endX = _____53D6_5355_4F4DX(target)
    local endY = _____53D6_5355_4F4DY(target)
    local controlX = (startX + endX) * 0.5
    local controlY = (startY + endY) * 0.5
    local barrage = _____521B_5EFA_539F_751F_5F39_5E55({
        ["所有者"] = unit,
        ["载体模式"] = "特效",
        X = startX,
        Y = startY,
        ["方向角"] = 0,
        ["速度"] = 0,
        ["生命周期"] = 4,
        ["轨迹采样器"] = _____521B_5EFA_4E8C_9636_8D1D_585E_5C14_52A0_901F_5EA6_629B_7269_7EBF_8F68_8FF9(
            startX,
            startY,
            80,
            controlX,
            controlY,
            endX,
            endY,
            0,
            _____788E_7901_6295_77F3_624B_914D_7F6E["抛物线抬高"],
            _____788E_7901_6295_77F3_624B_914D_7F6E["抛物速度"]
        ),
        ["附加特效1"] = {["模型"] = _____788E_7901_6295_77F3_624B_914D_7F6E["投射物特效"], ["缩放"] = 1.1, ["跟随轨迹俯仰"] = true},
        ["on到达目标点"] = _____788E_7901_6295_63B7_5230_8FBE_76EE_6807_70B9,
        ["on结束"] = _____788E_7901_6295_63B7_7ED3_675F
    })
    if barrage == nil or not (barrage["弹幕ID"] > 0) then
        return
    end
    local barrageId = barrage["弹幕ID"]
    _____5F39_5E55_72B6_6001_8868[barrageId] = {["来源"] = unit, ["目标X"] = endX, ["目标Y"] = endY, ["已结算"] = false}
    _____6D3B_52A8_5F39_5E55ID_5217_8868[#_____6D3B_52A8_5F39_5E55ID_5217_8868 + 1] = barrageId
    record["下次技能毫秒"] = getServerTime() + _____788E_7901_6295_77F3_624B_914D_7F6E["技能冷却毫秒"]
end
local function _____788E_7901_6295_63B7_5145_80FD_7ED3_675F(unit, reason, chargeId)
    local record = _____8BFB_53D6_5C01_5370_5B88_536B_6218_654C_4EBA_8BB0_5F55(unit)
    if record == nil or record["类型"] ~= "碎礁投石手" then
        return
    end
    if record["充能ID"] == chargeId then
        record["充能ID"] = 0
    end
    record["当前目标"] = nil
    if reason ~= "完成" then
        record["下次技能毫秒"] = getServerTime() + _____788E_7901_6295_77F3_624B_914D_7F6E["技能冷却毫秒"]
    end
end
____exports["尝试释放碎礁投掷"] = function(record)
    if record["充能ID"] ~= 0 or _____5355_4F4D_5904_4E8E_786C_63A7_5236(record["单位"]) or _____6295_77F3_624B_88AB_8FD1_8EAB(record) then
        return false
    end
    local target = _____53D6_6700_8FDC_73A9_5BB6_82F1_96C4(record)
    if not _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(target) then
        return false
    end
    record["当前目标"] = target
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "圆形",
        X = _____53D6_5355_4F4DX(target),
        Y = _____53D6_5355_4F4DY(target),
        ["半径"] = _____788E_7901_6295_77F3_624B_914D_7F6E["预警半径"],
        ["持续时间"] = _____788E_7901_6295_77F3_624B_914D_7F6E["预警秒"],
        ["来源单位"] = record["单位"]
    })
    local id = _____5F00_59CB_5145_80FD(record["单位"], {
        ["持续时间"] = _____788E_7901_6295_77F3_624B_914D_7F6E["预警秒"],
        ["强制硬直"] = true,
        ["显示进度条特效"] = true,
        ["周期回调间隔"] = 0.1,
        ["周期回调"] = _____788E_7901_6295_63B7_5145_80FD_5468_671F,
        ["充能完成回调"] = _____788E_7901_6295_63B7_5145_80FD_5B8C_6210,
        ["结束回调"] = _____788E_7901_6295_63B7_5145_80FD_7ED3_675F
    })
    record["充能ID"] = id
    return id > 0
end
____exports["刷新碎礁投石手AI"] = function(record, _____5F53_524D_6BEB_79D2)
    if record["充能ID"] ~= 0 or _____5F53_524D_6BEB_79D2 < record["下次AI毫秒"] then
        return
    end
    record["下次AI毫秒"] = _____5F53_524D_6BEB_79D2 + _____788E_7901_6295_77F3_624B_914D_7F6E["AI刷新毫秒"]
    if _____5F53_524D_6BEB_79D2 >= record["下次技能毫秒"] and ____exports["尝试释放碎礁投掷"](record) then
        return
    end
    local target = _____53D6_6700_8FDC_73A9_5BB6_82F1_96C4(record)
    if _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(target) then
        record["当前目标"] = target
        _____547D_4EE4_653B_51FB_76EE_6807(record["单位"], target)
    end
end
____exports["清理碎礁投石手机制"] = function(record)
    if record["充能ID"] ~= 0 and _____5C01_5370_5B88_536B_6218_5355_4F4D_5B58_6D3B(record["单位"]) then
        _____505C_6B62_5355_4F4D_5145_80FD(record["单位"])
    end
    record["充能ID"] = 0
    record["当前目标"] = nil
    local ids = {}
    do
        local i = 0
        while i < #_____6D3B_52A8_5F39_5E55ID_5217_8868 do
            local state = _____5F39_5E55_72B6_6001_8868[_____6D3B_52A8_5F39_5E55ID_5217_8868[i + 1]]
            if state ~= nil and state["来源"] == record["单位"] then
                ids[#ids + 1] = _____6D3B_52A8_5F39_5E55ID_5217_8868[i + 1]
            end
            i = i + 1
        end
    end
    do
        local i = 0
        while i < #ids do
            _____9500_6BC1_539F_751F_5F39_5E55(ids[i + 1], "手动销毁")
            i = i + 1
        end
    end
end
return ____exports
