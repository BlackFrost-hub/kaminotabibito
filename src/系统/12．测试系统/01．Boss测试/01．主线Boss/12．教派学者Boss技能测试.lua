--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____on_6559_6D3E_5B66_8005_6697_5F71_7D22_547D_51FB_843D_6062_590D_68C0_67E5, ____on_6559_6D3E_5B66_8005_5EF6_8FDF_6D4B_8BD5, GetUnitState, SetUnitPosition, UnitDamageTarget, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS, UNIT_STATE_LIFE, UNIT_STATE_MANA, _____6D4B_8BD5_4E2D_5FC3X, _____6D4B_8BD5_4E2D_5FC3Y
function ____on_6559_6D3E_5B66_8005_6697_5F71_7D22_547D_51FB_843D_6062_590D_68C0_67E5(variable)
    local data = variable
    if data == nil then
        return
    end
    local _____73A9_5BB6_82F1_96C4 = data["上下文"]["玩家英雄"]
    local _____5F53_524D_751F_547D_503C = GetUnitState(_____73A9_5BB6_82F1_96C4, UNIT_STATE_LIFE)
    local _____5F53_524D_9B54_6CD5_503C = GetUnitState(_____73A9_5BB6_82F1_96C4, UNIT_STATE_MANA)
end
function ____on_6559_6D3E_5B66_8005_5EF6_8FDF_6D4B_8BD5(variable)
    local data = variable
    if data == nil then
        return
    end
    local context = data["上下文"]
    if data["操作"] == "深渊之牢安全检查" then
        return
    end
    if data["操作"] == "冥神魔门创建检查" then
        local _____72B6_6001 = context["运行时"]["冥神魔门状态"]
        local ____opt_result_39
        if _____72B6_6001 ~= nil then
            ____opt_result_39 = _____72B6_6001["门实例"]
        end
        local ____opt_result_40
        if ____opt_result_39 ~= nil then
            ____opt_result_40 = ____opt_result_39["单位"]
        end
        local ____opt_result_40_44 = ____opt_result_40
        if ____opt_result_40_44 == nil then
            local ____opt_result_43
            if _____72B6_6001 ~= nil then
                ____opt_result_43 = _____72B6_6001["门单位"]
            end
            ____opt_result_40_44 = ____opt_result_43
        end
        local _____95E8 = ____opt_result_40_44
        return
    end
    if data["操作"] == "邪狱追魂状态检查" then
        local _____72B6_6001 = context["运行时"]["邪狱追魂状态"]
        local _____9501_94FE_6570_91CF = _____72B6_6001 ~= nil and _____72B6_6001["锁链列表"] ~= nil and #_____72B6_6001["锁链列表"] or -1
        local _____5DF2_53D1_5C04_5F39_5E55 = _____72B6_6001 ~= nil and _____72B6_6001["已发射弹幕"] == true
        return
    end
    if data["操作"] == "冥念随机结束检查" then
        local _____72B6_6001 = context["运行时"]["冥之念欲状态"]
        return
    end
    if data["操作"] == "深渊之牢离开" then
        SetUnitPosition(context["玩家英雄"], _____6D4B_8BD5_4E2D_5FC3X + 900, _____6D4B_8BD5_4E2D_5FC3Y + 900)
        return
    end
    if data["操作"] == "冥神魔门摧毁" then
        local _____72B6_6001 = context["运行时"]["冥神魔门状态"]
        local ____opt_result_49
        if _____72B6_6001 ~= nil then
            ____opt_result_49 = _____72B6_6001["门实例"]
        end
        local ____opt_result_50
        if ____opt_result_49 ~= nil then
            ____opt_result_50 = ____opt_result_49["单位"]
        end
        local ____opt_result_50_54 = ____opt_result_50
        if ____opt_result_50_54 == nil then
            local ____opt_result_53
            if _____72B6_6001 ~= nil then
                ____opt_result_53 = _____72B6_6001["门单位"]
            end
            ____opt_result_50_54 = ____opt_result_53
        end
        local _____95E8 = ____opt_result_50_54
        local submitted = 0
        if _____95E8 ~= nil and _____95E8 ~= 0 then
            do
                local i = 0
                while i < 8 do
                    if UnitDamageTarget(
                        context["玩家英雄"],
                        _____95E8,
                        100000,
                        true,
                        false,
                        ATTACK_TYPE_NORMAL,
                        DAMAGE_TYPE_NORMAL,
                        WEAPON_TYPE_WHOKNOWS
                    ) then
                        submitted = submitted + 1
                    end
                    i = i + 1
                end
            end
        end
        return
    end
    if data["操作"] == "冥念违规位置" then
        SetUnitPosition(context["玩家英雄"], _____6D4B_8BD5_4E2D_5FC3X + 1400, _____6D4B_8BD5_4E2D_5FC3Y + 1400)
        return
    end
    if data["操作"] == "冥念引安全" or data["操作"] == "冥念引违规" or data["操作"] == "冥念退安全" or data["操作"] == "冥念退违规" then
        local _____662F_5426_5B89_5168 = data["操作"] == "冥念引安全" or data["操作"] == "冥念退安全"
        local _____662F_5426_5FF5_5F15 = data["操作"] == "冥念引安全" or data["操作"] == "冥念引违规"
        local _____8DDD_79BB = _____662F_5426_5FF5_5F15 == _____662F_5426_5B89_5168 and 100 or 900
        SetUnitPosition(context["玩家英雄"], _____6D4B_8BD5_4E2D_5FC3X + _____8DDD_79BB, _____6D4B_8BD5_4E2D_5FC3Y)
        return
    end
    if data["操作"] == "冥念赶安全" or data["操作"] == "冥念赶违规" then
        local _____72B6_6001 = context["运行时"]["冥之念欲状态"]
        local ____opt_result_59
        if _____72B6_6001 ~= nil then
            ____opt_result_59 = _____72B6_6001["安全点列表"]
        end
        local ____opt_result_60
        if ____opt_result_59 ~= nil then
            ____opt_result_60 = ____opt_result_59[0]
        end
        local _____5B89_5168_70B9 = ____opt_result_60
        local _____662F_5426_5B89_5168 = data["操作"] == "冥念赶安全"
        if _____662F_5426_5B89_5168 and _____5B89_5168_70B9 ~= nil then
            SetUnitPosition(context["玩家英雄"], _____5B89_5168_70B9.X, _____5B89_5168_70B9.Y)
        else
            SetUnitPosition(context["玩家英雄"], _____6D4B_8BD5_4E2D_5FC3X, _____6D4B_8BD5_4E2D_5FC3Y)
        end
        return
    end
    local _____72B6_6001 = context["运行时"]["邪狱追魂状态"]
    local _____9501_94FE_5217_8868 = _____72B6_6001 ~= nil and _____72B6_6001["锁链列表"] ~= nil and _____72B6_6001["锁链列表"] or ({})
    local submitted = 0
    do
        local i = 0
        while i < #_____9501_94FE_5217_8868 do
            do
                local _____9501_94FE = _____9501_94FE_5217_8868[i + 1]
                local ____temp_61
                if _____9501_94FE ~= nil then
                    ____temp_61 = _____9501_94FE["机制实例"]
                else
                    ____temp_61 = nil
                end
                local _____673A_5236_5B9E_4F8B = ____temp_61
                local ____temp_62
                if _____673A_5236_5B9E_4F8B ~= nil then
                    ____temp_62 = _____673A_5236_5B9E_4F8B["单位"]
                else
                    ____temp_62 = nil
                end
                local _____9501_94FE_5355_4F4D = ____temp_62
                if _____9501_94FE_5355_4F4D == nil or _____9501_94FE_5355_4F4D == 0 then
                    goto __continue58
                end
                do
                    local hit = 0
                    while hit < 2 do
                        if UnitDamageTarget(
                            context["玩家英雄"],
                            _____9501_94FE_5355_4F4D,
                            100000,
                            true,
                            false,
                            ATTACK_TYPE_NORMAL,
                            DAMAGE_TYPE_NORMAL,
                            WEAPON_TYPE_WHOKNOWS
                        ) then
                            submitted = submitted + 1
                        end
                        hit = hit + 1
                    end
                end
            end
            ::__continue58::
            i = i + 1
        end
    end
