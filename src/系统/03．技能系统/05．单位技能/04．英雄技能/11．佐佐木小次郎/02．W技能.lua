--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.11．佐佐木小次郎.00．配置")
local _____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["佐佐木单位技能配置"]
local ____00A_FF0E_8868_73B0_5DE5_5177 = require("系统.03．技能系统.05．单位技能.04．英雄技能.11．佐佐木小次郎.00A．表现工具")
local _____64AD_653E_4F50_4F50_6728_5750_6807_97F3_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["播放佐佐木坐标音效"]
local ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406 = require("系统.03．技能系统.05．单位技能.04．英雄技能.11．佐佐木小次郎.00B．分身与状态管理")
local _____662F_4F50_4F50_6728_672C_4F53 = ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406["是佐佐木本体"]
local _____521B_5EFA_4F50_4F50_6728_5206_8EAB = ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406["创建佐佐木分身"]
local _____5237_65B0_77AC_79FB_5C31_7EEA = ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406["刷新瞬移就绪"]
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local ____require_result_2 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_2.registerSpellEffectListener
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口")
local _____5F00_59CB_51B2_950B = ____require_result_3["开始冲锋"]
local ____require_result_4 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_4["创建点特效"]
local ____require_result_5 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWESetUnitAbilityStateSafe = ____require_result_5.YDWESetUnitAbilityStateSafe
local YDUserDataSetSafe = ____require_result_5.YDUserDataSetSafe
local ____require_result_6 = require("系统.05．Buff系统.05．Buff清除函数")
local _____79FB_9664_5355_4F4D_8D1F_9762Buff = ____require_result_6["移除单位负面Buff"]
local ____W_672C_4F53_6280_80FDID = stringToFourCCSafe(_____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E["W技能ID"])
local ____W_4E8C_6BB5_6280_80FDID_6570_503C = stringToFourCCSafe(_____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E["W二段技能ID"])
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local GetOwningPlayer = jass.GetOwningPlayer
local SetPlayerAbilityAvailable = jass.SetPlayerAbilityAvailable
--- 共享充能切换（源 JASS：施放入口 + Trig_zzm_QFunc002Func004Func007T）
local function _____5207_6362W_6280_80FD(_____82F1_96C4, _____65BD_653E_6280_80FDID)
    local owner = GetOwningPlayer(_____82F1_96C4)
    if _____65BD_653E_6280_80FDID == ____W_672C_4F53_6280_80FDID then
        SetPlayerAbilityAvailable(owner, ____W_672C_4F53_6280_80FDID, false)
        SetPlayerAbilityAvailable(owner, ____W_4E8C_6BB5_6280_80FDID_6570_503C, true)
        YDWESetUnitAbilityStateSafe(_____82F1_96C4, ____W_4E8C_6BB5_6280_80FDID_6570_503C, 1, 0.01)
        addDelayedCallback(
            _____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E.W["二段窗口秒"] * 1000,
            function()
                SetPlayerAbilityAvailable(owner, ____W_672C_4F53_6280_80FDID, true)
                SetPlayerAbilityAvailable(owner, ____W_4E8C_6BB5_6280_80FDID_6570_503C, false)
            end
        )
    else
        SetPlayerAbilityAvailable(owner, ____W_4E8C_6BB5_6280_80FDID_6570_503C, false)
        SetPlayerAbilityAvailable(owner, ____W_672C_4F53_6280_80FDID, true)
    end
end
local function ____on_4F50_4F50_6728W_751F_6548(_____65BD_6CD5_5355_4F4D, _____6280_80FDID_6570_503C)
    if not _____662F_4F50_4F50_6728_672C_4F53(_____65BD_6CD5_5355_4F4D) then
        return
    end
    if _____6280_80FDID_6570_503C ~= ____W_672C_4F53_6280_80FDID and _____6280_80FDID_6570_503C ~= ____W_4E8C_6BB5_6280_80FDID_6570_503C then
        return
    end
    local cfg = _____4F50_4F50_6728_5355_4F4D_6280_80FD_914D_7F6E.W
    local _____539F_70B9X = GetUnitX(_____65BD_6CD5_5355_4F4D)
    local _____539F_70B9Y = GetUnitY(_____65BD_6CD5_5355_4F4D)
    local _____9762_5411 = GetUnitFacing(_____65BD_6CD5_5355_4F4D)
    local _____540E_64A4_89D2_5EA6 = _____9762_5411 + 180
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = cfg["起手特效模型"],
        X = _____539F_70B9X,
        Y = _____539F_70B9Y,
        ["缩放"] = cfg["起手特效缩放"],
        ["持续秒"] = 1
    })
    _____5207_6362W_6280_80FD(_____65BD_6CD5_5355_4F4D, _____6280_80FDID_6570_503C)
    _____64AD_653E_4F50_4F50_6728_5750_6807_97F3_6548(cfg["施法音效路径"], _____539F_70B9X, _____539F_70B9Y, cfg["施法音效裁断"])
    _____5237_65B0_77AC_79FB_5C31_7EEA(_____65BD_6CD5_5355_4F4D)
    YDUserDataSetSafe(
        "unit",
        _____65BD_6CD5_5355_4F4D,
        "免疫伤害",
        "boolean",
        true
    )
    _____79FB_9664_5355_4F4D_8D1F_9762Buff(_____65BD_6CD5_5355_4F4D)
    addDelayedCallback(
        cfg["免伤秒"] * 1000,
        function()
            if _____65BD_6CD5_5355_4F4D == nil or _____65BD_6CD5_5355_4F4D == 0 then
                return
            end
            YDUserDataSetSafe(
                "unit",
                _____65BD_6CD5_5355_4F4D,
                "免疫伤害",
                "boolean",
                false
            )
        end
    )
    _____521B_5EFA_4F50_4F50_6728_5206_8EAB(
        _____65BD_6CD5_5355_4F4D,
        _____539F_70B9X,
        _____539F_70B9Y,
        _____9762_5411,
        "W落地",
        _____6280_80FDID_6570_503C
    )
    _____5F00_59CB_51B2_950B(_____65BD_6CD5_5355_4F4D, {["距离"] = cfg["后撤距离"], ["每秒速度"] = cfg["后撤每秒速度"], ["角度"] = _____540E_64A4_89D2_5EA6, ["检查地形"] = true})
    addDelayedCallback(
        120,
        function()
            if _____65BD_6CD5_5355_4F4D == nil or _____65BD_6CD5_5355_4F4D == 0 then
                return
            end
            _____521B_5EFA_70B9_7279_6548({
                ["模型路径"] = cfg["起手特效模型"],
                X = GetUnitX(_____65BD_6CD5_5355_4F4D),
                Y = GetUnitY(_____65BD_6CD5_5355_4F4D),
                ["缩放"] = cfg["起手特效缩放"],
                ["持续秒"] = 1
            })
        end
    )
end
registerSpellEffectListener(____on_4F50_4F50_6728W_751F_6548)
return ____exports
