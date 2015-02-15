-- ## (server)^2 Dependency ## --
-- This file is intended to be executed by the (server)^2 Modification Core, and should NOT be run separately.

-- (server)^2 Handler Extension API
-- v1.0.0

-- Initialize Handler function tables.
handlerPlayerSpawn = {}
handlerPlayerConnect = {}
handlerPlayerDisconnect = {}
handlerPlayerDamage = {}
handlerPlayerDeath = {}
handlerArenaWin = {}
handlerMapChange = {}
handlerMapEnd = {}
handlerPlayerTeamChange = {}
handlerPlayerItemPickup = {}
handlerExtension = {}
handlerPlayerCallVote = {}
handlerPlayerShoot = {}
handlerFlagAction = {}
handlerLuaNotice = {}
handlerBlRead = {}
handlerPasswordsRead = {}
handlerMaprotRead = {}
handlerPlayerRoleChange = {}
handlerPlayerRoleChangeTry = {}
handlerPlayerNameChange = {}
handlerPlayerWeaponChange = {}
handlerItemRespawn = {}
handlerItemSpawn = {}
handlerPlayerSayVoice = {}
handlerPlayerWeaponReload = {}
handlerVoteEnd = {}
handlerPlayerSpawnClientSide = {}
handlerPlayerSwitchSpectCn = {}
handlerPlayerSuicide = {}
handlerPlayerVote = {}
handlerPlayerSendMap = {}
handlerPlayerDeathAfter = {}
handlerPlayerSpawnAfter = {}
handlerPlayerDamageAfter = {}
handlerPlayerTeamChangeAfter = {}
handlerPlayerItemPickupAfter = {}
handlerPlayerSayTextAfter = {}
handlerPlayerRoleChangeAfter = {}
handlerItemRespawnAfter = {}
handlerItemSpawnAfter = {}
handlerPlayerSayVoiceAfter = {}
handlerVoteEndAfter = {}
handlerPlayerSendMapAfter = {}
handlerWhois = {}
handlerWhoisAfter = {}
handlerPlayerDisconnectAfter = {}
handlerPlayerShootAfter = {}
handlerMasterServerUpdate = {}
handlerMasterServerCommand = {}
handlerMasterServerCommandAfter = {}
handlerPlayerBanThresholdReach = {}
handlerPlayerKickThresholdReach = {}
handlerConfigReread = {}
handlerConfigRereadAfter = {}
handlerPlayerRemoveMapAfter = {}
handlerPlayerPreconnect = {}
handlerPlayerSwitchEditing = {}
handlerPlayerRemoveMap = {}

-- Handler API
function onPlayerSpawn(CN)
	for tableName, tableValue in pairs(handlerPlayerSpawn) do
		for handlerFunction in pairs(tableValue) do
			if handlerPlayerSpawn[tableName][handlerFunction](CN) == false then
				return PLUGIN_BLOCK
			end
		end
	end
end

function onPlayerConnect(CN)
	for tableName, tableValue in pairs(handlerPlayerConnect) do
		for handlerFunction in pairs(tableValue) do
			handlerPlayerConnect[tableName][handlerFunction](CN)
		end
	end
end

function onPlayerDisconnect(CN, reason)
	for tableName, tableValue in pairs(handlerPlayerDisconnect) do
		for handlerFunction in pairs(tableValue) do
			handlerPlayerDisconnect[tableName][handlerFunction](CN, reason)
		end
	end
end

function onPlayerDamage(actorCN, targetCN, damage, actorGun, isGib)
	for tableName, tableValue in pairs(handlerPlayerDamage) do
		for handlerFunction in pairs(tableValue) do
			if handlerPlayerDamage[tableName][handlerFunction](actorCN, targetCN, damage, actorGun, isGib) == false then
				return PLUGIN_BLOCK
			end
		end
	end
end

function onPlayerDeath(targetCN, actorCN, isGib, gun)
	for tableName, tableValue in pairs(handlerPlayerDeath) do
		for handlerFunction in pairs(tableValue) do
			if handlerPlayerDeath[tableName][handlerFunction](targetCN, actorCN, isGib, gun) == false then
				return PLUGIN_BLOCK
			end
		end
	end
