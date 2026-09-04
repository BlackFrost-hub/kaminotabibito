local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.20．爱蜜莉雅.00．配置")
local _____7231_871C_8389_96C5_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["爱蜜莉雅技能配置"]
local _____7231_871C_8389_96C5_88AB_52A8_914D_7F6E = ____00_FF0E_914D_7F6E["爱蜜莉雅被动配置"]
local _____7231_871C_8389_96C5_97F3_6548_914D_7F6E = ____00_FF0E_914D_7F6E["爱蜜莉雅音效配置"]
local ____20_FF0E_7231_871C_8389_96C5 = require("系统.05．Buff系统.03．Buff表.02．英雄.20．爱蜜莉雅")
local _____7231_871C_8389_96C5BuffID = ____20_FF0E_7231_871C_8389_96C5["爱蜜莉雅BuffID"]
local ____02_FF0E_516C_5171_72B6_6001_4E0E_51B0_6676 = require("系统.03．技能系统.05．单位技能.04．英雄技能.20．爱蜜莉雅.02．公共状态与冰晶")
local _____521B_5EFA_7231_871C_8389_96C5_51B0_6676 = ____02_FF0E_516C_5171_72B6_6001_4E0E_51B0_6676["创建爱蜜莉雅冰晶"]
local _____79FB_9664_7231_871C_8389_96C5_51B0_6676 = ____02_FF0E_516C_5171_72B6_6001_4E0E_51B0_6676["移除爱蜜莉雅冰晶"]
local _____67E5_8BE2_7231_871C_8389_96C5_51B0_6676 = ____02_FF0E_516C_5171_72B6_6001_4E0E_51B0_6676["查询爱蜜莉雅冰晶"]
local _____767B_8BB0_7231_871C_8389_96C5_6280_80FD_6E05_7406 = ____02_FF0E_516C_5171_72B6_6001_4E0E_51B0_6676["登记爱蜜莉雅技能清理"]
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local fourCCToStringSafe = ____require_result_0.fourCCToStringSafe
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitName = jass.GetUnitName
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerId = jass.GetPlayerId
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_COLD = jass.DAMAGE_TYPE_COLD
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_1 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_UnitPlayReuse = ____require_result_1.Sound3DII_UnitPlayReuse
local Sound3DII_CooPlayReuse = ____require_result_1.Sound3DII_CooPlayReuse
local ____require_result_2 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_2.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_2["移除单位指定Buff"]
local _____83B7_53D6_5355_4F4DBuff_5C42_6570 = ____require_result_2["获取单位Buff层数"]
local ____require_result_3 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_3["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_3["移除单位暂停"]
local ____require_result_4 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6280_80FD_4F24_5BB3 = ____require_result_4["造成技能伤害"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_5["读取单位攻击力"]
local _____5355_4F4D_5B58_6D3B = ____require_result_5["单位存活"]
local _____53D6_5355_4F4DID = ____require_result_5["取单位ID"]
local _____8DDD_79BB_5E73_65B9XY = ____require_result_5["距离平方XY"]
local ____require_result_6 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_6.addDelayedCallback
local removeDelayedCallback = ____require_result_6.removeDelayedCallback
local getGameTime = ____require_result_6.getGameTime
local ____require_result_7 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createTimedUnitEffect = ____require_result_7.createTimedUnitEffect
local ____require_result_8 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_8.registerDeathListener
local ____require_result_9 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_9.debugLogForce
local _____82F1_96C4_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____7231_871C_8389_96C5_6280_80FD_914D_7F6E["单位类型ID"])
local _____51BB_7ED3_6682_505C_6765_6E90 = "爱蜜莉雅-冻结"
local _____88AB_52A8_76EE_6807_8868 = {}
--- 冻结去重：目标句柄 → 来源键 → true（同技能实例不重复冻结）
local _____51BB_7ED3_53BB_91CD_8868 = {}
--- 碎冰去重：目标句柄 → 来源键 → true（同技能实例只触发一次碎冰）
local _____788E_51B0_53BB_91CD_8868 = {}
local _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
local function _____76EE_6807_72B6_6001(_____76EE_6807)
    local id = _____53D6_5355_4F4DID(_____76EE_6807)
    local _____72B6_6001 = _____88AB_52A8_76EE_6807_8868[id]
    if _____72B6_6001 == nil then
        _____72B6_6001 = {
            ["目标单位"] = _____76EE_6807,
            ["寒意层数"] = 0,
            ["寒意到期"] = 0,
            ["冻结中"] = false,
            ["冻结回调ID"] = 0,
            ["冻结施法者"] = nil,
            ["冻结结束时间"] = 0,
            ["霜裂到期"] = 0,
            ["霜裂回调ID"] = 0
        }
        _____88AB_52A8_76EE_6807_8868[id] = _____72B6_6001
    end
    return _____72B6_6001
end
--- 判断单位是否为爱蜜莉雅
____exports["是爱蜜莉雅"] = function(unit)
    if unit == nil or unit == 0 then
        return false
    end
    return GetUnitTypeId(unit) == _____82F1_96C4_5355_4F4D_7C7B_578BID
end
--- 目标当前是否处于冻结抗性窗口（冻结结束后 冻结抗性秒 内）
local function _____5904_4E8E_51BB_7ED3_6297_6027(_____72B6_6001)
    if _____72B6_6001["冻结结束时间"] <= 0 then
        return false
    end
    return getGameTime() < _____72B6_6001["冻结结束时间"] + _____7231_871C_8389_96C5_88AB_52A8_914D_7F6E["冻结抗性秒"] * 1000
end
--- 目标当前是否霜裂（霜裂标记未过期）
____exports["目标处于霜裂"] = function(_____76EE_6807)
    local _____72B6_6001 = _____88AB_52A8_76EE_6807_8868[_____53D6_5355_4F4DID(_____76EE_6807)]
    if _____72B6_6001 == nil then
        return false
    end
    return getGameTime() < _____72B6_6001["霜裂到期"]
end
--- 目标当前是否冻结中
____exports["目标处于冻结"] = function(_____76EE_6807)
    local _____72B6_6001 = _____88AB_52A8_76EE_6807_8868[_____53D6_5355_4F4DID(_____76EE_6807)]
    if _____72B6_6001 == nil then
        return false
    end
    return _____72B6_6001["冻结中"]
end
local function _____65BD_52A0_971C_88C2(_____76EE_6807)
    if _____76EE_6807 == nil or _____76EE_6807 == 0 or not _____5355_4F4D_5B58_6D3B(_____76EE_6807) then
        return
    end
    local _____72B6_6001 = _____76EE_6807_72B6_6001(_____76EE_6807)
    _____72B6_6001["霜裂到期"] = getGameTime() + _____7231_871C_8389_96C5_88AB_52A8_914D_7F6E["霜裂秒"] * 1000
    debugLogForce(
        "爱蜜莉雅-被动",
        "Buff",
        "操作",
        "施加",
        "目标",
        GetUnitName(_____76EE_6807),
        "handle",
        _____76EE_6807,
        "X",
        math.floor(GetUnitX(_____76EE_6807)),
        "Y",
        math.floor(GetUnitY(_____76EE_6807)),
        "类型",
        "霜裂"
    )
    registerManualBuff(_____76EE_6807, _____7231_871C_8389_96C5BuffID["霜裂"], _____7231_871C_8389_96C5_88AB_52A8_914D_7F6E["霜裂秒"], 0)
    if _____72B6_6001["霜裂回调ID"] ~= 0 then
        removeDelayedCallback(_____72B6_6001["霜裂回调ID"])
    end
    _____72B6_6001["霜裂回调ID"] = addDelayedCallback(
        _____7231_871C_8389_96C5_88AB_52A8_914D_7F6E["霜裂秒"] * 1000,
        function()
            _____72B6_6001["霜裂回调ID"] = 0
            debugLogForce(
                "爱蜜莉雅-被动",
                "Buff",
                "操作",
                "移除",
                "目标",
                GetUnitName(_____76EE_6807),
                "handle",
                _____76EE_6807,
                "X",
                math.floor(GetUnitX(_____76EE_6807)),
                "Y",
                math.floor(GetUnitY(_____76EE_6807)),
                "类型",
                "霜裂"
            )
            _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____76EE_6807, _____7231_871C_8389_96C5BuffID["霜裂"])
        end
    )
