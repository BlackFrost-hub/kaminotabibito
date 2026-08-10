local ____lualib = require("lualib_bundle")
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local ____exports = {}
local ____01_FF0EBoss_6218_6597_542F_52A8_5C5E_6027_914D_7F6E_8868 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.01．Boss战斗启动属性配置表.index")
local ____Boss_6218_6597_542F_52A8_5C5E_6027_914D_7F6E_8868 = ____01_FF0EBoss_6218_6597_542F_52A8_5C5E_6027_914D_7F6E_8868["Boss战斗启动属性配置表"]
local ____02_FF0E_82F1_96C4Boss_6218_6597_542F_52A8_5C5E_6027_914D_7F6E_8868 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.02．英雄Boss战斗启动属性配置表.index")
local _____82F1_96C4Boss_6218_6597_542F_52A8_5C5E_6027_914D_7F6E_8868 = ____02_FF0E_82F1_96C4Boss_6218_6597_542F_52A8_5C5E_6027_914D_7F6E_8868["英雄Boss战斗启动属性配置表"]
local ____03_FF0E_5F02_754CBoss_6218_6597_542F_52A8_5C5E_6027_914D_7F6E_8868 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.03．异界Boss战斗启动属性配置表.index")
local _____5F02_754CBoss_6218_6597_542F_52A8_5C5E_6027_914D_7F6E_8868 = ____03_FF0E_5F02_754CBoss_6218_6597_542F_52A8_5C5E_6027_914D_7F6E_8868["异界Boss战斗启动属性配置表"]
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.07．地形系统.09．动态矩形区域注册表.index")
local _____83B7_53D6_77E9_5F62_533A_57DF = ____require_result_0["获取矩形区域"]
local GetHandleId = jass.GetHandleId
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local Rect = jass.Rect
local CreateSound = jass.CreateSound
local ____require_result_1 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataSetSafe = ____require_result_1.YDUserDataSetSafe
local YDUserDataClearSafe = ____require_result_1.YDUserDataClearSafe
local ____require_result_2 = require("系统.01．单位系统.08．单位配置表.02．Boss配置表")
local _____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID = ____require_result_2["按名字反查Boss单位ID"]
local ____require_result_3 = require("系统.01．单位系统.08．单位配置表.03．异界Boss配置表")
local _____6309_540D_5B57_53CD_67E5_5F02_754CBoss_5355_4F4DID = ____require_result_3["按名字反查异界Boss单位ID"]
local ____require_result_4 = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.00．玩家英雄配置")
local _____6309_540D_5B57_53CD_67E5_73A9_5BB6_82F1_96C4_5355_4F4DID = ____require_result_4["按名字反查玩家英雄单位ID"]
local ____require_result_5 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_5.stringToFourCCSafe
local ____require_result_6 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_6.debugLogForce
local _____6A21_5757_540D = "Boss战启动属性应用"
local _____5DF2_5E94_7528_5C5E_6027_5355_4F4D_8868 = {}
local ____Boss_6218_8DEF_5F84_97F3_4E50_7F13_5B58 = {}
local ____array_7 = __TS__SparseArrayNew(table.unpack(____Boss_6218_6597_542F_52A8_5C5E_6027_914D_7F6E_8868))
__TS__SparseArrayPush(
    ____array_7,
    table.unpack(_____82F1_96C4Boss_6218_6597_542F_52A8_5C5E_6027_914D_7F6E_8868)
)
__TS__SparseArrayPush(
    ____array_7,
    table.unpack(_____5F02_754CBoss_6218_6597_542F_52A8_5C5E_6027_914D_7F6E_8868)
)
local _____5168_90E8_6218_6597_542F_52A8_5C5E_6027_914D_7F6E_8868 = {__TS__SparseArraySpread(____array_7)}
local function _____89E3_6790_914D_7F6E_5355_4F4D_7C7B_578BID(_____914D_7F6E)
    if _____914D_7F6E["单位ID"] ~= nil and _____914D_7F6E["单位ID"] ~= "" then
        return stringToFourCCSafe(_____914D_7F6E["单位ID"])
    end
    if _____914D_7F6E["归类"] == "Boss" then
        return stringToFourCCSafe(_____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID(_____914D_7F6E["单位名"]))
    end
    if _____914D_7F6E["归类"] == "英雄Boss" then
        return stringToFourCCSafe(_____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID(_____914D_7F6E["单位名"]) or _____6309_540D_5B57_53CD_67E5_73A9_5BB6_82F1_96C4_5355_4F4DID(_____914D_7F6E["单位名"]))
    end
    if _____914D_7F6E["归类"] == "异界Boss" then
        return stringToFourCCSafe(_____6309_540D_5B57_53CD_67E5_5F02_754CBoss_5355_4F4DID(_____914D_7F6E["单位名"]))
    end
    return 0
