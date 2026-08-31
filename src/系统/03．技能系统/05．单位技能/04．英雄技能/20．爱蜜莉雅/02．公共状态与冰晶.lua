local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__Delete = ____lualib.__TS__Delete
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local _____53D6_53E5_67C4, _____6E05_7406_5168_90E8_8FDB_5EA6UI, _____6267_884C_5168_90E8_6280_80FD_6E05_7406, _____53D6_5355_4F4DID, _____9500_6BC1_70B9_7279_6548, _____9500_6BC1_4E16_754C_5750_6807_8FDB_5EA6UI, _____7231_871C_8389_96C5_72B6_6001_8868
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.20．爱蜜莉雅.00．配置")
local _____7231_871C_8389_96C5_51B0_6676_914D_7F6E = ____00_FF0E_914D_7F6E["爱蜜莉雅冰晶配置"]
local _____7231_871C_8389_96C5_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["爱蜜莉雅技能配置"]
local _____7231_871C_8389_96C5_8868_73B0_914D_7F6E = ____00_FF0E_914D_7F6E["爱蜜莉雅表现配置"]
function _____53D6_53E5_67C4(_____82F1_96C4)
    return _____53D6_5355_4F4DID(_____82F1_96C4)
end
--- 按创建序号移除单枚冰晶（销毁特效与引用）。返回被移除节点或 null。
____exports["移除爱蜜莉雅冰晶"] = function(_____82F1_96C4, _____5E8F_53F7)
    local _____72B6_6001 = _____7231_871C_8389_96C5_72B6_6001_8868[_____53D6_53E5_67C4(_____82F1_96C4)]
    if _____72B6_6001 == nil then
        return nil
    end
    do
        local i = 0
        while i < #_____72B6_6001["冰晶列表"] do
            do
                local _____8282_70B9 = _____72B6_6001["冰晶列表"][i + 1]
                if _____8282_70B9["序号"] ~= _____5E8F_53F7 then
                    goto __continue27
                end
                __TS__ArraySplice(_____72B6_6001["冰晶列表"], i, 1)
                _____9500_6BC1_70B9_7279_6548(_____8282_70B9["特效句柄"])
                _____8282_70B9["已读取"] = true
                return _____8282_70B9
            end
            ::__continue27::
            i = i + 1
        end
    end
    return nil
end
--- 清理全部冰晶（技能结束/场景清理）。返回清理数量。
____exports["清理爱蜜莉雅全部冰晶"] = function(_____82F1_96C4)
    local _____72B6_6001 = _____7231_871C_8389_96C5_72B6_6001_8868[_____53D6_53E5_67C4(_____82F1_96C4)]
    if _____72B6_6001 == nil then
        return 0
    end
    local _____6570_91CF = 0
    while #_____72B6_6001["冰晶列表"] > 0 do
        if ____exports["移除爱蜜莉雅冰晶"](_____82F1_96C4, _____72B6_6001["冰晶列表"][1]["序号"]) ~= nil then
            _____6570_91CF = _____6570_91CF + 1
        end
    end
    return _____6570_91CF
end
--- 清理 D 强化状态（到期/打断/死亡/R 收束）。
____exports["清理爱蜜莉雅D强化"] = function(_____82F1_96C4)
    local _____72B6_6001 = _____7231_871C_8389_96C5_72B6_6001_8868[_____53D6_53E5_67C4(_____82F1_96C4)]
    if _____72B6_6001 == nil then
        return
    end
    _____72B6_6001["D强化"] = nil
end
function _____6E05_7406_5168_90E8_8FDB_5EA6UI(_____72B6_6001)
    while #_____72B6_6001["进度UI列表"] > 0 do
        local ui = _____72B6_6001["进度UI列表"][1]
        __TS__ArraySplice(_____72B6_6001["进度UI列表"], 0, 1)
        _____9500_6BC1_4E16_754C_5750_6807_8FDB_5EA6UI(ui)
    end
end
function _____6267_884C_5168_90E8_6280_80FD_6E05_7406(_____72B6_6001)
    for _____6807_7B7E in pairs(_____72B6_6001["技能清理表"]) do
        local _____6E05_7406 = _____72B6_6001["技能清理表"][_____6807_7B7E]
        if _____6E05_7406 ~= nil then
            _____6E05_7406()
        end
    end
    for _____6807_7B7E in pairs(_____72B6_6001["技能清理表"]) do
        __TS__Delete(_____72B6_6001["技能清理表"], _____6807_7B7E)
    end
