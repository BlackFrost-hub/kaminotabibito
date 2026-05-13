--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_5171_4EAB = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.00．共享")
local DEFAULT_ATTACK_TYPE = ____00_FF0E_5171_4EAB.DEFAULT_ATTACK_TYPE
local DEFAULT_DAMAGE_TYPE = ____00_FF0E_5171_4EAB.DEFAULT_DAMAGE_TYPE
local DEFAULT_WEAPON_TYPE = ____00_FF0E_5171_4EAB.DEFAULT_WEAPON_TYPE
local X_GetAbleX = ____00_FF0E_5171_4EAB.X_GetAbleX
local X_GetAbleY = ____00_FF0E_5171_4EAB.X_GetAbleY
local X_IsTerrainWalkable = ____00_FF0E_5171_4EAB.X_IsTerrainWalkable
local jass = ____00_FF0E_5171_4EAB.jass
local BJ_DEGTORAD = ____00_FF0E_5171_4EAB.BJ_DEGTORAD
local MAX_SUB_STEP = ____00_FF0E_5171_4EAB.MAX_SUB_STEP
local WALKABLE_TOLERANCE = ____00_FF0E_5171_4EAB.WALKABLE_TOLERANCE
local _____4F4D_79FB_6620_5C04 = ____00_FF0E_5171_4EAB["位移映射"]
local _____547D_4E2D_8BB0_5F55 = ____00_FF0E_5171_4EAB["命中记录"]
local _____5355_4F4D_5B58_6D3B = ____00_FF0E_5171_4EAB["单位存活"]
local _____5728_53EF_73A9_533A_57DF_5185 = ____00_FF0E_5171_4EAB["在可玩区域内"]
local _____8BA1_7B97_5750_6807_8DDD_79BB = ____00_FF0E_5171_4EAB["计算坐标距离"]
local _____751F_6210_547D_4E2D_952E = ____00_FF0E_5171_4EAB["生成命中键"]
local _____64AD_653E_4F4D_79FB_7279_6548 = ____00_FF0E_5171_4EAB["播放位移特效"]
local _____83B7_53D6_679A_4E3E_7EC4 = ____00_FF0E_5171_4EAB["获取枚举组"]
local _____6E05_7A7A_679A_4E3E_7EC4 = ____00_FF0E_5171_4EAB["清空枚举组"]
local function _____7ED3_7B97_547D_4E2D_4F24_5BB3(_____5B9E_4F8B, _____76EE_6807_5355_4F4D)
    if _____5B9E_4F8B["命中伤害"] <= 0 then
        return
    end
    local ____temp_0
    if _____5B9E_4F8B["伤害来源"] ~= nil and _____5B9E_4F8B["伤害来源"] ~= 0 then
        ____temp_0 = _____5B9E_4F8B["伤害来源"]
    else
        ____temp_0 = _____5B9E_4F8B["单位"]
    end
    local _____6765_6E90_5355_4F4D = ____temp_0
    if not _____6765_6E90_5355_4F4D or _____6765_6E90_5355_4F4D == 0 then
        return
    end
    local ____jass_6 = jass
    local ____jass_UnitDamageTarget_7 = jass.UnitDamageTarget
    local ____76EE_6807_5355_4F4D_4 = _____76EE_6807_5355_4F4D
    local ____5B9E_4F8B__547D_4E2D_4F24_5BB3_5 = _____5B9E_4F8B["命中伤害"]
    local ____5B9E_4F8B__653B_51FB_7C7B_578B_1 = _____5B9E_4F8B["攻击类型"]
    if ____5B9E_4F8B__653B_51FB_7C7B_578B_1 == nil then
        ____5B9E_4F8B__653B_51FB_7C7B_578B_1 = DEFAULT_ATTACK_TYPE
    end
    local ____5B9E_4F8B__4F24_5BB3_7C7B_578B_2 = _____5B9E_4F8B["伤害类型"]
    if ____5B9E_4F8B__4F24_5BB3_7C7B_578B_2 == nil then
        ____5B9E_4F8B__4F24_5BB3_7C7B_578B_2 = DEFAULT_DAMAGE_TYPE
    end
    local ____5B9E_4F8B__6B66_5668_7C7B_578B_3 = _____5B9E_4F8B["武器类型"]
    if ____5B9E_4F8B__6B66_5668_7C7B_578B_3 == nil then
        ____5B9E_4F8B__6B66_5668_7C7B_578B_3 = DEFAULT_WEAPON_TYPE
    end
    ____jass_UnitDamageTarget_7(
        ____jass_6,
        _____6765_6E90_5355_4F4D,
        ____76EE_6807_5355_4F4D_4,
        ____5B9E_4F8B__547D_4E2D_4F24_5BB3_5,
        false,
        false,
        ____5B9E_4F8B__653B_51FB_7C7B_578B_1,
        ____5B9E_4F8B__4F24_5BB3_7C7B_578B_2,
        ____5B9E_4F8B__6B66_5668_7C7B_578B_3
    )
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
        local ____temp_8
        if _____5B9E_4F8B["伤害来源"] ~= nil and _____5B9E_4F8B["伤害来源"] ~= 0 then
            ____temp_8 = _____5B9E_4F8B["伤害来源"]
        else
            ____temp_8 = _____5B9E_4F8B["单位"]
        end
        local _____53C2_8003_5355_4F4D = ____temp_8
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
        if not _____5728_53EF_73A9_533A_57DF_5185(_____65B0X, _____65B0Y) then
            local _____649E_5899_56DE_8C03 = _____5B9E_4F8B["撞墙回调"]
            if type(_____649E_5899_56DE_8C03) == "function" then
                _____649E_5899_56DE_8C03(_____5355_4F4D, _____5B9E_4F8B.id)
                if _____4F4D_79FB_6620_5C04[_____5B9E_4F8B.id] ~= _____5B9E_4F8B then
                    return {["停止"] = true, ["原因"] = "中断"}
                end
            end
            return {["停止"] = true, ["原因"] = "撞墙"}
        end
        if not X_IsTerrainWalkable(nil, _____65B0X, _____65B0Y) then
            local _____53EF_901A_884CX = X_GetAbleX(nil)
            local _____53EF_901A_884CY = X_GetAbleY(nil)
            local ableDist = _____8BA1_7B97_5750_6807_8DDD_79BB(_____65B0X, _____65B0Y, _____53EF_901A_884CX, _____53EF_901A_884CY)
            if ableDist > WALKABLE_TOLERANCE then
                local _____649E_5899_56DE_8C03 = _____5B9E_4F8B["撞墙回调"]
                if type(_____649E_5899_56DE_8C03) == "function" then
                    _____649E_5899_56DE_8C03(_____5355_4F4D, _____5B9E_4F8B.id)
                    if _____4F4D_79FB_6620_5C04[_____5B9E_4F8B.id] ~= _____5B9E_4F8B then
                        return {["停止"] = true, ["原因"] = "中断"}
                    end
                end
                return {["停止"] = true, ["原因"] = "撞墙"}
            end
        end
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
    if _____672CTick_4F4D_79FB <= 0 then
        return {["停止"] = true, ["原因"] = "完成"}
    end
    local _____5269_4F59_6B65_957F = _____672CTick_4F4D_79FB
    while _____5269_4F59_6B65_957F > 0 do
        local _____5B50_6B65_957F = _____5269_4F59_6B65_957F > MAX_SUB_STEP and MAX_SUB_STEP or _____5269_4F59_6B65_957F
        local _____7ED3_679C = _____5C1D_8BD5_79FB_52A8_4E00_6B65(_____5B9E_4F8B, _____5B50_6B65_957F)
        if _____7ED3_679C["停止"] then
            if _____5B9E_4F8B["已移动"] > _____8D77_59CB_5DF2_79FB_52A8 then
                _____64AD_653E_4F4D_79FB_7279_6548(_____5B9E_4F8B)
            end
            return _____7ED3_679C
        end
        if _____4F4D_79FB_6620_5C04[_____5B9E_4F8B.id] ~= _____5B9E_4F8B then
            return {["停止"] = true, ["原因"] = "中断"}
        end
        _____5269_4F59_6B65_957F = _____5269_4F59_6B65_957F - _____5B50_6B65_957F
    end
    if _____5B9E_4F8B["已移动"] > _____8D77_59CB_5DF2_79FB_52A8 then
        _____64AD_653E_4F4D_79FB_7279_6548(_____5B9E_4F8B)
    end
    return {["停止"] = false}
end
return ____exports
