PLUGIN_NAME = "(server)^2 Modification"
PLUGIN_AUTHOR = "server"
PLUGIN_VERSION = "9.0.0" -- In development!

--[[ ################################################################
Copyright (C) server - All Rights Reserved.
This work is licensed under the Creative
Commons Attribution-NoDerivatives 4.0 International
License. To view a copy of this license,
visit http://creativecommons.org/licenses/by-nd/4.0/.
Written by server <serversquaredmain@gmail.com>, January 2015.
     ################################################################   ]]


-- Main table for the Core.
SSCore = {}
SSCore.baseversionCore = "9"			-- Base version of the Core.
SSCore.baseversionAPI = "1"				-- Base version of the Core API. Modules should probably work if they were written for this base version.
SSCore.versionCore = "9.0.0"			-- Version of the Core.
SSCore.versionAPI = "1.0"				-- Version of the Core API.
SSCore.alpha = true						-- True if this build is an alpha build.
SSCore.beta = false						-- True if this build is a beta build.
SSCore.buildDate = "26 January 2015"	-- Build date of this release. Not changed for dev builds.
SSCore.copyright = "2015"				-- Year of Copyright registration.
SSCore.url = "serversquared.org"	-- URL of the (server)^2 website.
SSCore.enableLog = true					-- Turn on or off mod logging.
SSCore.debugMode = false				-- Turn on or off debug (verbose) mode. This WILL write to the log.
SSCore.logInfo = true					-- Turn on or off logging "INFO" level messages.

-- Function to write the log.
function SSCore.log(message, level, sender)
	-- Do not continue if logging is off
	if not SSCore.enableLog then
		return
	end
	-- Log and print message, warn if incorrect syntax.
	if level == 0 and message ~= nil and sender ~= nil and SSCore.debugMode then
		print("[" .. os.date("%X") .. "] [" .. sender .. "/DEBUG]: " .. message)
		logline(level, "[" .. os.date("%X") .. "] [" .. sender .. "/DEBUG]: " .. message)
	elseif level == 1 and message ~= nil and sender ~= nil and SSCore.debugMode then
		print("[" .. os.date("%X") .. "] [" .. sender .. "/DEBUG]: " .. message)
		logline(level, "[" .. os.date("%X") .. "] [" .. sender .. "/DEBUG]: " .. message)
	elseif level == 2 and message ~= nil and sender ~= nil and SSCore.logInfo then
		logline(level, "[" .. os.date("%X") .. "] [" .. sender .. "/INFO]: " .. message)
	elseif level == 3 and message ~= nil and sender ~= nil then
		logline(level, "[" .. os.date("%X") .. "] [" .. sender .. "/WARN]: " .. message)
	elseif level == 4 and message ~= nil and sender ~= nil then
		logline(level, "[" .. os.date("%X") .. "] [" .. sender .. "/ERROR]: " .. message)
	elseif level == 20 and message ~= nil and sender ~= nil then
		logline(4, "[" .. os.date("%X") .. "] [" .. sender .. "/FATAL]: " .. message)
	elseif level == 21 and message ~= nil and sender ~= nil then
		logline(2, "[" .. os.date("%X") .. "] [" .. sender .. "/SHUTDOWN]: " .. message)
	elseif level == 22 and message ~= nil and sender ~= nil then
		logline(1, "[" .. os.date("%X") .. "] [" .. sender .. "/CHAT]: " .. message)
	elseif (level == 0 and message ~= nil and sender ~= nil and not SSCore.debugMode) or (level == 1 and message ~= nil and sender ~= nil and not SSCore.debugMode) or (level == 2 and message ~= nil and sender ~= nil and not SSCore.logInfo) then
		return
	else
		logline(3, "[" .. os.date("%X") .. "] [Server Core/WARN]: Log message was sent in the incorrect syntax.")
	end
end

-- Define blank to help prevent errors, space to make spaces more readable.
blank = ""
space = " "
baaaby = "and I\'ll write your name"

-- Include the AssaultCube server core.
include("ac_server")

-- Load LuaSocket
socket = require("socket")

-- Load Lua-Ex
require("ex")

-- Load SHA-1
sha1 = require("sha1")

function SSCore.init()
	SSCore.log("Initializing the Modification.", 2, "Server Core")
	-- Load our variables.
	SSCore.log("Loading Global configuration variables.", 1, "Server Core")
	SSCore.chatEcho = false					-- Global echo back coloured chat.
	SSCore.colouredChat = true				-- Allow or disallow coloured chat.
	SSCore.useAdminSystem = false			-- Use an external Administration system.
	SSCore.useMuteSystem = false			-- Use an external player muting system.
	SSCore.useChatFilter = false			-- Use an external chat filter system.
	SSCore.log("Loading server colour configuration.", 1, "Server Core")
	SSCore.serverColours = {}				-- Table of colours for the server.
	SSCore.serverColours.primary = "\f4"	-- Primary colour.
	SSCore.serverColours.secondary = "\f3"	-- Secondary colour.
	SSCore.serverColours.chatPublic = "\f0"	-- Public chat colour.
	SSCore.serverColours.chatTeam = "\f1"	-- Team chat colour.
	
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
	handlerPlayerSayText = {}
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
	
	-- Core functions.
	-- Make it easier to talk to the players.
	function SSCore.say(text, toCN, excludeCN)
		SSCore.log("Starting say function.", 1, "Server Core")
		if toCN == nil then
			SSCore.log("Recipient was not given, making the message global.", 0, "Server Core")
			toCN = -1
		end
		if excludeCN == nil then
			SSCore.log("Excluded client was not given, making the message global.", 0, "Server Core")
			excludeCN = -1
		end
		if text == nil then
			SSCore.log("Text was not given, sending a blank message.", 0, "Server Core")
			text = blank
		end
		SSCore.log("Printing to " .. toCN .. " excluding " .. excludeCN, 1, "Server Core")
		clientprint(toCN, text, excludeCN)
	end

	-- Run a Module.
	function SSCore.runModule(moduleName, unloadModule, booleanMode)
		SSCore.log("Starting runModule function.", 1, "Server Core")
		local loadStartTick = getsvtick()
		if unloadModule == nil or moduleName == nil then
			SSCore.log("runModule was called using incorrect syntax, stopping.", 3, "Server Core")
		end
		SSCore.log("Loading Module" .. (unloadModule and " in unload mode" or blank) .. ": " .. moduleName, 2, "Server Core")
		if pcall(dofile, "lua/scripts/SSModules/" .. moduleName .. ".ssm") then
			if unloadModule then
				onModuleUnload()
				if addCommands ~= nil then
					for commandName in pairs(addCommands) do
						commands[commandName] = nil
					end
				end
			elseif not unloadModule then
				if addCommands ~= nil then
					for commandName,commandFunction in pairs(addCommands) do
						commands[commandName] = commandFunction
					end
				end
				onModuleLoad()
			end
			onModuleLoad = nil
			onModuleUnload = nil
			local loadTime = (getsvtick() - loadStartTick)
			SSCore.log("Successfully loaded Module in " .. loadTime .. "ms.", 2, "Server Core")
			if unloadModule then
				SSCore.loadedModules[moduleName] = nil
				SSCore.log("Removed module from loadedModules table.", 0, "Server Core")
			else
				SSCore.loadedModules[moduleName] = true
				SSCore.checkModule(moduleName, moduleInfo)
				SSCore.log("Added Module to loadedModules table.", 0, "Server Core")
			end
			if booleanMode ~= nil and booleanMode then
				return true
			end
		else
			SSCore.log("Error loading Module.", 4, "Server Core")
			if booleanMode ~= nil and booleanMode then
				return false
			end
		end
	end

	-- Check if a Module is built for our API base version.
	function SSCore.checkModule(moduleName, moduleInfo)
		if moduleInfo ~= nil then
			if moduleInfo.usesbaseAPI ~= nil and moduleInfo.usesbaseAPI < SSCore.baseversionAPI then
				SSCore.log("Module " .. moduleName .. " is built for old API version " .. moduleInfo.usesAPI .. ". It may have compatibility issues.", 3, "Server Core")
			end
			moduleInfo = nil
		else
			SSCore.log("Module " .. moduleName .. " does not have a config. This may cause issues if the API version is outdated.", 3, "Server Core") 
		end
	end

	-- Chat printing
	function SSCore.printChat(text, CN, chatPrefix, isTeam, isMe)
		print("[" .. os.date("%X") .. "] [" .. getip(CN) .. "] " .. (isTeam and "[TEAM] " or blank) .. (isMe and "[ME] " or blank) .. getname(CN) .. " (" .. CN .. ") says: \"" .. text .. "\"")
		SSCore.log("[" .. getip(CN) .. "] " .. (isTeam and "[TEAM] " or blank) .. (isMe and "[ME] " or blank) .. getname(CN) .. " (" .. CN .. ") says: \"" .. text .. "\"", 22, "Server Core")
		if isTeam then
			for x=0,maxclient(),1 do
				if getteam(CN) == getteam(x) and CN ~= x then
					SSCore.say(SSCore.serverColours.primary .. CN .. "\f3" .. chatPrefix .. SSCore.serverColours.secondary .. "#" .. (isMe and SSCore.serverColours.chatTeam or "\f5") .. getname(CN) .. SSCore.serverColours.chatTeam .. (isMe and space or ": ") .. text, x, (SSCore.chatEcho and -1 or CN))
				end
			end
		else
			SSCore.say(SSCore.serverColours.primary .. CN .. "\f3" .. chatPrefix .. SSCore.serverColours.secondary .. "#" .. (isMe and SSCore.serverColours.chatPublic or "\f5") .. getname(CN) .. SSCore.serverColours.chatPublic .. (isMe and space or ": ") .. text, -1, (SSCore.chatEcho and -1 or CN))
		end
	end

	-- Chat decoding and processing. Chat and commands will probably break if this is changed by a Module, unless they know what they're doing.
	function onPlayerSayText(CN, text, isTeam, isMe)
		SSCore.log("Starting processing client chat.", 1, "Server Core")
		
		-- Run chat extensions (if present)
		SSCore.log("Running chat extensions (if present).", 1, "Server Core")
		for tableName, tableValue in pairs(handlerPlayerSayText) do
			for handlerFunction in pairs(tableValue) do
				handlerPlayerSayText[tableName][handlerFunction](CN, text, isTeam, isMe)
			end
		end
		-- Initialize chatPrefix.
		SSCore.log("Setting chat prefix to blank.", 0, "Server Core")
		local chatPrefix = blank
		
		-- Make a Server Master prefix if using default admin system.
		if isadmin(CN) then
			SSCore.log("Client is logged in as the server administrator, not using modded system. Setting prefix to @.", 0, "Server Core")
			local chatPrefix = "@"
		end
		
		-- Use dynamic prefixes if using our external Administration system.
		if SSCore.useAdminSystem then
			SSCore.log("Server is using modded admin system, checking for permissions.", 0, "Server Core")
			if modModerator[getname(CN)] then
				SSCore.log("Client has Moderator permissions. Setting prefix to M.", 0, "Server Core")
				local chatPrefix = "M"
			end
			if modAdministrator[getip(CN)] then
				SSCore.log("Client has Administrator permissions. Setting prefix to A.", 0, "Server Core")
				local chatPrefix = "A"
			end
			if modMaster[getip(CN)] then
				SSCore.log("Client has Master permissions. Setting prefix to @.", 0, "Server Core")
				local chatPrefix = "@"
			end
		end
		
		-- Block muted clients if using our external Muting system.
		if SSCore.useMuteSystem then
			SSCore.log("Server is using modded mute system, if client is muted.", 0, "Server Core")
			if isMuted[getip(CN)] then
				SSCore.log("Client is muted, stopping chat processing.", 0, "Server Core")
				blockChatReason = "Client is muted."
				SSCore.log("Sending chat to mute system to take over chat processing.", 0, "Server Core")
				blockChat(CN, text, isTeam, isMe, blockChatReason)
				return PLUGIN_BLOCK
			end
		end
		
		-- Test for profanity if using a filter system.
		if SSCore.useChatFilter then
			SSCore.log("Server is using modded profanity filter, checking for bloked words.", 0, "Server Core")
			if not chatIsClean(text) then
				SSCore.log("Chat contains a blocked word, stopping chat processing.", 0, "Server Core")
				blockChatReason = "Chat contains profanity."
				SSCore.log("Sending chat to filter system to take over chat processing.", 0, "Server Core")
				blockChat(CN, text, isTeam, isMe, blockChatReason)
				return PLUGIN_BLOCK
			end
		end
		
		-- Convert colour codes if enabled on our server.
		if SSCore.colouredChat then
			SSCore.log("Server has coloured text enabled, reprocessing and converting colour codes.", 0, "Server Core")
			local text = string.gsub(text, "\\f", "\f")
		end
		
		-- Split the text into an array.
		SSCore.log("Converting the sent chat into a table for command processing.", 0, "Server Core")
		local array = split(text, " ")
		-- Separate the command from the arguments.
		SSCore.log("Separating the command (first table entry) from the arguments.", 0, "Server Core")
		local command, args = array[1], slice(array, 2)
		-- Check if the text is a command, execute if it is.
		if commands[command] ~= nil then
			SSCore.log("Chat is a command, processing from command list.", 1, "Server Core")
			local callback = commands[command][1]
			callback(CN, args)
			return PLUGIN_BLOCK
		elseif string.byte(command,1) == string.byte("!",1) then
			SSCore.log("Chat is not a command but in command notation. Stopping chat processing.", 1, "Server Core")
			print("Not a command: \"" .. command .. "\"")
			return PLUGIN_BLOCK		
		end
		
		-- Chat function
		SSCore.log("Initial chat processing complete, sending to printChat to determine teams and /me.", 1, "Server Core")
		SSCore.printChat(text, CN, chatPrefix, isTeam, isMe)
		return PLUGIN_BLOCK
	end

	SSCore.verify()
end

function SSCore.configServer()
	-- Present a friendly message for the server configuration interface.
	SSCore.log("Writing configuration interface.", 1, "Server Core")
	io.write("\nWelcome to (server)^2 Modification version " .. PLUGIN_VERSION .. "!\n")
	if SSCore.alpha or SSCore.beta then io.write("********************\n/!\\ WARNING /!\\\nTHIS BUILD IS INCOMPLETE AND MAY CAUSE STABILITY ISSUES!\nUSE AT YOUR OWN RISK!\n********************\n") end
	io.write("Please report any bugs to the issue tracker at:\n")
	io.write("https://github.com/account3r2/serversquaredmod/issues\n")
	io.write("Let's configure your server.\n")
	io.write("============================================================\n")
	-- Get current working directory
	SSCore.log("Getting Current Working Directory.", 1, "Server Core")
	SSCore.ACPath = os.currentdir()
	SSCore.log("We are here: " .. SSCore.ACPath, 0, "Server Core")
	-- Determine if we're running on a Unix-like system
	if package.config:sub(1,1) == "/" then
		unix = true
	else
		unix = false
	end
	SSCore.log("We are " .. (unix and "not " or blank) .. "on a Windows NT-based system.", 0, "Server Core")
	-- Set input to stdin just in case.
	io.input(io.stdin)
	-- Should we load a configuration file?
	repeat
		io.write("Load from config file? Answer n if you don't have one. (y/n)\n")
		io.write(">")
		configAnswer = io.read()
		if configAnswer == "n" then
			loadFromConfig = false
		elseif configAnswer == blank or configAnswer == "y" then
			loadFromConfig = true
		end
	until loadFromConfig ~= nil
	-- Finish configuring the server if user answered no.
	if not loadFromConfig then
	SSCore.log("User wants to create a new config.", 1, "Server Core")
		-- What should the server be called?
		io.write("\nWhat would you like your server to be called?\n")
		io.write("Use the server colour codes if desired.\n")
		io.write(">")
		SSCore.serverName = (io.read() or blank)
		-- Get the user website for our API.
		io.write("\nWhat's your website URL?\n")
		io.write(">")
		SSCore.serverWebsite = (io.read() or blank)
		-- Make it easier on the user and offer a config save.
		repeat
			io.write("\nWould you like to save your configuration?\n")
			io.write(">")
			configAnswer = io.read()
			if configAnswer == "n" then
				SSCore.log("User completed config, and does not want to save to file.", 1, "Server Core")
				configCompleted = true
			elseif configAnswer == blank or configAnswer == "y" then
				SSCore.log("User completed config. Starting write to file.", 1, "Server Core")
				if not cfg.exists("serversquared.serverconfig") then
					SSCore.log("Config does not exist. Creating a new file.", 0, "Server Core")
					cfg.createfile("serversquared.serverconfig")
				end
				SSCore.log("Writing config values to file.", 0, "Server Core")
				cfg.setvalue("serversquared.serverconfig", "serverName", SSCore.serverName)
				cfg.setvalue("serversquared.serverconfig", "serverWebsite", SSCore.serverWebsite)
				SSCore.log("Config saved.", 0, "Server Core")
				io.write("\nConfiguration saved.")
				configCompleted = true
			end
		until configCompleted == true
		
		-- Load configuration if user answered yes previously.
		else
			SSCore.log("Loading configuration from file.", 1, "Server Core")
			SSCore.serverName = cfg.getvalue("serversquared.serverconfig", "serverName")
			SSCore.serverWebsite = cfg.getvalue("serversquared.serverconfig", "serverWebsite")
			SSCore.log("serverName = " .. SSCore.serverName, 0, "Server Core")
			SSCore.log("serverWebsite = " .. SSCore.serverWebsite, 0, "Server Core")
	end
	
	configAnswer = nil
	configCompleted = nil
	
	-- Tell user configuration is complete and we'll take it from here.
	io.write("\nThank you for using (server)^2 Modification!\n")
	io.write("The modification will now continue to load.\n")
end

function fileExists(name)
	SSCore.log("Checking if file exists: " .. name, 0, "Server Core")
	local f = io.open(name, "r")
	if f ~= nil then
		io.close(f)
		SSCore.log("File exists.", 0, "Server Core")
		return true
	else
		SSCore.log("File does not exist.", 0, "Server Core")
		return false
	end
end

function SSCore.sendToServer(data, getReply)
	SSCore.log("Setting socket mode.", 0, "Server Core")
	udp = socket.udp()
	SSCore.log("Setting peer name.", 0, "Server Core")
	udp:setpeername(SSCore.url, 53472)
	udp:settimeout(5)
	SSCore.log("Sending: " .. data, 0, "Server Core")
	udp:send(data)
	if getReply then
		SSCore.log("Waiting for reply...", 0, "Server Core")
		local data, err = udp:receive()
			if data then
				SSCore.log("Reply received: " .. data, 0, "Server Core")
				return true, data
			elseif err then
				SSCore.log("Network error: " .. err, 4, "Server Core")
				return false, "Network error: " .. tostring(err)
			end
	end
	udp:close()
end

function SSCore.checkHash()
	SSCore.log("Calculating SHA-1 hash of the Core...", 2, "Server Core")
	if fileExists("lua/scripts/serversquaredmodificationcore.lua") then
		io.input("lua/scripts/serversquaredmodificationcore.lua")
	elseif fileExists("lua/scripts/serversquaredmodificationcore.luac") then
		io.input("lua/scripts/serversquaredmodificationcore.luac")
	else
		SSCore.log("Could not find the Server Core.", 3, "Server Core")
		return false, "Server Core does not exist?"
	end
	local core = io.read("*all")
	io.input(io.stdin)
	local hash = sha1(core)
	SSCore.log("Calculated: " .. hash, 2, "Server Core")
	return true, hash
end

function SSCore.verify()
	local completed, hash_or_error = SSCore.checkHash()
	if completed then
		SSCore.log("Trying to connect to " .. SSCore.url .. ":53472...", 2, "Server Core")
		local received, msg = SSCore.sendToServer("ping", true)
		if received and msg == "pong" then
			SSCore.log("Connection established.", 2, "Server Core")
			local received, msg = SSCore.sendToServer("verify", true)
			if received and msg == "sendChecksum" then
				local received, msg = SSCore.sendToServer(hash_or_error, true)
				if received and msg == SSCore.versionCore then
					SSCore.log("SHA-1 Checksum is Valid.", 2, "Server Core")
				else
					SSCore.log("Could not verify Core: " .. msg, 4, "Server Core")
					SSCore.log("DO NOT SUBMIT BUG REPORTS OR REPORT CRASHES!", 4, "Server Core")
					SSCore.log("YOU CANNOT RECEIVE SUPPORT FOR THIS COPY OF (server)^2 Modification!", 4, "Server Core")
					SSCore.log("DO NOT DISTRIBUTE THIS COPY OR LEGAL ACTION WILL BE TAKEN!", 4, "Server Core")
					socket.sleep(5)
				end
			else
				SCore.log("Could not verify Core: " .. msg, 4, "Server Core")
			end
		else
			SSCore.log("Connection failed: " .. msg, 4, "Server Core")
			SSCore.log("If your copy of (server)^2 Modification is modded, you may not", 4, "Server Core")
			SSCore.log("submit bug reports or crashes. DO NOT DISTRIBUTE, OR LEGAL", 4, "Server Core")
			SSCore.log("ACTION WILL BE TAKEN!", 4, "Server Core")
			socket.sleep(5)
		end
	else
		SSCore.log("Could not calculate SHA-1 Checksum: " .. hash_or_error, 4, "Server Core")
		SSCore.log("If your copy of (server)^2 Modification is modded, you may not", 4, "Server Core")
		SSCore.log("submit bug reports or crashes. DO NOT DISTRIBUTE, OR LEGAL", 4, "Server Core")
		SSCore.log("ACTION WILL BE TAKEN!", 4, "Server Core")
		socket.sleep(5)
	end
end

-- Handler API
function onPlayerSpawn(CN)
	for tableName, tableValue in pairs(handlerPlayerSpawn) do
		for handlerFunction in pairs(tableValue) do
			handlerPlayerSpawn[tableName][handlerFunction](CN)
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
			handlerPlayerDamage[tableName][handlerFunction](actorCN, targetCN, damage, actorGun, isGib)
		end
	end
end

function onPlayerDeath(targetCN, actorCN, isGib, gun)
	for tableName, tableValue in pairs(handlerPlayerDeath) do
		for handlerFunction in pairs(tableValue) do
			handlerPlayerDeath[tableName][handlerFunction](targetCN, actorCN, isGib, gun)
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
			handlerPlayerTeamChange[tableName][handlerFunction](CN, newTeam, reason)
		end
	end
end

function onPlayerItemPickup(CN, itemType, itemID)
	for tableName, tableValue in pairs(handlerPlayerItemPickup) do
		for handlerFunction in pairs(tableValue) do
			handlerPlayerItemPickup[tableName][handlerFunction](CN, itemType, itemID)
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
			handlerPlayerRoleChange[tableName][handlerFunction](CN, newRole, hash, adminPasswordLine, isConnecting)
		end
	end
end

function onPlayerRoleChangeTry(CN, newRole, hash, isConnecting)
	for tableName, tableValue in pairs(handlerPlayerRoleChangeTry) do
		for handlerFunction in pairs(tableValue) do
			handlerPlayerRoleChangeTry[tableName][handlerFunction](CN, role, hash, isConnecting)
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
			handlerItemRespawn[tableName][handlerFunction](itemID, itemType)
		end
	end
end

function onItemSpawn(itemID, itemType)
	for tableName, tableValue in pairs(handlerItemSpawn) do
		for handlerFunction in pairs(tableValue) do
			handlerItemSpawn[tableName][handlerFunction](itemID, itemType)
		end
	end
end

function onPlayerSayVoice(CN, sound)
	for tableName, tableValue in pairs(handlerPlayerSayVoice) do
		for handlerFunction in pairs(tableValue) do
			handlerPlayerSayVoice[tableName][handlerFunction](CN, sound)
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
			handlerVoteEnd[tableName][handlerFunction](result, ownerCN, voteType, text, number)
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
			handlerPlayerSuicide[tableName][handlerFunction](CN)
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
			handlerWhois[tableName][handlerFunction](actorCN, targetCN)
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
			handlerPlayerBanThresholdReach[tableName][handlerFunction](CN)
		end
	end
end

function onPlayerKickThresholdReach(CN)
	for tableName, tableValue in pairs(handlerPlayerKickThresholdReach) do
		for handlerFunction in pairs(tableValue) do
			handlerPlayerKickThresholdReach[tableName][handlerFunction](CN)
		end
	end
end

function onConfigReread()
	for tableName, tableValue in pairs(handlerConfigReread) do
		for handlerFunction in pairs(tableValue) do
			handlerConfigReread[tableName][handlerFunction]()
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

-- Core Commands
commands = {
	["!loadModule"] = {
		function (CN, args)
			SSCore.log("loadModule command started.", 1, "Server Core")
			if args[2] ~= nil and  ("remove" or "unload") then
				SSCore.log("Unload mode set.", 0, "Server Core")
				unloadModule = true
			else
				unloadModule = false
			end
			SSCore.log("Calling runModule to load the Module.", 0, "Server Core")
			if SSCore.runModule(args[1], unloadModule, true) then
				SSCore.say("Module was loaded successfully.", CN)
			else
				SSCore.say("Module failed to load.", CN)
			end
		end
	},

	["!info"] = {
		function (CN, args)
			SSCore.say(SSCore.serverColours.primary .. "(server)^2 Modification Core " .. SSCore.serverColours.secondary .. "v" .. SSCore.versionCore .. SSCore.serverColours.primary .. " Created by " .. SSCore.serverColours.secondary .. "server", CN)
			SSCore.say(SSCore.serverColours.primary .. "Copyright (C) " .. SSCore.copyright .. " server. All Rights Reserved.", CN)
		end
	},

	["!stop"] = {
		function (CN, args)
			SSCore.log("Shutting down the server (Sent from player: " .. getname(CN) .. ")...", 21, "Server Core")
			os.exit()
		end
	}
}


function onInit()
	SSCore.loadedModules = {}		-- Table of Modules that we've loaded.
	SSCore.init()
	SSCore.log("Done.", 2, "Server Core")
	SSCore.configServer()
end

function onDestroy()
	SSCore.log("The server is being stopped gracefully.", 21, "Server Core")

	-- Let all loaded Modules do anything they need to before the Core stops.
	SSCore.log("Running Module shutdown scripts.", 21, "Server Core")
	for moduleName in pairs(SSCore.loadedModules) do
		SSCore.log("Unloading Module " .. moduleName, 21, "Server Core")
		SSCore.runModule(moduleName, true)
	end

	io.write("Thank you for using (server)^2 Modification.\n")
end