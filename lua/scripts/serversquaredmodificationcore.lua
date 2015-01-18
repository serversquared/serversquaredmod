PLUGIN_NAME = "(server)^2 Modification"
PLUGIN_AUTHOR = "server"
PLUGIN_VERSION = "9.0.0" -- In development!
ALPHA = true
BETA = false
BUILD_DATE = "16 January 2015"
COPYRIGHT_REGISTRATION_YEAR = "2015"
SS_SITE = "serversquared.noip.me"

--[[ ################################################################
Copyright (C) server - All Rights Reserved.
This work is licensed under the Creative
Commons Attribution-NoDerivatives 4.0 International
License. To view a copy of this license,
visit http://creativecommons.org/licenses/by-nd/4.0/.
Written by server <serversquaredmain@gmail.com>, January 2015.
     ################################################################   ]]

-- Logging control
SSLog = {
logMod = true,					-- Turn on or off mod logging.
debugMode = true,				-- Turn on or off debug (verbose) mode. This WILL write to the log.
logInfo = true					-- Turn on or off logging "INFO" level messages.
}

-- Function to write the log.
function serverLog(message, level, sender)
	-- Do not continue if logging is off
	if not SSLog.logMod then
		return
	end
	-- Log and print message, warn if incorrect syntax.
	if level == 0  and message ~= nil and sender ~= nil and SSLog.debugMode then
		print("[" .. os.date("%X") .. "] [" .. sender .. "/DEBUG]: " .. message)
		logline(level, "[" .. os.date("%X") .. "] [" .. sender .. "/DEBUG]: " .. message)
	elseif level == 1  and message ~= nil and sender ~= nil and SSLog.debugMode then
		print("[" .. os.date("%X") .. "] [" .. sender .. "/DEBUG]: " .. message)
		logline(level, "[" .. os.date("%X") .. "] [" .. sender .. "/DEBUG]: " .. message)
	elseif level == 2  and message ~= nil and sender ~= nil and SSLog.logInfo then
		logline(level, "[" .. os.date("%X") .. "] [" .. sender .. "/INFO]: " .. message)
	elseif level == 3  and message ~= nil and sender ~= nil then
		logline(level, "[" .. os.date("%X") .. "] [" .. sender .. "/WARN]: " .. message)
	elseif level == 4  and message ~= nil and sender ~= nil then
		logline(level, "[" .. os.date("%X") .. "] [" .. sender .. "/ERROR]: " .. message)
	elseif level == 20  and message ~= nil and sender ~= nil then
		logline(4, "[" .. os.date("%X") .. "] [" .. sender .. "/FATAL]: " .. message)
	elseif level == 21  and message ~= nil and sender ~= nil then
		logline(2, "[" .. os.date("%X") .. "] [" .. sender .. "/SHUTDOWN]: " .. message)
	elseif level == 22  and message ~= nil and sender ~= nil then
		logline(1, "[" .. os.date("%X") .. "] [" .. sender .. "/CHAT]: " .. message)
	else
		logline(3, "[" .. os.date("%X") .. "] [Server Core/WARN]: Log message was sent in the incorrect syntax.")
	end
end

-- Define blank to help prevent errors, space to make spaces more readable.
blank = ""
space = " "

-- Include the AssaultCube server core.
include("ac_server")

-- Load LuaSocket
socket = require("socket")

-- Load Lua-Ex
require("ex")

function onInit()
	serverLog("Initializing the Modification.", 2, "Server Core")
	-- Load our variables.
	serverLog("Loading Global configuration variables.", 1, "Server Core")
	SSConfig = {
	textEcho = false,				-- Global echo back coloured text.
	colouredText = true,			-- Allow or disallow coloured chat.
	useAdminSystem = false,			-- Use an external Administration system.
	useMuteSystem = false,			-- Use an external player muting system.
	useChatFilter = false			-- Use an external chat filter system.
	}
	for k,v in pairs(SSConfig) do
		serverLog(k .. " = " .. (v and "true" or "false"), 0, "Server Core")
	end
	-- Initialize our tables.
	serverLog("Initializing table of loaded Modules.", 1, "Server Core")
	loadedModules = {}				-- Table of Modules that we've loaded.
	serverLog("Loading server colour configuration.", 1, "Server Core")
	serverColour = {				-- Table of colours for the server.
	"\f4",							-- Primary colour.
	"\f3",							-- Secondary colour.
	"\f0",							-- Public chat colour.
	"\f1"							-- Team chat colour.
	}
	for k,v in pairs(serverColour) do
		v = string.gsub(v, "\f", "\\f")
		serverLog(k .. " = " .. v, 0, "Server Core")
	end

	-- Present a friendly message for the server configuration interface.
	serverLog("Writing configuration interface.", 1, "Server Core")
	io.write("\nWelcome to (server)^2 Modification version " .. PLUGIN_VERSION .. "!")
	if ALPHA or BETA then io.write("\n********************\n/!\\ WARNING /!\\\nTHIS BUILD IS INCOMPLETE AND MAY CAUSE STABILITY ISSUES!\nUSE AT YOUR OWN RISK!\n********************") end
	io.write("\nPlease report any bugs to the issue tracker at:")
	io.write("\nhttps://github.com/account3r2/serversquaredmod/issues")
	io.write("\nLet's configure your server.")
	io.write("\n============================================================")
	-- Get current working directory
	serverLog("Getting Current Working Directory.", 1, "Server Core")
	ACPath = os.currentdir()
	serverLog("We are here: " .. ACPath, 0, "Server Core")
	-- Should we load a configuration file?
	repeat
		io.write("\nLoad from config file? Answer n if you don't have one. (y/n)")
		io.write("\n>")
		configAnswer = io.read()
		if configAnswer == "n" then
			loadFromConfig = false
		elseif configAnswer == blank or configAnswer == "y" then
			loadFromConfig = true
		end
	until loadFromConfig ~= nil
	-- Finish configuring the server if user answered no.
	if not loadFromConfig then
	serverLog("User wants to create a new config.", 1, "Server Core")
		-- What should the server be called?
		io.write("\nWhat would you like your server to be called?")
		io.write("\nUse the server colour codes if desired.")
		io.write("\n>")
		serverName = (io.read() or blank)
		-- Get the user website for our API.
		io.write("\nWhat's your website URL?")
		io.write("\n>")
		serverWebsite = (io.read() or blank)
		-- Make it easier on the user and offer a config save.
		repeat
			io.write("\nWould you like to save your configuration?")
			io.write("\n>")
			configAnswer = io.read()
			if configAnswer == "n" then
				serverLog("User completed config, and does not want to save to file.", 1, "Server Core")
				configCompleted = true
			elseif configAnswer == blank or configAnswer == "y" then
				serverLog("User completed config. Starting write to file.", 1, "Server Core")
				if not cfg.exists("serversquared.serverconfig") then
					serverLog("Config does not exist. Creating a new file.", 0, "Server Core")
					cfg.createfile("serversquared.serverconfig")
				end
				serverLog("Writing config values to file.", 0, "Server Core")
				cfg.setvalue("serversquared.serverconfig", "serverName", serverName)
				cfg.setvalue("serversquared.serverconfig", "serverWebsite", serverWebsite)
				serverLog("Config saved.", 0, "Server Core")
				io.write("\nConfiguration saved.")
				configCompleted = true
			end
		until configCompleted == true
		
		-- Load configuration if user answered yes previously.
		else
			serverLog("Loading configuration from file.", 1, "Server Core")
			serverName = cfg.getvalue("serversquared.serverconfig", "serverName")
			serverWebsite = cfg.getvalue("serversquared.serverconfig", "serverWebsite")
			serverLog("serverName = " .. serverName, 0, "Server Core")
			serverLog("serverWebsite = " .. serverWebsite, 0, "Server Core")
	end
	-- Tell user configuration is complete and we'll take it from here.
	io.write("\nThank you for using (server)^2 Modification!")
	io.write("\nThe modification will now continue to load.\n")
	
	-- Core functions.
	-- Make it easier to talk to the players.
	function say(text, toCN, excludeCN)
		serverLog("Starting say function.", 1, "Server Core")
		if toCN == nil then
			serverLog("Recipient was not given, making the message global.", 0, "Server Core")
			toCN = -1
		end
		if excludeCN == nil then
			serverLog("Excluded client was not given, making the message global.", 0, "Server Core")
			excludeCN = -1
		end
		if text == nil then
			serverLog("Text was not given, sending a blank message.", 0, "Server Core")
			text = blank
		end
		serverLog("Printing to " .. toCN .. " excluding " .. excludeCN, 1, "Server Core")
		clientprint(toCN, text, excludeCN)
	end

	-- Run a Module.
	function runModule(moduleName)
		serverLog("Starting runModule function.", 1, "Server Core")
		local loadStartTick = getsvtick()
		serverLog("Loading Module" .. (unloadModule and " in unload mode" or blank) .. ": " .. moduleName, 2, "Server Core")
		if pcall(dofile, "lua/scripts/SSModules/" .. moduleName .. ".ssm") then
			local loadTime = (getsvtick() - loadStartTick)
			serverLog("Successfully loaded Module in " .. loadTime .. "ms.", 2, "Server Core")
			if unloadModule then
				loadedModules[moduleName] = nil
				serverLog("Removed module from loadedModules table.", 0, "Server Core")
			else
				loadedModules[moduleName] = true
				serverLog("Added Module to loadedModules table.", 0, "Server Core")
			end
		else
			serverLog("Error loading Module.", 2, "Server Core")
			end
	end

	-- Chat printing
	function printChat(text, CN, chatPrefix, isTeam, isMe)
		print("[" .. os.date("%X") .. "] [" .. getip(CN) .. "] " .. (isTeam and "[TEAM] " or blank) .. (isMe and "[ME] " or blank) .. getname(CN) .. " (" .. CN .. ") says: \"" .. text .. "\"")
		serverLog("[" .. getip(CN) .. "] " .. (isTeam and "[TEAM] " or blank) .. (isMe and "[ME] " or blank) .. getname(CN) .. " (" .. CN .. ") says: \"" .. text .. "\"", 22, "Server Core")
		if isTeam then
			for x=0,maxclient(),1 do
				if getteam(CN) == getteam(x) and CN ~= x then
					say(serverColour[1] .. CN .. "\f3" .. chatPrefix .. serverColour[2] .. "#" .. (isMe and serverColour[4] or "\f5") .. getname(CN) .. serverColour[4] .. (isMe and space or ": ") .. text, x, (SSConfig.textEcho and -1 or CN))
				end
			end
		else
			say(serverColour[1] .. CN .. "\f3" .. chatPrefix .. serverColour[2] .. "#" .. (isMe and serverColour[3] or "\f5") .. getname(CN) .. serverColour[3] .. (isMe and space or ": ") .. text, -1, (SSConfig.textEcho and -1 or CN))
		end
	end

	-- Chat decoding and processing. Chat and commands will probably break if this is changed by a Module, unless they know what they're doing.
	function onPlayerSayText(CN, text, isTeam, isMe)
		serverLog("Starting processing client chat.", 1, "Server Core")
		-- Initialize chatPrefix.
		serverLog("Setting chat prefix to blank.", 0, "Server Core")
		chatPrefix = blank
		
		-- Make a Server Master prefix if using default admin system.
		if isadmin(CN) then
			serverLog("Client is logged in as the server administrator, not using modded system. Setting prefix to @.", 0, "Server Core")
			chatPrefix = "@"
		end
		
		-- Use dynamic prefixes if using our external Administration system.
		if SSConfig.useAdminSystem then
			serverLog("Server is using modded admin system, checking for permissions.", 0, "Server Core")
			if modModerator[getname(CN)] then
				serverLog("Client has Moderator permissions. Setting prefix to M.", 0, "Server Core")
				chatPrefix = "M"
			end
			if modAdministrator[getip(CN)] then
				serverLog("Client has Administrator permissions. Setting prefix to A.", 0, "Server Core")
				chatPrefix = "A"
			end
			if modMaster[getip(CN)] then
				serverLog("Client has Master permissions. Setting prefix to @.", 0, "Server Core")
				chatPrefix = "@"
			end
		end
		
		-- Block muted clients if using our external Muting system.
		if SSConfig.useMuteSystem then
			serverLog("Server is using modded mute system, if client is muted.", 0, "Server Core")
			if isMuted[getip(CN)] then
				serverLog("Client is muted, stopping chat processing.", 0, "Server Core")
				blockChatReason = "Client is muted."
				serverLog("Sending chat to mute system to take over chat processing.", 0, "Server Core")
				blockChat(CN, text, isTeam, isMe, blockChatReason)
				return PLUGIN_BLOCK
			end
		end
		
		-- Test for profanity if using a filter system.
		if SSConfig.useChatFilter then
			serverLog("Server is using modded profanity filter, checking for bloked words.", 0, "Server Core")
			if not chatIsClean(text) then
				serverLog("Chat contains a blocked word, stopping chat processing.", 0, "Server Core")
				blockChatReason = "Chat contains profanity."
				serverLog("Sending chat to filter system to take over chat processing.", 0, "Server Core")
				blockChat(CN, text, isTeam, isMe, blockChatReason)
				return PLUGIN_BLOCK
			end
		end
		
		-- Convert colour codes if enabled on our server.
		if SSConfig.colouredText then
			serverLog("Server has coloured text enabled, reprocessing and converting colour codes.", 0, "Server Core")
			text = string.gsub(text, "\\f", "\f")
		end
		
		-- Split the text into an array.
		serverLog("Converting the sent chat into a table for command processing.", 0, "Server Core")
		local array = split(text, " ")
		-- Separate the command from the arguments.
		serverLog("Separating the command (first table entry) from the arguments.", 0, "Server Core")
		local command, args = array[1], slice(array, 2)
		-- Check if the text is a command, execute if it is.
		if commands[command] ~= nil then
			serverLog("Chat is a command, processing from command list.", 1, "Server Core")
			local callback = commands[command][1]
			callback(CN, args)
			return PLUGIN_BLOCK
		elseif string.byte(command,1) == string.byte("!",1) then
			serverLog("Chat is not a command but in command notation. Stopping chat processing.", 1, "Server Core")
			print("Not a command: \"" .. command .. "\"")
			return PLUGIN_BLOCK		
		end
		
		-- Chat function
		serverLog("Initial chat processing complete, sending to printChat to determine teams and /me.", 1, "Server Core")
		printChat(text, CN, chatPrefix, isTeam, isMe)
		return PLUGIN_BLOCK
	end
end

-- Core Commands
commands = {
	["!loadModule"] = {
	function (CN, args)
		serverLog("loadModule command started.", 1, "Server Core")
		if args[2] ~= nil and  ("remove" or "unload") then 
			serverLog("Unload mode set.", 0, "Server Core")
			unloadModule = true
		else
			unloadModule = false
		end
		serverLog("Calling runModule to load the Module.", 0, "Server Core")
		runModule(args[1])
		unloadModule = nil
	end
	};
	
	["!stop"] = {
	function (CN, args)
		serverLog("Shutting down the server (Sent from player: " .. getname(CN) .. ")...", 21, "Server Core")
		os.exit()
	end
	};
}

function onDestroy()
	serverLog("The server is being stopped gracefully.", 21, "Server Core")
end