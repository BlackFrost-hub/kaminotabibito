--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_5171_4EAB = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.00．共享")
local DEFAULT_ATTACK_TYPE = ____00_FF0E_5171_4EAB.DEFAULT_ATTACK_TYPE
local DEFAULT_DAMAGE_TYPE = ____00_FF0E_5171_4EAB.DEFAULT_DAMAGE_TYPE
local DEFAULT_WEAPON_TYPE = ____00_FF0E_5171_4EAB.DEFAULT_WEAPON_TYPE
local jass = ____00_FF0E_5171_4EAB.jass
local BJ_DEGTORAD = ____00_FF0E_5171_4EAB.BJ_DEGTORAD
local _____4F4D_79FB_6620_5C04 = ____00_FF0E_5171_4EAB["位移映射"]
local _____547D_4E2D_8BB0_5F55 = ____00_FF0E_5171_4EAB["命中记录"]
local _____5355_4F4D_5B58_6D3B = ____00_FF0E_5171_4EAB["单位存活"]
local _____751F_6210_547D_4E2D_952E = ____00_FF0E_5171_4EAB["生成命中键"]
local _____64AD_653E_4F4D_79FB_7279_6548 = ____00_FF0E_5171_4EAB["播放位移特效"]
local _____83B7_53D6_679A_4E3E_7EC4 = ____00_FF0E_5171_4EAB["获取枚举组"]
local _____6E05_7A7A_679A_4E3E_7EC4 = ____00_FF0E_5171_4EAB["清空枚举组"]
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.11．地形步进")
local _____6CBF_89D2_5EA6_6B65_8FDB_76F4_5230_5730_5F62_963B_6321 = ____require_result_0["沿角度步进直到地形阻挡"]
local ____require_result_1 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6280_80FD_4F24_5BB3 = ____require_result_1["造成技能伤害"]
local _____6700_5C0F_51B2_950B_6B65_8FDB_8DDD_79BB = 30
local function _____7ED3_7B97_547D_4E2D_4F24_5BB3(_____5B9E_4F8B, _____76EE_6807_5355_4F4D)
    if _____5B9E_4F8B["命中伤害"] <= 0 then
        return
    end
    local ____temp_2
    if _____5B9E_4F8B["伤害来源"] ~= nil and _____5B9E_4F8B["伤害来源"] ~= 0 then
        ____temp_2 = _____5B9E_4F8B["伤害来源"]
    else
        ____temp_2 = _____5B9E_4F8B["单位"]
    end
    local _____6765_6E90_5355_4F4D = ____temp_2
    if not _____6765_6E90_5355_4F4D or _____6765_6E90_5355_4F4D == 0 then
        return
    end
    local _____6807_8BB0 = _____5B9E_4F8B["技能伤害标记"]
    local ____9020_6210_6280_80FD_4F24_5BB3_28 = _____9020_6210_6280_80FD_4F24_5BB3
    local ____76EE_6807_5355_4F4D_26 = _____76EE_6807_5355_4F4D
    local ____5B9E_4F8B__547D_4E2D_4F24_5BB3_27 = _____5B9E_4F8B["命中伤害"]
    local ____5B9E_4F8B__653B_51FB_7C7B_578B_3 = _____5B9E_4F8B["攻击类型"]
    if ____5B9E_4F8B__653B_51FB_7C7B_578B_3 == nil then
        ____5B9E_4F8B__653B_51FB_7C7B_578B_3 = DEFAULT_ATTACK_TYPE
    end
    local ____5B9E_4F8B__4F24_5BB3_7C7B_578B_4 = _____5B9E_4F8B["伤害类型"]
    if ____5B9E_4F8B__4F24_5BB3_7C7B_578B_4 == nil then
        ____5B9E_4F8B__4F24_5BB3_7C7B_578B_4 = DEFAULT_DAMAGE_TYPE
    end
    local ____5B9E_4F8B__6B66_5668_7C7B_578B_5 = _____5B9E_4F8B["武器类型"]
    if ____5B9E_4F8B__6B66_5668_7C7B_578B_5 == nil then
        ____5B9E_4F8B__6B66_5668_7C7B_578B_5 = DEFAULT_WEAPON_TYPE
    end
    ____9020_6210_6280_80FD_4F24_5BB3_28({
        ["来源"] = _____6765_6E90_5355_4F4D,
        ["目标"] = ____76EE_6807_5355_4F4D_26,
        ["伤害"] = ____5B9E_4F8B__547D_4E2D_4F24_5BB3_27,
        attackType = ____5B9E_4F8B__653B_51FB_7C7B_578B_3,
        ["伤害类型"] = ____5B9E_4F8B__4F24_5BB3_7C7B_578B_4,
        weaponType = ____5B9E_4F8B__6B66_5668_7C7B_578B_5,
        ["来源类型"] = _____6807_8BB0 and _____6807_8BB0["来源类型"] or _____6807_8BB0 and _____6807_8BB0["装备技能类型"] or "其他",
        ["装备技能类型"] = _____6807_8BB0 and _____6807_8BB0["装备技能类型"],
        ["伤害形态"] = _____6807_8BB0 and _____6807_8BB0["伤害形态"] or (_____5B9E_4F8B["命中后结束"] and "单体" or "AOE"),
        ["物品ID"] = _____6807_8BB0 and _____6807_8BB0["物品ID"],
        ["物品实例"] = _____6807_8BB0 and _____6807_8BB0["物品实例"],
        ["技能ID"] = _____6807_8BB0 and _____6807_8BB0["技能ID"],
        ["技能实例ID"] = _____6807_8BB0 and _____6807_8BB0["技能实例ID"],
        ["标签"] = _____6807_8BB0 and _____6807_8BB0["标签"],
        ["参与技能伤害加成"] = _____6807_8BB0 and _____6807_8BB0["参与技能伤害加成"]
    })
