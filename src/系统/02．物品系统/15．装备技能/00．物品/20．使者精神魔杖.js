/** @noSelfInFile */
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出");
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器");
const jass = require("jass.common");
const { YDUserDataGet, YDUserDataSet, YDUserDataHas, YDUserDataClear } = require("lib.扩展函数.YDWE函数.index");
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版");
const GetItemTypeId = jass.GetItemTypeId;
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const GetUnitTypeId = jass.GetUnitTypeId;
const GetUnitFacing = jass.GetUnitFacing;
const GetOwningPlayer = jass.GetOwningPlayer;
const IsUnitRace = jass.IsUnitRace;
const IsHeroUnitId = jass.IsHeroUnitId;
const KillUnit = jass.KillUnit;
const CreateUnit = jass.CreateUnit;
const UnitApplyTimedLife = jass.UnitApplyTimedLife;
const RACE_DEMON = jass.RACE_DEMON;
import { 使者精神魔杖物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 使者精神魔杖配置 } from "../03．主动技能/03．物品使用触发/00．物品使用触发配置";
const 限时生命BuffID = stringToFourCCSafe("BHwe");
function 是否为使者精神魔杖(物品) {
    if (物品 == null || 物品 === 0)
        return false;
    return GetItemTypeId(物品) === 使者精神魔杖物品ID;
}
function 目标可存储(目标单位) {
    if (目标单位 == null || 目标单位 === 0)
        return false;
    if (IsUnitRace(目标单位, RACE_DEMON))
        return false;
    return !IsHeroUnitId(GetUnitTypeId(目标单位));
}
function 启动存储过期计时(施法单位) {
    addDelayedCallback(使者精神魔杖配置.存储持续时间 * 1000, function () {
        if (施法单位 != null && 施法单位 !== 0) {
            YDUserDataClear("unit", 施法单位, 使者精神魔杖配置.存储字段, "unitcode");
        }
    });
}
export function 处理使者精神魔杖使用(上下文) {
    debugLogForce("21．使者精神魔杖", "进入", "处理使者精神魔杖使用");
    if (!是否为使者精神魔杖(上下文.物品))
        return;
    const 施法单位 = 上下文.施法单位;
    if (施法单位 == null || 施法单位 === 0)
        return;
    const 已存储 = YDUserDataHas("unit", 施法单位, 使者精神魔杖配置.存储字段, "unitcode");
    const 目标单位 = 上下文.目标单位;
    if (!已存储) {
        if (!目标可存储(目标单位))
            return;
        KillUnit(目标单位);
        YDUserDataSet("unit", 施法单位, 使者精神魔杖配置.存储字段, "unitcode", GetUnitTypeId(目标单位));
        启动存储过期计时(施法单位);
        return;
    }
    const 存储单位类型 = YDUserDataGet("unit", 施法单位, 使者精神魔杖配置.存储字段, "unitcode");
    const x = 目标单位 == null || 目标单位 === 0 ? 上下文.目标X : GetUnitX(目标单位);
    const y = 目标单位 == null || 目标单位 === 0 ? 上下文.目标Y : GetUnitY(目标单位);
    const 召唤单位 = CreateUnit(GetOwningPlayer(施法单位), 存储单位类型, x, y, GetUnitFacing(施法单位));
    if (召唤单位 != null && 召唤单位 !== 0) {
        UnitApplyTimedLife(召唤单位, 限时生命BuffID, 使者精神魔杖配置.召唤持续时间);
    }
}
