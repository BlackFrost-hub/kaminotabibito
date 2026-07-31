local ____lualib = require("lualib_bundle")
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local __TS__Iterator = ____lualib.__TS__Iterator
local ____exports = {}
local jass = require("jass.common")
local DestroyEffect = jass.DestroyEffect
local japi = require("jass.japi")
local GetUnitStateJapi = japi.GetUnitState
local globals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local ____require_result_2 = require("系统.12．测试系统.00．Boss测试系统.index")
local ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B = ____require_result_2["Boss测试单位存活"]
local _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840 = ____require_result_2["设置Boss测试单位满血"]
local _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4 = ____require_result_2["获取Boss测试玩家基准英雄"]
local _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_6B65_5175 = ____require_result_2["准备Boss测试固定步兵"]
local _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_5C71_4E18_4E4B_738B = ____require_result_2["准备Boss测试固定山丘之王"]
local _____79FB_9664Boss_6D4B_8BD5_5355_4F4D = ____require_result_2["移除Boss测试单位"]
local _____6CE8_518CBoss_6D4B_8BD5_547D_4EE4_7EC4 = ____require_result_2["注册Boss测试命令组"]
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_3.stringToFourCCSafe
local ____require_result_4 = require("lib.扩展函数.BJ函数.index")
local SelectUnitForPlayerSingle = ____require_result_4.SelectUnitForPlayerSingle
local ____require_result_5 = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数")
local StarOther_PanCameraToTimedForPlayer = ____require_result_5.StarOther_PanCameraToTimedForPlayer
local ____require_result_6 = require("lib.扩展函数.Star扩展函数.Star扩展库.06A．X库函数安全版")
local X_RestoreUnitStandingSafe = ____require_result_6.X_RestoreUnitStandingSafe
local X_FixUnitStandingSafe = ____require_result_6.X_FixUnitStandingSafe
local ____require_result_7 = require("系统.12．测试系统.00．测试系统辅助函数")
local _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97 = ____require_result_7["标记测试Boss跳过死亡结算"]
local ____require_result_8 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用")
local _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E = ____require_result_8["应用Boss战启动属性配置"]
local ____require_result_9 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.01．Boss战运行上下文")
local _____521B_5EFABoss_6218_8FD0_884C_4E0A_4E0B_6587 = ____require_result_9["创建Boss战运行上下文"]
local _____8BB0_5F55Boss_6218_8FD0_884C_4E0A_4E0B_6587 = ____require_result_9["记录Boss战运行上下文"]
local _____8BFB_53D6Boss_6218_8FD0_884C_4E0A_4E0B_6587 = ____require_result_9["读取Boss战运行上下文"]
local _____6E05_7406Boss_6218_8FD0_884C_4E0A_4E0B_6587 = ____require_result_9["清理Boss战运行上下文"]
local ____require_result_10 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.00．配置")
local _____7956_5730_53CC_7075_536B_5355_4F4D_6280_80FD_914D_7F6E = ____require_result_10["祖地双灵卫单位技能配置"]
local ____require_result_11 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.02．数值与表现配置")
local _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E = ____require_result_11["祖地双灵卫数值与表现配置"]
local ____require_result_12 = require("系统.05．Buff系统.00．Buff系统")
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_12["移除单位指定Buff"]
local ____require_result_13 = require("系统.05．Buff系统.03．Buff表.01．Boss.02．挑战与隐藏Boss.05．祖地双灵卫")
local _____7956_5730_53CC_7075_536BBuffID = ____require_result_13["祖地双灵卫BuffID"]
local ____require_result_14 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.11．被动效果")
local _____6CE8_518C_7956_5730_53CC_7075_536B_88AB_52A8_6548_679C = ____require_result_14["注册祖地双灵卫被动效果"]
local ____require_result_15 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_7956_5730_53CC_7075_536B_8FD0_884C_65F6_4E0A_4E0B_6587 = ____require_result_15["获取或创建祖地双灵卫运行时上下文"]
local _____6E05_7406_7956_5730_53CC_7075_536B_8FD0_884C_65F6_4E0A_4E0B_6587 = ____require_result_15["清理祖地双灵卫运行时上下文"]
local ____require_result_16 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.05．侵蚀择形")
local _____7ED1_5B9A_7956_5730_53CC_7075_536B_4FB5_8680_751F_547D_4E0B_9650 = ____require_result_16["绑定祖地双灵卫侵蚀生命下限"]
local ____require_result_17 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.09．同息归寂")
local _____7ED1_5B9A_7956_5730_53CC_7075_536B_540C_606F_751F_547D_4E0B_9650 = ____require_result_17["绑定祖地双灵卫同息生命下限"]
local ____require_result_18 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.05．侵蚀择形")
local _____66F4_65B0_7956_5730_53CC_7075_536B_4FB5_8680_9636_6BB5 = ____require_result_18["更新祖地双灵卫侵蚀阶段"]
local ____require_result_19 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.07．双钥净化")
local _____66F4_65B0_7956_5730_53CC_7075_536B_53CC_94A5_51C0_5316 = ____require_result_19["更新祖地双灵卫双钥净化"]
local ____require_result_20 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.03．双灵同誓")
local _____66F4_65B0_7956_5730_53CC_7075_540C_8A93 = ____require_result_20["更新祖地双灵同誓"]
local ____require_result_21 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.01．赤誓灵卫.01．灵印折步")
local _____91CA_653E_7075_5370_6298_6B65 = ____require_result_21["释放灵印折步"]
local _____521B_5EFA_8D64_8A93_9547_9B42_5370 = ____require_result_21["创建赤誓镇魂印"]
local ____require_result_22 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.01．赤誓灵卫.02．月纹缚魂")
local _____91CA_653E_6708_7EB9_7F1A_9B42 = ____require_result_22["释放月纹缚魂"]
local ____require_result_23 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.01．赤誓灵卫.03．断誓践踏")
local _____91CA_653E_65AD_8A93_8DF5_8E0F = ____require_result_23["释放断誓践踏"]
local ____require_result_24 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.01．赤誓灵卫.04．裂魂坠斩")
local _____91CA_653E_88C2_9B42_5760_65A9 = ____require_result_24["释放裂魂坠斩"]
local ____require_result_25 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.02．苍影灵卫.01．誓锋壁进")
local _____91CA_653E_8A93_950B_58C1_8FDB = ____require_result_25["释放誓锋壁进"]
local ____require_result_26 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.02．苍影灵卫.02．盾刃裁决")
local _____91CA_653E_76FE_5203_88C1_51B3 = ____require_result_26["释放盾刃裁决"]
local ____require_result_27 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.02．苍影灵卫.03．失名祷潮")
local _____91CA_653E_5931_540D_7977_6F6E = ____require_result_27["释放失名祷潮"]
local ____require_result_28 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.02．苍影灵卫.04．记忆剥落")
local _____91CA_653E_8BB0_5FC6_5265_843D = ____require_result_28["释放记忆剥落"]
local ____require_result_29 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.06．封门校验")
local _____91CA_653E_7956_5730_53CC_7075_536B_5C01_95E8_6821_9A8C = ____require_result_29["释放祖地双灵卫封门校验"]
local ____require_result_30 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.08．封门误判")
local _____91CA_653E_7956_5730_53CC_7075_536B_5C01_95E8_8BEF_5224 = ____require_result_30["释放祖地双灵卫封门误判"]
local CreateUnit = jass.CreateUnit
local GetPlayerId = jass.GetPlayerId
local GetUnitState = jass.GetUnitState
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local SetUnitState = jass.SetUnitState
local SetHeroLevel = jass.SetHeroLevel
local SetUnitFacing = jass.SetUnitFacing
local SetUnitPosition = jass.SetUnitPosition
local SetUnitScale = jass.SetUnitScale
local SetUnitInvulnerable = jass.SetUnitInvulnerable
local PauseUnit = jass.PauseUnit
local UnitDamageTarget = jass.UnitDamageTarget
local Rect = jass.Rect
local RemoveRect = jass.RemoveRect
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local DzSetUnitModel = japi.DzSetUnitModel
local _____8D64_8A93_7075_536B_5355_4F4DID = stringToFourCCSafe(_____7956_5730_53CC_7075_536B_5355_4F4D_6280_80FD_914D_7F6E["单位"]["赤誓灵卫"]["单位ID"])
local _____82CD_5F71_7075_536B_5355_4F4DID = stringToFourCCSafe(_____7956_5730_53CC_7075_536B_5355_4F4D_6280_80FD_914D_7F6E["单位"]["苍影灵卫"]["单位ID"])
local _____6D4B_8BD5_4E2D_5FC3X = -540.6
local _____6D4B_8BD5_4E2D_5FC3Y = -2495.2
local _____73A9_5BB6_6D4B_8BD5X = -540.6
local _____73A9_5BB6_6D4B_8BD5Y = -3055.2
local _____53CC_7075_6D4B_8BD5_534A_5BBD = 1000
local _____53CC_7075_6D4B_8BD5_534A_9AD8 = 850
local _____6700_8FD1_8D64_8A93_7075_536B = {}
local _____6700_8FD1_82CD_5F71_7075_536B = {}
local _____6700_8FD1_6D4B_8BD5_6B65_5175 = {}
local _____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B = {}
local _____53CC_7075_6D4B_8BD5_77E9_5F62 = {}
local _____7956_5730_53CC_7075_536B_88AB_52A8_6D4B_8BD5_65E5_5FD7_6A21_5757 = "祖地双灵卫-13/14/15验证"
local function _____53D6_53CC_7075_536B_6D4B_8BD5_751F_547D_6BD4_4F8B(unit)
    local maxLife = unit ~= nil and unit ~= 0 and GetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE) or 0
    return maxLife > 0 and GetUnitState(unit, UNIT_STATE_LIFE) / maxLife or 0
