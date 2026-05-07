local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____01_FF0EYDUserData_517C_5BB9 = require("lib.扩展函数.YDWE函数.01．YDUserData兼容")
local YDUserDataGet = ____01_FF0EYDUserData_517C_5BB9.YDUserDataGet
local YDUserDataSet = ____01_FF0EYDUserData_517C_5BB9.YDUserDataSet
local ____01_FF0EFourCC_8F6C_6362 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换")
local stringToFourCC = ____01_FF0EFourCC_8F6C_6362.stringToFourCC
--- TS 侧对旧 JASS 弹幕系统（DMXT）的便捷封装。
-- 这里只负责给“现成单位”写入弹幕属性、加入弹幕组、启动触发器；
-- 不负责创建弹幕单位本身。
-- 配套底层 JASS 源文件：
-- `JASS/jass复制粘贴/jass的弹幕系统参考.j`
-- 
-- 后续 AI / 调用者使用约定：
-- 1. 先自己创建好弹幕单位，并设置好朝向；本文件不负责 CreateUnit。
-- 2. 再调用 `注册单位到弹幕系统` 或 `快捷注册直线弹幕` 把该单位登记进旧 JASS 弹幕系统。
-- 3. 如果想做“冲击波命中半径 200 的敌人，造成固定 300 伤害”，优先这样配：
--    - `伤害半径: 200`
--    - `伤害绑定: 300`
--    - `碰撞消失: true` 表示命中后消失；`false` 表示继续飞行并扫到沿途单位
-- 4. 如果想做“智力×3”这类动态伤害，则改传 `伤害系数: 3`，让旧 JASS 弹幕系统按主人属性倍率结算。
-- 5. `注册冲击波弹幕` 支持两种写法：
--    - `300`：按固定伤害处理，自动写入 `伤害绑定`
--    - `{ 伤害系数: 3 }`：按动态伤害处理，自动写入 `伤害系数`
-- 6. `飞行速度` 不是“每秒真实位移”。底层 JASS 会先把它乘 `0.66`，再按 `0.04` 秒循环推进一次。
--    - 实际每秒位移 = `飞行速度 × 0.66 ÷ 0.04 = 飞行速度 × 16.5`
--    - 例如想做“1 秒飞 1000 码”的弹幕，`飞行速度` 应设为约 `60.6`
--    - 实际配置可取 `60` 或 `61`
-- 7. `伤害系数` 是给主人属性倍率用的；要固定伤害时，主要看 `伤害绑定`。
-- 8. `伤害类型` 只是便捷写法，会自动回填到旧 JASS 识别的布尔字段。
local jass = require("jass.common")
local japi = require("jass.japi")
local jglobals = require("jass.globals")
local function _____83B7_53D6_5F39_5E55_7CFB_7EDF_89E6_53D1_5668()
    local ____jglobals_gg_trg_____________DMXT_0 = jglobals.gg_trg_____________DMXT
    if ____jglobals_gg_trg_____________DMXT_0 == nil then
        ____jglobals_gg_trg_____________DMXT_0 = _G.gg_trg_____________DMXT
    end
    local ____jglobals_gg_trg_____________DMXT_0_1 = ____jglobals_gg_trg_____________DMXT_0
    if ____jglobals_gg_trg_____________DMXT_0_1 == nil then
        ____jglobals_gg_trg_____________DMXT_0_1 = nil
    end
    return ____jglobals_gg_trg_____________DMXT_0_1
end
local function _____83B7_53D6_5F39_5E55_7CFB_7EDF_5355_4F4D_7EC4()
    return YDUserDataGet(
        nil,
        "string",
        "弹幕系统",
        "单位组",
        "group"
    )
end
local function _____5199_5165_5E03_5C14_5C5E_6027(_____5355_4F4D, _____5C5E_6027_540D, _____503C)
    if _____503C == nil then
        return
    end
    YDUserDataSet(
        nil,
        "unit",
        _____5355_4F4D,
        _____5C5E_6027_540D,
        "boolean",
        _____503C
    )
end
local function _____5199_5165_5B9E_6570_5C5E_6027(_____5355_4F4D, _____5C5E_6027_540D, _____503C)
    if _____503C == nil then
        return
    end
    YDUserDataSet(
        nil,
        "unit",
        _____5355_4F4D,
        _____5C5E_6027_540D,
        "real",
        _____503C
    )
