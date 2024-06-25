-- Toggle this to enable the use of the big map (That doesn't work together with the LAMBDA ASI)
local UseBigMap = true
-- Change this to change the big map toggle key while on foot (More Controls at http://docs.fivem.net/game-references/controls/)
local BigMapKeyOnFoot = 19
-- Change this to change the big map toggle key while in a vehicle (More Controls at http://docs.fivem.net/game-references/controls/)
local BigMapKeyInVehicle = 131
-- Change this to false to disable the big map in vehicles
local BigMapInVehicles = true
-- Change this to false to enable the radar for every passenger
local OnlyDriver = false
local showhud = true

function showHud(state)
	showhud = state
end


local Hide = false

local MM = GetMinimapAnchor()
local minimapAnchor = GetMinimapAnchor()

-- BAR COLORS
local BackgroundBar = {['R'] = 0, ['G'] = 0, ['B'] = 0, ['A'] = 125, ['L'] = 1}

local HealthBaseBar = {['R'] = 57, ['G'] = 102, ['B'] = 57, ['A'] = 175, ['L'] = 2}
local HealthBar = {['R'] = 114, ['G'] = 204, ['B'] = 114, ['A'] = 175, ['L'] = 3}

local HealthHitBaseBar = {['R'] = 112, ['G'] = 25, ['B'] = 25, ['A'] = 175}
local HealthHitBar = {['R'] = 224, ['G'] = 50, ['B'] = 50, ['A'] = 175}

local ArmourBaseBar = {['R'] = 47, ['G'] = 92, ['B'] = 115, ['A'] = 175, ['L'] = 2}
local ArmourBar = {['R'] = 93, ['G'] = 182, ['B'] = 229, ['A'] = 175, ['L'] = 3}

local StressBaseBar = {['R'] = 215, ['G'] = 180, ['B'] = 10, ['A'] = 125, ['L'] = 3}
local StressBar = {['R'] = 255, ['G'] = 150, ['B'] = 0, ['A'] = 255, ['L'] = 3}

local VoiceBaseBar = {['R'] = 100, ['G'] = 50, ['B'] = 100, ['A'] = 125, ['L'] = 3}
local VoiceBar = {['R'] = 90, ['G'] = 15, ['B'] = 125, ['A'] = 255, ['L'] = 3}

local AirBaseBar = {['R'] = 67, ['G'] = 106, ['B'] = 130, ['A'] = 175, ['L'] = 2}
local AirBar = {['R'] = 174, ['G'] = 219, ['B'] = 242, ['A'] = 175, ['L'] = 3}
-- BAR COLORS

local VoiceLevel = 66
local PlayerStress = 0


RegisterNetEvent('sw_hud:updateStress')
AddEventHandler('sw_hud:updateStress', function(newStress)
	PlayerStress = tonumber(newStress)
end)

local playerPedId = PlayerPedId()
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		playerPedId = PlayerPedId()
	end
end)

local isInFuckinCar = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(400)
		isInFuckinCar = IsPedInAnyVehicle(playerPedId, true)
		minimapAnchor = GetMinimapAnchor()
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if isInFuckinCar then
			DisplayRadar(true)
			if IsControlPressed(1, BigMapKeyInVehicle) then
				--SetRadarBigmapEnabled(true, false)
				SetBigmapActive(true, false)
			else
				 --SetRadarBigmapEnabled(false, false)
				SetBigmapActive(false, false)
			end
		else
			if IsControlPressed(1, BigMapKeyOnFoot) then
				DisplayRadar(true)
				--SetRadarBigmapEnabled(true, false)
				SetBigmapActive(true, false)
			else
				DisplayRadar(false)
				--SetRadarBigmapEnabled(false, false)
				SetBigmapActive(false, false)
			end
		end
	end
end)

--Getting health etc
local PlayerHealth = 0
local PlayerArmour = 0
local PlayerStamina = 0
local sprintOrRun = 0
local underWater = 0

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		PlayerHealth = GetEntityHealth(playerPedId)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		PlayerArmour = GetPedArmour(playerPedId)
		PlayerStamina = GetPlayerSprintStaminaRemaining(PlayerId())
		sprintOrRun = IsPedRunning(playerPedId) or IsPedSprinting(playerPedId)
		underWater = IsPedSwimmingUnderWater(playerPedId)
	end
end)



