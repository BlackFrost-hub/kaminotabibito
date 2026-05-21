/** @noSelfInFile */
const jass = require("jass.common");
const g = require("jass.globals");
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.index");
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心");
import { 开始充能 } from "../01．技能函数/06．施法·蓄力·充能/index";
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const GetOwningPlayer = jass.GetOwningPlayer;
const IsUnitEnemy = jass.IsUnitEnemy;
const CreateGroup = jass.CreateGroup;
const GroupEnumUnitsInRange = jass.GroupEnumUnitsInRange;
const FirstOfGroup = jass.FirstOfGroup;
const GroupRemoveUnit = jass.GroupRemoveUnit;
const DestroyGroup = jass.DestroyGroup;
const UnitDamageTarget = jass.UnitDamageTarget;
const 模块名 = "充能测试";
const 测试开关 = true;
const 充能测试命令 = "113";
const 充能伤害半径 = 500;
const 充能伤害 = 100;
function 对周围敌人造成伤害(中心单位) {
    const 中心X = GetUnitX(中心单位);
    const 中心Y = GetUnitY(中心单位);
    const 所属玩家 = GetOwningPlayer(中心单位);
    const 枚举组 = CreateGroup();
    GroupEnumUnitsInRange(枚举组, 中心X, 中心Y, 充能伤害半径, null);
    while (true) {
        const 目标 = FirstOfGroup(枚举组);
        if (目标 == null || 目标 === 0)
            break;
        GroupRemoveUnit(枚举组, 目标);
        if (IsUnitEnemy(目标, 所属玩家)) {
            UnitDamageTarget(中心单位, 目标, 充能伤害, false, false, jass.ATTACK_TYPE_NORMAL, jass.DAMAGE_TYPE_NORMAL, jass.WEAPON_TYPE_WHOKNOWS);
        }
    }
    DestroyGroup(枚举组);
}
function 充能完成回调(单位, _充能ID) {
    debugLogForce(模块名, "充能完成！对周围敌人造成", 充能伤害, "伤害");
    对周围敌人造成伤害(单位);
}
function 执行充能测试() {
    const 大法师 = g.gg_unit_Hamg_0002;
    if (大法师 == null || 大法师 === 0) {
        debugLogForce(模块名, "未找到 gg_unit_Hamg_0002");
        return;
    }
    debugLogForce(模块名, "找到大法师，开始充能...");
    const 充能ID = 开始充能(大法师, {
        持续时间: 3,
        过程特效: "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl",
        过程特效播放次数: 4,
        充能完成回调: 充能完成回调,
    });
    debugLogForce(模块名, "充能ID:", 充能ID);
}
function on聊天113测试() {
    执行充能测试();
}
if (测试开关) {
    注册聊天命令监听(充能测试命令, on聊天113测试);
    debugLogForce(模块名, "已注册测试：113=开始3秒充能，4次复活特效");
}