end
local function _____6309_5355_4F4D_67E5_627E_6218_6597_542F_52A8_5C5E_6027_914D_7F6E(unit)
    local unitTypeId = GetUnitTypeId(unit)
    if unitTypeId == 0 then
        return nil
    end
    do
        local i = 0
        while i < #_____5168_90E8_6218_6597_542F_52A8_5C5E_6027_914D_7F6E_8868 do
            local _____914D_7F6E = _____5168_90E8_6218_6597_542F_52A8_5C5E_6027_914D_7F6E_8868[i + 1]
            if _____89E3_6790_914D_7F6E_5355_4F4D_7C7B_578BID(_____914D_7F6E) == unitTypeId then
                return _____914D_7F6E
            end
            i = i + 1
        end
    end
    return nil
end
local function _____5199_5165_5B9E_6570_5C5E_6027(unit, _____5C5E_6027_540D, _____503C)
    if _____503C == nil then
        return
    end
    YDUserDataSetSafe(
        "unit",
        unit,
        _____5C5E_6027_540D,
        "real",
        _____503C
    )
end
local function _____5199_5165Boss_6218_5B57_7B26_4E32_8868_5B9E_6570(_____5C5E_6027_540D, _____503C)
    if _____503C == nil then
        return
    end
    YDUserDataSetSafe(
        "string",
        "Boss战",
        _____5C5E_6027_540D,
        "real",
        _____503C
    )
end
local function _____5199_5165Boss_6218_5355_4F4D_5E03_5C14(unit, _____5C5E_6027_540D, _____503C)
    if _____503C == nil then
        return
    end
    YDUserDataSetSafe(
        "unit",
        unit,
        _____5C5E_6027_540D,
        "boolean",
        _____503C
    )
end
local function _____83B7_53D6_6216_521B_5EFABoss_6218_8DEF_5F84_97F3_4E50(_____8DEF_5F84)
    if _____8DEF_5F84 == nil or _____8DEF_5F84 == "" then
        return nil
    end
    local _____5DF2_7F13_5B58 = ____Boss_6218_8DEF_5F84_97F3_4E50_7F13_5B58[_____8DEF_5F84]
    if _____5DF2_7F13_5B58 ~= nil and _____5DF2_7F13_5B58 ~= 0 then
        return _____5DF2_7F13_5B58
    end
    local _____97F3_9891_53E5_67C4 = CreateSound(
        _____8DEF_5F84,
        true,
        false,
        false,
        10,
        10,
        "DefaultEAXON"
    )
    if _____97F3_9891_53E5_67C4 == nil or _____97F3_9891_53E5_67C4 == 0 then
        return nil
    end
    ____Boss_6218_8DEF_5F84_97F3_4E50_7F13_5B58[_____8DEF_5F84] = _____97F3_9891_53E5_67C4
    debugLogForce(_____6A21_5757_540D, "创建路径音乐缓存", "path=", _____8DEF_5F84)
    return _____97F3_9891_53E5_67C4
