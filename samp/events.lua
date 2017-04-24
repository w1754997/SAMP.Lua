-- This file is part of the SAMP.Lua project.
-- Licensed under the MIT License.
-- Copyright (c) 2016, FYP @ BlastHack Team <blast.hk>
-- https://github.com/THE-FYP/SAMP.Lua


local raknet                                  = require 'lib.samp.raknet'
local events                                  = require 'lib.samp.events.core'
local utils                                   = require 'lib.samp.events.utils'
local handler                                 = require 'lib.samp.events.handlers'
                                                require 'lib.samp.events.extra_types'
local RPC                                     = raknet.RPC
local PACKET                                  = raknet.PACKET
local OUTCOMING_RPCS                          = events.INTERFACE.OUTCOMING_RPCS
local OUTCOMING_PACKETS                       = events.INTERFACE.OUTCOMING_PACKETS
local INCOMING_RPCS                           = events.INTERFACE.INCOMING_RPCS
local INCOMING_PACKETS                        = events.INTERFACE.INCOMING_PACKETS

-- Outgoing rpcs
OUTCOMING_RPCS[RPC.ENTERVEHICLE]              = {'onSendEnterVehicle', {vehicleId = 'int16'}, {passenger = 'bool8'}}
OUTCOMING_RPCS[RPC.CLICKPLAYER]               = {'onSendClickPlayer', {playerId = 'int16'}, {source = 'int8'}}
OUTCOMING_RPCS[RPC.CLIENTJOIN]                = {'onSendClientJoin', {version = 'int32'}, {mod = 'int8'}, {nickname = 'string8'}, {joinAuthKey = 'string8'}, {clientVer = 'string8'}}
OUTCOMING_RPCS[RPC.ENTEREDITOBJECT]           = {'onSendEnterEditObject'} -- TODO: find out
OUTCOMING_RPCS[RPC.SERVERCOMMAND]             = {'onSendCommand', {command = 'string32'}}
OUTCOMING_RPCS[RPC.SPAWN]                     = {'onSendSpawn'}
OUTCOMING_RPCS[RPC.DEATH]                     = {'onSendDeathNotification', {reason = 'int8'}, {killerId = 'int16'}}
OUTCOMING_RPCS[RPC.DIALOGRESPONSE]            = {'onSendDialogResponse', {dialogId = 'int16'}, {button = 'int8'}, {listboxId = 'int16'}, {input = 'string8'}}
OUTCOMING_RPCS[RPC.CLICKTEXTDRAW]             = {'onSendClickTextDraw', {textdrawId = 'int16'}}
OUTCOMING_RPCS[RPC.SCMEVENT]                  = {'onSendVehicleTuningNotification', {event = 'int32'}, {vehicleId = 'int32'}, {param1 = 'int32'}, {param2 = 'int32'}}
OUTCOMING_RPCS[RPC.CHAT]                      = {'onSendChat', {message = 'string8'}}
OUTCOMING_RPCS[RPC.CLIENTCHECK]               = {'onSendClientCheckResponse', {'int8'}, {'int32'}, {'int8'}}
OUTCOMING_RPCS[RPC.DAMAGEVEHICLE]             = {'onSendVehicleDamaged', {vehicleId = 'int16'}, {panelDmg = 'int32'}, {doorDmg = 'int32'}, {lights = 'int8'}, {tires = 'int8'}}
OUTCOMING_RPCS[RPC.EDITATTACHEDOBJECT]        = {'onSendEditAttachedObject', {response = 'int32'}, {index = 'int32'}, {model = 'int32'}, {bone = 'int32'}, {position = 'vector3d'}, {rotation = 'vector3d'}, {scale = 'vector3d'}, {color1 = 'int32'}, {color2 = 'int32'}}
OUTCOMING_RPCS[RPC.EDITOBJECT]                = {'onSendEditObject', {playerObject = 'bool'}, {objectId = 'int16'}, {response = 'int32'}, {position = 'vector3d'}, {rotation = 'vector3d'}}
OUTCOMING_RPCS[RPC.SETINTERIORID]             = {'onSendInteriorChangeNotification', {interior = 'int8'}}
OUTCOMING_RPCS[RPC.MAPMARKER]                 = {'onSendMapMarker', {position = 'vector3d'}}
OUTCOMING_RPCS[RPC.REQUESTCLASS]              = {'onSendRequestClass', {classId = 'int32'}}
OUTCOMING_RPCS[RPC.REQUESTSPAWN]              = {'onSendRequestSpawn'}
OUTCOMING_RPCS[RPC.PICKEDUPPICKUP]            = {'onSendPickedUpPickup', {pickupId = 'int32'}}
OUTCOMING_RPCS[RPC.MENUSELECT]                = {'onSendMenuSelect', {row = 'int8'}}
OUTCOMING_RPCS[RPC.VEHICLEDESTROYED]          = {'onSendVehicleDestroyed', {vehicleId = 'int16'}}
OUTCOMING_RPCS[RPC.MENUQUIT]                  = {'onSendQuitMenu'}
OUTCOMING_RPCS[RPC.EXITVEHICLE]               = {'onSendExitVehicle', {vehicleId = 'int16'}}
OUTCOMING_RPCS[RPC.UPDATESCORESPINGSIPS]      = {'onSendUpdateScoresAndPings'}
OUTCOMING_RPCS[RPC.GIVETAKEDAMAGE]            = {
	-- playerId = 'int16', damage = 'float', weapon = 'int32', bodypart ='int32'
	{'onSendGiveDamage',
	function(bs) return handler.send_give_take_damage_reader(bs, false) end,
	function(bs, data) return handler.send_give_take_damage_writer(bs, data, false) end},
	-- playerId = 'int16', damage = 'float', weapon = 'int32', bodypart ='int32'
	{'onSendTakeDamage',
	function(bs) return handler.send_give_take_damage_reader(bs, true) end,
	function(bs, data) return handler.send_give_take_damage_writer(bs, data, true) end}
}

