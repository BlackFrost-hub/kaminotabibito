/** @noSelfInFile */

import type { 封印守卫战第三章技能环境 } from "../03．技能系统/05．单位技能/01．杂鱼技能/03．第三章/00．封印守卫战公共/00．类型";

const jass = require("jass.common") as any;
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, command: string, callback: (this: void, player: any, command: string) => void) => void;
};
const { 是允许测试玩家 } = require("系统.12．测试系统.00．测试系统辅助函数") as {
  是允许测试玩家: (this: void, player: any) => boolean;
};
const { 获取Boss测试玩家基准英雄, 设置Boss测试单位满血 } = require("系统.12．测试系统.00．Boss测试系统.index") as {
  获取Boss测试玩家基准英雄: (this: void, player: any) => any;
  设置Boss测试单位满血: (this: void, unit: any, maxLife?: number) => void;
};
const { directRegisterPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  directRegisterPlayerHero: (this: void, player: any, hero: any) => void;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};
const { 立即移除单位并取消排泄登记 } = require("系统.00．核心系统.01．事件中心.07A．单位排泄") as {
  立即移除单位并取消排泄登记: (this: void, unit: any) => void;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, text: string) => number;
};
const { IsUnitAliveBJ } = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  IsUnitAliveBJ: (this: void, unit: any) => boolean;
};
const { addDelayedCallback, removeDelayedCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};
const { 施加快速控制Buff } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  施加快速控制Buff: (this: void, source: any, target: any, controlId: number, duration: number, sourceName?: string, sourceType?: string) => void;
};
const {
  启动封印守卫战第三章敌人技能,
  停止封印守卫战第三章敌人技能,
  登记封印守卫战第三章敌人,
  令封印守卫战敌人技能立即就绪,
  读取封印守卫战第三章敌人运行记录,
} = require("系统.03．技能系统.05．单位技能.01．杂鱼技能.03．第三章.00．封印守卫战技能运行时") as {
  启动封印守卫战第三章敌人技能: (this: void, environment: 封印守卫战第三章技能环境) => boolean;
  停止封印守卫战第三章敌人技能: (this: void) => void;
  登记封印守卫战第三章敌人: (this: void, unit: any) => boolean;
  令封印守卫战敌人技能立即就绪: (this: void, unit: any) => boolean;
  读取封印守卫战第三章敌人运行记录: (this: void, unit: any) => any;
};
const {
  封印守卫战单人波次配置表,
  封印守卫战波次配置表,
} = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.00．主线剧情.49．封印守卫战") as {
  封印守卫战单人波次配置表: any[];
  封印守卫战波次配置表: any[];
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const Player = jass.Player as (this: void, playerId: number) => any;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitState = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (this: void, unit: any, state: any, value: number) => void;
const SetUnitPosition = jass.SetUnitPosition as (this: void, unit: any, x: number, y: number) => void;
const SetUnitFacing = jass.SetUnitFacing as (this: void, unit: any, facing: number) => void;
const ShowUnit = jass.ShowUnit as (this: void, unit: any, show: boolean) => void;
const PauseUnit = jass.PauseUnit as (this: void, unit: any, pause: boolean) => void;
const KillUnit = jass.KillUnit as (this: void, unit: any) => void;
const UnitDamageTarget = jass.UnitDamageTarget as (
  this: void,
  source: any,
  target: any,
  amount: number,
  attack: boolean,
  ranged: boolean,
  attackType: any,
  damageType: any,
  weaponType: any,
) => boolean;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const 测试中心X = -540.6;
const 测试中心Y = -2495.2;
const 中立敌对玩家ID = 12;
const 中立被动玩家ID = 15;
const 封印技能测试日志模块 = "封印守卫战敌人技能测试";

const 测试单位类型ID: Record<string, number> = {
  失控英灵: stringToFourCCSafe("n06B"),
  夺灵祭司: stringToFourCCSafe("n06A"),
  锚蚀兽: stringToFourCCSafe("n06C"),
  断誓猎手: stringToFourCCSafe("n06D"),
  黑暗残响: stringToFourCCSafe("n069"),
  裂誓重卫: stringToFourCCSafe("n06E"),
  失律号令者: stringToFourCCSafe("n06F"),
  潮蚀巡鳞者: stringToFourCCSafe("n056"),
  碎礁投石手: stringToFourCCSafe("h00Y"),
  灵潮祭司: stringToFourCCSafe("n054"),
  金鳞执刑官: stringToFourCCSafe("n052"),
  深渊鳞将: stringToFourCCSafe("n055"),
  能量核心: stringToFourCCSafe("n06G"),
  场外白板: stringToFourCCSafe("hfoo"),
};

interface 测试锚点状态 {
  编号: number;
  X: number;
  Y: number;
  已完成: boolean;
  已压制: boolean;
}

interface 封印技能延迟操作 {
  操作: "硬控" | "移出锚点" | "击杀" | "隐藏英雄目标" | "记录检查";
  单位?: any;
  标签: string;
}

const 测试锚点列表: 测试锚点状态[] = [
  { 编号: 1, X: 测试中心X + 420, Y: 测试中心Y, 已完成: false, 已压制: false },
  { 编号: 2, X: 测试中心X - 420, Y: 测试中心Y, 已完成: false, 已压制: false },
  { 编号: 3, X: 测试中心X, Y: 测试中心Y + 420, 已完成: false, 已压制: false },
];
const 测试单位缓存: Record<string, any> = {};
const 本轮激活单位键列表: string[] = [];
const 待取消延迟回调ID列表: number[] = [];
let 测试核心: any = null;
let 测试玩家英雄: any = null;
let 测试目标列表: any[] = [];
let 测试修复英雄列表: any[] = [];