end
local function _____8BB0_5F55_53CC_7075_536B_88AB_52A8_6D4B_8BD5_7ED3_679C(_____547D_4EE4, context, _____9884_671F, _____539F_59CB_4F24_5BB3_6BD4_4F8B, _____4F24_5BB3_8C03_7528_6210_529F, _____51C6_5907_9636_6BB5, _____51C6_5907_8D64_8A93_751F_547D_6BD4_4F8B, _____51C6_5907_82CD_5F71_751F_547D_6BD4_4F8B)
    local runtime = context["运行时"]
    local redMaxLife = GetUnitStateJapi(context["赤誓灵卫单位"], UNIT_STATE_MAX_LIFE)
    local azureMaxLife = GetUnitStateJapi(context["苍影灵卫单位"], UNIT_STATE_MAX_LIFE)
    local redLife = GetUnitState(context["赤誓灵卫单位"], UNIT_STATE_LIFE)
    local azureLife = GetUnitState(context["苍影灵卫单位"], UNIT_STATE_LIFE)
    local redRatio = redMaxLife > 0 and redLife / redMaxLife or 0
    local azureRatio = azureMaxLife > 0 and azureLife / azureMaxLife or 0
    local lifeDiff = redRatio - azureRatio
    if lifeDiff < 0 then
        lifeDiff = -lifeDiff
    end
    local publicConfig = _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["公共"]
    local expectedLowDamageRatio = (1 - publicConfig["同誓低血减伤比例"]) * (1 - publicConfig["同誓高血分担比例"])
    local expectedSharedDamageRatio = (1 - publicConfig["同誓低血减伤比例"]) * publicConfig["同誓高血分担比例"]
    local ____runtime__4FB5_8680_751F_547D_4E0B_9650_4FDD_62A4_5217_8868_31 = runtime["侵蚀生命下限保护列表"]
    if ____runtime__4FB5_8680_751F_547D_4E0B_9650_4FDD_62A4_5217_8868_31 == nil then
        ____runtime__4FB5_8680_751F_547D_4E0B_9650_4FDD_62A4_5217_8868_31 = {}
    end
    local erosionControllers = ____runtime__4FB5_8680_751F_547D_4E0B_9650_4FDD_62A4_5217_8868_31
    local ____runtime__540C_606F_751F_547D_4E0B_9650_4FDD_62A4_5217_8868_32 = runtime["同息生命下限保护列表"]
    if ____runtime__540C_606F_751F_547D_4E0B_9650_4FDD_62A4_5217_8868_32 == nil then
        ____runtime__540C_606F_751F_547D_4E0B_9650_4FDD_62A4_5217_8868_32 = {}
    end
    local collapseControllers = ____runtime__540C_606F_751F_547D_4E0B_9650_4FDD_62A4_5217_8868_32
    local redErosionController = erosionControllers[1]
    local azureErosionController = erosionControllers[2]
    local redCollapseController = collapseControllers[1]
    local azureCollapseController = collapseControllers[2]
    local ____self_33 = runtime["联合生命周期"]
    local redMember = ____self_33["取成员"](____self_33, "赤誓灵卫")
    local ____self_34 = runtime["联合生命周期"]
    local azureMember = ____self_34["取成员"](____self_34, "苍影灵卫")
    local ____debugLogForce_78 = debugLogForce
    local ____array_77 = __TS__SparseArrayNew(
        _____7956_5730_53CC_7075_536B_88AB_52A8_6D4B_8BD5_65E5_5FD7_6A21_5757,
        "命令",
        _____547D_4EE4,
        "预期",
        _____9884_671F,
        "准备阶段",
        _____51C6_5907_9636_6BB5,
        "准备赤誓生命比例",
        _____51C6_5907_8D64_8A93_751F_547D_6BD4_4F8B,
        "准备苍影生命比例",
        _____51C6_5907_82CD_5F71_751F_547D_6BD4_4F8B,
        "阶段",
        runtime["阶段"],
        "赤誓形态",
        runtime["赤誓灵卫形态"],
        "苍影形态",
        runtime["苍影灵卫形态"],
        "赤誓当前生命",
        redLife,
        "赤誓最大生命",
        redMaxLife,
        "赤誓生命比例",
        redRatio,
        "苍影当前生命",
        azureLife,
        "苍影最大生命",
        azureMaxLife,
        "苍影生命比例",
        azureRatio,
        "生命差",
        lifeDiff,
        "双灵同誓触发阈值",
        publicConfig["双灵同誓触发生命差"],
        "双灵同誓解除阈值",
        publicConfig["双灵同誓解除生命差"],
        "双灵同誓启用",
        runtime["同誓保护已启用"],
        "低血守卫",
        runtime["低血保护守卫"],
        "保护特效",
        runtime["同誓保护特效"] ~= nil and runtime["同誓保护特效"] ~= 0,
        "暗金连线",
        runtime["同誓暗金连线"] ~= nil,
        "冷蓝连线",
        runtime["同誓冷蓝连线"] ~= nil,
        "侵蚀目标下限比例",
        _____7956_5730_53CC_7075_536B_5355_4F4D_6280_80FD_914D_7F6E["阶段阈值"]["首次变异生命比例"],
        "同息目标下限比例",
        _____7956_5730_53CC_7075_536B_5355_4F4D_6280_80FD_914D_7F6E["阶段阈值"]["灵魂崩解生命比例"],
        "侵蚀锁血-赤誓"
    )
    local ____opt_result_37
    if redErosionController ~= nil then
        ____opt_result_37 = redErosionController["是否生效"](redErosionController)
    end
    __TS__SparseArrayPush(____array_77, ____opt_result_37, "已触底")
    local ____opt_result_40
    if redErosionController ~= nil then
        ____opt_result_40 = redErosionController["是否已触底"](redErosionController)
    end
    __TS__SparseArrayPush(____array_77, ____opt_result_40, "下限")
    local ____opt_result_43
    if redErosionController ~= nil then
        ____opt_result_43 = redErosionController["读取生命下限"](redErosionController)
    end
    __TS__SparseArrayPush(____array_77, ____opt_result_43, "侵蚀锁血-苍影")
    local ____opt_result_46
    if azureErosionController ~= nil then
        ____opt_result_46 = azureErosionController["是否生效"](azureErosionController)
    end
    __TS__SparseArrayPush(____array_77, ____opt_result_46, "已触底")
    local ____opt_result_49
    if azureErosionController ~= nil then
        ____opt_result_49 = azureErosionController["是否已触底"](azureErosionController)
    end
    __TS__SparseArrayPush(____array_77, ____opt_result_49, "下限")
    local ____opt_result_52
    if azureErosionController ~= nil then
        ____opt_result_52 = azureErosionController["读取生命下限"](azureErosionController)
    end
    __TS__SparseArrayPush(____array_77, ____opt_result_52, "同息锁血-赤誓")
    local ____opt_result_55
    if redCollapseController ~= nil then
        ____opt_result_55 = redCollapseController["是否生效"](redCollapseController)
    end
    __TS__SparseArrayPush(____array_77, ____opt_result_55, "已触底")
    local ____opt_result_58
    if redCollapseController ~= nil then
        ____opt_result_58 = redCollapseController["是否已触底"](redCollapseController)
    end
    __TS__SparseArrayPush(____array_77, ____opt_result_58, "下限")
    local ____opt_result_61
    if redCollapseController ~= nil then
        ____opt_result_61 = redCollapseController["读取生命下限"](redCollapseController)
    end
    __TS__SparseArrayPush(____array_77, ____opt_result_61, "同息锁血-苍影")
    local ____opt_result_64
    if azureCollapseController ~= nil then
        ____opt_result_64 = azureCollapseController["是否生效"](azureCollapseController)
    end
    __TS__SparseArrayPush(____array_77, ____opt_result_64, "已触底")
    local ____opt_result_67
    if azureCollapseController ~= nil then
        ____opt_result_67 = azureCollapseController["是否已触底"](azureCollapseController)
    end
    __TS__SparseArrayPush(____array_77, ____opt_result_67, "下限")
    local ____opt_result_70
    if azureCollapseController ~= nil then
        ____opt_result_70 = azureCollapseController["读取生命下限"](azureCollapseController)
    end
    __TS__SparseArrayPush(____array_77, ____opt_result_70, "联合状态-赤誓")
    local ____opt_result_73
    if redMember ~= nil then
        ____opt_result_73 = redMember["状态"]
    end
    __TS__SparseArrayPush(____array_77, ____opt_result_73, "联合状态-苍影")
    local ____opt_result_76
    if azureMember ~= nil then
        ____opt_result_76 = azureMember["状态"]
    end
    __TS__SparseArrayPush(
        ____array_77,
        ____opt_result_76,
        "崩解中的守卫",
        runtime["崩解中的守卫"],
        "崩解截止Ms",
        runtime["崩解截止时间Ms"],
        "P3共鸣层数",
        runtime["P3共鸣层数"],
        "本次原始伤害比例",
        _____539F_59CB_4F24_5BB3_6BD4_4F8B,
        "本次伤害类型",
        "魔法",
        "本次伤害调用成功",
        _____4F24_5BB3_8C03_7528_6210_529F,
        "预期低血最终伤害比例",
        expectedLowDamageRatio,
        "预期高血分担伤害比例",
        expectedSharedDamageRatio
    )
    ____debugLogForce_78(__TS__SparseArraySpread(____array_77))
