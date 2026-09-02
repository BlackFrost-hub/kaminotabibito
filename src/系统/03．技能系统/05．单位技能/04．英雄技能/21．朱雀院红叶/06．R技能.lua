--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.21．朱雀院红叶.00．配置")
local _____6731_96C0_9662_7EA2_53F6_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院红叶技能配置"]
local _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院红叶表现配置"]
local _____6731_96C0_9662_7EA2_53F6_97F3_6548_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院红叶音效配置"]
local _____6731_96C0_9662_7EA2_53F6_52A8_4F5C_69FD = ____00_FF0E_914D_7F6E["朱雀院红叶动作槽"]
local _____6731_96C0_9662_7EA2_53F6_5F85_5E73_8861_6570_503C = ____00_FF0E_914D_7F6E["朱雀院红叶待平衡数值"]
local _____6731_96C0_9662_7EA2_53F6_8BFB_6761_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院红叶读条配置"]
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____require_result_1["注册单位技能壳监听"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统")
local _____5F00_59CB_5145_80FD = ____require_result_2["开始充能"]
local ____require_result_3 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6280_80FD_4F24_5BB3 = ____require_result_3["造成技能伤害"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_4["读取单位攻击力"]
local _____5355_4F4D_5B58_6D3B = ____require_result_4["单位存活"]
local _____4E24_70B9_89D2_5EA6 = ____require_result_4["两点角度"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.09．形状区域.扇形区域")
local _____83B7_53D6_6247_5F62_533A_57DF_5355_4F4D = ____require_result_5["获取扇形区域单位"]
local ____require_result_6 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_6["创建点特效"]
local ____require_result_7 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_UnitPlayReuse = ____require_result_7.Sound3DII_UnitPlayReuse
local Sound3DII_CooPlayReuse = ____require_result_7.Sound3DII_CooPlayReuse
local ____require_result_8 = require("系统.09．表现系统.10．英雄语音.10．技能喊话.01．英雄技能喊话")
local _____64AD_653E_82F1_96C4_6280_80FD_558A_8BDD = ____require_result_8["播放英雄技能喊话"]
local ____require_result_9 = require("系统.03．技能系统.05．单位技能.04．英雄技能.21．朱雀院红叶.02．被动效果")
local _____65BD_52A0_6731_96C0_9662_7834_7EFD = ____require_result_9["施加朱雀院破绽"]
local _____6D88_8D39_5168_90E8_5200_52BF = ____require_result_9["消费全部刀势"]
local _____662F_6731_96C0_9662_7EA2_53F6 = ____require_result_9["是朱雀院红叶"]
local _____64AD_653E_7EA2_53F6_52A8_4F5C = ____require_result_9["播放红叶动作"]
local ____require_result_10 = require("系统.03．技能系统.05．单位技能.04．英雄技能.21．朱雀院红叶.05．E技能")
local _____8BFB_53D6_6700_8FD1_5251_75D5_5E76_9501_5B9A = ____require_result_10["读取最近剑痕并锁定"]
local ____require_result_11 = require("系统.03．技能系统.05．单位技能.04．英雄技能.21．朱雀院红叶.07．D技能")
local _____6D88_8D39_5168_90E8D_5F3A_5316 = ____require_result_11["消费全部D强化"]
local _____7ED3_675FD_79D8_4F20 = ____require_result_11["结束D秘传"]
local ____require_result_12 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_12.debugLogForce
local _____82F1_96C4_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____6731_96C0_9662_7EA2_53F6_6280_80FD_914D_7F6E["单位类型ID"])
local ____R_6280_80FDID = stringToFourCCSafe(_____6731_96C0_9662_7EA2_53F6_6280_80FD_914D_7F6E.R["技能ID"])
local ____R_914D_7F6E = _____6731_96C0_9662_7EA2_53F6_5F85_5E73_8861_6570_503C.R
local ____R_84C4_52BF_97F3_6548 = _____6731_96C0_9662_7EA2_53F6_97F3_6548_914D_7F6E["R蓄势"]
local ____R_7EA2_53F6_4E00_95EA_97F3_6548 = _____6731_96C0_9662_7EA2_53F6_97F3_6548_914D_7F6E["R红叶一闪"]
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local function _____53D6_7A84_7EBF_654C_4EBA(_____65BD_6CD5_8005, _____65B9_5411_89D2)
    return _____83B7_53D6_6247_5F62_533A_57DF_5355_4F4D({
        X = GetUnitX(_____65BD_6CD5_8005),
        Y = GetUnitY(_____65BD_6CD5_8005),
        ["半径"] = ____R_914D_7F6E["距离"],
        ["方向角"] = _____65B9_5411_89D2,
        ["扇形角度"] = ____R_914D_7F6E["窄线角度"],
        ["单位筛选"] = function(_____5355_4F4D)
            return _____5355_4F4D ~= _____65BD_6CD5_8005 and _____5355_4F4D_5B58_6D3B(_____5355_4F4D) and jass.IsUnitEnemy(
                _____5355_4F4D,
                jass.GetOwningPlayer(_____65BD_6CD5_8005)
            )
        end
    })
end
local function _____7ED3_7B97R_4F24_5BB3(_____65BD_6CD5_8005, _____76EE_6807, _____6280_80FD_5B9E_4F8BID, _____4F24_5BB3_503C, _____6807_7B7E)
    debugLogForce(
        "红叶-R",
        "伤害",
        "标签",
        _____6807_7B7E,
        "数值",
        _____4F24_5BB3_503C,
        "目标",
        _____76EE_6807
    )
    _____9020_6210_6280_80FD_4F24_5BB3({
        ["来源"] = _____65BD_6CD5_8005,
        ["目标"] = _____76EE_6807,
        ["伤害"] = _____4F24_5BB3_503C,
        ["伤害类型"] = DAMAGE_TYPE_NORMAL,
        ["攻击类型"] = ATTACK_TYPE_NORMAL,
        ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = ____R_6280_80FDID,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["标签"] = _____6807_7B7E,
        ["伤害形态"] = "单体",
        ["参与技能伤害加成"] = true
    })
end
local function ____R_521B_5EFA_7EC8_5F0F(_____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID, ______76EE_6807X, _____76EE_6807Y, _____65B9_5411_89D2)
    if not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_8005) then
        return
    end
    debugLogForce("红叶-R", "状态", "创建终式")
    _____64AD_653E_7EA2_53F6_52A8_4F5C(_____65BD_6CD5_8005, _____6731_96C0_9662_7EA2_53F6_52A8_4F5C_69FD["R释放"])
    local _____5200_52BF_5C42_6570 = _____6D88_8D39_5168_90E8_5200_52BF(_____65BD_6CD5_8005)
    local ____D_6B21_6570 = _____6D88_8D39_5168_90E8D_5F3A_5316(_____65BD_6CD5_8005)
    if ____D_6B21_6570 > 0 then
        _____7ED3_675FD_79D8_4F20(_____65BD_6CD5_8005)
    end
    local _____653B_51FB_529B = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005)
    local _____4E3B_65A9_4F24_5BB3 = _____653B_51FB_529B * (____R_914D_7F6E["主斩攻击力倍率"] + ____D_6B21_6570 * ____R_914D_7F6E["D强化每次加成"])
    local _____654C_4EBA = _____53D6_7A84_7EBF_654C_4EBA(_____65BD_6CD5_8005, _____65B9_5411_89D2)
    do
        local i = 0
        while i < #_____654C_4EBA do
            _____7ED3_7B97R_4F24_5BB3(
                _____65BD_6CD5_8005,
                _____654C_4EBA[i + 1],
                _____6280_80FD_5B9E_4F8BID,
                _____4E3B_65A9_4F24_5BB3,
                "朱雀院红叶-R主斩"
            )
            _____65BD_52A0_6731_96C0_9662_7834_7EFD(_____65BD_6CD5_8005, _____654C_4EBA[i + 1])
            i = i + 1
        end
    end
    if _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["R主斩"]["模型路径"] ~= "" then
        debugLogForce("红叶-R", "特效", "路径", _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["R主斩"]["模型路径"])
        _____521B_5EFA_70B9_7279_6548({
            ["模型路径"] = _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["R主斩"]["模型路径"],
            RGB = _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["R主斩"].RGB,
            X = GetUnitX(_____65BD_6CD5_8005),
            Y = GetUnitY(_____65BD_6CD5_8005),
            Z = _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["R主斩"]["高度"],
            ["面向角度"] = _____65B9_5411_89D2,
            ["缩放"] = _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["R主斩"]["缩放"],
            ["持续秒"] = _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["R主斩"]["持续秒"]
        })
    end
    do
        local _____5C42 = 0
        while _____5C42 < _____5200_52BF_5C42_6570 and _____5C42 < 3 do
            do
                local i = 0
                while i < #_____654C_4EBA do
                    _____7ED3_7B97R_4F24_5BB3(
                        _____65BD_6CD5_8005,
                        _____654C_4EBA[i + 1],
                        _____6280_80FD_5B9E_4F8BID,
                        _____653B_51FB_529B * ____R_914D_7F6E["刀势回响攻击力倍率"],
                        "朱雀院红叶-R刀势回响"
                    )
                    i = i + 1
                end
            end
            _____5C42 = _____5C42 + 1
        end
    end
    local _____5251_75D5 = _____8BFB_53D6_6700_8FD1_5251_75D5_5E76_9501_5B9A(_____65BD_6CD5_8005)
    if _____5251_75D5 ~= nil then
        do
            local i = 0
            while i < #_____654C_4EBA do
                _____7ED3_7B97R_4F24_5BB3(
                    _____65BD_6CD5_8005,
                    _____654C_4EBA[i + 1],
                    _____6280_80FD_5B9E_4F8BID,
                    _____653B_51FB_529B * ____R_914D_7F6E["剑痕回响攻击力倍率"],
                    "朱雀院红叶-R剑痕回响"
                )
                i = i + 1
            end
        end
        local ____ = _____5251_75D5
    end
