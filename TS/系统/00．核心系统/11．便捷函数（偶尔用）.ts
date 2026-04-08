const jass = require("jass.common") as any;

interface PlayerGroup {
  players: any[];
}

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

function destroyPlayerGroup(pg: PlayerGroup): void {
  pg.players = [];
}

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

    const targetPlayers: any[] = isPlayer
      ? (triggerPlayerId !== undefined && triggerPlayerId >= 0 ? [jass.Player(triggerPlayerId)] : [])
      : pg.players;

    let value = 0;
    for (let i = 0; i < trimmed.length; i++) {
      const c = trimmed.charAt(i);
      if (c >= '0' && c <= '9') {
        value = value * 10 + (c.charCodeAt(0) - 48);
      } else if (value > 0) {
        break;
      }
    }
    if (value === 0) continue;

    const targetHeroes: any[] = [];
    for (const p of targetPlayers) {
      const h = getPlayerFirstHero(p);
      if (h) targetHeroes.push(h);
    }

    if (trimmed.indexOf('经验') !== -1 || trimmed.indexOf('exp') !== -1) {
      for (const hero of targetHeroes) {
        if (typeof jass.AddHeroXP === 'function') {
          jass.AddHeroXP(hero, value, true);
        }
      }
    }
    else if (trimmed.indexOf('金币') !== -1 || trimmed.indexOf('gold') !== -1) {
      for (const p of targetPlayers) {
        const currentGold = jass.GetPlayerState(p, jass.PLAYER_STATE_RESOURCE_GOLD) || 0;
        jass.SetPlayerState(p, jass.PLAYER_STATE_RESOURCE_GOLD, currentGold + value);
      }
    }
    else if (trimmed.indexOf('木材') !== -1 || trimmed.indexOf('能量碎片') !== -1 || trimmed.indexOf('wood') !== -1 || trimmed.indexOf('lumber') !== -1) {
      for (const p of targetPlayers) {
        const currentWood = jass.GetPlayerState(p, jass.PLAYER_STATE_RESOURCE_LUMBER) || 0;
        jass.SetPlayerState(p, jass.PLAYER_STATE_RESOURCE_LUMBER, currentWood + value);
      }
    }
    else if (trimmed.indexOf('智力') !== -1 || trimmed.indexOf('Int') !== -1) {
      for (const hero of targetHeroes) {
        if (typeof jass.SetHeroInt === 'function') {
          const currentInt = jass.GetHeroInt(hero, false);
          jass.SetHeroInt(hero, currentInt + value, true);
        }
      }
    }
    else if (trimmed.indexOf('敏捷') !== -1 || trimmed.indexOf('Agi') !== -1) {
      for (const hero of targetHeroes) {
        if (typeof jass.SetHeroAgi === 'function') {
          const currentAgi = jass.GetHeroAgi(hero, false);
          jass.SetHeroAgi(hero, currentAgi + value, true);
        }
      }
    }
    else if (trimmed.indexOf('力量') !== -1 || trimmed.indexOf('Str') !== -1) {
      for (const hero of targetHeroes) {
        if (typeof jass.SetHeroStr === 'function') {
          const currentStr = jass.GetHeroStr(hero, false);
          jass.SetHeroStr(hero, currentStr + value, true);
        }
      }
    }
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