function 测试单位存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitAliveBJ(unit) === true;
}

function 读取测试核心(this: void): any {
  return 测试核心;
}

function 读取测试锚点(this: void, 锚点编号: number): 测试锚点状态 | undefined {
  return 测试锚点列表[锚点编号 - 1];
}

function 设置测试锚点压制(this: void, 锚点编号: number, enabled: boolean): void {
  const anchor = 测试锚点列表[锚点编号 - 1];
  if (anchor == null) return;
  anchor.已压制 = enabled;
  debugLogForce(封印技能测试日志模块, "测试锚点压制状态变化", "anchorId=", 锚点编号, "suppressed=", enabled);
}

function 读取测试目标列表(this: void): any[] {
  return 测试目标列表;
}

function 读取测试修复英雄列表(this: void): any[] {
  return 测试修复英雄列表;
}

const 测试技能环境: 封印守卫战第三章技能环境 = {
  读取能量核心: 读取测试核心,
  读取锚点状态: 读取测试锚点,
  设置锚点压制: 设置测试锚点压制,
  读取玩家英雄列表: 读取测试目标列表,
  读取正在修复锚点的英雄列表: 读取测试修复英雄列表,
};

function 取消全部封印技能测试延迟回调(this: void): void {
  for (let i = 0; i < 待取消延迟回调ID列表.length; i++) removeDelayedCallback(待取消延迟回调ID列表[i]);
  待取消延迟回调ID列表.length = 0;
}

function 登记封印技能测试延迟回调(this: void, delayMs: number, data: 封印技能延迟操作): number {
  const id = addDelayedCallback(delayMs, on封印技能延迟操作, data);
  if (id > 0) 待取消延迟回调ID列表.push(id);
  return id;
}

function 停用全部缓存测试单位(this: void): void {
  本轮激活单位键列表.length = 0;
  for (const key in 测试单位缓存) {
    const unit = 测试单位缓存[key];
    if (!测试单位存活(unit)) continue;
    PauseUnit(unit, true);
    ShowUnit(unit, false);
  }
}

function 重置测试锚点(this: void): void {
  for (let i = 0; i < 测试锚点列表.length; i++) {
    测试锚点列表[i].已完成 = false;
    测试锚点列表[i].已压制 = false;
  }
}

function 获取或创建缓存测试单位(this: void, 类型: string, slot: number = 1): any {
  const key = 类型 + "#" + slot;
  let unit = 测试单位缓存[key];
  if (!测试单位存活(unit)) {
    unit = 创建单位并登记排泄安全(
      Player(中立敌对玩家ID),
      测试单位类型ID[类型],
      测试中心X,
      测试中心Y,
      0,
    );
    测试单位缓存[key] = unit;
  }
  return unit;
}

function 激活测试单位(
  this: void,
  类型: string,
  x: number,
  y: number,
  facing: number = 0,
  slot: number = 1,
  是否登记: boolean = true,
): any {
  const unit = 获取或创建缓存测试单位(类型, slot);
  if (!测试单位存活(unit)) return null;
  const key = 类型 + "#" + slot;
  本轮激活单位键列表.push(key);
  ShowUnit(unit, true);
  PauseUnit(unit, false);
  SetUnitPosition(unit, x, y);
  SetUnitFacing(unit, facing);
  设置Boss测试单位满血(unit, 100000);
  if (是否登记) {
    登记封印守卫战第三章敌人(unit);
    令封印守卫战敌人技能立即就绪(unit);
  }
  return unit;
}

function 确保测试核心(this: void): any {
  if (!测试单位存活(测试核心)) {
    测试核心 = 创建单位并登记排泄安全(
      Player(中立被动玩家ID),
      测试单位类型ID.能量核心,
      测试中心X,
      测试中心Y,
      0,
    );
  }
  if (测试单位存活(测试核心)) {
    ShowUnit(测试核心, true);
    PauseUnit(测试核心, false);
    SetUnitPosition(测试核心, 测试中心X, 测试中心Y);
    设置Boss测试单位满血(测试核心, 180000);
  }
  return 测试核心;
}

function 准备封印技能测试场(this: void, player: any): boolean {
  取消全部封印技能测试延迟回调();
  停止封印守卫战第三章敌人技能();
  停用全部缓存测试单位();
  重置测试锚点();
  测试玩家英雄 = 获取Boss测试玩家基准英雄(player);
  if (!测试单位存活(测试玩家英雄) || !测试单位存活(确保测试核心())) return false;
  directRegisterPlayerHero(player, 测试玩家英雄);
  SetUnitPosition(测试玩家英雄, 测试中心X - 500, 测试中心Y);
  SetUnitFacing(测试玩家英雄, 0);
  设置Boss测试单位满血(测试玩家英雄, 100000);
  测试目标列表 = [测试玩家英雄];
  测试修复英雄列表 = [];
  const started = 启动封印守卫战第三章敌人技能(测试技能环境);
  debugLogForce(
    封印技能测试日志模块,
    "测试场准备完成",
    "started=", started,
    "heroHid=", GetHandleId(测试玩家英雄),
    "coreHid=", GetHandleId(测试核心),
    "expected=", "缓存单位复用，职业运行时和延迟操作可统一清理",
  );
  return started;
}