-- Incoming rpcs
-- int playerId, string hostName, table settings, table vehicleModels, int unknown
INCOMING_RPCS[RPC.INITGAME]                   = {'onInitGame', handler.on_init_game_reader, handler.on_init_game_writer}
INCOMING_RPCS[RPC.SERVERJOIN]                 = {'onPlayerJoin', {playerId = 'int16'}, {color = 'int32'}, {isNpc = 'bool8'}, {nickname = 'string8'}}
INCOMING_RPCS[RPC.SERVERQUIT]                 = {'onPlayerQuit', {playerId = 'int16'}, {reason = 'int8'}}
INCOMING_RPCS[RPC.REQUESTCLASS]               = {'onRequestClassResponse', {canSpawn = 'bool8'}, {team = 'int8'}, {skin = 'int32'}, {unk = 'int8'}, {positon = 'vector3d'}, {rotation = 'float'}, {weapons = 'Int32Array3'}, {ammo = 'Int32Array3'}}
INCOMING_RPCS[RPC.REQUESTSPAWN]               = {'onRequestSpawnResponse', {response = 'bool8'}}
INCOMING_RPCS[RPC.SETPLAYERNAME]              = {'onSetPlayerName', {name = 'string8'}} -- TODO: test
INCOMING_RPCS[RPC.SETPLAYERPOS]               = {'onSetPlayerPos', {position = 'vector3d'}}
INCOMING_RPCS[RPC.SETPLAYERPOSFINDZ]          = {'onSetPlayerPosFindZ', {position = 'vector3d'}} -- TODO: test
INCOMING_RPCS[RPC.SETPLAYERHEALTH]            = {'onSetPlayerHealth', {health = 'float'}}
INCOMING_RPCS[RPC.TOGGLEPLAYERCONTROLLABLE]   = {'onTogglePlayerControllable', {controllable = 'bool8'}}
INCOMING_RPCS[RPC.PLAYSOUND]                  = {'onPlaySound', {soundId = 'int32'}, {position = 'vector3d'}} -- TODO: test
INCOMING_RPCS[RPC.SETPLAYERWORLDBOUNDS]       = {'onSetWorldBounds', {squareStart = 'vector2d'}, {squareEnd = 'vector2d'}} -- TODO: test
INCOMING_RPCS[RPC.GIVEPLAYERMONEY]            = {'onGivePlayerMoney', {money = 'int32'}}
INCOMING_RPCS[RPC.SETPLAYERFACINGANGLE]       = {'onSetPlayerFacingAngle', {angle = 'float'}} -- TODO: test
INCOMING_RPCS[RPC.RESETPLAYERMONEY]           = {'onResetPlayerMoney'}
INCOMING_RPCS[RPC.RESETPLAYERWEAPONS]         = {'onResetPlayerWeapons'}
INCOMING_RPCS[RPC.GIVEPLAYERWEAPON]           = {'onGivePlayerWeapon', {weaponId = 'int32'}, {ammo = 'int32'}} -- TODO: test
-- INCOMING_RPCS[RPC.SETVEHICLEPARAMSEX] = {''} -- TODO: test
INCOMING_RPCS[RPC.CANCELEDIT]                 = {'onCancelEdit'} -- TODO: test
INCOMING_RPCS[RPC.SETPLAYERTIME]              = {'onSetWorldTime', {hour = 'int8'}, {minute = 'int8'}} -- TODO: test
INCOMING_RPCS[RPC.TOGGLECLOCK]                = {'onSetToggleClock', {state = 'int8'}} -- TODO: test
INCOMING_RPCS[RPC.WORLDPLAYERADD]             = {'onPlayerStreamIn', {playerId = 'int16'}, {team = 'int8'}, {model = 'int32'}, {position = 'vector3d'}, {rotation = 'float'}, {color = 'int32'}, {fightingStyle = 'int8'}}
INCOMING_RPCS[RPC.SETPLAYERSHOPNAME]          = {'onSetShopName', {text = 'string8'}} -- TODO: test
INCOMING_RPCS[RPC.SETPLAYERSKILLLEVEL]        = {'onSetPlayerSkillLevel', {playerId = 'int16'}, {skill = 'int32'}, {level = 'int16'}} -- TODO: test
INCOMING_RPCS[RPC.SETPLAYERDRUNKLEVEL]        = {'onSetPlayerDrunk', {drunkLevel = 'int32'}} -- TODO: test
INCOMING_RPCS[RPC.CREATE3DTEXTLABEL]          = {'onCreate3DText', {id = 'int16'}, {color = 'int32'}, {position = 'vector3d'}, {distance = 'float'}, {testLOS = 'bool8'}, {attachedPlayerId = 'int16'}, {attachedVehicleId = 'int16'}, {text = 'encodedString4096'}}
INCOMING_RPCS[RPC.DISABLECHECKPOINT]          = {'onDisableCheckpoint'} -- TODO: test
INCOMING_RPCS[RPC.SETRACECHECKPOINT]          = {'onSetRaceCheckpoint', {type = 'int8'}, {firstPosition = 'vector3d'}, {secondPosition = 'vector3d'}, {size = 'float'}} -- TODO: test
INCOMING_RPCS[RPC.DISABLERACECHECKPOINT]      = {'onDisableRaceCheckpoint'} -- TODO: test
INCOMING_RPCS[RPC.GAMEMODERESTART]            = {'onGamemodeRestart'} -- TODO: test
INCOMING_RPCS[RPC.PLAYAUDIOSTREAM]            = {'onPlayAudioStream', {url = 'string8'}, {position = 'vector3d'}, {radius = 'float'}, {usePosition = 'int8'}} -- TODO: test
INCOMING_RPCS[RPC.STOPAUDIOSTREAM]            = {'onStopAudioStream'} -- TODO: test
INCOMING_RPCS[RPC.REMOVEBUILDINGFORPLAYER]    = {'onRemoveBuilding', {modelId = 'int32'}, {position = 'vector3d'}, {radius = 'float'}} -- TODO: test
-- INCOMING_RPCS[RPC.CREATEOBJECT] = {''} -- TODO: test
INCOMING_RPCS[RPC.SETOBJECTPOS]               = {'onSetObjectPosition', {objectId = 'int16'}, {position = 'vector3d'}} -- TODO: test
INCOMING_RPCS[RPC.SETOBJECTROT]               = {'onSetObjectRotation', {objectId = 'int16'}, {rotation = 'vector3d'}} -- TODO: test
INCOMING_RPCS[RPC.DESTROYOBJECT]              = {'onDestroyObject', {objectId = 'int16'}} -- TODO: test
INCOMING_RPCS[RPC.DEATHMESSAGE]               = {'onPlayerDeathNotification', {killerId = 'int16'}, {killedId = 'int16'}, {reason = 'int8'}} -- TODO: test
INCOMING_RPCS[RPC.SETPLAYERMAPICON]           = {'onSetMapIcon', {iconId = 'int8'}, {position = 'vector3d'}, {type = 'int8'}, {color = 'int32'}, {style = 'int8'}} -- TODO: test
INCOMING_RPCS[RPC.REMOVEVEHICLECOMPONENT]     = {'onRemoveVehicleComponent', {vehicleId = 'int16'}, {componentId = 'int16'}} -- TODO: test
INCOMING_RPCS[RPC.UPDATE3DTEXTLABEL]          = {'onRemove3DTextLabel', {textLabelId = 'int16'}} -- TODO: test
INCOMING_RPCS[RPC.CHATBUBBLE]                 = {'onPlayerChatBubble', {playerId = 'int16'}, {color = 'int32'}, {distance = 'float'}, {duration = 'int32'}, {message = 'string8'}}
INCOMING_RPCS[RPC.UPDATETIME]                 = {'onUpdateGlobalTimer', {time = 'int32'}}
INCOMING_RPCS[RPC.SHOWDIALOG]                 = {'onShowDialog', {dialogId = 'int16'}, {style = 'int8'}, {title = 'string8'}, {button1 = 'string8'}, {button2 = 'string8'}, {text = 'encodedString4096'}}
INCOMING_RPCS[RPC.DESTROYPICKUP]              = {'onDestroyPickup', {id = 'int32'}}
INCOMING_RPCS[RPC.LINKVEHICLETOINTERIOR]      = {'onLinkVehicleToInterior', {vehicleId = 'int16'}, {interiorId = 'int8'}} -- TODO: test
INCOMING_RPCS[RPC.SETPLAYERARMOUR]            = {'onSetPlayerArmour', {armour = 'float'}} -- TODO: test
INCOMING_RPCS[RPC.SETPLAYERARMEDWEAPON]       = {'onSetPlayerArmedWeapon', {weaponId = 'int32'}} -- TODO: test
INCOMING_RPCS[RPC.SETSPAWNINFO]               = {'onSetSpawnInfo', {team = 'int8'}, {skin = 'int32'}, {unk = 'int8'}, {position = 'vector3d'}, {rotation = 'float'}, {weapons = 'Int32Array3'}, {ammo = 'Int32Array3'}}
INCOMING_RPCS[RPC.SETPLAYERTEAM]              = {'onSetPlayerTeam', {playerId = 'int16'}, {teamId = 'int8'}} -- TODO: test
INCOMING_RPCS[RPC.PUTPLAYERINVEHICLE]         = {'onPutPlayerInVehicle', {vehicleId = 'int16'}, {seatId = 'int8'}} -- TODO: test
INCOMING_RPCS[RPC.REMOVEPLAYERFROMVEHICLE]    = {'onRemovePlayerFromVehicle'} -- TODO: test
INCOMING_RPCS[RPC.SETPLAYERCOLOR]             = {'onSetPlayerColor', {playerId = 'int16'}, {color = 'int32'}} -- TODO: test
INCOMING_RPCS[RPC.DISPLAYGAMETEXT]            = {'onDisplayGameText', {style = 'int32'}, {time = 'int32'}, {text = 'string8'}}
INCOMING_RPCS[RPC.FORCECLASSSELECTION]        = {'onForceClassSelection'} -- TODO: test - skip
INCOMING_RPCS[RPC.ATTACHOBJECTTOPLAYER]       = {'onAttachObjectToPlayer', {objectId = 'int16'}, {playerId = 'int16'}, {offsets = 'vector3d'}, {rotation = 'vector3d'}} -- TODO: test
-- int menuId, string title, float x, float y, bool twoColumns, table columns, table rows, bool menuUnk
INCOMING_RPCS[RPC.INITMENU]                   = {'onInitMenu', handler.on_init_menu_reader, handler.on_init_menu_writer}
INCOMING_RPCS[RPC.SHOWMENU]                   = {'onShowMenu', {menuId = 'int8'}}
INCOMING_RPCS[RPC.HIDEMENU]                   = {'onHideMenu', {menuId = 'int8'}}
INCOMING_RPCS[RPC.CREATEEXPLOSION]            = {'onCreateExplosion', {position = 'vector3d'}, {style = 'int32'}, {radius = 'float'}} -- TODO: test
INCOMING_RPCS[RPC.SHOWPLAYERNAMETAGFORPLAYER] = {'onShowPlayerNameTag', {playerId = 'int16'}, {state = 'int8'}} -- TODO: test
-- INCOMING_RPCS[RPC.ATTACHCAMERATOOBJECT] = {''} -- TODO: test - skip
-- INCOMING_RPCS[RPC.INTERPOLATECAMERA] = {''} -- TODO: test - skip
-- INCOMING_RPCS[RPC.SETOBJECTMATERIAL] = {''} -- TODO: test
INCOMING_RPCS[RPC.GANGZONESTOPFLASH]          = {'onGangZoneStopFlash', {zoneId = 'int16'}} -- TODO: test
INCOMING_RPCS[RPC.APPLYANIMATION]             = {'onApplyPlayerAnimation', {playerId = 'int16'}, {animLib = 'string8'}, {animName = 'string8'}, {loop = 'bool'}, {lockX = 'bool'}, {lockY = 'bool'}, {freeze = 'bool'}, {time = 'int32'}}
INCOMING_RPCS[RPC.CLEARANIMATIONS]            = {'onClearPlayerAnimation', {playerId = 'int16'}}
INCOMING_RPCS[RPC.SETPLAYERSPECIALACTION]     = {'onSetPlayerSpecialAction', {actionId = 'int8'}} -- TODO: test
INCOMING_RPCS[RPC.SETPLAYERFIGHTINGSTYLE]     = {'onSetPlayerFightingStyle', {playerId = 'int16'}, {styleId = 'int8'}} -- TODO: test
INCOMING_RPCS[RPC.SETPLAYERVELOCITY]          = {'onSetPlayerVelocity', {velocity = 'vector3d'}} -- TODO: test
INCOMING_RPCS[RPC.SETVEHICLEVELOCITY]         = {'onSetVehicleVelocity', {vehicleId = 'int16'}, {velocity = 'vector3d'}} -- TODO: test
INCOMING_RPCS[RPC.CLIENTMESSAGE]              = {'onServerMessage', {color = 'int32'}, {text = 'string32'}}
-- INCOMING_RPCS[RPC.SETWORLDTIME] = {''} -- TODO: test - skip
INCOMING_RPCS[RPC.CREATEPICKUP]               = {'onCreatePickup', {id = 'int32'}, {model = 'int32'}, {pickupType = 'int32'}, {position = 'vector3d'}}
-- INCOMING_RPCS[RPC.MOVEOBJECT] = {''} -- TODO: test - skip
INCOMING_RPCS[RPC.ENABLESTUNTBONUSFORPLAYER]  = {'onEnableStuntBonus', {state = 'int8'}} -- TODO: test
INCOMING_RPCS[RPC.TEXTDRAWSETSTRING]          = {'onTextDrawSetString', {id = 'int16'}, {textLength = 'int16'}, {text = 'string32'}} -- TODO: test
INCOMING_RPCS[RPC.SETCHECKPOINT]              = {'onSetCheckpoint', {position = 'vector3d'}, {radius = 'float'}} -- TODO: test
INCOMING_RPCS[RPC.GANGZONECREATE]             = {'onCreateGangZone', {zoneId = 'int16'}, {squareStart = 'vector2d'}, {squareEnd = 'vector2d'}, {color = 'int32'}} -- TODO: test
INCOMING_RPCS[RPC.PLAYCRIMEREPORT]            = {'onPlayCrimeReport', {suspectId = 'int16'}, {crimeId = 'int8'}} -- TODO: test
-- INCOMING_RPCS[RPC.SETPLAYERATTACHEDOBJECT] = {''} -- TODO: test - skip
INCOMING_RPCS[RPC.GANGZONEDESTROY]            = {'onGangZoneDestroy', {zoneId = 'int16'}} -- TODO: test
INCOMING_RPCS[RPC.GANGZONEFLASH]              = {'onGangZoneFlash', {zoneId = 'int16'}, {color = 'int32'}} -- TODO: test
INCOMING_RPCS[RPC.STOPOBJECT]                 = {'onStopObject', {objectId = 'int16'}} -- TODO: test
INCOMING_RPCS[RPC.SETNUMBERPLATE]             = {'onSetVehicleNumberPlate', {vehicleId = 'int16'}, {text = 'string8'}} -- TODO: test
INCOMING_RPCS[RPC.TOGGLEPLAYERSPECTATING]     = {'onTogglePlayerSpectating', {state = 'int32'}} -- TODO: test
INCOMING_RPCS[RPC.PLAYERSPECTATEPLAYER]       = {'onSpectatePlayer', {playerId = 'int16'}, {camType = 'int8'}} -- TODO: test
INCOMING_RPCS[RPC.PLAYERSPECTATEVEHICLE]      = {'onSpectateVehicle', {vehicleId = 'int16'}, {camType = 'int8'}} -- TODO: test
INCOMING_RPCS[RPC.SETPLAYERWANTEDLEVEL]       = {'onSetPlayerWantedLevel', {wantedLevel = 'int8'}} -- TODO: test
INCOMING_RPCS[RPC.SHOWTEXTDRAW]               = {'onShowTextDraw', {textDrawId = 'int16'}, {flags = 'int8'}, {letterWidth = 'float'}, {letterHeight = 'float'}, {letterColor = 'int32'}, {lineWidth = 'float'}, {lineHeight = 'float'}, {boxColor = 'int32'}, {shadow = 'int8'},
{outline                                      = 'int8'}, {backgroundColor = 'int32'}, {style = 'int8'}, {selectable = 'int8'}, {position = 'vector2d'}, {modelId = 'int16'}, {rotation = 'vector3d'}, {zoom = 'float'}, {color1 = 'int16'}, {color2 = 'int16'}, {text = 'string32'}} -- TODO: test - skip
INCOMING_RPCS[RPC.TEXTDRAWHIDEFORPLAYER]      = {'onTextDrawHide', {textDrawId = 'int16'}} -- TODO: test
INCOMING_RPCS[RPC.REMOVEPLAYERMAPICON]        = {'onRemoveMapIcon', {iconId = 'int8'}} -- TODO: test
INCOMING_RPCS[RPC.SETPLAYERAMMO]              = {'onSetWeaponAmmo', {weaponId = 'int8'}, {bullets = 'int16'}} -- TODO: test
INCOMING_RPCS[RPC.SETGRAVITY]                 = {'onSetGravity', {gravity = 'float'}}
INCOMING_RPCS[RPC.SETVEHICLEHEALTH]           = {'onSetVehicleHealth', {vehicleId = 'int16'}, {health = 'float'}}
INCOMING_RPCS[RPC.ATTACHTRAILERTOVEHICLE]     = {'onAttachTrailerToVehicle', {trailerId = 'int16'}, {vehicleId = 'int16'}} -- TODO: test
INCOMING_RPCS[RPC.DETACHTRAILERFROMVEHICLE]   = {'onDetachTrailerFromVehicle', {vehicleId = 'int16'}} -- TODO: test
INCOMING_RPCS[RPC.SETWEATHER]                 = {'onSetWeather', {weatherId = 'int8'}} -- TODO: test
INCOMING_RPCS[RPC.SETPLAYERSKIN]              = {'onSetPlayerSkin', {playerId = 'int32'}, {skinId = 'int32'}} -- TODO: test
INCOMING_RPCS[RPC.SETPLAYERINTERIOR]          = {'onSetInterior', {interior = 'int8'}}
INCOMING_RPCS[RPC.SETPLAYERCAMERAPOS]         = {'onSetCameraPosition', {position = 'vector3d'}} -- TODO: test
INCOMING_RPCS[RPC.SETPLAYERCAMERALOOKAT]      = {'onSetCameraLookAt', {lookAtPosition = 'vector3d'}, {cutType = 'int8'}} -- TODO: test
INCOMING_RPCS[RPC.SETVEHICLEPOS]              = {'onSetVehiclePosition', {vehicleId = 'int16'}, {position = 'vector3d'}} -- TODO: test
INCOMING_RPCS[RPC.SETVEHICLEZANGLE]           = {'onSetVehicleAngle', {vehicleid = 'int16'}, {angle = 'float'}} -- TODO: test
INCOMING_RPCS[RPC.SETVEHICLEPARAMSFORPLAYER]  = {'onSetVehicleParams', {vehicleId = 'int16'}, {objective = 'int8'}, {doorsLocked = 'int8'}} -- TODO: test
INCOMING_RPCS[RPC.SETCAMERABEHINDPLAYER]      = {'onSetCameraBehind'} -- TODO: test
INCOMING_RPCS[RPC.CHAT]                       = {'onChatMessage', {playerId = 'int16'}, {text = 'string8'}}
INCOMING_RPCS[RPC.CONNECTIONREJECTED]         = {'onConnectionRejected', {reason = 'int8'}}
INCOMING_RPCS[RPC.WORLDPLAYERREMOVE]          = {'onPlayerStreamOut', {playerId = 'int16'}}
INCOMING_RPCS[RPC.WORLDVEHICLEADD]            = {'onVehicleStreamIn', {vehicleId = 'int16'}, {model = 'int32'}, {position = 'vector3d'}, {rotation = 'float'}, {color1 = 'int8'}, {color2 = 'int8'}, {health = 'float'}, {interior = 'int8'}, {locked = 'bool8'}, {panelDamage = 'int32'}, {doorDamage = 'int32'}, {lightsDamage = 'int8'}, {tiresDamage = 'int8'}} -- TODO: Update
INCOMING_RPCS[RPC.WORLDVEHICLEREMOVE]         = {'onVehicleStreamOut', {vehicleId = 'int16'}}
INCOMING_RPCS[RPC.WORLDPLAYERDEATH]           = {'onPlayerDeath', {playerId = 'int16'}}
INCOMING_RPCS[RPC.ENTERVEHICLE]               = {'onPlayerEnterVehicle', {playerId = 'int16'}, {vehicleId = 'int16'}, {passenger = 'bool8'}}
INCOMING_RPCS[RPC.UPDATESCORESPINGSIPS]       = {'onUpdateScoresAndPings', {playerList = 'PlayerScorePingMap'}}