end

function onArenaWin(aliveCN)
	for tableName, tableValue in pairs(handlerArenaWin) do
		for handlerFunction in pairs(tableValue) do
			handlerArenaWin[tableName][handlerFunction](aliveCN)
		end
	end
end

function onMapChange(map, gamemode)
	for tableName, tableValue in pairs(handlerMapChange) do
		for handlerFunction in pairs(tableValue) do
			handlerMapChange[tableName][handlerFunction](map, gamemode)
		end
	end
end

function onMapEnd()
	for tableName, tableValue in pairs(handlerMapEnd) do
		for handlerFunction in pairs(tableValue) do
			handlerMapEnd[tableName][handlerFunction]()
		end
	end
end

function onPlayerTeamChange(CN, newTeam, reason)
	for tableName, tableValue in pairs(handlerPlayerTeamChange) do
		for handlerFunction in pairs(tableValue) do
			if handlerPlayerTeamChange[tableName][handlerFunction](CN, newTeam, reason) == false then
				return PLUGIN_BLOCK
			end
		end
	end
end

function onPlayerItemPickup(CN, itemType, itemID)
	for tableName, tableValue in pairs(handlerPlayerItemPickup) do
		for handlerFunction in pairs(tableValue) do
			if handlerPlayerItemPickup[tableName][handlerFunction](CN, itemType, itemID) == false then
				return PLUGIN_BLOCK
			end
		end
	end
end

function onExtension(extension, CN, argument)
	for tableName, tableValue in pairs(handlerExtension) do
		for handlerFunction in pairs(tableValue) do
			handlerExtension[tableName][handlerFunction](extension, CN, argument)
		end
	end
end

function onPlayerCallVote(CN, voteType, text, number, voteError)
	for tableName, tableValue in pairs(handlerPlayerCallVote) do
		for handlerFunction in pairs(tableValue) do
			handlerPlayerCallVote[tableName][handlerFunction](CN, voteType, text, number, voteError)
		end
	end
end

function onPlayerShoot(CN, gun, to)
	for tableName, tableValue in pairs(handlerPlayerShoot) do
		for handlerFunction in pairs(tableValue) do
			handlerPlayerShoot[tableName][handlerFunction](CN, gun, to)
		end
	end
end

function onFlagAction(CN, action, flag)
	for tableName, tableValue in pairs(handlerFlagAction) do
		for handlerFunction in pairs(tableValue) do
			handlerFlagAction[tableName][handlerFunction](CN, action, flag)
		end
	end
end

function onBlRead()
	for tableName, tableValue in pairs(handlerBlRead) do
		for handlerFunction in pairs(tableValue) do
			handlerBlRead[tableName][handlerFunction]()
		end
	end
end

function onPasswordsRead()
	for tableName, tableValue in pairs(handlerPasswordsRead) do
		for handlerFunction in pairs(tableValue) do
			handlerPasswordsRead[tableName][handlerFunction]()
		end
	end
end

function onPasswordsRead()
	for tableName, tableValue in pairs(handlerPasswordsRead) do
		for handlerFunction in pairs(tableValue) do
			handlerPasswordsRead[tableName][handlerFunction]()
		end
	end
end

function onMaprotRead()
	for tableName, tableValue in pairs(handlerMaprotRead) do
		for handlerFunction in pairs(tableValue) do
			handlerMaprotRead[tableName][handlerFunction]()
		end
	end
end

function onPlayerRoleChange(CN, newRole, hash, adminPasswordLine, isConnecting)
	for tableName, tableValue in pairs(handlerPlayerRoleChange) do
		for handlerFunction in pairs(tableValue) do
			if handlerPlayerRoleChange[tableName][handlerFunction](CN, newRole, hash, adminPasswordLine, isConnecting) == false then
				return PLUGIN_BLOCK
			end
		end
	end
end

function onPlayerRoleChangeTry(CN, newRole, hash, isConnecting)
	for tableName, tableValue in pairs(handlerPlayerRoleChangeTry) do
		for handlerFunction in pairs(tableValue) do
			if handlerPlayerRoleChangeTry[tableName][handlerFunction](CN, role, hash, isConnecting) == false then
				return PLUGIN_BLOCK
			end
		end
	end
