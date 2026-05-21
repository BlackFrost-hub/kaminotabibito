/**
 * 任务系统 - 数据结构定义和数据管理
 */
/** 获取当前时间戳（War3 Lua 环境下替代 Date.now） */
function now() {
    return os.time();
}
export var QuestType;
(function (QuestType) {
    QuestType["MAIN"] = "\u4E3B\u7EBF";
    QuestType["SIDE"] = "\u652F\u7EBF";
    QuestType["DAILY"] = "\u5C0F\u4EFB\u52A1";
})(QuestType || (QuestType = {}));
/**
 * 任务状态枚举（与War3原生状态对应）
 * 参考：bj_QUESTTYPE_REQ_DISCOVERED, bj_QUESTTYPE_REQ_UNDISCOVERED
 */
export var QuestStatus;
(function (QuestStatus) {
    QuestStatus["UNDISCOVERED"] = "\u672A\u53D1\u73B0";
    QuestStatus["DISCOVERED"] = "\u5DF2\u53D1\u73B0";
    QuestStatus["IN_PROGRESS"] = "\u8FDB\u884C\u4E2D";
    QuestStatus["COMPLETED"] = "\u5DF2\u5B8C\u6210";
    QuestStatus["FAILED"] = "\u5DF2\u5931\u8D25";
})(QuestStatus || (QuestStatus = {}));
/**
 * 任务数据库类
 */
export class QuestDatabase {
    static instance;
    questDefinitions = new Map(); // 任务定义模板
    globalData = {
        quests: new Map(),
        completedQuests: new Set(),
        failedQuests: new Set()
    };
    constructor() { }
    static getInstance() {
        if (!QuestDatabase.instance) {
            QuestDatabase.instance = new QuestDatabase();
        }
        return QuestDatabase.instance;
    }
    /**
     * 注册任务定义
     */
    registerQuest(quest) {
        quest.createdAt = quest.createdAt || now();
        quest.updatedAt = quest.updatedAt || now();
        this.questDefinitions.set(quest.id, quest);
    }
    /**
     * 获取任务定义
     */
    getQuest(id) {
        return this.questDefinitions.get(id);
    }
    /**
     * 获取所有任务定义
     */
    getAllQuests() {
        return Array.from(this.questDefinitions.values());
    }
    /**
     * 获取可接任务（未接受、前置已完成）
     */
    getAvailableQuests(playerId, type) {
        const source = type
            ? Array.from(this.questDefinitions.values()).filter(quest => quest.type === type)
            : this.getAllQuests();
        return source.filter(quest => {
            if (quest.uiReserved)
                return false;
            if (this.globalData.quests.has(quest.id) ||
                this.globalData.completedQuests.has(quest.id) ||
                this.globalData.failedQuests.has(quest.id)) {
                return false;
            }
            if (quest.requiredQuests && quest.requiredQuests.length > 0) {
                for (const rid of quest.requiredQuests) {
                    if (!this.globalData.completedQuests.has(rid))
                        return false;
                }
            }
            return true;
        });
    }
    /**
     * 初始化任务数据（所有玩家共享，无需 per-player）
     */
    initPlayerData(playerId) {
        // 现在是全局任务数据，无需 per-player 初始化
    }
    /**
     * 接受任务（所有玩家共享）
     */
    acceptQuest(playerId, questId) {
        const quest = this.getQuest(questId);
        if (!quest || quest.uiReserved)
            return false;
        // 检查是否已经接受或完成
        if (this.globalData.quests.has(questId) ||
            this.globalData.completedQuests.has(questId) ||
            this.globalData.failedQuests.has(questId)) {
            return false;
        }
        // 检查前置任务
        if (quest.requiredQuests && quest.requiredQuests.length > 0) {
            for (const requiredId of quest.requiredQuests) {
                if (!this.globalData.completedQuests.has(requiredId)) {
                    return false;
                }
            }
        }
        // 克隆任务数据并设置为进行中
        const acceptedQuest = {
            ...quest,
            status: QuestStatus.IN_PROGRESS,
            createdAt: now(),
            updatedAt: now(),
            startTime: now(),
        };
        this.globalData.quests.set(questId, acceptedQuest);
        return true;
    }
    /**
     * 完成任务（所有玩家共享）
     */
    completeQuest(playerId, questId) {
        const quest = this.globalData.quests.get(questId);
        if (!quest)
            return false;
        // 检查所有目标是否完成
        let allObjectivesCompleted = true;
        for (let i = 0; i < quest.objectives.length; i++) {
            if (!quest.objectives[i].completed) {
                allObjectivesCompleted = false;
                break;
            }
        }
        if (!allObjectivesCompleted)
            return false;
        // 更新状态
        quest.status = QuestStatus.COMPLETED;
        quest.updatedAt = now();
        // 移动到已完成列表
        this.globalData.quests.delete(questId);
        this.globalData.completedQuests.add(questId);
        return true;
    }
    /**
     * 放弃任务（所有玩家共享）
     */
    abandonQuest(playerId, questId) {
        const quest = this.globalData.quests.get(questId);
        if (!quest)
            return false;
        if (quest.status !== QuestStatus.IN_PROGRESS)
            return false;
        quest.status = QuestStatus.UNDISCOVERED;
        this.globalData.quests.delete(questId);
        return true;
    }
    /**
     * 任务失败（所有玩家共享）
     */
    failQuest(playerId, questId) {
        const quest = this.globalData.quests.get(questId);
        if (!quest)
            return false;
        if (quest.status !== QuestStatus.IN_PROGRESS)
            return false;
        quest.status = QuestStatus.FAILED;
        quest.updatedAt = now();
        this.globalData.quests.delete(questId);
        this.globalData.failedQuests.add(questId);
        return true;
    }
    /**
     * 更新任务目标进度（所有玩家共享）
     */
    updateObjective(playerId, questId, objectiveId, progress) {
        const quest = this.globalData.quests.get(questId);
        if (!quest)
            return false;
        const objective = quest.objectives.find(obj => obj.id === objectiveId);
        if (!objective)
            return false;
        objective.current = progress < objective.required ? progress : objective.required;
        objective.completed = objective.current >= objective.required;
        quest.updatedAt = now();
        return true;
    }
    /**
     * 获取进行中的任务（所有玩家共享）
     */
    getPlayerActiveQuests(playerId) {
        return Array.from(this.globalData.quests.values()).filter(quest => quest.status === QuestStatus.IN_PROGRESS);
    }
    /**
     * 获取已完成的任务（所有玩家共享）
     */
    getPlayerCompletedQuests(playerId) {
        return Array.from(this.globalData.completedQuests);
    }
    /**
     * 获取任务状态（所有玩家共享）
     */
    getPlayerQuestStatus(playerId, questId) {
        const quest = this.globalData.quests.get(questId);
        if (quest)
            return quest.status;
        if (this.globalData.completedQuests.has(questId))
            return QuestStatus.COMPLETED;
        if (this.globalData.failedQuests.has(questId))
            return QuestStatus.FAILED;
        return QuestStatus.UNDISCOVERED;
    }
    /**
     * 重置任务数据（用于测试）
     */
    resetPlayerData(playerId) {
        // 全局数据，重置所有
        this.globalData.quests.clear();
        this.globalData.completedQuests.clear();
        this.globalData.failedQuests.clear();
    }
    /**
     * 清除所有数据（用于测试）
     */
    clearAll() {
        this.questDefinitions.clear();
        this.globalData.quests.clear();
        this.globalData.completedQuests.clear();
        this.globalData.failedQuests.clear();
    }
}
// 导出单例实例
export const questDB = QuestDatabase.getInstance();