end
local jass = require("jass.common")
local globals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用")
local _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E = ____require_result_1["应用Boss战启动属性配置"]
local ____require_result_2 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local directRegisterPlayerHero = ____require_result_2.directRegisterPlayerHero
local ____require_result_3 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.13．教派学者.08．技能入口")
local _____6CE8_518C_6559_6D3E_5B66_8005_6280_80FD_7ED3_6784 = ____require_result_3["注册教派学者技能结构"]
local ____require_result_4 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.13．教派学者.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_6559_6D3E_5B66_8005_4E0A_4E0B_6587 = ____require_result_4["获取或创建教派学者上下文"]
local _____6E05_7406_6559_6D3E_5B66_8005_4E0A_4E0B_6587 = ____require_result_4["清理教派学者上下文"]
local ____require_result_5 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_5.addDelayedCallback
local ____require_result_6 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.13．教派学者.04．深渊之牢")
local _____91CA_653E_6559_6D3E_5B66_8005_6DF1_6E0A_4E4B_7262 = ____require_result_6["释放教派学者深渊之牢"]
local ____require_result_7 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.13．教派学者.05．冥神魔门")
local _____91CA_653E_6559_6D3E_5B66_8005_51A5_795E_9B54_95E8 = ____require_result_7["释放教派学者冥神魔门"]
local ____require_result_8 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.13．教派学者.06．冥之念欲")
local _____91CA_653E_6559_6D3E_5B66_8005_51A5_4E4B_5FF5_6B32 = ____require_result_8["释放教派学者冥之念欲"]
local ____require_result_9 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.13．教派学者.07．邪狱追魂冥法")
local _____91CA_653E_6559_6D3E_5B66_8005_90AA_72F1_8FFD_9B42_51A5_6CD5 = ____require_result_9["释放教派学者邪狱追魂冥法"]
local ____require_result_10 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.13．教派学者.03．暗影索命")
local _____521B_5EFA_6559_6D3E_5B66_8005_6697_5F71_5F39_5E55 = ____require_result_10["创建教派学者暗影弹幕"]
local ____require_result_11 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.13．教派学者.02．数值与表现配置")
local _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E = ____require_result_11["教派学者技能配置"]
local ____require_result_12 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.index")
local _____83B7_53D6_539F_751F_5F39_5E55 = ____require_result_12["获取原生弹幕"]
local ____require_result_13 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_13["读取单位攻击力"]
local ____require_result_14 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____6CE8_518CBoss_6280_80FD_6D4B_8BD5_76EE_6807 = ____require_result_14["注册Boss技能测试目标"]
local _____6CE8_9500Boss_6280_80FD_6D4B_8BD5_76EE_6807 = ____require_result_14["注销Boss技能测试目标"]
local ____require_result_15 = require("系统.12．测试系统.00．测试系统辅助函数")
local _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97 = ____require_result_15["标记测试Boss跳过死亡结算"]
local ____require_result_16 = require("系统.12．测试系统.00．Boss测试系统.index")
local ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B = ____require_result_16["Boss测试单位存活"]
local _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4 = ____require_result_16["获取Boss测试玩家基准英雄"]
local _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840 = ____require_result_16["设置Boss测试单位满血"]
local _____79FB_9664Boss_6D4B_8BD5_5355_4F4D = ____require_result_16["移除Boss测试单位"]
local _____6CE8_518CBoss_6D4B_8BD5_547D_4EE4_7EC4 = ____require_result_16["注册Boss测试命令组"]
local CreateUnit = jass.CreateUnit
local Player = jass.Player
local GetPlayerId = jass.GetPlayerId
local GetHandleId = jass.GetHandleId
GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
SetUnitPosition = jass.SetUnitPosition
local SetUnitFacing = jass.SetUnitFacing
UnitDamageTarget = jass.UnitDamageTarget
ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
UNIT_STATE_MANA = jass.UNIT_STATE_MANA
local UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
local _____6559_6D3E_5B66_8005_5355_4F4DID = stringToFourCCSafe("N05M")
_____6D4B_8BD5_4E2D_5FC3X = -540.6
_____6D4B_8BD5_4E2D_5FC3Y = -2495.2
local _____4E2D_7ACB_654C_5BF9_73A9_5BB6ID = 12
local _____6700_8FD1Boss = {}
local function _____91CD_7F6E_6559_6D3E_5B66_8005_6D4B_8BD5_7AD9_4F4D(context)
    SetUnitPosition(context["Boss单位"], _____6D4B_8BD5_4E2D_5FC3X, _____6D4B_8BD5_4E2D_5FC3Y)
    SetUnitFacing(context["Boss单位"], 270)
    SetUnitPosition(context["玩家英雄"], _____6D4B_8BD5_4E2D_5FC3X - 450, _____6D4B_8BD5_4E2D_5FC3Y)
    SetUnitFacing(context["玩家英雄"], 90)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(context["Boss单位"], 100000)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(context["玩家英雄"], 100000)