end
local function _____5199_5165_5355_4F4D_5C5E_6027(_____5355_4F4D, _____5C5E_6027_540D, _____503C)
    if _____503C == nil or _____503C == 0 then
        return
    end
    YDUserDataSet(
        nil,
        "unit",
        _____5355_4F4D,
        _____5C5E_6027_540D,
        "unit",
        _____503C
    )
end
local function _____5F52_4E00_5316_751F_547D_5468_671FBuff(buff)
    if type(buff) == "number" then
        return buff
    end
    if type(buff) == "string" and #buff == 4 then
        return stringToFourCC(nil, buff)
    end
    return stringToFourCC(nil, "BHwe")
end
local function _____6309_4F24_5BB3_7C7B_578B_56DE_586B_5E03_5C14_6807_8BB0(_____53C2_6570)
    if _____53C2_6570["伤害类型"] == nil then
        return
    end
    if _____53C2_6570["伤害类型"] == "攻击特效" then
        _____53C2_6570["攻击特效"] = true
        return
    end
    if _____53C2_6570["伤害类型"] == "强化" then
        _____53C2_6570["强化伤害"] = true
        return
    end
    if _____53C2_6570["伤害类型"] == "金魔法" then
        _____53C2_6570["金魔法伤害"] = true
        return
    end
    if _____53C2_6570["伤害类型"] == "木魔法" then
        _____53C2_6570["木魔法伤害"] = true
        return
    end
    if _____53C2_6570["伤害类型"] == "水魔法" then
        _____53C2_6570["水魔法伤害"] = true
        return
    end
    if _____53C2_6570["伤害类型"] == "火魔法" then
        _____53C2_6570["火魔法伤害"] = true
        return
    end
    if _____53C2_6570["伤害类型"] == "土魔法" then
        _____53C2_6570["土魔法伤害"] = true
        return
    end
    if _____53C2_6570["伤害类型"] == "暗魔法" then
        _____53C2_6570["暗魔法伤害"] = true
    end
end
local function _____8BBE_7F6E_5F39_5E55_5916_89C2(_____5F39_5E55_5355_4F4D, _____53C2_6570)
    if _____53C2_6570["模型"] and _____53C2_6570["模型"] ~= "" then
        japi:DzSetUnitModel(_____5F39_5E55_5355_4F4D, _____53C2_6570["模型"])
    end
    local _____7F29_653EX = _____53C2_6570["缩放X"] or _____53C2_6570["缩放"] or nil
    local _____7F29_653EY = _____53C2_6570["缩放Y"] or _____53C2_6570["缩放"] or nil
    local _____7F29_653EZ = _____53C2_6570["缩放Z"] or _____53C2_6570["缩放"] or nil
    if _____7F29_653EX ~= nil or _____7F29_653EY ~= nil or _____7F29_653EZ ~= nil then
        jass:SetUnitScale(_____5F39_5E55_5355_4F4D, _____7F29_653EX or 1, _____7F29_653EY or 1, _____7F29_653EZ or 1)
    end
    if _____53C2_6570["飞行高度"] ~= nil then
        jass:SetUnitFlyHeight(_____5F39_5E55_5355_4F4D, _____53C2_6570["飞行高度"], 0)
    end
    if _____53C2_6570["禁用碰撞"] ~= false then
        jass:SetUnitPathing(_____5F39_5E55_5355_4F4D, false)
    end
    if _____53C2_6570["生命周期"] ~= nil and _____53C2_6570["生命周期"] > 0 then
        jass:UnitApplyTimedLife(
            _____5F39_5E55_5355_4F4D,
            _____5F52_4E00_5316_751F_547D_5468_671FBuff(_____53C2_6570["生命周期Buff"]),
            _____53C2_6570["生命周期"]
        )
    end
