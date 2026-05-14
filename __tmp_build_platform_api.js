const fs = require("fs");
const path = require("path");

const root = "C:/Users/Administrator/Desktop/syzl";
const tsDir = path.join(root, "TS");
const tsFile = path.join(tsDir, "平台扩展API.ts");
const tsActionFile = path.join(tsDir, "平台扩展API.动作.ts");
const tsValueFile = path.join(tsDir, "平台扩展API.取值.ts");
const tsConditionFile = path.join(tsDir, "平台扩展API.条件.ts");
const tsEventFile = path.join(tsDir, "平台扩展API.事件.ts");

const jassFiles = [
  path.join(root, "JASS", "世界地图", "DzAPI.j"),
  path.join(root, "JASS", "世界地图", "KKPRE.j"),
  path.join(root, "JASS", "世界地图", "KKAPI.j"),
];

const 官方翻译标题文件 = [
  "F:/1.9.3k6_雪月编辑器 (2)/share/mpq/dzapi2/call.txt",
  "F:/1.9.3k6_雪月编辑器 (2)/share/mpq/dzapi2/action.txt",
  "F:/1.9.3k6_雪月编辑器 (2)/share/mpq/kkapi/call.txt",
  "F:/1.9.3k6_雪月编辑器 (2)/share/mpq/kkapi/action.txt",
];

const 官方触发字符串文件 = [
  "F:/1.9.3k6_雪月编辑器 (2)/share/mpq/dzapi/ui/TriggerStrings.txt",
  "F:/1.9.3k6_雪月编辑器 (2)/share/mpq/dzapi/ui/TriggerData.txt",
];

const prefixAllow = /^(Dz|KK|RequestExtra|EX)/;

function read(p) {
  return fs.readFileSync(p, "utf8");
}

function setIfMissing(map, key, value) {
  if (!key || !value || map.has(key)) return;
  map.set(key, value);
}

function parseTitleDescriptorFile(filePath) {
  const text = read(filePath);
  const result = new Map();
  let 当前键 = "";
  let 当前标题 = "";
  let 脚本别名 = "";

  function 提交当前项() {
    if (!当前键 || !当前标题) return;
    setIfMissing(result, 当前键, 当前标题);
    setIfMissing(result, 脚本别名, 当前标题);
  }

  for (const rawLine of text.split(/\r?\n/)) {
    const line = rawLine.trim();
    const sectionMatch = /^\[([^\]]+)\]$/.exec(line);
    if (sectionMatch) {
      if (!sectionMatch[1].startsWith(".")) {
        提交当前项();
        当前键 = sectionMatch[1];
        当前标题 = "";
        脚本别名 = "";
      }
      continue;
    }
    const titleMatch = /^title\s*=\s*"([^"]*)"/.exec(line);
    if (titleMatch) {
      当前标题 = titleMatch[1].trim();
      continue;
    }
    const scriptMatch = /^scriptname\s*=\s*([A-Za-z0-9_]+)/.exec(line);
    if (scriptMatch) {
      脚本别名 = scriptMatch[1].trim();
    }
  }

  提交当前项();
  return result;
}

function parseTriggerStringsFile(filePath) {
  const text = read(filePath);
  const result = new Map();
  for (const rawLine of text.split(/\r?\n/)) {
    const line = rawLine.trim();
    if (!line || line.startsWith("[") || line.startsWith("_")) continue;
    const eqIndex = line.indexOf("=");
    if (eqIndex < 0) continue;
    const key = line.slice(0, eqIndex).trim();
    const value = line.slice(eqIndex + 1).trim();
    if (!/^[A-Za-z0-9_]+$/.test(key)) continue;
    if (key.endsWith("Hint")) continue;
    if (!value || value.startsWith("\"") || value.startsWith("~")) continue;
    setIfMissing(result, key, value);
  }
  return result;
}

function loadOfficialChineseTitles() {
  const result = new Map();
  for (const filePath of 官方翻译标题文件) {
    const parsed = parseTitleDescriptorFile(filePath);
    for (const [key, value] of parsed) {
      setIfMissing(result, key, value);
    }
  }
  for (const filePath of 官方触发字符串文件) {
    const parsed = parseTriggerStringsFile(filePath);
    for (const [key, value] of parsed) {
      setIfMissing(result, key, value);
    }
  }
  return result;
}

function loadCategoryByRawName() {
  const result = new Map();
  const triggerDataFile = "F:/1.9.3k6_雪月编辑器 (2)/share/mpq/dzapi/ui/TriggerData.txt";
  const text = read(triggerDataFile);
  let currentSection = "";
  for (const rawLine of text.split(/\r?\n/)) {
    const line = rawLine.trim();
    if (!line) continue;
    const sectionMatch = /^\[([^\]]+)\]$/.exec(line);
    if (sectionMatch) {
      currentSection = sectionMatch[1];
      continue;
    }
    const eqIndex = line.indexOf("=");
    if (eqIndex < 0) continue;
    const key = line.slice(0, eqIndex).trim();
    if (!/^[A-Za-z0-9_]+$/.test(key)) continue;
    if (key.startsWith("_")) continue;
    if (currentSection === "TriggerActions") result.set(key, "动作");
    else if (currentSection === "TriggerEvents") result.set(key, "事件");
    else if (currentSection === "TriggerCalls" || currentSection === "TriggerConditions") result.set(key, "条件");
  }
  return result;
}

function deduceCategory(rawName, chineseName, baseCategory, returnType) {
  const 动作前缀 = /^(设|保存|注册|打开|关闭|发送|播放|启用|禁用|创建|销毁|修改|更新|切换|使用|绑定|解除|清理|写|加载|提交|添加|移除|改|恢复|强制)/;
  const 条件前缀 = /^(是否|能否|可否|有无|存在|判定)/;
  const 取值前缀 = /^(取|查询|检查|转换|读取|获取|查找)/;

  if (baseCategory === "事件") return "事件";

  if (returnType === "void") return "动作";
  if (chineseName && 动作前缀.test(chineseName)) return "动作";
  if (chineseName && 条件前缀.test(chineseName)) return "条件";
  if (chineseName && 取值前缀.test(chineseName)) return "取值";

  if (/^(DzSet|DzSave|DzOpen|DzClose|DzEnable|DzDisable|DzCreate|DzDestroy|DzChange|DzWrite|DzSend|DzRegister|DzBind|DzUnbind|DzPlay|DzLoad|KKApiAdd|KKApiBegin|KKApiEnd|KKApiInitialize|KKApiRequest|EXSet)/.test(rawName)) {
    return "动作";
  }
  if (/^(DzIs|KKApiIs)/.test(rawName)) {
    return "条件";
  }
  if (/^(DzGet|KKApiGet|EXGet)/.test(rawName)) {
    return "取值";
  }

  if (returnType === "boolean") {
    return "条件";
  }

  if (returnType && returnType !== "void") {
    return "取值";
  }

  return baseCategory || "条件";
}

function walk(dir) {
  const out = [];
  for (const ent of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, ent.name);
    if (ent.isDirectory()) out.push(...walk(full));
    else if (ent.isFile()) out.push(full);
  }
  return out;
}

function splitCamel(text) {
  return text.match(/[A-Z]+(?![a-z])|[A-Z]?[a-z]+|[0-9]+/g) || [text];
}

const typeAliasMap = {
  player: "玩家句柄",
  unit: "单位句柄",
  item: "物品句柄",
  widget: "控件句柄",
  effect: "特效句柄",
  integer: "number",
  real: "number",
  string: "string",
  boolean: "boolean",
  trigger: "触发器句柄",
  location: "点句柄",
  group: "单位组句柄",
  ability: "技能句柄",
  attacktype: "any",
  damagetype: "any",
  weapontype: "any",
  code: "() => void",
  agent: "代理句柄",
  texttag: "漂浮字句柄",
  force: "玩家组句柄",
  boolexpr: "布尔表达式句柄",
  button: "按钮句柄",
  dialog: "对话框句柄",
  timerdialog: "计时器对话框句柄",
  trackable: "追踪物句柄",
  leaderboard: "排行榜句柄",
  multiboard: "多面板句柄",
  multiboarditem: "多面板项句柄",
  region: "区域句柄",
  rect: "矩形句柄",
  lightning: "闪电句柄",
  sound: "音效句柄",
  destructable: "可破坏物句柄",
  nothing: "void",
};