end
--- 统一回收入口：英雄死亡 / 技能打断 / 目标失效 / 地图清理 / 主动清理。
-- 依次清理：冰晶节点 → D 强化 → 世界坐标进度 UI → 技能清理表 → 摘除状态表项。幂等。
____exports["清理爱蜜莉雅状态"] = function(_____82F1_96C4, _____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "主动清理"
    end
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return false
    end
    local id = _____53D6_53E5_67C4(_____82F1_96C4)
    local _____72B6_6001 = _____7231_871C_8389_96C5_72B6_6001_8868[id]
    if _____72B6_6001 == nil then
        return false
    end
    if _____72B6_6001["已清理"] then
        return true
    end
    _____72B6_6001["已清理"] = true
    local ____ = _____539F_56E0
    ____exports["清理爱蜜莉雅全部冰晶"](_____82F1_96C4)
    ____exports["清理爱蜜莉雅D强化"](_____82F1_96C4)
    _____6E05_7406_5168_90E8_8FDB_5EA6UI(_____72B6_6001)
    _____6267_884C_5168_90E8_6280_80FD_6E05_7406(_____72B6_6001)
    __TS__Delete(_____7231_871C_8389_96C5_72B6_6001_8868, id)
    return true
end
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_0.registerDeathListener
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local getGameTime = ____require_result_1.getGameTime
local addDelayedCallback = ____require_result_1.addDelayedCallback
local removeDelayedCallback = ____require_result_1.removeDelayedCallback
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
_____53D6_5355_4F4DID = ____require_result_2["取单位ID"]
local _____5355_4F4D_5B58_6D3B = ____require_result_2["单位存活"]
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_3["创建点特效"]
_____9500_6BC1_70B9_7279_6548 = ____require_result_3["销毁点特效"]
local ____require_result_4 = require("系统.09．表现系统.15．世界坐标进度UI.01．世界坐标进度UI")
_____9500_6BC1_4E16_754C_5750_6807_8FDB_5EA6UI = ____require_result_4["销毁世界坐标进度UI"]
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
local _____82F1_96C4_5355_4F4D_7C7B_578BID = jass.FourCC(_____7231_871C_8389_96C5_6280_80FD_914D_7F6E["单位类型ID"])
_____7231_871C_8389_96C5_72B6_6001_8868 = {}
local _____4E0B_4E00_5168_5C40_51B0_6676_5E8F_53F7 = 1
local _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
local function _____53D6_6216_5EFA_72B6_6001(_____82F1_96C4)
    local id = _____53D6_53E5_67C4(_____82F1_96C4)
    local _____72B6_6001 = _____7231_871C_8389_96C5_72B6_6001_8868[id]
    if _____72B6_6001 == nil then
        _____72B6_6001 = {
            ["冰晶列表"] = {},
            ["下一冰晶序号"] = 1,
            ["D强化"] = nil,
            ["进度UI列表"] = {},
            ["技能清理表"] = {},
            ["已清理"] = false
        }
        _____7231_871C_8389_96C5_72B6_6001_8868[id] = _____72B6_6001
    end
    return _____72B6_6001
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
        if _____7231_871C_8389_96C5_72B6_6001_8868[id] == nil then
            return
        end
        ____exports["清理爱蜜莉雅状态"](dyingUnit, "英雄死亡")
    end)
