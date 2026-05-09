local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local _____53D6_53E5_67C4ID, _____5355_4F4D_5B58_6D3B, _____5728_53EF_73A9_533A_57DF_5185, _____8BA1_7B97_5750_6807_8DDD_79BB, _____6E05_7406_547D_4E2D_8BB0_5F55, _____751F_6210_547D_4E2D_952E, _____8BBE_7F6E_5355_4F4D_6682_505C_72B6_6001, _____5355_4F4D_5DF2_88AB_6682_505C, _____64AD_653E_4F4D_79FB_7279_6548, _____4ECE_4E2D_5FC3_8BA1_65F6_5668_6CE8_9500, _____5C1D_8BD5_6536_5C3E_4E2D_5FC3_8BA1_65F6_5668, _____5185_90E8_79FB_9664_4F4D_79FB, _____7ED3_675F_4F4D_79FB_5B9E_4F8B, _____7ED3_675F_4F4D_79FBID, _____7ED3_7B97_547D_4E2D_4F24_5BB3, _____53EF_547D_4E2D_76EE_6807, _____8BB0_5F55_547D_4E2D, _____83B7_53D6_679A_4E3E_7EC4, _____6E05_7A7A_679A_4E3E_7EC4, _____68C0_67E5_547D_4E2D, _____5C1D_8BD5_79FB_52A8_4E00_6B65, _____63A8_8FDB_4E00_6B65, ____on_51B2_950B_51FB_9000_7CFB_7EDFTick, jass, jglobals, japi, X_IsTerrainWalkable, X_GetAbleX, X_GetAbleY, offTick10ms, BJ_DEGTORAD, CENTER_TIMER_TICKS, MAX_SUB_STEP, WALKABLE_TOLERANCE, UNIT_ALIVE_LIFE, DEFAULT_ATTACK_TYPE, DEFAULT_DAMAGE_TYPE, DEFAULT_WEAPON_TYPE, _____6D3B_52A8_4F4D_79FB_5217_8868, _____4F4D_79FB_6620_5C04, _____5355_4F4D_5F53_524D_4F4D_79FB, _____547D_4E2D_8BB0_5F55, _____679A_4E3E_7EC4, _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668, ____tick_8BA1_6570
function _____53D6_53E5_67C4ID(h)
    return h ~= nil and h ~= 0 and jass.GetHandleId(h) or 0 or 0
end
function _____5355_4F4D_5B58_6D3B(u)
    return u ~= nil and u ~= 0 and jass.GetUnitState(u, jass.UNIT_STATE_LIFE) > UNIT_ALIVE_LIFE
end
function _____5728_53EF_73A9_533A_57DF_5185(x, y)
    return x >= jass.GetRectMinX(jglobals.bj_mapInitialPlayableArea) and y >= jass.GetRectMinY(jglobals.bj_mapInitialPlayableArea) and x <= jass.GetRectMaxX(jglobals.bj_mapInitialPlayableArea) and y <= jass.GetRectMaxY(jglobals.bj_mapInitialPlayableArea)
