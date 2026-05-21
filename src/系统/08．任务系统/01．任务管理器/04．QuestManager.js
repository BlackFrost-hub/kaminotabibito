/** @noSelfInFile */
/**
 * 任务管理器（单例）
 *
 * 职责概览：
 * - 与 `questDB` 打交道：接取、完成、失败、放弃、目标进度、查询
 * - 协调 `02．任务提示与奖励`：何时浮字、何时发奖
 * - 维护 `uiRefreshCallbacks`：任务状态变化时通知自定义 UI（如任务面板）
 * - 可选限时：`timeLimit` > 0 时挂一次性计时器，到期调用 `onQuestFailed`
 *
 * 不负责：从 JASS 全局读 udg_*（见 `05．事件桥接`）；F9 原生任务同步（见 `03．原生任务同步`，需自行接入）。
 */
const jass = require("jass.common");
const { safeTimerStart, safeDestroyTimer } = require("系统.00．核心系统.07．联机安全工具");
import { questDB } from "../01．任务数据";
import { questDebugPrint } from "./01．调试";
import { giveQuestRewards, showAbandonedQuestNotice, showQuestAcceptedMessage, showQuestCompletedMessage, showQuestFailedMessage, } from "./02．任务提示与奖励";
/**
 * 单例类。计时器到期回调里必须用 `QuestManager.getInstance()`，
 * 避免在模块顶层 `questManager` 尚未完成初始化时闭包引用未定义。
 */
