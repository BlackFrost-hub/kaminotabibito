local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____4ECE_4E2D_5FC3_8BA1_65F6_5668_6CE8_9500, _____5C1D_8BD5_6536_5C3E_4E2D_5FC3_8BA1_65F6_5668, _____5185_90E8_79FB_9664_4F4D_79FB, offTick10ms, _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668, ____tick_8BA1_6570
local ____00_FF0E_5171_4EAB = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.00．共享")
local CENTER_TIMER_TICKS = ____00_FF0E_5171_4EAB.CENTER_TIMER_TICKS
local DEFAULT_ATTACK_TYPE = ____00_FF0E_5171_4EAB.DEFAULT_ATTACK_TYPE
local DEFAULT_DAMAGE_TYPE = ____00_FF0E_5171_4EAB.DEFAULT_DAMAGE_TYPE
local DEFAULT_MOVE_EFFECT_MODEL = ____00_FF0E_5171_4EAB.DEFAULT_MOVE_EFFECT_MODEL
local DEFAULT_WEAPON_TYPE = ____00_FF0E_5171_4EAB.DEFAULT_WEAPON_TYPE
local jass = ____00_FF0E_5171_4EAB.jass
local _____6D3B_52A8_4F4D_79FB_5217_8868 = ____00_FF0E_5171_4EAB["活动位移列表"]
local _____4F4D_79FB_6620_5C04 = ____00_FF0E_5171_4EAB["位移映射"]
local _____5355_4F4D_5F53_524D_4F4D_79FB = ____00_FF0E_5171_4EAB["单位当前位移"]
local _____5206_914D_65B0_4F4D_79FBID = ____00_FF0E_5171_4EAB["分配新位移ID"]
local _____53D6_53E5_67C4ID = ____00_FF0E_5171_4EAB["取句柄ID"]
local _____5355_4F4D_5B58_6D3B = ____00_FF0E_5171_4EAB["单位存活"]
local _____6E05_7406_547D_4E2D_8BB0_5F55 = ____00_FF0E_5171_4EAB["清理命中记录"]
local _____8BA1_7B97_6BCFTick_4F4D_79FB = ____00_FF0E_5171_4EAB["计算每Tick位移"]
local _____5355_4F4D_5DF2_88AB_6682_505C = ____00_FF0E_5171_4EAB["单位已被暂停"]
local _____7533_8BF7_5355_4F4D_6682_505C_5360_7528 = ____00_FF0E_5171_4EAB["申请单位暂停占用"]
local _____91CA_653E_5355_4F4D_6682_505C_5360_7528 = ____00_FF0E_5171_4EAB["释放单位暂停占用"]
local _____5355_4F4D_662F_5426_5B58_5728_5176_4ED6_6682_505C_5360_7528 = ____00_FF0E_5171_4EAB["单位是否存在其他暂停占用"]
local _____96F6_79D2_540E_91CD_7F6E_5355_4F4D_52A8_753B = ____00_FF0E_5171_4EAB["零秒后重置单位动画"]
local ____01_FF0E_547D_4E2D_4E0E_79FB_52A8 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.01．命中与移动")
local _____63A8_8FDB_4E00_6B65 = ____01_FF0E_547D_4E2D_4E0E_79FB_52A8["推进一步"]
function _____4ECE_4E2D_5FC3_8BA1_65F6_5668_6CE8_9500()
    if not _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 then
        return
    end
    _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 = false
    offTick10ms(____exports["on冲锋击退系统Tick"])
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
____exports["结束位移实例"] = function(_____5B9E_4F8B, _____539F_56E0, _____547D_4E2D_76EE_6807)
    if _____4F4D_79FB_6620_5C04[_____5B9E_4F8B.id] ~= _____5B9E_4F8B then
        return
    end
    local _____5355_4F4D = _____5B9E_4F8B["单位"]
    local _____4F4D_79FBID = _____5B9E_4F8B.id
    local _____7ED3_675F_56DE_8C03 = _____5B9E_4F8B["结束回调"]
    if _____5B9E_4F8B["禁用碰撞"] then
        jass:SetUnitPathing(_____5355_4F4D, true)
    end
    if _____5B9E_4F8B["暂停单位"] then
        _____91CA_653E_5355_4F4D_6682_505C_5360_7528(_____5355_4F4D, _____5B9E_4F8B["暂停来源"])
    end
    if _____5355_4F4D_5B58_6D3B(_____5355_4F4D) and _____539F_56E0 ~= "死亡" and _____539F_56E0 ~= "主单位死亡" then
        _____96F6_79D2_540E_91CD_7F6E_5355_4F4D_52A8_753B(_____5355_4F4D)
    end
    _____5185_90E8_79FB_9664_4F4D_79FB(_____5B9E_4F8B)
    if type(_____7ED3_675F_56DE_8C03) == "function" then
        _____7ED3_675F_56DE_8C03(_____5355_4F4D, _____539F_56E0, _____4F4D_79FBID, _____547D_4E2D_76EE_6807)
    end