end
local function _____521B_5EFA_6216_83B7_53D6_6559_6D3E_5B66_8005_6D4B_8BD5_4E0A_4E0B_6587(player)
    local playerId = GetPlayerId(player)
    local _____73A9_5BB6_82F1_96C4 = _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4(player)
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(_____73A9_5BB6_82F1_96C4) then
        return nil
    end
    _____6CE8_518C_6559_6D3E_5B66_8005_6280_80FD_7ED3_6784()
    directRegisterPlayerHero(player, _____73A9_5BB6_82F1_96C4)
    _____6CE8_518CBoss_6280_80FD_6D4B_8BD5_76EE_6807(_____73A9_5BB6_82F1_96C4)
    local boss = _____6700_8FD1Boss[playerId]
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) then
        boss = CreateUnit(
            Player(_____4E2D_7ACB_654C_5BF9_73A9_5BB6ID),
            _____6559_6D3E_5B66_8005_5355_4F4DID,
            _____6D4B_8BD5_4E2D_5FC3X,
            _____6D4B_8BD5_4E2D_5FC3Y,
            270
        )
        _____6700_8FD1Boss[playerId] = boss
    end
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) then
        return nil
    end
    _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E(boss)
    _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97(boss)
    local _____8FD0_884C_65F6 = _____83B7_53D6_6216_521B_5EFA_6559_6D3E_5B66_8005_4E0A_4E0B_6587(boss)
    if _____8FD0_884C_65F6 == nil then
        return nil
    end
    local context = {["Boss单位"] = boss, ["玩家英雄"] = _____73A9_5BB6_82F1_96C4, ["运行时"] = _____8FD0_884C_65F6}
    _____91CD_7F6E_6559_6D3E_5B66_8005_6D4B_8BD5_7AD9_4F4D(context)
    globals.udg_Boss = boss
    return context