function 清理封印技能测试场(this: void): void {
  取消全部封印技能测试延迟回调();
  停止封印守卫战第三章敌人技能();
  for (const key in 测试单位缓存) {
    const unit = 测试单位缓存[key];
    if (unit != null && unit !== 0) 立即移除单位并取消排泄登记(unit);
    delete 测试单位缓存[key];
  }
  if (测试核心 != null && 测试核心 !== 0) 立即移除单位并取消排泄登记(测试核心);
  测试核心 = null;
  测试目标列表 = [];
  测试修复英雄列表 = [];
  debugLogForce(封印技能测试日志模块, "测试场已清理", "expected=", "敌人、充能、弹幕、锚点压制和号令属性全部清理");
}

function 提交真实普攻(this: void, source: any, target: any, amount: number = 200): boolean {
  return UnitDamageTarget(source, target, amount, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS);
}

function on封印技能延迟操作(this: void, variable?: any): void {
  const data = variable as 封印技能延迟操作;
  if (data == null) return;
  const unit = data.单位;
  if (data.操作 === "硬控" && 测试单位存活(unit)) {
    施加快速控制Buff(测试玩家英雄, unit, 0, 1, "封印守卫战技能测试打断", "测试");
  } else if (data.操作 === "移出锚点" && 测试单位存活(unit)) {
    SetUnitPosition(unit, 测试中心X + 900, 测试中心Y + 900);
  } else if (data.操作 === "击杀" && 测试单位存活(unit)) {
    KillUnit(unit);
  } else if (data.操作 === "隐藏英雄目标") {
    测试目标列表 = [];
    测试修复英雄列表 = [];
  }
  const record = 读取封印守卫战第三章敌人运行记录(unit);
  debugLogForce(
    封印技能测试日志模块,
    "延迟分支执行",
    "label=", data.标签,
    "action=", data.操作,
    "unitHid=", unit != null && unit !== 0 ? GetHandleId(unit) : 0,
    "recordExists=", record != null,
    "chargeId=", record?.充能ID ?? 0,
    "anchorSuppressed=", record?.正在压制锚点 ?? false,
  );
}

function 测试失控英灵正常(this: void, player: any): void {
  if (!准备封印技能测试场(player)) return;
  const revenant = 激活测试单位("失控英灵", 测试中心X - 180, 测试中心Y, 0);
  SetUnitPosition(测试玩家英雄, 测试中心X + 80, 测试中心Y);
  const submitted = 提交真实普攻(revenant, 测试玩家英雄);
  debugLogForce(封印技能测试日志模块, "失控英灵正常测试", "submitted=", submitted, "expected=", "优先追击玩家英雄，真实普攻命中后施加20%移速降低2秒");
}

function 测试失控英灵回退核心(this: void, player: any): void {
  if (!准备封印技能测试场(player)) return;
  测试目标列表 = [];
  const revenant = 激活测试单位("失控英灵", 测试中心X - 600, 测试中心Y, 0);
  debugLogForce(封印技能测试日志模块, "失控英灵回退核心", "revenantHid=", GetHandleId(revenant), "expected=", "无玩家目标时攻击能量核心");
}

function 测试失控英灵减速冷却(this: void, player: any): void {
  if (!准备封印技能测试场(player)) return;
  const revenant = 激活测试单位("失控英灵", 测试中心X - 180, 测试中心Y, 0);
  const first = 提交真实普攻(revenant, 测试玩家英雄);
  const second = 提交真实普攻(revenant, 测试玩家英雄);
  debugLogForce(封印技能测试日志模块, "失控英灵减速冷却", "first=", first, "second=", second, "expected=", "5秒内第二次命中不重复触发缚魂斩");
}

function 测试夺灵祭司正常(this: void, player: any): void {
  if (!准备封印技能测试场(player)) return;
  const anchor = 测试锚点列表[0];
  const priest = 激活测试单位("夺灵祭司", anchor.X + 40, anchor.Y, 180);
  debugLogForce(封印技能测试日志模块, "夺灵祭司正常测试", "priestHid=", GetHandleId(priest), "expected=", "头顶2秒充能完成后锚点压制=true并关闭正式光束");
}

function 测试夺灵祭司硬控打断(this: void, player: any): void {
  if (!准备封印技能测试场(player)) return;
  const anchor = 测试锚点列表[0];
  const priest = 激活测试单位("夺灵祭司", anchor.X + 40, anchor.Y, 180);
  登记封印技能测试延迟回调(500, { 操作: "硬控", 单位: priest, 标签: "祭司引导硬控打断" });
  debugLogForce(封印技能测试日志模块, "夺灵祭司硬控打断已提交", "expected=", "进度条清理、锚点不压制、3秒后才可重试");
}

function 测试夺灵祭司越界打断(this: void, player: any): void {
  if (!准备封印技能测试场(player)) return;
  const anchor = 测试锚点列表[0];
  const priest = 激活测试单位("夺灵祭司", anchor.X + 40, anchor.Y, 180);
  登记封印技能测试延迟回调(500, { 操作: "移出锚点", 单位: priest, 标签: "祭司引导越界打断" });
  debugLogForce(封印技能测试日志模块, "夺灵祭司越界打断已提交", "expected=", "离开220码后引导中断且锚点不压制");
}

function 测试夺灵祭司死亡解压制(this: void, player: any): void {
  if (!准备封印技能测试场(player)) return;
  const anchor = 测试锚点列表[0];
  const priest = 激活测试单位("夺灵祭司", anchor.X + 40, anchor.Y, 180);
  登记封印技能测试延迟回调(2400, { 操作: "击杀", 单位: priest, 标签: "祭司完成压制后死亡" });
  debugLogForce(封印技能测试日志模块, "夺灵祭司死亡解压制已提交", "expected=", "先压制锚点，死亡后压制和法阵立即清除");
}