end
local function _____83B7_53D6_6216_521B_5EFA_53CC_7075_6D4B_8BD5_77E9_5F62(player)
    local pid = GetPlayerId(player)
    local rect = _____53CC_7075_6D4B_8BD5_77E9_5F62[pid]
    if rect == nil or rect == 0 then
        rect = Rect(_____6D4B_8BD5_4E2D_5FC3X - _____53CC_7075_6D4B_8BD5_534A_5BBD, _____6D4B_8BD5_4E2D_5FC3Y - _____53CC_7075_6D4B_8BD5_534A_9AD8, _____6D4B_8BD5_4E2D_5FC3X + _____53CC_7075_6D4B_8BD5_534A_5BBD, _____6D4B_8BD5_4E2D_5FC3Y + _____53CC_7075_6D4B_8BD5_534A_9AD8)
        _____53CC_7075_6D4B_8BD5_77E9_5F62[pid] = rect
    end
    return rect
end
local function _____83B7_53D6_6216_521B_5EFA_53CC_7075_6D4B_8BD5Boss(player)
    local pid = GetPlayerId(player)
    local red = _____6700_8FD1_8D64_8A93_7075_536B[pid]
    local azure = _____6700_8FD1_82CD_5F71_7075_536B[pid]
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(red) or not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(azure) then
        _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(red)
        _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(azure)
        red = CreateUnit(
            player,
            _____8D64_8A93_7075_536B_5355_4F4DID,
            _____6D4B_8BD5_4E2D_5FC3X - 320,
            _____6D4B_8BD5_4E2D_5FC3Y,
            270
        )
        azure = CreateUnit(
            player,
            _____82CD_5F71_7075_536B_5355_4F4DID,
            _____6D4B_8BD5_4E2D_5FC3X + 320,
            _____6D4B_8BD5_4E2D_5FC3Y,
            270
        )
        _____6700_8FD1_8D64_8A93_7075_536B[pid] = red
        _____6700_8FD1_82CD_5F71_7075_536B[pid] = azure
        if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(red) then
            SetHeroLevel(red, 45, false)
        end
        if ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(azure) then
            SetHeroLevel(azure, 45, false)
        end
    end
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(red) or not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(azure) then
        return nil
    end
    SetUnitPosition(red, _____6D4B_8BD5_4E2D_5FC3X - 320, _____6D4B_8BD5_4E2D_5FC3Y)
    SetUnitPosition(azure, _____6D4B_8BD5_4E2D_5FC3X + 320, _____6D4B_8BD5_4E2D_5FC3Y)
    SetUnitFacing(red, 270)
    SetUnitFacing(azure, 270)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(red)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(azure)
    _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97(red)
    _____6807_8BB0_6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97(azure)
    globals.udg_Boss = red
    return {red = red, azure = azure}
