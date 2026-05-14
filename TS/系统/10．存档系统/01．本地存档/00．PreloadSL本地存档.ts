/** @noSelfInFile */
/**
 * Preload 本地存档封装
 *
 * `JASS/世界地图/存档.j` 里的 `YDWE_PreloadSL_*` 是编辑器生成的 JASS 函数，
 * Lua 侧不会自动拥有同名 API。这里直接用原生 Preload 文件生成能力写入本机文件，
 * 再用 `SetPlayerTechMaxAllowed(Player(14/15), key, value)` 在 `Preloader` 执行时回填槽位。
 *
 * 当前封装支持两层能力：
 * - 文本载荷：给正式配置文件使用，例如 `chouhen=true;shoucejian=K`
 * - 整数槽位：保留给测试和低层兼容使用
 */

const jass = require("jass.common") as any;

declare const YDWE_PreloadSL_Set: ((p: any, s: string, n: number, value: number) => void) | undefined;
declare const YDWE_PreloadSL_Get: ((p: any, s: string, n: number) => number) | undefined;
declare const YDWE_PreloadSL_Save: ((p: any, dir: string, file: string, n: number) => void) | undefined;
declare const YDWE_PreloadSL_Load: ((p: any, dir: string, file: string, n: number) => boolean) | undefined;

const GetLocalPlayer = jass.GetLocalPlayer as (() => any) | undefined;
const PreloadGenClear = jass.PreloadGenClear as (() => void) | undefined;
const PreloadGenStart = jass.PreloadGenStart as (() => void) | undefined;
const Preload = jass.Preload as ((filename: string) => void) | undefined;
const PreloadGenEnd = jass.PreloadGenEnd as ((filename: string) => void) | undefined;
const Preloader = jass.Preloader as ((filename: string) => void) | undefined;
const Player = jass.Player as (playerId: number) => any;
const SetPlayerTechMaxAllowed = jass.SetPlayerTechMaxAllowed as (whichPlayer: any, techid: number, maximum: number) => void;
const GetPlayerTechMaxAllowed = jass.GetPlayerTechMaxAllowed as (whichPlayer: any, techid: number) => number;

const 存档扩展名 = ".sav";
const 空载荷 = "";
const 字段分隔符 = "|";
const 文本字段名 = "config";
const 文本长度槽 = 1;
const 文本内容起始槽 = 2;
const 文本槽位数量 = 192;
const 负数标记偏移 = 0x200;
const 字段值表: Record<number, number | undefined> = {};
let 文本载荷 = 空载荷;
let 最近读取路径 = 空载荷;
let 最近接口来源 = 空载荷;
let 最近加载成功 = false;
let 最近文本长度 = 0;
const 字符工具 = string as any;
const 字符编码转文本 = 字符工具.char as (this: void, code: number) => string;

function 函数存在(this: void, fn: any): boolean {
  return typeof fn === "function";
}

function YDWE存档接口是否存在(this: void): boolean {
  return 函数存在(YDWE_PreloadSL_Set)
    && 函数存在(YDWE_PreloadSL_Get)
    && 函数存在(YDWE_PreloadSL_Save)
    && 函数存在(YDWE_PreloadSL_Load);
}

function 是否本地玩家(this: void, player: any): boolean {
  return 函数存在(GetLocalPlayer) && GetLocalPlayer!() === player;
}

function 构建存档路径(this: void, dir: string, file: string): string {
  const dirPart = dir == null || dir === "" ? "default" : dir;
  return dirPart + "\\pre" + file + 存档扩展名;
}

function 构建目录列表路径(this: void, dir: string): string {
  const dirPart = dir == null || dir === "" ? "default" : dir;
  return dirPart + "\\list.sav";
}

export function PreloadSL获取存档路径(this: void, dir: string, file: string): string {
  return 构建存档路径(dir, file);
}

export function PreloadSL获取最近读取路径(this: void): string {
  return 最近读取路径;
}

export function PreloadSL获取最近接口来源(this: void): string {
  return 最近接口来源;
}

export function PreloadSL最近加载是否成功(this: void): boolean {
  return 最近加载成功;
}

export function PreloadSL获取最近文本长度(this: void): number {
  return 最近文本长度;
}

function 构建整数载荷(this: void, fieldCount: number): string {
  let payload = "";
  for (let index = 1; index <= fieldCount; index++) {
    if (index > 1) payload = payload + 字段分隔符;
    const value = 字段值表[index];
    payload = payload + tostring(value == null ? 0 : value);
  }
  return payload;
}

