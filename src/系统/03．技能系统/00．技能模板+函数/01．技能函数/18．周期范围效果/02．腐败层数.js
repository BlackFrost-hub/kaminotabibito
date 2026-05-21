/** @noSelfInFile */
const jass = require("jass.common");
const GetOwningPlayer = jass.GetOwningPlayer;
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const { EC_CreateEffect } = require("lib.扩展函数.Star扩展函数.04．EC扩展库");
const { YDUserDataGetSafe, YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版");
const { 显示单位数值漂浮文字 } = require("lib.扩展函数.封装函数.03．漂浮文字.05．数值漂浮文字");
const 腐败特效模型 = "Abilities\\Spells\\NightElf\\CorrosiveBreath\\ChimaeraAcidTargetArt.mdl";
const 腐败值上限 = 100;
function 转数字(value) {
    if (value == null || value === false || value === "")
        return 0;
    const n = typeof value === "number" ? value : Number(value);
    return n !== n ? 0 : n;
}
function 限制腐败值上限(value) {
    if (value <= 0)
        return value;
    if (value >= 腐败值上限)
        return 腐败值上限;
    return value;
}
export function 应用腐败层数(参数) {
    const 目标单位 = 参数.目标单位 ?? 参数.TargetUnit;
    if (目标单位 == null || 目标单位 === 0)
        return;
    const 层数 = 转数字(参数.层数 ?? 参数.Stacks);
    if (层数 === 0)
        return;
    const 拥有者 = GetOwningPlayer(目标单位);
    if (参数.腐败值 !== false && 拥有者 != null && 拥有者 !== 0) {
        const 当前腐败值 = 转数字(YDUserDataGetSafe("player", 拥有者, "腐败值", "real"));
        YDUserDataSetSafe("player", 拥有者, "腐败值", "real", 限制腐败值上限(当前腐败值 + 层数));
    }
    EC_CreateEffect(腐败特效模型, GetUnitX(目标单位), GetUnitY(目标单位), 0, 270, 1.5, 1, 1);
    显示单位数值漂浮文字(目标单位, 层数, {
        后缀: "腐败",
        红: 100,
        绿: 20,
        蓝: 20,
        持续时间: 1,
    });
}
