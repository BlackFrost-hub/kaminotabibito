--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.01．物品使用配置表")
local _____7269_54C1_4F7F_7528_88C5_5907ID = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用装备ID"]
local _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用数值配置"]
local ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____662F_5426_4E3A_4F7F_7528_7269_54C1 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["是否为使用物品"]
local ____01_FF0E_524D_6447_9884_8B66_6267_884C_6A21_677F = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.04．主动技能流程模板.01．前摇预警执行模板")
local _____5F00_59CB_4E3B_52A8_6280_80FD_524D_6447_9884_8B66_6267_884C_6A21_677F = ____01_FF0E_524D_6447_9884_8B66_6267_884C_6A21_677F["开始主动技能前摇预警执行模板"]
local _____80F6_56CA_533A_57DF = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.09．形状区域.胶囊区域")
local _____83B7_53D6_80F6_56CA_533A_57DF_5355_4F4D = _____80F6_56CA_533A_57DF["获取胶囊区域单位"]
local ____07_FF0E_88C5_5907_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____53D6_88C5_5907_51B7_5374_952E = ____07_FF0E_88C5_5907_8F85_52A9["取装备冷却键"]
local _____88C5_5907_51B7_5374_4E2D = ____07_FF0E_88C5_5907_8F85_52A9["装备冷却中"]
local _____8FDB_5165_88C5_5907_51B7_5374_5E76_663E_793A = ____07_FF0E_88C5_5907_8F85_52A9["进入装备冷却并显示"]
local _____662F_654C_5BF9_5355_4F4D = ____07_FF0E_88C5_5907_8F85_52A9["是敌对单位"]
local _____53D6_653B_51FB_529B = ____07_FF0E_88C5_5907_8F85_52A9["取攻击力"]
local _____9020_6210_88C5_5907_4F24_5BB3 = ____07_FF0E_88C5_5907_8F85_52A9["造成装备伤害"]
local _____88C5_5907_4F24_5BB3_7C7B_578B = ____07_FF0E_88C5_5907_8F85_52A9["装备伤害类型"]
local _____7956_5730_79D8_5883_6218_5229_54C1_88C5_5907_540D = ____07_FF0E_88C5_5907_8F85_52A9["祖地秘境战利品装备名"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____65BD_52A0_5FEB_901F_51CF_901FBuff = ____require_result_0["施加快速减速Buff"]
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_1["创建点特效"]
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local Atan2 = jass.Atan2
local Cos = jass.Cos
local Sin = jass.Sin
local bj_RADTODEG = jass.bj_RADTODEG
local _____6F6E_6C50_6CE2_7279_6548 = "Common\\Effect\\Form\\Line\\DeathWave.mdx"
____exports["处理深渊潮汐法典使用"] = function(ctx)
    if not _____662F_5426_4E3A_4F7F_7528_7269_54C1(ctx["物品"], _____7269_54C1_4F7F_7528_88C5_5907ID["深渊潮汐法典"]) then
        return
    end
    local caster = ctx["施法单位"]
    local cfg = _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["深渊潮汐法典"]
    local _____51B7_5374_952E = _____53D6_88C5_5907_51B7_5374_952E(caster, _____7956_5730_79D8_5883_6218_5229_54C1_88C5_5907_540D["深渊潮汐法典"], "物品使用")
    if _____88C5_5907_51B7_5374_4E2D(_____51B7_5374_952E) then
        return
    end
    _____8FDB_5165_88C5_5907_51B7_5374_5E76_663E_793A(_____51B7_5374_952E, cfg["冷却秒"], caster, _____7956_5730_79D8_5883_6218_5229_54C1_88C5_5907_540D["深渊潮汐法典"])
    local x = ctx["目标X"]
    local y = ctx["目标Y"]
    local cx = GetUnitX(caster)
    local cy = GetUnitY(caster)
    local rad = Atan2(y - cy, x - cx)
    local deg = rad * bj_RADTODEG
    local _____8DDD_79BB = cfg["直线距离"]
    local _____7EC8_70B9X = cx + Cos(rad) * _____8DDD_79BB
    local _____7EC8_70B9Y = cy + Sin(rad) * _____8DDD_79BB
    _____5F00_59CB_4E3B_52A8_6280_80FD_524D_6447_9884_8B66_6267_884C_6A21_677F({
        ["施法者"] = caster,
        ["目标X"] = x,
        ["目标Y"] = y,
        ["前摇"] = {["持续时间"] = cfg["前摇秒"], ["强制硬直"] = false, ["允许自我打断"] = true, ["施法动作名"] = "spell"},
        ["提示圈"] = {
            ["类型"] = "矩形",
            X = cx,
            Y = cy,
            ["宽度"] = cfg["宽度"],
            ["长度"] = _____8DDD_79BB,
            ["朝向"] = deg,
            ["持续时间"] = cfg["前摇秒"],
            ["来源单位"] = caster
        },
        ["执行"] = function()
            do
                local i = 1
                while i <= 3 do
                    local t = i / 3 * _____8DDD_79BB
                    _____521B_5EFA_70B9_7279_6548({
                        ["模型路径"] = _____6F6E_6C50_6CE2_7279_6548,
                        X = cx + Cos(rad) * t,
                        Y = cy + Sin(rad) * t,
                        Z = 0,
                        ["Z轴角度"] = deg,
                        ["持续秒"] = 1.2,
                        ["缩放"] = 0.9
                    })
                    i = i + 1
                end
            end
            local units = _____83B7_53D6_80F6_56CA_533A_57DF_5355_4F4D({
                ["起点X"] = cx,
                ["起点Y"] = cy,
                ["终点X"] = _____7EC8_70B9X,
                ["终点Y"] = _____7EC8_70B9Y,
                ["宽度"] = cfg["宽度"],
                ["单位筛选"] = function(u) return _____662F_654C_5BF9_5355_4F4D(caster, u) end
            })
            local damage = _____53D6_653B_51FB_529B(caster) * cfg["攻击倍率"]
            do
                local i = 0
                while i < #units do
                    _____9020_6210_88C5_5907_4F24_5BB3(
                        caster,
                        units[i + 1],
                        damage,
                        _____88C5_5907_4F24_5BB3_7C7B_578B["魔法"],
                        false,
                        nil,
                        {
                            ["装备技能类型"] = "装备主动",
                            ["物品ID"] = jass.GetItemTypeId(ctx["物品"]),
                            ["物品实例"] = ctx["物品"],
                            ["技能ID"] = ctx["技能ID"],
                            ["标签"] = "潮汐冲击",
                            ["伤害形态"] = "AOE"
                        }
                    )
                    _____65BD_52A0_5FEB_901F_51CF_901FBuff(
                        caster,
                        units[i + 1],
                        0,
                        cfg["减速比例"],
                        cfg["减速秒"],
                        _____7956_5730_79D8_5883_6218_5229_54C1_88C5_5907_540D["深渊潮汐法典"],
                        "装备"
                    )
                    i = i + 1
                end
            end
        end
    })
end
return ____exports