end
____exports["on冲锋击退系统Tick"] = function()
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
                goto __continue23
            end
            if not _____5355_4F4D_5B58_6D3B(_____5B9E_4F8B["单位"]) then
                ____exports["结束位移实例"](_____5B9E_4F8B, "死亡")
                goto __continue23
            end
            if _____5B9E_4F8B["主单位死亡时中断"] and _____5B9E_4F8B["主单位"] ~= nil and _____5B9E_4F8B["主单位"] ~= 0 and not _____5355_4F4D_5B58_6D3B(_____5B9E_4F8B["主单位"]) then
                ____exports["结束位移实例"](_____5B9E_4F8B, "主单位死亡")
                goto __continue23
            end
            if not _____5B9E_4F8B["暂停单位"] and _____5355_4F4D_5DF2_88AB_6682_505C(_____5B9E_4F8B["单位"]) then
                ____exports["结束位移实例"](_____5B9E_4F8B, "中断")
                goto __continue23
            end
            if _____5B9E_4F8B["暂停单位"] and _____5355_4F4D_5DF2_88AB_6682_505C(_____5B9E_4F8B["单位"]) and _____5355_4F4D_662F_5426_5B58_5728_5176_4ED6_6682_505C_5360_7528(_____5B9E_4F8B["单位"], _____5B9E_4F8B["暂停来源"]) then
                ____exports["结束位移实例"](_____5B9E_4F8B, "中断")
                goto __continue23
            end
            local _____7ED3_679C = _____63A8_8FDB_4E00_6B65(_____5B9E_4F8B)
            if _____7ED3_679C["停止"] then
                local ____exports__7ED3_675F_4F4D_79FB_5B9E_4F8B_2 = ____exports["结束位移实例"]
                local ____7ED3_679C__539F_56E0_1 = _____7ED3_679C["原因"]
                if ____7ED3_679C__539F_56E0_1 == nil then
                    ____7ED3_679C__539F_56E0_1 = "完成"
                end
                ____exports__7ED3_675F_4F4D_79FB_5B9E_4F8B_2(_____5B9E_4F8B, ____7ED3_679C__539F_56E0_1, _____7ED3_679C["命中目标"])
                goto __continue23
            end
            i = i + 1
        end
        ::__continue23::
    end
end
local ____G_0 = _G
local onTick10ms = ____G_0.onTick10ms
offTick10ms = ____G_0.offTick10ms
_____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 = false
____tick_8BA1_6570 = 0
local function _____6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668()
    if _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 then
        return
    end
    _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 = true
    onTick10ms(____exports["on冲锋击退系统Tick"])
end
____exports["结束位移ID"] = function(_____4F4D_79FBID, _____539F_56E0, _____547D_4E2D_76EE_6807)
    local _____5B9E_4F8B = _____4F4D_79FB_6620_5C04[_____4F4D_79FBID]
    if not _____5B9E_4F8B then
        return false
    end
    ____exports["结束位移实例"](_____5B9E_4F8B, _____539F_56E0, _____547D_4E2D_76EE_6807)
    return true
