local ____lualib = require("lualib_bundle")
local __TS__ArraySort = ____lualib.__TS__ArraySort
local ____exports = {}
local _____82B1_7530_8054_52A8_53D6_89E3_6790_5FEB_7167, _____5355_4F4D_5B58_6D3B, _____89E3_6790_5FEB_7167_6E90
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.25．芙莉莲.00．配置")
local _____8299_8389_83B2_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["芙莉莲技能配置"]
local _____8299_8389_83B2R_914D_7F6E = ____00_FF0E_914D_7F6E["芙莉莲R配置"]
local _____8299_8389_83B2_88AB_52A8_914D_7F6E = ____00_FF0E_914D_7F6E["芙莉莲被动配置"]
local _____8299_8389_83B2_8868_73B0_914D_7F6E = ____00_FF0E_914D_7F6E["芙莉莲表现配置"]
local _____8299_8389_83B2_8BFB_6761_914D_7F6E = ____00_FF0E_914D_7F6E["芙莉莲读条配置"]
function _____82B1_7530_8054_52A8_53D6_89E3_6790_5FEB_7167(_____65BD_6CD5_8005)
    local _____53D6_76EE_6807 = _____89E3_6790_5FEB_7167_6E90["取芙莉莲重点目标"]
    local ____temp_10
    if _____53D6_76EE_6807 ~= nil then
        ____temp_10 = _____53D6_76EE_6807(_____65BD_6CD5_8005)
    else
        ____temp_10 = nil
    end
    local _____76EE_6807 = ____temp_10
    if _____76EE_6807 == nil or _____76EE_6807 == 0 or not _____5355_4F4D_5B58_6D3B(_____76EE_6807) then
        return {["目标"] = nil, ["类型"] = nil, ["完成"] = false}
    end
    local _____7C7B_578B = nil
    if _____89E3_6790_5FEB_7167_6E90["有解析"](_____65BD_6CD5_8005, _____76EE_6807, "攻击") then
        _____7C7B_578B = "攻击"
    elseif _____89E3_6790_5FEB_7167_6E90["有解析"](_____65BD_6CD5_8005, _____76EE_6807, "防御") then
        _____7C7B_578B = "防御"
    elseif _____89E3_6790_5FEB_7167_6E90["有解析"](_____65BD_6CD5_8005, _____76EE_6807, "位置") then
        _____7C7B_578B = "位置"
    end
    return {
        ["目标"] = _____76EE_6807,
        ["类型"] = _____7C7B_578B,
        ["完成"] = _____89E3_6790_5FEB_7167_6E90["目标解析完成"](_____65BD_6CD5_8005, _____76EE_6807)
    }
