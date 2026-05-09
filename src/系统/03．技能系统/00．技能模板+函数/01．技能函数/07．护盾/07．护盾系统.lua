local ____lualib = require("lualib_bundle")
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local ____exports = {}
local ____02_FF0E_62A4_76FE_5B9E_4F8B = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾.02．护盾实例")
local _____521B_5EFA_62A4_76FE_5B9E_4F8B = ____02_FF0E_62A4_76FE_5B9E_4F8B["创建护盾实例"]
local _____83B7_53D6_62A4_76FE_5B9E_4F8B = ____02_FF0E_62A4_76FE_5B9E_4F8B["获取护盾实例"]
local _____5220_9664_62A4_76FE_5B9E_4F8B = ____02_FF0E_62A4_76FE_5B9E_4F8B["删除护盾实例"]
local _____83B7_53D6_5355_4F4D_62A4_76FE_5B9E_4F8B_5217_8868 = ____02_FF0E_62A4_76FE_5B9E_4F8B["获取单位护盾实例列表"]
local _____83B7_53D6_5355_4F4D_603B_62A4_76FE_503C = ____02_FF0E_62A4_76FE_5B9E_4F8B["获取单位总护盾值"]
local _____83B7_53D6_5355_4F4D_7C7B_578B_62A4_76FE_503C = ____02_FF0E_62A4_76FE_5B9E_4F8B["获取单位类型护盾值"]
local _____5355_4F4D_662F_5426_6709_62A4_76FE = ____02_FF0E_62A4_76FE_5B9E_4F8B["单位是否有护盾"]
local _____5220_9664_5355_4F4D_6240_6709_62A4_76FE = ____02_FF0E_62A4_76FE_5B9E_4F8B["删除单位所有护盾"]
local _____53D6_53E5_67C4ID = ____02_FF0E_62A4_76FE_5B9E_4F8B["取句柄ID"]
local ____04_FF0E_62A4_76FE_4F24_5BB3_7ED3_7B97 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾.04．护盾伤害结算")
local _____5438_6536_4F24_5BB3 = ____04_FF0E_62A4_76FE_4F24_5BB3_7ED3_7B97["吸收伤害"]
local _____6CE8_518C_62A4_76FE_5438_6536_94A9_5B50 = ____04_FF0E_62A4_76FE_4F24_5BB3_7ED3_7B97["注册护盾吸收钩子"]
local ____05_FF0E_62A4_76FE_751F_547D_5468_671F = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾.05．护盾生命周期")
local _____521D_59CB_5316_62A4_76FE_751F_547D_5468_671F = ____05_FF0E_62A4_76FE_751F_547D_5468_671F["初始化护盾生命周期"]
local ____06_FF0E_62A4_76FE_6761_8868_73B0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾.06．护盾条表现")
local _____521B_5EFA_62A4_76FE_6761 = ____06_FF0E_62A4_76FE_6761_8868_73B0["创建护盾条"]
local _____5220_9664_62A4_76FE_6761 = ____06_FF0E_62A4_76FE_6761_8868_73B0["删除护盾条"]
local _____62A4_76FE_6761_95EA_8272 = ____06_FF0E_62A4_76FE_6761_8868_73B0["护盾条闪色"]
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.index")
local debugLogForce = ____require_result_0.debugLogForce
local GetHandleId = jass.GetHandleId
local _____8C03_8BD5_6A21_5757_540D = "护盾系统"
local _____5DF2_521D_59CB_5316 = false
local function _____786E_4FDD_521D_59CB_5316()
    if _____5DF2_521D_59CB_5316 then
        return
    end
    _____5DF2_521D_59CB_5316 = true
    _____521D_59CB_5316_62A4_76FE_751F_547D_5468_671F()
    _____6CE8_518C_62A4_76FE_5438_6536_94A9_5B50()
    debugLogForce(_____8C03_8BD5_6A21_5757_540D, "护盾系统初始化完成")
