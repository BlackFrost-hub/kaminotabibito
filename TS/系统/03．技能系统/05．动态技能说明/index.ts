const preregistration = require("系统.03．技能系统.05．动态技能说明.03．英雄技能预注册") as {
  initHeroSkillPreregistration: (this: void) => void;
  onHeroRegisteredPreregistration: (this: void, whichPlayer: any, whichHero: any) => void;
};
const hoverHijack = require("系统.03．技能系统.05．动态技能说明.04．悬浮劫持") as {
  onPlayerHeroRegistered?: (this: void, whichPlayer: any, whichHero: any) => void;
};
const heroSkillRecord = require("系统.03．技能系统.05．动态技能说明.05．英雄技能记录") as {
  registerHeroSkillRecordHero: (this: void, whichHero: any) => void;
};
const skillButtonHover = require("系统.03．技能系统.05．动态技能说明.06．技能按钮悬浮") as {
  initSkillButtonHover: (this: void) => void;
  onPlayerHeroRegistered?: (this: void, whichPlayer: any, whichHero: any) => void;
};

let _initialized = false;

export * from "./01．核心功能";
export * from "./05．英雄技能记录";

export function init(): void {
  if (_initialized) return;
  _initialized = true;

  preregistration.initHeroSkillPreregistration();
  skillButtonHover.initSkillButtonHover();
}

export function onPlayerHeroRegistered(this: void, whichPlayer: any, whichHero: any): void {
  if (!whichPlayer || whichPlayer === 0 || !whichHero || whichHero === 0) return;

  heroSkillRecord.registerHeroSkillRecordHero(whichHero);
  preregistration.onHeroRegisteredPreregistration(whichPlayer, whichHero);

  if (typeof hoverHijack.onPlayerHeroRegistered === "function") {
    hoverHijack.onPlayerHeroRegistered(whichPlayer, whichHero);
  }
  if (typeof skillButtonHover.onPlayerHeroRegistered === "function") {
    skillButtonHover.onPlayerHeroRegistered(whichPlayer, whichHero);
  }
}
