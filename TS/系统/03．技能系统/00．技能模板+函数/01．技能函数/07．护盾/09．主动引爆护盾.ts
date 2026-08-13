/** @noSelfInFile */

import { 护盾参数 } from "./01．护盾类型";
import { 开始护盾, 查询单位标签护盾值, 移除单位标签护盾 } from "./07．护盾系统";

const jass = require("jass.common") as any;

const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const SetPlayerAbilityAvailable = jass.SetPlayerAbilityAvailable as (this: void, player: any, abilityId: number, available: boolean) => void;
const UnitAddAbility = jass.UnitAddAbility as (this: void, unit: any, abilityId: number) => boolean;
const UnitRemoveAbility = jass.UnitRemoveAbility as (this: void, unit: any, abilityId: number) => boolean;

export interface 主动引爆护盾控制器 {
  名称: string;
  施法者: any;
  护盾目标: any;
  主技能ID: number;
  引爆技能ID: number;
  护盾标签: string;
  护盾ID: number;
  已清理: boolean;
  主技能已禁用: boolean;
  on清理?: (this: void, 控制器: 主动引爆护盾控制器, 原因: string) => void;
  on引爆前?: (this: void, 控制器: 主动引爆护盾控制器, 剩余护盾值: number) => void;
  on引爆后?: (this: void, 控制器: 主动引爆护盾控制器, 剩余护盾值: number) => void;
}

export interface 主动引爆护盾参数 {
  名称: string;
  施法者: any;
  护盾目标: any;
  主技能ID: number;
  引爆技能ID: number;
  护盾标签: string;
  护盾参数: 护盾参数;
  on创建前?: (this: void, 控制器: 主动引爆护盾控制器) => void;
  on创建成功?: (this: void, 控制器: 主动引爆护盾控制器) => void;
  on清理?: (this: void, 控制器: 主动引爆护盾控制器, 原因: string) => void;
  on引爆前?: (this: void, 控制器: 主动引爆护盾控制器, 剩余护盾值: number) => void;
  on引爆后?: (this: void, 控制器: 主动引爆护盾控制器, 剩余护盾值: number) => void;
}

const 主动引爆护盾表: Record<number, 主动引爆护盾控制器 | undefined> = {};
const 待登记主动引爆护盾列表: 主动引爆护盾控制器[] = [];

function 单位存在(this: void, unit: any): boolean {
  return unit != null && unit !== 0;
}

function 设置主动引爆技能状态(this: void, 控制器: 主动引爆护盾控制器): void {
  const owner = GetOwningPlayer(控制器.施法者);
  if (owner != null && owner !== 0) {
    SetPlayerAbilityAvailable(owner, 控制器.主技能ID, false);
    控制器.主技能已禁用 = true;
  }
  UnitAddAbility(控制器.施法者, 控制器.引爆技能ID);
  if (owner != null && owner !== 0) SetPlayerAbilityAvailable(owner, 控制器.引爆技能ID, true);
}

function 恢复主动引爆技能状态(this: void, 控制器: 主动引爆护盾控制器): void {
  UnitRemoveAbility(控制器.施法者, 控制器.引爆技能ID);
  if (!控制器.主技能已禁用) return;
  const owner = GetOwningPlayer(控制器.施法者);
  if (owner != null && owner !== 0) SetPlayerAbilityAvailable(owner, 控制器.主技能ID, true);
  控制器.主技能已禁用 = false;
}

export function 清理主动引爆护盾(this: void, 控制器: 主动引爆护盾控制器 | undefined, 原因 = "外部清理"): void {
  if (控制器 == null || 控制器.已清理) return;
  控制器.已清理 = true;
  const 护盾ID = 控制器.护盾ID;
  控制器.护盾ID = 0;
  if (护盾ID !== 0 && 主动引爆护盾表[护盾ID] === 控制器) 主动引爆护盾表[护盾ID] = undefined;
  if (控制器.on清理 != null) 控制器.on清理(控制器, 原因);
  恢复主动引爆技能状态(控制器);
}