const tokenMap = {
  Dz: "", EX: "", KK: "", Api: "", UI: "界面",
  Get: "取", Set: "设", Is: "是否", Has: "有", Save: "保存", Load: "加载", Open: "打开", Close: "关闭", Enable: "启用", Disable: "禁用",
  Create: "创建", Destroy: "销毁", Register: "注册", Change: "修改", Update: "更新", Toggle: "切换", Use: "使用", Consume: "消耗", Commit: "提交",
  Request: "请求", Extra: "额外", Integer: "整数", Boolean: "布尔", String: "字符串", Real: "实数", Data: "数据", Submit: "提交", Stored: "存档",
  Map: "地图", Game: "游戏", Match: "匹配", Result: "结算", Version: "版本", Mode: "模式", Store: "商店", Server: "服务器", Archive: "存档",
  Settings: "设置", Flush: "清空", Mission: "任务", Custom: "自定义", Value: "值", Using: "使用", Skin: "皮肤", Title: "标题",
  Public: "公共", Platform: "平台", Player: "玩家", User: "用户", Name: "名称", UserName: "用户名称", GUID: "GUID",
  Guild: "公会", Role: "职责", Level: "等级", Rank: "排名", Forum: "论坛", Activity: "活动", Config: "配置", Flags: "标记", Identity: "身份",
  MapTest: "地图测试", Test: "测试", Competition: "赛事", Day: "当天", Rounds: "局数", Continuous: "连续", Played: "游玩", Since: "距今", Last: "上次", Used: "已用", Loaded: "已加载",
  Blue: "蓝", Red: "红", VIP: "VIP", RPG: "RPG", Lobby: "大厅", Ladder: "天梯", Quick: "快速", Buy: "购买", Cancel: "取消", Lottery: "抽奖",
  Mall: "商城", Item: "物品", Items: "物品", Count: "数量", UpdateCount: "变动数量", QuickMatch: "快速匹配", Returns: "回流", Author: "作者", Connoisseur: "鉴赏家",
  Comment: "评论", Friend: "好友", Total: "总", Seconds: "秒数", Hours: "小时", Time: "时间", Timestamp: "时间戳", Date: "日期", Current: "当前",
  Progress: "进度", TotalProgress: "总进度", Achievement: "成就", Points: "点数", Exploration: "探险", Order: "预约", Ml: "云脚本", Script: "脚本", Event: "事件", Global: "全局",
  Frame: "界面", Simple: "简单", Model: "模型", Text: "文本", Font: "字体", Texture: "贴图", Alpha: "透明度", Vertex: "顶点", Color: "颜色",
  Clip: "裁剪", Parent: "父级", Child: "子项", Children: "子项数", Context: "上下文", Width: "宽度", Height: "高度", RealWidth: "实际宽度", RealHeight: "实际高度",
  Point: "点位", Absolute: "绝对", Relative: "相对", Mouse: "鼠标", Keyboard: "键盘", Window: "窗口", System: "系统", Metrics: "指标", Focus: "焦点", Screen: "屏幕",
  Edit: "编辑", Box: "框", Check: "勾选", Chat: "聊天", Message: "消息", Msg: "消息", World: "世界", Minimap: "小地图", Command: "命令", Cooldown: "冷却", Valid: "有效",
  Overlay: "覆盖层", Indicator: "指示器", AutoCast: "自动施法", Peon: "农民", Info: "信息", Panel: "面板", Buff: "增益", Bar: "条", HP: "血", Mana: "蓝",
  Add: "添加", Remove: "移除", Bind: "绑定", UnBind: "解绑", WorldToMinimapPos: "世界转小地图坐标", TexCoord: "贴图坐标", IgnoreTrackEvents: "忽略轨迹事件",
  SetNameContext: "设名称上下文", TextFontSpacing: "文本字距", GetMouse: "取鼠标", SetModel2: "设模型2", AddModel: "添加模型", AddModelEffect: "添加模型特效",
  RemoveModelEffect: "移除模型特效", Effect: "特效", Camera: "镜头", Source: "源", Target: "目标", Position: "位置", Size: "大小", Speed: "速度", Scale: "缩放", Rotate: "旋转",
  Mat: "矩阵", Reset: "重置", Animation: "动画", Animate: "动画", WideScreen: "宽屏", Wide: "宽", Tooltip: "提示", Show: "显示", Hide: "隐藏", Hook: "挂钩",
  Trigger: "触发", Sync: "同步", Local: "本地", Recipient: "接收者", Selected: "已选", Leader: "主选", Select: "选择", Cursor: "光标", Glue: "胶水",
  Unit: "单位", Ability: "技能", Hero: "英雄", Attack: "攻击", Defense: "防御", Primary: "主", Attribute: "属性", Plus: "附加", BackSwing: "后摇", CastPoint: "施法前摇",
  CastTime: "施法时长", Duration: "持续时间", HeroDuration: "英雄持续时间", LifeRegen: "生命回复", ManaRegen: "魔法回复", MaxSpeed: "最大移速", MinSpeed: "最小移速",
  Pojectile: "投射物", Projectile: "投射物", Launch: "发射", Missile: "弹道", Homing: "追踪", Arc: "弧度", Damage: "伤害", MaxDamage: "最大伤害",
  Collision: "碰撞", MoveType: "移动类型", TechReach: "科技达成", ReachTip: "达成提示", Engineering: "工程", Upgrade: "升级", New: "新", Old: "旧",
  AttackTargetCount: "攻击目标数量", XY: "坐标", DisableControlOrder: "禁控制指令", DisableLocalOrder: "禁本地指令", AsAttackTargetType: "作为攻击目标类型",
  Attack1TargetType: "攻击1目标类型", Attack2TargetType: "攻击2目标类型", SelectScale: "选择缩放", HitIgnore: "受击忽略", Description: "说明", Portrait: "头像",
  ProperName: "专名", Revive: "复活", AbilityEnable: "技能启用", AbilityDisable: "技能禁用", AbilityIsDisabled: "技能已禁用", AbilityDisabledCount: "技能禁用计数",
  Async: "异步", Building: "建造", OnBuild: "建造选位", OnTarget: "目标选择", Agent: "对象", Instant: "瞬时", ActivePatron: "活跃顾客",
  Doodad: "装饰物", Team: "队伍", Visible: "可见", AnimationCount: "动画数量", AnimationName: "动画名称", AnimationTime: "动画时长", TimeScale: "时间缩放",
  ItemGet: "物品取", ItemSet: "物品设", StringContains: "字符串包含", StringFind: "字符串查找", StringReplace: "字符串替换", StringInsert: "字符串插入",
  Trim: "裁剪空白", Reverse: "反转", First: "首个", Last: "最后", Not: "非", Of: "中", Bit: "位", Shift: "移位", Left: "左", Right: "右",
  Queue: "队列", Group: "单位组", Immediate: "立即", Order: "命令", ById: "按ID", PointOrder: "点命令", TargetOrder: "目标命令", Neutral: "中立",
  Orders: "命令队列", Clear: "清空", Exec: "执行", ForceStop: "强停", Xlsx: "表格", Worksheet: "工作表", Row: "行", Column: "列", Cell: "单元格",
  Float: "浮点", Type: "类型", Targs: "目标类型", Range: "范围", Area: "区域", Cost: "消耗", ReqLevel: "需求等级", UnitId: "单位ID", BuildOrderId: "建造命令ID",
  BuildModel: "建造模型", Hotkey: "热键", Convert: "转换", Str: "字符串", ButtonPos: "按钮位置", SpellBook: "法术书", Art: "美术", Tip: "提示",
  UberTip: "扩展提示", OrderId: "命令ID", Id: "ID", List: "列表", Facing: "朝向", Pause: "暂停", Execute: "执行", Array: "数组", State: "状态", Active: "激活", All: "全部", From: "从", Cache: "缓存", Clipboard: "剪贴板", Coord: "坐标", Priority: "优先级", Particle: "粒子", Leap: "闰", Year: "年", Url: "链接", Preselect: "预选", Ime: "输入法", Req: "需求", Control: "控制", Tech: "科技", Max: "最大", Min: "最小", Regen: "回复", Cool: "冷却", Artillery: "火炮", Bounce: "弹跳", Line: "直线", Splash: "溅射", Carrion: "腐尸", Swarm: "蜂群", Build: "建造", Cast: "施法", Disabled: "已禁用", SpellBook: "法术书", Reach: "达成", Uber: "扩展", Proper: "专名", Shadow: "阴影", Start: "初始", Find: "查找", Contains: "包含", Insert: "插入", Replace: "替换", Kill: "杀死", Illusion: "幻象", Unbind: "解绑", Widget: "控件", Limit: "限制", Move: "移动", ForceStop: "强停", Patron: "顾客", Toc: "界面目录", Jass: "JASS", FPS: "帧率", Abil: "技能", Life: "生命", Overhead: "头顶", Offset: "偏移", As: "作为", Key: "按键", Event: "事件", Code: "代码", By: "按", At: "第", X: "X", Y: "Y", Z: "Z", A: "A", B: "B", C: "C", D: "D", E: "E",
  UnitAbility: "单位技能", AbilityId: "技能ID", ItemData: "物品数据", UnitDataCacheInteger: "单位数据缓存整数", UIAddLevelArrayInteger: "界面等级数组整数", HashtableSetNull: "哈希表设空",
  FixUnitEventMemoryLeak: "修复单位事件泄漏", FrameBindAddHideRect: "界面绑定附加隐藏矩形", RandomSaveGameCount: "随机存档次数", Backend: "后端", Logic: "逻辑",
  Exists: "存在", IntResult: "整数结果", StrResult: "字符串结果", UpdateTime: "更新时间", Groupkey: "分组键", Begin: "开始", End: "结束", Batch: "批量",
  CaseInsensitive: "忽略大小写", Surrender: "投降", TeamId: "队伍ID", Pinned: "置顶", ConsumeLevel: "消费等级", DrawSkillPanel: "绘制技能面板", FogVisible: "雾中可见",
  MaskVisible: "遮罩可见", DisableAttackSpeedLimit: "禁攻速上限", MaxFps: "最大帧率", FPS: "FPS", WriteLog: "写日志", QQGroupUrl: "QQ群链接", OpenMall: "打开商城",
};