end
function _____8BA1_7B97_5750_6807_8DDD_79BB(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return jass.SquareRoot(dx * dx + dy * dy)
end
function _____6E05_7406_547D_4E2D_8BB0_5F55(_____4F4D_79FBID)
    local _____524D_7F00 = tostring(_____4F4D_79FBID) .. ":"
    for key in pairs(_____547D_4E2D_8BB0_5F55) do
        if (string.find(key, _____524D_7F00, nil, true) or 0) - 1 == 0 then
            __TS__Delete(_____547D_4E2D_8BB0_5F55, key)
        end
    end
end
function _____751F_6210_547D_4E2D_952E(_____4F4D_79FBID, _____76EE_6807_5355_4F4D)
    return (tostring(_____4F4D_79FBID) .. ":") .. tostring(_____53D6_53E5_67C4ID(_____76EE_6807_5355_4F4D))
end
function _____8BBE_7F6E_5355_4F4D_6682_505C_72B6_6001(_____5355_4F4D, _____662F_5426_6682_505C)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return
    end
    if japi ~= nil and type(japi.EXPauseUnit) == "function" then
        japi.EXPauseUnit(_____5355_4F4D, _____662F_5426_6682_505C)
        return
    end
    jass.PauseUnit(_____5355_4F4D, _____662F_5426_6682_505C)
end
function _____5355_4F4D_5DF2_88AB_6682_505C(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return false
    end
    return jass.IsUnitPaused(_____5355_4F4D) == true
end
function _____64AD_653E_4F4D_79FB_7279_6548(_____5B9E_4F8B)
    local _____6A21_578B = _____5B9E_4F8B["位移特效"]
    if _____6A21_578B == nil or _____6A21_578B == "" then
        return
    end
    local _____7279_6548 = jass.AddSpecialEffect(
        _____6A21_578B,
        jass.GetUnitX(_____5B9E_4F8B["单位"]),
        jass.GetUnitY(_____5B9E_4F8B["单位"])
    )
    if _____7279_6548 ~= nil and _____7279_6548 ~= 0 then
        jass.DestroyEffect(_____7279_6548)
    end
end
function _____4ECE_4E2D_5FC3_8BA1_65F6_5668_6CE8_9500()
    if not _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 then
        return
    end
    _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 = false
    offTick10ms(____on_51B2_950B_51FB_9000_7CFB_7EDFTick)
end
function _____5C1D_8BD5_6536_5C3E_4E2D_5FC3_8BA1_65F6_5668()
    if #_____6D3B_52A8_4F4D_79FB_5217_8868 ~= 0 then
        return
    end
    ____tick_8BA1_6570 = 0
    _____4ECE_4E2D_5FC3_8BA1_65F6_5668_6CE8_9500()
end
function _____5185_90E8_79FB_9664_4F4D_79FB(_____5B9E_4F8B)
    local _____4F4D_79FBID = _____5B9E_4F8B.id
    local _____5355_4F4DID = _____5B9E_4F8B["单位ID"]
    __TS__Delete(_____4F4D_79FB_6620_5C04, _____4F4D_79FBID)
    if _____5355_4F4D_5F53_524D_4F4D_79FB[_____5355_4F4DID] == _____4F4D_79FBID then
        __TS__Delete(_____5355_4F4D_5F53_524D_4F4D_79FB, _____5355_4F4DID)
    end
    _____6E05_7406_547D_4E2D_8BB0_5F55(_____4F4D_79FBID)
    local idx = _____5B9E_4F8B.listIndex
    local lastIdx = #_____6D3B_52A8_4F4D_79FB_5217_8868 - 1
    if idx ~= lastIdx then
        local last = _____6D3B_52A8_4F4D_79FB_5217_8868[lastIdx + 1]
        _____6D3B_52A8_4F4D_79FB_5217_8868[idx + 1] = last
        last.listIndex = idx
    end
    table.remove(_____6D3B_52A8_4F4D_79FB_5217_8868)
    _____5C1D_8BD5_6536_5C3E_4E2D_5FC3_8BA1_65F6_5668()
end
function _____7ED3_675F_4F4D_79FB_5B9E_4F8B(_____5B9E_4F8B, _____539F_56E0, _____547D_4E2D_76EE_6807)
    if _____4F4D_79FB_6620_5C04[_____5B9E_4F8B.id] ~= _____5B9E_4F8B then
        return
    end
    local _____5355_4F4D = _____5B9E_4F8B["单位"]
    local _____4F4D_79FBID = _____5B9E_4F8B.id
    local _____7ED3_675F_56DE_8C03 = _____5B9E_4F8B["结束回调"]
    if _____5B9E_4F8B["禁用碰撞"] then
        jass.SetUnitPathing(_____5355_4F4D, true)
    end
    if _____5B9E_4F8B["暂停单位"] then
        _____8BBE_7F6E_5355_4F4D_6682_505C_72B6_6001(_____5355_4F4D, false)
    end
    _____5185_90E8_79FB_9664_4F4D_79FB(_____5B9E_4F8B)
    if type(_____7ED3_675F_56DE_8C03) == "function" then
        _____7ED3_675F_56DE_8C03(_____5355_4F4D, _____539F_56E0, _____4F4D_79FBID, _____547D_4E2D_76EE_6807)
    end
end
function _____7ED3_675F_4F4D_79FBID(_____4F4D_79FBID, _____539F_56E0, _____547D_4E2D_76EE_6807)
    local _____5B9E_4F8B = _____4F4D_79FB_6620_5C04[_____4F4D_79FBID]
    if not _____5B9E_4F8B then
        return false
    end
    _____7ED3_675F_4F4D_79FB_5B9E_4F8B(_____5B9E_4F8B, _____539F_56E0, _____547D_4E2D_76EE_6807)
    return true
end
function _____7ED3_7B97_547D_4E2D_4F24_5BB3(_____5B9E_4F8B, _____76EE_6807_5355_4F4D)
    if _____5B9E_4F8B["命中伤害"] <= 0 then
        return
    end
    local ____temp_3
    if _____5B9E_4F8B["伤害来源"] ~= nil and _____5B9E_4F8B["伤害来源"] ~= 0 then
        ____temp_3 = _____5B9E_4F8B["伤害来源"]
    else
        ____temp_3 = _____5B9E_4F8B["单位"]
    end
    local _____6765_6E90_5355_4F4D = ____temp_3
    if not _____6765_6E90_5355_4F4D or _____6765_6E90_5355_4F4D == 0 then
        return
    end
    local ____jass_UnitDamageTarget_9 = jass.UnitDamageTarget
    local ____76EE_6807_5355_4F4D_7 = _____76EE_6807_5355_4F4D
    local ____5B9E_4F8B__547D_4E2D_4F24_5BB3_8 = _____5B9E_4F8B["命中伤害"]
    local ____5B9E_4F8B__653B_51FB_7C7B_578B_4 = _____5B9E_4F8B["攻击类型"]
    if ____5B9E_4F8B__653B_51FB_7C7B_578B_4 == nil then
        ____5B9E_4F8B__653B_51FB_7C7B_578B_4 = DEFAULT_ATTACK_TYPE
    end
    local ____5B9E_4F8B__4F24_5BB3_7C7B_578B_5 = _____5B9E_4F8B["伤害类型"]
    if ____5B9E_4F8B__4F24_5BB3_7C7B_578B_5 == nil then
        ____5B9E_4F8B__4F24_5BB3_7C7B_578B_5 = DEFAULT_DAMAGE_TYPE
    end
    local ____5B9E_4F8B__6B66_5668_7C7B_578B_6 = _____5B9E_4F8B["武器类型"]
    if ____5B9E_4F8B__6B66_5668_7C7B_578B_6 == nil then
        ____5B9E_4F8B__6B66_5668_7C7B_578B_6 = DEFAULT_WEAPON_TYPE
    end
    ____jass_UnitDamageTarget_9(
        jass,
        _____6765_6E90_5355_4F4D,
        ____76EE_6807_5355_4F4D_7,
        ____5B9E_4F8B__547D_4E2D_4F24_5BB3_8,
        false,
        false,
        ____5B9E_4F8B__653B_51FB_7C7B_578B_4,
        ____5B9E_4F8B__4F24_5BB3_7C7B_578B_5,
        ____5B9E_4F8B__6B66_5668_7C7B_578B_6
    )
end
function _____53EF_547D_4E2D_76EE_6807(_____5B9E_4F8B, _____76EE_6807_5355_4F4D)
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
        local ____temp_10
        if _____5B9E_4F8B["伤害来源"] ~= nil and _____5B9E_4F8B["伤害来源"] ~= 0 then
            ____temp_10 = _____5B9E_4F8B["伤害来源"]
        else
            ____temp_10 = _____5B9E_4F8B["单位"]
        end
        local _____53C2_8003_5355_4F4D = ____temp_10
        local _____6240_5C5E_73A9_5BB6 = jass.GetOwningPlayer(_____53C2_8003_5355_4F4D)
        if not jass.IsUnitEnemy(_____76EE_6807_5355_4F4D, _____6240_5C5E_73A9_5BB6) then
            return false
        end
    end
    local _____547D_4E2D_8FC7_6EE4 = _____5B9E_4F8B["命中过滤"]
    if type(_____547D_4E2D_8FC7_6EE4) == "function" and not _____547D_4E2D_8FC7_6EE4(_____5B9E_4F8B["单位"], _____76EE_6807_5355_4F4D, _____5B9E_4F8B.id) then
        return false
    end
    return true
end
function _____8BB0_5F55_547D_4E2D(_____5B9E_4F8B, _____76EE_6807_5355_4F4D)
    if _____5B9E_4F8B["允许重复命中"] then
        return
    end
    _____547D_4E2D_8BB0_5F55[_____751F_6210_547D_4E2D_952E(_____5B9E_4F8B.id, _____76EE_6807_5355_4F4D)] = true
end
function _____83B7_53D6_679A_4E3E_7EC4()
    if _____679A_4E3E_7EC4 == nil or _____679A_4E3E_7EC4 == 0 then
        _____679A_4E3E_7EC4 = jass.CreateGroup()
    end
    return _____679A_4E3E_7EC4
end
function _____6E05_7A7A_679A_4E3E_7EC4()
    local g = _____83B7_53D6_679A_4E3E_7EC4()
    while true do
        local u = jass.FirstOfGroup(g)
        if u == nil or u == 0 then
            break
        end
        jass.GroupRemoveUnit(g, u)
    end
end
function _____68C0_67E5_547D_4E2D(_____5B9E_4F8B)
    if _____5B9E_4F8B["命中半径"] <= 0 then
        return nil
    end
    local _____679A_4E3E_7528_7EC4 = _____83B7_53D6_679A_4E3E_7EC4()
    jass.GroupEnumUnitsInRange(
        _____679A_4E3E_7528_7EC4,
        jass.GetUnitX(_____5B9E_4F8B["单位"]),
        jass.GetUnitY(_____5B9E_4F8B["单位"]),
        _____5B9E_4F8B["命中半径"],
        nil
    )
    while true do
        do
            local _____76EE_6807_5355_4F4D = jass.FirstOfGroup(_____679A_4E3E_7528_7EC4)
            if _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 then
                break
            end
            jass.GroupRemoveUnit(_____679A_4E3E_7528_7EC4, _____76EE_6807_5355_4F4D)
            if not _____53EF_547D_4E2D_76EE_6807(_____5B9E_4F8B, _____76EE_6807_5355_4F4D) then
                goto __continue66
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
        ::__continue66::
    end
    return nil
end
function _____5C1D_8BD5_79FB_52A8_4E00_6B65(_____5B9E_4F8B, _____4F4D_79FB_8DDD_79BB)
    local _____5355_4F4D = _____5B9E_4F8B["单位"]
    local _____5F53_524DX = jass.GetUnitX(_____5355_4F4D)
    local _____5F53_524DY = jass.GetUnitY(_____5355_4F4D)
    local _____5F27_5EA6 = _____5B9E_4F8B["角度"] * BJ_DEGTORAD
    local _____65B0X = _____5F53_524DX + _____4F4D_79FB_8DDD_79BB * jass.Cos(_____5F27_5EA6)
    local _____65B0Y = _____5F53_524DY + _____4F4D_79FB_8DDD_79BB * jass.Sin(_____5F27_5EA6)
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
        jass.SetUnitFacing(_____5355_4F4D, _____5B9E_4F8B["角度"])
    end
    jass.SetUnitX(_____5355_4F4D, _____65B0X)
    jass.SetUnitY(_____5355_4F4D, _____65B0Y)
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
function _____63A8_8FDB_4E00_6B65(_____5B9E_4F8B)
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
function ____on_51B2_950B_51FB_9000_7CFB_7EDFTick()
    ____tick_8BA1_6570 = ____tick_8BA1_6570 + 1
    if ____tick_8BA1_6570 < CENTER_TIMER_TICKS then
        return
    end
    ____tick_8BA1_6570 = 0
    local i = 0
    while i < #_____6D3B_52A8_4F4D_79FB_5217_8868 do
        do
            local _____5B9E_4F8B = _____6D3B_52A8_4F4D_79FB_5217_8868[i + 1]
            if _____4F4D_79FB_6620_5C04[_____5B9E_4F8B.id] ~= _____5B9E_4F8B then
                i = i + 1
                goto __continue95
            end
            if not _____5355_4F4D_5B58_6D3B(_____5B9E_4F8B["单位"]) then
                _____7ED3_675F_4F4D_79FB_5B9E_4F8B(_____5B9E_4F8B, "死亡")
                goto __continue95
            end
            if _____5B9E_4F8B["主单位死亡时中断"] and _____5B9E_4F8B["主单位"] ~= nil and _____5B9E_4F8B["主单位"] ~= 0 and not _____5355_4F4D_5B58_6D3B(_____5B9E_4F8B["主单位"]) then
                _____7ED3_675F_4F4D_79FB_5B9E_4F8B(_____5B9E_4F8B, "主单位死亡")
                goto __continue95
            end
            if not _____5B9E_4F8B["暂停单位"] and _____5355_4F4D_5DF2_88AB_6682_505C(_____5B9E_4F8B["单位"]) then
                _____7ED3_675F_4F4D_79FB_5B9E_4F8B(_____5B9E_4F8B, "中断")
                goto __continue95
            end
            local _____7ED3_679C = _____63A8_8FDB_4E00_6B65(_____5B9E_4F8B)
            if _____7ED3_679C["停止"] then
                _____7ED3_675F_4F4D_79FB_5B9E_4F8B(_____5B9E_4F8B, _____7ED3_679C["原因"] or "完成", _____7ED3_679C["命中目标"])
                goto __continue95
            end
            i = i + 1
        end
        ::__continue95::
    end
end
____exports["停止单位位移"] = function(_____5355_4F4D, _____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "中断"
    end
    local _____4F4D_79FBID = _____5355_4F4D_5F53_524D_4F4D_79FB[_____53D6_53E5_67C4ID(_____5355_4F4D)]
    if not _____4F4D_79FBID then
        return false
    end
    return _____7ED3_675F_4F4D_79FBID(_____4F4D_79FBID, _____539F_56E0)
end
jass = require("jass.common")
jglobals = require("jass.globals")
japi = nil
do
    local function ____catch(_e)
        japi = nil
    end
    local ____try, ____hasReturned = pcall(function()
        japi = require("jass.japi")
    end)
    if not ____try then
        ____catch(____hasReturned)
    end
end
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.06．X库函数")
local X_GAFC = ____require_result_0.X_GAFC
X_IsTerrainWalkable = ____require_result_0.X_IsTerrainWalkable
X_GetAbleX = ____require_result_0.X_GetAbleX
X_GetAbleY = ____require_result_0.X_GetAbleY
local ____G_1 = _G
local onTick10ms = ____G_1.onTick10ms
offTick10ms = ____G_1.offTick10ms
local ForGroup = jass.ForGroup
local GetEnumUnit = jass.GetEnumUnit
local ____jglobals_bj_DEGTORAD_2 = jglobals.bj_DEGTORAD
if ____jglobals_bj_DEGTORAD_2 == nil then
    ____jglobals_bj_DEGTORAD_2 = 0.017453292519943295
end
BJ_DEGTORAD = ____jglobals_bj_DEGTORAD_2
local TICK_INTERVAL = 0.02
CENTER_TIMER_TICKS = 2
MAX_SUB_STEP = 31
WALKABLE_TOLERANCE = 8
UNIT_ALIVE_LIFE = 0.405
local DEFAULT_MOVE_EFFECT_MODEL = "Abilities\\Spells\\Human\\FlakCannons\\FlakTarget.mdl"
DEFAULT_ATTACK_TYPE = jass.ATTACK_TYPE_NORMAL
DEFAULT_DAMAGE_TYPE = jass.DAMAGE_TYPE_NORMAL
DEFAULT_WEAPON_TYPE = jass.WEAPON_TYPE_WHOKNOWS
_____6D3B_52A8_4F4D_79FB_5217_8868 = {}
_____4F4D_79FB_6620_5C04 = {}
_____5355_4F4D_5F53_524D_4F4D_79FB = {}
_____547D_4E2D_8BB0_5F55 = {}
_____679A_4E3E_7EC4 = nil
local _____5355_4F4D_7EC4_5FEB_7167_7F13_5B58 = {}
local _____4E0B_4E00_4E2A_4F4D_79FBID = 0
_____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 = false
____tick_8BA1_6570 = 0
local function _____6536_96C6_5355_4F4D_7EC4_6210_5458()
    local _____5355_4F4D = GetEnumUnit()
    if _____5355_4F4D ~= nil and _____5355_4F4D ~= 0 then
        _____5355_4F4D_7EC4_5FEB_7167_7F13_5B58[#_____5355_4F4D_7EC4_5FEB_7167_7F13_5B58 + 1] = _____5355_4F4D
    end
end
local function _____5FEB_7167_5355_4F4D_7EC4(_____5355_4F4D_7EC4)
    if _____5355_4F4D_7EC4 == nil or _____5355_4F4D_7EC4 == 0 then
        return {}
    end
    _____5355_4F4D_7EC4_5FEB_7167_7F13_5B58 = {}
    ForGroup(_____5355_4F4D_7EC4, _____6536_96C6_5355_4F4D_7EC4_6210_5458)
    local _____7ED3_679C = _____5355_4F4D_7EC4_5FEB_7167_7F13_5B58
    _____5355_4F4D_7EC4_5FEB_7167_7F13_5B58 = {}
    return _____7ED3_679C
end
local function _____8BA1_7B97_6BCFTick_4F4D_79FB(_____8DDD_79BB, _____6301_7EED_65F6_95F4, _____6BCF_79D2_901F_5EA6)
    if _____6BCF_79D2_901F_5EA6 ~= nil and _____6BCF_79D2_901F_5EA6 > 0 then
        return _____6BCF_79D2_901F_5EA6 * TICK_INTERVAL
    end
    if _____6301_7EED_65F6_95F4 ~= nil and _____6301_7EED_65F6_95F4 > 0 then
        return _____8DDD_79BB / (_____6301_7EED_65F6_95F4 / TICK_INTERVAL)
    end
    return _____8DDD_79BB
end
local function _____6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668()
    if _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 then
        return
    end
    _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 = true
    onTick10ms(____on_51B2_950B_51FB_9000_7CFB_7EDFTick)
end
local function _____9500_6BC1_679A_4E3E_7EC4()
    if _____679A_4E3E_7EC4 ~= nil and _____679A_4E3E_7EC4 ~= 0 then
        jass.DestroyGroup(_____679A_4E3E_7EC4)
        _____679A_4E3E_7EC4 = nil
    end
end
local function _____521B_5EFA_4F4D_79FB_5B9E_4F8B(_____5355_4F4D, _____89D2_5EA6, _____53C2_6570)
    if not _____5355_4F4D_5B58_6D3B(_____5355_4F4D) then
        return 0
    end
    if _____53C2_6570["距离"] == nil or _____53C2_6570["距离"] <= 0 then
        return 0
    end
    local _____5355_4F4DID = _____53D6_53E5_67C4ID(_____5355_4F4D)
    if _____5355_4F4DID == 0 then
        return 0
    end
    ____exports["停止单位位移"](_____5355_4F4D, "中断")
    local _____6BCFTick_4F4D_79FB = _____8BA1_7B97_6BCFTick_4F4D_79FB(_____53C2_6570["距离"], _____53C2_6570["持续时间"], _____53C2_6570["每秒速度"])
    if _____6BCFTick_4F4D_79FB <= 0 then
        return 0
    end
    _____4E0B_4E00_4E2A_4F4D_79FBID = _____4E0B_4E00_4E2A_4F4D_79FBID + 1
    local _____4F4D_79FBID = _____4E0B_4E00_4E2A_4F4D_79FBID
    local ____temp_15 = #_____6D3B_52A8_4F4D_79FB_5217_8868
    local ____5355_4F4D_16 = _____5355_4F4D
    local ____5355_4F4DID_17 = _____5355_4F4DID
    local ____53C2_6570__4E3B_5355_4F4D_18 = _____53C2_6570["主单位"]
    local ____temp_19 = _____53C2_6570["主单位死亡时中断"] ~= false
    local ____89D2_5EA6_20 = _____89D2_5EA6
    local ____6BCFTick_4F4D_79FB_21 = _____6BCFTick_4F4D_79FB
    local ____53C2_6570__8DDD_79BB_22 = _____53C2_6570["距离"]
    local ____temp_23 = _____53C2_6570["检查地形"] ~= false
    local ____temp_24 = _____53C2_6570["朝向跟随位移"] ~= false
    local ____temp_25 = _____53C2_6570["暂停单位"] == true
    local ____temp_26 = _____53C2_6570["禁用碰撞"] == true
    local ____temp_27 = _____53C2_6570["位移特效"] or DEFAULT_MOVE_EFFECT_MODEL
    local ____temp_28 = _____53C2_6570["命中半径"] or 0
    local ____temp_29 = _____53C2_6570["只命中敌人"] == true
    local ____temp_30 = _____53C2_6570["允许命中自己"] == true
    local ____temp_31 = _____53C2_6570["允许重复命中"] == true
    local ____temp_32 = _____53C2_6570["命中后结束"] == true
    local ____temp_33 = _____53C2_6570["命中伤害"] or 0
    local ____53C2_6570__4F24_5BB3_6765_6E90_11 = _____53C2_6570["伤害来源"]
    if ____53C2_6570__4F24_5BB3_6765_6E90_11 == nil then
        ____53C2_6570__4F24_5BB3_6765_6E90_11 = _____5355_4F4D
    end
    local ____53C2_6570__653B_51FB_7C7B_578B_12 = _____53C2_6570["攻击类型"]
    if ____53C2_6570__653B_51FB_7C7B_578B_12 == nil then
        ____53C2_6570__653B_51FB_7C7B_578B_12 = DEFAULT_ATTACK_TYPE
    end
    local ____53C2_6570__4F24_5BB3_7C7B_578B_13 = _____53C2_6570["伤害类型"]
    if ____53C2_6570__4F24_5BB3_7C7B_578B_13 == nil then
        ____53C2_6570__4F24_5BB3_7C7B_578B_13 = DEFAULT_DAMAGE_TYPE
    end
    local ____53C2_6570__6B66_5668_7C7B_578B_14 = _____53C2_6570["武器类型"]
    if ____53C2_6570__6B66_5668_7C7B_578B_14 == nil then
        ____53C2_6570__6B66_5668_7C7B_578B_14 = DEFAULT_WEAPON_TYPE
    end
    local _____5B9E_4F8B = {
        id = _____4F4D_79FBID,
        listIndex = ____temp_15,
        ["单位"] = ____5355_4F4D_16,
        ["单位ID"] = ____5355_4F4DID_17,
        ["主单位"] = ____53C2_6570__4E3B_5355_4F4D_18,
        ["主单位死亡时中断"] = ____temp_19,
        ["角度"] = ____89D2_5EA6_20,
        ["每Tick位移"] = ____6BCFTick_4F4D_79FB_21,
        ["总距离"] = ____53C2_6570__8DDD_79BB_22,
        ["已移动"] = 0,
        ["检查地形"] = ____temp_23,
        ["朝向跟随位移"] = ____temp_24,
        ["暂停单位"] = ____temp_25,
        ["禁用碰撞"] = ____temp_26,
        ["位移特效"] = ____temp_27,
        ["命中半径"] = ____temp_28,
        ["只命中敌人"] = ____temp_29,
        ["允许命中自己"] = ____temp_30,
        ["允许重复命中"] = ____temp_31,
        ["命中后结束"] = ____temp_32,
        ["命中伤害"] = ____temp_33,
        ["伤害来源"] = ____53C2_6570__4F24_5BB3_6765_6E90_11,
        ["攻击类型"] = ____53C2_6570__653B_51FB_7C7B_578B_12,
        ["伤害类型"] = ____53C2_6570__4F24_5BB3_7C7B_578B_13,
        ["武器类型"] = ____53C2_6570__6B66_5668_7C7B_578B_14,
        ["命中过滤"] = _____53C2_6570["命中过滤"],
        ["命中回调"] = _____53C2_6570["命中回调"],
        ["撞墙回调"] = _____53C2_6570["撞墙回调"],
        ["结束回调"] = _____53C2_6570["结束回调"]
    }
    _____4F4D_79FB_6620_5C04[_____4F4D_79FBID] = _____5B9E_4F8B
    _____5355_4F4D_5F53_524D_4F4D_79FB[_____5355_4F4DID] = _____4F4D_79FBID
    _____6D3B_52A8_4F4D_79FB_5217_8868[#_____6D3B_52A8_4F4D_79FB_5217_8868 + 1] = _____5B9E_4F8B
    if _____5B9E_4F8B["禁用碰撞"] then
        jass.SetUnitPathing(_____5355_4F4D, false)
    end
    if _____5B9E_4F8B["暂停单位"] then
        _____8BBE_7F6E_5355_4F4D_6682_505C_72B6_6001(_____5355_4F4D, true)
    end
    _____6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668()
    if type(_____53C2_6570["开始回调"]) == "function" then
        _____53C2_6570["开始回调"](_____5355_4F4D, _____4F4D_79FBID)
    end
    return _____4F4D_79FBID
end
local function _____89E3_6790_51B2_950B_89D2_5EA6(_____5355_4F4D, _____53C2_6570)
    if _____53C2_6570["角度"] ~= nil then
        return _____53C2_6570["角度"]
    end
    if _____53C2_6570["目标X"] ~= nil and _____53C2_6570["目标Y"] ~= nil then
        return X_GAFC(
            nil,
            jass.GetUnitX(_____5355_4F4D),
            jass.GetUnitY(_____5355_4F4D),
            _____53C2_6570["目标X"],
            _____53C2_6570["目标Y"]
        )
    end
    return nil
end
local function _____89E3_6790_51FB_9000_89D2_5EA6(_____5355_4F4D, _____53C2_6570)
    if _____53C2_6570["角度"] ~= nil then
        return _____53C2_6570["角度"]
    end
    if _____53C2_6570["来源单位"] ~= nil and _____53C2_6570["来源单位"] ~= 0 then
        return X_GAFC(
            nil,
            jass.GetUnitX(_____53C2_6570["来源单位"]),
            jass.GetUnitY(_____53C2_6570["来源单位"]),
            jass.GetUnitX(_____5355_4F4D),
            jass.GetUnitY(_____5355_4F4D)
        )
    end
    if _____53C2_6570["来源X"] ~= nil and _____53C2_6570["来源Y"] ~= nil then
        return X_GAFC(
            nil,
            _____53C2_6570["来源X"],
            _____53C2_6570["来源Y"],
            jass.GetUnitX(_____5355_4F4D),
            jass.GetUnitY(_____5355_4F4D)
        )
    end
    return nil
end
____exports["开始冲锋"] = function(_____5355_4F4D, _____53C2_6570)
    local _____89D2_5EA6 = _____89E3_6790_51B2_950B_89D2_5EA6(_____5355_4F4D, _____53C2_6570)
    if _____89D2_5EA6 == nil then
        return 0
    end
    return _____521B_5EFA_4F4D_79FB_5B9E_4F8B(_____5355_4F4D, _____89D2_5EA6, _____53C2_6570)
end
____exports["开始击退"] = function(_____5355_4F4D, _____53C2_6570)
    local _____89D2_5EA6 = _____89E3_6790_51FB_9000_89D2_5EA6(_____5355_4F4D, _____53C2_6570)
    if _____89D2_5EA6 == nil then
        return 0
    end
    if _____53C2_6570["主单位"] == nil and _____53C2_6570["来源单位"] ~= nil and _____53C2_6570["来源单位"] ~= 0 then
        return _____521B_5EFA_4F4D_79FB_5B9E_4F8B(
            _____5355_4F4D,
            _____89D2_5EA6,
            __TS__ObjectAssign({}, _____53C2_6570, {["主单位"] = _____53C2_6570["来源单位"]})
        )
    end
    return _____521B_5EFA_4F4D_79FB_5B9E_4F8B(_____5355_4F4D, _____89D2_5EA6, _____53C2_6570)
end
____exports["开始单位组冲锋"] = function(_____5355_4F4D_7EC4, _____53C2_6570)
    local _____5355_4F4D_5217_8868 = _____5FEB_7167_5355_4F4D_7EC4(_____5355_4F4D_7EC4)
    local _____7ED3_679C = {}
    for ____, _____5355_4F4D in ipairs(_____5355_4F4D_5217_8868) do
        local _____4F4D_79FBID = ____exports["开始冲锋"](_____5355_4F4D, _____53C2_6570)
        if _____4F4D_79FBID > 0 then
            _____7ED3_679C[#_____7ED3_679C + 1] = _____4F4D_79FBID
        end
    end
    return _____7ED3_679C
end
____exports["开始单位组击退"] = function(_____5355_4F4D_7EC4, _____53C2_6570)
    local _____5355_4F4D_5217_8868 = _____5FEB_7167_5355_4F4D_7EC4(_____5355_4F4D_7EC4)
    local _____7ED3_679C = {}
    for ____, _____5355_4F4D in ipairs(_____5355_4F4D_5217_8868) do
        local _____4F4D_79FBID = ____exports["开始击退"](_____5355_4F4D, _____53C2_6570)
        if _____4F4D_79FBID > 0 then
            _____7ED3_679C[#_____7ED3_679C + 1] = _____4F4D_79FBID
        end
    end
    return _____7ED3_679C
end
____exports["停止位移"] = function(_____4F4D_79FBID, _____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "中断"
    end
    return _____7ED3_675F_4F4D_79FBID(_____4F4D_79FBID, _____539F_56E0)
end
____exports["单位是否正在位移"] = function(_____5355_4F4D)
    local _____4F4D_79FBID = _____5355_4F4D_5F53_524D_4F4D_79FB[_____53D6_53E5_67C4ID(_____5355_4F4D)]
    return not not (_____4F4D_79FBID and _____4F4D_79FB_6620_5C04[_____4F4D_79FBID])
end
____exports["获取单位当前位移ID"] = function(_____5355_4F4D)
    return _____5355_4F4D_5F53_524D_4F4D_79FB[_____53D6_53E5_67C4ID(_____5355_4F4D)] or 0
end
____exports["获取活跃位移数量"] = function()
    return #_____6D3B_52A8_4F4D_79FB_5217_8868
end
return ____exports