function 清理载荷文本(this: void, payload: string): string {
  // 载荷会被写进 JASS 字符串，禁止引号和换行进入文件结构。
  return payload.split("\"").join("").split("\n").join("").split("\r").join("");
}

function 解析整数载荷(this: void, payload: string, fieldCount: number): void {
  const parts = payload.split(字段分隔符);
  for (let index = 1; index <= fieldCount; index++) {
    const raw = parts[index - 1];
    const value = raw == null || raw === "" ? 0 : parseInt(raw, 10);
    字段值表[index] = isNaN(value) ? 0 : value;
  }
}

function 限制文本长度(this: void, payload: string): string {
  const safePayload = 清理载荷文本(payload);
  const maxLength = 文本槽位数量 - 文本内容起始槽 + 1;
  if (safePayload.length <= maxLength) return safePayload;
  return safePayload.substring(0, maxLength);
}

function 写入YDWE文本槽位(this: void, player: any, payload: string): string {
  const safePayload = 限制文本长度(payload);
  YDWE_PreloadSL_Set!(player, 文本字段名, 文本长度槽, safePayload.length);
  for (let i = 0; i < safePayload.length; i++) {
    YDWE_PreloadSL_Set!(player, 文本字段名, 文本内容起始槽 + i, safePayload.charCodeAt(i));
  }
  最近文本长度 = YDWE_PreloadSL_Get!(player, 文本字段名, 文本长度槽);
  return safePayload;
}

function 读取YDWE文本槽位(this: void, player: any): string {
  const length = YDWE_PreloadSL_Get!(player, 文本字段名, 文本长度槽);
  最近文本长度 = length == null ? 0 : length;
  if (length == null || length <= 0) return 空载荷;

  const maxLength = 文本槽位数量 - 文本内容起始槽 + 1;
  const safeLength = length > maxLength ? maxLength : length;
  let payload = "";
  for (let i = 0; i < safeLength; i++) {
    const code = YDWE_PreloadSL_Get!(player, 文本字段名, 文本内容起始槽 + i);
    if (code == null || code <= 0) break;
    payload = payload + 字符编码转文本(code);
  }
  return payload;
}

function 构建保存整数文本(this: void, key: number, value: number): string {
  const absValue = value < 0 ? -value : value;
  const typeValue = value < 0 ? 2 : 1;
  return "\")\ncall SetPlayerTechMaxAllowed(Player(14)," + tostring(key) + "," + tostring(typeValue) + ")\ncall SetPlayerTechMaxAllowed(Player(15)," + tostring(key) + "," + tostring(absValue) + ")\n//";
}

function 写入原生Preload整数(this: void, key: number, value: number): void {
  Preload!(构建保存整数文本(key, value));
}

function 读取原生Preload整数(this: void, key: number): number {
  const typeValue = GetPlayerTechMaxAllowed(Player(14), key);
  const absValue = GetPlayerTechMaxAllowed(Player(15), key);
  if (typeValue === 1) return absValue;
  if (typeValue === 2) return -absValue;
  return 0;
}

function 保存原生Preload文本(this: void, path: string, payload: string): string {
  const safePayload = 限制文本长度(payload);
  PreloadGenClear!();
  PreloadGenStart!();
  写入原生Preload整数(文本长度槽, safePayload.length);
  for (let i = 0; i < safePayload.length; i++) {
    写入原生Preload整数(文本内容起始槽 + i, safePayload.charCodeAt(i));
  }
  PreloadGenEnd!(path);
  最近文本长度 = safePayload.length;
  return safePayload;
}

function 初始化原生Preload目录(this: void, dir: string): void {
  PreloadGenClear!();
  PreloadGenStart!();
  Preload!("");
  PreloadGenEnd!(构建目录列表路径(dir));
}

function 加载原生Preload文本(this: void, path: string): string {
  Preloader!(path);
  const length = 读取原生Preload整数(文本长度槽);
  最近文本长度 = length == null ? 0 : length;
  if (length == null || length <= 0) return 空载荷;

  const maxLength = 文本槽位数量 - 文本内容起始槽 + 1;
  const safeLength = length > maxLength ? maxLength : length;
  let payload = "";
  for (let i = 0; i < safeLength; i++) {
    const code = 读取原生Preload整数(文本内容起始槽 + i);
    if (code == null || code <= 0) break;
    payload = payload + 字符编码转文本(code);
  }
  最近读取路径 = path;
  return payload;
}