end
local function _____8BFB_53D6_53D8_91CF_97F3_9891(_____53D8_91CF_540D)
    if _____53D8_91CF_540D == nil or _____53D8_91CF_540D == "" then
        return
    end
    local _____97F3_9891_53E5_67C4 = jglobals[_____53D8_91CF_540D]
    if _____97F3_9891_53E5_67C4 == nil then
        return nil
    end
    return _____97F3_9891_53E5_67C4
end
local function _____5199_5165Boss_6218_97F3_9891(_____5C5E_6027_540D, _____8DEF_5F84, _____53D8_91CF_540D)
    local ____83B7_53D6_6216_521B_5EFABoss_6218_8DEF_5F84_97F3_4E50_result_8 = _____83B7_53D6_6216_521B_5EFABoss_6218_8DEF_5F84_97F3_4E50(_____8DEF_5F84)
    if ____83B7_53D6_6216_521B_5EFABoss_6218_8DEF_5F84_97F3_4E50_result_8 == nil then
        ____83B7_53D6_6216_521B_5EFABoss_6218_8DEF_5F84_97F3_4E50_result_8 = _____8BFB_53D6_53D8_91CF_97F3_9891(_____53D8_91CF_540D)
    end
    local _____97F3_9891_53E5_67C4 = ____83B7_53D6_6216_521B_5EFABoss_6218_8DEF_5F84_97F3_4E50_result_8
    if _____97F3_9891_53E5_67C4 == nil or _____97F3_9891_53E5_67C4 == 0 then
        return
    end
    YDUserDataSetSafe(
        "string",
        "Boss战",
        _____5C5E_6027_540D,
        "sound",
        _____97F3_9891_53E5_67C4
    )
end
local function _____5199_5165Boss_6218_77E9_5F62(_____5C5E_6027_540D, _____533A_57DF_540D_79F0)
    if _____533A_57DF_540D_79F0 == nil or _____533A_57DF_540D_79F0 == "" then
        return
    end
    local _____77E9_5F62_53E5_67C4 = _____83B7_53D6_77E9_5F62_533A_57DF(_____533A_57DF_540D_79F0)
    if _____77E9_5F62_53E5_67C4 == nil then
        return
    end
    YDUserDataSetSafe(
        "string",
        "Boss战",
        _____5C5E_6027_540D,
        "rect",
        _____77E9_5F62_53E5_67C4
    )
end
local function _____6E05_7406Boss_6218_5730_70B9()
    YDUserDataClearSafe("string", "Boss战", "地点", "rect")
    YDUserDataClearSafe("string", "Boss战", "地点动态", "boolean")
end
local function _____5199_5165Boss_6218_52A8_6001_77E9_5F62(_____914D_7F6E)
    if _____914D_7F6E == nil then
        return
    end
    if not (_____914D_7F6E["左"] < _____914D_7F6E["右"]) or not (_____914D_7F6E["下"] < _____914D_7F6E["上"]) then
        return
    end
    local _____77E9_5F62_53E5_67C4 = Rect(_____914D_7F6E["左"], _____914D_7F6E["下"], _____914D_7F6E["右"], _____914D_7F6E["上"])
    if _____77E9_5F62_53E5_67C4 == nil or _____77E9_5F62_53E5_67C4 == 0 then
        return
    end
    YDUserDataSetSafe(
        "string",
        "Boss战",
        "地点",
        "rect",
        _____77E9_5F62_53E5_67C4
    )
    YDUserDataSetSafe(
        "string",
        "Boss战",
        "地点动态",
        "boolean",
        true
    )