const paramNameOverrides = {
  whichPlayer: "玩家",
  whichUnit: "单位",
  whichItem: "物品",
  whichEffect: "特效",
  whichAbility: "技能",
  whichHandle: "句柄",
  whichframe: "界面",
  whichFrame: "界面",
  whichGroup: "单位组",
  whichWidget: "控件",
  whichboard: "面板",
  whichUnitType: "单位类型",
  whichData: "数据项",
  whichString: "目标字符串",
  whichPosition: "位置",
  whichkey: "键名",
  key: "键名",
  groupkey: "分组键",
  eventKey: "事件键",
  eventType: "事件类型",
  value: "值",
  width: "宽度",
  height: "高度",
  path: "路径",
  filePath: "文件路径",
  fileName: "文件名",
  model: "模型路径",
  modelFile: "模型路径",
  model_path: "模型路径",
  texture: "贴图路径",
  text: "文本",
  tip: "提示",
  ubertip: "扩展提示",
  name: "名称",
  msg: "消息",
  recipient: "接收者",
  p: "玩家",
  u: "单位",
  it: "物品",
  g: "单位组",
  t: "类型",
  x: "x",
  y: "y",
  z: "z",
  alpha: "透明度",
  color: "颜色",
  scale: "缩放",
  speed: "速度",
  angle: "角度",
  anim: "动画",
  link: "链接",
  row: "行",
  column: "列",
  index: "序号",
  id: "ID",
  uid: "单位ID",
  abil_id: "技能ID",
  abilcode: "技能编码",
  abilityId: "技能ID",
  itemcode: "物品编码",
  data_type: "数据类型",
  state_type: "状态类型",
  unitid: "单位ID",
  targetid: "目标单位ID",
  mapId: "地图ID",
  ranking: "排名",
  label: "标签",
  option: "选项",
  enable: "是否启用",
  visible: "是否显示",
  is_enable: "是否启用",
  is_unlock: "是否解锁",
  is_down: "是否按下",
  is_active: "是否激活",
  is_disable: "是否禁用",
  keep_current_bonus: "保留当前加成",
  keep_primary_bonus: "保留主属性加成",
  ignore_polymorph: "忽略变形",
  mouse_type: "鼠标类型",
  key_code: "键码",
  order: "命令ID",
  unitId: "单位ID",
  targetWidget: "目标控件",
  instantTargetWidget: "瞬时目标控件",
  skinType: "皮肤类型",
  hideUI: "是否隐藏界面",
  anchor: "锚点",
  attachName: "附着点",
  model_frame: "模型界面",
  model_file: "模型路径",
  world_x: "世界x",
  world_y: "世界y",
  world_z: "世界z",
  screen_x: "屏幕x",
  screen_y: "屏幕y",
  fog_visible: "雾中可见",
  unit_visible: "单位可见",
  dead_visible: "死亡可见",
  check_box_frame: "勾选框界面",
  checked: "是否勾选",
  doodad: "装饰物",
  var: "变体",
  rotate: "旋转角度",
  animName: "动画名",
  animRandom: "是否随机动画",
  byteIndex: "字节序号",
  byteValue: "字节值",
  bitsToShift: "移位位数",
  b1: "字节1",
  b2: "字节2",
  b3: "字节3",
  b4: "字节4",
  i: "整数值",
  a: "值A",
  b: "值B",
  eff: "特效",
  Handle: "句柄",
  neutralStructure: "中立建筑",
  forWhichPlayer: "归属玩家",
  target: "目标",
  source: "来源",
  trig: "触发器",
  xfunc: "回调",
  loc: "点",
  obj: "对象",
  frame: "界面",
  parent: "父界面",
  root: "根界面",
  template: "模板",
  style: "样式",
  attachPoint: "附着点",
  attach_point: "附着点",
  axisX: "轴x",
  axisY: "轴y",
  axisZ: "轴z",
  priority: "优先级",
  texId: "贴图ID",
  blend: "混合模式",
  spacing: "字距",
  level: "等级",
  left: "左",
  top: "上",
  right: "右",
  bottom: "下",
  max_fps: "最大FPS",
  off: "偏移",
  seconds: "秒数",
  count: "数量",
  minHours: "最小时长",
  maxHours: "最大时长",
};

function translateWords(words) {
  return words
    .map(word => {
      if (tokenMap[word] != null) return tokenMap[word];
      const 首字母大写词 = word ? word[0].toUpperCase() + word.slice(1) : word;
      if (tokenMap[首字母大写词] != null) return tokenMap[首字母大写词];
      const 全大写词 = word ? word.toUpperCase() : word;
      if (tokenMap[全大写词] != null) return tokenMap[全大写词];
      return word;
    })
    .join("");
}