end
local function _____53EF_547D_4E2D_76EE_6807(_____5B9E_4F8B, _____76EE_6807_5355_4F4D)
    if not _____5355_4F4D_5B58_6D3B(_____76EE_6807_5355_4F4D) then
        return false
    end
    if not _____5B9E_4F8B["允许命中自己"] and _____76EE_6807_5355_4F4D == _____5B9E_4F8B["单位"] then
        return false
    end
    if not _____5B9E_4F8B["允许重复命中"] then
        local _____547D_4E2D_952E = _____751F_6210_547D_4E2D_952E(_____5B9E_4F8B.id, _____76EE_6807_5355_4F4D)
        if _____547D_4E2D_8BB0_5F55[_____547D_4E2D_952E] == true then
            return false
        end
    end
    if _____5B9E_4F8B["只命中敌人"] then
        local ____temp_29
        if _____5B9E_4F8B["伤害来源"] ~= nil and _____5B9E_4F8B["伤害来源"] ~= 0 then
            ____temp_29 = _____5B9E_4F8B["伤害来源"]
        else
            ____temp_29 = _____5B9E_4F8B["单位"]
        end
        local _____53C2_8003_5355_4F4D = ____temp_29
        local _____6240_5C5E_73A9_5BB6 = jass:GetOwningPlayer(_____53C2_8003_5355_4F4D)
        if not jass:IsUnitEnemy(_____76EE_6807_5355_4F4D, _____6240_5C5E_73A9_5BB6) then
            return false
        end
    end
    local _____547D_4E2D_8FC7_6EE4 = _____5B9E_4F8B["命中过滤"]
    if type(_____547D_4E2D_8FC7_6EE4) == "function" and not _____547D_4E2D_8FC7_6EE4(_____5B9E_4F8B["单位"], _____76EE_6807_5355_4F4D, _____5B9E_4F8B.id) then
        return false
    end
    return true
