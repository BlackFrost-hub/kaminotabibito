/** @noSelfInFile */
/**
 * 扇形区域测试
 *
 * 输入"1005"后，以 `gg_unit_Hamg_0002` 为中心，
 * 按单位当前朝向创建一个红色扇形提示特效，并统计扇形内敌方单位数量。
 */
const jass = require("jass.common");
const g = require("jass.globals");
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.index");
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心");
import { 创建红色扇形提示圈 } from "../02．通用函数/09．提示特效";
import { 获取扇形区域单位 } from "../01．技能函数/09．形状区域/index";
import { isUnitEnemy } from "../02．通用函数/02．单位与范围";
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const GetUnitFacing = jass.GetUnitFacing;
const UnitDamageTarget = jass.UnitDamageTarget;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS;
const 模块名 = "扇形区域测试";
const 测试命令 = "1005";
const 扇形角度 = 90;
const 扇形外半径 = 512;
const 扇形模型尺寸 = 1.0;
const 测试伤害 = 100;
function on聊天1005测试() {
    const 大法师 = g.gg_unit_Hamg_0002;
    if (大法师 == null || 大法师 === 0) {
        debugLogForce(模块名, "错误：未找到 gg_unit_Hamg_0002");
        return;
    }
    const x = GetUnitX(大法师);
    const y = GetUnitY(大法师);
    const 朝向 = GetUnitFacing(大法师);
    创建红色扇形提示圈(x, y, 朝向, 扇形模型尺寸, 2.0);
    const 命中单位 = 获取扇形区域单位({
        X: x,
        Y: y,
        半径: 扇形外半径,
        方向角: 朝向,
        扇形角度: 扇形角度,
        单位筛选: 扇形区域测试_敌方筛选,
    });
    for (const 单位 of 命中单位) {
        UnitDamageTarget(大法师, 单位, 测试伤害, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS);
    }
    debugLogForce(模块名, "已创建扇形测试：朝向=", 朝向, "扇形角=", 扇形角度, "外半径=", 扇形外半径, "敌方命中=", 命中单位.length, "每个目标伤害=", 测试伤害);
}
function 扇形区域测试_敌方筛选(单位) {
    const 大法师 = g.gg_unit_Hamg_0002;
    if (大法师 == null || 大法师 === 0) {
        return false;
    }
    return isUnitEnemy(单位, 大法师);
}
注册聊天命令监听(测试命令, on聊天1005测试);
debugLogForce(模块名, "已注册测试：输入", 测试命令, "创建扇形提示特效并统计敌方单位");