function 测试锚蚀兽正常(this: void, player: any): void {
  if (!准备封印技能测试场(player)) return;
  const beast = 激活测试单位("锚蚀兽", 测试中心X - 120, 测试中心Y, 0);
  debugLogForce(封印技能测试日志模块, "锚蚀兽正常测试", "beastHid=", GetHandleId(beast), "coreLifeBefore=", GetUnitState(测试核心, UNIT_STATE_LIFE), "expected=", "1.4秒充能后自爆，对核心造成2%最大生命+50%攻击力并死亡");
}

function 测试锚蚀兽硬控打断(this: void, player: any): void {
  if (!准备封印技能测试场(player)) return;
  const beast = 激活测试单位("锚蚀兽", 测试中心X - 120, 测试中心Y, 0);
  登记封印技能测试延迟回调(500, { 操作: "硬控", 单位: beast, 标签: "锚蚀兽自爆硬控打断" });
  debugLogForce(封印技能测试日志模块, "锚蚀兽硬控打断已提交", "expected=", "本次不爆炸，1秒后重新进入范围可重试");
}

function 测试锚蚀兽蓄力死亡(this: void, player: any): void {
  if (!准备封印技能测试场(player)) return;
  const beast = 激活测试单位("锚蚀兽", 测试中心X - 120, 测试中心Y, 0);
  登记封印技能测试延迟回调(500, { 操作: "击杀", 单位: beast, 标签: "锚蚀兽蓄力中死亡" });
  debugLogForce(封印技能测试日志模块, "锚蚀兽蓄力死亡已提交", "expected=", "死亡清理充能且核心不受自爆伤害");
}

function 测试锚蚀兽无视玩家(this: void, player: any): void {
  if (!准备封印技能测试场(player)) return;
  SetUnitPosition(测试玩家英雄, 测试中心X - 250, 测试中心Y);
  const beast = 激活测试单位("锚蚀兽", 测试中心X - 700, 测试中心Y, 0);
  debugLogForce(封印技能测试日志模块, "锚蚀兽无视玩家", "beastHid=", GetHandleId(beast), "expected=", "即使玩家挡路也持续以核心为目标");
}

function 连续提交猎手普攻(this: void, hunter: any, count: number): number {
  let submitted = 0;
  for (let i = 0; i < count; i++) {
    if (提交真实普攻(hunter, 测试核心, 100)) submitted += 1;
  }
  return submitted;
}

function 测试断誓猎手第四击(this: void, player: any): void {
  if (!准备封印技能测试场(player)) return;
  const hunter = 激活测试单位("断誓猎手", 测试中心X + 760, 测试中心Y, 180);
  const before = GetUnitState(测试核心, UNIT_STATE_LIFE);
  const submitted = 连续提交猎手普攻(hunter, 4);
  const after = GetUnitState(测试核心, UNIT_STATE_LIFE);
  debugLogForce(封印技能测试日志模块, "断誓猎手第四击", "submitted=", submitted, "lifeBefore=", before, "lifeAfter=", after, "expected=", "第四次伤害为130%，核心生命恢复降低50%持续3秒");
}

function 测试断誓猎手近身转火(this: void, player: any): void {
  if (!准备封印技能测试场(player)) return;
  const hunter = 激活测试单位("断誓猎手", 测试中心X + 760, 测试中心Y, 180);
  SetUnitPosition(测试玩家英雄, 测试中心X + 700, 测试中心Y);
  debugLogForce(封印技能测试日志模块, "断誓猎手近身转火", "hunterHid=", GetHandleId(hunter), "expected=", "240码内转火玩家，玩家离开后恢复核心射击站位");
}

function 测试断誓猎手刷新压制(this: void, player: any): void {
  if (!准备封印技能测试场(player)) return;
  const hunter = 激活测试单位("断誓猎手", 测试中心X + 760, 测试中心Y, 180);
  const submitted = 连续提交猎手普攻(hunter, 8);
  debugLogForce(封印技能测试日志模块, "断誓猎手压制刷新", "submitted=", submitted, "expected=", "两次第四击只刷新3秒持续时间，不叠加降低比例");
}

function 测试黑暗残响正常(this: void, player: any): void {
  if (!准备封印技能测试场(player)) return;
  const echo = 激活测试单位("黑暗残响", 测试中心X - 260, 测试中心Y, 0);
  测试修复英雄列表 = [测试玩家英雄];
  debugLogForce(封印技能测试日志模块, "黑暗残响正常测试", "echoHid=", GetHandleId(echo), "expected=", "优先修复英雄，0.6秒充能后发射追踪暗影弹并结算伤害与减速");
}

function 测试黑暗残响硬控打断(this: void, player: any): void {
  if (!准备封印技能测试场(player)) return;
  const echo = 激活测试单位("黑暗残响", 测试中心X - 260, 测试中心Y, 0);
  登记封印技能测试延迟回调(250, { 操作: "硬控", 单位: echo, 标签: "黑暗残响充能硬控打断" });
  debugLogForce(封印技能测试日志模块, "黑暗残响硬控打断已提交", "expected=", "不生成弹幕并进入完整8秒冷却");
}

function 测试黑暗残响目标失效(this: void, player: any): void {
  if (!准备封印技能测试场(player)) return;
  const dummy = 激活测试单位("场外白板", 测试中心X + 260, 测试中心Y, 180, 1, false);
  测试目标列表 = [dummy];
  const echo = 激活测试单位("黑暗残响", 测试中心X - 260, 测试中心Y, 0);
  登记封印技能测试延迟回调(250, { 操作: "击杀", 单位: dummy, 标签: "黑暗残响目标充能中失效" });
  debugLogForce(封印技能测试日志模块, "黑暗残响目标失效已提交", "echoHid=", GetHandleId(echo), "expected=", "目标死亡后中断充能、清理目标引用且不生成弹幕");
}