-- Outgoing packets
OUTCOMING_PACKETS[PACKET.RCON_COMMAND]        = {'onSendRconCommand', {command = 'string32'}}
OUTCOMING_PACKETS[PACKET.STATS_UPDATE]        = {'onSendStatsUpdate', {money = 'int32'}, {drunkLevel = 'int32'}}
local function empty_writer() end
OUTCOMING_PACKETS[PACKET.PLAYER_SYNC]         = {'onSendPlayerSync', function(bs) return utils.process_outcoming_sync_data(bs, 'PlayerSyncData') end, empty_writer}
OUTCOMING_PACKETS[PACKET.VEHICLE_SYNC]        = {'onSendVehicleSync', function(bs) return utils.process_outcoming_sync_data(bs, 'VehicleSyncData') end, empty_writer}
OUTCOMING_PACKETS[PACKET.PASSENGER_SYNC]      = {'onSendPassengerSync', function(bs) return utils.process_outcoming_sync_data(bs, 'PassengerSyncData') end, empty_writer}
OUTCOMING_PACKETS[PACKET.AIM_SYNC]            = {'onSendAimSync', function(bs) return utils.process_outcoming_sync_data(bs, 'AimSyncData') end, empty_writer}
OUTCOMING_PACKETS[PACKET.UNOCCUPIED_SYNC]     = {'onSendUnoccupiedSync', function(bs) return utils.process_outcoming_sync_data(bs, 'UnoccupiedSyncData') end, empty_writer}
OUTCOMING_PACKETS[PACKET.TRAILER_SYNC]        = {'onSendTrailerSync', function(bs) return utils.process_outcoming_sync_data(bs, 'TrailerSyncData') end, empty_writer}
OUTCOMING_PACKETS[PACKET.BULLET_SYNC]         = {'onSendBulletSync', function(bs) return utils.process_outcoming_sync_data(bs, 'BulletSyncData') end, empty_writer}
OUTCOMING_PACKETS[PACKET.SPECTATOR_SYNC]      = {'onSendSpectatorSync', function(bs) return utils.process_outcoming_sync_data(bs, 'SpectatorSyncData') end, empty_writer}