end
local ____require_result_0 = require("系统.03．技能系统.05．单位技能.04．英雄技能.25．芙莉莲.01A．动作表现")
local _____64AD_653E_9650_65F6_52A8_4F5C = ____require_result_0["播放限时动作"]
local _____5F00_59CB_5FAA_73AF_5B88_62A4 = ____require_result_0["开始循环守护"]
local _____505C_6B62_5FAA_73AF_5B88_62A4 = ____require_result_0["停止循环守护"]
local _____8299_8389_83B2_52A8_4F5C_69FD = ____require_result_0["芙莉莲动作槽"]
local jass = require("jass.common")
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____require_result_2["注册单位技能壳监听"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.27．战斗技能实例生命周期工厂")
local _____521B_5EFA_6218_6597_6280_80FD_5B9E_4F8B = ____require_result_3["创建战斗技能实例"]
local _____67E5_8BE2_6218_6597_6280_80FD_5B9E_4F8B = ____require_result_3["查询战斗技能实例"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统")
local _____5F00_59CB_5145_80FD = ____require_result_4["开始充能"]
local ____require_result_5 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6280_80FD_4F24_5BB3 = ____require_result_5["造成技能伤害"]
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_6["读取单位攻击力"]
_____5355_4F4D_5B58_6D3B = ____require_result_6["单位存活"]
local _____4E24_70B9_89D2_5EA6 = ____require_result_6["两点角度"]
local _____89D2_5EA6_5DEE_7EDD_5BF9_503C = ____require_result_6["角度差绝对值"]
local _____8DDD_79BB_5E73_65B9XY = ____require_result_6["距离平方XY"]
local ____require_result_7 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_7["创建点特效"]
local ____require_result_8 = require("系统.03．技能系统.05．单位技能.04．英雄技能.25．芙莉莲.02．被动效果")
local _____662F_8299_8389_83B2 = ____require_result_8["是芙莉莲"]
local _____8BB0_5F55_8299_8389_83B2_6D3B_52A8 = ____require_result_8["记录芙莉莲活动"]
local _____5FEB_7167_9690_533F = ____require_result_8["快照隐匿"]
local _____6709_89E3_6790 = ____require_result_8["有解析"]
local _____76EE_6807_89E3_6790_5B8C_6210 = ____require_result_8["目标解析完成"]
local _____5C1D_8BD5_6D88_8D39_89E3_6790_5B8C_6210 = ____require_result_8["尝试消费解析完成"]
local _____82B1_7530_8054_52A8 = require("系统.03．技能系统.05．单位技能.04．英雄技能.25．芙莉莲.07．D技能")
local _____82F1_96C4_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____8299_8389_83B2_6280_80FD_914D_7F6E["单位类型ID"])
local ____R_6280_80FDID = stringToFourCCSafe(_____8299_8389_83B2_6280_80FD_914D_7F6E.R["技能ID"])
local ____R_914D_7F6E = _____8299_8389_83B2R_914D_7F6E
local _____88AB_52A8_914D_7F6E = _____8299_8389_83B2_88AB_52A8_914D_7F6E
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local GetOwningPlayer = jass.GetOwningPlayer
local IsUnitEnemy = jass.IsUnitEnemy
local function ____R_7ED3_7B97_4E3B_70AE(_____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID, _____5FEB_7167)
    if not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_8005) then
        return
    end
    local _____653B_51FB_529B = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005)
    local _____534A_5BBD = ____R_914D_7F6E["命中半宽"]
    if _____5FEB_7167["解析类型"] == "位置" then
        _____534A_5BBD = ____R_914D_7F6E["命中半宽"] * ____R_914D_7F6E["位置解析宽度倍率"]
    end
    local _____5206_652F_52A0_6210 = 0
    if _____5FEB_7167["解析类型"] == "攻击" then
        _____5206_652F_52A0_6210 = ____R_914D_7F6E["攻击解析加成倍率"]
    end
    if _____5FEB_7167["解析类型"] == "防御" then
        _____5206_652F_52A0_6210 = ____R_914D_7F6E["防御解析加成倍率"]
    end
    local _____9690_533F_52A0_6210 = _____5FEB_7167["隐匿"] and _____88AB_52A8_914D_7F6E["隐匿首击加成倍率"] or 0
    local _____65BD_6CD5_8005X = GetUnitX(_____65BD_6CD5_8005)
    local _____65BD_6CD5_8005Y = GetUnitY(_____65BD_6CD5_8005)
    local _____547D_4E2D_5217_8868 = {}
    local _____7EC4 = jass.CreateGroup()
    jass.GroupEnumUnitsInRange(
        _____7EC4,
        _____65BD_6CD5_8005X,
        _____65BD_6CD5_8005Y,
        ____R_914D_7F6E["距离"],
        nil
    )
    while true do
        do
            local u = jass.FirstOfGroup(_____7EC4)
            if u == nil or u == 0 then
                break
            end
            jass.GroupRemoveUnit(_____7EC4, u)
            if u == _____65BD_6CD5_8005 or not _____5355_4F4D_5B58_6D3B(u) then
                goto __continue7
            end
            if not IsUnitEnemy(
                u,
                GetOwningPlayer(_____65BD_6CD5_8005)
            ) then
                goto __continue7
            end
            local _____76EE_6807X = GetUnitX(u)
            local _____76EE_6807Y = GetUnitY(u)
            local _____76EE_6807_8DDD_79BB = math.sqrt(_____8DDD_79BB_5E73_65B9XY(_____65BD_6CD5_8005X, _____65BD_6CD5_8005Y, _____76EE_6807X, _____76EE_6807Y))
            if _____76EE_6807_8DDD_79BB <= 0 or _____76EE_6807_8DDD_79BB > ____R_914D_7F6E["距离"] then
                goto __continue7
            end
            local _____5939_89D2 = _____89D2_5EA6_5DEE_7EDD_5BF9_503C(
                _____5FEB_7167["方向角"],
                _____4E24_70B9_89D2_5EA6(_____65BD_6CD5_8005X, _____65BD_6CD5_8005Y, _____76EE_6807X, _____76EE_6807Y)
            )
            local _____5939_89D2_5F27_5EA6 = _____5939_89D2 * 0.01745329252
            local _____6295_5F71 = math.cos(_____5939_89D2_5F27_5EA6) * _____76EE_6807_8DDD_79BB
            local _____5782_8DDD = math.sin(_____5939_89D2_5F27_5EA6) * _____76EE_6807_8DDD_79BB
            if _____6295_5F71 <= 0 or _____5782_8DDD > _____534A_5BBD then
                goto __continue7
            end
            _____547D_4E2D_5217_8868[#_____547D_4E2D_5217_8868 + 1] = {["目标"] = u, ["投影"] = _____6295_5F71}
        end
        ::__continue7::
    end
    jass.DestroyGroup(_____7EC4)
    __TS__ArraySort(
        _____547D_4E2D_5217_8868,
        function(a, b)
            return a["投影"] - b["投影"]
        end
    )
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["R主炮"],
        X = _____65BD_6CD5_8005X,
        Y = _____65BD_6CD5_8005Y,
        Z = _____8299_8389_83B2_8868_73B0_914D_7F6E["特效参数"]["R主炮"]["高度"],
        ["面向角度"] = _____5FEB_7167["方向角"],
        ["动画索引"] = 0,
        ["缩放"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["特效参数"]["R主炮"]["缩放"],
        ["持续秒"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["特效参数"]["R主炮"]["持续秒"]
    })
    do
        local i = 0
        while i < #_____547D_4E2D_5217_8868 do
            local _____76EE_6807 = _____547D_4E2D_5217_8868[i + 1]["目标"]
            local _____500D_7387 = ____R_914D_7F6E["主炮倍率"] + _____5206_652F_52A0_6210 + (i == 0 and _____9690_533F_52A0_6210 or 0)
            local _____6807_7B7E = "芙莉莲-R贯穿射杀"
            if _____5FEB_7167["解析完成"] and _____5FEB_7167["解析目标"] == _____76EE_6807 then
                if _____5C1D_8BD5_6D88_8D39_89E3_6790_5B8C_6210(_____65BD_6CD5_8005, _____76EE_6807) then
                    _____500D_7387 = _____500D_7387 + ____R_914D_7F6E["完成破防追加倍率"]
                    _____6807_7B7E = "芙莉莲-R破防贯穿"
                    _____521B_5EFA_70B9_7279_6548({
                        ["模型路径"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["R命中反馈"],
                        X = GetUnitX(_____76EE_6807),
                        Y = GetUnitY(_____76EE_6807),
                        Z = _____8299_8389_83B2_8868_73B0_914D_7F6E["特效参数"]["R破防爆发"]["高度"],
                        ["面向角度"] = 0,
                        ["动画索引"] = 0,
                        ["缩放"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["特效参数"]["R破防爆发"]["缩放"],
                        ["持续秒"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["特效参数"]["R破防爆发"]["持续秒"]
                    })
                    _____9020_6210_6280_80FD_4F24_5BB3({
                        ["来源"] = _____65BD_6CD5_8005,
                        ["目标"] = _____76EE_6807,
                        ["伤害"] = _____653B_51FB_529B * ____R_914D_7F6E["完成爆发倍率"],
                        ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                        ["攻击类型"] = ATTACK_TYPE_NORMAL,
                        ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
                        ["来源类型"] = "单位技能",
                        ["技能ID"] = ____R_6280_80FDID,
                        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
                        ["标签"] = "芙莉莲-R完成爆发",
                        ["伤害形态"] = "单体",
                        ["参与技能伤害加成"] = true
                    })
                end
            end
            _____9020_6210_6280_80FD_4F24_5BB3({
                ["来源"] = _____65BD_6CD5_8005,
                ["目标"] = _____76EE_6807,
                ["伤害"] = _____653B_51FB_529B * _____500D_7387,
                ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                ["攻击类型"] = ATTACK_TYPE_NORMAL,
                ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
                ["来源类型"] = "单位技能",
                ["技能ID"] = ____R_6280_80FDID,
                ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
                ["标签"] = _____6807_7B7E,
                ["伤害形态"] = "AOE",
                ["参与技能伤害加成"] = true
            })
            _____521B_5EFA_70B9_7279_6548({
                ["模型路径"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["R命中反馈"],
                X = GetUnitX(_____76EE_6807),
                Y = GetUnitY(_____76EE_6807),
                Z = _____8299_8389_83B2_8868_73B0_914D_7F6E["特效参数"]["R命中反馈"]["高度"],
                ["面向角度"] = 0,
                ["动画索引"] = 0,
                ["缩放"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["特效参数"]["R命中反馈"]["缩放"],
                ["持续秒"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["特效参数"]["R命中反馈"]["持续秒"]
            })
            i = i + 1
        end
    end
    if _____5FEB_7167["花田内释放"] and _____82B1_7530_8054_52A8["尝试消费花田盛开"] ~= nil then
        _____82B1_7530_8054_52A8["尝试消费花田盛开"](_____65BD_6CD5_8005)
    end
end
local function _____91CA_653ER(_context, _____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID)
    if not _____662F_8299_8389_83B2(_____65BD_6CD5_8005) then
        return
    end
    if #_____67E5_8BE2_6218_6597_6280_80FD_5B9E_4F8B(_____65BD_6CD5_8005, "芙莉莲R") > 0 then
        return
    end
    local _____9690_533F = _____5FEB_7167_9690_533F(_____65BD_6CD5_8005)
    _____8BB0_5F55_8299_8389_83B2_6D3B_52A8(_____65BD_6CD5_8005)
    local _____84C4_529B_5B88_62A4 = _____5F00_59CB_5FAA_73AF_5B88_62A4(_____65BD_6CD5_8005, _____8299_8389_83B2_52A8_4F5C_69FD["R蓄力保持"], "芙莉莲R蓄力")
    local _____76EE_6807X = GetSpellTargetX()
    local _____76EE_6807Y = GetSpellTargetY()
    local _____89E3_6790_5FEB_7167 = _____82B1_7530_8054_52A8_53D6_89E3_6790_5FEB_7167(_____65BD_6CD5_8005)
    local ____temp_9
    if _____82B1_7530_8054_52A8["在花田内"] ~= nil then
        ____temp_9 = _____82B1_7530_8054_52A8["在花田内"](_____65BD_6CD5_8005)
    else
        ____temp_9 = false
    end
    local _____82B1_7530_5185_91CA_653E = ____temp_9
    local _____5FEB_7167 = {
        ["方向角"] = _____4E24_70B9_89D2_5EA6(
            GetUnitX(_____65BD_6CD5_8005),
            GetUnitY(_____65BD_6CD5_8005),
            _____76EE_6807X,
            _____76EE_6807Y
        ),
        ["隐匿"] = _____9690_533F,
        ["解析目标"] = _____89E3_6790_5FEB_7167["目标"],
        ["解析类型"] = _____89E3_6790_5FEB_7167["类型"],
        ["解析完成"] = _____89E3_6790_5FEB_7167["完成"],
        ["花田内释放"] = _____82B1_7530_5185_91CA_653E
    }
    local _____63A7_5236_5668 = _____521B_5EFA_6218_6597_6280_80FD_5B9E_4F8B({
        ["技能键"] = "芙莉莲R",
        ["施法者"] = _____65BD_6CD5_8005,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["数据"] = _____5FEB_7167,
        ["结束回调"] = function(______539F_56E0, _c)
        end
    })
    local _____9884_8B66_53E5_67C4 = nil
    local _____5145_80FDID
    _____5145_80FDID = _____5F00_59CB_5145_80FD(
        _____65BD_6CD5_8005,
        {
            ["持续时间"] = ____R_914D_7F6E["蓄力秒"],
            ["指令中断"] = true,
            ["世界坐标进度UI"] = true,
            ["世界坐标进度UI类型"] = _____8299_8389_83B2_8BFB_6761_914D_7F6E["UI类型"],
            ["世界坐标进度UI标题"] = "贯穿射杀",
            ["世界坐标进度UI数值后缀"] = "",
            ["世界坐标进度UI高度偏移"] = _____8299_8389_83B2_8BFB_6761_914D_7F6E["跟随Z偏移"],
            ["显示进度条特效"] = false,
            ["开始回调"] = function(______5355_4F4D, ______5145_80FDID)
                _____9884_8B66_53E5_67C4 = _____521B_5EFA_70B9_7279_6548({
                    ["模型路径"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["R蓄力收束"],
                    X = GetUnitX(_____65BD_6CD5_8005),
                    Y = GetUnitY(_____65BD_6CD5_8005),
                    Z = _____8299_8389_83B2_8868_73B0_914D_7F6E["特效参数"]["R蓄力预警"]["高度"],
                    ["面向角度"] = _____5FEB_7167["方向角"],
                    ["动画索引"] = 0,
                    ["缩放"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["特效参数"]["R蓄力预警"]["缩放"],
                    ["持续秒"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["特效参数"]["R蓄力预警"]["持续秒"]
                })
            end,
            ["充能完成回调"] = function(______5355_4F4D, ______5145_80FDID)
                if _____84C4_529B_5B88_62A4 ~= nil then
                    _____505C_6B62_5FAA_73AF_5B88_62A4(_____84C4_529B_5B88_62A4)
                    _____84C4_529B_5B88_62A4 = nil
                end
                _____64AD_653E_9650_65F6_52A8_4F5C(_____65BD_6CD5_8005, _____8299_8389_83B2_52A8_4F5C_69FD["R发射"], "芙莉莲R发射")
                ____R_7ED3_7B97_4E3B_70AE(_____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID, _____5FEB_7167)
                _____63A7_5236_5668["完成"](_____63A7_5236_5668)
            end,
            ["结束回调"] = function(______5355_4F4D, _____539F_56E0, ______5145_80FDID)
                if _____84C4_529B_5B88_62A4 ~= nil then
                    _____505C_6B62_5FAA_73AF_5B88_62A4(_____84C4_529B_5B88_62A4)
                    _____84C4_529B_5B88_62A4 = nil
                end
                if _____9884_8B66_53E5_67C4 ~= nil and _____9884_8B66_53E5_67C4 ~= 0 then
                    jass.DestroyEffect(_____9884_8B66_53E5_67C4)
                    _____9884_8B66_53E5_67C4 = nil
                end
                if _____539F_56E0 ~= "完成" then
                    _____63A7_5236_5668["中断"](_____63A7_5236_5668)
                end
                local ____ = _____5145_80FDID
            end
        }
    )
end
_____89E3_6790_5FEB_7167_6E90 = require("系统.03．技能系统.05．单位技能.04．英雄技能.25．芙莉莲.02．被动效果")
local _____5DF2_6CE8_518C = false
____exports["注册芙莉莲R"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "芙莉莲-解析魔法·贯穿射杀（R）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____8299_8389_83B2_6280_80FD_914D_7F6E.R["技能ID"],
        ["获取或创建上下文"] = function(unit)
            return {["英雄"] = unit}
        end,
        ["释放技能"] = _____91CA_653ER,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = ____R_914D_7F6E["蓄力秒"] + 3
    })
end
return ____exports