end
local function _____6E05_7406_6559_6D3E_5B66_8005_6D4B_8BD5_4E0A_4E0B_6587(player, context)
    local playerId = GetPlayerId(player)
    _____6CE8_9500Boss_6280_80FD_6D4B_8BD5_76EE_6807(context and context["玩家英雄"])
    if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(context and context["Boss单位"]) then
        _____6E05_7406_6559_6D3E_5B66_8005_4E0A_4E0B_6587(context["Boss单位"])
    end
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____6700_8FD1Boss[playerId])
    _____6700_8FD1Boss[playerId] = nil
    if globals.udg_Boss == (context and context["Boss单位"]) then
        globals.udg_Boss = nil
    end
end
local function _____6D4B_8BD5_6697_5F71_7D22_547D_88AB_52A8(_player, context)
    _____91CD_7F6E_6559_6D3E_5B66_8005_6D4B_8BD5_7AD9_4F4D(context)
    local _____662F_5426_9020_6210_4F24_5BB3 = UnitDamageTarget(
        context["Boss单位"],
        context["玩家英雄"],
        200,
        true,
        false,
        ATTACK_TYPE_NORMAL,
        DAMAGE_TYPE_NORMAL,
        WEAPON_TYPE_WHOKNOWS
    )
end
local function _____6D4B_8BD5_6697_5F71_7D22_547D_51FB_843D_6062_590D(_player, context)
    _____91CD_7F6E_6559_6D3E_5B66_8005_6D4B_8BD5_7AD9_4F4D(context)
    local _____73A9_5BB6_82F1_96C4 = context["玩家英雄"]
    local _____653B_51FB_529B = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____73A9_5BB6_82F1_96C4)
    local _____6700_5927_751F_547D_503C = GetUnitState(_____73A9_5BB6_82F1_96C4, UNIT_STATE_MAX_LIFE)
    local _____6700_5927_9B54_6CD5_503C = GetUnitState(_____73A9_5BB6_82F1_96C4, UNIT_STATE_MAX_MANA)
    local _____539F_59CB_751F_547D_6062_590D = _____653B_51FB_529B * 0.5
    local _____539F_59CB_9B54_6CD5_6062_590D = _____653B_51FB_529B * 0.25
    local _____751F_547D_503C_524D = _____6700_5927_751F_547D_503C > _____539F_59CB_751F_547D_6062_590D and _____6700_5927_751F_547D_503C - _____539F_59CB_751F_547D_6062_590D or _____6700_5927_751F_547D_503C * 0.5
    local _____9B54_6CD5_503C_524D = _____6700_5927_9B54_6CD5_503C > _____539F_59CB_9B54_6CD5_6062_590D and _____6700_5927_9B54_6CD5_503C - _____539F_59CB_9B54_6CD5_6062_590D or _____6700_5927_9B54_6CD5_503C * 0.5
    SetUnitState(_____73A9_5BB6_82F1_96C4, UNIT_STATE_LIFE, _____751F_547D_503C_524D)
    SetUnitState(_____73A9_5BB6_82F1_96C4, UNIT_STATE_MANA, _____9B54_6CD5_503C_524D)
    local _____5F39_5E55ID = _____521B_5EFA_6559_6D3E_5B66_8005_6697_5F71_5F39_5E55(context["运行时"], 0, _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["暗影索命"]["普攻弹幕缩放"], "普通攻击")
    local ____temp_23
    if _____5F39_5E55ID > 0 then
        ____temp_23 = _____83B7_53D6_539F_751F_5F39_5E55(_____5F39_5E55ID)
    else
        ____temp_23 = nil
    end
    local _____5B9E_4F8B = ____temp_23
    local ____temp_24
    if _____5B9E_4F8B ~= nil then
        ____temp_24 = _____5B9E_4F8B["弹幕单位"]
    else
        ____temp_24 = nil
    end
    local _____8F7D_4F53_5355_4F4D = ____temp_24
    if _____8F7D_4F53_5355_4F4D == nil or _____8F7D_4F53_5355_4F4D == 0 then
        return
    end
    local callbackId = addDelayedCallback(100, ____on_6559_6D3E_5B66_8005_6697_5F71_7D22_547D_51FB_843D_6062_590D_68C0_67E5, {
        ["上下文"] = context,
        ["弹幕ID"] = _____5F39_5E55ID,
        ["载体单位"] = _____8F7D_4F53_5355_4F4D,
        ["攻击力"] = _____653B_51FB_529B,
        ["生命值前"] = _____751F_547D_503C_524D,
        ["魔法值前"] = _____9B54_6CD5_503C_524D,
        ["原始生命恢复"] = _____539F_59CB_751F_547D_6062_590D,
        ["原始魔法恢复"] = _____539F_59CB_9B54_6CD5_6062_590D
    })
    local ____self_25 = context["运行时"]["清理"]
    ____self_25["登记延迟回调"](____self_25, "教派学者测试-暗影索命击落恢复检查", callbackId)
    local submitted = UnitDamageTarget(
        _____73A9_5BB6_82F1_96C4,
        _____8F7D_4F53_5355_4F4D,
        100000000,
        true,
        false,
        ATTACK_TYPE_NORMAL,
        DAMAGE_TYPE_NORMAL,
        WEAPON_TYPE_WHOKNOWS
    )