end

function onPlayerNameChange(CN, newName)
	for tableName, tableValue in pairs(handlerPlayerNameChange) do
		for handlerFunction in pairs(tableValue) do
			handlerPlayerNameChange[tableName][handlerFunction](CN, newName)
		end
	end
end

function onPlayerWeaponChange(CN, newWeapon)
	for tableName, tableValue in pairs(handlerPlayerWeaponChange) do
		for handlerFunction in pairs(tableValue) do
			handlerPlayerWeaponChange[tableName][handlerFunction](CN, newWeapon)
		end
	end
end

function onItemRespawn(itemID, itemType)
	for tableName, tableValue in pairs(handlerItemRespawn) do
		for handlerFunction in pairs(tableValue) do
			if handlerItemRespawn[tableName][handlerFunction](itemID, itemType) == false then
				return PLUGIN_BLOCK
			end
		end
	end
end

function onItemSpawn(itemID, itemType)
	for tableName, tableValue in pairs(handlerItemSpawn) do
		for handlerFunction in pairs(tableValue) do
			if handlerItemSpawn[tableName][handlerFunction](itemID, itemType) == false then
				return PLUGIN_BLOCK
			end
		end
	end
end

function onPlayerSayVoice(CN, sound)
	for tableName, tableValue in pairs(handlerPlayerSayVoice) do
		for handlerFunction in pairs(tableValue) do
			if handlerPlayerSayVoice[tableName][handlerFunction](CN, sound) == false then
				return PLUGIN_BLOCK
			end
		end
	end
end

function onPlayerWeaponReload(CN, weapon)
	for tableName, tableValue in pairs(handlerPlayerWeaponReload) do
		for handlerFunction in pairs(tableValue) do
			handlerPlayerWeaponReload[tableName][handlerFunction](CN, weapon)
		end
	end
end

function onVoteEnd(result, ownerCN, voteType, text, number)
	for tableName, tableValue in pairs(handlerVoteEnd) do
		for handlerFunction in pairs(tableValue) do
			if handlerVoteEnd[tableName][handlerFunction](result, ownerCN, voteType, text, number) == false then
				return PLUGIN_BLOCK
			end
		end
	end
end

function onPlayerSpawnClientSide(CN)
	for tableName, tableValue in pairs(handlerPlayerSpawnClientSide) do
		for handlerFunction in pairs(tableValue) do
			handlerPlayerSpawnClientSide[tableName][handlerFunction](CN)
		end
	end
end

function onPlayerSwitchSpectCn(actorCN, spectCN)
	for tableName, tableValue in pairs(handlerPlayerSwitchSpectCn) do
		for handlerFunction in pairs(tableValue) do
			handlerPlayerSwitchSpectCn[tableName][handlerFunction](actorCN, spectCN)
		end
	end
end

function onPlayerSuicide(CN)
	for tableName, tableValue in pairs(handlerPlayerSuicide) do
		for handlerFunction in pairs(tableValue) do
			if handlerPlayerSuicide[tableName][handlerFunction](CN) == false then
				return PLUGIN_BLOCK
			end
		end
	end
end

function onPlayerVote(CN, vote)
	for tableName, tableValue in pairs(handlerPlayerVote) do
		for handlerFunction in pairs(tableValue) do
			handlerPlayerVote[tableName][handlerFunction](CN, vote)
		end
	end
end

function onPlayerSendMap(mapName, CN, revision, mapsize, cfgsize, cfgsizegz, uploadError)
	for tableName, tableValue in pairs(handlerPlayerSendMap) do
		for handlerFunction in pairs(tableValue) do
			handlerPlayerSendMap[tableName][handlerFunction](mapName, CN, revision, mapsize, cfgsize, cfgsizegz, uploadError)
		end
	end
end

function onPlayerDeathAfter(targetCN, actorCN, isGib, gun)
	for tableName, tableValue in pairs(handlerPlayerDeathAfter) do
		for handlerFunction in pairs(tableValue) do
			handlerPlayerDeathAfter[tableName][handlerFunction](targetCN, actorCN, isGib, gun)
		end
	end
end