end
local function _____8BB0_5F55_547D_4E2D(_____5B9E_4F8B, _____76EE_6807_5355_4F4D)
    if _____5B9E_4F8B["允许重复命中"] then
        return
    end
    _____547D_4E2D_8BB0_5F55[_____751F_6210_547D_4E2D_952E(_____5B9E_4F8B.id, _____76EE_6807_5355_4F4D)] = true
end
local function _____68C0_67E5_547D_4E2D(_____5B9E_4F8B)
    if _____5B9E_4F8B["命中半径"] <= 0 then
        return nil
    end
    local _____679A_4E3E_7528_7EC4 = _____83B7_53D6_679A_4E3E_7EC4()
    jass:GroupEnumUnitsInRange(
        _____679A_4E3E_7528_7EC4,
        jass:GetUnitX(_____5B9E_4F8B["单位"]),
        jass:GetUnitY(_____5B9E_4F8B["单位"]),
        _____5B9E_4F8B["命中半径"],
        nil
    )
    while true do
        do
            local _____76EE_6807_5355_4F4D = jass:FirstOfGroup(_____679A_4E3E_7528_7EC4)
            if _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 then
                break
            end
            jass:GroupRemoveUnit(_____679A_4E3E_7528_7EC4, _____76EE_6807_5355_4F4D)
            if not _____53EF_547D_4E2D_76EE_6807(_____5B9E_4F8B, _____76EE_6807_5355_4F4D) then
                goto __continue17
            end
            _____8BB0_5F55_547D_4E2D(_____5B9E_4F8B, _____76EE_6807_5355_4F4D)
            _____7ED3_7B97_547D_4E2D_4F24_5BB3(_____5B9E_4F8B, _____76EE_6807_5355_4F4D)
            local _____547D_4E2D_56DE_8C03 = _____5B9E_4F8B["命中回调"]
            if type(_____547D_4E2D_56DE_8C03) == "function" then
                _____547D_4E2D_56DE_8C03(_____5B9E_4F8B["单位"], _____76EE_6807_5355_4F4D, _____5B9E_4F8B.id)
                if _____4F4D_79FB_6620_5C04[_____5B9E_4F8B.id] ~= _____5B9E_4F8B then
                    _____6E05_7A7A_679A_4E3E_7EC4()
                    return _____76EE_6807_5355_4F4D
                end
            end
            if _____5B9E_4F8B["命中后结束"] then
                _____6E05_7A7A_679A_4E3E_7EC4()
                return _____76EE_6807_5355_4F4D
            end
        end
        ::__continue17::
    end
    return nil
