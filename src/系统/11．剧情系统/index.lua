--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local _xpcall = _G.xpcall
local _luaDebug = _G.debug
local _raiseError = _G.error
local STORY_INIT_LOG_MODULE = "剧情系统/分段加载"
local _____5F53_524D_5267_60C5_5B50_7CFB_7EDF_540D_79F0 = ""
local _____5F53_524D_5267_60C5_5B50_7CFB_7EDF_8DEF_5F84 = ""
local function _____5267_60C5_521D_59CB_5316_5F02_5E38_5904_7406(____error)
    local errorText = tostring(____error)
    local traceback = _luaDebug ~= nil and type(_luaDebug.traceback) == "function" and _luaDebug.traceback(errorText, 2) or errorText
    debugLogForce(STORY_INIT_LOG_MODULE, "捕获异常，完整调用栈如下\n" .. traceback)
    return traceback
end
local function _____6267_884C_5F53_524D_5267_60C5_5B50_7CFB_7EDF()
    debugLogForce(
        STORY_INIT_LOG_MODULE,
        "准备加载",
        _____5F53_524D_5267_60C5_5B50_7CFB_7EDF_540D_79F0,
        "path=",
        _____5F53_524D_5267_60C5_5B50_7CFB_7EDF_8DEF_5F84
    )
    local _____5B50_7CFB_7EDF = require(_____5F53_524D_5267_60C5_5B50_7CFB_7EDF_8DEF_5F84)
    debugLogForce(STORY_INIT_LOG_MODULE, "模块加载完成", _____5F53_524D_5267_60C5_5B50_7CFB_7EDF_540D_79F0)
    if type(_____5B50_7CFB_7EDF.init) == "function" then
        debugLogForce(STORY_INIT_LOG_MODULE, "准备初始化", _____5F53_524D_5267_60C5_5B50_7CFB_7EDF_540D_79F0)
        _____5B50_7CFB_7EDF.init()
        debugLogForce(STORY_INIT_LOG_MODULE, "初始化完成", _____5F53_524D_5267_60C5_5B50_7CFB_7EDF_540D_79F0)
    end
end
local function _____52A0_8F7D_5E76_521D_59CB_5316_5267_60C5_5B50_7CFB_7EDF(_____540D_79F0, _____6A21_5757_8DEF_5F84)
    _____5F53_524D_5267_60C5_5B50_7CFB_7EDF_540D_79F0 = _____540D_79F0
    _____5F53_524D_5267_60C5_5B50_7CFB_7EDF_8DEF_5F84 = _____6A21_5757_8DEF_5F84
    if type(_xpcall) == "function" then
        local ok = _xpcall(_____6267_884C_5F53_524D_5267_60C5_5B50_7CFB_7EDF, _____5267_60C5_521D_59CB_5316_5F02_5E38_5904_7406)
        if not ok then
            _raiseError("剧情子系统加载或初始化失败：" .. _____540D_79F0)
        end
    else
        _____6267_884C_5F53_524D_5267_60C5_5B50_7CFB_7EDF()
    end
end
function ____exports.init()
    _____52A0_8F7D_5E76_521D_59CB_5316_5267_60C5_5B50_7CFB_7EDF("公共", "系统.11．剧情系统.00．公共.index")
    _____52A0_8F7D_5E76_521D_59CB_5316_5267_60C5_5B50_7CFB_7EDF("主线任务", "系统.11．剧情系统.01．主线任务.index")
    _____52A0_8F7D_5E76_521D_59CB_5316_5267_60C5_5B50_7CFB_7EDF("支线任务", "系统.11．剧情系统.02．支线任务.index")
    _____52A0_8F7D_5E76_521D_59CB_5316_5267_60C5_5B50_7CFB_7EDF("世界线变动", "系统.11．剧情系统.03．世界线变动.index")
end
return ____exports
