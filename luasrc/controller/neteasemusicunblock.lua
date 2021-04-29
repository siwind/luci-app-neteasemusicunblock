-- This is a free software, use it under GNU General Public License v3.0.
-- Created By Silvan
-- https://github.com/cnsilvan/luci-app-neteasemusicunblock

module("luci.controller.neteasemusicunblock", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/neteasemusicunblock") then
		return
	end

	entry({"admin", "services", "neteasemusicunblock"},firstchild(), _("解除云音乐播放限制"), 50).dependent = false

	entry({"admin", "services", "neteasemusicunblock", "general"},cbi("neteasemusicunblock"), _("基本设定"), 1)
	entry({"admin", "services", "neteasemusicunblock", "senior"},cbi("neteasemusicunblock_senior"), _("高级设定"), 2)
	entry({"admin", "services", "neteasemusicunblock", "log"},form("neteasemusicunblock_log"), _("日志"), 3)

	entry({"admin", "services", "neteasemusicunblock", "status"},call("act_status")).leaf=true
end

function act_status()
	local e={}
	e.running=luci.sys.call("pidof neteasemusicunblock >/dev/null")==0
	luci.http.prepare_content("application/json")
	luci.http.write_json(e)
end