end
local function _____83B7_53D6_6216_521B_5EFA_53CC_7075_6D4B_8BD5_6B65_5175(cache, player, x, y)
    local pid = GetPlayerId(player)
    local unit = _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_6B65_5175(cache[pid], x, y, 90)
    cache[pid] = unit
    return unit
end
local function _____786E_4FDD_53CC_7075_6D4B_8BD5_6218_6597_77E9_5F62(player, unit)
    if _____8BFB_53D6Boss_6218_8FD0_884C_4E0A_4E0B_6587(unit) ~= nil then
        return
    end
    local battle = _____521B_5EFABoss_6218_8FD0_884C_4E0A_4E0B_6587(
        unit,
        _____83B7_53D6_6216_521B_5EFA_53CC_7075_6D4B_8BD5_77E9_5F62(player),
        nil,
        nil
    )
    if battle ~= nil then
        _____8BB0_5F55Boss_6218_8FD0_884C_4E0A_4E0B_6587(battle)
    end
end
local function _____521B_5EFA_6216_83B7_53D6_7956_5730_53CC_7075_536B_6D4B_8BD5_4E0A_4E0B_6587(player)
    local pid = GetPlayerId(player)
    local hero = _____83B7_53D6Boss_6D4B_8BD5_73A9_5BB6_57FA_51C6_82F1_96C4(player)
    local pair = _____83B7_53D6_6216_521B_5EFA_53CC_7075_6D4B_8BD5Boss(player)
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(hero) or pair == nil then
        return nil
    end
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(hero)
    local target = _____83B7_53D6_6216_521B_5EFA_53CC_7075_6D4B_8BD5_6B65_5175(_____6700_8FD1_6D4B_8BD5_6B65_5175, player, _____73A9_5BB6_6D4B_8BD5X - 220, _____73A9_5BB6_6D4B_8BD5Y + 180)
    _____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid] = _____51C6_5907Boss_6D4B_8BD5_56FA_5B9A_5C71_4E18_4E4B_738B(_____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid], _____73A9_5BB6_6D4B_8BD5X + 220, _____73A9_5BB6_6D4B_8BD5Y + 180, 90)
    if not ____Boss_6D4B_8BD5_5355_4F4D_5B58_6D3B(target) then
        return nil
    end
    _____6CE8_518C_7956_5730_53CC_7075_536B_88AB_52A8_6548_679C()
    _____786E_4FDD_53CC_7075_6D4B_8BD5_6218_6597_77E9_5F62(player, pair.red)
    _____786E_4FDD_53CC_7075_6D4B_8BD5_6218_6597_77E9_5F62(player, pair.azure)
    _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E(pair.red)
    _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E(pair.azure)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(pair.red)
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(pair.azure)
    local runtime = _____83B7_53D6_6216_521B_5EFA_7956_5730_53CC_7075_536B_8FD0_884C_65F6_4E0A_4E0B_6587(pair.red)
    if runtime == nil then
        return nil
    end
    _____7ED1_5B9A_7956_5730_53CC_7075_536B_4FB5_8680_751F_547D_4E0B_9650(runtime)
    _____7ED1_5B9A_7956_5730_53CC_7075_536B_540C_606F_751F_547D_4E0B_9650(runtime)
    SelectUnitForPlayerSingle(pair.red, player)
    StarOther_PanCameraToTimedForPlayer(player, _____6D4B_8BD5_4E2D_5FC3X, _____6D4B_8BD5_4E2D_5FC3Y, 0.2)
    return {["运行时"] = runtime, ["目标单位"] = target, ["赤誓灵卫单位"] = pair.red, ["苍影灵卫单位"] = pair.azure}