end
local function _____6D4B_8BD5_6DF1_6E0A_4E4B_7262(_player, context)
    _____91CD_7F6E_6559_6D3E_5B66_8005_6D4B_8BD5_7AD9_4F4D(context)
    local _____662F_5426_5F00_59CB = _____91CA_653E_6559_6D3E_5B66_8005_6DF1_6E0A_4E4B_7262(context["运行时"], context["玩家英雄"])
    if _____662F_5426_5F00_59CB then
        local callbackId = addDelayedCallback(1900, ____on_6559_6D3E_5B66_8005_5EF6_8FDF_6D4B_8BD5, {["上下文"] = context, ["操作"] = "深渊之牢安全检查"})
        local ____self_26 = context["运行时"]["清理"]
        ____self_26["登记延迟回调"](____self_26, "教派学者测试-深渊之牢安全检查", callbackId)
    end
end
local function _____6D4B_8BD5_6DF1_6E0A_4E4B_7262_79BB_5F00(_player, context)
    _____91CD_7F6E_6559_6D3E_5B66_8005_6D4B_8BD5_7AD9_4F4D(context)
    local _____662F_5426_5F00_59CB = _____91CA_653E_6559_6D3E_5B66_8005_6DF1_6E0A_4E4B_7262(context["运行时"], context["玩家英雄"])
    if _____662F_5426_5F00_59CB then
        local callbackId = addDelayedCallback(500, ____on_6559_6D3E_5B66_8005_5EF6_8FDF_6D4B_8BD5, {["上下文"] = context, ["操作"] = "深渊之牢离开"})
        local ____self_27 = context["运行时"]["清理"]
        ____self_27["登记延迟回调"](____self_27, "教派学者测试-深渊之牢离开", callbackId)
    end
