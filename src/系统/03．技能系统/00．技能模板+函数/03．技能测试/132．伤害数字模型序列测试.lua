local ____lualib = require("lualib_bundle")
local __TS__ArraySetLength = ____lualib.__TS__ArraySetLength
local ____exports = {}
--- 伤害数字模型序列测试
-- 
-- 输入 1036：开启每秒创建一次伤害数字模型并播放序列动画
-- 输入 1037：关闭测试
local jass = require("jass.common")
local japi = require("jass.japi")
local g = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_0["注册聊天命令监听"]
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local onSecond = ____require_result_1.onSecond
local offSecond = ____require_result_1.offSecond
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_2.debugLogForce
local AddSpecialEffect = jass.AddSpecialEffect
local DestroyEffect = jass.DestroyEffect
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFlyHeight = jass.GetUnitFlyHeight
local R2I = jass.R2I
local EXSetEffectZ = japi.EXSetEffectZ
local DzSetEffectAnimation = japi.DzSetEffectAnimation
local DzSetEffectScale = japi.DzSetEffectScale
local DzSetEffectVisible = japi.DzSetEffectVisible
local _____6A21_5757_540D = "伤害数字模型序列测试"
local _____5F00_542F_547D_4EE4 = "1036"
local _____5173_95ED_547D_4EE4 = "1037"
local _____6A21_578B_8DEF_5F84 = "UI\\DamageNumbers\\DmgNum_8.mdx"
local _____52A8_753B_5E8F_53F7 = 2
local _____7279_6548_7F29_653E = 1.25
local ____Z_504F_79FB = 120
local _____4FDD_7559_79D2_6570 = 2
local _____5F53_524D_79D2_8BA1_6570 = 0
local _____5DF2_5F00_542F = false
local _____5DF2_8BA2_9605_79D2_56DE_8C03 = false
local _____5F85_9500_6BC1_961F_5217 = {}
local function _____83B7_53D6_6D4B_8BD5_5355_4F4D()
    local ____g_gg_unit_Hamg_0002_3 = g.gg_unit_Hamg_0002
    if ____g_gg_unit_Hamg_0002_3 == nil then
        ____g_gg_unit_Hamg_0002_3 = _G.bj_lastCreatedUnit
    end
    return ____g_gg_unit_Hamg_0002_3