end
local function _____6E05_7406_7956_5730_53CC_7075_536B_6D4B_8BD5_4E0A_4E0B_6587(player, context)
    local pid = GetPlayerId(player)
    if context ~= nil then
        if context["运行时"] ~= nil then
            _____6E05_7406_7956_5730_53CC_7075_536B_8FD0_884C_65F6_4E0A_4E0B_6587(context["运行时"])
        end
        _____6E05_7406Boss_6218_8FD0_884C_4E0A_4E0B_6587(context["赤誓灵卫单位"])
        _____6E05_7406Boss_6218_8FD0_884C_4E0A_4E0B_6587(context["苍影灵卫单位"])
    end
    local rect = _____53CC_7075_6D4B_8BD5_77E9_5F62[pid]
    if rect ~= nil and rect ~= 0 then
        RemoveRect(rect)
    end
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____6700_8FD1_6D4B_8BD5_6B65_5175[pid])
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid])
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____6700_8FD1_8D64_8A93_7075_536B[pid])
    _____79FB_9664Boss_6D4B_8BD5_5355_4F4D(_____6700_8FD1_82CD_5F71_7075_536B[pid])
    _____53CC_7075_6D4B_8BD5_77E9_5F62[pid] = nil
    _____6700_8FD1_6D4B_8BD5_6B65_5175[pid] = nil
    _____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[pid] = nil
    _____6700_8FD1_8D64_8A93_7075_536B[pid] = nil
    _____6700_8FD1_82CD_5F71_7075_536B[pid] = nil
    if globals.udg_Boss == (context and context["赤誓灵卫单位"]) then
        globals.udg_Boss = nil
    end
end
local function _____6E05_7406_7956_5730_53CC_7075_536B_9547_9B42_5370(runtime)
    local ____opt_result_83
    if runtime ~= nil then
        ____opt_result_83 = runtime["镇魂印"]
    end
    local seal = ____opt_result_83
    local ____opt_result_86
    if seal ~= nil then
        ____opt_result_86 = seal["区域实例"]
    end
    if ____opt_result_86 ~= nil then
        local ____self_87 = seal["区域实例"]
        ____self_87["销毁"](____self_87)
    else
        local ____opt_result_90
        if seal ~= nil then
            ____opt_result_90 = seal["特效"]
        end
        if ____opt_result_90 ~= nil and seal["特效"] ~= 0 then
            DestroyEffect(seal["特效"])
        end
    end
    runtime["镇魂印"] = nil
end
local function _____91CD_7F6E_7956_5730_53CC_7075_536BP1(context)
    local runtime = context["运行时"]
    local cfg = _____7956_5730_53CC_7075_536B_5355_4F4D_6280_80FD_914D_7F6E["单位"]
    local ____runtime__4FB5_8680_751F_547D_4E0B_9650_4FDD_62A4_5217_8868_91 = runtime["侵蚀生命下限保护列表"]
    if ____runtime__4FB5_8680_751F_547D_4E0B_9650_4FDD_62A4_5217_8868_91 == nil then
        ____runtime__4FB5_8680_751F_547D_4E0B_9650_4FDD_62A4_5217_8868_91 = {}
    end
    local erosionControllers = ____runtime__4FB5_8680_751F_547D_4E0B_9650_4FDD_62A4_5217_8868_91
    local ____runtime__540C_606F_751F_547D_4E0B_9650_4FDD_62A4_5217_8868_92 = runtime["同息生命下限保护列表"]
    if ____runtime__540C_606F_751F_547D_4E0B_9650_4FDD_62A4_5217_8868_92 == nil then
        ____runtime__540C_606F_751F_547D_4E0B_9650_4FDD_62A4_5217_8868_92 = {}
    end
    local collapseControllers = ____runtime__540C_606F_751F_547D_4E0B_9650_4FDD_62A4_5217_8868_92
    do
        local i = 0
        while i < #erosionControllers do
            local controller = erosionControllers[i + 1]
            if controller ~= nil then
                controller["重置触底状态"](controller)
            end
            i = i + 1
        end
    end
    do
        local i = 0
        while i < #collapseControllers do
            local controller = collapseControllers[i + 1]
            if controller ~= nil then
                controller["重置触底状态"](controller)
            end
            i = i + 1
        end
    end
    local units = {context["赤誓灵卫单位"], context["苍影灵卫单位"]}
    local names = {"赤誓灵卫", "苍影灵卫"}
    do
        local i = 0
        while i < #units do
            local unit = units[i + 1]
            PauseUnit(unit, false)
            SetUnitInvulnerable(unit, false)
            _____79FB_9664_5355_4F4D_6307_5B9ABuff(unit, _____7956_5730_53CC_7075_536BBuffID["双灵同誓"])
            _____79FB_9664_5355_4F4D_6307_5B9ABuff(unit, _____7956_5730_53CC_7075_536BBuffID["双蚀共鸣"])
            _____79FB_9664_5355_4F4D_6307_5B9ABuff(unit, _____7956_5730_53CC_7075_536BBuffID["灵魂崩解"])
            _____79FB_9664_5355_4F4D_6307_5B9ABuff(unit, _____7956_5730_53CC_7075_536BBuffID["净化反冲"])
            local ____self_93 = runtime["联合生命周期"]
            local member = ____self_93["取成员"](____self_93, names[i + 1])
            if member ~= nil and member["状态"] ~= "活跃" then
                local ____self_94 = runtime["联合生命周期"]
                ____self_94["设置状态"](____self_94, names[i + 1], "活跃", "测试重置")
            end
            i = i + 1
        end
    end
    if runtime["誓盾"] ~= nil and runtime["誓盾"]["特效"] ~= nil and runtime["誓盾"]["特效"] ~= 0 then
        DestroyEffect(runtime["誓盾"]["特效"])
    end
    runtime["誓盾"] = nil
    _____6E05_7406_7956_5730_53CC_7075_536B_9547_9B42_5370(runtime)
    local _____51C0_5316_8282_70B9_5217_8868 = runtime["净化节点列表"]
    do
        local i = 0
        while i < #_____51C0_5316_8282_70B9_5217_8868 do
            local node = _____51C0_5316_8282_70B9_5217_8868[i + 1]
            if node["特效"] ~= nil and node["特效"] ~= 0 then
                DestroyEffect(node["特效"])
            end
            node["特效"] = nil
            node["表现阶段"] = nil
            node["阶段"] = "未激活"
            node["校准截止Ms"] = 0
            node["重试允许Ms"] = 0
            i = i + 1
        end
    end
    runtime["阶段"] = "P1双灵守门"
    runtime["赤誓灵卫形态"] = "正常"
    runtime["苍影灵卫形态"] = "正常"
    runtime["首次变异守卫"] = nil
    runtime["崩解中的守卫"] = nil
    runtime["崩解截止时间Ms"] = 0
    runtime["大型技能占用者"] = nil
    runtime["大型机制忙碌到Ms"] = 0
    runtime["当前净化节点序号"] = 0
    runtime["已净化节点数量"] = 0
    runtime["P3共鸣层数"] = _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P3["净化节点数量"]
    runtime["净化易伤到Ms"] = 0
    runtime["最终结算待处理"] = false
    runtime["封门误判待触发"] = false
    DzSetUnitModel(context["赤誓灵卫单位"], cfg["赤誓灵卫"]["正常模型路径"])
    DzSetUnitModel(context["苍影灵卫单位"], cfg["苍影灵卫"]["正常模型路径"])
    SetUnitScale(context["赤誓灵卫单位"], cfg["赤誓灵卫"]["正常模型缩放"], cfg["赤誓灵卫"]["正常模型缩放"], cfg["赤誓灵卫"]["正常模型缩放"])
    SetUnitScale(context["苍影灵卫单位"], cfg["苍影灵卫"]["正常模型缩放"], cfg["苍影灵卫"]["正常模型缩放"], cfg["苍影灵卫"]["正常模型缩放"])
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(context["赤誓灵卫单位"])
    _____8BBE_7F6EBoss_6D4B_8BD5_5355_4F4D_6EE1_8840(context["苍影灵卫单位"])
    _____66F4_65B0_7956_5730_53CC_7075_540C_8A93(runtime)
