--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local stringToFourCC
function stringToFourCC(s)
    return (string.byte(s, 1) or 0 / 0) * 16777216 + (string.byte(s, 2) or 0 / 0) * 65536 + (string.byte(s, 3) or 0 / 0) * 256 + (string.byte(s, 4) or 0 / 0)
end
local jass = require("jass.common")
local japi = require("jass.japi")
local globals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.BJ函数.index")
local SelectUnitForPlayerSingle = ____require_result_0.SelectUnitForPlayerSingle
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数")
local StarOther_PanCameraToTimedForPlayer = ____require_result_1.StarOther_PanCameraToTimedForPlayer
local ____require_result_2 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用")
local _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E = ____require_result_2["应用Boss战启动属性配置"]
local ____require_result_3 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.03．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_5DF4_5C14_624E_7F57_65AF_4E0A_4E0B_6587 = ____require_result_3["获取或创建巴尔扎罗斯上下文"]
local _____6E05_7406_5DF4_5C14_624E_7F57_65AF_4E0A_4E0B_6587 = ____require_result_3["清理巴尔扎罗斯上下文"]
local _____6CE8_518C_5DF4_5C14_624E_7F57_65AF_8FD0_884C_65F6 = ____require_result_3["注册巴尔扎罗斯运行时"]
local ____require_result_4 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.15．技能入口")
local _____6CE8_518C_5DF4_5C14_624E_7F57_65AF_6280_80FD_7ED3_6784 = ____require_result_4["注册巴尔扎罗斯技能结构"]
local ____require_result_5 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.04．熔核封印与护卫机制")
local _____521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_7194_6838_5C01_5370_4E0E_62A4_536B_673A_5236 = ____require_result_5["初始化巴尔扎罗斯熔核封印与护卫机制"]
local ____require_result_6 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.01．护卫A格鲁姆.index")
local _____521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_683C_9C81_59C6_6280_80FD = ____require_result_6["初始化巴尔扎罗斯格鲁姆技能"]
local ____require_result_7 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.02．护卫B塞拉.index")
local _____521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_585E_62C9_6280_80FD = ____require_result_7["初始化巴尔扎罗斯塞拉技能"]
local ____require_result_8 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.11．地核召唤")
local _____521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_5730_6838_53EC_5524_8282_70B9 = ____require_result_8["初始化巴尔扎罗斯地核召唤节点"]
local _____91CA_653E_5DF4_5C14_624E_7F57_65AF_5730_6838_53EC_5524 = ____require_result_8["释放巴尔扎罗斯地核召唤"]
local ____require_result_9 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.12．熔岩护盾")
local _____521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_7194_5CA9_62A4_76FE_8282_70B9 = ____require_result_9["初始化巴尔扎罗斯熔岩护盾节点"]
local _____91CA_653E_5DF4_5C14_624E_7F57_65AF_7194_5CA9_62A4_76FE = ____require_result_9["释放巴尔扎罗斯熔岩护盾"]
local ____require_result_10 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.13．末日熔爆")
local _____521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_672B_65E5_7194_7206_8282_70B9 = ____require_result_10["初始化巴尔扎罗斯末日熔爆节点"]
local _____91CA_653E_5DF4_5C14_624E_7F57_65AF_672B_65E5_7194_7206 = ____require_result_10["释放巴尔扎罗斯末日熔爆"]
local ____require_result_11 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.07．恶魔咆哮波")
local _____91CA_653E_5DF4_5C14_624E_7F57_65AF_6076_9B54_5486_54EE_6CE2 = ____require_result_11["释放巴尔扎罗斯恶魔咆哮波"]
local _____91CA_653E_5DF4_5C14_624E_7F57_65AF_62A4_536B_6A21_4EFF_6076_9B54_5486_54EE_6CE2 = ____require_result_11["释放巴尔扎罗斯护卫模仿恶魔咆哮波"]
local ____require_result_12 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.08．王者天罚")
local _____91CA_653E_5DF4_5C14_624E_7F57_65AF_738B_8005_5929_7F5A = ____require_result_12["释放巴尔扎罗斯王者天罚"]
local ____require_result_13 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.09．熔岩喷发")
local _____91CA_653E_5DF4_5C14_624E_7F57_65AF_7194_5CA9_55B7_53D1 = ____require_result_13["释放巴尔扎罗斯熔岩喷发"]
local ____require_result_14 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.10．火焰锁链")
local _____91CA_653E_5DF4_5C14_624E_7F57_65AF_706B_7130_9501_94FE = ____require_result_14["释放巴尔扎罗斯火焰锁链"]
local ____require_result_15 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.01．护卫A格鲁姆.index")
local _____91CA_653E_683C_9C81_59C6_91CD_9524 = ____require_result_15["释放格鲁姆重锤"]
local _____91CA_653E_683C_9C81_59C6_706B_5F84 = ____require_result_15["释放格鲁姆火径"]
local _____89E6_53D1_683C_9C81_59C6_7099_70ED_5949_732E = ____require_result_15["触发格鲁姆炙热奉献"]
local _____4E2D_65AD_683C_9C81_59C6_7099_70ED_5949_732E = ____require_result_15["中断格鲁姆炙热奉献"]
local ____require_result_16 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.02．护卫B塞拉.index")
local _____91CA_653E_51B0_7130_53CC_661F = ____require_result_16["释放冰焰双星"]
local _____91CA_653E_7EDD_5BF9_96F6_5EA6_9886_57DF = ____require_result_16["释放绝对零度领域"]
local _____5207_6362_585E_62C9_5F62_6001 = ____require_result_16["切换塞拉形态"]
local ____require_result_17 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.01．场地配置")
local _____5DF4_5C14_624E_7F57_65AF_6218_6597_533A_57DF_914D_7F6E = ____require_result_17["巴尔扎罗斯战斗区域配置"]
local _____5DF4_5C14_624E_7F57_65AF_56FA_5B9A_5B89_5168_533A_914D_7F6E_8868 = ____require_result_17["巴尔扎罗斯固定安全区配置表"]
local ____require_result_18 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.02．数值与表现配置")
local _____5DF4_5C14_624E_7F57_65AF_62A4_536B_914D_7F6E = ____require_result_18["巴尔扎罗斯护卫配置"]
local _____5DF4_5C14_624E_7F57_65AF_9636_6BB5_9608_503C = ____require_result_18["巴尔扎罗斯阶段阈值"]
local _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E = ____require_result_18["巴尔扎罗斯技能数值配置"]
local ____require_result_19 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.00．配置")
local _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____require_result_19["巴尔扎罗斯单位技能配置"]
local ____require_result_20 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾")
local _____79FB_9664_5355_4F4D_6807_7B7E_62A4_76FE = ____require_result_20["移除单位标签护盾"]
local ____require_result_21 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_21.registerManualBuff
local ____require_result_22 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_22.addDelayedCallback
local removeDelayedCallback = ____require_result_22.removeDelayedCallback
local ____require_result_23 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.02．战斗区域.index")
local _____521B_5EFA_52A8_6001_77E9_5F62_533A_57DF_7EC4 = ____require_result_23["创建动态矩形区域组"]
local _____9500_6BC1_52A8_6001_77E9_5F62_533A_57DF_7EC4 = ____require_result_23["销毁动态矩形区域组"]
local ____require_result_24 = require("系统.12．测试系统.00．测试系统辅助函数")
local _____521B_5EFA_6D4B_8BD5_4E2D_5FC3_5E73_79FB_6620_5C04 = ____require_result_24["创建测试中心平移映射"]
local _____6309_6D4B_8BD5_6620_5C04_5E73_79FB_77E9_5F62 = ____require_result_24["按测试映射平移矩形"]
local _____590D_5236_5E73_79FB_6D4B_8BD5_77E9_5F62_6570_7EC4 = ____require_result_24["复制平移测试矩形数组"]
local _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97 = ____require_result_24["标记测试Boss跳过死亡结算"]
local ____require_result_25 = require("系统.12．测试系统.00．Boss测试系统.index")
local ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B = ____require_result_25["Boss测试单位存活"]
local _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840 = ____require_result_25["设置Boss测试单位满血"]
local _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4 = ____require_result_25["获取Boss测试玩家基准英雄"]
local _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_6B65_5175 = ____require_result_25["准备Boss测试固定步兵"]
local _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_5C71_4E18_4E4B_738B = ____require_result_25["准备Boss测试固定山丘之王"]
local _____79FB_9664Boss_6D4B_8BD5_5355_4F4D = ____require_result_25["移除Boss测试单位"]
local _____6CE8_518CBoss_6D4B_8BD5_547D_4EE4_7EC4 = ____require_result_25["注册Boss测试命令组"]
local _____5DF4_5C14_624E_7F57_65AF_5355_4F4DID = stringToFourCC("N03G")
local _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X = -540.6
local _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y = -2495.2
local _____4E34_65F6_6D4B_8BD5_73A9_5BB6X = -540.6
local _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y = -3055.2
local _____5DF4_5C14_624E_7F57_65AF_6D4B_8BD5_7981_7528_62A4_536B = false
local _____5DF4_5C14_624E_7F57_65AF_6D4B_8BD5_7981_7528_62A4_536B_4E3B_52A8_6280_80FD = false
local _____5DF4_5C14_624E_7F57_65AF_6D4B_8BD5_7981_7528_683C_9C81_59C6_4E3B_52A8_6280_80FD = false
local _____5DF4_5C14_624E_7F57_65AF_6D4B_8BD5_7981_7528_585E_62C9_4E3B_52A8_6280_80FD = false
local _____5DF4_5C14_624E_7F57_65AF_6D4B_8BD5_7981_7528_683C_9C81_59C6_666E_653B = false
local _____5DF4_5C14_624E_7F57_65AF_6D4B_8BD5_7981_7528_585E_62C9_666E_653B = false
local CreateUnit = jass.CreateUnit
local SetHeroLevel = jass.SetHeroLevel
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local SetUnitFacing = jass.SetUnitFacing
local SetUnitPosition = jass.SetUnitPosition
local SetUnitState = jass.SetUnitState
local GetUnitState = jass.GetUnitState
local SetUnitAcquireRange = jass.SetUnitAcquireRange
local IssueImmediateOrder = jass.IssueImmediateOrder
local GetPlayerId = jass.GetPlayerId
local UnitDamageTarget = jass.UnitDamageTarget
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local DAMAGE_TYPE_COLD = jass.DAMAGE_TYPE_COLD
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local DzUnitDisableAttack = japi.DzUnitDisableAttack
local _____6700_8FD1_6D4B_8BD5Boss = {}
local _____6700_8FD1_6D4B_8BD5_6B65_5175 = {}
local _____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B = {}
local _____7194_5CA9_62A4_76FE_8FD1_6218_6D4B_8BD5_56DE_8C03ID = 0
local _____7194_5CA9_62A4_76FE_51B0_971C_6D4B_8BD5_56DE_8C03ID = 0
local function _____5E94_7528_5DF4_5C14_624E_7F57_65AF_6D4B_8BD5_573A_5730(context)
    local _____6B63_5F0F_4E2D_5FC3X = (_____5DF4_5C14_624E_7F57_65AF_6218_6597_533A_57DF_914D_7F6E["左"] + _____5DF4_5C14_624E_7F57_65AF_6218_6597_533A_57DF_914D_7F6E["右"]) / 2
    local _____6B63_5F0F_4E2D_5FC3Y = (_____5DF4_5C14_624E_7F57_65AF_6218_6597_533A_57DF_914D_7F6E["下"] + _____5DF4_5C14_624E_7F57_65AF_6218_6597_533A_57DF_914D_7F6E["上"]) / 2
    local _____6620_5C04 = _____521B_5EFA_6D4B_8BD5_4E2D_5FC3_5E73_79FB_6620_5C04(_____6B63_5F0F_4E2D_5FC3X, _____6B63_5F0F_4E2D_5FC3Y, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y)
    local _____6D4B_8BD5_6218_6597_533A_57DF = _____6309_6D4B_8BD5_6620_5C04_5E73_79FB_77E9_5F62(_____5DF4_5C14_624E_7F57_65AF_6218_6597_533A_57DF_914D_7F6E, _____6620_5C04)
    _____9500_6BC1_52A8_6001_77E9_5F62_533A_57DF_7EC4(context["战斗区域组"])
    context["战斗区域组"] = _____521B_5EFA_52A8_6001_77E9_5F62_533A_57DF_7EC4("巴尔扎罗斯测试战斗区域", {_____6D4B_8BD5_6218_6597_533A_57DF})
    context["测试固定安全区配置表"] = _____590D_5236_5E73_79FB_6D4B_8BD5_77E9_5F62_6570_7EC4(_____5DF4_5C14_624E_7F57_65AF_56FA_5B9A_5B89_5168_533A_914D_7F6E_8868, _____6620_5C04)
