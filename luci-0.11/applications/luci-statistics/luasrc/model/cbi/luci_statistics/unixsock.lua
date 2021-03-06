--[[

Luci configuration model for statistics - collectd unixsock plugin configuration
(c) 2008 Freifunk Leipzig / Jo-Philipp Wich <xm@leipzig.freifunk.net>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

$Id: unixsock.lua 6060 2010-04-13 20:42:26Z jow $

]]--

m = Map("luci_statistics",
	translate("Unixsock Plugin Configuration"),
	translate(
		"The unixsock plugin creates a unix socket which can be used " ..
		"to read collected data from a running collectd instance."
	))

-- collectd_unixsock config section
s = m:section( NamedSection, "collectd_unixsock", "luci_statistics" )

-- collectd_unixsock.enable
enable = s:option( Flag, "enable", translate("Enable this plugin") )
enable.default = 0

-- collectd_unixsock.socketfile (SocketFile)
socketfile = s:option( Value, "SocketFile" )
socketfile.default = "/var/run/collect-query.socket"
socketfile:depends( "enable", 1 )

-- collectd_unixsock.socketgroup (SocketGroup)
socketgroup = s:option( Value, "SocketGroup" )
socketgroup.default  = "nobody"
socketgroup.rmempty  = true
socketgroup.optional = true
socketgroup:depends( "enable", 1 )

-- collectd_unixsock.socketperms (SocketPerms)
socketperms = s:option( Value, "SocketPerms" )
socketperms.default  = "0770"
socketperms.rmempty  = true
socketperms.optional = true
socketperms:depends( "enable", 1 )

return m
