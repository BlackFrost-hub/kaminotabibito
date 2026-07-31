--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
____exports["夏提雅单位技能配置"] = {
    BossKey = "ShalltearBloodfallen",
    ["单位名称"] = "夏提雅·布拉德弗伦",
    ["正式单位ID"] = "U009",
    ["模型路径"] = "Boss\\ShalltearBloodfallen\\Shalltear.mdx",
    ["女武神形态"] = {["单位ID"] = "U00A", ["模型路径"] = "Boss\\ShalltearBloodfallen\\ShalltearValkyrie.mdx"},
    ["阶段阈值"] = {["P2生命比例"] = 0.7, ["P3生命比例"] = 0.35},
    ["广播持续时间Ms"] = 5200,
    ["配音裁断距离"] = 4000,
    ["开场台词时间"] = {["战斗开始延迟Ms"] = 10500, ["英灵战乙女延迟Ms"] = 7200},
    ["台词"] = {
        ["登场"] = {"夏提雅·布拉德弗伦已进入战斗，生命值降至70%与35%会改变阶段。（留意血印、英灵投影与复生仪式。）"},
        ["战斗开始"] = {"战斗开始：夏提雅的普通攻击连续命中同一目标会叠加「猎血连击」；P1/P2连续命中2次、P3连续命中1次后，下一次会改为汲血强化穿刺。（改打其他目标会从新目标的第1层重新计数，也可在蓄力时拉开距离或施加硬控制。）"},
        ["滴管穿心"] = {"滴管穿心：0.8秒后沿锁定直线突进，P2的英灵会在1.0～1.3秒后复刻一次。（离开红色直线路径；P2还要避开英灵的第二条路径。）"},
        ["汲血穿刺"] = {"汲血强化穿刺：蓄力0.55～0.70秒后造成强化伤害；命中后夏提雅恢复3%最大生命，P1/P2还会在目标位置生成鲜血印记，P3不再生成。（蓄力期间拉开距离或施加硬控制可打断。）"},
        ["血月轮舞"] = {"血月轮舞：0.8秒后结算正面110°扇形，约0.525～0.70秒后沿反向直线反刺。（先离开正面扇形，再避开Boss转身后的直线。）"},
        ["净化投枪"] = {"净化投枪：1.2秒后在点名位置落下投枪，P3再于0.65秒后落下第二枚。（离开圆形预警；可把落点引到鲜血印记上完成净化。）"},
        ["鲜血回收"] = {"鲜血回收：1.5秒后吸收场上全部鲜血印记，每枚恢复夏提雅最大生命2%～3%，并获得1层持续8秒的血之狂热，最多获得3层；每层加8%攻击速度和5%技能冷却恢复速度。（在连线收束前站入血印1.2秒可净化，或用净化投枪覆盖落点。）"},
        ["进入P2"] = {"P2英灵战乙女：夏提雅生命值降至70%，召唤英灵投影并切换女武神形态。（英灵不普攻，但会在1.0～1.3秒后复刻指定技能，注意第二条路径。）"},
        ["英灵战乙女"] = {"英灵战乙女：英灵投影已就位，夏提雅的滴管穿心或净化投枪会在1.0～1.3秒后被复刻。（同时观察本体预警与英灵位置。）"},
        ["镜像夹击"] = {"镜像夹击：0.9秒后本体沿第一条直线冲锋，1.1秒后英灵沿反向第二条直线冲锋；命中会减速1.2秒、25%。（横向离开两条预警直线，别停在交叉点。）"},
        ["进入P3"] = {"P3真祖血宴：夏提雅生命值降至35%，进入真祖阶段并停止生成新的鲜血印记。（转化前尽量净化场上血印，减少她的强化层数。）"},
        ["血月终舞"] = {"血月终舞：四个扇区依次预警，每个约0.7～0.8秒后结算并发射4枚弹幕，最后沿锁定直线俯冲。（沿安全扇区移动，最后离开直线冲锋路径。）"},
        ["血之复生"] = {"血之复生：夏提雅进入12秒仪式并生成3枚复生结晶；每枚存活结晶使她恢复10%最大生命。（12秒内摧毁全部3枚即可阻止复生。）"},
        ["复生成功"] = {"复生成功：存活结晶已转化为生命，每枚使夏提雅恢复10%最大生命；本次复生不会再次触发。（继续输出并准备P3技能。）"},
        ["复生失败"] = {"复生失败：12秒仪式结束前已摧毁全部3枚复生结晶，夏提雅无法复生。（保持输出，准备结束战斗。）"},
        ["再次战败"] = {"夏提雅再次战败，挑战将在1.5秒离场演出后结束。（离场演出结束后领取挑战奖励。）"},
        ["真祖血宴"] = {"真祖血宴：每枚未净化鲜血印记转化1层，最多3层；每层加8%攻击速度、加5%技能循环速度，满层为加24%攻击速度和15%技能循环速度。（场上血印越少，P3越容易处理。）"}
    },
    ["配音资源"] = {
        ["登场"] = {"Sound\\Boss\\ShalltearBloodfallen\\Voice\\01_intro_trial.mp3"},
        ["战斗开始"] = {"Sound\\Boss\\ShalltearBloodfallen\\Voice\\02_battle_start.mp3"},
        ["滴管穿心"] = {"Sound\\Boss\\ShalltearBloodfallen\\Voice\\03_pipette_lance.mp3"},
        ["汲血穿刺"] = {"Sound\\Boss\\ShalltearBloodfallen\\Voice\\04_blood_drain.mp3"},
        ["血月轮舞"] = {"Sound\\Boss\\ShalltearBloodfallen\\Voice\\05_blood_moon_waltz.mp3"},
        ["净化投枪"] = {"Sound\\Boss\\ShalltearBloodfallen\\Voice\\06_purifying_javelin.mp3"},
        ["鲜血回收"] = {"Sound\\Boss\\ShalltearBloodfallen\\Voice\\07_blood_recall.mp3"},
        ["进入P2"] = {"Sound\\Boss\\ShalltearBloodfallen\\Voice\\08_phase_two_valkyrie.mp3"},
        ["英灵战乙女"] = {"Sound\\Boss\\ShalltearBloodfallen\\Voice\\09_einherjar_summon.mp3"},
        ["镜像夹击"] = {"Sound\\Boss\\ShalltearBloodfallen\\Voice\\10_mirror_pincer.mp3"},
        ["进入P3"] = {"Sound\\Boss\\ShalltearBloodfallen\\Voice\\11_true_ancestor_feast.mp3"},
        ["血月终舞"] = {"Sound\\Boss\\ShalltearBloodfallen\\Voice\\12_blood_moon_finale.mp3"},
        ["血之复生"] = {"Sound\\Boss\\ShalltearBloodfallen\\Voice\\13_blood_resurrection.mp3"},
        ["复生成功"] = {"Sound\\Boss\\ShalltearBloodfallen\\Voice\\14_resurrection_success.mp3"},
        ["复生失败"] = {"Sound\\Boss\\ShalltearBloodfallen\\Voice\\15_resurrection_failure.mp3"},
        ["再次战败"] = {"Sound\\Boss\\ShalltearBloodfallen\\Voice\\16_final_defeat.mp3"}
    },
    ["当前状态"] = {
        ["目录结构已建立"] = true,
        ["单位数据已确认"] = true,
        ["普攻核心已实现"] = true,
        ["技能已实现"] = true,
        ["战斗已注册"] = true
    }
}
return ____exports