end
local function _____53D6_5DF4_5C14_624E_7F57_65AF_6D4B_8BD5_573A_5730_6620_5C04()
    local _____6B63_5F0F_4E2D_5FC3X = (_____5DF4_5C14_624E_7F57_65AF_6218_6597_533A_57DF_914D_7F6E["左"] + _____5DF4_5C14_624E_7F57_65AF_6218_6597_533A_57DF_914D_7F6E["右"]) / 2
    local _____6B63_5F0F_4E2D_5FC3Y = (_____5DF4_5C14_624E_7F57_65AF_6218_6597_533A_57DF_914D_7F6E["下"] + _____5DF4_5C14_624E_7F57_65AF_6218_6597_533A_57DF_914D_7F6E["上"]) / 2
    return _____521B_5EFA_6D4B_8BD5_4E2D_5FC3_5E73_79FB_6620_5C04(_____6B63_5F0F_4E2D_5FC3X, _____6B63_5F0F_4E2D_5FC3Y, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y)
end
local function _____653E_7F6E_5DF4_5C14_624E_7F57_65AF_6D4B_8BD5_62A4_536B(context)
    local _____6620_5C04 = _____53D6_5DF4_5C14_624E_7F57_65AF_6D4B_8BD5_573A_5730_6620_5C04()
    if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(context["格鲁姆"]) then
        SetUnitPosition(context["格鲁姆"], _____5DF4_5C14_624E_7F57_65AF_62A4_536B_914D_7F6E["格鲁姆"].X + _____6620_5C04["偏移X"], _____5DF4_5C14_624E_7F57_65AF_62A4_536B_914D_7F6E["格鲁姆"].Y + _____6620_5C04["偏移Y"])
        SetUnitFacing(context["格鲁姆"], _____5DF4_5C14_624E_7F57_65AF_62A4_536B_914D_7F6E["格鲁姆"]["面向"])
        _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(context["格鲁姆"])
    end
    if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(context["塞拉"]) then
        SetUnitPosition(context["塞拉"], _____5DF4_5C14_624E_7F57_65AF_62A4_536B_914D_7F6E["塞拉"].X + _____6620_5C04["偏移X"], _____5DF4_5C14_624E_7F57_65AF_62A4_536B_914D_7F6E["塞拉"].Y + _____6620_5C04["偏移Y"])
        SetUnitFacing(context["塞拉"], _____5DF4_5C14_624E_7F57_65AF_62A4_536B_914D_7F6E["塞拉"]["面向"])
        _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(context["塞拉"])
    end
