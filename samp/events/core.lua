-- This file is part of the SAMP.Lua project.
-- Licensed under the MIT License.
-- Copyright (c) 2016, FYP @ BlastHack Team <blast.hk>
-- https://github.com/THE-FYP/SAMP.Lua


local MODULE = {
	MODULEINFO = {
		name = 'samp.events',
		version = 2
	},
	INTERFACE = {
		OUTCOMING_RPCS    = {},
		OUTCOMING_PACKETS = {},
		INCOMING_RPCS     = {},
		INCOMING_PACKETS  = {}
	},
	EXPORTS = {}
}

-- check dependencies
assert(isSampLoaded(), 'SA:MP is not loaded')
assert(isSampfuncsLoaded(), 'samp.events requires SAMPFUNCS')
assert(getMoonloaderVersion() >= 20, 'samp.events requires MoonLoader v.020 or greater')

local OUTCOMING_RPCS         = MODULE.INTERFACE.OUTCOMING_RPCS
local OUTCOMING_PACKETS      = MODULE.INTERFACE.OUTCOMING_PACKETS
local INCOMING_RPCS          = MODULE.INTERFACE.INCOMING_RPCS
local INCOMING_PACKETS       = MODULE.INTERFACE.INCOMING_PACKETS
local BitStreamIO            = require 'lib.samp.events.bitstream_io'
MODULE.INTERFACE.BitStreamIO = BitStreamIO


local function process_event(bs, callback, struct, ignorebits)
	local args = {}
	if bs ~= 0 then
		if ignorebits then
			-- skip packet id
			raknetBitStreamIgnoreBits(bs, ignorebits)
		end

		if type(struct[2]) == 'function' then
			args = struct[2](bs) -- call custom reading function
			if args == false then
				-- stop processing if custom reader returns false
				raknetBitStreamResetReadPointer(bs)
				return
			end
		else
			-- skip event name
			for i = 2, #struct do
				local _, t = next(struct[i]) -- type
				table.insert(args, BitStreamIO[t].read(bs))
			end
		end
	end
	local result = callback(unpack(args))
	if result == false then
		return false -- consume packet
	end
	if bs ~= 0 and type(result) == 'table' then
		raknetBitStreamSetWriteOffset(bs, ignorebits or 0)
		if type(struct[3]) == 'function' then
			struct[3](bs, result) -- call custom writing function
		else
			assert(#struct - 1 == #result)
			for i = 2, #struct do
				local _, t = next(struct[i]) -- type
				BitStreamIO[t].write(bs, result[i - 1])
			end
		end
	end
end

local function process_packet(id, bs, event_table, ignorebits)
	local entry = event_table[id]
	if entry ~= nil then
		if type(entry[1]) ~= 'table' then
			if type(MODULE[entry[1]]) == 'function' then
				if process_event(bs, MODULE[entry[1]], entry, ignorebits) == false then
					return false
				end
			end
		else
			for _, item in pairs(entry) do
				if type(MODULE[item[1]]) == 'function' then
					if process_event(bs, MODULE[item[1]], item, ignorebits) == false then
						return false
					end
				end
			end
		end
	end
end


local function samp_on_send_rpc(id, bitStream, priority, reliability, orderingChannel, shiftTs)
	if process_packet(id, bitStream, OUTCOMING_RPCS) == false then return false end
end

local function samp_on_send_packet(id, bitStream, priority, reliability, orderingChannel)
	if process_packet(id, bitStream, OUTCOMING_PACKETS, 8) == false then return false end
end

local function samp_on_receive_rpc(id, bitStream)
	if process_packet(id, bitStream, INCOMING_RPCS) == false then return false end
end

local function samp_on_receive_packet(id, bitStream)
	if process_packet(id, bitStream, INCOMING_PACKETS, 8) == false then return false end
end

addEventHandler('onSendRpc', samp_on_send_rpc)
addEventHandler('onSendPacket', samp_on_send_packet)
addEventHandler('onReceiveRpc', samp_on_receive_rpc)
addEventHandler('onReceivePacket', samp_on_receive_packet)

return MODULE