export class QuestManager {
    static instance;
    isInitialized = false;
    /** 任务数据变更时依次调用；异常单独捕获，避免一条回调拖死全局 */
    uiRefreshCallbacks = [];
    constructor() { }
    static getInstance() {
        if (!QuestManager.instance) {
            QuestManager.instance = new QuestManager();
        }
        return QuestManager.instance;
    }
    // ─── 初始化 ───
    /**
     * 地图级一次性初始化：玩家槽位、原生任务同步占位等。
     * 重复调用会直接 return。
     */
    initialize() {
        if (this.isInitialized)
            return;
        questDebugPrint("初始化任务系统...");
        for (let i = 0; i < 12; i++) {
            questDB.initPlayerData(i);
        }
        this.setupWar3QuestSync();
        this.isInitialized = true;
    }
    /** 占位：若以后要在开局注册 JASS 级任务同步，可写在这里 */
    setupWar3QuestSync() {
        questDebugPrint("War3原生任务同步已就绪");
    }
    // ─── 限时（计时器） ───
    /**
     * 从全局任务配置读 `timeLimit`（秒），到期后对对应玩家执行失败流程。
     * 计时器与 (playerId, questId) 的映射存在 `globalThis.__questTimers`（Map），避免闭包野指针。
     */
    setupTimeLimit(playerId, questId) {
        const quest = questDB.globalData?.quests.get(questId);
        if (!quest || !quest.timeLimit || quest.timeLimit <= 0)
            return;
        const timer = jass.CreateTimer();
        if (!timer)
            return;
        const timerData = globalThis.__questTimers ||
            (globalThis.__questTimers = new Map());
        timerData.set(timer, { playerId, questId });
        safeTimerStart(timer, quest.timeLimit, false, onQuestTimeLimitTimerExpire);
        questDebugPrint(`已为任务 ${questId} 设置 ${quest.timeLimit} 秒时间限制`);
    }
    // ─── 任务状态：失败 / 放弃 / 追踪 ───
    /**
     * 标记失败并刷新 UI + 浮字。可由计时器或 JASS 桥接 `handleQuestFailed` 调用。
     */
    onQuestFailed(playerId, questId) {
        questDebugPrint(`玩家 ${playerId} 任务 ${questId} 失败`);
        const success = questDB.failQuest(playerId, questId);
        if (success) {
            this.triggerUIRefresh(playerId, questId);
            showQuestFailedMessage(playerId, questId);
        }
        else {
            questDebugPrint(`玩家 ${playerId} 任务 ${questId} 失败处理失败`);
        }
        return success;
    }
    /**
     * 先缓存 `nativeHandle`（abandon 后配置里可能删行），再 `abandonQuest`；成功则 DestroyQuest + UI + 浮字。
     */
    onQuestAbandoned(playerId, questId) {
        questDebugPrint(`玩家 ${playerId} 放弃任务 ${questId}`);
        const nativeHandle = questDB.globalData?.quests.get(questId)?.nativeHandle;
        const success = questDB.abandonQuest(playerId, questId);
        if (success) {
            if (nativeHandle) {
                jass.DestroyQuest(nativeHandle);
            }
            this.triggerUIRefresh(playerId, questId);
            showAbandonedQuestNotice(playerId, questId);
        }
        else {
            questDebugPrint(`玩家 ${playerId} 放弃任务 ${questId} 失败`);
        }
        return success;
    }
    // ─── UI 回调 ───
    /** 任务 UI 在 init 时注册，任意任务变更会带上 playerId 与可选 questId */
    registerUIRefreshCallback(callback) {
        this.uiRefreshCallbacks.push(callback);
    }
    triggerUIRefresh(playerId, questId) {
        for (const callback of this.uiRefreshCallbacks) {
            try {
                callback(playerId, questId);
            }
            catch (error) {
                questDebugPrint(`UI刷新回调错误: ${error}`);
            }
        }
    }
    // ─── 任务状态：接受 / 完成 / 目标 ───
    /**
     * 接取成功则：限时（若有）→ 刷新 UI → 接取浮字。
     */
    onQuestAccepted(playerId, questId) {
        questDebugPrint(`玩家 ${playerId} 接受任务 ${questId}`);
        const success = questDB.acceptQuest(playerId, questId);
        if (success) {
            this.setupTimeLimit(playerId, questId);
            this.triggerUIRefresh(playerId, questId);
            showQuestAcceptedMessage(playerId, questId);
        }
        else {
            questDebugPrint(`玩家 ${playerId} 接受任务 ${questId} 失败`);
        }
        return success;
    }
    /**
     * 顺序：发奖 → 刷新 UI → 完成浮字（奖励逻辑在 `giveQuestRewards`）。
     */
    onQuestCompleted(playerId, questId) {
        questDebugPrint(`玩家 ${playerId} 完成任务 ${questId}`);
        const success = questDB.completeQuest(playerId, questId);
        if (success) {
            giveQuestRewards(playerId, questId);
            this.triggerUIRefresh(playerId, questId);
            showQuestCompletedMessage(playerId, questId);
        }
        else {
            questDebugPrint(`玩家 ${playerId} 完成任务 ${questId} 失败`);
        }
        return success;
    }
    /**
     * 更新单条目标进度；若该任务下所有 objective 均 `completed`，会**递归**调用 `onQuestCompleted`。
     */
    updateQuestObjective(playerId, questId, objectiveId, progress) {
        const success = questDB.updateObjective(playerId, questId, objectiveId, progress);
        if (success) {
            this.triggerUIRefresh(playerId, questId);
            const quest = questDB.globalData?.quests.get(questId);
            if (quest && quest.objectives) {
                let allCompleted = true;
                for (const obj of quest.objectives) {
                    if (!obj || !obj.completed) {
                        allCompleted = false;
                        break;
                    }
                }
                if (allCompleted) {
                    this.onQuestCompleted(playerId, questId);
                }
            }
        }
        return success;
    }
    // ─── 查询 ───
    /** 玩家进行中任务；`type` 可选，用于只取主线/支线等 */
    getPlayerQuests(playerId, type) {
        const activeQuests = questDB.getPlayerActiveQuests(playerId);
        if (!type)
            return activeQuests;
        return activeQuests.filter(quest => quest.type === type);
    }
}
function onQuestTimeLimitTimerExpire() {
    const expired = jass.GetExpiredTimer();
    const data = globalThis.__questTimers?.get(expired);
    if (data) {
        questDebugPrint(`任务 ${data.questId} 时间到期`);
        questManager.onQuestFailed(data.playerId, data.questId);
        globalThis.__questTimers.delete(expired);
    }
    jass.PauseTimer(expired);
    safeDestroyTimer(expired);
}
/** 模块加载后即存在的单例引用；`05．事件桥接` 与其它系统统一使用此变量 */
export const questManager = QuestManager.getInstance();