end
local function _____7981_7528_5DF4_5C14_624E_7F57_65AF_6D4B_8BD5_62A4_536B_666E_653B(guard)
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(guard) then
        return
    end
    SetUnitAcquireRange(guard, 0)
    if DzUnitDisableAttack ~= nil then
        DzUnitDisableAttack(guard, true)
    end
    IssueImmediateOrder(guard, "stop")
end
local function _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5Boss(player)
    local pid = GetPlayerId(player)
    local cached = _____6700_8FD1_6D4B_8BD5Boss[pid]
    if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(cached) then
        SetUnitPosition(cached, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y)
        SetUnitFacing(cached, 270)
        _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(cached)
        _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97(cached)
        globals.udg_Boss = cached
        return cached
    end
    local boss = CreateUnit(
        player,
        _____5DF4_5C14_624E_7F57_65AF_5355_4F4DID,
        _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X,
        _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y,
        270
    )
    if boss ~= nil and boss ~= 0 then
        _____6700_8FD1_6D4B_8BD5Boss[pid] = boss
        _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97(boss)
        SetHeroLevel(boss, 40, false)
        _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(boss)
        globals.udg_Boss = boss
    end
    return boss
end
local function _____51C6_5907_5DF4_5C14_624E_7F57_65AF_6D4B_8BD5_573A_666F(player, hero, boss)
    local pid = GetPlayerId(player)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(hero)
    _____6700_8FD1_6D4B_8BD5_6B65_5175[pid] = _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_6B65_5175(_____6700_8FD1_6D4B_8BD5_6B65_5175[pid], _____4E34_65F6_6D4B_8BD5_73A9_5BB6X - 220, _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y + 220, 90)
    _____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid] = _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_5C71_4E18_4E4B_738B(_____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid], _____4E34_65F6_6D4B_8BD5_73A9_5BB6X + 220, _____4E34_65F6_6D4B_8BD5_73A9_5BB6Y + 220, 90)
    SelectUnitForPlayerSingle(boss, player)
    StarOther_PanCameraToTimedForPlayer(player, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3X, _____4E34_65F6_6D4B_8BD5_573A_5730_4E2D_5FC3Y, 0.2)
    local context = _____83B7_53D6_6216_521B_5EFA_5DF4_5C14_624E_7F57_65AF_4E0A_4E0B_6587(boss)
    if context ~= nil then
        _____5E94_7528_5DF4_5C14_624E_7F57_65AF_6D4B_8BD5_573A_5730(context)
    end
    return context