function 测试黑暗残响回退核心(this: void, player: any): void {
  if (!准备封印技能测试场(player)) return;
  测试目标列表 = [];
  测试修复英雄列表 = [];
  const echo = 激活测试单位("黑暗残响", 测试中心X - 600, 测试中心Y, 0);
  debugLogForce(封印技能测试日志模块, "黑暗残响回退核心", "echoHid=", GetHandleId(echo), "expected=", "无有效玩家英雄时不施放暗影索敌并攻击核心");
}

function 测试裂誓重卫正背面(this: void, player: any): void {
  if (!准备封印技能测试场(player)) return;
  const bulwark = 激活测试单位("裂誓重卫", 测试中心X, 测试中心Y, 0);
  SetUnitPosition(测试玩家英雄, 测试中心X + 220, 测试中心Y);
  const front = 提交真实普攻(测试玩家英雄, bulwark, 1000);
  SetUnitPosition(测试玩家英雄, 测试中心X - 220, 测试中心Y);
  const back = 提交真实普攻(测试玩家英雄, bulwark, 1000);
  debugLogForce(封印技能测试日志模块, "裂誓重卫正背面减伤", "frontSubmitted=", front, "backSubmitted=", back, "expected=", "正面120度减伤30%，背面不减伤");
}

function 测试裂誓重卫保护不叠加(this: void, player: any): void {
  if (!准备封印技能测试场(player)) return;
  const ally = 激活测试单位("失控英灵", 测试中心X, 测试中心Y, 0);
  const first = 激活测试单位("裂誓重卫", 测试中心X + 120, 测试中心Y, 180, 1);
  const second = 激活测试单位("裂誓重卫", 测试中心X - 120, 测试中心Y, 0, 2);
  const submitted = 提交真实普攻(测试玩家英雄, ally, 1000);
  debugLogForce(封印技能测试日志模块, "裂誓重卫保护不叠加", "submitted=", submitted, "firstHid=", GetHandleId(first), "secondHid=", GetHandleId(second), "expected=", "友军只获得一次12%减伤，重卫彼此不受保护");
}

function 测试裂誓重卫盾击(this: void, player: any): void {
  if (!准备封印技能测试场(player)) return;
  SetUnitPosition(测试玩家英雄, 测试中心X + 120, 测试中心Y);
  const bulwark = 激活测试单位("裂誓重卫", 测试中心X, 测试中心Y, 0);
  debugLogForce(封印技能测试日志模块, "裂誓重卫盾击", "bulwarkHid=", GetHandleId(bulwark), "expected=", "220码内触发80%攻击力AOE并击退180，不附加眩晕");
}

function 测试失律号令正常(this: void, player: any): void {
  if (!准备封印技能测试场(player)) return;
  const ally = 激活测试单位("失控英灵", 测试中心X + 180, 测试中心Y, 180);
  const herald = 激活测试单位("失律号令者", 测试中心X, 测试中心Y, 0);
  debugLogForce(封印技能测试日志模块, "失律号令正常测试", "heraldHid=", GetHandleId(herald), "allyHid=", GetHandleId(ally), "expected=", "0.8秒充能后550码登记敌人获得移速12%、攻速15%、减伤12%持续6秒");
}

function 测试失律号令硬控打断(this: void, player: any): void {
  if (!准备封印技能测试场(player)) return;
  激活测试单位("失控英灵", 测试中心X + 180, 测试中心Y, 180);
  const herald = 激活测试单位("失律号令者", 测试中心X, 测试中心Y, 0);
  登记封印技能测试延迟回调(300, { 操作: "硬控", 单位: herald, 标签: "失律号令充能硬控打断" });
  debugLogForce(封印技能测试日志模块, "失律号令硬控打断已提交", "expected=", "不施加强化并进入完整10秒冷却");
}

function 测试失律号令刷新不叠加(this: void, player: any): void {
  if (!准备封印技能测试场(player)) return;
  const ally = 激活测试单位("失控英灵", 测试中心X + 180, 测试中心Y, 180);
  const first = 激活测试单位("失律号令者", 测试中心X - 100, 测试中心Y, 0, 1);
  const second = 激活测试单位("失律号令者", 测试中心X + 100, 测试中心Y, 180, 2);
  debugLogForce(封印技能测试日志模块, "失律号令刷新不叠加", "allyHid=", GetHandleId(ally), "firstHid=", GetHandleId(first), "secondHid=", GetHandleId(second), "expected=", "两次号令只刷新持续时间，不重复增加属性和减伤");
}

function 测试失律号令仅登记敌人(this: void, player: any): void {
  if (!准备封印技能测试场(player)) return;
  const ally = 激活测试单位("失控英灵", 测试中心X + 180, 测试中心Y, 180);
  const outsider = 激活测试单位("场外白板", 测试中心X + 220, 测试中心Y, 180, 1, false);
  const herald = 激活测试单位("失律号令者", 测试中心X, 测试中心Y, 0);
  debugLogForce(封印技能测试日志模块, "失律号令登记范围", "heraldHid=", GetHandleId(herald), "allyHid=", GetHandleId(ally), "outsiderHid=", GetHandleId(outsider), "expected=", "只强化守卫战登记敌人，场外白板不受影响");
}