end
____exports["停止单位位移"] = function(_____5355_4F4D, _____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "中断"
    end
    local _____4F4D_79FBID = _____5355_4F4D_5F53_524D_4F4D_79FB[_____53D6_53E5_67C4ID(_____5355_4F4D)]
    if not _____4F4D_79FBID then
        return false
    end
    return ____exports["结束位移ID"](_____4F4D_79FBID, _____539F_56E0)
end
____exports["创建位移实例"] = function(_____5355_4F4D, _____89D2_5EA6, _____53C2_6570)
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
    local _____4F4D_79FBID = _____5206_914D_65B0_4F4D_79FBID()
    local ____temp_7 = #_____6D3B_52A8_4F4D_79FB_5217_8868
    local ____5355_4F4D_8 = _____5355_4F4D
    local ____5355_4F4DID_9 = _____5355_4F4DID
    local ____53C2_6570__4E3B_5355_4F4D_10 = _____53C2_6570["主单位"]
    local ____temp_11 = _____53C2_6570["主单位死亡时中断"] ~= false
    local ____89D2_5EA6_12 = _____89D2_5EA6
    local ____6BCFTick_4F4D_79FB_13 = _____6BCFTick_4F4D_79FB
    local ____53C2_6570__8DDD_79BB_14 = _____53C2_6570["距离"]
    local ____temp_15 = _____53C2_6570["检查地形"] ~= false
    local ____temp_16 = _____53C2_6570["朝向跟随位移"] ~= false
    local ____temp_17 = _____53C2_6570["暂停单位"] ~= false
    local ____temp_18 = _____53C2_6570["禁用碰撞"] == true
    local ____temp_19 = _____53C2_6570["位移特效"] or DEFAULT_MOVE_EFFECT_MODEL
    local ____temp_20 = _____53C2_6570["命中半径"] or 0
    local ____temp_21 = _____53C2_6570["只命中敌人"] == true
    local ____temp_22 = _____53C2_6570["允许命中自己"] == true
    local ____temp_23 = _____53C2_6570["允许重复命中"] == true
    local ____temp_24 = _____53C2_6570["命中后结束"] == true
    local ____temp_25 = _____53C2_6570["命中伤害"] or 0
    local ____53C2_6570__4F24_5BB3_6765_6E90_3 = _____53C2_6570["伤害来源"]
    if ____53C2_6570__4F24_5BB3_6765_6E90_3 == nil then
        ____53C2_6570__4F24_5BB3_6765_6E90_3 = _____5355_4F4D
    end
    local ____53C2_6570__653B_51FB_7C7B_578B_4 = _____53C2_6570["攻击类型"]
    if ____53C2_6570__653B_51FB_7C7B_578B_4 == nil then
        ____53C2_6570__653B_51FB_7C7B_578B_4 = DEFAULT_ATTACK_TYPE
    end
    local ____53C2_6570__4F24_5BB3_7C7B_578B_5 = _____53C2_6570["伤害类型"]
    if ____53C2_6570__4F24_5BB3_7C7B_578B_5 == nil then
        ____53C2_6570__4F24_5BB3_7C7B_578B_5 = DEFAULT_DAMAGE_TYPE
    end
    local ____53C2_6570__6B66_5668_7C7B_578B_6 = _____53C2_6570["武器类型"]
    if ____53C2_6570__6B66_5668_7C7B_578B_6 == nil then
        ____53C2_6570__6B66_5668_7C7B_578B_6 = DEFAULT_WEAPON_TYPE
    end
    local _____5B9E_4F8B = {
        id = _____4F4D_79FBID,
        listIndex = ____temp_7,
        ["单位"] = ____5355_4F4D_8,
        ["单位ID"] = ____5355_4F4DID_9,
        ["主单位"] = ____53C2_6570__4E3B_5355_4F4D_10,
        ["主单位死亡时中断"] = ____temp_11,
        ["角度"] = ____89D2_5EA6_12,
        ["每Tick位移"] = ____6BCFTick_4F4D_79FB_13,
        ["总距离"] = ____53C2_6570__8DDD_79BB_14,
        ["已移动"] = 0,
        ["检查地形"] = ____temp_15,
        ["朝向跟随位移"] = ____temp_16,
        ["暂停单位"] = ____temp_17,
        ["禁用碰撞"] = ____temp_18,
        ["位移特效"] = ____temp_19,
        ["命中半径"] = ____temp_20,
        ["只命中敌人"] = ____temp_21,
        ["允许命中自己"] = ____temp_22,
        ["允许重复命中"] = ____temp_23,
        ["命中后结束"] = ____temp_24,
        ["命中伤害"] = ____temp_25,
        ["伤害来源"] = ____53C2_6570__4F24_5BB3_6765_6E90_3,
        ["攻击类型"] = ____53C2_6570__653B_51FB_7C7B_578B_4,
        ["伤害类型"] = ____53C2_6570__4F24_5BB3_7C7B_578B_5,
        ["武器类型"] = ____53C2_6570__6B66_5668_7C7B_578B_6,
        ["命中过滤"] = _____53C2_6570["命中过滤"],
        ["命中回调"] = _____53C2_6570["命中回调"],
        ["撞墙回调"] = _____53C2_6570["撞墙回调"],
        ["结束回调"] = _____53C2_6570["结束回调"],
        ["暂停来源"] = "击退系统:" .. tostring(_____4F4D_79FBID)
    }
    _____4F4D_79FB_6620_5C04[_____4F4D_79FBID] = _____5B9E_4F8B
    _____5355_4F4D_5F53_524D_4F4D_79FB[_____5355_4F4DID] = _____4F4D_79FBID
    _____6D3B_52A8_4F4D_79FB_5217_8868[#_____6D3B_52A8_4F4D_79FB_5217_8868 + 1] = _____5B9E_4F8B
    if _____5B9E_4F8B["禁用碰撞"] then
        jass:SetUnitPathing(_____5355_4F4D, false)
    end
    if _____5B9E_4F8B["暂停单位"] then
        _____7533_8BF7_5355_4F4D_6682_505C_5360_7528(_____5355_4F4D, _____5B9E_4F8B["暂停来源"])
    end
    _____6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668()
    if type(_____53C2_6570["开始回调"]) == "function" then
        _____53C2_6570["开始回调"](_____5355_4F4D, _____4F4D_79FBID)
    end
    return _____4F4D_79FBID
end
return ____exports