end
local function _____91CA_653ER_5965_4E49(_context, _____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID)
    debugLogForce("红叶-R", "释放", "技能实例ID", _____6280_80FD_5B9E_4F8BID or "-")
    if not _____662F_6731_96C0_9662_7EA2_53F6(_____65BD_6CD5_8005) then
        return
    end
    _____64AD_653E_7EA2_53F6_52A8_4F5C(_____65BD_6CD5_8005, _____6731_96C0_9662_7EA2_53F6_52A8_4F5C_69FD["R蓄力"])
    local _____4E2D_5FC3X = GetSpellTargetX()
    local _____4E2D_5FC3Y = GetSpellTargetY()
    local _____65B9_5411_89D2 = _____4E24_70B9_89D2_5EA6(
        GetUnitX(_____65BD_6CD5_8005),
        GetUnitY(_____65BD_6CD5_8005),
        _____4E2D_5FC3X,
        _____4E2D_5FC3Y
    )
    local _____9884_8B66_7279_6548 = nil
    local _____5145_80FDID = _____5F00_59CB_5145_80FD(
        _____65BD_6CD5_8005,
        {
            ["持续时间"] = ____R_914D_7F6E["蓄力秒"],
            ["指令中断"] = true,
            ["世界坐标进度UI"] = true,
            ["世界坐标进度UI类型"] = _____6731_96C0_9662_7EA2_53F6_8BFB_6761_914D_7F6E["UI类型"],
            ["世界坐标进度UI标题"] = "奥义·红叶一闪",
            ["世界坐标进度UI数值后缀"] = _____6731_96C0_9662_7EA2_53F6_8BFB_6761_914D_7F6E["数值后缀"],
            ["世界坐标进度UI高度偏移"] = _____6731_96C0_9662_7EA2_53F6_8BFB_6761_914D_7F6E["跟随Z偏移"],
            ["显示进度条特效"] = false,
            ["开始回调"] = function(______5355_4F4D, ______5145_80FDID)
                Sound3DII_UnitPlayReuse(____R_84C4_52BF_97F3_6548["路径"], _____65BD_6CD5_8005, ____R_84C4_52BF_97F3_6548["裁断距离"])
                if _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["R蓄力提示"]["模型路径"] ~= nil and _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["R蓄力提示"]["模型路径"] ~= "" then
                    _____9884_8B66_7279_6548 = _____521B_5EFA_70B9_7279_6548({
                        ["模型路径"] = _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["R蓄力提示"]["模型路径"],
                        RGB = _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["R蓄力提示"].RGB,
                        X = _____4E2D_5FC3X,
                        Y = _____4E2D_5FC3Y,
                        Z = _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["R蓄力提示"]["高度"],
                        ["缩放"] = _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["R蓄力提示"]["缩放"],
                        ["持续秒"] = _____6731_96C0_9662_7EA2_53F6_8868_73B0_914D_7F6E["R蓄力提示"]["持续秒"]
                    })
                end
            end,
            ["充能完成回调"] = function(______5355_4F4D, ______5145_80FDID)
                debugLogForce("红叶-R", "状态", "蓄力完成")
                Sound3DII_CooPlayReuse(
                    ____R_7EA2_53F6_4E00_95EA_97F3_6548["路径"],
                    GetUnitX(_____65BD_6CD5_8005),
                    GetUnitY(_____65BD_6CD5_8005),
                    ____R_7EA2_53F6_4E00_95EA_97F3_6548["高度"],
                    ____R_7EA2_53F6_4E00_95EA_97F3_6548["裁断距离"]
                )
                ____R_521B_5EFA_7EC8_5F0F(
                    _____65BD_6CD5_8005,
                    _____6280_80FD_5B9E_4F8BID,
                    _____4E2D_5FC3X,
                    _____4E2D_5FC3Y,
                    _____65B9_5411_89D2
                )
            end,
            ["结束回调"] = function(______5355_4F4D, ______539F_56E0, ______5145_80FDID)
                debugLogForce("红叶-R", "结束", "原因", "-")
                if _____9884_8B66_7279_6548 ~= nil and _____9884_8B66_7279_6548 ~= 0 then
                    jass.DestroyEffect(_____9884_8B66_7279_6548)
                    _____9884_8B66_7279_6548 = nil
                end
            end
        }
    )
    if _____5145_80FDID > 0 then
        _____64AD_653E_82F1_96C4_6280_80FD_558A_8BDD(_____65BD_6CD5_8005, "朱雀院红叶", _____6731_96C0_9662_7EA2_53F6_6280_80FD_914D_7F6E.R["技能ID"])
    end
end
local _____5DF2_6CE8_518C = false
____exports["注册朱雀院红叶R"] = function()
    debugLogForce(
        "红叶-R",
        "注册",
        "名称",
        "R",
        "函数",
        "注册朱雀院红叶R"
    )
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "朱雀院红叶-奥义·红叶一闪（R）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = "AMR1",
        ["获取或创建上下文"] = function(unit)
            return {["英雄"] = unit}
        end,
        ["释放技能"] = _____91CA_653ER_5965_4E49,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = ____R_914D_7F6E["蓄力秒"] + 1
    })
end
____exports["朱雀院红叶R模块"] = {["技能ID"] = _____6731_96C0_9662_7EA2_53F6_6280_80FD_914D_7F6E.R["技能ID"], ["蓄力秒"] = ____R_914D_7F6E["蓄力秒"], ["世界坐标读条"] = _____6731_96C0_9662_7EA2_53F6_8BFB_6761_914D_7F6E, ["注册"] = ____exports["注册朱雀院红叶R"]}
return ____exports