function 结束主动引爆护盾(this: void, 护盾ID: number, 原因: string): void {
  清理主动引爆护盾(主动引爆护盾表[护盾ID], 原因);
}

function 主动引爆护盾破碎(this: void, _unit: any, shieldId: number, _absorbed: number): void {
  结束主动引爆护盾(shieldId, "破碎");
}

function 主动引爆护盾开始(this: void, _unit: any, shieldId: number): void {
  const 控制器 = 待登记主动引爆护盾列表[待登记主动引爆护盾列表.length - 1];
  if (控制器 == null) return;
  控制器.护盾ID = shieldId;
  主动引爆护盾表[shieldId] = 控制器;
}

function 主动引爆护盾到期(this: void, _unit: any, shieldId: number): void {
  结束主动引爆护盾(shieldId, "到期");
}

function 主动引爆护盾结束(this: void, _unit: any, shieldId: number, reason: string): void {
  结束主动引爆护盾(shieldId, reason);
}

export function 创建主动引爆护盾(this: void, 参数: 主动引爆护盾参数): 主动引爆护盾控制器 | undefined {
  if (!单位存在(参数.施法者) || !单位存在(参数.护盾目标)) return undefined;
  if (参数.主技能ID === 0 || 参数.引爆技能ID === 0 || 参数.护盾标签 === "") return undefined;
  if (查询单位标签护盾值(参数.护盾目标, 参数.护盾标签) > 0) return undefined;

  const 控制器: 主动引爆护盾控制器 = {
    名称: 参数.名称,
    施法者: 参数.施法者,
    护盾目标: 参数.护盾目标,
    主技能ID: 参数.主技能ID,
    引爆技能ID: 参数.引爆技能ID,
    护盾标签: 参数.护盾标签,
    护盾ID: 0,
    已清理: false,
    主技能已禁用: false,
    on清理: 参数.on清理,
    on引爆前: 参数.on引爆前,
    on引爆后: 参数.on引爆后,
  };

  设置主动引爆技能状态(控制器);
  if (参数.on创建前 != null) 参数.on创建前(控制器);
  待登记主动引爆护盾列表.push(控制器);
  const 护盾ID = 开始护盾(参数.护盾目标, {
    ...参数.护盾参数,
    标签: 参数.护盾标签,
    开始回调: 主动引爆护盾开始,
    破碎回调: 主动引爆护盾破碎,
    到期回调: 主动引爆护盾到期,
    结束回调: 主动引爆护盾结束,
  });
  待登记主动引爆护盾列表.pop();
  if (护盾ID === 0) {
    清理主动引爆护盾(控制器, "创建失败");
    return undefined;
  }
  if (控制器.已清理) return undefined;
  if (控制器.护盾ID === 0) {
    控制器.护盾ID = 护盾ID;
    主动引爆护盾表[护盾ID] = 控制器;
  }
  if (参数.on创建成功 != null) 参数.on创建成功(控制器);
  return 控制器;
}

export function 主动引爆护盾仍有效(this: void, 控制器: 主动引爆护盾控制器 | undefined): boolean {
  return 控制器 != null
    && !控制器.已清理
    && 控制器.护盾ID !== 0
    && 查询单位标签护盾值(控制器.护盾目标, 控制器.护盾标签) > 0;
}

export function 引爆主动引爆护盾(this: void, 控制器: 主动引爆护盾控制器 | undefined): boolean {
  if (!主动引爆护盾仍有效(控制器)) {
    清理主动引爆护盾(控制器, "引爆时无有效护盾");
    return false;
  }
  const 当前控制器 = 控制器 as 主动引爆护盾控制器;
  const 剩余护盾值 = 查询单位标签护盾值(当前控制器.护盾目标, 当前控制器.护盾标签);
  if (当前控制器.on引爆前 != null) 当前控制器.on引爆前(当前控制器, 剩余护盾值);
  移除单位标签护盾(当前控制器.护盾目标, 当前控制器.护盾标签);
  if (当前控制器.on引爆后 != null) 当前控制器.on引爆后(当前控制器, 剩余护盾值);
  return true;
}