end
local function _____6D4B_8BD5_51A5_795E_9B54_95E8(_player, context)
    _____91CD_7F6E_6559_6D3E_5B66_8005_6D4B_8BD5_7AD9_4F4D(context)
    local _____662F_5426_5F00_59CB = _____91CA_653E_6559_6D3E_5B66_8005_51A5_795E_9B54_95E8(context["运行时"])
    if _____662F_5426_5F00_59CB then
        local callbackId = addDelayedCallback(1500, ____on_6559_6D3E_5B66_8005_5EF6_8FDF_6D4B_8BD5, {["上下文"] = context, ["操作"] = "冥神魔门创建检查"})
        local ____self_28 = context["运行时"]["清理"]
        ____self_28["登记延迟回调"](____self_28, "教派学者测试-冥神魔门创建检查", callbackId)
    end
end
local function _____6D4B_8BD5_51A5_795E_9B54_95E8_6467_6BC1(_player, context)
    _____91CD_7F6E_6559_6D3E_5B66_8005_6D4B_8BD5_7AD9_4F4D(context)
    local _____662F_5426_5F00_59CB = _____91CA_653E_6559_6D3E_5B66_8005_51A5_795E_9B54_95E8(context["运行时"])
    if _____662F_5426_5F00_59CB then
        local callbackId = addDelayedCallback(700, ____on_6559_6D3E_5B66_8005_5EF6_8FDF_6D4B_8BD5, {["上下文"] = context, ["操作"] = "冥神魔门摧毁"})
        local ____self_29 = context["运行时"]["清理"]
        ____self_29["登记延迟回调"](____self_29, "教派学者测试-冥神魔门摧毁", callbackId)
    end
end
local function _____6D4B_8BD5_51A5_4E4B_5FF5_6B32(_player, context)
    _____91CD_7F6E_6559_6D3E_5B66_8005_6D4B_8BD5_7AD9_4F4D(context)
    local _____662F_5426_5F00_59CB = _____91CA_653E_6559_6D3E_5B66_8005_51A5_4E4B_5FF5_6B32(context["运行时"])
    if _____662F_5426_5F00_59CB then
        local callbackId = addDelayedCallback(3000, ____on_6559_6D3E_5B66_8005_5EF6_8FDF_6D4B_8BD5, {["上下文"] = context, ["操作"] = "冥念随机结束检查"})
        local ____self_30 = context["运行时"]["清理"]
        ____self_30["登记延迟回调"](____self_30, "教派学者测试-冥念随机结束检查", callbackId)
    end
end
local function _____6D4B_8BD5_51A5_4E4B_5FF5_6B32_8FDD_89C4_4F4D_7F6E(_player, context)
    _____91CD_7F6E_6559_6D3E_5B66_8005_6D4B_8BD5_7AD9_4F4D(context)
    local _____662F_5426_5F00_59CB = _____91CA_653E_6559_6D3E_5B66_8005_51A5_4E4B_5FF5_6B32(context["运行时"])
    if _____662F_5426_5F00_59CB then
        local callbackId = addDelayedCallback(500, ____on_6559_6D3E_5B66_8005_5EF6_8FDF_6D4B_8BD5, {["上下文"] = context, ["操作"] = "冥念违规位置"})
        local ____self_31 = context["运行时"]["清理"]
        ____self_31["登记延迟回调"](____self_31, "教派学者测试-冥念违规位置", callbackId)
    end