function 测试七类敌人综合AI(this: void, player: any): void {
  if (!准备封印技能测试场(player)) return;
  激活测试单位("失控英灵", 测试中心X - 700, 测试中心Y - 200, 0);
  激活测试单位("夺灵祭司", 测试锚点列表[0].X + 60, 测试锚点列表[0].Y, 180);
  激活测试单位("锚蚀兽", 测试中心X - 140, 测试中心Y, 0);
  激活测试单位("断誓猎手", 测试中心X + 760, 测试中心Y, 180);
  激活测试单位("黑暗残响", 测试中心X - 500, 测试中心Y + 200, 0);
  激活测试单位("裂誓重卫", 测试中心X + 300, 测试中心Y - 220, 180);
  激活测试单位("失律号令者", 测试中心X + 100, 测试中心Y - 220, 180);
  测试修复英雄列表 = [测试玩家英雄];
  debugLogForce(封印技能测试日志模块, "七类敌人综合AI", "activeCount=", 本轮激活单位键列表.length, "expected=", "各职业独立执行目标与技能，不再被旧1.8秒核心攻击命令覆盖");
}

function 测试潮蚀巡鳞者正常(this: void, player: any): void {
  if (!准备封印技能测试场(player)) return;
  const unit = 激活测试单位("潮蚀巡鳞者", 测试中心X - 900, 测试中心Y, 0);
  debugLogForce(封印技能测试日志模块, "潮蚀巡鳞者潮刃突袭", "unitHid=", GetHandleId(unit), "expected=", "250至650码内出现160x480矩形预警，充能完成后突进并造成120%攻击力伤害和25%减速");
}

function 测试潮蚀巡鳞者打断(this: void, player: any): void {
  if (!准备封印技能测试场(player)) return;
  const unit = 激活测试单位("潮蚀巡鳞者", 测试中心X - 900, 测试中心Y, 0);
  登记封印技能测试延迟回调(250, { 操作: "硬控", 单位: unit, 标签: "潮刃突袭充能硬控打断" });
  debugLogForce(封印技能测试日志模块, "潮蚀巡鳞者打断已提交", "unitHid=", GetHandleId(unit), "expected=", "打断后不突进、不结算命中伤害，进度条清理并进入冷却");
}

function 测试碎礁投石手正常(this: void, player: any): void {
  if (!准备封印技能测试场(player)) return;
  const unit = 激活测试单位("碎礁投石手", 测试中心X + 100, 测试中心Y, 180);
  debugLogForce(封印技能测试日志模块, "碎礁投石手碎礁投掷", "unitHid=", GetHandleId(unit), "targetX=", 测试中心X - 500, "targetY=", 测试中心Y, "expected=", "最远玩家位置出现220码圆形预警，抛物线投射物抵达锁定目标点后造成145%攻击力伤害和0.5秒硬直");
}

function 测试碎礁投石手近身禁止(this: void, player: any): void {
  if (!准备封印技能测试场(player)) return;
  SetUnitPosition(测试玩家英雄, 测试中心X, 测试中心Y);
  const unit = 激活测试单位("碎礁投石手", 测试中心X + 100, 测试中心Y, 180);
  debugLogForce(封印技能测试日志模块, "碎礁投石手近身禁止", "unitHid=", GetHandleId(unit), "distance=", 100, "expected=", "玩家进入250码内不释放碎礁投掷，继续处理近身目标");
}

function 测试碎礁投石手岩石删除(this: void, player: any): void {
  if (!准备封印技能测试场(player)) return;
  const unit = 激活测试单位("碎礁投石手", 测试中心X + 100, 测试中心Y, 180);
  debugLogForce(封印技能测试日志模块, "碎礁投石手岩石删除检查已提交", "unitHid=", GetHandleId(unit), "expected=", "投射物抵达目标点创建LTcr地形装饰物，1.5秒后自动删除，装饰物不阻挡寻路");
}

function 测试灵潮祭司祷印(this: void, player: any): void {
  if (!准备封印技能测试场(player)) return;
  const unit = 激活测试单位("灵潮祭司", 测试中心X + 100, 测试中心Y, 180);
  debugLogForce(封印技能测试日志模块, "灵潮祭司灵潮祷印", "unitHid=", GetHandleId(unit), "expected=", "玩家最密集位置出现260码圆形预警和吟唱条，完成后造成130%攻击力伤害并降低30%移速2.5秒");
}

function 测试灵潮祭司祷印打断(this: void, player: any): void {
  if (!准备封印技能测试场(player)) return;
  const unit = 激活测试单位("灵潮祭司", 测试中心X + 100, 测试中心Y, 180);
  登记封印技能测试延迟回调(300, { 操作: "硬控", 单位: unit, 标签: "灵潮祷印充能硬控打断" });
  debugLogForce(封印技能测试日志模块, "灵潮祭司祷印打断已提交", "unitHid=", GetHandleId(unit), "expected=", "打断后不爆发、不造成伤害，进度条和预警清理并进入冷却");
}

function 测试灵潮祭司护持(this: void, player: any): void {
  if (!准备封印技能测试场(player)) return;
  const ally = 激活测试单位("潮蚀巡鳞者", 测试中心X - 650, 测试中心Y, 0);
  const unit = 激活测试单位("灵潮祭司", 测试中心X - 500, 测试中心Y, 180);
  const record = 读取封印守卫战第三章敌人运行记录(unit);
  if (record != null) {
    if (record.附加状态 == null) record.附加状态 = {};
    record.附加状态.灵潮祷印冷却毫秒 = getServerTime() + 60000;
  }
  debugLogForce(封印技能测试日志模块, "灵潮祭司潮蚀护持", "unitHid=", GetHandleId(unit), "allyHid=", GetHandleId(ally), "expected=", "优先连接生命比例最低的精英或普通小怪，创建蓝色细束连线，目标获得25%减伤并每秒恢复0.8%最大生命");
}