function buildChineseName(rawName) {
  const overrides = {
    DzAPI_Map_GetGameStartTime: "地图_取开局时间",
    DzAPI_Map_GetActivityData: "地图_取活动数据",
    DzAPI_Map_MissionComplete: "地图_任务完成",
    DzAPI_Map_GetServerArchiveDrop: "地图_取服务器存档掉落",
    DzAPI_Map_GetMapLevel: "地图_取地图等级",
    DzAPI_Map_IsRPGLobby: "地图_是否RPG大厅",
    DzAPI_Map_GetPublicArchive: "地图_取公共存档",
    DzAPI_Map_Ladder_SetStat: "地图_天梯设统计",
    DzAPI_Map_IsBlueVIP: "地图_是否蓝贵宾",
    DzAPI_Map_SaveServerValue: "地图_保存服务器值",
    DzAPI_Map_GetServerValue: "地图_取服务器值",
    DzAPI_Map_Stat_SetStat: "地图_统计设统计",
    DzAPI_Map_Ladder_SetPlayerStat: "地图_天梯设玩家统计",
    DzAPI_Map_IsRPGLadder: "地图_是否RPG天梯",
    DzAPI_Map_GetMatchType: "地图_取匹配类型",
    DzAPI_Map_UpdatePlayerHero: "地图_更新玩家英雄",
    DzAPI_Map_GetLadderLevel: "地图_取天梯等级",
    DzAPI_Map_IsRedVIP: "地图_是否红贵宾",
    DzAPI_Map_GetLadderRank: "地图_取天梯排名",
    DzAPI_Map_GetMapLevelRank: "地图_取地图等级排名",
    DzAPI_Map_GetServerValueErrorCode: "地图_取服务器值错误码",
    DzAPI_Map_GetGuildName: "地图_取公会名",
    DzAPI_Map_GetServerArchiveEquip: "地图_取服务器存档装备",
    DzAPI_Map_GetGuildRole: "地图_取公会职责",
    DzAPI_Map_GetMapConfig: "地图_取地图配置",
    DzAPI_Map_HasMallItem: "地图_有商城物品",
    DzAPI_Map_ChangeStoreItemCoolDown: "地图_改商店物品冷却",
    DzAPI_Map_ToggleStore: "地图_切换商店",
    DzAPI_Map_OrpgTrigger: "地图_触发开放角色扮演",
    DzAPI_Map_GetUserID: "地图_取用户ID",
    DzAPI_Map_GetPlatformVIP: "地图_取平台VIP",
    DzAPI_Map_SavePublicArchive: "地图_保存公共存档",
    DzAPI_Map_UseConsumablesItem: "地图_使用消耗品",
    DzAPI_Map_ChangeStoreItemCount: "地图_改商店物品数量",
    DzAPI_Map_Statistics: "地图_统计上报",
    DzAPI_Map_GameResult_CommitGameResultNoEnd: "地图_游戏结算提交结果不结束",
    DzAPI_Map_GameResult_CommitTitle: "地图_游戏结算提交标题",
    DzAPI_Map_GetLotteryUsedCount: "地图_取抽奖已用数量",
    DzAPI_Map_GetLotteryUsedCountEx: "地图_取抽奖已用数量扩展",
    DzAPI_Map_Global_ChangeMsg: "地图_全局修改消息",
    DzAPI_Map_Global_GetStoreString: "地图_全局取商店字符串",
    DzAPI_Map_Global_StoreString: "地图_全局商店字符串",
    DzAPI_Map_MapsConsumeGold: "地图_地图消耗金币",
    DzAPI_Map_MapsConsumeLumber: "地图_地图消耗木材",
    DzAPI_Map_MapsConsumeLv1: "地图_地图消耗等级1",
    DzAPI_Map_MapsConsumeLv2: "地图_地图消耗等级2",
    DzAPI_Map_MapsConsumeLv3: "地图_地图消耗等级3",
    DzAPI_Map_MapsConsumeLv4: "地图_地图消耗等级4",
    DzAPI_Map_MapsLevel: "地图_地图等级",
    DzAPI_Map_MapsTotalPlayed: "地图_地图总游玩",
    DzAPI_Map_PlayedGames: "地图_游玩局数",
    DzAPI_Map_PlayerLoadedItems: "地图_玩家已加载物品",
    DzAPI_Map_CustomRankCount: "地图_自定义排行数量",
    DzAPI_Map_CustomRankPlayerName: "地图_自定义排行玩家名",
    DzAPI_Map_CustomRankValue: "地图_自定义排行值",
    DzAPI_Map_EnablePlatformSettings: "地图_启用平台设置",
    DzAPI_Map_FlushStoredMission: "地图_清空存档任务",
    DzAPI_Map_GetStoredAbilityId: "地图_取存档技能ID",
    DzAPI_Map_GetStoredBoolean: "地图_取存档布尔",
    DzAPI_Map_GetStoredInteger: "地图_取存档整数",
    DzAPI_Map_GetStoredIntegerEX: "地图_取存档整数扩展",
    DzAPI_Map_GetStoredReal: "地图_取存档实数",
    DzAPI_Map_GetStoredString: "地图_取存档字符串",
    DzAPI_Map_GetStoredStringEX: "地图_取存档字符串扩展",
    DzAPI_Map_GetStoredUnitType: "地图_取存档单位类型",
    DzAPI_Map_IsPlayerUsingSkin: "地图_是否玩家使用皮肤",
    DzAPI_Map_Ladder_SubmitAblityIdData: "地图_天梯提交技能ID数据",
    DzAPI_Map_Ladder_SubmitBooleanData: "地图_天梯提交布尔数据",
    DzAPI_Map_Ladder_SubmitIntegerData: "地图_天梯提交整数数据",
    DzAPI_Map_Ladder_SubmitItemData: "地图_天梯提交物品数据",
    DzAPI_Map_Ladder_SubmitItemIdData: "地图_天梯提交物品ID数据",
    DzAPI_Map_Ladder_SubmitPlayerExtraExp: "地图_天梯提交玩家额外经验",
    DzAPI_Map_Ladder_SubmitPlayerRank: "地图_天梯提交玩家排名",
    DzAPI_Map_Ladder_SubmitTitle: "地图_天梯提交标题",
    DzAPI_Map_Stat_SubmitUnitData: "地图_统计提交单位数据",
    DzAPI_Map_Stat_SubmitUnitIdData: "地图_统计提交单位ID数据",
    DzGetGameUI: "取游戏界面",
    DzGetTriggerKeyPlayer: "取触发按键玩家",
    DzGetTriggerKey: "取触发按键",
    DzLoadToc: "加载Toc",
    DzFrameSetText: "界面_设文本",
    DzFrameSetPoint: "界面_设点位",
    DzFrameSetSize: "界面_设大小",
    DzFrameSetFont: "界面_设字体",
    DzFrameSetTexture: "界面_设贴图",
    DzFrameSetTextAlignment: "界面_设文本对齐",
    DzFrameShow: "界面_显示",
    DzCreateFrameByTagName: "界面_按标签创建",
    DzCreateFrame: "界面_创建",
    DzFrameSetAbsolutePoint: "界面_设绝对点位",
    DzFrameAddModelEffect: "界面_添加模型特效",
    DzFrameBindWidget: "界面_绑定控件",
    DzFrameBindWorldPos: "界面_绑定世界坐标",
    DzFrameEnableClipRect: "界面_启用裁剪矩形",
    DzFrameGetPointRelative: "界面_取点位相对锚点",
    DzFrameGetPointRelativePoint: "界面_取点位相对点位",
    DzFrameGetPointValid: "界面_取点位是否有效",
    DzFrameSetCheckBoxState: "界面_设勾选框状态",
    DzFrameRemoveModelEffect: "界面_移除模型特效",
    DzFrameSetAnimateByIndex: "界面_设动画按序号",
    DzFrameSetIgnoreTrackEvents: "界面_设忽略轨迹事件",
    DzFrameSetModelAnimationByIndex: "界面_设模型动画按序号",
    DzFrameSetPriority: "界面_设优先级",
    DzFrameSetTextFontSpacing: "界面_设文本字距",
    DzFrameUnBind: "界面_解绑",
    DzFrameUnlockMouseRectLimit: "界面_解锁鼠标矩形限制",
    DzFrameWorldToMinimapPosX: "界面_世界转小地图坐标X",
    DzFrameWorldToMinimapPosY: "界面_世界转小地图坐标Y",
    EXGetUnitAbility: "单位扩展_取技能",
    EXGetUnitAbilityByIndex: "单位扩展_按序号取技能",
    EXGetAbilityId: "技能扩展_取ID",
    EXGetAbilityState: "技能扩展_取状态",
    EXSetAbilityState: "技能扩展_设状态",
    EXGetAbilityDataReal: "技能扩展_取实数数据",
    EXSetAbilityDataReal: "技能扩展_设实数数据",
    EXGetAbilityDataInteger: "技能扩展_取整数数据",
    EXSetAbilityDataInteger: "技能扩展_设整数数据",
    EXGetAbilityDataString: "技能扩展_取字符串数据",
    EXSetAbilityDataString: "技能扩展_设字符串数据",
    EXSetAbilityAEmeDataA: "技能扩展_设AEme数据A",
    EXGetItemDataString: "物品扩展_取字符串数据",
    EXSetItemDataString: "物品扩展_设字符串数据",
    EXSetUnitFacing: "单位扩展_设朝向",
    EXPauseUnit: "单位扩展_暂停",
    EXSetUnitCollisionType: "单位扩展_设碰撞类型",
    EXSetUnitMoveType: "单位扩展_设移动类型",
    EXExecuteScript: "脚本扩展_执行",
    DzAbilitySetEnable: "平台_技能设启用",
    DzAbilitySetStringData: "平台_技能设字符串数据",
    DzBitAnd: "平台_位与",
    DzBitGet: "平台_取位",
    DzBitGetByte: "平台_取字节",
    DzBitNot: "平台_位非",
    DzBitOr: "平台_位或",
    DzBitSet: "平台_设位",
    DzBitSetByte: "平台_设字节",
    DzBitShiftLeft: "平台_位左移",
    DzBitShiftRight: "平台_位右移",
    DzBitToInt: "平台_位转整数",
    DzBitXor: "平台_位异或",
    DzConvertStr2Targs: "平台_字符串转目标类型",
    DzConvertTargs2Str: "平台_目标类型转字符串",
    DzDoodadCreate: "装饰物_创建",
    DzDoodadGetCurrentAnimationIndex: "装饰物_取当前动画序号",
    DzDoodadGetTypeId: "装饰物_取类型ID",
    DzDoodadSetOrientMatrixResize: "装饰物_重置朝向矩阵缩放",
    DzDoodadSetOrientMatrixRotate: "装饰物_设朝向矩阵旋转",
    DzDoodadSetOrientMatrixScale: "装饰物_设朝向矩阵缩放",
    DzEffectBindEffect: "平台_对象绑定特效",
    DzGetConvertScreenPositionX: "平台_取屏幕坐标X",
    DzGetConvertScreenPositionY: "平台_取屏幕坐标Y",
    DzGetCacheModelCount: "取缓存模型数量",
    DzGetDoodadsCount: "取装饰物数量",
    DzGetEffectVertexAlpha: "取特效顶点透明度",
    DzGetEffectVertexColor: "取特效顶点颜色",
    DzGetHeroPrimaryAttribute: "取英雄主属性",
    DzGetHeroPrimaryAttributeBonus: "取英雄主属性附加",
    DzGetHeroPrimaryAttributeType: "取英雄主属性类型",
    DzGetJassStringTableCount: "取Jass字符串表数量",
    DzGetTerrainZ: "取地形Z",
    DzIsLeapYear: "是否闰年",
    DzIsWindowActive: "是否窗口激活",
    DzOpenQQGroupUrl: "打开_QQ群链接",
    DzPlayEffectAnimation: "平台_播放特效动画",
    DzPlayerSendChat: "平台_玩家发送聊天",
    DzPositionCanPlaceAround: "平台_位置周围可放置",
    DzRemovePlayerTechResearched: "平台_移除玩家已研发科技",
    DzReviveUnit: "平台_复活单位",
    DzSetClipboard: "设剪贴板",
    DzSetDoodadsMatReset: "设装饰物矩阵重置",
    DzSetDoodadsMatRotateX: "设装饰物矩阵旋转X",
    DzSetDoodadsMatRotateY: "设装饰物矩阵旋转Y",
    DzSetDoodadsMatRotateZ: "设装饰物矩阵旋转Z",
    DzSetDoodadsMatScale: "设装饰物矩阵缩放",
    DzDisableAttackSpeedLimit: "禁用_攻击速度上限",
    DzEnableDrawSkillPanel: "启用_绘制技能面板",
    DzEnableDrawSkillPanelByPlayer: "启用_按玩家绘制技能面板",
    DzEnableHashtableSetNull: "启用_哈希表设空",
    DzFixUnitEventMemoryLeak: "平台_修复单位事件内存泄漏",
    DzFrameBindAddHideRect: "界面_绑定附加隐藏矩形",
    DzFrameGetCommandBarButton: "界面_取命令条按钮",
    DzFrameGetCommandBarButtonAutoCastIndicator: "界面_取命令条按钮自动施法指示器",
    DzFrameGetCommandBarButtonCooldownIndicator: "界面_取命令条按钮冷却指示器",
    DzFrameGetCommandBarButtonNumberOverlay: "界面_取命令条按钮数字覆盖层",
    DzFrameGetCommandBarButtonNumberText: "界面_取命令条按钮数字文本",
    DzFrameGetInfoPanelBuffButton: "界面_取信息面板Buff按钮",
    DzFrameGetInfoPanelSelectedButton: "界面_取信息面板选中按钮",
    DzFrameGetLowerButtonBar: "界面_取下方按钮条",
    DzFrameSetTexCoord: "界面_设贴图坐标",
    DzGetActivePatron: "取激活顾客",
    DzGetHeroPrimaryAttributeBonus: "取英雄主属性附加",
    DzGetOnBuildAgent: "取建造选位对象",
    DzGetOnBuildOrderId: "取建造选位命令ID",
    DzGetOnBuildType: "取建造选位命令类型",
    DzGetOnTargetAbilityId: "取目标选择技能ID",
    DzGetOnTargetAgent: "取目标选择对象",
    DzGetOnTargetInstantTarget: "取目标选择瞬时目标",
    DzGetOnTargetOrderId: "取目标选择命令ID",
    DzGetOnTargetType: "取目标选择命令类型",
    DzGetUnitAbilityBackSwing: "取单位技能后摇",
    DzGetUnitAbilityBuildOrderId: "取单位技能建造命令ID",
    DzGetUnitAbilityCastPoint: "取单位技能施法前摇",
    DzGetUnitAbilityCastTime: "取单位技能施法时长",
    DzGetUnitAbilityDataA: "取单位技能dataA",
    DzGetUnitAbilityDataB: "取单位技能dataB",
    DzGetUnitAbilityDataC: "取单位技能dataC",
    DzGetUnitAbilityDataD: "取单位技能dataD",
    DzGetUnitAbilityDataE: "取单位技能dataE",
    DzGetUnitAbilityDisabledCount: "取单位技能禁用计数",
    DzGetUnitAbilityHeroDuration: "取单位技能英雄持续时间",
    DzGetUnitAbilityIsDisabled: "取单位技能是否已禁用",
    DzGetUnitAbilityOrderId: "取单位技能命令ID",
    DzGetUnitAbilitySpellBookList: "取单位技能法术书列表",
    DzGetUnitAbilityTechReach: "取单位技能科技达成",
    DzGetUnitAbilityUberTip: "取单位技能扩展提示",
    DzGetUnitAbilityUnitId: "取单位技能单位ID",
    DzGetUnitAsAttackTargetType: "取单位作为攻击目标类型",
    DzGetUnitBackSwing: "取单位后摇",
    DzGetUnitCastPoint: "取单位施法前摇",
    DzGetUnitLifeRegen: "取单位生命回复",
    DzGetUnitOverheadOffset: "取单位头顶偏移",
    DzGroupGetUnitAt: "平台_单位组取第N个单位",
    DzKillUnit: "平台_杀死单位",
    DzLoadToc: "加载界面目录",
    DzRegisterOnBuildLocal: "注册_建造选位本地",
    DzRegisterOnTargetLocal: "注册_目标选择本地",
    DzSetEffectFogVisible: "设特效雾中可见",
    DzSetEffectMaskVisible: "设特效遮罩可见",
    DzSetEffectPos: "设特效坐标",
    DzSetForceUIKey: "强制_界面按键",
    DzSetGlobalUnitMinMaxMoveSpeed: "设全局单位最小最大移动速度",
    DzSetHeroPrimaryAttribute: "设英雄主属性",
    DzSetHeroPrimaryAttributeBonus: "设英雄主属性附加",
    DzSetHeroPrimaryAttributeType: "设英雄主属性类型",
    DzSetHeroTypeProperName: "设英雄类型专名",
    DzSetMaxFps: "设最大FPS",
    DzSetMinMaxAttackSpeedFactor: "设最小最大攻击速度系数",
    DzSetMoveSpeedBonusesStack: "设移动速度加成叠加",
    DzSetPariticle2Size: "设粒子2大小",
    DzSetUnitAbilityBackSwing: "设单位技能后摇",
    DzSetUnitAbilityBuildModel: "设单位技能建造模型",
    DzSetUnitAbilityBuildOrderId: "设单位技能建造命令ID",
    DzSetUnitAbilityButtonPos: "设单位技能按钮位置",
    DzSetUnitAbilityCastPoint: "设单位技能施法前摇",
    DzSetUnitAbilityCastTime: "设单位技能施法时长",
    DzSetUnitAbilityDataA: "设单位技能dataA",
    DzSetUnitAbilityDataB: "设单位技能dataB",
    DzSetUnitAbilityDataC: "设单位技能dataC",
    DzSetUnitAbilityDataD: "设单位技能dataD",
    DzSetUnitAbilityDataE: "设单位技能dataE",
    DzSetUnitAbilityHeroDuration: "设单位技能英雄持续时间",
    DzSetUnitAbilityOrderId: "设单位技能命令ID",
    DzSetUnitAbilitySpellBookAddAbility: "设单位技能法术书添加技能",
    DzSetUnitAbilitySpellBookList: "设单位技能法术书列表",
    DzSetUnitAbilitySpellBookRemoveAbility: "设单位技能法术书移除技能",
    DzSetUnitAbilityTechReach: "设单位技能科技达成",
    DzSetUnitAbilityTechReachTip: "设单位技能科技达成提示",
    DzSetUnitAbilityUberTip: "设单位技能扩展提示",
    DzSetUnitAbilityUnitId: "设单位技能单位ID",
    DzSetUnitAsAttackTargetType: "设单位作为攻击目标类型",
    DzSetUnitBackSwing: "设单位后摇",
    DzSetUnitCastPoint: "设单位施法前摇",
    DzSetUnitLifeRegen: "设单位生命回复",
    DzSetWidgetSpriteScale: "设控件精灵缩放",
    DzStringContains: "平台_字符串包含",
    DzStringFind: "平台_字符串查找",
    DzStringFindFirstNotOf: "平台_字符串查找首个不属于",
    DzStringFindFirstOf: "平台_字符串查找首个属于",
    DzStringFindLastNotOf: "平台_字符串查找最后不属于",
    DzStringFindLastOf: "平台_字符串查找最后属于",
    DzStringInsert: "平台_字符串插入",
    DzStringReplace: "平台_字符串替换",
    DzTextTagGetShadowColor: "漂浮字_取阴影颜色",
    DzTextTagSetShadowColor: "漂浮字_设阴影颜色",
    DzTextTagSetStartAlpha: "漂浮字_设初始透明度",
    DzToggleFPS: "平台_切换帧率",
    DzTriggerRegisterKeyEventByCode: "平台_触发注册按键事件按代码",
    DzUnbindEffect: "平台_解绑特效",
    DzUnitCanPlaceAround: "单位_周围可放置",
    DzUnitCreateIllusion: "单位_创建幻象",
    DzUnitCreateIllusionFromUnit: "单位_从单位创建幻象",
    DzUnitFindAbility: "单位_查找技能",
    DzUnitQueueForceStop: "单位_命令队列强停",
    DzUnitSetMoveType: "单位_设移动类型",
    DzUnlockBlpSizeLimit: "平台_解锁贴图大小限制",
    DzUnlockOpCodeLimit: "平台_解锁操作码限制",
    DzWidgetSetMinimapIcon: "平台_控件设小地图图标",
    DzWidgetSetMinimapIconEnable: "平台_控件设小地图图标启用",
    DzWriteLog: "写_日志",
    EXEffectMatRotateZ: "扩展_特效矩阵旋转Z",
    EXGetAbilityId: "技能扩展_取ID",
    EXSetAbilityAEmeDataA: "技能扩展_设AEmeDataA",
    KKApiAchievementPoints: "平台扩展_成就点数",
    KKApiAddBatchSaveArchive: "平台扩展_添加批量保存存档",
    KKApiAddBatchSaveArchiveBoolean: "平台扩展_添加批量保存存档布尔",
    KKApiAddBatchSaveArchiveInteger: "平台扩展_添加批量保存存档整数",
    KKApiAddBatchSaveArchiveReal: "平台扩展_添加批量保存存档实数",
    KKApiAddBatchSaveArchiveString: "平台扩展_添加批量保存存档字符串",
    KKApiBeginBatchSaveArchive: "平台扩展_开始批量保存存档",
    KKApiCheckBackendLogicExists: "平台扩展_检查后端逻辑存在",
    KKApiConsumeLevel: "平台扩展_消耗等级",
    KKApiDayCount: "平台扩展_当天局数",
    KKApiEndBatchSaveArchive: "平台扩展_结束批量保存存档",
    KKApiGetBackendLogicGroup: "平台扩展_取后端逻辑分组",
    KKApiGetBackendLogicIntResult: "平台扩展_取后端逻辑整数结果",
    KKApiGetBackendLogicStrResult: "平台扩展_取后端逻辑字符串结果",
    KKApiGetBackendLogicUpdateTime: "平台扩展_取后端逻辑更新时间",
    KKApiGetCompetitionGameMode: "平台扩展_取赛事游戏模式",
    KKApiGetGuildLevel: "平台扩展_取公会等级",
    KKApiGetLadderSurrenderTeamId: "平台扩展_取天梯投降队伍编号",
    KKApiGetMallItemUpdateCount: "平台扩展_取商城物品更新数量",
    KKApiGetMapVersion: "平台扩展_取地图版本",
    KKApiGetServerValueLeftLimit: "平台扩展_取服务器值左限制",
    KKApiGetSyncBackendLogic: "平台扩展_取同步后端逻辑",
    KKApiGetTimestampDate: "平台扩展_取时间戳日期",
    KKApiGetTimestampDay: "平台扩展_取时间戳当天",
    KKApiGetTimestampMonth: "平台扩展_取时间戳月份",
    KKApiGetTimestampYear: "平台扩展_取时间戳年份",
    KKApiInitializeGameKey: "平台扩展_初始化游戏按键",
    KKApiIsAchievementCompleted: "平台扩展_是否成就已完成",
    KKApiIsGameMode: "平台扩展_是否游戏模式",
    KKApiIsPinned: "平台扩展_是否置顶",
    KKApiIsTaskInProgress: "平台扩展_是否任务进行中",
    KKApiMapExplorationNum: "平台扩展_地图探险数量",
    KKApiMapExplorationTime: "平台扩展_地图探险时间",
    KKApiMapOrderNum: "平台扩展_地图命令数量",
    KKApiMlScriptEvent: "平台扩展_云脚本事件",
    KKApiPlayTime: "平台扩展_游玩时间",
    KKApiPlayerGUID: "平台扩展_玩家全局标识",
    KKApiPlayerIdentityType: "平台扩展_玩家身份类型",
    KKApiQueryTaskCurrentProgress: "平台扩展_查询任务当前进度",
    KKApiQueryTaskTotalProgress: "平台扩展_查询任务总进度",
    KKApiRandomSaveGameCount: "平台扩展_随机存档次数",
    KKApiRemoveBackendLogicResult: "平台扩展_移除后端逻辑结果",
    KKApiRequestBackendLogic: "平台扩展_请求后端逻辑",
    KKApiTriggerRegisterBackendLogicDelete: "平台扩展_触发注册后端逻辑删除",
    KKApiTriggerRegisterBackendLogicUpdata: "平台扩展_触发注册后端逻辑更新",
    KKApiTriggerRegisterLadderSurrender: "平台扩展_触发注册天梯投降",
    KKCommandButtonClick: "平台扩展_命令按钮点击",
    KKCommandButtonGetAbilityId: "平台扩展_命令按钮取技能编号",
    KKCommandButtonGetOrderId: "平台扩展_命令按钮取命令编号",
    KKCommandGetCooldownModel: "平台扩展_命令取冷却模型",
    KKCommandSetCooldownModelScale: "平台扩展_命令设冷却模型缩放",
    KKCommandSetCooldownModelSize: "平台扩展_命令设冷却模型大小",
    KKCommandTargetClick: "平台扩展_命令目标点击",
    KKCommandTerrainClick: "平台扩展_命令地形点击",
    KKConvertAbilityId2Int: "平台扩展_转换技能编号到整数",
    KKConvertColor2Int: "平台扩展_转换颜色到整数",
    KKConvertInt2AbilityId: "平台扩展_转换整数到技能编号",
    KKConvertInt2Color: "平台扩展_转换整数到颜色",
    KKCreateCommandButton: "平台扩展_创建命令按钮",
    KKDestroyCommandButton: "平台扩展_销毁命令按钮",
    KKFrameBindItem: "平台扩展_界面绑定物品",
    KKPositionCanPlaceAroundLoc: "平台扩展_点周围可放置",
    KKSetCommandUnitAbility: "平台扩展_设命令单位技能",
    KKSimpleFrameIsVisible: "平台扩展_简单界面是否可见",
    KKUnitCanPlaceAroundLoc: "平台扩展_单位点周围可放置",
    KKUnitCanPlaceAroundLocItem: "平台扩展_单位物品点周围可放置",
    KKWESetUnitDataCacheInteger: "平台扩展_编辑器设单位数据缓存整数",
    KKWEUIAddBuildsIds: "平台扩展_编辑器单位界面添加建造编号",
    KKWEUIAddMakesItemIds: "平台扩展_编辑器单位界面添加制造物品编号",
    KKWEUIAddRequiresAmounts: "平台扩展_编辑器单位界面添加需求数量",
    KKWEUIAddRequiresTechcode: "平台扩展_编辑器单位界面添加需求科技代码",
    KKWEUIAddRequiresUnitId: "平台扩展_编辑器单位界面添加需求单位编号",
    KKWEUnitUIAddRequiresAmounts: "平台扩展_编辑器单位界面添加需求数量",
    KKWEUnitUIAddRequiresTechcode: "平台扩展_编辑器单位界面添加需求科技代码",
    KKWEUnitUIAddRequiresUnitCode: "平台扩展_编辑器单位界面添加需求单位编号",
    KKWEUIAddResearchesIds: "平台扩展_编辑器单位界面添加研究编号",
    KKWEUIAddSellsItemIds: "平台扩展_编辑器单位界面添加出售物品编号",
    KKWEUIAddSellsUnitIds: "平台扩展_编辑器单位界面添加出售单位编号",
    KKWEUIAddTrainsIds: "平台扩展_编辑器单位界面添加训练编号",
    KKWEUIAddUpgradesIds: "平台扩展_编辑器单位界面添加升级编号",
  };
  if (overrides[rawName]) return overrides[rawName];

  let prefix = "平台_";
  let body = rawName;
  if (rawName.startsWith("DzAPI_Map_")) { prefix = "地图_"; body = rawName.slice(10); }
  else if (rawName.startsWith("KKApi")) { prefix = "KK平台_"; body = rawName.slice(5); }
  else if (rawName.startsWith("DzFrame")) { prefix = "界面_"; body = rawName.slice(7); }
  else if (rawName.startsWith("DzSimpleMessageFrame")) { prefix = "简单消息界面_"; body = rawName.slice("DzSimpleMessageFrame".length); }
  else if (rawName.startsWith("DzSimple")) { prefix = "简单界面_"; body = rawName.slice(8); }
  else if (rawName.startsWith("DzTextTag")) { prefix = "漂浮字_"; body = rawName.slice(9); }
  else if (rawName.startsWith("DzDoodad")) { prefix = "装饰物_"; body = rawName.slice(8); }
  else if (rawName.startsWith("DzItem")) { prefix = "物品_"; body = rawName.slice(6); }
  else if (rawName.startsWith("DzUnit")) { prefix = "单位_"; body = rawName.slice(6); }
  else if (rawName.startsWith("DzQueue")) { prefix = "队列_"; body = rawName.slice(7); }
  else if (rawName.startsWith("DzLaunch")) { prefix = "发射_"; body = rawName.slice(8); }
  else if (rawName.startsWith("DzGet")) { prefix = "取"; body = rawName.slice(5); }
  else if (rawName.startsWith("DzSet")) { prefix = "设"; body = rawName.slice(5); }
  else if (rawName.startsWith("DzIs")) { prefix = "是否"; body = rawName.slice(4); }
  else if (rawName.startsWith("DzEnable")) { prefix = "启用_"; body = rawName.slice(8); }
  else if (rawName.startsWith("DzDisable")) { prefix = "禁用_"; body = rawName.slice(9); }
  else if (rawName.startsWith("DzCreate")) { prefix = "创建_"; body = rawName.slice(8); }
  else if (rawName.startsWith("DzDestroy")) { prefix = "销毁_"; body = rawName.slice(9); }
  else if (rawName.startsWith("DzChange")) { prefix = "改_"; body = rawName.slice(8); }
  else if (rawName.startsWith("DzWrite")) { prefix = "写_"; body = rawName.slice(7); }
  else if (rawName.startsWith("DzOpen")) { prefix = "打开_"; body = rawName.slice(6); }
  else if (rawName.startsWith("DzSend")) { prefix = "发送_"; body = rawName.slice(6); }
  else if (rawName.startsWith("DzForce")) { prefix = "强制_"; body = rawName.slice(7); }
  else if (rawName.startsWith("DzRegister")) { prefix = "注册_"; body = rawName.slice(10); }
  else if (rawName.startsWith("RequestExtra")) { prefix = "请求额外_"; body = rawName.slice(12); }
  else if (rawName.startsWith("EXGetUnit")) { prefix = "单位扩展_取"; body = rawName.slice(9); }
  else if (rawName.startsWith("EXSetUnit")) { prefix = "单位扩展_设"; body = rawName.slice(9); }
  else if (rawName.startsWith("EXPauseUnit")) { prefix = "单位扩展_"; body = "PauseUnit"; }
  else if (rawName.startsWith("EXGetAbility")) { prefix = "技能扩展_取"; body = rawName.slice(12); }
  else if (rawName.startsWith("EXSetAbility")) { prefix = "技能扩展_设"; body = rawName.slice(12); }
  else if (rawName.startsWith("EXGetItem")) { prefix = "物品扩展_取"; body = rawName.slice(9); }
  else if (rawName.startsWith("EXSetItem")) { prefix = "物品扩展_设"; body = rawName.slice(9); }
  else if (rawName.startsWith("EXExecute")) { prefix = "脚本扩展_"; body = rawName.slice(2); }
  else if (rawName.startsWith("EX")) { prefix = "扩展_"; body = rawName.slice(2); }
  else if (rawName.startsWith("KK")) { prefix = "KK_"; body = rawName.slice(2); }

  let result = prefix + translateWords(splitCamel(body));
  result = result.replace(/__+/g, "_").replace(/^_+|_+$/g, "");
  result = result.replace(/^取_/, "取").replace(/^设_/, "设").replace(/^是否_/, "是否");
  return result;
}