end
--- 为单位创建护盾
-- 
-- @param 单位 目标单位
-- @param 参数 护盾参数
-- @returns 护盾ID，失败返回 0
____exports["开始护盾"] = function(_____5355_4F4D, _____53C2_6570)
    _____786E_4FDD_521D_59CB_5316()
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return 0
    end
    if _____53C2_6570["数值"] <= 0 then
        return 0
    end
    local _____5B9E_4F8B = _____521B_5EFA_62A4_76FE_5B9E_4F8B(_____5355_4F4D, _____53C2_6570)
    if _____5B9E_4F8B == nil then
        return 0
    end
    if _____5B9E_4F8B["显示护盾条"] then
        _____521B_5EFA_62A4_76FE_6761(_____5355_4F4D)
    end
    if type(_____5B9E_4F8B["开始回调"]) == "function" then
        _____5B9E_4F8B["开始回调"](_____5355_4F4D, _____5B9E_4F8B.id)
    end
    debugLogForce(
        _____8C03_8BD5_6A21_5757_540D,
        "创建护盾",
        "id=",
        _____5B9E_4F8B.id,
        "类型=",
        _____5B9E_4F8B["类型"],
        "数值=",
        _____5B9E_4F8B["当前值"]
    )
    return _____5B9E_4F8B.id
end
--- 移除指定护盾
____exports["移除护盾"] = function(_____62A4_76FEID)
    local _____5B9E_4F8B = _____83B7_53D6_62A4_76FE_5B9E_4F8B(_____62A4_76FEID)
    if _____5B9E_4F8B == nil then
        return false
    end
    local _____5355_4F4D = _____5B9E_4F8B["单位"]
    local _____5355_4F4DID = _____5B9E_4F8B["单位ID"]
    _____5220_9664_62A4_76FE_5B9E_4F8B(_____62A4_76FEID)
    if type(_____5B9E_4F8B["结束回调"]) == "function" then
        _____5B9E_4F8B["结束回调"](_____5355_4F4D, _____62A4_76FEID, "手动移除")
    end
    if not _____5355_4F4D_662F_5426_6709_62A4_76FE(_____5355_4F4DID) then
        _____5220_9664_62A4_76FE_6761(_____5355_4F4D)
    end
    return true
end
--- 移除单位的所有护盾
____exports["移除单位全部护盾"] = function(_____5355_4F4D)
    local _____5355_4F4DID = _____53D6_53E5_67C4ID(_____5355_4F4D)
    if _____5355_4F4DID == 0 then
        return
    end
    local _____5220_9664_5217_8868 = _____5220_9664_5355_4F4D_6240_6709_62A4_76FE(_____5355_4F4DID)
    for ____, _____5B9E_4F8B in ipairs(_____5220_9664_5217_8868) do
        if type(_____5B9E_4F8B["结束回调"]) == "function" then
            _____5B9E_4F8B["结束回调"](_____5355_4F4D, _____5B9E_4F8B.id, "手动移除")
        end
    end
    _____5220_9664_62A4_76FE_6761(_____5355_4F4D)
end
--- 获取护盾信息
____exports["获取护盾信息"] = function(_____62A4_76FEID)
    local _____5B9E_4F8B = _____83B7_53D6_62A4_76FE_5B9E_4F8B(_____62A4_76FEID)
    if _____5B9E_4F8B == nil then
        return nil
    end
    return {
        ["类型"] = _____5B9E_4F8B["类型"],
        ["当前值"] = _____5B9E_4F8B["当前值"],
        ["初始值"] = _____5B9E_4F8B["初始值"],
        ["剩余时间"] = _____5B9E_4F8B["剩余时间"],
        ["总持续时间"] = _____5B9E_4F8B["总持续时间"]
    }
end
--- 查询单位总护盾值
____exports["查询单位总护盾值"] = function(_____5355_4F4D)
    local _____5355_4F4DID = _____53D6_53E5_67C4ID(_____5355_4F4D)
    return _____83B7_53D6_5355_4F4D_603B_62A4_76FE_503C(_____5355_4F4DID)