end
local function _____8BBE_7F6E_5F39_5E55_7CFB_7EDF_5C5E_6027(_____5F39_5E55_5355_4F4D, _____53C2_6570)
    _____6309_4F24_5BB3_7C7B_578B_56DE_586B_5E03_5C14_6807_8BB0(_____53C2_6570)
    YDUserDataSet(
        nil,
        "unit",
        _____5F39_5E55_5355_4F4D,
        "主人",
        "unit",
        _____53C2_6570["主人"]
    )
    YDUserDataSet(
        nil,
        "unit",
        _____5F39_5E55_5355_4F4D,
        "飞行速度",
        "real",
        _____53C2_6570["飞行速度"]
    )
    YDUserDataSet(
        nil,
        "unit",
        _____5F39_5E55_5355_4F4D,
        "伤害半径",
        "real",
        _____53C2_6570["伤害半径"]
    )
    YDUserDataSet(
        nil,
        "unit",
        _____5F39_5E55_5355_4F4D,
        "伤害系数",
        "real",
        _____53C2_6570["伤害系数"]
    )
    _____5199_5165_5B9E_6570_5C5E_6027(_____5F39_5E55_5355_4F4D, "最远飞行距离", _____53C2_6570["最远飞行距离"])
    _____5199_5165_5B9E_6570_5C5E_6027(_____5F39_5E55_5355_4F4D, "伤害绑定", _____53C2_6570["伤害绑定"])
    _____5199_5165_5B9E_6570_5C5E_6027(_____5F39_5E55_5355_4F4D, "强化伤害系数", _____53C2_6570["强化伤害系数"])
    _____5199_5165_5B9E_6570_5C5E_6027(_____5F39_5E55_5355_4F4D, "弹射角度", _____53C2_6570["弹射角度"])
    _____5199_5165_5B9E_6570_5C5E_6027(_____5F39_5E55_5355_4F4D, "弹射次数", _____53C2_6570["弹射次数"])
    _____5199_5165_5B9E_6570_5C5E_6027(_____5F39_5E55_5355_4F4D, "弹射次数上限", _____53C2_6570["弹射次数上限"])
    _____5199_5165_5B9E_6570_5C5E_6027(_____5F39_5E55_5355_4F4D, "弹射衰减", _____53C2_6570["弹射衰减"])
    _____5199_5165_5B9E_6570_5C5E_6027(_____5F39_5E55_5355_4F4D, "控制效果", _____53C2_6570["控制效果"])
    _____5199_5165_5E03_5C14_5C5E_6027(_____5F39_5E55_5355_4F4D, "命中效果", _____53C2_6570["命中效果"])
    _____5199_5165_5E03_5C14_5C5E_6027(_____5F39_5E55_5355_4F4D, "碰撞消失", _____53C2_6570["碰撞消失"])
    _____5199_5165_5E03_5C14_5C5E_6027(_____5F39_5E55_5355_4F4D, "攻击效果", _____53C2_6570["攻击特效"])
    _____5199_5165_5E03_5C14_5C5E_6027(_____5F39_5E55_5355_4F4D, "强化伤害", _____53C2_6570["强化伤害"])
    _____5199_5165_5E03_5C14_5C5E_6027(_____5F39_5E55_5355_4F4D, "弹射", _____53C2_6570["弹射"])
    _____5199_5165_5E03_5C14_5C5E_6027(_____5F39_5E55_5355_4F4D, "随机弹射", _____53C2_6570["随机弹射"])
    _____5199_5165_5E03_5C14_5C5E_6027(_____5F39_5E55_5355_4F4D, "金魔法伤害", _____53C2_6570["金魔法伤害"])
    _____5199_5165_5E03_5C14_5C5E_6027(_____5F39_5E55_5355_4F4D, "木魔法伤害", _____53C2_6570["木魔法伤害"])
    _____5199_5165_5E03_5C14_5C5E_6027(_____5F39_5E55_5355_4F4D, "水魔法伤害", _____53C2_6570["水魔法伤害"])
    _____5199_5165_5E03_5C14_5C5E_6027(_____5F39_5E55_5355_4F4D, "火魔法伤害", _____53C2_6570["火魔法伤害"])
    _____5199_5165_5E03_5C14_5C5E_6027(_____5F39_5E55_5355_4F4D, "土魔法伤害", _____53C2_6570["土魔法伤害"])
    _____5199_5165_5E03_5C14_5C5E_6027(_____5F39_5E55_5355_4F4D, "暗魔法伤害", _____53C2_6570["暗魔法伤害"])
    _____5199_5165_5355_4F4D_5C5E_6027(_____5F39_5E55_5355_4F4D, "指定敌人", _____53C2_6570["指定敌人"])