end
local function _____51C6_5907_7956_5730_53CC_7075_536BP2(context)
    _____91CD_7F6E_7956_5730_53CC_7075_536BP1(context)
    local maxLife = GetUnitStateJapi(context["赤誓灵卫单位"], UNIT_STATE_MAX_LIFE)
    SetUnitState(context["赤誓灵卫单位"], UNIT_STATE_LIFE, maxLife * 0.6)
    _____66F4_65B0_7956_5730_53CC_7075_536B_4FB5_8680_9636_6BB5(context["运行时"])
end
local function _____51C6_5907_7956_5730_53CC_7075_536BP2_82CD_5F71_5148_53D8_5F02(context)
    _____91CD_7F6E_7956_5730_53CC_7075_536BP1(context)
    local maxLife = GetUnitStateJapi(context["苍影灵卫单位"], UNIT_STATE_MAX_LIFE)
    SetUnitState(context["苍影灵卫单位"], UNIT_STATE_LIFE, maxLife * 0.6)
    _____66F4_65B0_7956_5730_53CC_7075_536B_4FB5_8680_9636_6BB5(context["运行时"])
end
local function _____51C6_5907_7956_5730_53CC_7075_536BP3(context)
    _____51C6_5907_7956_5730_53CC_7075_536BP2(context)
    local maxLife = GetUnitStateJapi(context["赤誓灵卫单位"], UNIT_STATE_MAX_LIFE)
    SetUnitState(context["赤誓灵卫单位"], UNIT_STATE_LIFE, maxLife * 0.3)
    _____66F4_65B0_7956_5730_53CC_7075_536B_4FB5_8680_9636_6BB5(context["运行时"])
end
local function _____6D4B_8BD5_53CC_7075_536B_7075_5370_6298_6B65(_player, context)
    _____91CD_7F6E_7956_5730_53CC_7075_536BP1(context)
    _____91CA_653E_7075_5370_6298_6B65(
        context["运行时"],
        _____6700_8FD1_6D4B_8BD5_5C71_4E18_4E4B_738B[GetPlayerId(_player)]
    )
end
local function _____6D4B_8BD5_53CC_7075_536B_6708_7EB9_7F1A_9B42(_player, context)
    _____91CD_7F6E_7956_5730_53CC_7075_536BP1(context)
    _____91CA_653E_6708_7EB9_7F1A_9B42(context["运行时"], context["目标单位"])
end
local function _____6D4B_8BD5_53CC_7075_536B_8A93_950B_58C1_8FDB(_player, context)
    _____91CD_7F6E_7956_5730_53CC_7075_536BP1(context)
    _____91CA_653E_8A93_950B_58C1_8FDB(context["运行时"], context["目标单位"])
end
local function _____6D4B_8BD5_53CC_7075_536B_76FE_5203_88C1_51B3(_player, context)
    _____91CD_7F6E_7956_5730_53CC_7075_536BP1(context)
    _____91CA_653E_76FE_5203_88C1_51B3(context["运行时"], context["目标单位"])
end
local function _____6D4B_8BD5_53CC_7075_536B_5C01_95E8_6821_9A8C(_player, context)
    _____91CD_7F6E_7956_5730_53CC_7075_536BP1(context)
    _____91CA_653E_7956_5730_53CC_7075_536B_5C01_95E8_6821_9A8C(context["运行时"], context["目标单位"])
end
local function _____6D4B_8BD5_53CC_7075_536B_8D64_8A93_53D8_5F02(_player, context)
    _____51C6_5907_7956_5730_53CC_7075_536BP2(context)
end
local function _____6D4B_8BD5_53CC_7075_536B_65AD_8A93_8DF5_8E0F(_player, context)
    _____51C6_5907_7956_5730_53CC_7075_536BP2(context)
    _____91CA_653E_65AD_8A93_8DF5_8E0F(context["运行时"], context["目标单位"])
end
local function _____6D4B_8BD5_53CC_7075_536B_65AD_8A93_8DF5_8E0FP3(_player, context)
    _____51C6_5907_7956_5730_53CC_7075_536BP3(context)
    _____91CA_653E_65AD_8A93_8DF5_8E0F(context["运行时"], context["目标单位"])
end
local function _____6D4B_8BD5_53CC_7075_536B_88C2_9B42_5760_65A9(_player, context)
    _____51C6_5907_7956_5730_53CC_7075_536BP2(context)
    _____91CA_653E_88C2_9B42_5760_65A9(context["运行时"], context["目标单位"])
end
local function _____6D4B_8BD5_53CC_7075_536B_53CC_8680_5171_9E23(_player, context)
    _____51C6_5907_7956_5730_53CC_7075_536BP3(context)
