--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.11．佐佐木小次郎.00．配置")
local _____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["佐佐木单位技能配置"]
local ____00A_FF0E_8868_73B0_5DE5_5177 = require("系统.03．技能系统.05．单位技能.04．英雄技能.11．佐佐木小次郎.00A．表现工具")
local _____64AD_653E_4F50_4F50_6728_5750_6807_97F3_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["播放佐佐木坐标音效"]
local _____64AD_653E_4F50_4F50_6728_914D_7F6E_52A8_4F5C = ____00A_FF0E_8868_73B0_5DE5_5177["播放佐佐木配置动作"]
local ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406 = require("系统.03．技能系统.05．单位技能.04．英雄技能.11．佐佐木小次郎.00B．分身与状态管理")
local _____662F_4F50_4F50_6728_672C_4F53 = ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406["是佐佐木本体"]
local _____4F50_4F50_6728_6247_5F62_4F24_5BB3 = ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406["佐佐木扇形伤害"]
local _____521B_5EFA_4F50_4F50_6728_5206_8EAB = ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406["创建佐佐木分身"]
local _____5237_65B0_77AC_79FB_5C31_7EEA = ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406["刷新瞬移就绪"]
local _____6D88_8017_77AC_79FB_540E_6807_8BB0 = ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406["消耗瞬移后标记"]
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local ____require_result_2 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_2.registerSpellEffectListener
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境")
local _____65BD_52A0_7729_6655 = ____require_result_3["施加眩晕"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_4["读取单位攻击力"]
local _____5355_4F4D_5B58_6D3B = ____require_result_4["单位存活"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口")
local _____521B_5EFA_539F_751F_5F39_5E55 = ____require_result_5["创建原生弹幕"]
local _____83B7_53D6_539F_751F_5F39_5E55 = ____require_result_5["获取原生弹幕"]
local ____require_result_6 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_6["创建点特效"]
local ____require_result_7 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWESetUnitAbilityStateSafe = ____require_result_7.YDWESetUnitAbilityStateSafe
local ____Q_672C_4F53_6280_80FDID = stringToFourCCSafe(_____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E["Q技能ID"])
local ____Q_4E8C_6BB5_6280_80FDID_6570_503C = stringToFourCCSafe(_____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E["Q二段技能ID"])
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local SetUnitX = jass.SetUnitX
local SetUnitY = jass.SetUnitY
local GetOwningPlayer = jass.GetOwningPlayer
local SetPlayerAbilityAvailable = jass.SetPlayerAbilityAvailable
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local function _____4E24_70B9_8DDD_79BB(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return math.sqrt(dx * dx + dy * dy)
end
local function _____4E24_70B9_89D2_5EA6(x1, y1, x2, y2)
    return math.atan(y2 - y1, x2 - x1) * 180 / math.pi
end
--- 地形可通行判定（不可通行 = 阻挡）
local function _____5730_5F62_53EF_901A_884C(x, y)
    if type(jass.IsTerrainPathable) ~= "function" then
        return true
    end
    return not jass.IsTerrainPathable(x, y, jass.PATHING_TYPE_WALKABILITY)
end
--- 沿施法方向做 40 码步长地形检查，返回最终落点（阻挡时停在最后一个可通行点）。
-- 源 JASS：Trig_zzm_QFunc001Func018Func007Func009Func005T 的循环判定。
local function _____8BA1_7B97_77AC_79FB_843D_70B9(_____8D77_70B9X, _____8D77_70B9Y, _____89D2_5EA6, _____8DDD_79BB)
    local _____843D_70B9X = _____8D77_70B9X
    local _____843D_70B9Y = _____8D77_70B9Y
    local _____6B65_6570 = math.floor(_____8DDD_79BB / 40)
    local _____5F27_5EA6 = _____89D2_5EA6 * math.pi / 180
    do
        local i = 1
        while i <= _____6B65_6570 do
            local _____5019_9009X = _____8D77_70B9X + math.cos(_____5F27_5EA6) * 40 * i
            local _____5019_9009Y = _____8D77_70B9Y + math.sin(_____5F27_5EA6) * 40 * i
            if not _____5730_5F62_53EF_901A_884C(_____5019_9009X, _____5019_9009Y) then
                break
            end
            _____843D_70B9X = _____5019_9009X
            _____843D_70B9Y = _____5019_9009Y
            i = i + 1
        end
    end
    return {_____843D_70B9X, _____843D_70B9Y}
end
--- 共享充能切换（t≈610ms；源 JASS：Trig_zzm_QFunc001Func018Func007Func009Func008T）
local function _____5207_6362Q_6280_80FD(_____82F1_96C4, _____65BD_653E_6280_80FDID)
    local owner = GetOwningPlayer(_____82F1_96C4)
    if _____65BD_653E_6280_80FDID == ____Q_672C_4F53_6280_80FDID then
        SetPlayerAbilityAvailable(owner, ____Q_672C_4F53_6280_80FDID, false)
        SetPlayerAbilityAvailable(owner, ____Q_4E8C_6BB5_6280_80FDID_6570_503C, true)
        YDWESetUnitAbilityStateSafe(_____82F1_96C4, ____Q_4E8C_6BB5_6280_80FDID_6570_503C, 1, 0.01)
        addDelayedCallback(
            _____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E.Q["二段窗口秒"] * 1000,
            function()
                if not _____5355_4F4D_5B58_6D3B(_____82F1_96C4) then
                    return
                end
                SetPlayerAbilityAvailable(owner, ____Q_672C_4F53_6280_80FDID, true)
                SetPlayerAbilityAvailable(owner, ____Q_4E8C_6BB5_6280_80FDID_6570_503C, false)
            end
        )
    else
        SetPlayerAbilityAvailable(owner, ____Q_4E8C_6BB5_6280_80FDID_6570_503C, false)
        SetPlayerAbilityAvailable(owner, ____Q_672C_4F53_6280_80FDID, true)
    end
end
--- 发射剑气（瞬移后窗口内附加；源 JASS 刀光2 e07U 弹幕 → TS 原生弹幕）
local function _____53D1_5C04_4F50_4F50_6728_5251_6C14(_____82F1_96C4, _____8D77_70B9X, _____8D77_70B9Y, _____89D2_5EA6, _____6280_80FDID)
    local cfg = _____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E.Q["剑气"]
    _____521B_5EFA_539F_751F_5F39_5E55({
        ["所有者"] = _____82F1_96C4,
        X = _____8D77_70B9X,
        Y = _____8D77_70B9Y,
        ["方向角"] = _____89D2_5EA6,
        ["速度"] = cfg["速度"],
        ["最大距离"] = cfg["最大飞行距离"],
        ["命中半径"] = cfg["命中半径"],
        ["影响目标"] = "敌方",
        ["每单位最大命中次数"] = 1,
        ["不可阻挡"] = true,
        ["伤害值"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____82F1_96C4) * cfg["攻击力倍率"],
        attack = true,
        ["攻击类型"] = ATTACK_TYPE_NORMAL,
        ["伤害类型"] = DAMAGE_TYPE_NORMAL,
        ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = _____6280_80FDID,
        ["标签"] = "佐佐木小次郎-剑气",
        ["伤害形态"] = "单体",
        ["参与技能伤害加成"] = true,
        ["模型"] = cfg["模型"],
        ["缩放"] = 1,
        ["目标筛选"] = function(_____76EE_6807_5355_4F4D, _____5F39_5E55ID)
            local _____5B9E_4F8B = _____83B7_53D6_539F_751F_5F39_5E55(_____5F39_5E55ID)
            if _____5B9E_4F8B == nil then
                return true
            end
            return _____5B9E_4F8B["已飞行距离"] >= cfg["起伤距离"]
        end
    })
end
local function ____on_4F50_4F50_6728Q_751F_6548(_____65BD_6CD5_5355_4F4D, _____6280_80FDID_6570_503C)
    if not _____662F_4F50_4F50_6728_672C_4F53(_____65BD_6CD5_5355_4F4D) then
        return
    end
    if _____6280_80FDID_6570_503C ~= ____Q_672C_4F53_6280_80FDID and _____6280_80FDID_6570_503C ~= ____Q_4E8C_6BB5_6280_80FDID_6570_503C then
        return
    end
    local cfg = _____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E.Q
    local _____8D77_70B9X = GetUnitX(_____65BD_6CD5_5355_4F4D)
    local _____8D77_70B9Y = GetUnitY(_____65BD_6CD5_5355_4F4D)
    local _____76EE_6807X = jass.GetSpellTargetX()
    local _____76EE_6807Y = jass.GetSpellTargetY()
    local _____89D2_5EA6 = _____4E24_70B9_89D2_5EA6(_____8D77_70B9X, _____8D77_70B9Y, _____76EE_6807X, _____76EE_6807Y)
    local _____8DDD_79BB = _____4E24_70B9_8DDD_79BB(_____8D77_70B9X, _____8D77_70B9Y, _____76EE_6807X, _____76EE_6807Y)
    _____5237_65B0_77AC_79FB_5C31_7EEA(_____65BD_6CD5_5355_4F4D)
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E.D["换位特效模型"],
        X = _____8D77_70B9X,
        Y = _____8D77_70B9Y,
        ["缩放"] = _____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E.D["换位特效缩放"],
        ["持续秒"] = 1
    })
    addDelayedCallback(
        10,
        function()
            if not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_5355_4F4D) then
                return
            end
            _____65BD_52A0_7729_6655(
                _____65BD_6CD5_5355_4F4D,
                _____65BD_6CD5_5355_4F4D,
                0.6,
                "佐佐木前斩",
                "技能"
            )
            _____64AD_653E_4F50_4F50_6728_914D_7F6E_52A8_4F5C(
                _____65BD_6CD5_5355_4F4D,
                math.floor(math.random() * 2) == 0 and 8 or 7,
                0
            )
            _____521B_5EFA_70B9_7279_6548({
                ["模型路径"] = cfg["蓄力特效模型"],
                X = GetUnitX(_____65BD_6CD5_5355_4F4D),
                Y = GetUnitY(_____65BD_6CD5_5355_4F4D),
                ["动画速度"] = cfg["蓄力特效速度"],
                ["持续秒"] = cfg["蓄力特效持续秒"]
            })
        end
    )
    addDelayedCallback(
        210,
        function()
            if not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_5355_4F4D) then
                return
            end
            _____521B_5EFA_4F50_4F50_6728_5206_8EAB(
                _____65BD_6CD5_5355_4F4D,
                _____8D77_70B9X,
                _____8D77_70B9Y,
                _____89D2_5EA6,
                "原地",
                _____6280_80FDID_6570_503C
            )
        end
    )
    addDelayedCallback(
        310,
        function()
            if not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_5355_4F4D) then
                return
            end
            if math.floor(math.random() * 2) == 0 then
                _____64AD_653E_4F50_4F50_6728_5750_6807_97F3_6548(
                    cfg["挥砍音效路径1"],
                    GetUnitX(_____65BD_6CD5_5355_4F4D),
                    GetUnitY(_____65BD_6CD5_5355_4F4D),
                    cfg["挥砍音效裁断"]
                )
            else
                _____64AD_653E_4F50_4F50_6728_5750_6807_97F3_6548(
                    cfg["挥砍音效路径2"],
                    GetUnitX(_____65BD_6CD5_5355_4F4D),
                    GetUnitY(_____65BD_6CD5_5355_4F4D),
                    cfg["挥砍音效裁断"]
                )
            end
            local _____843D_70B9_5750_6807 = _____8BA1_7B97_77AC_79FB_843D_70B9(_____8D77_70B9X, _____8D77_70B9Y, _____89D2_5EA6, _____8DDD_79BB)
            local _____843D_70B9X = _____843D_70B9_5750_6807[1]
            local _____843D_70B9Y = _____843D_70B9_5750_6807[2]
            _____521B_5EFA_70B9_7279_6548({
                ["模型路径"] = _____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E.D["换位特效模型"],
                X = _____843D_70B9X,
                Y = _____843D_70B9Y,
                ["缩放"] = _____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E.D["换位特效缩放"],
                ["持续秒"] = 1
            })
            SetUnitX(_____65BD_6CD5_5355_4F4D, _____843D_70B9X)
            SetUnitY(_____65BD_6CD5_5355_4F4D, _____843D_70B9Y)
            _____4F50_4F50_6728_6247_5F62_4F24_5BB3(
                _____65BD_6CD5_5355_4F4D,
                _____843D_70B9X,
                _____843D_70B9Y,
                _____89D2_5EA6,
                cfg["命中范围"],
                cfg["扇形半角"],
                cfg["攻击力倍率"],
                _____6280_80FDID_6570_503C,
                "佐佐木小次郎-前斩",
                cfg["命中特效模型"],
                cfg["命中特效缩放"],
                cfg["硬直秒"]
            )
            if _____6D88_8017_77AC_79FB_540E_6807_8BB0(_____65BD_6CD5_5355_4F4D) then
                _____53D1_5C04_4F50_4F50_6728_5251_6C14(
                    _____65BD_6CD5_5355_4F4D,
                    _____843D_70B9X,
                    _____843D_70B9Y,
                    _____89D2_5EA6,
                    _____6280_80FDID_6570_503C
                )
            end
        end
    )
    addDelayedCallback(
        610,
        function()
            if not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_5355_4F4D) then
                return
            end
            _____5207_6362Q_6280_80FD(_____65BD_6CD5_5355_4F4D, _____6280_80FDID_6570_503C)
        end
    )
end
registerSpellEffectListener(____on_4F50_4F50_6728Q_751F_6548)
return ____exports