end
local function _____521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_6D4B_8BD5_4E0A_4E0B_6587(context)
    _____6CE8_518C_5DF4_5C14_624E_7F57_65AF_8FD0_884C_65F6()
    _____6CE8_518C_5DF4_5C14_624E_7F57_65AF_6280_80FD_7ED3_6784()
    _____521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_7194_6838_5C01_5370_4E0E_62A4_536B_673A_5236(context, _____5DF4_5C14_624E_7F57_65AF_6D4B_8BD5_7981_7528_62A4_536B)
    if not _____5DF4_5C14_624E_7F57_65AF_6D4B_8BD5_7981_7528_62A4_536B then
        if not _____5DF4_5C14_624E_7F57_65AF_6D4B_8BD5_7981_7528_62A4_536B_4E3B_52A8_6280_80FD and not _____5DF4_5C14_624E_7F57_65AF_6D4B_8BD5_7981_7528_683C_9C81_59C6_4E3B_52A8_6280_80FD then
            _____521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_683C_9C81_59C6_6280_80FD(context)
        end
        if not _____5DF4_5C14_624E_7F57_65AF_6D4B_8BD5_7981_7528_62A4_536B_4E3B_52A8_6280_80FD and not _____5DF4_5C14_624E_7F57_65AF_6D4B_8BD5_7981_7528_585E_62C9_4E3B_52A8_6280_80FD then
            _____521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_585E_62C9_6280_80FD(context)
        end
        _____653E_7F6E_5DF4_5C14_624E_7F57_65AF_6D4B_8BD5_62A4_536B(context)
        if _____5DF4_5C14_624E_7F57_65AF_6D4B_8BD5_7981_7528_683C_9C81_59C6_666E_653B then
            _____7981_7528_5DF4_5C14_624E_7F57_65AF_6D4B_8BD5_62A4_536B_666E_653B(context["格鲁姆"])
        end
        if _____5DF4_5C14_624E_7F57_65AF_6D4B_8BD5_7981_7528_585E_62C9_666E_653B then
            _____7981_7528_5DF4_5C14_624E_7F57_65AF_6D4B_8BD5_62A4_536B_666E_653B(context["塞拉"])
        end
    end
    _____521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_5730_6838_53EC_5524_8282_70B9(context)
    _____521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_7194_5CA9_62A4_76FE_8282_70B9(context)
    _____521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_672B_65E5_7194_7206_8282_70B9(context)
    _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E(context["Boss单位"])