end
local function _____6D4B_8BD5_53CC_7075_536B_5931_540D_7977_6F6E(_player, context)
    _____51C6_5907_7956_5730_53CC_7075_536BP2_82CD_5F71_5148_53D8_5F02(context)
    _____521B_5EFA_8D64_8A93_9547_9B42_5370(
        context["运行时"],
        GetUnitX(context["目标单位"]),
        GetUnitY(context["目标单位"])
    )
    _____91CA_653E_5931_540D_7977_6F6E(context["运行时"], context["目标单位"])
end
local function _____6D4B_8BD5_53CC_7075_536B_5931_540D_7977_6F6EP3(_player, context)
    _____51C6_5907_7956_5730_53CC_7075_536BP3(context)
    local runtime = context["运行时"]
    runtime["当前净化节点序号"] = 1
    runtime["已净化节点数量"] = 0
    local node = nil
    local nodes = runtime["净化节点列表"]
    if nodes ~= nil then
        for ____, candidate in __TS__Iterator(nodes) do
            if candidate ~= nil and candidate["序号"] == 1 then
                node = candidate
                break
            end
        end
    end
    if node ~= nil then
        node["阶段"] = "校准"
        node["校准截止Ms"] = 0
        X_RestoreUnitStandingSafe(context["目标单位"])
        SetUnitPosition(context["目标单位"], node.X, node.Y)
        X_FixUnitStandingSafe(context["目标单位"])
        _____66F4_65B0_7956_5730_53CC_7075_536B_53CC_94A5_51C0_5316(context["运行时"])
    end
    _____91CA_653E_5931_540D_7977_6F6E(context["运行时"], context["目标单位"])
end
local function _____6D4B_8BD5_53CC_7075_536B_5931_540D_7977_6F6E_65E0_9547_9B42_5370(_player, context)
    _____51C6_5907_7956_5730_53CC_7075_536BP2_82CD_5F71_5148_53D8_5F02(context)
    _____6E05_7406_7956_5730_53CC_7075_536B_9547_9B42_5370(context["运行时"])
    _____91CA_653E_5931_540D_7977_6F6E(context["运行时"], context["目标单位"])
end
local function _____6D4B_8BD5_53CC_7075_536B_8BB0_5FC6_5265_843D(_player, context)
    _____51C6_5907_7956_5730_53CC_7075_536BP2_82CD_5F71_5148_53D8_5F02(context)
    _____91CA_653E_8BB0_5FC6_5265_843D(context["运行时"], context["目标单位"])
end
local function _____6D4B_8BD5_53CC_7075_536B_5C01_95E8_8BEF_5224(_player, context)
    _____51C6_5907_7956_5730_53CC_7075_536BP3(context)
    context["运行时"]["已净化节点数量"] = 1
    context["运行时"]["封门误判待触发"] = true
    if context["运行时"]["净化节点列表"][1] ~= nil then
        context["运行时"]["净化节点列表"][1]["阶段"] = "已净化"
    end
    _____91CA_653E_7956_5730_53CC_7075_536B_5C01_95E8_8BEF_5224(context["运行时"])
end
local function _____65BD_52A0_53CC_7075_536B_6D4B_8BD5_4F24_5BB3(context, target, _____76EE_6807_6700_5927_751F_547D_6BD4_4F8B)
    local maxLife = GetUnitStateJapi(target, UNIT_STATE_MAX_LIFE)
    if maxLife <= 0 or _____76EE_6807_6700_5927_751F_547D_6BD4_4F8B <= 0 then
        return false
    end
    return UnitDamageTarget(
        context["目标单位"],
        target,
        maxLife * _____76EE_6807_6700_5927_751F_547D_6BD4_4F8B,
        false,
        true,
        ATTACK_TYPE_NORMAL,
        DAMAGE_TYPE_MAGIC,
        WEAPON_TYPE_WHOKNOWS
    )
end
local function _____6D4B_8BD5_53CC_7075_536B_540C_8A93_88AB_52A8(_player, context)
    _____91CD_7F6E_7956_5730_53CC_7075_536BP1(context)
    local redMax = GetUnitStateJapi(context["赤誓灵卫单位"], UNIT_STATE_MAX_LIFE)
    local azureMax = GetUnitStateJapi(context["苍影灵卫单位"], UNIT_STATE_MAX_LIFE)
    SetUnitState(context["赤誓灵卫单位"], UNIT_STATE_LIFE, redMax * 0.7)
    SetUnitState(context["苍影灵卫单位"], UNIT_STATE_LIFE, azureMax)
    _____66F4_65B0_7956_5730_53CC_7075_540C_8A93(context["运行时"])
    local preparedRedRatio = _____53D6_53CC_7075_536B_6D4B_8BD5_751F_547D_6BD4_4F8B(context["赤誓灵卫单位"])
    local preparedAzureRatio = _____53D6_53CC_7075_536B_6D4B_8BD5_751F_547D_6BD4_4F8B(context["苍影灵卫单位"])
    local damageApplied = _____65BD_52A0_53CC_7075_536B_6D4B_8BD5_4F24_5BB3(context, context["赤誓灵卫单位"], 0.1)
    _____8BB0_5F55_53CC_7075_536B_88AB_52A8_6D4B_8BD5_7ED3_679C(
        "13",
        context,
        "P1，赤誓70%、苍影100%，生命差30%触发双灵同誓，施加10%最大生命魔法伤害观察55%减伤与25%分担",
        0.1,
        damageApplied,
        "P1双灵守门",
        preparedRedRatio,
        preparedAzureRatio
    )
end
local function _____6D4B_8BD5_53CC_7075_536B_4FB5_8680_9501_8840_88AB_52A8(_player, context)
    _____91CD_7F6E_7956_5730_53CC_7075_536BP1(context)
    local preparedRedRatio = _____53D6_53CC_7075_536B_6D4B_8BD5_751F_547D_6BD4_4F8B(context["赤誓灵卫单位"])
    local preparedAzureRatio = _____53D6_53CC_7075_536B_6D4B_8BD5_751F_547D_6BD4_4F8B(context["苍影灵卫单位"])
    local damageApplied = _____65BD_52A0_53CC_7075_536B_6D4B_8BD5_4F24_5BB3(context, context["赤誓灵卫单位"], 0.9)
    _____8BB0_5F55_53CC_7075_536B_88AB_52A8_6D4B_8BD5_7ED3_679C(
        "14",
        context,
        "P1满血承受90%最大生命伤害，赤誓锁在65%并首次变异进入P2",
        0.9,
        damageApplied,
        "P1双灵守门",
        preparedRedRatio,
        preparedAzureRatio
    )