end
--- 创建冰晶节点；超过上限时按配置替换最旧节点（旧节点特效与引用一并清除）。返回新节点或 null（创建失败）。
____exports["创建爱蜜莉雅冰晶"] = function(_____82F1_96C4, _____6765_6E90_6280_80FD, X, Y, Z)
    if Z == nil then
        Z = _____7231_871C_8389_96C5_8868_73B0_914D_7F6E["冰晶节点"]["高度"]
    end
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 or not _____5355_4F4D_5B58_6D3B(_____82F1_96C4) then
        return nil
    end
    local _____72B6_6001 = _____53D6_6216_5EFA_72B6_6001(_____82F1_96C4)
    if _____72B6_6001["已清理"] then
        return nil
    end
    while #_____72B6_6001["冰晶列表"] >= _____7231_871C_8389_96C5_51B0_6676_914D_7F6E["数量上限"] do
        ____exports["移除爱蜜莉雅冰晶"](_____82F1_96C4, _____72B6_6001["冰晶列表"][1]["序号"])
    end
    local _____7279_6548_53E5_67C4 = _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____7231_871C_8389_96C5_8868_73B0_914D_7F6E["冰晶节点"]["模型路径"],
        RGB = _____7231_871C_8389_96C5_8868_73B0_914D_7F6E["冰晶节点"].RGB,
        X = X,
        Y = Y,
        Z = Z,
        ["面向角度"] = 0,
        ["缩放"] = _____7231_871C_8389_96C5_8868_73B0_914D_7F6E["冰晶节点"]["缩放"],
        ["持续秒"] = _____7231_871C_8389_96C5_8868_73B0_914D_7F6E["冰晶节点"]["持续秒"]
    })
    if _____7279_6548_53E5_67C4 == nil or _____7279_6548_53E5_67C4 == 0 then
        return nil
    end
    local ____4E0B_4E00_5168_5C40_51B0_6676_5E8F_53F7_5 = _____4E0B_4E00_5168_5C40_51B0_6676_5E8F_53F7
    _____4E0B_4E00_5168_5C40_51B0_6676_5E8F_53F7 = ____4E0B_4E00_5168_5C40_51B0_6676_5E8F_53F7_5 + 1
    local _____8282_70B9 = {
        ["序号"] = ____4E0B_4E00_5168_5C40_51B0_6676_5E8F_53F7_5,
        ["创建时间"] = getGameTime(),
        ["来源技能"] = _____6765_6E90_6280_80FD,
        X = X,
        Y = Y,
        Z = Z,
        ["已读取"] = false,
        ["特效句柄"] = _____7279_6548_53E5_67C4
    }
    local ____72B6_6001__51B0_6676_5217_8868_6 = _____72B6_6001["冰晶列表"]
    ____72B6_6001__51B0_6676_5217_8868_6[#____72B6_6001__51B0_6676_5217_8868_6 + 1] = _____8282_70B9
    return _____8282_70B9
end
--- 查询冰晶节点（按创建顺序返回副本；过滤条件可选）
____exports["查询爱蜜莉雅冰晶"] = function(_____82F1_96C4, _____8FC7_6EE4)
    local _____72B6_6001 = _____7231_871C_8389_96C5_72B6_6001_8868[_____53D6_53E5_67C4(_____82F1_96C4)]
    if _____72B6_6001 == nil then
        return {}
    end
    local _____7ED3_679C = {}
    do
        local i = 0
        while i < #_____72B6_6001["冰晶列表"] do
            do
                local _____8282_70B9 = _____72B6_6001["冰晶列表"][i + 1]
                if _____8FC7_6EE4 ~= nil and not _____8FC7_6EE4(_____8282_70B9) then
                    goto __continue18
                end
                _____7ED3_679C[#_____7ED3_679C + 1] = _____8282_70B9
            end
            ::__continue18::
            i = i + 1
        end
    end
    return _____7ED3_679C
end
--- 读取并移除冰晶（Q 穿晶 / R 读取前置节点）。
-- 规则："最旧" 取序号最小，"最近" 取序号最大；返回被读取节点信息（特效已销毁），无节点返回 null。
____exports["读取爱蜜莉雅冰晶"] = function(_____82F1_96C4, _____89C4_5219)
    if _____89C4_5219 == nil then
        _____89C4_5219 = "最旧"
    end
    local _____72B6_6001 = _____7231_871C_8389_96C5_72B6_6001_8868[_____53D6_53E5_67C4(_____82F1_96C4)]
    if _____72B6_6001 == nil or #_____72B6_6001["冰晶列表"] <= 0 then
        return nil
    end
    local _____76EE_6807_5E8F_53F7 = -1
    if _____89C4_5219 == "最旧" then
        _____76EE_6807_5E8F_53F7 = _____72B6_6001["冰晶列表"][1]["序号"]
    else
        _____76EE_6807_5E8F_53F7 = _____72B6_6001["冰晶列表"][#_____72B6_6001["冰晶列表"]]["序号"]
    end
    return ____exports["移除爱蜜莉雅冰晶"](_____82F1_96C4, _____76EE_6807_5E8F_53F7)
end
____exports["获取爱蜜莉雅D强化"] = function(_____82F1_96C4)
    local _____72B6_6001 = _____7231_871C_8389_96C5_72B6_6001_8868[_____53D6_53E5_67C4(_____82F1_96C4)]
    if _____72B6_6001 == nil or _____72B6_6001["D强化"] == nil or not _____72B6_6001["D强化"]["激活"] then
        return nil
    end
    if _____72B6_6001["D强化"]["到期时间"] > 0 and getGameTime() >= _____72B6_6001["D强化"]["到期时间"] then
        ____exports["清理爱蜜莉雅D强化"](_____82F1_96C4)
        return nil
    end
    return _____72B6_6001["D强化"]
end
--- 设置 D 强化状态（重复开启时覆盖旧状态，旧计时器由技能清理表负责清理）。
____exports["设置爱蜜莉雅D强化"] = function(_____82F1_96C4, _____5269_4F59_6B21_6570, _____6301_7EED_6BEB_79D2)
    local _____72B6_6001 = _____53D6_6216_5EFA_72B6_6001(_____82F1_96C4)
    local _____65B0_72B6_6001 = {
        ["激活"] = true,
        ["剩余次数"] = _____5269_4F59_6B21_6570 > 0 and _____5269_4F59_6B21_6570 or 0,
        ["到期时间"] = _____6301_7EED_6BEB_79D2 > 0 and getGameTime() + _____6301_7EED_6BEB_79D2 or 0
    }
    _____72B6_6001["D强化"] = _____65B0_72B6_6001
    return _____65B0_72B6_6001
end
--- 消费一次强化资源；无资源返回 false。
____exports["消费爱蜜莉雅D强化"] = function(_____82F1_96C4)
    local _____72B6_6001 = ____exports["获取爱蜜莉雅D强化"](_____82F1_96C4)
    if _____72B6_6001 == nil then
        return false
    end
    if _____72B6_6001["剩余次数"] <= 0 then
        return false
    end
    _____72B6_6001["剩余次数"] = _____72B6_6001["剩余次数"] - 1
    return true
end
--- 登记世界坐标进度 UI 句柄（随英雄状态统一销毁；重复登记同一句柄自动去重）。
____exports["登记爱蜜莉雅进度UI"] = function(_____82F1_96C4, ui)
    if ui == nil or ui == 0 then
        return
    end
    local _____72B6_6001 = _____53D6_6216_5EFA_72B6_6001(_____82F1_96C4)
    do
        local i = 0
        while i < #_____72B6_6001["进度UI列表"] do
            if _____72B6_6001["进度UI列表"][i + 1] == ui then
                return
            end
            i = i + 1
        end
    end
    local ____72B6_6001__8FDB_5EA6UI_5217_8868_7 = _____72B6_6001["进度UI列表"]
    ____72B6_6001__8FDB_5EA6UI_5217_8868_7[#____72B6_6001__8FDB_5EA6UI_5217_8868_7 + 1] = ui
end
--- 立即销毁指定世界坐标进度 UI 并从登记移除。
____exports["销毁爱蜜莉雅进度UI"] = function(_____82F1_96C4, ui)
    if ui == nil or ui == 0 then
        return
    end
    local _____72B6_6001 = _____7231_871C_8389_96C5_72B6_6001_8868[_____53D6_53E5_67C4(_____82F1_96C4)]
    _____9500_6BC1_4E16_754C_5750_6807_8FDB_5EA6UI(ui)
    if _____72B6_6001 == nil then
        return
    end
    do
        local i = 0
        while i < #_____72B6_6001["进度UI列表"] do
            if _____72B6_6001["进度UI列表"][i + 1] == ui then
                __TS__ArraySplice(_____72B6_6001["进度UI列表"], i, 1)
                return
            end
            i = i + 1
        end
    end
end
--- 登记技能清理回调，返回注销函数（幂等）。
____exports["登记爱蜜莉雅技能清理"] = function(_____82F1_96C4, _____6807_7B7E, _____6E05_7406)
    local _____72B6_6001 = _____53D6_6216_5EFA_72B6_6001(_____82F1_96C4)
    _____72B6_6001["技能清理表"][_____6807_7B7E] = _____6E05_7406
    return function()
        local _____5F53_524D = _____7231_871C_8389_96C5_72B6_6001_8868[_____53D6_53E5_67C4(_____82F1_96C4)]
        if _____5F53_524D ~= nil and _____5F53_524D["技能清理表"][_____6807_7B7E] == _____6E05_7406 then
            __TS__Delete(_____5F53_524D["技能清理表"], _____6807_7B7E)
        end
    end
end
local function _____9500_6BC1_72B6_6001_5185_5168_90E8_51B0_6676_7279_6548(_____72B6_6001)
    while #_____72B6_6001["冰晶列表"] > 0 do
        local _____8282_70B9 = _____72B6_6001["冰晶列表"][1]
        __TS__ArraySplice(_____72B6_6001["冰晶列表"], 0, 1)
        _____9500_6BC1_70B9_7279_6548(_____8282_70B9["特效句柄"])
        _____8282_70B9["已读取"] = true
    end
end
--- 地图清理 / 场景结束：清理全部爱蜜莉雅状态（不依赖单位句柄反查，TSTL 无 handle 反查 API）。返回清理数量。
____exports["清理全部爱蜜莉雅状态"] = function(_____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "地图清理"
    end
    local _____6570_91CF = 0
    local ids = {}
    for id in pairs(_____7231_871C_8389_96C5_72B6_6001_8868) do
        ids[#ids + 1] = __TS__Number(id)
    end
    do
        local i = 0
        while i < #ids do
            do
                local _____72B6_6001 = _____7231_871C_8389_96C5_72B6_6001_8868[ids[i + 1]]
                if _____72B6_6001 == nil or _____72B6_6001["已清理"] then
                    goto __continue74
                end
                _____72B6_6001["已清理"] = true
                local ____ = _____539F_56E0
                _____9500_6BC1_72B6_6001_5185_5168_90E8_51B0_6676_7279_6548(_____72B6_6001)
                _____6E05_7406_5168_90E8_8FDB_5EA6UI(_____72B6_6001)
                _____6267_884C_5168_90E8_6280_80FD_6E05_7406(_____72B6_6001)
                __TS__Delete(_____7231_871C_8389_96C5_72B6_6001_8868, ids[i + 1])
                _____6570_91CF = _____6570_91CF + 1
            end
            ::__continue74::
            i = i + 1
        end
    end
    return _____6570_91CF
end
--- 仅供测试/调试：当前登记中的英雄数量与冰晶总数。
____exports["获取爱蜜莉雅状态统计"] = function()
    local _____82F1_96C4_6570 = 0
    local _____51B0_6676_603B_6570 = 0
    for id in pairs(_____7231_871C_8389_96C5_72B6_6001_8868) do
        local _____72B6_6001 = _____7231_871C_8389_96C5_72B6_6001_8868[id]
        if _____72B6_6001 ~= nil then
            _____82F1_96C4_6570 = _____82F1_96C4_6570 + 1
            _____51B0_6676_603B_6570 = _____51B0_6676_603B_6570 + #_____72B6_6001["冰晶列表"]
        end
    end
    return {["英雄数"] = _____82F1_96C4_6570, ["冰晶总数"] = _____51B0_6676_603B_6570}
end
_____786E_4FDD_6B7B_4EA1_76D1_542C()
--- 播放爱蜜莉雅施法动作（接收动作槽，索引/持续秒全部配置驱动），持续后恢复 stand。
____exports["播放爱蜜莉雅动作"] = function(_____82F1_96C4, _____69FD)
    local _____52A8_4F5C_7D22_5F15 = _____69FD["索引"]
    local _____6301_7EED_79D2 = _____69FD["持续秒"]
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 or _____52A8_4F5C_7D22_5F15 <= 0 then
        return
    end
    jass.SetUnitAnimationByIndex(_____82F1_96C4, _____52A8_4F5C_7D22_5F15)
    if _____6301_7EED_79D2 > 0 then
        local _____6062_590DID = addDelayedCallback(
            _____6301_7EED_79D2 * 1000,
            function()
                if _____5355_4F4D_5B58_6D3B(_____82F1_96C4) then
                    jass.SetUnitAnimation(_____82F1_96C4, "stand")
                end
            end
        )
        local _____72B6_6001 = _____7231_871C_8389_96C5_72B6_6001_8868[_____53D6_5355_4F4DID(_____82F1_96C4)]
        if _____72B6_6001 ~= nil then
            _____72B6_6001["技能清理表"]["动作恢复-" .. tostring(_____52A8_4F5C_7D22_5F15)] = function()
                removeDelayedCallback(_____6062_590DID)
            end
        end
    end
end
return ____exports