end
local function _____521B_5EFA_5E76_521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_6D4B_8BD5(player)
    local hero = _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4(player)
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(hero) then
        return nil
    end
    local boss = _____83B7_53D6_6216_521B_5EFA_6D4B_8BD5Boss(player)
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) then
        return nil
    end
    local context = _____51C6_5907_5DF4_5C14_624E_7F57_65AF_6D4B_8BD5_573A_666F(player, hero, boss)
    if context == nil then
        return nil
    end
    _____521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_6D4B_8BD5_4E0A_4E0B_6587(context)
    return context
end
local function _____6E05_7406_5DF4_5C14_624E_7F57_65AF_6D4B_8BD5(player, _context)
    local pid = GetPlayerId(player)
    local boss = _____6700_8FD1_6D4B_8BD5Boss[pid]
    if boss ~= nil and boss ~= 0 then
        _____6E05_7406_5DF4_5C14_624E_7F57_65AF_4E0A_4E0B_6587(boss)
    end
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____6700_8FD1_6D4B_8BD5_6B65_5175[pid])
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid])
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(boss)
    _____6700_8FD1_6D4B_8BD5_6B65_5175[pid] = nil
    _____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid] = nil
    _____6700_8FD1_6D4B_8BD5Boss[pid] = nil
    if globals.udg_Boss == boss then
        globals.udg_Boss = nil
    end
end
local function ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD1_6D4B_8BD5_547D_4EE4(_player, context)
    _____91CA_653E_5DF4_5C14_624E_7F57_65AF_6076_9B54_5486_54EE_6CE2(context)
end
local function ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD1_62A4_536B_6A21_4EFF_6D4B_8BD5_547D_4EE4(_player, context)
    _____91CA_653E_5DF4_5C14_624E_7F57_65AF_6076_9B54_5486_54EE_6CE2(context)
    _____91CA_653E_5DF4_5C14_624E_7F57_65AF_62A4_536B_6A21_4EFF_6076_9B54_5486_54EE_6CE2(context)
end
local function ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD2_6D4B_8BD5_547D_4EE4(_player, context)
    _____91CA_653E_5DF4_5C14_624E_7F57_65AF_738B_8005_5929_7F5A(context)
end
local function ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD2P3_6D4B_8BD5_547D_4EE4(_player, context)
    local boss = context["Boss单位"]
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) then
        return
    end
    SetUnitState(
        boss,
        UNIT_STATE_LIFE,
        GetUnitState(boss, UNIT_STATE_MAX_LIFE) * _____5DF4_5C14_624E_7F57_65AF_9636_6BB5_9608_503C["第三阶段生命比例"] * 0.5
    )
    context["阶段"] = 3
    _____91CA_653E_5DF4_5C14_624E_7F57_65AF_738B_8005_5929_7F5A(context)
end
local function ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD3_6D4B_8BD5_547D_4EE4(_player, context)
    _____91CA_653E_5DF4_5C14_624E_7F57_65AF_7194_5CA9_55B7_53D1(context)
end
local function ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD4_6D4B_8BD5_547D_4EE4(_player, context)
    _____91CA_653E_5DF4_5C14_624E_7F57_65AF_706B_7130_9501_94FE(context)
end
local function ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD4_8D85_8DDD_6D4B_8BD5_547D_4EE4(player, context)
    local boss = context["Boss单位"]
    local target = _____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[GetPlayerId(player)]
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) or not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(target) then
        return
    end
    SetUnitPosition(
        target,
        GetUnitX(boss) + 700,
        GetUnitY(boss)
    )
    SetUnitFacing(target, 180)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(target)
    _____91CA_653E_5DF4_5C14_624E_7F57_65AF_706B_7130_9501_94FE(context)
end
local function ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD5_6D4B_8BD5_547D_4EE4(_player, context)
    _____91CA_653E_5DF4_5C14_624E_7F57_65AF_5730_6838_53EC_5524(context)
end
local function ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD6_6D4B_8BD5_547D_4EE4(_player, context)
    _____91CA_653E_5DF4_5C14_624E_7F57_65AF_672B_65E5_7194_7206(context)