function onPlayerSpawnAfter(CN)
	for tableName, tableValue in pairs(handlerPlayerSpawnAfter) do
		for handlerFunction in pairs(tableValue) do
			handlerPlayerSpawnAfter[tableName][handlerFunction](CN)
		end
	end
end

function onPlayerDamageAfter(actorCN, targetCN, damage, actorGun, isGib)
	for tableName, tableValue in pairs(handlerPlayerDamageAfter) do
		for handlerFunction in pairs(tableValue) do
			handlerPlayerDamageAfter[tableName][handlerFunction](actorCN, targetCN, damage, actorGun, isGib)
		end
	end
end

--[[
  ## That night, Core could not sleep. He was crying on
  ## his bed, thinking about what his father had not
  ## said. He wondered what had to happen for an app to
  ## be created, and why his father had not told him.
  ##
  2# "Son?" his father asked as he entered Core's room.
  ##
  ## "Yes, papa Core?" he replied, trying not cry.
  ##
  ## "If you really want to know, I will tell you how
  ## applications are made. But only if you are ready."
  ]]

function onPlayerTeamChangeAfter(CN, oldTeam, reason)
	for tableName, tableValue in pairs(handlerPlayerTeamChangeAfter) do
		for handlerFunction in pairs(tableValue) do
			handlerPlayerTeamChangeAfter[tableName][handlerFunction](CN, oldTeam, reason)
		end
	end
end

function onPlayerItemPickupAfter(CN, itemType, itemID)
	for tableName, tableValue in pairs(handlerPlayerItemPickupAfter) do
		for handlerFunction in pairs(tableValue) do
			handlerPlayerItemPickupAfter[tableName][handlerFunction](CN, itemType, itemID)
		end
	end
end

function onPlayerSayTextAfter(CN, text)
	for tableName, tableValue in pairs(handlerPlayerSayTextAfter) do
		for handlerFunction in pairs(tableValue) do
			handlerPlayerSayTextAfter[tableName][handlerFunction](CN, text)
		end
	end
end

function onPlayerRoleChangeAfter(CN, oldRole, hash, adminPasswordLine, isConnecting)
	for tableName, tableValue in pairs(handlerPlayerRoleChangeAfter) do
		for handlerFunction in pairs(tableValue) do
			handlerPlayerRoleChangeAfter[tableName][handlerFunction](CN, oldRole, hash, adminPasswordLine, isConnecting)
		end
	end
end

function onItemRespawnAfter(itemID, itemType)
	for tableName, tableValue in pairs(handlerItemRespawnAfter) do
		for handlerFunction in pairs(tableValue) do
			handlerItemRespawnAfter[tableName][handlerFunction](itemID, itemType)
		end
	end
end

function onItemSpawnAfter(itemID, itemType)
	for tableName, tableValue in pairs(handlerItemRespawnAfter) do
		for handlerFunction in pairs(tableValue) do
			handlerItemSpawnAfter[tableName][handlerFunction](itemID, itemType)
		end
	end
end

function onPlayerSayVoiceAfter(CN, sound)
	for tableName, tableValue in pairs(handlerPlayerSayVoiceAfter) do
		for handlerFunction in pairs(tableValue) do
			handlerPlayerSayVoiceAfter[tableName][handlerFunction](CN, sound)
		end
	end
end

function onVoteEndAfter(result, ownerCN, voteType, text, number)
	for tableName, tableValue in pairs(handlerVoteEndAfter) do
		for handlerFunction in pairs(tableValue) do
			handlerVoteEndAfter[tableName][handlerFunction](result, ownerCN, voteType, text, number)
		end
	end
end

function onPlayerSendMapAfter(mapName, CN, revision, mapsize, cfgsize, cfgsizegz, uploadError)
	for tableName, tableValue in pairs(handlerPlayerSendMapAfter) do
		for handlerFunction in pairs(tableValue) do
			handlerPlayerSendMapAfter[tableName][handlerFunction](mapName, CN, revision, mapsize, cfgsize, cfgsizegz, uploadError)
		end
	end
end

function onWhois(actorCN, targetCN)
	for tableName, tableValue in pairs(handlerWhois) do
		for handlerFunction in pairs(tableValue) do
			if handlerWhois[tableName][handlerFunction](actorCN, targetCN) == false then
				return PLUGIN_BLOCK
			end
		end
	end
