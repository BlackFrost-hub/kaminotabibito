--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_524D_6447_9884_8B66_6267_884C_6A21_677F = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.04．主动技能流程模板.01．前摇预警执行模板")
local _____5F00_59CB_4E3B_52A8_6280_80FD_524D_6447_9884_8B66_6267_884C_6A21_677F = ____01_FF0E_524D_6447_9884_8B66_6267_884C_6A21_677F["开始主动技能前摇预警执行模板"]
local ____index = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.index")
local _____521B_5EFA_53CB_519B_8303_56F4_627F_4F24_8F6C_79FB = ____index["创建友军范围承伤转移"]
local _____521B_5EFA_53E5_67C4_4E0A_4E0B_6587_6258_7BA1_5668 = ____index["创建句柄上下文托管器"]
local ____07_FF0E_88C5_5907_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____5355_4F4D_5B58_6D3B = ____07_FF0E_88C5_5907_8F85_52A9["单位存活"]
local _____53D6_5F53_524D_751F_547D = ____07_FF0E_88C5_5907_8F85_52A9["取当前生命"]
local _____53D6_6700_5927_751F_547D = ____07_FF0E_88C5_5907_8F85_52A9["取最大生命"]
local _____662F_654C_5BF9_5355_4F4D = ____07_FF0E_88C5_5907_8F85_52A9["是敌对单位"]
local _____5F00_59CB_901A_7528_62A4_76FE = ____07_FF0E_88C5_5907_8F85_52A9["开始通用护盾"]
local _____9020_6210_88C5_5907_4F24_5BB3 = ____07_FF0E_88C5_5907_8F85_52A9["造成装备伤害"]
local _____64AD_653E_5355_4F4D_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["播放单位特效"]
local _____56DBBoss_88C5_5907_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["四Boss装备特效"]
local _____88C5_5907_4F24_5BB3_7C7B_578B = ____07_FF0E_88C5_5907_8F85_52A9["装备伤害类型"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_0.getServerTime
local _____8FDE_63A5 = _____521B_5EFA_53E5_67C4_4E0A_4E0B_6587_6258_7BA1_5668("黑翼守护重盾")
_____521B_5EFA_53CB_519B_8303_56F4_627F_4F24_8F6C_79FB({
    ["名称"] = "黑翼守护重盾-守护者之职责",
    ["转移比例"] = 0.35,
    ["转移半径"] = 900,
    ["过滤伤害"] = function(e) return e["上下文"].isTrueDamage ~= true and e["上下文"].isDotDamage ~= true and e["上下文"].isDamageTransfer ~= true and e["上下文"].isReflectedDamage ~= true and e["上下文"].isEquipmentSkillDamage ~= true end,
    ["获取候选单位列表"] = function(e)
        local s = _____8FDE_63A5["读取"](e["受击者"])
        if s == nil or getServerTime() >= s["到期"] or not _____5355_4F4D_5B58_6D3B(s["守护者"]) or _____53D6_5F53_524D_751F_547D(s["守护者"]) / _____53D6_6700_5927_751F_547D(s["守护者"]) <= 0.2 then
            _____8FDE_63A5["清空"](e["受击者"])
            return {}
        end
        return {s["守护者"]}
    end,
    ["on转移"] = function(e) return _____9020_6210_88C5_5907_4F24_5BB3(
        e["承受者"],
        e["承受者"],
        e["转移伤害"],
        _____88C5_5907_4F24_5BB3_7C7B_578B["物理"],
        false,
        nil,
        {["装备技能类型"] = "装备主动", ["标签"] = "守护者伤害转移", ["伤害形态"] = "单体"}
    ) end
})
____exports["处理黑翼守护重盾使用"] = function(ctx)
    local caster = ctx["施法单位"]
    local target = ctx["目标单位"]
    if not _____5355_4F4D_5B58_6D3B(target) or target == caster or _____662F_654C_5BF9_5355_4F4D(caster, target) then
        return
    end
    _____5F00_59CB_4E3B_52A8_6280_80FD_524D_6447_9884_8B66_6267_884C_6A21_677F({
        ["施法者"] = caster,
        ["目标"] = target,
        ["前摇"] = {
            ["持续时间"] = 1,
            ["强制硬直"] = true,
            ["允许自我打断"] = true,
            ["施法动作名"] = "spell",
            ["过程特效"] = _____56DBBoss_88C5_5907_7279_6548["黑翼拘束"],
            ["过程特效生命周期"] = 1
        },
        ["提示圈"] = false,
        ["执行"] = function()
            _____8FDE_63A5["写入"](
                target,
                {
                    ["守护者"] = caster,
                    ["到期"] = getServerTime() + 8000
                }
            )
            _____5F00_59CB_901A_7528_62A4_76FE(
                caster,
                caster,
                _____53D6_6700_5927_751F_547D(caster) * 0.12,
                8,
                "守护者之职责"
            )
            _____5F00_59CB_901A_7528_62A4_76FE(
                caster,
                target,
                _____53D6_6700_5927_751F_547D(target) * 0.1,
                8,
                "守护者之职责"
            )
            _____64AD_653E_5355_4F4D_7279_6548(
                _____56DBBoss_88C5_5907_7279_6548["黑翼屏障"],
                caster,
                "origin",
                8,
                0.32
            )
            _____64AD_653E_5355_4F4D_7279_6548(
                _____56DBBoss_88C5_5907_7279_6548["黑翼拘束"],
                target,
                "origin",
                8,
                0.25
            )
        end
    })
end
return ____exports