end
local function ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD7_6D4B_8BD5_547D_4EE4(player, context)
    local target = _____6700_8FD1_6D4B_8BD5_6B65_5175[GetPlayerId(player)]
    if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(context["格鲁姆"]) and ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(target) then
        _____91CA_653E_683C_9C81_59C6_91CD_9524(context, target)
    end
end
local function ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD8_6D4B_8BD5_547D_4EE4(player, context)
    local target = _____6700_8FD1_6D4B_8BD5_6B65_5175[GetPlayerId(player)]
    if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(context["格鲁姆"]) and ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(target) then
        _____91CA_653E_683C_9C81_59C6_706B_5F84(context, target)
    end
end
local function ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD9_6D4B_8BD5_547D_4EE4(player, context)
    local target = _____6700_8FD1_6D4B_8BD5_6B65_5175[GetPlayerId(player)]
    if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(context["塞拉"]) and ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(target) then
        _____91CA_653E_51B0_7130_53CC_661F(context, target)
    end
end
local function ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD10_6D4B_8BD5_547D_4EE4(player, context)
    local target = _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4(player)
    if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(context["塞拉"]) and ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(target) then
        _____91CA_653E_7EDD_5BF9_96F6_5EA6_9886_57DF(context, target)
    end
end
local function ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD11_6D4B_8BD5_547D_4EE4(_player, context)
    if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(context["塞拉"]) then
        _____5207_6362_585E_62C9_5F62_6001(context, "火焰", true)
    end
end
local function ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD12_6D4B_8BD5_547D_4EE4(_player, context)
    if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(context["塞拉"]) then
        _____5207_6362_585E_62C9_5F62_6001(context, "冰霜", true)
    end
end
local function _____53D6_6D88_5DF4_5C14_624E_7F57_65AF_7194_5CA9_62A4_76FE_6D4B_8BD5_56DE_8C03()
    if _____7194_5CA9_62A4_76FE_8FD1_6218_6D4B_8BD5_56DE_8C03ID > 0 then
        removeDelayedCallback(_____7194_5CA9_62A4_76FE_8FD1_6218_6D4B_8BD5_56DE_8C03ID)
    end
    if _____7194_5CA9_62A4_76FE_51B0_971C_6D4B_8BD5_56DE_8C03ID > 0 then
        removeDelayedCallback(_____7194_5CA9_62A4_76FE_51B0_971C_6D4B_8BD5_56DE_8C03ID)
    end
    _____7194_5CA9_62A4_76FE_8FD1_6218_6D4B_8BD5_56DE_8C03ID = 0
    _____7194_5CA9_62A4_76FE_51B0_971C_6D4B_8BD5_56DE_8C03ID = 0
end
local function _____91CD_7F6E_5DF4_5C14_624E_7F57_65AF_7194_5CA9_62A4_76FE_6D4B_8BD5(boss)
    _____53D6_6D88_5DF4_5C14_624E_7F57_65AF_7194_5CA9_62A4_76FE_6D4B_8BD5_56DE_8C03()
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) then
        return
    end
    _____79FB_9664_5355_4F4D_6807_7B7E_62A4_76FE(boss, _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["熔岩护盾"]["护盾标签"])
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(boss)
end
local function ____on_5DF4_5C14_624E_7F57_65AF_7194_5CA9_62A4_76FE_8FD1_6218_6D4B_8BD5_4F24_5BB3(variable)
    _____7194_5CA9_62A4_76FE_8FD1_6218_6D4B_8BD5_56DE_8C03ID = 0
    local _____53C2_6570 = variable
    if _____53C2_6570 == nil or not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(_____53C2_6570["Boss单位"]) or not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(_____53C2_6570["攻击单位"]) then
        return
    end
    UnitDamageTarget(
        _____53C2_6570["攻击单位"],
        _____53C2_6570["Boss单位"],
        _____53C2_6570["伤害"],
        true,
        false,
        ATTACK_TYPE_NORMAL,
        DAMAGE_TYPE_NORMAL,
        WEAPON_TYPE_WHOKNOWS
    )
end
local function ____on_5DF4_5C14_624E_7F57_65AF_7194_5CA9_62A4_76FE_51B0_971C_6D4B_8BD5_4F24_5BB3(variable)
    _____7194_5CA9_62A4_76FE_51B0_971C_6D4B_8BD5_56DE_8C03ID = 0
    local _____53C2_6570 = variable
    if _____53C2_6570 == nil or not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(_____53C2_6570["Boss单位"]) or not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(_____53C2_6570["攻击单位"]) then
        return
    end
    UnitDamageTarget(
        _____53C2_6570["攻击单位"],
        _____53C2_6570["Boss单位"],
        _____53C2_6570["伤害"],
        false,
        true,
        ATTACK_TYPE_NORMAL,
        DAMAGE_TYPE_COLD,
        WEAPON_TYPE_WHOKNOWS
    )