end
local function _____89E3_51BB_76EE_6807(_____76EE_6807, _____72B6_6001)
    debugLogForce(
        "爱蜜莉雅-被动",
        "状态",
        "解冻",
        "目标",
        GetUnitName(_____76EE_6807),
        "handle",
        _____76EE_6807,
        "X",
        math.floor(GetUnitX(_____76EE_6807)),
        "Y",
        math.floor(GetUnitY(_____76EE_6807))
    )
    if _____72B6_6001["冻结回调ID"] ~= 0 then
        removeDelayedCallback(_____72B6_6001["冻结回调ID"])
        _____72B6_6001["冻结回调ID"] = 0
    end
    _____79FB_9664_5355_4F4D_6682_505C(_____76EE_6807, _____51BB_7ED3_6682_505C_6765_6E90)
    debugLogForce(
        "爱蜜莉雅-被动",
        "Buff",
        "操作",
        "移除",
        "目标",
        GetUnitName(_____76EE_6807),
        "handle",
        _____76EE_6807,
        "类型",
        "冻结"
    )
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____76EE_6807, _____7231_871C_8389_96C5BuffID["冻结"])
    _____72B6_6001["冻结中"] = false
    _____72B6_6001["冻结结束时间"] = getGameTime()
end
local function _____51BB_7ED3_7ED3_675F(_____76EE_6807, _____72B6_6001)
    _____72B6_6001["冻结回调ID"] = 0
    if _____76EE_6807 == nil or _____76EE_6807 == 0 or not _____5355_4F4D_5B58_6D3B(_____76EE_6807) then
        _____72B6_6001["冻结中"] = false
        return
    end
    _____89E3_51BB_76EE_6807(_____76EE_6807, _____72B6_6001)
    Sound3DII_CooPlayReuse(
        _____7231_871C_8389_96C5_97F3_6548_914D_7F6E["Q命中"]["路径"],
        GetUnitX(_____76EE_6807),
        GetUnitY(_____76EE_6807),
        _____7231_871C_8389_96C5_97F3_6548_914D_7F6E["Q命中"]["高度"],
        _____7231_871C_8389_96C5_97F3_6548_914D_7F6E["Q命中"]["裁断距离"]
    )
    _____65BD_52A0_971C_88C2(_____76EE_6807)