end
local function _____542F_52A8_5F39_5E55_7CFB_7EDF_89E6_53D1_5668()
    local trig = _____83B7_53D6_5F39_5E55_7CFB_7EDF_89E6_53D1_5668()
    if trig == nil then
        return
    end
    if not jass:IsTriggerEnabled(trig) then
        jass:EnableTrigger(trig)
    end
end
____exports["注册单位到弹幕系统"] = function(_____5F39_5E55_5355_4F4D, _____53C2_6570)
    if _____5F39_5E55_5355_4F4D == nil or _____5F39_5E55_5355_4F4D == 0 then
        return nil
    end
    if _____53C2_6570 == nil or _____53C2_6570["主人"] == nil or _____53C2_6570["主人"] == 0 then
        return nil
    end
    _____8BBE_7F6E_5F39_5E55_5916_89C2(_____5F39_5E55_5355_4F4D, _____53C2_6570)
    _____8BBE_7F6E_5F39_5E55_7CFB_7EDF_5C5E_6027(_____5F39_5E55_5355_4F4D, _____53C2_6570)
    local _____5355_4F4D_7EC4 = _____83B7_53D6_5F39_5E55_7CFB_7EDF_5355_4F4D_7EC4()
    if _____5355_4F4D_7EC4 ~= nil then
        jass:GroupAddUnit(_____5355_4F4D_7EC4, _____5F39_5E55_5355_4F4D)
    end
    _____542F_52A8_5F39_5E55_7CFB_7EDF_89E6_53D1_5668()
    return _____5F39_5E55_5355_4F4D
end
____exports["快捷注册直线弹幕"] = function(_____5F39_5E55_5355_4F4D, _____4E3B_4EBA, _____98DE_884C_901F_5EA6, _____4F24_5BB3_534A_5F84, _____4F24_5BB3_7CFB_6570, _____989D_5916_53C2_6570)
    return ____exports["注册单位到弹幕系统"](
        _____5F39_5E55_5355_4F4D,
        __TS__ObjectAssign({["主人"] = _____4E3B_4EBA, ["飞行速度"] = _____98DE_884C_901F_5EA6, ["伤害半径"] = _____4F24_5BB3_534A_5F84, ["伤害系数"] = _____4F24_5BB3_7CFB_6570}, _____989D_5916_53C2_6570 or ({}))
    )
end
local function _____89E3_6790_51B2_51FB_6CE2_4F24_5BB3_914D_7F6E(_____4F24_5BB3_914D_7F6E)
    if type(_____4F24_5BB3_914D_7F6E) == "number" then
        return {["伤害绑定"] = _____4F24_5BB3_914D_7F6E}
    end
    if _____4F24_5BB3_914D_7F6E["固定伤害"] ~= nil then
        return {["伤害绑定"] = _____4F24_5BB3_914D_7F6E["固定伤害"]}
    end
    if _____4F24_5BB3_914D_7F6E["伤害系数"] ~= nil then
        return {["伤害系数"] = _____4F24_5BB3_914D_7F6E["伤害系数"]}
    end
    return {}
end
____exports["注册冲击波弹幕"] = function(_____5F39_5E55_5355_4F4D, _____4E3B_4EBA, _____4F24_5BB3_914D_7F6E, _____534A_5F84, _____989D_5916_53C2_6570)
    local _____4F24_5BB3_53C2_6570 = _____89E3_6790_51B2_51FB_6CE2_4F24_5BB3_914D_7F6E(_____4F24_5BB3_914D_7F6E)
    return ____exports["注册单位到弹幕系统"](
        _____5F39_5E55_5355_4F4D,
        __TS__ObjectAssign({["主人"] = _____4E3B_4EBA, ["飞行速度"] = _____989D_5916_53C2_6570 and _____989D_5916_53C2_6570["飞行速度"] or 0, ["伤害半径"] = _____534A_5F84}, _____989D_5916_53C2_6570 or ({}), {["伤害系数"] = 0}, _____4F24_5BB3_53C2_6570)
    )
end
return ____exports