function 测试灵潮祭司护持断线(this: void, player: any): void {
  if (!准备封印技能测试场(player)) return;
  const ally = 激活测试单位("潮蚀巡鳞者", 测试中心X - 650, 测试中心Y, 0);
  const unit = 激活测试单位("灵潮祭司", 测试中心X - 500, 测试中心Y, 180);
  const record = 读取封印守卫战第三章敌人运行记录(unit);
  if (record != null) {
    if (record.附加状态 == null) record.附加状态 = {};
    record.附加状态.灵潮祷印冷却毫秒 = getServerTime() + 60000;
  }
  登记封印技能测试延迟回调(800, { 操作: "移出锚点", 单位: unit, 标签: "潮蚀护持超过700码断线" });
  debugLogForce(封印技能测试日志模块, "灵潮祭司护持断线已提交", "unitHid=", GetHandleId(unit), "allyHid=", GetHandleId(ally), "expected=", "祭司离开目标700码后蓝色连线、减伤Buff和周期治疗清理");
}

function 测试金鳞执刑官冲阵(this: void, player: any): void {
  if (!准备封印技能测试场(player)) return;
  const unit = 激活测试单位("金鳞执刑官", 测试中心X + 100, 测试中心Y, 180);
  debugLogForce(封印技能测试日志模块, "金鳞执刑官金鳞冲阵", "unitHid=", GetHandleId(unit), "expected=", "出现220x600矩形预警和进度条，冲锋命中造成160%攻击力伤害并击退180码");
}

function 测试金鳞执刑官冲阵打断(this: void, player: any): void {
  if (!准备封印技能测试场(player)) return;
  const unit = 激活测试单位("金鳞执刑官", 测试中心X + 100, 测试中心Y, 180);
  登记封印技能测试延迟回调(250, { 操作: "硬控", 单位: unit, 标签: "金鳞冲阵充能硬控打断" });
  debugLogForce(封印技能测试日志模块, "金鳞执刑官冲阵打断已提交", "unitHid=", GetHandleId(unit), "expected=", "打断后不冲锋、不造成命中伤害，进度条清理并进入冷却");
}

function 测试金鳞执刑官重鳞护体(this: void, player: any): void {
  if (!准备封印技能测试场(player)) return;
  const unit = 激活测试单位("金鳞执刑官", 测试中心X + 100, 测试中心Y, 180);
  SetUnitState(unit, UNIT_STATE_LIFE, GetUnitState(unit, jass.UNIT_STATE_MAX_LIFE) * 0.4);
  debugLogForce(封印技能测试日志模块, "金鳞执刑官重鳞护体", "unitHid=", GetHandleId(unit), "life=", GetUnitState(unit, UNIT_STATE_LIFE), "expected=", "首次低于50%生命触发一次，获得30%减伤和25%移速降低6秒，结束播放护盾破裂特效");
}

function 测试深渊鳞将回潮(this: void, player: any): void {
  if (!准备封印技能测试场(player)) return;
  const unit = 激活测试单位("深渊鳞将", 测试中心X + 100, 测试中心Y, 180);
  debugLogForce(封印技能测试日志模块, "深渊鳞将深渊回潮", "unitHid=", GetHandleId(unit), "expected=", "正面100度、半径500码预警1秒，完成后左中右三道死亡波造成175%攻击力伤害并降低攻速移速30%3秒");
}

function 测试深渊鳞将潮汐牵引(this: void, player: any): void {
  if (!准备封印技能测试场(player)) return;
  const unit = 激活测试单位("深渊鳞将", 测试中心X + 100, 测试中心Y, 180);
  const record = 读取封印守卫战第三章敌人运行记录(unit);
  if (record != null) {
    if (record.附加状态 == null) record.附加状态 = {};
    record.附加状态.深渊回潮冷却毫秒 = getServerTime() + 60000;
  }
  debugLogForce(封印技能测试日志模块, "深渊鳞将潮汐牵引", "unitHid=", GetHandleId(unit), "expected=", "先出现550码圆形预警和0.8秒进度条，完成后造成70%攻击力伤害并将范围内玩家拉近最多240码");
}

function 测试深渊鳞将回潮封锁(this: void, player: any): void {
  if (!准备封印技能测试场(player)) return;
  const unit = 激活测试单位("深渊鳞将", 测试中心X + 100, 测试中心Y, 180);
  const record = 读取封印守卫战第三章敌人运行记录(unit);
  if (record != null) {
    if (record.附加状态 == null) record.附加状态 = {};
    record.附加状态.深渊回潮冷却毫秒 = getServerTime() + 60000;
  }
  登记封印技能测试延迟回调(1800, { 操作: "记录检查", 单位: unit, 标签: "潮汐牵引后检查回潮封锁" });
  debugLogForce(封印技能测试日志模块, "深渊鳞将回潮封锁检查已提交", "unitHid=", GetHandleId(unit), "expected=", "潮汐牵引结束后设置回潮封锁毫秒，封锁期间不会立即接深渊回潮");
}

function 测试五类敌人综合AI(this: void, player: any): void {
  if (!准备封印技能测试场(player)) return;
  激活测试单位("潮蚀巡鳞者", 测试中心X - 900, 测试中心Y, 0);
  激活测试单位("碎礁投石手", 测试中心X + 100, 测试中心Y, 180);
  激活测试单位("灵潮祭司", 测试中心X - 300, 测试中心Y + 260, 180);
  激活测试单位("金鳞执刑官", 测试中心X + 320, 测试中心Y - 220, 180);
  激活测试单位("深渊鳞将", 测试中心X + 420, 测试中心Y + 220, 180);
  debugLogForce(封印技能测试日志模块, "五类敌人综合AI", "activeCount=", 本轮激活单位键列表.length, "expected=", "五类新单位同时登记后各自执行预警、充能、技能结算和状态清理");
}