-- Incoming packets
INCOMING_PACKETS[PACKET.PLAYER_SYNC]          = {'onPlayerSync', handler.on_player_sync_reader, handler.on_player_sync_writer}
INCOMING_PACKETS[PACKET.VEHICLE_SYNC]         = {'onVehicleSync', handler.on_vehicle_sync_reader, handler.on_vehicle_sync_writer}
INCOMING_PACKETS[PACKET.MARKERS_SYNC]         = {'onMarkersSync', handler.on_markers_sync_reader, handler.on_markers_sync_writer}
INCOMING_PACKETS[PACKET.AIM_SYNC]             = {'onAimSync', {playerId = 'int16'}, {data = 'AimSyncData'}}
INCOMING_PACKETS[PACKET.BULLET_SYNC]          = {'onBulletSync', {playerId = 'int16'}, {data = 'BulletSyncData'}}
INCOMING_PACKETS[PACKET.UNOCCUPIED_SYNC]      = {'onUnoccupiedSync', {playerId = 'int16'}, {data = 'UnoccupiedSyncData'}}
INCOMING_PACKETS[PACKET.TRAILER_SYNC]         = {'onTrailerSync', {playerId = 'int16'}, {data = 'TrailerSyncData'}}
INCOMING_PACKETS[PACKET.PASSENGER_SYNC]       = {'onPassengerSync', {playerId = 'int16'}, {data = 'PassengerSyncData'}}

return events