function normalizeChineseFunctionName(name) {
  const replacements = [
    ["Random", "随机"],
    ["ORPG", "开放角色扮演"],
    ["QQ", "群聊"],
    ["蓝V", "蓝贵宾"],
    ["红V", "红贵宾"],
    ["第N个", "第序号个"],
    ["取第序号个单位", "取第序号单位"],
    ["RequiresAmounts", "需求数量"],
    ["RequiresTechcode", "需求科技代码"],
    ["Requires单位代码", "需求单位编号"],
    ["KK平台_", "平台扩展_"],
    ["KK_API", "平台扩展"],
    ["KK_", "平台扩展_"],
    ["WE", "编辑器"],
    ["QueryTask", "查询任务"],
    ["TaskIn", "任务中"],
    ["Initialize", "初始化"],
    ["Completed", "已完成"],
    ["Delete", "删除"],
    ["Updata", "更新"],
    ["ByCode", "按代码"],
    ["ByID", "按编号"],
    ["ById", "按编号"],
    ["Issue", "下达"],
    ["Button", "按钮"],
    ["Buff", "增益"],
    ["Lower", "下方"],
    ["Hero", "英雄"],
    ["Jass", "原生"],
    ["Patron", "顾客"],
    ["On建造", "建造选位"],
    ["On目标", "目标选择"],
    ["On", ""],
    ["Abil", "技能"],
    ["BuildsIds", "建造编号"],
    ["Makes物品Ids", "制造物品编号"],
    ["ResearchesIds", "研究编号"],
    ["Sells物品Ids", "出售物品编号"],
    ["Sells单位Ids", "出售单位编号"],
    ["TrainsIds", "训练编号"],
    ["UpgradesIds", "升级编号"],
    ["Build命令", "建造命令"],
    ["Build模型", "建造模型"],
    ["Cast点位", "施法前摇"],
    ["Cast时间", "施法时长"],
    ["SpellBook", "法术书"],
    ["Uber", "扩展"],
    ["Reach", "达成"],
    ["BackSwing", "后摇"],
    ["Life回复", "生命回复"],
    ["HitIgnore", "受击忽略"],
    ["ForceStop", "强停"],
    ["Move类型", "移动类型"],
    ["CanPlaceAroundLoc", "点周围可放置"],
    ["CanPlaceAround", "周围可放置"],
    ["Illusion", "幻象"],
    ["Find", "查找"],
    ["Contains", "包含"],
    ["Replace", "替换"],
    ["Insert", "插入"],
    ["Shadow", "阴影"],
    ["Start透明度", "初始透明度"],
    ["Tex坐标", "贴图坐标"],
    ["Proper名称", "专名"],
    ["Proper", "专名"],
    ["OpCode", "操作码"],
    ["Blp", "贴图"],
    ["Log", "日志"],
    ["Click", "点击"],
    ["Terrain", "地形"],
    ["Num", "数量"],
    ["Month", "月份"],
    ["Int", "整数"],
    ["GUID", "全局标识"],
    ["VIP", "贵宾"],
    ["RPG", "角色扮演"],
    ["FPS", "帧率"],
    ["ID", "编号"],
    ["X", "横坐标"],
    ["Y", "纵坐标"],
    ["Z", "高度"],
    ["数据A", "dataA"],
    ["数据B", "dataB"],
    ["数据C", "dataC"],
    ["数据D", "dataD"],
    ["数据E", "dataE"],
    ["AEme", "杂项"],
  ];
  let result = name;
  for (const [from, to] of replacements) {
    result = result.replaceAll(from, to);
  }
  result = result.replace(/__+/g, "_").replace(/^_+|_+$/g, "");
  return result;
}

