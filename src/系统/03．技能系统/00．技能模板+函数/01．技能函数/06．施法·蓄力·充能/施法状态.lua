local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____5145_80FD_7CFB_7EDF = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统")
local _____5355_4F4D_662F_5426_6B63_5728_5145_80FD = _____5145_80FD_7CFB_7EDF["单位是否正在充能"]
local _____6CE8_518C_5145_80FD_6253_65AD_56DE_8C03 = _____5145_80FD_7CFB_7EDF["注册充能打断回调"]
local _____53D6_6D88_6CE8_518C_5145_80FD_6253_65AD_56DE_8C03 = _____5145_80FD_7CFB_7EDF["取消注册充能打断回调"]
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local _____6280_80FD_4E8B_4EF6_4E2D_5FC3 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellChannelListener = _____6280_80FD_4E8B_4EF6_4E2D_5FC3.registerSpellChannelListener
local registerSpellEndcastListener = _____6280_80FD_4E8B_4EF6_4E2D_5FC3.registerSpellEndcastListener
local _____5355_4F4D_6B7B_4EA1_4E8B_4EF6_4E2D_5FC3 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = _____5355_4F4D_6B7B_4EA1_4E8B_4EF6_4E2D_5FC3.registerDeathListener
local _____539F_751F_65BD_6CD5_72B6_6001 = {}
local function _____53D6_5355_4F4D_53E5_67C4ID(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return 0
    end
    return GetHandleId(_____5355_4F4D)
end
local function _____5904_7406_539F_751F_65BD_6CD5_5F00_59CB(_____5355_4F4D, ______6280_80FDID)
    local _____5355_4F4DID = _____53D6_5355_4F4D_53E5_67C4ID(_____5355_4F4D)
    if _____5355_4F4DID ~= 0 then
        _____539F_751F_65BD_6CD5_72B6_6001[_____5355_4F4DID] = true
    end
end
local function _____5904_7406_539F_751F_65BD_6CD5_7ED3_675F(_____5355_4F4D, ______6280_80FDID)
    local _____5355_4F4DID = _____53D6_5355_4F4D_53E5_67C4ID(_____5355_4F4D)
    if _____5355_4F4DID ~= 0 then
        __TS__Delete(_____539F_751F_65BD_6CD5_72B6_6001, _____5355_4F4DID)
    end
end
local function _____6E05_7406_6B7B_4EA1_5355_4F4D_65BD_6CD5_72B6_6001(_____6B7B_4EA1_5355_4F4D, ______51FB_6740_5355_4F4D)
    local _____5355_4F4DID = _____53D6_5355_4F4D_53E5_67C4ID(_____6B7B_4EA1_5355_4F4D)
    if _____5355_4F4DID ~= 0 then
        __TS__Delete(_____539F_751F_65BD_6CD5_72B6_6001, _____5355_4F4DID)
    end
end
registerSpellChannelListener(_____5904_7406_539F_751F_65BD_6CD5_5F00_59CB)
registerSpellEndcastListener(_____5904_7406_539F_751F_65BD_6CD5_7ED3_675F)
registerDeathListener(_____6E05_7406_6B7B_4EA1_5355_4F4D_65BD_6CD5_72B6_6001)
--- 判断单位是否处于魔兽原生技能的施法阶段。
-- 状态由 SPELL_CHANNEL / SPELL_ENDCAST 事件维护，不使用轮询或单位组扫描。
____exports["单位是否正在原生施法"] = function(_____5355_4F4D)
    local _____5355_4F4DID = _____53D6_5355_4F4D_53E5_67C4ID(_____5355_4F4D)
    return _____5355_4F4DID ~= 0 and _____539F_751F_65BD_6CD5_72B6_6001[_____5355_4F4DID] == true
end
--- 兼容旧接口：判断项目自定义充能状态，不代表魔兽原生施法状态。
____exports["单位是否正在施法"] = function(_____5355_4F4D)
    return _____5355_4F4D_662F_5426_6B63_5728_5145_80FD(_____5355_4F4D)
end
--- 兼容别名。
-- 推荐优先使用 `单位是否正在施法`。
____exports["单位是否正在蓄力"] = function(_____5355_4F4D)
    return ____exports["单位是否正在施法"](_____5355_4F4D)
end
--- 兼容别名。
-- 推荐优先使用 `单位是否正在施法`。
____exports["单位是否正在施法或蓄力或充能"] = function(_____5355_4F4D)
    return ____exports["单位是否正在施法"](_____5355_4F4D)
end
--- 推荐统一使用这个接口注册“施法被打断”回调。
-- 底层实现与“充能被打断”相同。
____exports["注册施法被打断回调"] = _____6CE8_518C_5145_80FD_6253_65AD_56DE_8C03
--- 推荐统一使用这个接口取消“施法被打断”回调。
-- 底层实现与“充能被打断”相同。
____exports["取消注册施法被打断回调"] = _____53D6_6D88_6CE8_518C_5145_80FD_6253_65AD_56DE_8C03
--- 兼容别名。
-- 推荐优先使用 `注册施法被打断回调`。
____exports["注册蓄力被打断回调"] = _____6CE8_518C_5145_80FD_6253_65AD_56DE_8C03
--- 兼容别名。
-- 推荐优先使用 `取消注册施法被打断回调`。
____exports["取消注册蓄力被打断回调"] = _____53D6_6D88_6CE8_518C_5145_80FD_6253_65AD_56DE_8C03
return ____exports
