--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____533A_57DF_6548_679C = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.04．区域效果.区域效果")
local _____521B_5EFA_533A_57DF_6548_679C = _____533A_57DF_6548_679C["创建区域效果"]
--- 区域效果测试
-- 
-- 输入 "1101"：在大法师位置创建区域效果，测试进入/离开事件
local jass = require("jass.common")
local g = require("jass.globals")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitName = jass.GetUnitName
local GetHandleId = jass.GetHandleId
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_1["注册聊天命令监听"]
local sfbModule = require("lib.扩展函数.Star扩展函数.Star扩展库.04．快速Buff系统")
local SFB_setBuff = sfbModule.SFB_setBuff
local SFB_setSlow = sfbModule.SFB_setSlow
local _____6A21_5757_540D = "区域效果测试"
local _____6D4B_8BD5_547D_4EE4 = "1101"
local function getSFBUnit()
    return sfbModule.SFB_Unit
end
local function safeUnitName(u)
    if u == nil or u == 0 then
        return "无效单位"
    end
    local n = GetUnitName(u)
    return type(n) == "string" and n ~= "" and n or "无名单位"
end
local function safeHid(h)
    if h == nil or h == 0 then
        return 0
    end
    return GetHandleId(h)
end
local _____5F53_524D_6D4B_8BD5_5355_4F4D
local function _____533A_57DF_6548_679C_6D4B_8BD5__8FDB_5165(_____5355_4F4D)
    local _____6D4B_8BD5_5355_4F4D = _____5F53_524D_6D4B_8BD5_5355_4F4D
    if _____6D4B_8BD5_5355_4F4D == nil or _____6D4B_8BD5_5355_4F4D == 0 or _____5355_4F4D == nil or _____5355_4F4D == 0 then
        debugLogForce(_____6A21_5757_540D, "[进入-跳过] 测试单位或进入单位无效")
        return
    end
    local sfbUnit = getSFBUnit()
    debugLogForce(
        _____6A21_5757_540D,
        ((((("[进入] SFB_Unit=" .. (sfbUnit ~= nil and sfbUnit ~= 0 and ("有效(hid=" .. tostring(safeHid(sfbUnit))) .. ")" or "NULL!")) .. " 目标=") .. safeUnitName(_____5355_4F4D)) .. "(hid=") .. tostring(safeHid(_____5355_4F4D))) .. ")"
    )
    SFB_setSlow(
        _____6D4B_8BD5_5355_4F4D,
        _____5355_4F4D,
        0,
        30,
        1
    )
    debugLogForce(_____6A21_5757_540D, "进入区域，减速1秒")
end
local function _____533A_57DF_6548_679C_6D4B_8BD5__79BB_5F00(_____5355_4F4D)
    local _____6D4B_8BD5_5355_4F4D = _____5F53_524D_6D4B_8BD5_5355_4F4D
    if _____6D4B_8BD5_5355_4F4D == nil or _____6D4B_8BD5_5355_4F4D == 0 or _____5355_4F4D == nil or _____5355_4F4D == 0 then
        debugLogForce(_____6A21_5757_540D, "[离开-跳过] 测试单位或离开单位无效")
        return
    end
    local sfbUnit = getSFBUnit()
    debugLogForce(
        _____6A21_5757_540D,
        ((((("[离开] SFB_Unit=" .. (sfbUnit ~= nil and sfbUnit ~= 0 and ("有效(hid=" .. tostring(safeHid(sfbUnit))) .. ")" or "NULL!")) .. " 目标=") .. safeUnitName(_____5355_4F4D)) .. "(hid=") .. tostring(safeHid(_____5355_4F4D))) .. ")"
    )
    SFB_setBuff(_____6D4B_8BD5_5355_4F4D, _____5355_4F4D, 0, 1)
    debugLogForce(_____6A21_5757_540D, "离开区域，眩晕1秒")
end
local function _____533A_57DF_6548_679C_6D4B_8BD5__9500_6BC1()
    debugLogForce(_____6A21_5757_540D, "区域效果已结束")
end
local function ____on_804A_5929_6D4B_8BD5()
    local _____6D4B_8BD5_5355_4F4D = g.gg_unit_Hamg_0002
    if _____6D4B_8BD5_5355_4F4D == nil or _____6D4B_8BD5_5355_4F4D == 0 then
        debugLogForce(_____6A21_5757_540D, "错误：未找到 gg_unit_Hamg_0002")
        return
    end
    _____5F53_524D_6D4B_8BD5_5355_4F4D = _____6D4B_8BD5_5355_4F4D
    _____521B_5EFA_533A_57DF_6548_679C({
        X = GetUnitX(_____6D4B_8BD5_5355_4F4D),
        Y = GetUnitY(_____6D4B_8BD5_5355_4F4D),
        ["半径"] = 400,
        ["持续时间"] = 10,
        ["检测间隔"] = 1,
        ["影响目标"] = "全部",
        ["所有者"] = _____6D4B_8BD5_5355_4F4D,
        ["周期伤害"] = 50,
        ["on进入"] = _____533A_57DF_6548_679C_6D4B_8BD5__8FDB_5165,
        ["on离开"] = _____533A_57DF_6548_679C_6D4B_8BD5__79BB_5F00,
        ["on销毁"] = _____533A_57DF_6548_679C_6D4B_8BD5__9500_6BC1
    })
    debugLogForce(
        _____6A21_5757_540D,
        "完整效果已创建",
        ((("位置=(" .. tostring(GetUnitX(_____6D4B_8BD5_5355_4F4D))) .. ",") .. tostring(GetUnitY(_____6D4B_8BD5_5355_4F4D))) .. ")"
    )
    debugLogForce(_____6A21_5757_540D, "请让其他单位进入/离开区域测试")
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_804A_5929_6D4B_8BD5)
debugLogForce(_____6A21_5757_540D, "已注册测试：输入", _____6D4B_8BD5_547D_4EE4, "在大法师位置创建区域效果")
return ____exports
