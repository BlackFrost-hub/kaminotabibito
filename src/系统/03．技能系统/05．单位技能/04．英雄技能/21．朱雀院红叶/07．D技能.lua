local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____79FB_9664D_72B6_6001, jass, removeDelayedCallback, _____79FB_9664_5355_4F4D_6307_5B9ABuff, _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548, debugLogForce, _____79D8_4F20BuffID, _____5200_73AF_7279_6548_952E, ____D_72B6_6001_8868
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.21．朱雀院红叶.00．配置")
local _____6731_96C0_9662_7EA2_53F6_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院红叶技能配置"]
local _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院红叶表现配置"]
local _____6731_96C0_9662_7EA2_53F6_97F3_6548_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院红叶音效配置"]
local _____6731_96C0_9662_7EA2_53F6Buff_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院红叶Buff配置"]
local _____6731_96C0_9662_7EA2_53F6_52A8_4F5C_69FD = ____00_FF0E_914D_7F6E["朱雀院红叶动作槽"]
local _____6731_96C0_9662_7EA2_53F6_5F85_5E73_8861_6570_503C = ____00_FF0E_914D_7F6E["朱雀院红叶待平衡数值"]
function _____79FB_9664D_72B6_6001(_____82F1_96C4)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return
    end
    local id = jass.GetHandleId(_____82F1_96C4)
    local _____72B6_6001 = ____D_72B6_6001_8868[id]
    if _____72B6_6001 == nil then
        return
    end
    if _____72B6_6001["到期回调ID"] ~= 0 then
        removeDelayedCallback(_____72B6_6001["到期回调ID"])
        _____72B6_6001["到期回调ID"] = 0
    end
    debugLogForce(
        "红叶-D",
        "Buff",
        "操作",
        "移除",
        "目标",
        _____82F1_96C4
    )
    _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548(_____82F1_96C4, _____5200_73AF_7279_6548_952E)
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____82F1_96C4, _____79D8_4F20BuffID)
    __TS__Delete(____D_72B6_6001_8868, id)
end
jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local getGameTime = ____require_result_1.getGameTime
local addDelayedCallback = ____require_result_1.addDelayedCallback
removeDelayedCallback = ____require_result_1.removeDelayedCallback
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____require_result_2["注册单位技能壳监听"]
local ____require_result_3 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_3.registerManualBuff
_____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_3["移除单位指定Buff"]
local ____require_result_4 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_5355_4F4D_5750_6807_8DDF_968F_7279_6548 = ____require_result_4["创建单位坐标跟随特效"]
_____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548 = ____require_result_4["销毁单位坐标跟随特效"]
local ____require_result_5 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_UnitPlayReuse = ____require_result_5.Sound3DII_UnitPlayReuse
local ____require_result_6 = require("系统.09．表现系统.10．英雄语音.10．技能喊话.01．英雄技能喊话")
local _____64AD_653E_82F1_96C4_6280_80FD_558A_8BDD = ____require_result_6["播放英雄技能喊话"]
local ____require_result_7 = require("系统.03．技能系统.05．单位技能.04．英雄技能.21．朱雀院红叶.02．被动效果")
local _____662F_6731_96C0_9662_7EA2_53F6 = ____require_result_7["是朱雀院红叶"]
local _____767B_8BB0_6731_96C0_9662_6E05_7406 = ____require_result_7["登记朱雀院清理"]
local _____6CE8_518C_7834_7EFD_65A9_76D1_542C = ____require_result_7["注册破绽斩监听"]
local _____64AD_653E_7EA2_53F6_52A8_4F5C = ____require_result_7["播放红叶动作"]
local ____require_result_8 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
debugLogForce = ____require_result_8.debugLogForce
local _____82F1_96C4_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____6731_96C0_9662_7EA2_53F6_6280_80FD_914D_7F6E["单位类型ID"])
_____79D8_4F20BuffID = _____6731_96C0_9662_7EA2_53F6Buff_914D_7F6E["秘传三式"]
local ____D_914D_7F6E = _____6731_96C0_9662_7EA2_53F6_5F85_5E73_8861_6570_503C.D
local ____D_79D8_4F20_4E09_5F0F_97F3_6548 = _____6731_96C0_9662_7EA2_53F6_97F3_6548_914D_7F6E["D秘传三式"]
_____5200_73AF_7279_6548_952E = "朱雀院红叶D刀环"
____D_72B6_6001_8868 = {}
local function _____5237_65B0D_663E_793A(_____82F1_96C4, _____72B6_6001)
    local _____5269_4F59_79D2 = _____72B6_6001["到期时间"] - getGameTime()
    if _____5269_4F59_79D2 <= 0 then
        _____79FB_9664D_72B6_6001(_____82F1_96C4)
        return
    end
    registerManualBuff(
        _____82F1_96C4,
        _____79D8_4F20BuffID,
        _____5269_4F59_79D2,
        _____72B6_6001["剩余次数"],
        {stack = _____72B6_6001["剩余次数"]}
    )
