import sys
import traceback
from pathlib import Path

import bpy


ADDON_PARENT = r"F:\Blender\MCP\blender_mcp\addon"


LOG_PATH = Path(r"C:\Users\Administrator\Desktop\syzl\blender_mcp_bootstrap.log")


def start_mcp_bridge():
    if ADDON_PARENT not in sys.path:
        sys.path.insert(0, ADDON_PARENT)

    try:
        from blender_mcp_addon import execute_interactive, mcp_to_blender_server

        mcp_to_blender_server.timer_internal_vars_calc(
            active=0.01,
            idle=0.1,
            idle_delay=1.0,
        )
        if not mcp_to_blender_server.is_running():
            mcp_to_blender_server.start("localhost", 9876)
        if not bpy.app.timers.is_registered(execute_interactive.run):
            bpy.app.timers.register(
                execute_interactive.run,
                first_interval=mcp_to_blender_server.TIMER_INTERVAL_ACTIVE,
                persistent=True,
            )
        LOG_PATH.write_text("started localhost:9876\n", encoding="utf-8")
    except Exception:
        LOG_PATH.write_text(traceback.format_exc(), encoding="utf-8")
    return None


start_mcp_bridge()