end
____exports["应用Boss战启动属性配置"] = function(unit)
    if unit == nil or unit == 0 then
        return
    end
    local handleId = GetHandleId(unit)
    if handleId == 0 or _____5DF2_5E94_7528_5C5E_6027_5355_4F4D_8868[handleId] then
        return
    end
    local _____914D_7F6E = _____6309_5355_4F4D_67E5_627E_6218_6597_542F_52A8_5C5E_6027_914D_7F6E(unit)
    if _____914D_7F6E == nil then
        return
    end
    _____5199_5165Boss_6218_97F3_9891("战斗音乐", _____914D_7F6E["战斗音乐路径"], _____914D_7F6E["战斗音乐变量名"])
    _____5199_5165Boss_6218_97F3_9891("胜利音乐", _____914D_7F6E["胜利音乐路径"], _____914D_7F6E["胜利音乐变量名"])
    _____6E05_7406Boss_6218_5730_70B9()
    if _____914D_7F6E["动态地点矩形"] ~= nil then
        _____5199_5165Boss_6218_52A8_6001_77E9_5F62(_____914D_7F6E["动态地点矩形"])
    else
        _____5199_5165Boss_6218_77E9_5F62("地点", _____914D_7F6E["地点区域名称"])
    end
    _____5199_5165Boss_6218_5355_4F4D_5E03_5C14(unit, "转换场景", _____914D_7F6E["转换场景"])
    _____5199_5165Boss_6218_5B57_7B26_4E32_8868_5B9E_6570(
        "BS移动X轴",
        _____914D_7F6E["BS移动X轴"] or GetUnitX(unit)
    )
    _____5199_5165Boss_6218_5B57_7B26_4E32_8868_5B9E_6570(
        "BS移动Y轴",
        _____914D_7F6E["BS移动Y轴"] or GetUnitY(unit)
    )
    _____5199_5165Boss_6218_5B57_7B26_4E32_8868_5B9E_6570("玩家移动X轴", _____914D_7F6E["玩家移动X轴"])
    _____5199_5165Boss_6218_5B57_7B26_4E32_8868_5B9E_6570("玩家移动Y轴", _____914D_7F6E["玩家移动Y轴"])
    _____5199_5165_5B9E_6570_5C5E_6027(unit, "魔抗", _____914D_7F6E["魔抗"])
    _____5199_5165_5B9E_6570_5C5E_6027(unit, "暴击率", _____914D_7F6E["暴击率"])
    _____5199_5165_5B9E_6570_5C5E_6027(unit, "暴击伤害", _____914D_7F6E["暴击伤害"])
    _____5199_5165_5B9E_6570_5C5E_6027(unit, "眩晕抗性", _____914D_7F6E["眩晕抗性"])
    _____5199_5165_5B9E_6570_5C5E_6027(unit, "命中率", _____914D_7F6E["命中率"])
    _____5199_5165_5B9E_6570_5C5E_6027(unit, "闪避率", _____914D_7F6E["闪避率"])
    _____5199_5165_5B9E_6570_5C5E_6027(unit, "护甲穿透", _____914D_7F6E["护甲穿透"])
    _____5199_5165_5B9E_6570_5C5E_6027(unit, "金属性抗性", _____914D_7F6E["金属性抗性"])
    _____5199_5165_5B9E_6570_5C5E_6027(unit, "伤害吸血", _____914D_7F6E["伤害吸血"])
    _____5199_5165_5B9E_6570_5C5E_6027(unit, "魔法伤害吸血", _____914D_7F6E["魔法伤害吸血"])
    _____5199_5165_5B9E_6570_5C5E_6027(unit, "普攻伤害吸血", _____914D_7F6E["普攻伤害吸血"])
    _____5199_5165_5B9E_6570_5C5E_6027(unit, "魔法穿透", _____914D_7F6E["魔法穿透"])
    _____5DF2_5E94_7528_5C5E_6027_5355_4F4D_8868[handleId] = true
    debugLogForce(
        _____6A21_5757_540D,
        "应用配置",
        "unitTypeId=",
        GetUnitTypeId(unit),
        "分类=",
        _____914D_7F6E["归类"]
    )
end
return ____exports