end
--- 冻结目标（内部：含抗性窗口与同技能实例去重）
____exports["冻结爱蜜莉雅目标"] = function(_____65BD_6CD5_8005, _____76EE_6807, _____6765_6E90_952E)
    if _____65BD_6CD5_8005 == nil or _____76EE_6807 == nil or _____76EE_6807 == 0 or not _____5355_4F4D_5B58_6D3B(_____76EE_6807) then
        return false
    end
    local id = _____53D6_5355_4F4DID(_____76EE_6807)
    local _____72B6_6001 = _____76EE_6807_72B6_6001(_____76EE_6807)
    if _____72B6_6001["冻结中"] then
        return false
    end
    if _____5904_4E8E_51BB_7ED3_6297_6027(_____72B6_6001) then
        return false
    end
    local _____53BB_91CD = _____51BB_7ED3_53BB_91CD_8868[id]
    if _____53BB_91CD == nil then
        _____53BB_91CD = {}
        _____51BB_7ED3_53BB_91CD_8868[id] = _____53BB_91CD
    end
    if _____53BB_91CD[_____6765_6E90_952E] == true then
        return false
    end
    _____53BB_91CD[_____6765_6E90_952E] = true
    _____6DFB_52A0_5355_4F4D_6682_505C(_____76EE_6807, _____51BB_7ED3_6682_505C_6765_6E90)
    _____72B6_6001["冻结中"] = true
    _____72B6_6001["冻结施法者"] = _____65BD_6CD5_8005
    debugLogForce(
        "爱蜜莉雅-被动",
        "状态",
        "冻结",
        "玩家",
        GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
        "来源",
        _____6765_6E90_952E,
        "目标",
        GetUnitName(_____76EE_6807),
        "handle",
        _____76EE_6807,
        "X",
        math.floor(GetUnitX(_____76EE_6807)),
        "Y",
        math.floor(GetUnitY(_____76EE_6807))
    )
    debugLogForce(
        "爱蜜莉雅-被动",
        "Buff",
        "操作",
        "施加",
        "目标",
        GetUnitName(_____76EE_6807),
        "handle",
        _____76EE_6807,
        "类型",
        "冻结"
    )
    registerManualBuff(_____76EE_6807, _____7231_871C_8389_96C5BuffID["冻结"], _____7231_871C_8389_96C5_88AB_52A8_914D_7F6E["冻结秒"], 0)
    debugLogForce(
        "爱蜜莉雅-被动",
        "特效",
        "类型",
        "创建",
        "玩家",
        GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
        "路径",
        "Common\\Effect\\Element\\Ice\\sem_shen_du_dong_jie.mdx"
    )
    createTimedUnitEffect(_____76EE_6807, "origin", "Common\\Effect\\Element\\Ice\\sem_shen_du_dong_jie.mdx", _____7231_871C_8389_96C5_88AB_52A8_914D_7F6E["冻结秒"])
    Sound3DII_UnitPlayReuse(_____7231_871C_8389_96C5_97F3_6548_914D_7F6E["冻结包裹"]["路径"], _____76EE_6807, _____7231_871C_8389_96C5_97F3_6548_914D_7F6E["冻结包裹"]["裁断距离"])
    _____72B6_6001["冻结回调ID"] = addDelayedCallback(
        _____7231_871C_8389_96C5_88AB_52A8_914D_7F6E["冻结秒"] * 1000,
        function()
            _____51BB_7ED3_7ED3_675F(_____76EE_6807, _____72B6_6001)
        end
    )
    return true