function cleanOfficialTitle(title) {
  let result = (title || "").trim();
  if (!result) return "";
  result = result
    .replace(/【[^】]*】/g, "")
    .replace(/\[[^\]]*\]/g, "")
    .replace(/（区分大小写）/g, "")
    .replace(/【废弃】/g, "")
    .replace(/（1~199）/g, "区间1到199")
    .replace(/（200~499）/g, "区间200到499")
    .replace(/（500~999）/g, "区间500到999")
    .replace(/（1000\+）/g, "区间1000以上")
    .replace(/[（）()]/g, "")
    .replace(/\s*--\s*/g, "_")
    .replace(/\s*-\s*/g, "_")
    .replace(/\s+/g, "")
    .replace(/[：:]/g, "_")
    .replace(/[\/]/g, "_")
    .replace(/[、,，]/g, "_");
  result = result
    .replace(/获得/g, "获取")
    .replace(/讀取/g, "读取")
    .replace(/Id/g, "ID")
    .replace(/id/g, "ID")
    .replace(/Ui/g, "UI")
    .replace(/ui/g, "UI")
    .replace(/^4字节组合为整数$/, "四字节组合为整数");
  result = result.replace(/_+/g, "_").replace(/^_+|_+$/g, "");
  return result;
}

function titleToFunctionName(rawName, title) {
  const cleaned = cleanOfficialTitle(title);
  if (!cleaned) return "";

  const namedOverrides = {
    DzBitToInt: "四字节组合为整数",
    DzAPI_Map_Stat_SetStat: "地图_上报房间内显示的数据",
    DzAPI_Map_Ladder_SubmitBooleanData: "地图_天梯提交布尔值数据",
    DzAPI_Map_Ladder_SetStat: "地图_天梯提交字符串数据",
    DzAPI_Map_Ladder_SubmitIntegerData: "地图_天梯提交整数数据",
    DzAPI_Map_Stat_SubmitUnitIdData: "地图_天梯提交单位类型数据",
    DzAPI_Map_Ladder_SubmitAblityIdData: "地图_天梯提交技能数据",
    DzAPI_Map_Ladder_SubmitItemIdData: "地图_天梯提交物品数据",
    DzAPI_Map_Ladder_SubmitTitle: "地图_天梯提交获得称号",
    DzAPI_Map_Ladder_SubmitPlayerRank: "地图_天梯提交玩家排名",
    DzAPI_Map_Ladder_SubmitPlayerExtraExp: "地图_天梯设置玩家额外分",
    DzAPI_Map_SaveServerValue: "地图_保存服务器存档",
    DzAPI_Map_SavePublicArchive: "地图_保存服务器存档组",
    DzAPI_Map_Global_StoreString: "地图_保存全局存档",
    DzAPI_Map_Global_GetStoreString: "地图_读取全局存档",
    DzAPI_Map_OpenMall: "地图_打开地图商城道具购买界面",
    DzAPI_Map_QuickBuy: "地图_使用U币快速购买地图商城道具",
    DzAPI_Map_CancelQuickBuy: "地图_关闭U币快速购买界面",
    DzAPI_Map_MapsConsumeLv1: "地图_玩家在指定地图累计消费金额区间1到199",
    DzAPI_Map_MapsConsumeLv2: "地图_玩家在指定地图累计消费金额区间200到499",
    DzAPI_Map_MapsConsumeLv3: "地图_玩家在指定地图累计消费金额区间500到999",
    DzAPI_Map_MapsConsumeLv4: "地图_玩家在指定地图累计消费金额区间1000以上",
    KKApiRequestBackendLogic: "平台扩展_随机只读存档生成随机数",
    KKApiRemoveBackendLogicResult: "平台扩展_随机只读存档删除随机数",
    KKApiBeginBatchSaveArchive: "平台扩展_批量存档开始保存",
    KKApiAddBatchSaveArchive: "平台扩展_批量存档添加条目",
    KKApiEndBatchSaveArchive: "平台扩展_批量存档结束保存",
    KKApiMlScriptEvent: "平台扩展_发送云脚本数据",
  };
  if (namedOverrides[rawName]) return namedOverrides[rawName];

  let prefix = "";
  if (rawName.startsWith("DzAPI_Map_")) prefix = "地图_";
  else if (rawName.startsWith("KKApi")) prefix = "平台扩展_";
  else if (rawName.startsWith("KK")) prefix = "平台扩展_";
  else if (rawName.startsWith("DzFrame")) prefix = "界面_";
  else if (rawName.startsWith("DzSimpleMessageFrame")) prefix = "简单消息界面_";
  else if (rawName.startsWith("DzSimple")) prefix = "简单界面_";
  else if (rawName.startsWith("DzTextTag")) prefix = "漂浮字_";
  else if (rawName.startsWith("DzDoodad")) prefix = "装饰物_";
  else if (rawName.startsWith("DzItem")) prefix = "物品_";
  else if (rawName.startsWith("DzUnit")) prefix = "单位_";
  else if (rawName.startsWith("EXGetUnit")) prefix = "单位扩展_";
  else if (rawName.startsWith("EXSetUnit")) prefix = "单位扩展_";
  else if (rawName.startsWith("EXGetAbility")) prefix = "技能扩展_";
  else if (rawName.startsWith("EXSetAbility")) prefix = "技能扩展_";
  else if (rawName.startsWith("EXGetItem")) prefix = "物品扩展_";
  else if (rawName.startsWith("EXSetItem")) prefix = "物品扩展_";
  else if (rawName.startsWith("EX")) prefix = "扩展_";

  let result = cleaned;
  if (/^(获取|读取|判断|检查|查询|转换|打开|关闭|设置|保存|清理|解除|绑定|注册|播放|发送|使用|触发|创建|销毁|修改|更新|切换|启用|禁用|加载)/.test(result)) {
    const verbMap = [
      [/^获取/, "取"],
      [/^获得/, "取"],
      [/^读取/, "取"],
      [/^判断/, "是否"],
      [/^检查/, "检查"],
      [/^查询/, "查询"],
      [/^转换/, "转换"],
      [/^打开/, "打开_"],
      [/^关闭/, "关闭_"],
      [/^设置/, "设"],
      [/^保存/, "保存"],
      [/^清理/, "清理"],
      [/^解除/, "解除"],
      [/^绑定/, "绑定"],
      [/^注册/, "注册_"],
      [/^播放/, "播放"],
      [/^发送/, "发送"],
      [/^使用/, "使用"],
      [/^触发/, "触发"],
      [/^创建/, "创建"],
      [/^销毁/, "销毁"],
      [/^修改/, "修改"],
      [/^更新/, "更新"],
      [/^切换/, "切换"],
      [/^启用/, "启用_"],
      [/^禁用/, "禁用_"],
      [/^加载/, "加载"],
    ];
    for (const [pattern, replacement] of verbMap) {
      if (pattern.test(result)) {
        result = result.replace(pattern, replacement);
        break;
      }
    }
  }

  if (prefix && !result.startsWith(prefix)) result = `${prefix}${result}`;
  result = result.replace(/__+/g, "_").replace(/^_+|_+$/g, "");
  return normalizeChineseFunctionName(result);
}