end
local function _____5F00_542FD_79D8_4F20_4E09_5F0F(_context, _____65BD_6CD5_8005, ______6280_80FD_5B9E_4F8BID)
    debugLogForce("红叶-D", "释放", "技能实例ID", "-")
    if not _____662F_6731_96C0_9662_7EA2_53F6(_____65BD_6CD5_8005) then
        return
    end
    _____64AD_653E_7EA2_53F6_52A8_4F5C(_____65BD_6CD5_8005, _____6731_96C0_9662_7EA2_53F6_52A8_4F5C_69FD["D启动"])
    _____64AD_653E_82F1_96C4_6280_80FD_558A_8BDD(_____65BD_6CD5_8005, "朱雀院红叶", _____6731_96C0_9662_7EA2_53F6_6280_80FD_914D_7F6E.D["技能ID"])
    local id = jass.GetHandleId(_____65BD_6CD5_8005)
    local _____5DF2_6709 = ____D_72B6_6001_8868[id]
    if _____5DF2_6709 ~= nil then
        if _____5DF2_6709["到期回调ID"] ~= 0 then
            removeDelayedCallback(_____5DF2_6709["到期回调ID"])
        end
        _____5DF2_6709["到期时间"] = getGameTime() + ____D_914D_7F6E["持续秒"]
        _____5DF2_6709["到期回调ID"] = addDelayedCallback(
            ____D_914D_7F6E["持续秒"] * 1000,
            function()
                _____79FB_9664D_72B6_6001(_____65BD_6CD5_8005)
            end
        )
        _____5237_65B0D_663E_793A(_____65BD_6CD5_8005, _____5DF2_6709)
        return
    end
    local _____72B6_6001 = {
        ["剩余次数"] = ____D_914D_7F6E["强化次数"],
        ["到期时间"] = getGameTime() + ____D_914D_7F6E["持续秒"],
        ["延长次数"] = 0,
        ["到期回调ID"] = 0
    }
    _____72B6_6001["到期回调ID"] = addDelayedCallback(
        ____D_914D_7F6E["持续秒"] * 1000,
        function()
            _____79FB_9664D_72B6_6001(_____65BD_6CD5_8005)
        end
    )
    ____D_72B6_6001_8868[id] = _____72B6_6001
    debugLogForce("红叶-D", "状态", "开启秘传", _____72B6_6001["剩余次数"])
    _____5237_65B0D_663E_793A(_____65BD_6CD5_8005, _____72B6_6001)
    if _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["D刀环"]["模型路径"] ~= "" then
        _____521B_5EFA_5355_4F4D_5750_6807_8DDF_968F_7279_6548(
            _____65BD_6CD5_8005,
            _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["D刀环"]["模型路径"],
            _____5200_73AF_7279_6548_952E,
            _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["D刀环"]["缩放"],
            _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["D刀环"]["高度"],
            1,
            nil,
            0,
            _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["D刀环"].RGB
        )
    end
    Sound3DII_UnitPlayReuse(____D_79D8_4F20_4E09_5F0F_97F3_6548["路径"], _____65BD_6CD5_8005, ____D_79D8_4F20_4E09_5F0F_97F3_6548["裁断距离"])
    _____767B_8BB0_6731_96C0_9662_6E05_7406(
        _____65BD_6CD5_8005,
        "红叶D",
        function()
            _____79FB_9664D_72B6_6001(_____65BD_6CD5_8005)
        end
    )