end
--- 施加一层寒意；叠满阈值触发冻结（返回是否触发冻结）
____exports["施加爱蜜莉雅寒意"] = function(_____65BD_6CD5_8005, _____76EE_6807, _____6765_6E90_952E)
    if _____65BD_6CD5_8005 == nil or _____76EE_6807 == nil or _____76EE_6807 == 0 or not _____5355_4F4D_5B58_6D3B(_____76EE_6807) then
        return false
    end
    local _____72B6_6001 = _____76EE_6807_72B6_6001(_____76EE_6807)
    local now = getGameTime()
    local _____5F53_524D_5C42_6570 = now < _____72B6_6001["寒意到期"] and _____72B6_6001["寒意层数"] or 0
    local _____65B0_5C42_6570 = _____5F53_524D_5C42_6570 + 1
    _____72B6_6001["寒意层数"] = _____65B0_5C42_6570
    _____72B6_6001["寒意到期"] = now + _____7231_871C_8389_96C5_88AB_52A8_914D_7F6E["寒意持续秒"] * 1000
    registerManualBuff(
        _____76EE_6807,
        _____7231_871C_8389_96C5BuffID["寒意"],
        _____7231_871C_8389_96C5_88AB_52A8_914D_7F6E["寒意持续秒"],
        _____65B0_5C42_6570,
        {stack = _____65B0_5C42_6570, sourceUnit = _____65BD_6CD5_8005}
    )
    if _____65B0_5C42_6570 >= _____7231_871C_8389_96C5_88AB_52A8_914D_7F6E["寒意阈值"] then
        ____exports["冻结爱蜜莉雅目标"](_____65BD_6CD5_8005, _____76EE_6807, _____6765_6E90_952E)
        return true
    end
    return false