end
local function _____6D4B_8BD5_53CC_7075_536B_540C_606F_9501_8840_88AB_52A8(_player, context)
    _____51C6_5907_7956_5730_53CC_7075_536BP3(context)
    local preparedRedRatio = _____53D6_53CC_7075_536B_6D4B_8BD5_751F_547D_6BD4_4F8B(context["赤誓灵卫单位"])
    local preparedAzureRatio = _____53D6_53CC_7075_536B_6D4B_8BD5_751F_547D_6BD4_4F8B(context["苍影灵卫单位"])
    local damageApplied = _____65BD_52A0_53CC_7075_536B_6D4B_8BD5_4F24_5BB3(context, context["赤誓灵卫单位"], 0.8)
    addDelayedCallback(
        0,
        function()
            _____8BB0_5F55_53CC_7075_536B_88AB_52A8_6D4B_8BD5_7ED3_679C(
                "15",
                context,
                "P3双蚀共鸣，赤誓锁在5%并进入暂停、无敌、灵魂崩解",
                0.8,
                damageApplied,
                "P3双蚀共鸣",
                preparedRedRatio,
                preparedAzureRatio
            )
        end
    )
end
local _____7956_5730_53CC_7075_536B_6D4B_8BD5_6280_80FD_5217_8868 = {
    {["序号"] = 1, ["名称"] = "赤誓灵印折步", ["执行"] = _____6D4B_8BD5_53CC_7075_536B_7075_5370_6298_6B65},
    {["序号"] = 2, ["名称"] = "赤誓月纹缚魂", ["执行"] = _____6D4B_8BD5_53CC_7075_536B_6708_7EB9_7F1A_9B42},
    {["序号"] = 3, ["名称"] = "苍影誓锋壁进", ["执行"] = _____6D4B_8BD5_53CC_7075_536B_8A93_950B_58C1_8FDB},
    {["序号"] = 4, ["名称"] = "苍影盾刃裁决", ["执行"] = _____6D4B_8BD5_53CC_7075_536B_76FE_5203_88C1_51B3},
    {["序号"] = 5, ["名称"] = "P1联合封门校验", ["执行"] = _____6D4B_8BD5_53CC_7075_536B_5C01_95E8_6821_9A8C},
    {["序号"] = 6, ["名称"] = "P2赤誓侵蚀变异", ["执行"] = _____6D4B_8BD5_53CC_7075_536B_8D64_8A93_53D8_5F02},
    {["序号"] = 7, ["名称"] = "赤誓断誓践踏（P2盾压制）", ["执行"] = _____6D4B_8BD5_53CC_7075_536B_65AD_8A93_8DF5_8E0F},
    {["序号"] = 7, ["命令"] = "7-3", ["名称"] = "赤誓断誓践踏（P3破壳净化）", ["执行"] = _____6D4B_8BD5_53CC_7075_536B_65AD_8A93_8DF5_8E0FP3},
    {["序号"] = 8, ["名称"] = "赤誓裂魂坠斩", ["执行"] = _____6D4B_8BD5_53CC_7075_536B_88C2_9B42_5760_65A9},
    {["序号"] = 9, ["名称"] = "P3双蚀共鸣", ["执行"] = _____6D4B_8BD5_53CC_7075_536B_53CC_8680_5171_9E23},
    {["序号"] = 10, ["名称"] = "苍影失名祷潮（P2吸收镇魂印）", ["执行"] = _____6D4B_8BD5_53CC_7075_536B_5931_540D_7977_6F6E},
    {["序号"] = 10, ["命令"] = "10-2", ["名称"] = "苍影失名祷潮（P2正常伤害）", ["执行"] = _____6D4B_8BD5_53CC_7075_536B_5931_540D_7977_6F6E_65E0_9547_9B42_5370},
    {["序号"] = 10, ["命令"] = "10-3", ["名称"] = "苍影失名祷潮（P3校准净化）", ["执行"] = _____6D4B_8BD5_53CC_7075_536B_5931_540D_7977_6F6EP3},
    {["序号"] = 11, ["名称"] = "苍影记忆剥落", ["执行"] = _____6D4B_8BD5_53CC_7075_536B_8BB0_5FC6_5265_843D},
    {["序号"] = 12, ["名称"] = "P3封门误判", ["执行"] = _____6D4B_8BD5_53CC_7075_536B_5C01_95E8_8BEF_5224},
    {["序号"] = 13, ["名称"] = "被动：双灵同誓减伤与分担", ["执行"] = _____6D4B_8BD5_53CC_7075_536B_540C_8A93_88AB_52A8},
    {["序号"] = 14, ["名称"] = "被动：侵蚀阶段生命下限", ["执行"] = _____6D4B_8BD5_53CC_7075_536B_4FB5_8680_9501_8840_88AB_52A8},
    {["序号"] = 15, ["名称"] = "被动：同息归寂生命下限", ["执行"] = _____6D4B_8BD5_53CC_7075_536B_540C_606F_9501_8840_88AB_52A8}
}
_____6CE8_518CBoss_6D4B_8BD5_547D_4EE4_7EC4({
    ["命令单位名"] = "双灵卫",
    ["Boss名称"] = "祖地双灵卫",
    ["场地"] = {["正式中心"] = {x = _____7956_5730_53CC_7075_536B_5355_4F4D_6280_80FD_914D_7F6E["正式场地"]["中心X"], y = _____7956_5730_53CC_7075_536B_5355_4F4D_6280_80FD_914D_7F6E["正式场地"]["中心Y"]}, ["测试空地中心"] = {x = _____6D4B_8BD5_4E2D_5FC3X, y = _____6D4B_8BD5_4E2D_5FC3Y}},
    ["创建或获取上下文"] = _____521B_5EFA_6216_83B7_53D6_7956_5730_53CC_7075_536B_6D4B_8BD5_4E0A_4E0B_6587,
    ["清理上下文"] = _____6E05_7406_7956_5730_53CC_7075_536B_6D4B_8BD5_4E0A_4E0B_6587,
    ["技能命令列表"] = _____7956_5730_53CC_7075_536B_6D4B_8BD5_6280_80FD_5217_8868
})
return ____exports