function preferGeneratedName(rawName, currentName) {
  const fallbackName = normalizeChineseFunctionName(buildChineseName(rawName));
  if (!currentName) return fallbackName;

  const badMarkers = [
    "-",
    "UI模型",
    "界面_UI",
    "界面-",
    "游戏-",
    "技能-",
    "单位-",
    "物品-",
    "玩家-",
    "装饰物-",
    "坐标-",
    "建造-",
    "转化-",
    "特效-",
    "哈希表-",
    "硬件-",
  ];

  if (badMarkers.some(marker => currentName.includes(marker))) {
    return fallbackName;
  }
  return currentName;
}

function finalizeFunctionName(rawName, currentName) {
  const finalOverrides = {
    DzBitToInt: "四字节组合为整数",
    DzAPI_Map_MapsConsumeLv1: "地图_玩家在指定地图累计消费金额区间1到199",
    DzAPI_Map_MapsConsumeLv2: "地图_玩家在指定地图累计消费金额区间200到499",
    DzAPI_Map_MapsConsumeLv3: "地图_玩家在指定地图累计消费金额区间500到999",
    DzAPI_Map_MapsConsumeLv4: "地图_玩家在指定地图累计消费金额区间1000以上",
  };
  let result = finalOverrides[rawName] || currentName;
  result = result
    .replace(/~/g, "到")
    .replace(/\+/g, "以上")
    .replace(/（/g, "")
    .replace(/）/g, "")
    .replace(/\(/g, "")
    .replace(/\)/g, "");
  if (/^[0-9]/.test(result)) {
    result = result
      .replace(/^0/, "零")
      .replace(/^1/, "一")
      .replace(/^2/, "二")
      .replace(/^3/, "三")
      .replace(/^4/, "四")
      .replace(/^5/, "五")
      .replace(/^6/, "六")
      .replace(/^7/, "七")
      .replace(/^8/, "八")
      .replace(/^9/, "九");
  }
  return result;
}

function translateParamName(rawName, rawType, index) {
  if (!rawName || rawName === "") {
    rawName = `arg${index + 1}`;
  }
  if (paramNameOverrides[rawName]) return paramNameOverrides[rawName];

  const trimmed = rawName.replace(/^_+/, "");
  if (paramNameOverrides[trimmed]) return paramNameOverrides[trimmed];

  const withoutWhich = trimmed.replace(/^which/, "");
  if (withoutWhich !== trimmed) {
    const words = splitCamel(withoutWhich);
    const translated = translateWords(words);
    if (translated) return translated;
  }

  const translated = translateWords(trimmed.split("_").flatMap(splitCamel));
  if (translated) {
    const 残留英文片段 = translated.match(/[A-Za-z]+/g) || [];
    const 允许残留 = new Set(["x", "y", "z", "ID", "A", "B", "C", "D", "E", "FPS", "GUID", "VIP", "RPG", "UI", "Buff"]);
    if (残留英文片段.every(part => 允许残留.has(part))) return translated;
  }

  const fallbackByType = {
    player: "玩家",
    unit: "单位",
    item: "物品",
    widget: "控件",
    effect: "特效",
    trigger: "触发器",
    location: "点",
    group: "单位组",
    ability: "技能",
    integer: `整数${index + 1}`,
    real: `实数${index + 1}`,
    string: `字符串${index + 1}`,
    boolean: `布尔${index + 1}`,
  };
  return fallbackByType[rawType] || `参数${index + 1}`;
}

function makeUniqueParams(params) {
  const used = new Map();
  return params.map(param => {
    let name = param.tsName;
    const count = used.get(name) || 0;
    used.set(name, count + 1);
    if (count > 0) name = `${name}${count + 1}`;
    return { ...param, tsName: name };
  });
}

function parseJassParams(text) {
  const trimmed = text.trim();
  if (trimmed === "nothing") return [];
  return trimmed.split(",").map((part, index) => {
    const item = part.trim().replace(/\s+/g, " ");
    const bits = item.split(" ");
    const rawType = bits[0];
    const rawName = bits.slice(1).join(" ");
    const tsType = typeAliasMap[rawType] || "any";
    return { rawType, rawName, tsType, tsName: translateParamName(rawName, rawType, index) };
  });
}

function parseJassFunctions(filePath) {
  const text = read(filePath);
  const results = [];
  const regex = /^\s*(native|function)\s+([A-Za-z0-9_]+)\s+takes\s+(.+?)\s+returns\s+([A-Za-z0-9_]+)\s*$/gm;
  let match;
  while ((match = regex.exec(text)) !== null) {
    const rawName = match[2];
    if (!prefixAllow.test(rawName)) continue;
    const params = makeUniqueParams(parseJassParams(match[3]));
    const returnType = typeAliasMap[match[4]] || "any";
    results.push({
      rawName,
      params,
      returnType,
      source: path.basename(filePath),
      originalSignature: `${match[1]} ${rawName} takes ${match[3]} returns ${match[4]}`,
      precedence: 1,
    });
  }
  return results;
}