export function PreloadSL接口是否存在(this: void): boolean {
  if (YDWE存档接口是否存在()) return true;
  return 函数存在(GetLocalPlayer)
    && 函数存在(PreloadGenClear)
    && 函数存在(PreloadGenStart)
    && 函数存在(Preload)
    && 函数存在(PreloadGenEnd)
    && 函数存在(Preloader)
    && 函数存在(Player)
    && 函数存在(SetPlayerTechMaxAllowed)
    && 函数存在(GetPlayerTechMaxAllowed);
}

export function PreloadSL接口来源描述(this: void): string {
  if (YDWE存档接口是否存在()) return "YDWE_PreloadSL";
  if (PreloadSL接口是否存在()) return "native-preload-tech";
  return "missing-native-preload-tech";
}

export function PreloadSL设置整数(this: void, player: any, index: number, value: number): boolean {
  if (YDWE存档接口是否存在()) {
    YDWE_PreloadSL_Set!(player, tostring(index), index, value);
  }
  字段值表[index] = value;
  return true;
}

export function PreloadSL读取整数(this: void, player: any, index: number): number {
  if (YDWE存档接口是否存在()) {
    return YDWE_PreloadSL_Get!(player, tostring(index), index);
  }
  const value = 字段值表[index];
  return value == null ? 0 : value;
}

export function PreloadSL设置文本载荷(this: void, payload: string): boolean {
  文本载荷 = 清理载荷文本(payload);
  return true;
}

export function PreloadSL读取文本载荷(this: void): string {
  return 文本载荷;
}

export function PreloadSL保存文本(this: void, player: any, dir: string, file: string, payload: string): boolean {
  if (!PreloadSL接口是否存在()) return false;

  if (YDWE存档接口是否存在()) {
    最近接口来源 = "YDWE_PreloadSL";
    最近加载成功 = false;
    最近读取路径 = dir == null || dir === "" ? file : dir + "\\" + file;
    文本载荷 = 写入YDWE文本槽位(player, payload);
    YDWE_PreloadSL_Save!(player, dir, file, 文本槽位数量);
    return true;
  }

  最近接口来源 = "native-preload-tech";
  if (!是否本地玩家(player)) return true;

  const path = 构建存档路径(dir, file);
  最近读取路径 = path;
  初始化原生Preload目录(dir);
  文本载荷 = 保存原生Preload文本(path, payload);
  return true;
}

export function PreloadSL加载文本(this: void, player: any, dir: string, file: string): string {
  if (!PreloadSL接口是否存在()) return 空载荷;

  if (YDWE存档接口是否存在()) {
    最近接口来源 = "YDWE_PreloadSL";
    const ok = YDWE_PreloadSL_Load!(player, dir, file, 文本槽位数量);
    最近加载成功 = ok === true;
    最近读取路径 = dir == null || dir === "" ? file : dir + "\\" + file;
    if (!ok) return 空载荷;
    文本载荷 = 读取YDWE文本槽位(player);
    return 文本载荷 == null ? 空载荷 : 文本载荷;
  }

  最近接口来源 = "native-preload-tech";
  最近加载成功 = false;
  if (!是否本地玩家(player)) return 文本载荷;

  const path = 构建存档路径(dir, file);
  最近读取路径 = path;
  文本载荷 = 加载原生Preload文本(path);
  最近加载成功 = 文本载荷 !== 空载荷;
  return 文本载荷 == null ? 空载荷 : 文本载荷;
}

export function PreloadSL保存(this: void, player: any, dir: string, file: string, fieldCount: number): boolean {
  if (!PreloadSL接口是否存在()) return false;

  if (YDWE存档接口是否存在()) {
    YDWE_PreloadSL_Save!(player, dir, file, fieldCount);
    return true;
  }

  if (!是否本地玩家(player)) return true;

  const path = 构建存档路径(dir, file);
  const payload = 构建整数载荷(fieldCount);
  return PreloadSL保存文本(player, dir, file, payload);
}

export function PreloadSL加载(this: void, player: any, dir: string, file: string, fieldCount: number): boolean {
  if (!PreloadSL接口是否存在()) return false;

  if (YDWE存档接口是否存在()) {
    return YDWE_PreloadSL_Load!(player, dir, file, fieldCount);
  }

  if (!是否本地玩家(player)) return true;

  const payload = PreloadSL加载文本(player, dir, file);
  if (payload == null || payload === 空载荷) return false;

  解析整数载荷(payload, fieldCount);
  return true;
}
