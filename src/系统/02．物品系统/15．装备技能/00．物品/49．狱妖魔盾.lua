local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.01．物品使用配置表")
local _____7269_54C1_4F7F_7528_88C5_5907ID = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用装备ID"]
local _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用数值配置"]
local ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____662F_5426_4E3A_4F7F_7528_7269_54C1 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["是否为使用物品"]
local _____5355_4F4D_6301_6709_7269_54C1 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["单位持有物品"]
local _____53D6_53E5_67C4ID = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取句柄ID"]
local _____5355_4F4D_5B58_6D3B = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["单位存活"]
local _____53D6_5F53_524D_751F_547D = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取当前生命"]
local _____53D6_5355_4F4DX = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取单位X"]
local _____53D6_5355_4F4DY = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取单位Y"]
local _____53D6_6700_5927_751F_547D = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取最大生命"]
local _____8BBE_7F6E_751F_547D = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["设置生命"]
local _____83B7_53D6_8303_56F4_654C_4EBA = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["获取范围敌人"]
local _____9020_6210_5F3A_5316_4F24_5BB3 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["造成强化伤害"]
local _____65BD_52A0_7729_6655 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["施加眩晕"]
local _____51FB_9000_8FDC_79BB_6765_6E90 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["击退远离来源"]
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.04．物品事件中心")
local onItemPickup = ____require_result_0.onItemPickup
local onItemDrop = ____require_result_0.onItemDrop
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_1.addPeriodicCallback
local getServerTime = ____require_result_1.getServerTime
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾")
local _____5F00_59CB_62A4_76FE = ____require_result_2["开始护盾"]
local _____62A4_76FE_7C7B_578B = ____require_result_2["护盾类型"]
local _____67E5_8BE2_5355_4F4D_6807_7B7E_62A4_76FE_503C = ____require_result_2["查询单位标签护盾值"]
local _____5145_80FD_5355_4F4D_6807_7B7E_62A4_76FE = ____require_result_2["充能单位标签护盾"]
local _____79FB_9664_5355_4F4D_6807_7B7E_62A4_76FE = ____require_result_2["移除单位标签护盾"]
local _____72F1_5996_9B54_76FE_914D_7F6E = _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["狱妖魔盾"]
local _____72F1_5996_9B54_76FE_7269_54C1ID = _____7269_54C1_4F7F_7528_88C5_5907ID["狱妖魔盾"]
local _____72F1_5996_9B54_76FE_62A4_76FE_6807_7B7E = "装备:狱妖魔盾"
local _____6301_6709_8005_5217_8868 = {}
local _____6301_6709_8005_8868 = {}
local _____51B7_5374_5230_671F_8868 = {}
local _____5DF2_521D_59CB_5316 = false
local _____5DF2_6CE8_518C_5145_80FD_8BA1_65F6_5668 = false
local function _____52A0_5165_6301_6709_8005(_____5355_4F4D)
    local id = _____53D6_53E5_67C4ID(_____5355_4F4D)
    if id == 0 or _____6301_6709_8005_8868[id] ~= nil then
        return
    end
    _____6301_6709_8005_8868[id] = _____5355_4F4D
    _____6301_6709_8005_5217_8868[#_____6301_6709_8005_5217_8868 + 1] = _____5355_4F4D
end
local function _____79FB_9664_6301_6709_8005(_____5355_4F4D)
    local id = _____53D6_53E5_67C4ID(_____5355_4F4D)
    if id == 0 then
        return
    end
    __TS__Delete(_____6301_6709_8005_8868, id)
    do
        local i = #_____6301_6709_8005_5217_8868 - 1
        while i >= 0 do
            if _____53D6_53E5_67C4ID(_____6301_6709_8005_5217_8868[i + 1]) == id then
                __TS__ArraySplice(_____6301_6709_8005_5217_8868, i, 1)
            end
            i = i - 1
        end
    end
    _____79FB_9664_5355_4F4D_6807_7B7E_62A4_76FE(_____5355_4F4D, _____72F1_5996_9B54_76FE_62A4_76FE_6807_7B7E)
end
local function ____on_62FE_53D6_72F1_5996_9B54_76FE(_____5355_4F4D, _____7269_54C1)
    if not _____662F_5426_4E3A_4F7F_7528_7269_54C1(_____7269_54C1, _____72F1_5996_9B54_76FE_7269_54C1ID) then
        return
    end
    _____52A0_5165_6301_6709_8005(_____5355_4F4D)
end
local function ____on_4E22_5F03_72F1_5996_9B54_76FE(_____5355_4F4D, _____7269_54C1)
    if not _____662F_5426_4E3A_4F7F_7528_7269_54C1(_____7269_54C1, _____72F1_5996_9B54_76FE_7269_54C1ID) then
        return
    end
    _____79FB_9664_6301_6709_8005(_____5355_4F4D)
end
local function _____5C1D_8BD5_5145_80FD_72F1_5996_9B54_76FE(_____5355_4F4D)
    local id = _____53D6_53E5_67C4ID(_____5355_4F4D)
    if id == 0 then
        return
    end
    local _____51B7_5374_5230_671F = _____51B7_5374_5230_671F_8868[id] or 0
    if _____51B7_5374_5230_671F > getServerTime() then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(_____5355_4F4D) or not _____5355_4F4D_6301_6709_7269_54C1(_____5355_4F4D, _____72F1_5996_9B54_76FE_7269_54C1ID) then
        _____79FB_9664_6301_6709_8005(_____5355_4F4D)
        return
    end
    local maxLife = _____53D6_6700_5927_751F_547D(_____5355_4F4D)
    local currentLife = _____53D6_5F53_524D_751F_547D(_____5355_4F4D)
    local maxShield = maxLife * _____72F1_5996_9B54_76FE_914D_7F6E["最大护盾比例"]
    local currentShield = _____67E5_8BE2_5355_4F4D_6807_7B7E_62A4_76FE_503C(_____5355_4F4D, _____72F1_5996_9B54_76FE_62A4_76FE_6807_7B7E)
    local amount = maxLife * _____72F1_5996_9B54_76FE_914D_7F6E["生命吸取比例"]
    local shieldRoom = maxShield - currentShield
    if amount > shieldRoom then
        amount = shieldRoom
    end
    local canPayLife = currentLife - 1
    if amount > canPayLife then
        amount = canPayLife
    end
    if not (amount > 0) then
        return
    end
    _____8BBE_7F6E_751F_547D(_____5355_4F4D, currentLife - amount)
    local added = _____5145_80FD_5355_4F4D_6807_7B7E_62A4_76FE(
        _____5355_4F4D,
        _____72F1_5996_9B54_76FE_62A4_76FE_6807_7B7E,
        amount,
        maxShield,
        {
            ["类型"] = _____62A4_76FE_7C7B_578B["通用"],
            ["数值"] = amount,
            ["持续时间"] = 0,
            ["来源单位"] = _____5355_4F4D,
            ["显示护盾条"] = true,
            ["可驱散"] = false
        }
    )
    if not (added > 0) and _____67E5_8BE2_5355_4F4D_6807_7B7E_62A4_76FE_503C(_____5355_4F4D, _____72F1_5996_9B54_76FE_62A4_76FE_6807_7B7E) <= 0 then
        _____5F00_59CB_62A4_76FE(_____5355_4F4D, {
            ["类型"] = _____62A4_76FE_7C7B_578B["通用"],
            ["数值"] = amount,
            ["持续时间"] = 0,
            ["来源单位"] = _____5355_4F4D,
            ["标签"] = _____72F1_5996_9B54_76FE_62A4_76FE_6807_7B7E
        })
    end
end
local function ____on_72F1_5996_9B54_76FE_5145_80FDTick()
    do
        local i = #_____6301_6709_8005_5217_8868 - 1
        while i >= 0 do
            _____5C1D_8BD5_5145_80FD_72F1_5996_9B54_76FE(_____6301_6709_8005_5217_8868[i + 1])
            i = i - 1
        end
    end
end
local function _____5F00_59CB_72F1_5996_9B54_76FE_51B7_5374(_____5355_4F4D)
    local id = _____53D6_53E5_67C4ID(_____5355_4F4D)
    if id == 0 then
        return
    end
    _____51B7_5374_5230_671F_8868[id] = getServerTime() + _____72F1_5996_9B54_76FE_914D_7F6E["冷却毫秒"]
end
____exports["初始化狱妖魔盾持有充能"] = function()
    if _____5DF2_521D_59CB_5316 then
        return
    end
    _____5DF2_521D_59CB_5316 = true
    onItemPickup(____on_62FE_53D6_72F1_5996_9B54_76FE)
    onItemDrop(____on_4E22_5F03_72F1_5996_9B54_76FE)
    if not _____5DF2_6CE8_518C_5145_80FD_8BA1_65F6_5668 then
        _____5DF2_6CE8_518C_5145_80FD_8BA1_65F6_5668 = true
        addPeriodicCallback(_____72F1_5996_9B54_76FE_914D_7F6E["充能间隔毫秒"], ____on_72F1_5996_9B54_76FE_5145_80FDTick)
    end
end
____exports["处理狱妖魔盾使用"] = function(_____4E0A_4E0B_6587)
    if not _____662F_5426_4E3A_4F7F_7528_7269_54C1(_____4E0A_4E0B_6587["物品"], _____72F1_5996_9B54_76FE_7269_54C1ID) then
        return
    end
    local _____5355_4F4D = _____4E0A_4E0B_6587["施法单位"]
    local id = _____53D6_53E5_67C4ID(_____5355_4F4D)
    if id == 0 then
        return
    end
    local _____51B7_5374_5230_671F = _____51B7_5374_5230_671F_8868[id] or 0
    if _____51B7_5374_5230_671F > getServerTime() then
        return
    end
    local shieldValue = _____67E5_8BE2_5355_4F4D_6807_7B7E_62A4_76FE_503C(_____5355_4F4D, _____72F1_5996_9B54_76FE_62A4_76FE_6807_7B7E)
    if not (shieldValue > 0) then
        return
    end
    local x = _____4E0A_4E0B_6587["目标X"] ~= 0 and _____4E0A_4E0B_6587["目标X"] or _____53D6_5355_4F4DX(_____5355_4F4D)
    local y = _____4E0A_4E0B_6587["目标Y"] ~= 0 and _____4E0A_4E0B_6587["目标Y"] or _____53D6_5355_4F4DY(_____5355_4F4D)
    local enemies = _____83B7_53D6_8303_56F4_654C_4EBA(_____5355_4F4D, x, y, _____72F1_5996_9B54_76FE_914D_7F6E["爆发半径"])
    for ____, enemy in ipairs(enemies) do
        _____9020_6210_5F3A_5316_4F24_5BB3(_____5355_4F4D, enemy, shieldValue * _____72F1_5996_9B54_76FE_914D_7F6E["爆发倍率"])
        _____65BD_52A0_7729_6655(_____5355_4F4D, enemy, _____72F1_5996_9B54_76FE_914D_7F6E["眩晕时间"])
        _____51FB_9000_8FDC_79BB_6765_6E90(_____5355_4F4D, enemy, 250, 0.5)
    end
    _____79FB_9664_5355_4F4D_6807_7B7E_62A4_76FE(_____5355_4F4D, _____72F1_5996_9B54_76FE_62A4_76FE_6807_7B7E)
    _____5F00_59CB_72F1_5996_9B54_76FE_51B7_5374(_____5355_4F4D)
end
return ____exports