end
--- 尝试消费 1 次 D 强化（无 D 状态或次数不足返回 false，技能仍执行基础效果）
____exports["尝试消费D强化"] = function(_____82F1_96C4)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return false
    end
    local _____72B6_6001 = ____D_72B6_6001_8868[jass.GetHandleId(_____82F1_96C4)]
    if _____72B6_6001 == nil or _____72B6_6001["剩余次数"] <= 0 then
        return false
    end
    _____72B6_6001["剩余次数"] = _____72B6_6001["剩余次数"] - 1
    _____5237_65B0D_663E_793A(_____82F1_96C4, _____72B6_6001)
    return true
end
--- 消费 D 的全部剩余强化次数（R 终式用），返回实际消费次数
____exports["消费全部D强化"] = function(_____82F1_96C4)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return 0
    end
    local _____72B6_6001 = ____D_72B6_6001_8868[jass.GetHandleId(_____82F1_96C4)]
    if _____72B6_6001 == nil then
        return 0
    end
    local _____6B21_6570 = _____72B6_6001["剩余次数"]
    if _____6B21_6570 <= 0 then
        return 0
    end
    _____72B6_6001["剩余次数"] = 0
    _____5237_65B0D_663E_793A(_____82F1_96C4, _____72B6_6001)
    return _____6B21_6570
end
--- R 收束 / 主动结束 D（移除 Buff、刀环、计时器与表项）
____exports["结束D秘传"] = function(_____82F1_96C4)
    _____79FB_9664D_72B6_6001(_____82F1_96C4)
end
--- 获取 D 剩余强化次数（R 判定用）
____exports["获取D剩余强化次数"] = function(_____82F1_96C4)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return 0
    end
    local _____72B6_6001 = ____D_72B6_6001_8868[jass.GetHandleId(_____82F1_96C4)]
    return _____72B6_6001 ~= nil and _____72B6_6001["剩余次数"] or 0
end
local function _____7834_7EFD_65A9_5EF6_957FD(_____7EA2_53F6, ______76EE_6807)
    if _____7EA2_53F6 == nil or _____7EA2_53F6 == 0 then
        return
    end
    local _____72B6_6001 = ____D_72B6_6001_8868[jass.GetHandleId(_____7EA2_53F6)]
    if _____72B6_6001 == nil then
        return
    end
    if _____72B6_6001["延长次数"] >= ____D_914D_7F6E["最大延长次数"] then
        return
    end
    _____72B6_6001["延长次数"] = _____72B6_6001["延长次数"] + 1
    _____72B6_6001["到期时间"] = _____72B6_6001["到期时间"] + ____D_914D_7F6E["延长秒"]
    if _____72B6_6001["到期回调ID"] ~= 0 then
        removeDelayedCallback(_____72B6_6001["到期回调ID"])
    end
    _____72B6_6001["到期回调ID"] = addDelayedCallback(
        (_____72B6_6001["到期时间"] - getGameTime()) * 1000,
        function()
            _____79FB_9664D_72B6_6001(_____7EA2_53F6)
        end
    )
    _____5237_65B0D_663E_793A(_____7EA2_53F6, _____72B6_6001)
end
local _____5DF2_6CE8_518C = false
____exports["注册朱雀院红叶D"] = function()
    debugLogForce(
        "红叶-D",
        "注册",
        "名称",
        "D",
        "函数",
        "注册朱雀院红叶D"
    )
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518C_7834_7EFD_65A9_76D1_542C(_____7834_7EFD_65A9_5EF6_957FD)
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "朱雀院红叶-秘传三式（D）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = "AMD1",
        ["获取或创建上下文"] = function(unit)
            return {["英雄"] = unit}
        end,
        ["释放技能"] = _____5F00_542FD_79D8_4F20_4E09_5F0F,
        ["创建独立技能实例"] = false
    })
end
____exports["朱雀院红叶D模块"] = {["技能ID"] = _____6731_96C0_9662_7EA2_53F6_6280_80FD_914D_7F6E.D["技能ID"], ["持续秒"] = ____D_914D_7F6E["持续秒"], ["强化次数"] = ____D_914D_7F6E["强化次数"], ["注册"] = ____exports["注册朱雀院红叶D"]}
return ____exports
