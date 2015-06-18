--[[=========================================================================\\
  || Copyright (C) 2012, 2013, 2014, 2015 Niko Geil                          ||
  ||                                                                         ||
  || This file is part of serversquared Modification.                        ||
  ||                                                                         ||
  || serversquared Modification is free software: you can redistribute it    ||
  || and/or modify it under the terms of the GNU Affero General Public       ||
  || License as published by the Free Software Foundation, either version 3  ||
  || of the License, or (at your option) any later version.                  ||
  ||                                                                         ||
  || serversquared Modification is distributed in the hope that it will be   ||
  || useful, but WITHOUT ANY WARRANTY; without even the implied warranty of  ||
  || MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           ||
  || GNU Affero General Public License for more details.                     ||
  ||                                                                         ||
  || You should have received a copy of the GNU Affero General Public        ||
  || License along with serversquared Modification.  If not, see             ||
  || <http://www.gnu.org/licenses/>.                                         ||
  \\=========================================================================]]

local socket = require("socket")
local json = require("json")

local SSMod = {}		-- Main table for serversquared Modification.
SSMod.version = {}		-- Table for version numbers of Modification.
SSMod.version.network = "1.0.0"	-- Version of this library.
SSMod.network = {}		-- Main table for this library.

function SSMod.network.assemblePacket(from, version, data)
	local packet = {
		from = from,
		ver = SSMod.version.network,
		data = {},
	}

	for k, v in pairs(data) do
		packet.data[k] = v
	end

	return packet
end

function SSMod.network.send(packet, to)
	SENDFUNCTIONPLZCHANGE(json.encode(packet), to)
end

function SSMod.network.receive()
	local data = {}
end

return SSMod