end
local function _____8BB0_5F55_5F85_9500_6BC1_7279_6548(effect)
    _____5F85_9500_6BC1_961F_5217[#_____5F85_9500_6BC1_961F_5217 + 1] = {effect = effect, expireSecond = _____5F53_524D_79D2_8BA1_6570 + _____4FDD_7559_79D2_6570}
end
local function _____6E05_7406_5230_671F_7279_6548()
    local writeIndex = 0
    do
        local i = 0
        while i < #_____5F85_9500_6BC1_961F_5217 do
            do
                local item = _____5F85_9500_6BC1_961F_5217[i + 1]
                if item.expireSecond <= _____5F53_524D_79D2_8BA1_6570 then
                    DestroyEffect(item.effect)
                    goto __continue6
                end
                _____5F85_9500_6BC1_961F_5217[writeIndex + 1] = item
                writeIndex = writeIndex + 1
            end
            ::__continue6::
            i = i + 1
        end
    end
    while #_____5F85_9500_6BC1_961F_5217 > writeIndex do
        table.remove(_____5F85_9500_6BC1_961F_5217)
    end
end
local function _____521B_5EFA_4E00_6B21_6A21_578B_5E8F_5217_7279_6548()
    local unit = _____83B7_53D6_6D4B_8BD5_5355_4F4D()
    if unit == nil or unit == 0 then
        debugLogForce(_____6A21_5757_540D, "创建失败：未找到测试单位 gg_unit_Hamg_0002")
        return
    end
    local x = GetUnitX(unit)
    local y = GetUnitY(unit)
    local z = GetUnitFlyHeight(unit) + ____Z_504F_79FB
    local effect = AddSpecialEffect(_____6A21_578B_8DEF_5F84, x, y)
    if effect == nil or effect == 0 then
        debugLogForce(_____6A21_5757_540D, "创建失败：模型句柄为空", "path=", _____6A21_578B_8DEF_5F84)
        return
    end
    if type(EXSetEffectZ) == "function" then
        EXSetEffectZ(effect, z)
    end
    if type(DzSetEffectVisible) == "function" then
        DzSetEffectVisible(effect, true)
    end
    if type(DzSetEffectScale) == "function" then
        DzSetEffectScale(effect, _____7279_6548_7F29_653E)
    end
    if type(DzSetEffectAnimation) == "function" then
        DzSetEffectAnimation(effect, _____52A8_753B_5E8F_53F7, 0)
    end
    _____8BB0_5F55_5F85_9500_6BC1_7279_6548(effect)
    debugLogForce(
        _____6A21_5757_540D,
        "创建成功",
        "path=",
        _____6A21_578B_8DEF_5F84,
        "anim=",
        _____52A8_753B_5E8F_53F7,
        "x=",
        R2I(x),
        "y=",
        R2I(y),
        "z=",
        R2I(z)
    )
end
local function ____on_6BCF_79D2_9A71_52A8()
    _____5F53_524D_79D2_8BA1_6570 = _____5F53_524D_79D2_8BA1_6570 + 1
    _____6E05_7406_5230_671F_7279_6548()
    if not _____5DF2_5F00_542F then
        return
    end
    _____521B_5EFA_4E00_6B21_6A21_578B_5E8F_5217_7279_6548()
end
local function _____5F00_542F_6D4B_8BD5()
    if _____5DF2_5F00_542F then
        debugLogForce(_____6A21_5757_540D, "已经开启，无需重复开启")
        return
    end
    _____5DF2_5F00_542F = true
    if not _____5DF2_8BA2_9605_79D2_56DE_8C03 then
        _____5DF2_8BA2_9605_79D2_56DE_8C03 = true
        onSecond(____on_6BCF_79D2_9A71_52A8)
    end
    debugLogForce(
        _____6A21_5757_540D,
        "已开启：每秒创建模型",
        "模型=",
        _____6A21_578B_8DEF_5F84,
        "动画序号=",
        _____52A8_753B_5E8F_53F7
    )
end
local function _____5173_95ED_6D4B_8BD5()
    if not _____5DF2_5F00_542F then
        debugLogForce(_____6A21_5757_540D, "当前未开启")
    end
    _____5DF2_5F00_542F = false
    if _____5DF2_8BA2_9605_79D2_56DE_8C03 then
        _____5DF2_8BA2_9605_79D2_56DE_8C03 = false
        offSecond(____on_6BCF_79D2_9A71_52A8)
    end
    do
        local i = 0
        while i < #_____5F85_9500_6BC1_961F_5217 do
            DestroyEffect(_____5F85_9500_6BC1_961F_5217[i + 1].effect)
            i = i + 1
        end
    end
    __TS__ArraySetLength(_____5F85_9500_6BC1_961F_5217, 0)
    debugLogForce(_____6A21_5757_540D, "已关闭并清理特效")
end
local function ____on_804A_59291036_5F00_542F_6D4B_8BD5()
    _____5F00_542F_6D4B_8BD5()
end
local function ____on_804A_59291037_5173_95ED_6D4B_8BD5()
    _____5173_95ED_6D4B_8BD5()
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____5F00_542F_547D_4EE4, ____on_804A_59291036_5F00_542F_6D4B_8BD5)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____5173_95ED_547D_4EE4, ____on_804A_59291037_5173_95ED_6D4B_8BD5)
debugLogForce(
    _____6A21_5757_540D,
    "已注册测试命令：",
    _____5F00_542F_547D_4EE4,
    "开启；",
    _____5173_95ED_547D_4EE4,
    "关闭"
)
return ____exports