end
local function ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD13_6D4B_8BD5_547D_4EE4(_player, context)
    local boss = context["Boss单位"]
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) then
        return
    end
    _____91CD_7F6E_5DF4_5C14_624E_7F57_65AF_7194_5CA9_62A4_76FE_6D4B_8BD5(boss)
    _____91CA_653E_5DF4_5C14_624E_7F57_65AF_7194_5CA9_62A4_76FE(context)
end
local function ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD13_8FD1_6218_53CD_5F39_6D4B_8BD5_547D_4EE4(player, context)
    local boss = context["Boss单位"]
    local attacker = _____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[GetPlayerId(player)]
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) or not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(attacker) then
        return
    end
    _____91CD_7F6E_5DF4_5C14_624E_7F57_65AF_7194_5CA9_62A4_76FE_6D4B_8BD5(boss)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(attacker)
    SetUnitPosition(
        attacker,
        GetUnitX(boss) + 140,
        GetUnitY(boss)
    )
    SetUnitFacing(attacker, 180)
    _____91CA_653E_5DF4_5C14_624E_7F57_65AF_7194_5CA9_62A4_76FE(context)
    local _____53C2_6570 = {
        ["命令"] = "13-2",
        Context = context,
        ["Boss单位"] = boss,
        ["攻击单位"] = attacker,
        ["伤害"] = 1000
    }
    _____7194_5CA9_62A4_76FE_8FD1_6218_6D4B_8BD5_56DE_8C03ID = addDelayedCallback(1000, ____on_5DF4_5C14_624E_7F57_65AF_7194_5CA9_62A4_76FE_8FD1_6218_6D4B_8BD5_4F24_5BB3, _____53C2_6570)
    local ____self_26 = context["清理"]
    ____self_26["登记延迟回调"](____self_26, "巴尔扎罗斯测试-熔岩护盾近战反弹", _____7194_5CA9_62A4_76FE_8FD1_6218_6D4B_8BD5_56DE_8C03ID)
end
local function ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD13_51B0_971C_7834_76FE_6D4B_8BD5_547D_4EE4(player, context)
    local boss = context["Boss单位"]
    local attacker = _____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[GetPlayerId(player)]
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) or not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(attacker) then
        return
    end
    _____91CD_7F6E_5DF4_5C14_624E_7F57_65AF_7194_5CA9_62A4_76FE_6D4B_8BD5(boss)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(attacker)
    registerManualBuff(
        boss,
        _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E.BuffID["熔岩暴走"],
        3600,
        1,
        {stack = 1, sourceName = "巴尔扎罗斯测试"}
    )
    _____91CA_653E_5DF4_5C14_624E_7F57_65AF_7194_5CA9_62A4_76FE(context)
    local maxLife = GetUnitState(boss, UNIT_STATE_MAX_LIFE)
    local _____4F24_5BB3 = maxLife * _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["熔岩护盾"]["护盾Boss最大生命比例"] * 2
    local _____53C2_6570 = {
        ["命令"] = "13-3",
        Context = context,
        ["Boss单位"] = boss,
        ["攻击单位"] = attacker,
        ["伤害"] = _____4F24_5BB3
    }
    _____7194_5CA9_62A4_76FE_51B0_971C_6D4B_8BD5_56DE_8C03ID = addDelayedCallback(2000, ____on_5DF4_5C14_624E_7F57_65AF_7194_5CA9_62A4_76FE_51B0_971C_6D4B_8BD5_4F24_5BB3, _____53C2_6570)
    local ____self_27 = context["清理"]
    ____self_27["登记延迟回调"](____self_27, "巴尔扎罗斯测试-熔岩护盾冰霜破盾", _____7194_5CA9_62A4_76FE_51B0_971C_6D4B_8BD5_56DE_8C03ID)
end
local function _____51C6_5907_5DF4_5C14_624E_7F57_65AF_7099_70ED_5949_732E_6D4B_8BD5_751F_547D(context)
    local grum = context["格鲁姆"]
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(grum) then
        return false
    end
    local boss = context["Boss单位"]
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(boss) then
        return false
    end
    local maxLife = GetUnitState(grum, UNIT_STATE_MAX_LIFE)
    SetUnitState(grum, UNIT_STATE_LIFE, maxLife * 0.19)
    local bossMaxLife = GetUnitState(boss, UNIT_STATE_MAX_LIFE)
    SetUnitState(boss, UNIT_STATE_LIFE, bossMaxLife * 0.8)
    return true
end
local function ____on_5DF4_5C14_624E_7F57_65AF_7099_70ED_5949_732E_6253_65AD(variable)
    local context = variable
    if context == nil then
        return
    end
    _____4E2D_65AD_683C_9C81_59C6_7099_70ED_5949_732E(context)
end
local function ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD14_6D4B_8BD5_547D_4EE4(_player, context)
    if not _____51C6_5907_5DF4_5C14_624E_7F57_65AF_7099_70ED_5949_732E_6D4B_8BD5_751F_547D(context) then
        return
    end
    _____89E6_53D1_683C_9C81_59C6_7099_70ED_5949_732E(context)
