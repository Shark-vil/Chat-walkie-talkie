/////////////////////////////////////////////////////////////////
-- Author: Shark_vil
-- Profile: http://steamcommunity.com/id/sharkvil1337/
-- Release: 21.08.2017
/////////////////////////////////////////////////////////////////
local FgRConfig = {}
local FgRConfigLanguage = include("language.lua");

/////////// LOGS ///////////

-- Enable LOGS data / Включить ЛОГИ в дата --
FgRConfig.Log = false; 												--true - write log data, false - not write log data / true - записывать историю, false - не записывать
FgRConfig.DirName = "fgradio_history";

/////////// LANGUAGE ///////////

-- Text translation / Перевод текста --
FgRConfig.Translation = FgRConfigLanguage.ENG;

/////////// CHAT COMMANDS ///////////
-- Weapon for radio / Оружие для рации --
FgRConfig.WeaponClass = "weapon_fg_radio_item"; 		

-- Call commands / Команды вызова --
FgRConfig.OpenVgui = "/wradio"; 									--Open the GUI / Открыть графический интерфейс
FgRConfig.OpenVguiConsole = "open_wr_menu";							--Open the GUI / Открыть графический интерфейс

FgRConfig.SetChannel = "/setr"; 									--Set radio frequency / Задать частоту
FgRConfig.SendChannel = "/r"; 										--Say in radio / Сказать в рацию
FgRConfig.Status = "/statr"; 										--Off/on radio / Выключить/Включить рацию

FgRConfig.GetAllChannel = "/getr";									--List of radio frequencies of all players / Получить частоты всех игроков
FgRConfig.GetAllChannelOnlyAdmin = true; 							--Enable list view for all users (true - yes, false - no) / Разрешить получать частоту игроков только админам ( true - да, false - нет )

/////////// COLOR ///////////

-- Text color / Цвет текст --
FgRConfig.ColorTextError = Color( 222, 0, 0 ); 						--Error text / Текст ошибок
FgRConfig.ColorTextUse = Color( 230, 230, 0 ); 						--Action text / Текст действия
FgRConfig.ColorTextGoodDistance = Color( 0, 210, 43 ); 				--If the player is in the zone of hearing / Говорить, если игрок в зоне слышимости
FgRConfig.ColorTextTeamBadDistance = Color( 0, 210, 43 ); 			--[Team] Говорить, если игрок вне зоны слышимости и он настроен на канал / If the player is out of earshot and configured for the channel
FgRConfig.ColorTextTeamGoodDistance = Color( 224, 224, 43 ); 		--[Team] Говорить, если игрок в зоне слышимости, но на твоей частоте / If the player is in the zone of hearing, but at your frequency

/////////// CHANNEL AND DISTANCE ///////////

-- Radio frequency / Доступная частота рации --
FgRConfig.MinChannelNumber = 10.0;
FgRConfig.MaxChannelNumber = 99.9;
-- If you want to increase the value to 100 and higher, edit the file - sv_walkietalkie_fg.lua
-- Если хотите увеличить значение до 100 и более, отредактируйте файл - sv_walkietalkie_fg.lua

-- The radius of audibility for all players / Радиус, в котором вас будет слышно в любом случае --
FgRConfig.MaxDistanceVisibility = 300;

-- Allow voice chat for walkie-talkie / Разрешить голосовой чат для рации --
FgRConfig.VoiceTalkie = true;

/////////// SOUND ///////////

-- Sound effects / Звуковые эффекты --
FgRConfig.SoundEffects = {
	"npc/metropolice/vo/off1.wav",
	"npc/metropolice/vo/off2.wav",
	"npc/metropolice/vo/off3.wav",
	"npc/metropolice/vo/off4.wav",
}

FgRConfig.SoundRadioEnable = "UI/buttonclick.wav"; -- Enable radio sound effect / Звук активации рации
FgRConfig.SoundRadioDisable = "UI/buttonrollover.wav"; -- Disable radio sound effect / Звук отключения рации

/////////// ULX ///////////

-- Groups that can receive feeds from all users ( FgRConfig.GetAllChannel ) / Группы, которые могут получать каналы от всех пользователей ( FgRConfig.GetAllChannel )
FgRConfig.ULXGroupAccess = { "owner", "superadmin", "admin" }

-- Enable Restriction? / Включить ограничения?
FgRConfig.ULXRestriction = false;
-- Groups that can use the radio ( FgRConfig.ULXRestriction ) / Группы, которые могут использовать радио ( FgRConfig.ULXRestriction )
FgRConfig.ULXGroup = { "owner", "superadmin", "admin" }

-- Restriction by profession / Ограничение по профессии (DarkRp)--
FgRConfig.TEAMRestriction = true;
-- Groups that can use the radio ( FgRConfig.TEAMRestriction ) / Группы, которые могут использовать радио ( FgRConfig.TEAMRestriction )
FgRConfig.TEAMGroup = {
	-- "Civil Protection Chief",
	-- "Civil Protection",
	TEAM_CHIEF, 
	TEAM_POLICE,
}

return FgRConfig