end
--- 查询单位指定类型护盾值
____exports["查询单位类型护盾值"] = function(_____5355_4F4D, _____7C7B_578B)
    local _____5355_4F4DID = _____53D6_53E5_67C4ID(_____5355_4F4D)
    return _____83B7_53D6_5355_4F4D_7C7B_578B_62A4_76FE_503C(_____5355_4F4DID, _____7C7B_578B)
end
--- 查询单位是否有护盾
____exports["查询单位是否有护盾"] = function(_____5355_4F4D)
    local _____5355_4F4DID = _____53D6_53E5_67C4ID(_____5355_4F4D)
    return _____5355_4F4D_662F_5426_6709_62A4_76FE(_____5355_4F4DID)
end
--- 获取单位护盾列表（信息）
____exports["查询单位护盾列表"] = function(_____5355_4F4D)
    local _____5355_4F4DID = _____53D6_53E5_67C4ID(_____5355_4F4D)
    local _____5B9E_4F8B_5217_8868 = _____83B7_53D6_5355_4F4D_62A4_76FE_5B9E_4F8B_5217_8868(_____5355_4F4DID)
    return __TS__ArrayMap(
        _____5B9E_4F8B_5217_8868,
        function(____, _____5B9E_4F8B) return {
            id = _____5B9E_4F8B.id,
            ["类型"] = _____5B9E_4F8B["类型"],
            ["当前值"] = _____5B9E_4F8B["当前值"],
            ["初始值"] = _____5B9E_4F8B["初始值"],
            ["剩余时间"] = _____5B9E_4F8B["剩余时间"]
        } end
    )
end
--- 处理护盾吸收（供伤害系统调用）
-- 
-- @param 目标 受伤单位
-- @param 伤害值 待结算伤害
-- @param 是物理伤害 是否物理伤害
-- @param 是魔法伤害 是否魔法伤害
-- @param 攻击者 攻击者
-- @returns 剩余伤害
____exports["处理护盾吸收"] = function(_____76EE_6807, _____4F24_5BB3_503C, _____662F_7269_7406_4F24_5BB3, _____662F_9B54_6CD5_4F24_5BB3, _____653B_51FB_8005)
    _____786E_4FDD_521D_59CB_5316()
    local _____7ED3_679C = _____5438_6536_4F24_5BB3(
        _____76EE_6807,
        _____4F24_5BB3_503C,
        _____662F_7269_7406_4F24_5BB3,
        _____662F_9B54_6CD5_4F24_5BB3,
        _____653B_51FB_8005
    )
    if _____7ED3_679C["总吸收量"] > 0 then
        local _____4F24_5BB3_7C7B_578B = _____662F_7269_7406_4F24_5BB3 and 1 or (_____662F_9B54_6CD5_4F24_5BB3 and 2 or 0)
        _____62A4_76FE_6761_95EA_8272(_____76EE_6807, _____4F24_5BB3_7C7B_578B)
    end
    if #_____7ED3_679C["破碎护盾"] > 0 then
        local _____5355_4F4DID = _____53D6_53E5_67C4ID(_____76EE_6807)
        if not _____5355_4F4D_662F_5426_6709_62A4_76FE(_____5355_4F4DID) then
            _____5220_9664_62A4_76FE_6761(_____76EE_6807)
        end
    end
    return _____7ED3_679C["剩余伤害"]
end
local g = _G
if type(g["开始护盾"]) ~= "function" then
    g["开始护盾"] = ____exports["开始护盾"]
end
if type(g["移除护盾"]) ~= "function" then
    g["移除护盾"] = ____exports["移除护盾"]
end
if type(g["处理护盾吸收"]) ~= "function" then
    g["处理护盾吸收"] = ____exports["处理护盾吸收"]
end
return ____exports