end
local function ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD14_6253_65AD_6D4B_8BD5_547D_4EE4(_player, context)
    if not _____51C6_5907_5DF4_5C14_624E_7F57_65AF_7099_70ED_5949_732E_6D4B_8BD5_751F_547D(context) then
        return
    end
    _____89E6_53D1_683C_9C81_59C6_7099_70ED_5949_732E(context)
    local callbackId = addDelayedCallback(1000, ____on_5DF4_5C14_624E_7F57_65AF_7099_70ED_5949_732E_6253_65AD, context)
    local ____self_28 = context["清理"]
    ____self_28["登记延迟回调"](____self_28, "巴尔扎罗斯测试-炙热奉献打断", callbackId)
end
local _____5DF4_5C14_624E_7F57_65AF_6D4B_8BD5_6280_80FD_5217_8868 = {
    {["序号"] = 1, ["名称"] = "恶魔咆哮波", ["执行"] = ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD1_6D4B_8BD5_547D_4EE4},
    {["序号"] = 1, ["命令"] = "1-2", ["名称"] = "恶魔咆哮波(P2护卫模仿)", ["执行"] = ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD1_62A4_536B_6A21_4EFF_6D4B_8BD5_547D_4EE4},
    {["序号"] = 2, ["名称"] = "王者天罚", ["执行"] = ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD2_6D4B_8BD5_547D_4EE4},
    {["序号"] = 2, ["命令"] = "2-3", ["名称"] = "王者天罚(P3随机天罚)", ["执行"] = ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD2P3_6D4B_8BD5_547D_4EE4},
    {["序号"] = 3, ["名称"] = "熔岩喷发", ["执行"] = ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD3_6D4B_8BD5_547D_4EE4},
    {["序号"] = 4, ["名称"] = "火焰锁链", ["执行"] = ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD4_6D4B_8BD5_547D_4EE4},
    {["序号"] = 4, ["命令"] = "4-2", ["名称"] = "火焰锁链(山丘之王700码超距)", ["执行"] = ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD4_8D85_8DDD_6D4B_8BD5_547D_4EE4},
    {["序号"] = 5, ["名称"] = "地核召唤", ["执行"] = ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD5_6D4B_8BD5_547D_4EE4},
    {["序号"] = 6, ["名称"] = "末日熔爆", ["执行"] = ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD6_6D4B_8BD5_547D_4EE4},
    {["序号"] = 7, ["名称"] = "格鲁姆熔岩重锤", ["执行"] = ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD7_6D4B_8BD5_547D_4EE4},
    {["序号"] = 8, ["名称"] = "格鲁姆熔岩火径", ["执行"] = ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD8_6D4B_8BD5_547D_4EE4},
    {["序号"] = 9, ["名称"] = "塞拉冰焰双星", ["执行"] = ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD9_6D4B_8BD5_547D_4EE4},
    {["序号"] = 10, ["名称"] = "塞拉绝对零度领域", ["执行"] = ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD10_6D4B_8BD5_547D_4EE4},
    {["序号"] = 11, ["名称"] = "塞拉切换火焰形态", ["执行"] = ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD11_6D4B_8BD5_547D_4EE4},
    {["序号"] = 12, ["名称"] = "塞拉切换冰霜形态", ["执行"] = ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD12_6D4B_8BD5_547D_4EE4},
    {["序号"] = 13, ["名称"] = "熔岩护盾(直接生成)", ["执行"] = ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD13_6D4B_8BD5_547D_4EE4},
    {["序号"] = 13, ["命令"] = "13-2", ["名称"] = "熔岩护盾(1秒后近战反弹)", ["执行"] = ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD13_8FD1_6218_53CD_5F39_6D4B_8BD5_547D_4EE4},
    {["序号"] = 13, ["命令"] = "13-3", ["名称"] = "熔岩护盾(2秒后冰霜破盾)", ["执行"] = ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD13_51B0_971C_7834_76FE_6D4B_8BD5_547D_4EE4},
    {["序号"] = 14, ["名称"] = "炙热奉献(8秒成功)", ["执行"] = ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD14_6D4B_8BD5_547D_4EE4},
    {["序号"] = 14, ["命令"] = "14-2", ["名称"] = "炙热奉献(1秒后打断)", ["执行"] = ____on_5DF4_5C14_624E_7F57_65AF_6280_80FD14_6253_65AD_6D4B_8BD5_547D_4EE4}
}
_____6CE8_518CBoss_6D4B_8BD5_547D_4EE4_7EC4({
    ["命令单位名"] = "巴尔扎罗斯",
    ["Boss名称"] = "巴尔扎罗斯",
    ["创建或获取上下文"] = _____521B_5EFA_5E76_521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_6D4B_8BD5,
    ["清理上下文"] = _____6E05_7406_5DF4_5C14_624E_7F57_65AF_6D4B_8BD5,
    ["技能命令列表"] = _____5DF4_5C14_624E_7F57_65AF_6D4B_8BD5_6280_80FD_5217_8868
})
return ____exports