end
local function _____6D4B_8BD5_6307_5B9A_51A5_4E4B_5FF5(_player, context, _____7C7B_578B, _____662F_5426_6D4B_8BD5_5B89_5168_4F4D_7F6E)
    _____91CD_7F6E_6559_6D3E_5B66_8005_6D4B_8BD5_7AD9_4F4D(context)
    local _____662F_5426_5F00_59CB = _____91CA_653E_6559_6D3E_5B66_8005_51A5_4E4B_5FF5_6B32(context["运行时"], _____7C7B_578B)
    local _____64CD_4F5C = _____7C7B_578B == "念引" and (_____662F_5426_6D4B_8BD5_5B89_5168_4F4D_7F6E and "冥念引安全" or "冥念引违规") or (_____7C7B_578B == "念退" and (_____662F_5426_6D4B_8BD5_5B89_5168_4F4D_7F6E and "冥念退安全" or "冥念退违规") or (_____662F_5426_6D4B_8BD5_5B89_5168_4F4D_7F6E and "冥念赶安全" or "冥念赶违规"))
    if _____662F_5426_5F00_59CB then
        local callbackId = addDelayedCallback(500, ____on_6559_6D3E_5B66_8005_5EF6_8FDF_6D4B_8BD5, {["上下文"] = context, ["操作"] = _____64CD_4F5C})
        local ____self_32 = context["运行时"]["清理"]
        ____self_32["登记延迟回调"](____self_32, "教派学者测试-" .. _____64CD_4F5C, callbackId)
    end
end
local function _____6D4B_8BD5_51A5_4E4B_5FF5_5F15_5B89_5168(player, context)
    _____6D4B_8BD5_6307_5B9A_51A5_4E4B_5FF5(player, context, "念引", true)
end
local function _____6D4B_8BD5_51A5_4E4B_5FF5_5F15_8FDD_89C4(player, context)
    _____6D4B_8BD5_6307_5B9A_51A5_4E4B_5FF5(player, context, "念引", false)
end
local function _____6D4B_8BD5_51A5_4E4B_5FF5_9000_5B89_5168(player, context)
    _____6D4B_8BD5_6307_5B9A_51A5_4E4B_5FF5(player, context, "念退", true)
end
local function _____6D4B_8BD5_51A5_4E4B_5FF5_9000_8FDD_89C4(player, context)
    _____6D4B_8BD5_6307_5B9A_51A5_4E4B_5FF5(player, context, "念退", false)
end
local function _____6D4B_8BD5_51A5_4E4B_5FF5_8D76_5B89_5168(player, context)
    _____6D4B_8BD5_6307_5B9A_51A5_4E4B_5FF5(player, context, "念赶", true)
end
local function _____6D4B_8BD5_51A5_4E4B_5FF5_8D76_8FDD_89C4(player, context)
    _____6D4B_8BD5_6307_5B9A_51A5_4E4B_5FF5(player, context, "念赶", false)
end
local function _____6D4B_8BD5_90AA_72F1_8FFD_9B42_51A5_6CD5(_player, context)
    _____91CD_7F6E_6559_6D3E_5B66_8005_6D4B_8BD5_7AD9_4F4D(context)
    local _____662F_5426_5F00_59CB = _____91CA_653E_6559_6D3E_5B66_8005_90AA_72F1_8FFD_9B42_51A5_6CD5(context["运行时"])
    if _____662F_5426_5F00_59CB then
        local callbackId = addDelayedCallback(1300, ____on_6559_6D3E_5B66_8005_5EF6_8FDF_6D4B_8BD5, {["上下文"] = context, ["操作"] = "邪狱追魂状态检查"})
        local ____self_33 = context["运行时"]["清理"]
        ____self_33["登记延迟回调"](____self_33, "教派学者测试-邪狱追魂状态检查", callbackId)
    end
end
local function _____6D4B_8BD5_90AA_72F1_9501_94FE_51FB_7834(_player, context)
    _____91CD_7F6E_6559_6D3E_5B66_8005_6D4B_8BD5_7AD9_4F4D(context)
    local _____662F_5426_5F00_59CB = _____91CA_653E_6559_6D3E_5B66_8005_90AA_72F1_8FFD_9B42_51A5_6CD5(context["运行时"])
    if _____662F_5426_5F00_59CB then
        local callbackId = addDelayedCallback(700, ____on_6559_6D3E_5B66_8005_5EF6_8FDF_6D4B_8BD5, {["上下文"] = context, ["操作"] = "邪狱锁链击破"})
        local ____self_34 = context["运行时"]["清理"]
        ____self_34["登记延迟回调"](____self_34, "教派学者测试-邪狱锁链击破", callbackId)
    end