end
--- 触发碎冰强化伤害（霜裂目标 + 同技能实例去重）
____exports["触发爱蜜莉雅碎冰"] = function(_____65BD_6CD5_8005, _____76EE_6807, _____6765_6E90_952E, _____6280_80FDID, _____6280_80FD_5B9E_4F8BID)
    if _____65BD_6CD5_8005 == nil or _____76EE_6807 == nil or _____76EE_6807 == 0 or not _____5355_4F4D_5B58_6D3B(_____76EE_6807) then
        return false
    end
    if not ____exports["目标处于霜裂"](_____76EE_6807) then
        return false
    end
    local id = _____53D6_5355_4F4DID(_____76EE_6807)
    local _____53BB_91CD = _____788E_51B0_53BB_91CD_8868[id]
    if _____53BB_91CD == nil then
        _____53BB_91CD = {}
        _____788E_51B0_53BB_91CD_8868[id] = _____53BB_91CD
    end
    if _____53BB_91CD[_____6765_6E90_952E] == true then
        return false
    end
    _____53BB_91CD[_____6765_6E90_952E] = true
    local _____4F24_5BB3 = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005) * _____7231_871C_8389_96C5_88AB_52A8_914D_7F6E["碎冰攻击力倍率"]
    debugLogForce(
        "爱蜜莉雅-被动",
        "状态",
        "触发碎冰",
        "玩家",
        GetPlayerId(GetOwningPlayer(_____65BD_6CD5_8005)) + 1,
        "四码",
        fourCCToStringSafe(_____6280_80FDID),
        "实例",
        _____6280_80FD_5B9E_4F8BID or "-",
        "来源",
        _____6765_6E90_952E,
        "目标",
        GetUnitName(_____76EE_6807),
        "handle",
        _____76EE_6807,
        "X",
        math.floor(GetUnitX(_____76EE_6807)),
        "Y",
        math.floor(GetUnitY(_____76EE_6807))
    )
    debugLogForce(
        "爱蜜莉雅-被动",
        "伤害",
        "标签",
        "爱蜜莉雅-碎冰",
        "目标",
        GetUnitName(_____76EE_6807),
        "handle",
        _____76EE_6807,
        "X",
        math.floor(GetUnitX(_____76EE_6807)),
        "Y",
        math.floor(GetUnitY(_____76EE_6807)),
        "数值",
        _____4F24_5BB3
    )
    _____9020_6210_6280_80FD_4F24_5BB3({
        ["来源"] = _____65BD_6CD5_8005,
        ["目标"] = _____76EE_6807,
        ["伤害"] = _____4F24_5BB3,
        ["伤害类型"] = DAMAGE_TYPE_COLD,
        ["攻击类型"] = ATTACK_TYPE_NORMAL,
        ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = _____6280_80FDID,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["标签"] = "爱蜜莉雅-碎冰",
        ["伤害形态"] = "单体",
        ["参与技能伤害加成"] = false
    })
    debugLogForce(
        "爱蜜莉雅-被动",
        "Buff",
        "操作",
        "移除",
        "目标",
        GetUnitName(_____76EE_6807),
        "handle",
        _____76EE_6807,
        "类型",
        "霜裂"
    )
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____76EE_6807, _____7231_871C_8389_96C5BuffID["霜裂"])
    local _____72B6_6001 = _____88AB_52A8_76EE_6807_8868[id]
    if _____72B6_6001 ~= nil then
        _____72B6_6001["霜裂到期"] = 0
    end
    return true
end
--- 目标是否处于受控状态（冻结/减速/霜裂）——用于伤害增益判定；减速状态由 W/R 区域标记查询
____exports["目标受控增伤"] = function(_____76EE_6807)
    if ____exports["目标处于冻结"](_____76EE_6807) or ____exports["目标处于霜裂"](_____76EE_6807) then
        return true
    end
    return false