end

function onWhoisAfter(actorCN, targetCN)
	for tableName, tableValue in pairs(handlerWhoisAfter) do
		for handlerFunction in pairs(tableValue) do
			handlerWhoisAfter[tableName][handlerFunction](actorCN, targetCN)
		end
	end
end

function onPlayerDisconnectAfter(CN, reason)
	for tableName, tableValue in pairs(handlerPlayerDisconnectAfter) do
		for handlerFunction in pairs(tableValue) do
			handlerPlayerDisconnectAfter[tableName][handlerFunction](CN, reason)
		end
	end
end

function onPlayerShootAfter(CN, gun, to)
	for tableName, tableValue in pairs(handlerPlayerShootAfter) do
		for handlerFunction in pairs(tableValue) do
			handlerPlayerShootAfter[tableName][handlerFunction](CN, gun, to)
		end
	end
end

function onMasterServerUpdate(host)
	for tableName, tableValue in pairs(handlerMasterServerUpdate) do
		for handlerFunction in pairs(tableValue) do
			handlerMasterServerUpdate[tableName][handlerFunction](host)
		end
	end
end

function onMasterServerCommand(host, command)
	for tableName, tableValue in pairs(handlerMasterServerCommand) do
		for handlerFunction in pairs(tableValue) do
			handlerMasterServerCommand[tableName][handlerFunction](host, command)
		end
	end
end

function onMasterServerCommandAfter(host, command)
	for tableName, tableValue in pairs(handlerMasterServerCommandAfter) do
		for handlerFunction in pairs(tableValue) do
			handlerMasterServerCommandAfter[tableName][handlerFunction](host, command)
		end
	end
end

function onPlayerBanThresholdReach(CN)
	for tableName, tableValue in pairs(handlerPlayerBanThresholdReach) do
		for handlerFunction in pairs(tableValue) do
			if handlerPlayerBanThresholdReach[tableName][handlerFunction](CN) == false then
				return PLUGIN_BLOCK
			end
		end
	end
end

function onPlayerKickThresholdReach(CN)
	for tableName, tableValue in pairs(handlerPlayerKickThresholdReach) do
		for handlerFunction in pairs(tableValue) do
			if handlerPlayerKickThresholdReach[tableName][handlerFunction](CN) == false then
				return PLUGIN_BLOCK
			end
		end
	end
end

function onConfigReread()
	for tableName, tableValue in pairs(handlerConfigReread) do
		for handlerFunction in pairs(tableValue) do
			if handlerConfigReread[tableName][handlerFunction]() == false then
				return PLUGIN_BLOCK
			end
		end
	end
end

function onConfigRereadAfter()
	for tableName, tableValue in pairs(handlerConfigRereadAfter) do
		for handlerFunction in pairs(tableValue) do
			handlerConfigRereadAfter[tableName][handlerFunction]()
		end
	end
end

function onPlayerRemoveMapAfter(mapName, CN, removeError)
	for tableName, tableValue in pairs(handlerPlayerRemoveMapAfter) do
		for handlerFunction in pairs(tableValue) do
			handlerPlayerRemoveMapAfter[tableName][handlerFunction](mapName, CN, removeError)
		end
	end
end

function onPlayerPreconnect(CN)
	for tableName, tableValue in pairs(handlerPlayerPreconnect) do
		for handlerFunction in pairs(tableValue) do
			handlerPlayerPreconnect[tableName][handlerFunction](CN)
		end
	end
end

function onPlayerSwitchEditing(CN, isEditing)
	for tableName, tableValue in pairs(handlerPlayerSwitchEditing) do
		for handlerFunction in pairs(tableValue) do
			handlerPlayerSwitchEditing[tableName][handlerFunction](CN, isEditing)
		end
	end
end

function onPlayerRemoveMap(mapName, CN, removeError)
	for tableName, tableValue in pairs(handlerPlayerRemoveMap) do
		for handlerFunction in pairs(tableValue) do
			handlerPlayerRemoveMap[tableName][handlerFunction](mapName, CN, removeError)
		end
	end
end