function 统计波次单位数量(this: void, waves: any[]): number {
  let total = 0;
  for (let i = 0; i < waves.length; i++) {
    const units = waves[i]?.单位列表 ?? [];
    for (let j = 0; j < units.length; j++) total += units[j]?.数量 ?? 0;
  }
  return total;
}

function 测试单人波次配置(this: void, _player: any): void {
  debugLogForce(封印技能测试日志模块, "单人波次配置", "waveCount=", 封印守卫战单人波次配置表.length, "totalUnits=", 统计波次单位数量(封印守卫战单人波次配置表), "expected=", "九波、每批最多一种精英，明显少于多人且避免祭司与锚蚀兽集中叠压");
}

function 测试多人波次配置(this: void, _player: any): void {
  debugLogForce(封印技能测试日志模块, "多人波次配置", "waveCount=", 封印守卫战波次配置表.length, "totalUnits=", 统计波次单位数量(封印守卫战波次配置表), "expected=", "2人及以上统一使用多人九波配置");
}

type 封印测试执行器 = (this: void, player: any) => void;
const 封印测试命令表: Record<string, 封印测试执行器 | undefined> = {
  "封印测试": 准备封印技能测试场,
  "封印清理": 清理封印技能测试场,
  "封印1": 测试失控英灵正常,
  "封印1-1": 测试失控英灵回退核心,
  "封印1-2": 测试失控英灵减速冷却,
  "封印2": 测试夺灵祭司正常,
  "封印2-1": 测试夺灵祭司硬控打断,
  "封印2-2": 测试夺灵祭司越界打断,
  "封印2-3": 测试夺灵祭司死亡解压制,
  "封印3": 测试锚蚀兽正常,
  "封印3-1": 测试锚蚀兽硬控打断,
  "封印3-2": 测试锚蚀兽蓄力死亡,
  "封印3-3": 测试锚蚀兽无视玩家,
  "封印4": 测试断誓猎手第四击,
  "封印4-1": 测试断誓猎手近身转火,
  "封印4-2": 测试断誓猎手刷新压制,
  "封印5": 测试黑暗残响正常,
  "封印5-1": 测试黑暗残响硬控打断,
  "封印5-2": 测试黑暗残响目标失效,
  "封印5-3": 测试黑暗残响回退核心,
  "封印6": 测试裂誓重卫正背面,
  "封印6-1": 测试裂誓重卫保护不叠加,
  "封印6-2": 测试裂誓重卫盾击,
  "封印7": 测试失律号令正常,
  "封印7-1": 测试失律号令硬控打断,
  "封印7-2": 测试失律号令刷新不叠加,
  "封印7-3": 测试失律号令仅登记敌人,
  "封印8": 测试七类敌人综合AI,
  "封印8-1": 测试单人波次配置,
  "封印8-2": 测试多人波次配置,
  "封印8-3": 清理封印技能测试场,
  "双灵卫1": 测试潮蚀巡鳞者正常,
  "双灵卫1-1": 测试潮蚀巡鳞者打断,
  "双灵卫2": 测试碎礁投石手正常,
  "双灵卫2-1": 测试碎礁投石手近身禁止,
  "双灵卫2-2": 测试碎礁投石手岩石删除,
  "双灵卫3": 测试灵潮祭司祷印,
  "双灵卫3-1": 测试灵潮祭司祷印打断,
  "双灵卫3-2": 测试灵潮祭司护持,
  "双灵卫3-3": 测试灵潮祭司护持断线,
  "双灵卫4": 测试金鳞执刑官冲阵,
  "双灵卫4-1": 测试金鳞执刑官冲阵打断,
  "双灵卫4-2": 测试金鳞执刑官重鳞护体,
  "双灵卫5": 测试深渊鳞将回潮,
  "双灵卫5-1": 测试深渊鳞将潮汐牵引,
  "双灵卫5-2": 测试深渊鳞将回潮封锁,
  "双灵卫6": 测试五类敌人综合AI,
};

const 封印测试命令列表 = [
  "封印测试", "封印清理",
  "封印1", "封印1-1", "封印1-2",
  "封印2", "封印2-1", "封印2-2", "封印2-3",
  "封印3", "封印3-1", "封印3-2", "封印3-3",
  "封印4", "封印4-1", "封印4-2",
  "封印5", "封印5-1", "封印5-2", "封印5-3",
  "封印6", "封印6-1", "封印6-2",
  "封印7", "封印7-1", "封印7-2", "封印7-3",
  "封印8", "封印8-1", "封印8-2", "封印8-3",
  "双灵卫1", "双灵卫1-1",
  "双灵卫2", "双灵卫2-1", "双灵卫2-2",
  "双灵卫3", "双灵卫3-1", "双灵卫3-2", "双灵卫3-3",
  "双灵卫4", "双灵卫4-1", "双灵卫4-2",
  "双灵卫5", "双灵卫5-1", "双灵卫5-2",
  "双灵卫6",
] as const;

function on封印守卫战敌人技能测试命令(this: void, player: any, command: string): void {
  if (!是允许测试玩家(player)) return;
  const execute = 封印测试命令表[command];
  if (execute != null) execute(player);
}

function 注册封印守卫战敌人技能测试命令(this: void): void {
  for (let i = 0; i < 封印测试命令列表.length; i++) {
    注册聊天命令监听(封印测试命令列表[i], on封印守卫战敌人技能测试命令);
  }
}

注册封印守卫战敌人技能测试命令();

export {};
