const jass = require("jass.common") as any;

// 玩家组类型
interface PlayerGroup {
  players: any[];
}

// 创建玩家组（玩家1-4）
function createPlayerGroup(): PlayerGroup {
  const players: any[] = [];
  for (let i = 0; i < 4; i++) {
    const p = jass.Player(i);
    if (jass.GetPlayerController(p) === jass.MAP_CONTROL_USER) {
      players.push(p);
    }
  }
  return { players };
}

// 销毁玩家组
function destroyPlayerGroup(pg: PlayerGroup): void {
  pg.players = [];
}

// 创建单位组
function createGroup(): any {
  return jass.CreateGroup();
}

// 销毁单位组
function destroyGroup(g: any): void {
  if (g) {
    jass.DestroyGroup(g);
  }
}

// 获取玩家组中所有玩家的第一个英雄
function getHeroesFromPlayerGroup(pg: PlayerGroup): any[] {
  const heroes: any[] = [];
  for (const p of pg.players) {
    const hero = getPlayerFirstHero(p);
    if (hero) {
      heroes.push(hero);
    }
  }
  return heroes;
}

/**
 * 给玩家1-4发放奖励
 * @param reward 奖励字符串，如 "all700exp;400gold" 或 "Player8000gold;5Int"
 * @param triggerPlayerId 完成任务的玩家ID（0-based），用于 "完成任务的玩家" 类型奖励
 *        必须传数字ID而非玩家对象，确保所有客户端都能通过 Player(id) 得到同一玩家
 */
export function giveRewardToPlayers(reward: string, triggerPlayerId?: number): void {
  if (!reward) return;

  const pg = createPlayerGroup();

  const parts = reward.split(';');
  for (const part of parts) {
    const trimmed = part.trim();
    if (trimmed.length === 0) continue;

    const hasExplicitTarget = trimmed.indexOf('所有玩家') !== -1 ||
                               trimmed.indexOf('完成任务的玩家') !== -1 ||
                               trimmed.indexOf('all') !== -1 ||
                               trimmed.indexOf('Player') !== -1;
    const isAll = trimmed.indexOf('所有玩家') !== -1 || trimmed.indexOf('all') !== -1 || !hasExplicitTarget;
    const isPlayer = trimmed.indexOf('完成任务的玩家') !== -1 || trimmed.indexOf('Player') !== -1;

    if (!isAll && !isPlayer) continue;

    // 确定目标玩家列表
    // 用 Player(id) 而非捕获的玩家对象，确保所有客户端都执行相同操作（不依赖本地触发玩家）
    const targetPlayers: any[] = isPlayer
      ? (triggerPlayerId !== undefined && triggerPlayerId >= 0 ? [jass.Player(triggerPlayerId)] : [])
      : pg.players;

    // 解析数值 - 从字符串中提取数字
    let value = 0;
    for (let i = 0; i < trimmed.length; i++) {
      const c = trimmed.charAt(i);
      if (c >= '0' && c <= '9') {
        value = value * 10 + (c.charCodeAt(0) - 48);
      } else if (value > 0) {
        break; // 数字结束后退出
      }
    }
    if (value === 0) continue;

    // 获取目标英雄列表
    const targetHeroes: any[] = [];
    for (const p of targetPlayers) {
      const h = getPlayerFirstHero(p);
      if (h) targetHeroes.push(h);
    }

    // 经验奖励
    if (trimmed.indexOf('经验') !== -1 || trimmed.indexOf('exp') !== -1) {
      for (const hero of targetHeroes) {
        if (typeof jass.AddHeroXP === 'function') {
          jass.AddHeroXP(hero, value, true);
        }
      }
    }
    // 金币奖励
    else if (trimmed.indexOf('金币') !== -1 || trimmed.indexOf('gold') !== -1) {
      for (const p of targetPlayers) {
        const currentGold = jass.GetPlayerState(p, jass.PLAYER_STATE_RESOURCE_GOLD) || 0;
        jass.SetPlayerState(p, jass.PLAYER_STATE_RESOURCE_GOLD, currentGold + value);
      }
    }
    // 木材奖励
    else if (trimmed.indexOf('木材') !== -1 || trimmed.indexOf('能量碎片') !== -1 || trimmed.indexOf('wood') !== -1 || trimmed.indexOf('lumber') !== -1) {
      for (const p of targetPlayers) {
        const currentWood = jass.GetPlayerState(p, jass.PLAYER_STATE_RESOURCE_LUMBER) || 0;
        jass.SetPlayerState(p, jass.PLAYER_STATE_RESOURCE_LUMBER, currentWood + value);
      }
    }
    // 智力奖励
    else if (trimmed.indexOf('智力') !== -1 || trimmed.indexOf('Int') !== -1) {
      for (const hero of targetHeroes) {
        if (typeof jass.SetHeroInt === 'function') {
          const currentInt = jass.GetHeroInt(hero, false);
          jass.SetHeroInt(hero, currentInt + value, true);
        }
      }
    }
    // 敏捷奖励
    else if (trimmed.indexOf('敏捷') !== -1 || trimmed.indexOf('Agi') !== -1) {
      for (const hero of targetHeroes) {
        if (typeof jass.SetHeroAgi === 'function') {
          const currentAgi = jass.GetHeroAgi(hero, false);
          jass.SetHeroAgi(hero, currentAgi + value, true);
        }
      }
    }
    // 力量奖励
    else if (trimmed.indexOf('力量') !== -1 || trimmed.indexOf('Str') !== -1) {
      for (const hero of targetHeroes) {
        if (typeof jass.SetHeroStr === 'function') {
          const currentStr = jass.GetHeroStr(hero, false);
          jass.SetHeroStr(hero, currentStr + value, true);
        }
      }
    }
    // 等级奖励
    else if (trimmed.indexOf('等级') !== -1 || trimmed.indexOf('level') !== -1) {
      for (const hero of targetHeroes) {
        if (typeof jass.SetHeroLevel === 'function') {
          const currentLevel = jass.GetHeroLevel(hero);
          jass.SetHeroLevel(hero, currentLevel + value, false);
        }
      }
    }
  }

  destroyPlayerGroup(pg);
}

//取得玩家的第一个英雄
export function getPlayerFirstHero(player: any): any {
  const g = jass.CreateGroup();
  jass.GroupEnumUnitsOfPlayer(g, player, null);
  let hero: any = null;
  let firstUnit: any = jass.FirstOfGroup(g);
  while (firstUnit) {
    if (jass.IsUnitType(firstUnit, jass.UNIT_TYPE_HERO)) {
      hero = firstUnit;
      break;
    }
    jass.GroupRemoveUnit(g, firstUnit);
    firstUnit = jass.FirstOfGroup(g);
  }
  jass.DestroyGroup(g);
  return hero;
}