end
local _____6559_6D3E_5B66_8005_6D4B_8BD5_6280_80FD_5217_8868 = {
    {["序号"] = 1, ["命令"] = "学者1", ["名称"] = "暗影索命真实普攻", ["执行"] = _____6D4B_8BD5_6697_5F71_7D22_547D_88AB_52A8},
    {["序号"] = 1, ["命令"] = "学者1-2", ["名称"] = "暗影弹幕击落恢复", ["执行"] = _____6D4B_8BD5_6697_5F71_7D22_547D_51FB_843D_6062_590D},
    {["序号"] = 2, ["命令"] = "学者2", ["名称"] = "深渊之牢", ["执行"] = _____6D4B_8BD5_6DF1_6E0A_4E4B_7262},
    {["序号"] = 2, ["命令"] = "学者2-2", ["名称"] = "深渊之牢离开分支", ["执行"] = _____6D4B_8BD5_6DF1_6E0A_4E4B_7262_79BB_5F00},
    {["序号"] = 3, ["命令"] = "学者3", ["名称"] = "冥神魔门", ["执行"] = _____6D4B_8BD5_51A5_795E_9B54_95E8},
    {["序号"] = 3, ["命令"] = "学者3-2", ["名称"] = "冥神魔门摧毁", ["执行"] = _____6D4B_8BD5_51A5_795E_9B54_95E8_6467_6BC1},
    {["序号"] = 4, ["命令"] = "学者4", ["名称"] = "冥之念欲", ["执行"] = _____6D4B_8BD5_51A5_4E4B_5FF5_6B32},
    {["序号"] = 4, ["命令"] = "学者4-2", ["名称"] = "冥之念欲违规位置", ["执行"] = _____6D4B_8BD5_51A5_4E4B_5FF5_6B32_8FDD_89C4_4F4D_7F6E},
    {["序号"] = 4, ["命令"] = "学者4-3", ["名称"] = "冥之念引安全", ["执行"] = _____6D4B_8BD5_51A5_4E4B_5FF5_5F15_5B89_5168},
    {["序号"] = 4, ["命令"] = "学者4-4", ["名称"] = "冥之念引违规", ["执行"] = _____6D4B_8BD5_51A5_4E4B_5FF5_5F15_8FDD_89C4},
    {["序号"] = 4, ["命令"] = "学者4-5", ["名称"] = "冥之念退安全", ["执行"] = _____6D4B_8BD5_51A5_4E4B_5FF5_9000_5B89_5168},
    {["序号"] = 4, ["命令"] = "学者4-6", ["名称"] = "冥之念退违规", ["执行"] = _____6D4B_8BD5_51A5_4E4B_5FF5_9000_8FDD_89C4},
    {["序号"] = 4, ["命令"] = "学者4-7", ["名称"] = "冥之念赶安全", ["执行"] = _____6D4B_8BD5_51A5_4E4B_5FF5_8D76_5B89_5168},
    {["序号"] = 4, ["命令"] = "学者4-8", ["名称"] = "冥之念赶违规", ["执行"] = _____6D4B_8BD5_51A5_4E4B_5FF5_8D76_8FDD_89C4},
    {["序号"] = 5, ["命令"] = "学者5", ["名称"] = "邪狱追魂冥法", ["执行"] = _____6D4B_8BD5_90AA_72F1_8FFD_9B42_51A5_6CD5},
    {["序号"] = 5, ["命令"] = "学者5-2", ["名称"] = "邪狱锁链击破", ["执行"] = _____6D4B_8BD5_90AA_72F1_9501_94FE_51FB_7834}
}
_____6CE8_518CBoss_6D4B_8BD5_547D_4EE4_7EC4({
    ["命令单位名"] = "教派学者",
    ["Boss名称"] = "蒙面人（学者姿态）",
    ["场地"] = {["正式中心"] = {x = _____6D4B_8BD5_4E2D_5FC3X, y = _____6D4B_8BD5_4E2D_5FC3Y}, ["测试空地中心"] = {x = _____6D4B_8BD5_4E2D_5FC3X, y = _____6D4B_8BD5_4E2D_5FC3Y}},
    ["创建或获取上下文"] = _____521B_5EFA_6216_83B7_53D6_6559_6D3E_5B66_8005_6D4B_8BD5_4E0A_4E0B_6587,
    ["清理上下文"] = _____6E05_7406_6559_6D3E_5B66_8005_6D4B_8BD5_4E0A_4E0B_6587,
    ["技能命令列表"] = _____6559_6D3E_5B66_8005_6D4B_8BD5_6280_80FD_5217_8868
})
return ____exports