end
--- 统一命中结算入口：各技能命中调用。
-- 顺序：① 霜裂目标优先碎冰（额外强化伤害）→ ② 受控目标伤害增益 → ③ 施加寒意。
____exports["结算爱蜜莉雅技能命中"] = function(_____65BD_6CD5_8005, _____76EE_6807, _____6765_6E90_952E, _____53C2_6570)
    if _____65BD_6CD5_8005 == nil or _____65BD_6CD5_8005 == 0 then
        debugLogForce(
            "爱蜜莉雅-被动",
            "命中失败",
            "原因",
            "施法者无效",
            "标签",
            _____53C2_6570["标签"]
        )
        return false
    end
    if _____76EE_6807 == nil or _____76EE_6807 == 0 or not _____5355_4F4D_5B58_6D3B(_____76EE_6807) then
        debugLogForce(
            "爱蜜莉雅-被动",
            "命中失败",
            "原因",
            "目标无效",
            "标签",
            _____53C2_6570["标签"],
            "目标",
            (_____76EE_6807 == nil or _____76EE_6807 == 0) and "-" or GetUnitName(_____76EE_6807)
        )
        return false
    end
    local _____4F24_5BB3 = _____53C2_6570["伤害值"]
    ____exports["触发爱蜜莉雅碎冰"](
        _____65BD_6CD5_8005,
        _____76EE_6807,
        _____6765_6E90_952E,
        _____53C2_6570["技能ID"],
        _____53C2_6570["技能实例ID"]
    )
    if ____exports["目标受控增伤"](_____76EE_6807) then
        _____4F24_5BB3 = _____4F24_5BB3 * (1 + _____7231_871C_8389_96C5_88AB_52A8_914D_7F6E["对受控目标伤害倍率"])
    end
    local ____9020_6210_6280_80FD_4F24_5BB3_14 = _____9020_6210_6280_80FD_4F24_5BB3
    local ____65BD_6CD5_8005_11 = _____65BD_6CD5_8005
    local ____76EE_6807_12 = _____76EE_6807
    local ____4F24_5BB3_13 = _____4F24_5BB3
    local ____53C2_6570__4F24_5BB3_7C7B_578B_10 = _____53C2_6570["伤害类型"]
    if ____53C2_6570__4F24_5BB3_7C7B_578B_10 == nil then
        ____53C2_6570__4F24_5BB3_7C7B_578B_10 = DAMAGE_TYPE_COLD
    end
    ____9020_6210_6280_80FD_4F24_5BB3_14({
        ["来源"] = ____65BD_6CD5_8005_11,
        ["目标"] = ____76EE_6807_12,
        ["伤害"] = ____4F24_5BB3_13,
        ["伤害类型"] = ____53C2_6570__4F24_5BB3_7C7B_578B_10,
        ["攻击类型"] = ATTACK_TYPE_NORMAL,
        ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = _____53C2_6570["技能ID"],
        ["技能实例ID"] = _____53C2_6570["技能实例ID"],
        ["标签"] = _____53C2_6570["标签"],
        ["伤害形态"] = "单体",
        ["参与技能伤害加成"] = true
    })
    ____exports["施加爱蜜莉雅寒意"](_____65BD_6CD5_8005, _____76EE_6807, _____6765_6E90_952E)
    return true
end
--- 创建场上冰晶节点并在 持续秒 后自动移除（英雄死亡由 A1 统一回收）
____exports["创建爱蜜莉雅场上冰晶"] = function(_____82F1_96C4, _____6765_6E90_6280_80FD, X, Y, _____6301_7EED_79D2)
    local _____8282_70B9 = _____521B_5EFA_7231_871C_8389_96C5_51B0_6676(_____82F1_96C4, _____6765_6E90_6280_80FD, X, Y)
    if _____8282_70B9 == nil then
        return nil
    end
    if _____6301_7EED_79D2 > 0 then
        local _____5E8F_53F7 = _____8282_70B9["序号"]
        local _____5EF6_8FDFID = addDelayedCallback(
            _____6301_7EED_79D2 * 1000,
            function()
                _____79FB_9664_7231_871C_8389_96C5_51B0_6676(_____82F1_96C4, _____5E8F_53F7)
            end
        )
        local _____6CE8_9500 = _____767B_8BB0_7231_871C_8389_96C5_6280_80FD_6E05_7406(
            _____82F1_96C4,
            "冰晶-" .. tostring(_____5E8F_53F7),
            function()
                removeDelayedCallback(_____5EF6_8FDFID)
                _____79FB_9664_7231_871C_8389_96C5_51B0_6676(_____82F1_96C4, _____5E8F_53F7)
            end
        )
        local ____ = _____6CE8_9500
    end
    return _____8282_70B9