Citizen.CreateThread(function()
    while true do
		Citizen.Wait(4)
		if(showhud) then
			local MM = minimapAnchor
			local BarY = MM.bottom_y - ((MM.yunit * 18.0) * 0.5)
			local BarSecondY = MM.bottom_y + ((MM.yunit * 12.0) * 0.5)
			local BackgroundBarH = MM.yunit * 18.0
			local BackgroundSecondBarH = MM.yunit * 12.0
			local BarH = BackgroundBarH / 2
			local BarSpacer = MM.xunit * 3.0

			local BackgroundBarW = MM.width
			local BackgroundBarX = MM.x + (MM.width / 2)

			local StressBaseBarW = (MM.width / 2) - (BarSpacer / 2) + 0.00006
			local StressBaseBarX = MM.x + (StressBaseBarW / 2)
			--local StressBarW = ((MM.width / 2) - (BarSpacer / 2)) / 100 * PlayerStress

			local StressBarW = (MM.width / 2) - (BarSpacer / 2)
			if PlayerStress >= 0 and PlayerStress < 100  then
				StressBarW = ((MM.width / 2) - (BarSpacer / 2)) / 100 * (PlayerStress)
			elseif PlayerStress == 100 then
				StressBarW = (MM.width / 2) - (BarSpacer / 2)
			end

			local StressBarX = MM.x + (StressBarW / 2)
			--local StressBarX = MM.x - ((MM.width / 2) - (BarSpacer / 2)) + (StressBarW / 2)


			_DrawRect(StressBaseBarX, BarSecondY, StressBaseBarW, BarH, StressBaseBar.R, StressBaseBar.G, StressBaseBar.B, StressBaseBar.A, StressBaseBar.L)
			_DrawRect(StressBarX, BarSecondY, StressBarW, BarH, StressBar.R, StressBar.G, StressBar.B, StressBar.A, StressBar.L)

			local VoiceBaseBarW = (MM.width / 2) - (BarSpacer / 2)
			local VoiceBaseBarX = MM.right_x - (VoiceBaseBarW / 2)

			local VoiceBarW = (MM.width / 2) - (BarSpacer / 2)
			if VoiceLevel > 0 and VoiceLevel < 100  then
				VoiceBarW = ((MM.width / 2) - (BarSpacer / 2)) / 100 * (VoiceLevel)
			elseif PlayerStress == 100 then
				VoiceBarW = (MM.width / 2) - (BarSpacer / 2)
			end

			local VoiceBarX = MM.right_x - ((MM.width / 2) - (BarSpacer / 2)) + (VoiceBarW / 2)

			_DrawRect(VoiceBaseBarX, BarSecondY, VoiceBaseBarW, BarH, VoiceBaseBar.R, VoiceBaseBar.G, VoiceBaseBar.B, VoiceBaseBar.A, VoiceBaseBar.L)
			_DrawRect(VoiceBarX, BarSecondY, VoiceBarW, BarH, VoiceBar.R, VoiceBar.G, VoiceBar.B, VoiceBar.A, VoiceBar.L)

			_DrawRect(BackgroundBarX, BarSecondY, BackgroundBarW, BackgroundSecondBarH, BackgroundBar.R, BackgroundBar.G, BackgroundBar.B, BackgroundBar.A, BackgroundBar.L)


			if not isInFuckinCar then

				_DrawRect(BackgroundBarX, BarY, BackgroundBarW, BackgroundBarH, BackgroundBar.R, BackgroundBar.G, BackgroundBar.B, BackgroundBar.A, BackgroundBar.L)

				local HealthBaseBarW = (MM.width / 2) - (BarSpacer / 2)
				local HealthBaseBarX = MM.x + (HealthBaseBarW / 2)
				local HealthBaseBarR, HealthBaseBarG, HealthBaseBarB, HealthBaseBarA = HealthBaseBar.R, HealthBaseBar.G, HealthBaseBar.B, HealthBaseBar.A
				local HealthBarW = (MM.width / 2) - (BarSpacer / 2)
				if PlayerHealth == nil then
					PlayerHealth = 0
				end

				if PlayerHealth < GetEntityMaxHealth(playerPedId) and PlayerHealth > 100 then
					HealthBarW = ((MM.width / 2) - (BarSpacer / 2)) / (GetEntityMaxHealth(playerPedId) - 100) * (PlayerHealth - 100)
				elseif PlayerHealth < 100 then
					HealthBarW = 0
				end
				local HealthBarX = MM.x + (HealthBarW / 2)
				local HealthBarR, HealthBarG, HealthBarB, HealthBarA = HealthBar.R, HealthBar.G, HealthBar.B, HealthBar.A
				if PlayerHealth <= 118 or (PlayerStamina >= 90.0 and sprintOrRun) then
					HealthBaseBarR, HealthBaseBarG, HealthBaseBarB, HealthBaseBarA = HealthHitBaseBar.R, HealthHitBaseBar.G, HealthHitBaseBar.B, HealthHitBaseBar.A
					HealthBarR, HealthBarG, HealthBarB, HealthBarA = HealthHitBar.R, HealthHitBar.G, HealthHitBar.B, HealthHitBar.A
				end

				_DrawRect(HealthBaseBarX, BarY, HealthBaseBarW, BarH, HealthBaseBarR, HealthBaseBarG, HealthBaseBarB, HealthBaseBarA, HealthBaseBar.L)
				_DrawRect(HealthBarX, BarY, HealthBarW, BarH, HealthBarR, HealthBarG, HealthBarB, HealthBarA, HealthBar.L)

				if not underWater then
					local ArmourBaseBarW = (MM.width / 2) - (BarSpacer / 2)
					local ArmourBaseBarX = MM.right_x - (ArmourBaseBarW / 2)
					local ArmourBarW = ((MM.width / 2) - (BarSpacer / 2)) / 100 * PlayerArmour
					local ArmourBarX = MM.right_x - ((MM.width / 2) - (BarSpacer / 2)) + (ArmourBarW / 2)

					_DrawRect(ArmourBaseBarX, BarY, ArmourBaseBarW, BarH, ArmourBaseBar.R, ArmourBaseBar.G, ArmourBaseBar.B, ArmourBaseBar.A, ArmourBaseBar.L)
					_DrawRect(ArmourBarX, BarY, ArmourBarW, BarH, ArmourBar.R, ArmourBar.G, ArmourBar.B, ArmourBar.A, ArmourBar.L)
				else
					local ArmourBaseBarW = (((MM.width / 2) - (BarSpacer / 2)) / 2) - (BarSpacer / 2)
					local ArmourBaseBarX = MM.right_x - (((MM.width / 2) - (BarSpacer / 2)) / 2) - (ArmourBaseBarW / 2) - (BarSpacer / 2)
					local ArmourBarW = ((((MM.width / 2) - (BarSpacer / 2)) / 2) - (BarSpacer / 2)) / 100 * PlayerArmour
					local ArmourBarX = MM.right_x - ((MM.width / 2) - (BarSpacer / 2)) + (ArmourBarW / 2)

					_DrawRect(ArmourBaseBarX, BarY, ArmourBaseBarW, BarH, ArmourBaseBar.R, ArmourBaseBar.G, ArmourBaseBar.B, ArmourBaseBar.A, ArmourBaseBar.L)
					_DrawRect(ArmourBarX, BarY, ArmourBarW, BarH, ArmourBar.R, ArmourBar.G, ArmourBar.B, ArmourBar.A, ArmourBar.L)

					local AirBaseBarW = (((MM.width / 2) - (BarSpacer / 2)) / 2) - (BarSpacer / 2)
					local AirBaseBarX = MM.right_x - (AirBaseBarW / 2)
					local Air = GetPlayerUnderwaterTimeRemaining(PlayerId())
					if Air < 0.0 then
						Air = 0.0
					end
					local AirBarW = ((((MM.width / 2) - (BarSpacer / 2)) / 2) - (BarSpacer / 2)) / 10.0 * Air
					local AirBarX = MM.right_x - ((((MM.width / 2) - (BarSpacer / 2)) / 2) - (BarSpacer / 2)) + (AirBarW / 2)

					_DrawRect(AirBaseBarX, BarY, AirBaseBarW, BarH, AirBaseBar.R, AirBaseBar.G, AirBaseBar.B, AirBaseBar.A, AirBaseBar.L)
					_DrawRect(AirBarX, BarY, AirBarW, BarH, AirBar.R, AirBar.G, AirBar.B, AirBar.A, AirBar.L)
				end
			end
		end
	end
end)