end
local function _____5C1D_8BD5_79FB_52A8_4E00_6B65(_____5B9E_4F8B, _____4F4D_79FB_8DDD_79BB)
    local _____5355_4F4D = _____5B9E_4F8B["单位"]
    local _____5F53_524DX = jass:GetUnitX(_____5355_4F4D)
    local _____5F53_524DY = jass:GetUnitY(_____5355_4F4D)
    local _____5F27_5EA6 = _____5B9E_4F8B["角度"] * BJ_DEGTORAD
    local _____65B0X = _____5F53_524DX + _____4F4D_79FB_8DDD_79BB * jass:Cos(_____5F27_5EA6)
    local _____65B0Y = _____5F53_524DY + _____4F4D_79FB_8DDD_79BB * jass:Sin(_____5F27_5EA6)
    if _____5B9E_4F8B["检查地形"] then
        local _____6B65_8FDB_7ED3_679C = _____6CBF_89D2_5EA6_6B65_8FDB_76F4_5230_5730_5F62_963B_6321({
            ["起点X"] = _____5F53_524DX,
            ["起点Y"] = _____5F53_524DY,
            ["角度度"] = _____5B9E_4F8B["角度"],
            ["单步距离"] = _____4F4D_79FB_8DDD_79BB,
            ["步数"] = 1,
            ["检测单位"] = _____5355_4F4D
        })
        if _____6B65_8FDB_7ED3_679C["实际步数"] <= 0 then
            local _____649E_5899_56DE_8C03 = _____5B9E_4F8B["撞墙回调"]
            if type(_____649E_5899_56DE_8C03) == "function" then
                _____649E_5899_56DE_8C03(_____5355_4F4D, _____5B9E_4F8B.id)
                if _____4F4D_79FB_6620_5C04[_____5B9E_4F8B.id] ~= _____5B9E_4F8B then
                    return {["停止"] = true, ["原因"] = "中断"}
                end
            end
            return {["停止"] = true, ["原因"] = "撞墙"}
        end
        _____65B0X = _____6B65_8FDB_7ED3_679C["最终X"]
        _____65B0Y = _____6B65_8FDB_7ED3_679C["最终Y"]
    end
    if _____5B9E_4F8B["朝向跟随位移"] then
        jass:SetUnitFacing(_____5355_4F4D, _____5B9E_4F8B["角度"])
    end
    jass:SetUnitX(_____5355_4F4D, _____65B0X)
    jass:SetUnitY(_____5355_4F4D, _____65B0Y)
    _____5B9E_4F8B["已移动"] = _____5B9E_4F8B["已移动"] + _____4F4D_79FB_8DDD_79BB
    local _____547D_4E2D_76EE_6807 = _____68C0_67E5_547D_4E2D(_____5B9E_4F8B)
    if _____547D_4E2D_76EE_6807 ~= nil and _____547D_4E2D_76EE_6807 ~= 0 then
        return {["停止"] = true, ["原因"] = "命中", ["命中目标"] = _____547D_4E2D_76EE_6807}
    end
    if _____5B9E_4F8B["已移动"] >= _____5B9E_4F8B["总距离"] then
        return {["停止"] = true, ["原因"] = "完成"}
    end
    return {["停止"] = false}
end
____exports["推进一步"] = function(_____5B9E_4F8B)
    local _____8D77_59CB_5DF2_79FB_52A8 = _____5B9E_4F8B["已移动"]
    local _____5269_4F59_8DDD_79BB = _____5B9E_4F8B["总距离"] - _____5B9E_4F8B["已移动"]
    if _____5269_4F59_8DDD_79BB <= 0 then
        return {["停止"] = true, ["原因"] = "完成"}
    end
    local _____672CTick_4F4D_79FB = _____5B9E_4F8B["每Tick位移"]
    if _____672CTick_4F4D_79FB > _____5269_4F59_8DDD_79BB then
        _____672CTick_4F4D_79FB = _____5269_4F59_8DDD_79BB
    end
    if _____672CTick_4F4D_79FB < _____6700_5C0F_51B2_950B_6B65_8FDB_8DDD_79BB and _____5269_4F59_8DDD_79BB > _____6700_5C0F_51B2_950B_6B65_8FDB_8DDD_79BB then
        _____672CTick_4F4D_79FB = _____6700_5C0F_51B2_950B_6B65_8FDB_8DDD_79BB
    end
    if _____672CTick_4F4D_79FB <= 0 then
        return {["停止"] = true, ["原因"] = "完成"}
    end
    local _____7ED3_679C = _____5C1D_8BD5_79FB_52A8_4E00_6B65(_____5B9E_4F8B, _____672CTick_4F4D_79FB)
    if _____7ED3_679C["停止"] then
        if _____5B9E_4F8B["已移动"] > _____8D77_59CB_5DF2_79FB_52A8 then
            _____64AD_653E_4F4D_79FB_7279_6548(_____5B9E_4F8B)
        end
        return _____7ED3_679C
    end
    if _____4F4D_79FB_6620_5C04[_____5B9E_4F8B.id] ~= _____5B9E_4F8B then
        return {["停止"] = true, ["原因"] = "中断"}
    end
    if _____5B9E_4F8B["已移动"] > _____8D77_59CB_5DF2_79FB_52A8 then
        _____64AD_653E_4F4D_79FB_7279_6548(_____5B9E_4F8B)
    end
    return {["停止"] = false}
end
return ____exports
