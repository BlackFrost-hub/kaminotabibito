/** @noSelfInFile */
/**
 * 伤害数字模型序列测试
 *
 * 输入 1036：开启每秒创建一次伤害数字模型并播放序列动画
 * 输入 1037：关闭测试
 */
const jass = require("jass.common");
const japi = require("jass.japi");
const g = require("jass.globals");
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心");
const { onSecond, offSecond } = require("系统.00．核心系统.05．中心计时器");
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出");
const AddSpecialEffect = jass.AddSpecialEffect;
const DestroyEffect = jass.DestroyEffect;
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const GetUnitFlyHeight = jass.GetUnitFlyHeight;
const R2I = jass.R2I;
const EXSetEffectZ = japi.EXSetEffectZ;
const DzSetEffectAnimation = japi.DzSetEffectAnimation;
const DzSetEffectScale = japi.DzSetEffectScale;
const DzSetEffectVisible = japi.DzSetEffectVisible;
const 模块名 = "伤害数字模型序列测试";
const 开启命令 = "1036";
const 关闭命令 = "1037";
const 模型路径 = "UI\\DamageNumbers\\DmgNum_8.mdx";
const 动画序号 = 2;
const 特效缩放 = 1.25;
const Z偏移 = 120;
const 保留秒数 = 2;
let 当前秒计数 = 0;
let 已开启 = false;
let 已订阅秒回调 = false;
const 待销毁队列 = [];
function 获取测试单位() {
    return g.gg_unit_Hamg_0002 ?? globalThis.bj_lastCreatedUnit;
}
function 记录待销毁特效(effect) {
    待销毁队列.push({
        effect,
        expireSecond: 当前秒计数 + 保留秒数,
    });
}
function 清理到期特效() {
    let writeIndex = 0;
    for (let i = 0; i < 待销毁队列.length; i++) {
        const item = 待销毁队列[i];
        if (item.expireSecond <= 当前秒计数) {
            DestroyEffect(item.effect);
            continue;
        }
        待销毁队列[writeIndex] = item;
        writeIndex++;
    }
    while (待销毁队列.length > writeIndex) {
        待销毁队列.pop();
    }
}
function 创建一次模型序列特效() {
    const unit = 获取测试单位();
    if (unit == null || unit === 0) {
        debugLogForce(模块名, "创建失败：未找到测试单位 gg_unit_Hamg_0002");
        return;
    }
    const x = GetUnitX(unit);
    const y = GetUnitY(unit);
    const z = GetUnitFlyHeight(unit) + Z偏移;
    const effect = AddSpecialEffect(模型路径, x, y);
    if (effect == null || effect === 0) {
        debugLogForce(模块名, "创建失败：模型句柄为空", "path=", 模型路径);
        return;
    }
    if (typeof EXSetEffectZ === "function") {
        EXSetEffectZ(effect, z);
    }
    if (typeof DzSetEffectVisible === "function") {
        DzSetEffectVisible(effect, true);
    }
    if (typeof DzSetEffectScale === "function") {
        DzSetEffectScale(effect, 特效缩放);
    }
    if (typeof DzSetEffectAnimation === "function") {
        DzSetEffectAnimation(effect, 动画序号, 0);
    }
    记录待销毁特效(effect);
    debugLogForce(模块名, "创建成功", "path=", 模型路径, "anim=", 动画序号, "x=", R2I(x), "y=", R2I(y), "z=", R2I(z));
}
function on每秒驱动() {
    当前秒计数++;
    清理到期特效();
    if (!已开启)
        return;
    创建一次模型序列特效();
}
function 开启测试() {
    if (已开启) {
        debugLogForce(模块名, "已经开启，无需重复开启");
        return;
    }
    已开启 = true;
    if (!已订阅秒回调) {
        已订阅秒回调 = true;
        onSecond(on每秒驱动);
    }
    debugLogForce(模块名, "已开启：每秒创建模型", "模型=", 模型路径, "动画序号=", 动画序号);
}
function 关闭测试() {
    if (!已开启) {
        debugLogForce(模块名, "当前未开启");
    }
    已开启 = false;
    if (已订阅秒回调) {
        已订阅秒回调 = false;
        offSecond(on每秒驱动);
    }
    for (let i = 0; i < 待销毁队列.length; i++) {
        DestroyEffect(待销毁队列[i].effect);
    }
    待销毁队列.length = 0;
    debugLogForce(模块名, "已关闭并清理特效");
}
function on聊天1036开启测试() {
    开启测试();
}
function on聊天1037关闭测试() {
    关闭测试();
}
注册聊天命令监听(开启命令, on聊天1036开启测试);
注册聊天命令监听(关闭命令, on聊天1037关闭测试);
debugLogForce(模块名, "已注册测试命令：", 开启命令, "开启；", 关闭命令, "关闭");
export {};