end
--- 查询距点最近的冰晶节点（用于 Q 穿晶 / R 读取）
____exports["取最近冰晶"] = function(_____82F1_96C4, X, Y, _____6700_5927_8DDD_79BB)
    local _____5217_8868 = _____67E5_8BE2_7231_871C_8389_96C5_51B0_6676(_____82F1_96C4)
    local _____6700_8FD1_8282_70B9 = nil
    local _____6700_8FD1_8DDD_79BB_5E73_65B9 = _____6700_5927_8DDD_79BB * _____6700_5927_8DDD_79BB
    do
        local i = 0
        while i < #_____5217_8868 do
            local _____8282_70B9 = _____5217_8868[i + 1]
            local d = _____8DDD_79BB_5E73_65B9XY(_____8282_70B9.X, _____8282_70B9.Y, X, Y)
            if d <= _____6700_8FD1_8DDD_79BB_5E73_65B9 then
                _____6700_8FD1_8DDD_79BB_5E73_65B9 = d
                _____6700_8FD1_8282_70B9 = _____8282_70B9
            end
            i = i + 1
        end
    end
    return _____6700_8FD1_8282_70B9
end
--- 按序号读取（移除）一枚冰晶并返回其坐标；不存在返回 null
____exports["读取爱蜜莉雅冰晶节点"] = function(_____82F1_96C4, _____8282_70B9)
    if _____8282_70B9 == nil then
        return nil
    end
    local _____79FB_9664_7ED3_679C = _____79FB_9664_7231_871C_8389_96C5_51B0_6676(_____82F1_96C4, _____8282_70B9["序号"])
    if _____79FB_9664_7ED3_679C == nil then
        return nil
    end
    return {X = _____79FB_9664_7ED3_679C.X, Y = _____79FB_9664_7ED3_679C.Y}
end
local function _____786E_4FDD_6B7B_4EA1_76D1_542C()
    if _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C then
        return
    end
    _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = true
    registerDeathListener(function(dyingUnit, _killingUnit)
        if dyingUnit == nil or dyingUnit == 0 then
            return
        end
        local id = _____53D6_5355_4F4DID(dyingUnit)
        local _____72B6_6001 = _____88AB_52A8_76EE_6807_8868[id]
        if _____72B6_6001 ~= nil then
            _____89E3_51BB_76EE_6807(dyingUnit, _____72B6_6001)
            if _____72B6_6001["霜裂回调ID"] ~= 0 then
                removeDelayedCallback(_____72B6_6001["霜裂回调ID"])
            end
            __TS__Delete(_____88AB_52A8_76EE_6807_8868, id)
            __TS__Delete(_____51BB_7ED3_53BB_91CD_8868, id)
            __TS__Delete(_____788E_51B0_53BB_91CD_8868, id)
            return
        end
        for _____76EE_6807ID in pairs(_____88AB_52A8_76EE_6807_8868) do
            do
                local s = _____88AB_52A8_76EE_6807_8868[_____76EE_6807ID]
                if s == nil or not s["冻结中"] or s["冻结施法者"] == nil then
                    goto __continue60
                end
                if _____53D6_5355_4F4DID(s["冻结施法者"]) == id and s["目标单位"] ~= nil then
                    _____89E3_51BB_76EE_6807(s["目标单位"], s)
                end
            end
            ::__continue60::
        end
    end)
end
_____786E_4FDD_6B7B_4EA1_76D1_542C()
return ____exports
