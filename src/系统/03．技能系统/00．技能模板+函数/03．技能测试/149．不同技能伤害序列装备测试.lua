--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 不同技能伤害序列装备测试
--
-- 先通过 wp177 / wp181 / wp191 获取待测装备，再输入 1052。
-- 地图预设大法师会对周围每个敌人依次造成 4 次技能伤害，
-- 四次伤害分别携带不同的技能 ID，用于验证不同技能计数与下一次技能伤害触发。
local jass = require("jass.common")
local globals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_0["注册聊天命令监听"]
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_1.debugLogForce
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getEnemyUnitsInRangeOfUnit = ____require_result_2.getEnemyUnitsInRangeOfUnit
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_3.stringToFourCCSafe
local ____require_result_4 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_4["造成单体技能伤害"]
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local _____6A21_5757_540D = "不同技能伤害序列装备测试"
local _____6D4B_8BD5_547D_4EE4 = "1052"
local _____641C_7D22_534A_5F84 = 800
local _____5355_6B21_4F24_5BB3 = 10
local _____6D4B_8BD5_6280_80FDID_5217_8868 = {
    stringToFourCCSafe("T491"),
    stringToFourCCSafe("T492"),
    stringToFourCCSafe("T493"),
    stringToFourCCSafe("T494")
}
local function _____5BF9_76EE_6807_9020_6210_56DB_6B21_4E0D_540C_6280_80FD_4F24_5BB3(_____6765_6E90, _____76EE_6807)
    local _____6210_529F_6B21_6570 = 0
    do
        local i = 0
        while i < #_____6D4B_8BD5_6280_80FDID_5217_8868 do
            local _____5F53_524D_5E8F_53F7 = i + 1
            local _____6210_529F = _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
                ["来源"] = _____6765_6E90,
                ["目标"] = _____76EE_6807,
                ["伤害"] = _____5355_6B21_4F24_5BB3,
                ["伤害类型"] = DAMAGE_TYPE_MAGIC,
                ["来源类型"] = "单位技能",
                ["技能ID"] = _____6D4B_8BD5_6280_80FDID_5217_8868[i + 1],
                ["标签"] = "不同技能序列测试-" .. tostring(_____5F53_524D_5E8F_53F7),
                ["参与技能伤害加成"] = false
            })
            if _____6210_529F then
                _____6210_529F_6B21_6570 = _____6210_529F_6B21_6570 + 1
            end
            i = i + 1
        end
    end
    return _____6210_529F_6B21_6570
end
local function ____on_804A_59291052_4E0D_540C_6280_80FD_6D4B_8BD5(_player, _command)
    local _____5927_6CD5_5E08 = globals.gg_unit_Hamg_0002
    if _____5927_6CD5_5E08 == nil or _____5927_6CD5_5E08 == 0 then
        debugLogForce(_____6A21_5757_540D, "未找到地图预设大法师 gg_unit_Hamg_0002")
        return
    end
    local _____654C_4EBA_5217_8868 = getEnemyUnitsInRangeOfUnit(_____5927_6CD5_5E08, _____641C_7D22_534A_5F84)
    if #_____654C_4EBA_5217_8868 <= 0 then
        debugLogForce(_____6A21_5757_540D, "大法师周围没有可测试敌人", "半径=", _____641C_7D22_534A_5F84)
        return
    end
    local _____603B_6210_529F_4F24_5BB3_6B21_6570 = 0
    do
        local i = 0
        while i < #_____654C_4EBA_5217_8868 do
            _____603B_6210_529F_4F24_5BB3_6B21_6570 = _____603B_6210_529F_4F24_5BB3_6B21_6570 + _____5BF9_76EE_6807_9020_6210_56DB_6B21_4E0D_540C_6280_80FD_4F24_5BB3(_____5927_6CD5_5E08, _____654C_4EBA_5217_8868[i + 1])
            i = i + 1
        end
    end
    debugLogForce(
        _____6A21_5757_540D,
        "测试完成",
        "敌人数=",
        #_____654C_4EBA_5217_8868,
        "每个敌人不同技能数=",
        #_____6D4B_8BD5_6280_80FDID_5217_8868,
        "成功伤害次数=",
        _____603B_6210_529F_4F24_5BB3_6B21_6570,
        "提示=先装备wp177、wp181或wp191再观察对应效果"
    )
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_804A_59291052_4E0D_540C_6280_80FD_6D4B_8BD5)
debugLogForce(_____6A21_5757_540D, "已注册测试：输入", _____6D4B_8BD5_547D_4EE4, "对大法师周围每个敌人造成4次不同技能伤害")
return ____exports