--Citizen.CreateThread(function()
--	while true do
--		Citizen.Wait(100)
--		if (NetworkIsPlayerTalking(PlayerId())) then
--			-- VoiceBar = {['R'] = 205, ['G'] = 90, ['B'] = 255, ['A'] = 255, ['L'] = 2}
--			VoiceBar = {['R'] = 165, ['G'] = 0, ['B'] = 245, ['A'] = 255, ['L'] = 2}
--		else
--			VoiceBar = {['R'] = 90, ['G'] = 15, ['B'] = 125, ['A'] = 255, ['L'] = 2}
--		end
--	end
--end)


function _DrawRect(X, Y, W, H, R, G, B, A, L)
	SetUiLayer(L)
	DrawRect(X, Y, W, H, R, G, B, A)
end

-- VOICE
local voice = {default = 7.0, shout = 25.0, whisper = 2.0, current = 0, level = nil, metres = nil}

voice.metres = "7m"
voice.current = 0
NetworkSetTalkerProximity(0.01)
--Citizen.CreateThread(function()
--	while true do
--    	Citizen.Wait(5)
--		if IsControlJustPressed(1, 303) and IsControlPressed(1, 303) then
--			voice.current = (voice.current + 1) % 3
--			if voice.current == 0 then
--				NetworkSetTalkerProximity(voice.default)
--				voice.metres = "7m"
--				VoiceLevel = 66
--			elseif voice.current == 1 then
--				NetworkSetTalkerProximity(voice.shout)
--				voice.metres = "25"
--				VoiceLevel = 100
--			elseif voice.current == 2 then
--				NetworkSetTalkerProximity(voice.whisper)
--				voice.metres = "2m"
--				VoiceLevel = 33
--			end
--		end
--  	end
--end)


-- Volá tokovoip
function changeVoiceLevel(data)
	VoiceLevel = data
	--if(data == 1) then
	--	VoiceLevel = 33
	--elseif(data == 2) then
	--	VoiceLevel = 66
	--else
	--	VoiceLevel = 100
	--end
end

function isTalking(data)
	if(data) then
		VoiceBar = {['R'] = 165, ['G'] = 0, ['B'] = 245, ['A'] = 255, ['L'] = 2}
	else
		VoiceBar = {['R'] = 90, ['G'] = 15, ['B'] = 125, ['A'] = 255, ['L'] = 2}
	end
end