function scanBalancedParen(text, openIdx) {
  let depth = 0;
  for (let i = openIdx; i < text.length; i++) {
    const ch = text[i];
    if (ch === "(") depth++;
    else if (ch === ")") {
      depth--;
      if (depth === 0) return i;
    }
  }
  return -1;
}

function parseTsTypeParamList(paramText) {
  const parts = [];
  let buf = "";
  let depthParen = 0;
  let depthAngle = 0;
  let depthBracket = 0;
  for (let i = 0; i < paramText.length; i++) {
    const ch = paramText[i];
    if (ch === "," && depthParen === 0 && depthAngle === 0 && depthBracket === 0) {
      parts.push(buf.trim());
      buf = "";
      continue;
    }
    if (ch === "(") depthParen++;
    else if (ch === ")") depthParen--;
    else if (ch === "<") depthAngle++;
    else if (ch === ">") depthAngle--;
    else if (ch === "[") depthBracket++;
    else if (ch === "]") depthBracket--;
    buf += ch;
  }
  if (buf.trim()) parts.push(buf.trim());
  return parts.filter(Boolean).map((part, index) => {
    const normalized = part.replace(/^\.\.\./, "");
    const colonIdx = normalized.indexOf(":");
    if (colonIdx < 0) return { tsName: `参数${index + 1}`, tsType: "any", rawName: `参数${index + 1}` };
    const rawName = normalized.slice(0, colonIdx).trim().replace(/\?$/, "");
    const tsType = stripTopLevelDefaultValue(normalized.slice(colonIdx + 1).trim());
    return { rawName, tsName: translateParamName(rawName, "", index), tsType };
  });
}

function stripTopLevelDefaultValue(text) {
  let depthParen = 0;
  let depthAngle = 0;
  let depthBracket = 0;
  for (let i = 0; i < text.length; i++) {
    const ch = text[i];
    if (ch === "(") depthParen++;
    else if (ch === ")") depthParen--;
    else if (ch === "<") depthAngle++;
    else if (ch === ">") depthAngle--;
    else if (ch === "[") depthBracket++;
    else if (ch === "]") depthBracket--;
    else if (ch === "=" && depthParen === 0 && depthAngle === 0 && depthBracket === 0) {
      const prev = text[i - 1];
      const next = text[i + 1];
      if (prev !== "=" && next !== ">") return text.slice(0, i).trim();
    }
  }
  return text;
}

function parseTsCasts(filePath) {
  const text = read(filePath);
  const results = [];
  let idx = 0;
  while (idx < text.length) {
    const pos = text.indexOf("japi.", idx);
    if (pos < 0) break;
    const m = /^japi\.([A-Za-z0-9_]+)\s+as\s+\(/.exec(text.slice(pos));
    if (!m) {
      idx = pos + 5;
      continue;
    }
    const rawName = m[1];
    const openIdx = pos + m[0].length - 1;
    const closeIdx = scanBalancedParen(text, openIdx);
    if (closeIdx < 0) break;
    const paramsText = text.slice(openIdx + 1, closeIdx);
    const tail = text.slice(closeIdx + 1);
    const tailMatch = /^\s*=>\s*([^;\n]+);/.exec(tail);
    if (!tailMatch) {
      idx = closeIdx + 1;
      continue;
    }
    const params = makeUniqueParams(parseTsTypeParamList(paramsText));
    const returnType = tailMatch[1].trim();
    results.push({
      rawName,
      params,
      returnType,
      source: path.relative(root, filePath).replace(/\\/g, "/"),
      originalSignature: `${rawName} as (${paramsText}) => ${returnType}`,
      precedence: 3,
    });
    idx = closeIdx + 1;
  }
  return results;
}

function parseExportedFunctions(filePath) {
  const text = read(filePath);
  const results = [];
  const regex = /export function\s+([A-Za-z0-9_]+)\s*\(/g;
  let match;
  while ((match = regex.exec(text)) !== null) {
    const rawName = match[1];
    if (!prefixAllow.test(rawName)) continue;
    const openIdx = regex.lastIndex - 1;
    const closeIdx = scanBalancedParen(text, openIdx);
    if (closeIdx < 0) continue;
    const paramsText = text.slice(openIdx + 1, closeIdx);
    const rest = text.slice(closeIdx + 1);
    const retMatch = /^\s*:\s*([^\{\n]+)\s*\{/.exec(rest);
    if (!retMatch) continue;
    const params = makeUniqueParams(parseTsTypeParamList(paramsText));
    const returnType = retMatch[1].trim();
    results.push({
      rawName,
      params,
      returnType,
      source: path.relative(root, filePath).replace(/\\/g, "/"),
      originalSignature: `export function ${rawName}(${paramsText}): ${returnType}`,
      precedence: 2,
    });
  }
  return results;
}

const collected = [];
for (const file of jassFiles) collected.push(...parseJassFunctions(file));

const tsFiles = walk(path.join(root, "TS"));
for (const file of tsFiles) {
  if (!file.endsWith(".ts") || file === tsFile) continue;
  collected.push(...parseTsCasts(file));
}
for (const file of tsFiles) {
  if (!file.endsWith(".ts") || !file.includes(`${path.sep}YDWE函数${path.sep}`)) continue;
  collected.push(...parseExportedFunctions(file));
}

const chosen = new Map();
for (const item of collected) {
  const prev = chosen.get(item.rawName);
  if (!prev || item.precedence > prev.precedence) {
    chosen.set(item.rawName, item);
  }
}

const 官方中文标题映射 = loadOfficialChineseTitles();
const 原名分类映射 = loadCategoryByRawName();
const items = [...chosen.values()].sort((a, b) => a.rawName.localeCompare(b.rawName));
const usedNames = new Map();
for (const item of items) {
  const 官方标题 = 官方中文标题映射.get(item.rawName);
  let name = 官方标题
    ? titleToFunctionName(item.rawName, 官方标题)
    : normalizeChineseFunctionName(buildChineseName(item.rawName));
  name = preferGeneratedName(item.rawName, name);
  name = finalizeFunctionName(item.rawName, name);
  if (!name) {
    name = normalizeChineseFunctionName(buildChineseName(item.rawName));
  }
  const count = usedNames.get(name) || 0;
  usedNames.set(name, count + 1);
  if (count > 0) name = `${name}_${count + 1}`;
  item.chineseName = name;
  item.分类 = deduceCategory(item.rawName, name, 原名分类映射.get(item.rawName) || "条件", item.returnType);
}

function buildModuleLines(moduleName, moduleItems) {
  const lines = [];
  lines.push("/** @noSelfInFile */");
  lines.push("");
  lines.push("/**");
  lines.push(` * 平台扩展 API 中文包装 - ${moduleName}。`);
  lines.push(" */");
  lines.push("");
  lines.push("type 玩家句柄 = any;");
  lines.push("type 单位句柄 = any;");
  lines.push("type 物品句柄 = any;");
  lines.push("type 控件句柄 = any;");
  lines.push("type 特效句柄 = any;");
  lines.push("type 触发器句柄 = any;");
  lines.push("type 点句柄 = any;");
  lines.push("type 单位组句柄 = any;");
  lines.push("type 技能句柄 = any;");
  lines.push("type 代理句柄 = any;");
  lines.push("type 漂浮字句柄 = any;");
  lines.push("type 玩家组句柄 = any;");
  lines.push("type 布尔表达式句柄 = any;");
  lines.push("type 按钮句柄 = any;");
  lines.push("type 对话框句柄 = any;");
  lines.push("type 计时器对话框句柄 = any;");
  lines.push("type 追踪物句柄 = any;");
  lines.push("type 排行榜句柄 = any;");
  lines.push("type 多面板句柄 = any;");
  lines.push("type 多面板项句柄 = any;");
  lines.push("type 区域句柄 = any;");
  lines.push("type 矩形句柄 = any;");
  lines.push("type 闪电句柄 = any;");
  lines.push("type 音效句柄 = any;");
  lines.push("type 可破坏物句柄 = any;");
  lines.push("");
  lines.push("type 原生表 = Record<string, any>;");
  lines.push("const 平台原生表 = require(\"jass.japi\") as 原生表;");
  lines.push("const 原生函数表 = 平台原生表 as Record<string, (...参数: any[]) => any>;");
  lines.push("");
  for (const item of moduleItems) {
    const paramsDecl = item.params.map(p => `${p.tsName}: ${p.tsType}`).join(", ");
    const callArgs = item.params.map(p => p.tsName).join(", ");
    lines.push(`export function ${item.chineseName}(this: void${paramsDecl ? ", " + paramsDecl : ""}): ${item.returnType} {`);
    lines.push(`  return (原生函数表[\"${item.rawName}\"] as (${paramsDecl}) => ${item.returnType})(${callArgs});`);
    lines.push("}");
    lines.push("");
  }
  return lines.join("\n");
}

const 动作项 = items.filter(item => item.分类 === "动作");
const 取值项 = items.filter(item => item.分类 === "取值");
const 条件项 = items.filter(item => item.分类 === "条件");
const 事件项 = items.filter(item => item.分类 === "事件");

fs.writeFileSync(tsActionFile, buildModuleLines("动作", 动作项), "utf8");
fs.writeFileSync(tsValueFile, buildModuleLines("取值", 取值项), "utf8");
fs.writeFileSync(tsConditionFile, buildModuleLines("条件", 条件项), "utf8");
fs.writeFileSync(tsEventFile, buildModuleLines("事件", 事件项), "utf8");

const indexLines = [];
indexLines.push("/** @noSelfInFile */");
indexLines.push("");
indexLines.push("export * from \"./平台扩展API.动作\";");
indexLines.push("export * from \"./平台扩展API.取值\";");
indexLines.push("export * from \"./平台扩展API.条件\";");
indexLines.push("export * from \"./平台扩展API.事件\";");
indexLines.push("");
fs.writeFileSync(tsFile, indexLines.join("\n"), "utf8");

console.log(JSON.stringify({
  count: items.length,
  files: {
    index: tsFile,
    action: tsActionFile,
    value: tsValueFile,
    condition: tsConditionFile,
    event: tsEventFile,
  },
  groups: {
    动作: 动作项.length,
    取值: 取值项.length,
    条件: 条件项.length,
    事件: 事件项.length,
  },
}, null, 2));
