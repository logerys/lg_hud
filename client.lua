--local PlayerData              = {}
local movie = false
local showhud = true
local UI = { x =  0.000 ,  y = -0.001 }
--ESX = nil


function AddTextEntry(key, value)
	Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), key, value)
end

function ToggleNews(state)
  if(state == "on") then
    showhud = false
    DisplayHud(false)
  else
    showhud = true
    DisplayHud(true)
  end
  showHud(showhud)
  Citizen.CreateThread(function()
  while (showhud == false) do
    HideHUDThisFrame()
    HideHudComponentThisFrame(1)
    HideHudComponentThisFrame(2)
    HideHudComponentThisFrame(3)
    HideHudComponentThisFrame(4)
    HideHudComponentThisFrame(6)
    HideHudComponentThisFrame(7)
    HideHudComponentThisFrame(8)
    HideHudComponentThisFrame(9)
    HideHudComponentThisFrame(13)
    HideHudComponentThisFrame(17)
    Citizen.Wait(5)
	end
end)
end

RegisterCommand('hud', function(source, args, rawCommand)
  local state = 'on'
  if not showhud then
    state = 'off'
    lib.notify({
      title = 'HUD',
      description = 'Úspěšně sis zapnul hud',
      type = 'success'
  })
  else
    lib.notify({
      title = 'HUD',
      description = 'Úspěšně sis vypnul hud',
      type = 'error'
  })
  end
  print(state)
  ToggleNews(state)
end, false)


RegisterCommand("movie", function(source, args, rawCommand)
  if movie == true then
    movie = false
	  TriggerEvent('chat:toggleChat', true)
  else
    movie = true
	  TriggerEvent('chat:toggleChat')
  end
end, false)

Citizen.CreateThread(function()
	while true do
    Citizen.Wait(1)
    ClearPedInPauseMenu()
    ShowPedInPauseMenu(false)
  end
end)

-- MOVIE view

Citizen.CreateThread(function()
	while true do
    Citizen.Wait(5)
		if movie then
			HideHUDThisFrame()
			drawRct(UI.x + 0.0, 	UI.y + 0.0, 1.0,0.15,0,0,0,255) -- Top Bar
			drawRct(UI.x + 0.0, 	UI.y + 0.85, 1.0,0.151,0,0,0,255) -- Bottom Bar
		end
	end
end)

--hides native hud components
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    HideHudComponentThisFrame(1)
    HideHudComponentThisFrame(2)
    HideHudComponentThisFrame(3)
    HideHudComponentThisFrame(4)
    HideHudComponentThisFrame(6)
    HideHudComponentThisFrame(7)
    HideHudComponentThisFrame(8)
    HideHudComponentThisFrame(9)
    HideHudComponentThisFrame(13)
    HideHudComponentThisFrame(17)
    HideHudComponentThisFrame(19)
    HideHudComponentThisFrame(20)
    HideHudComponentThisFrame(21)
    HideHudComponentThisFrame(22)
    --HudForceWeaponWheel(false)
    --HideHudAndRadarThisFrame()
    HudWeaponWheelIgnoreSelection()
    DisableControlAction(0, 37, true);
  end
end)

--hides another native hud components for the movie view
function HideHUDThisFrame()

	HideHelpTextThisFrame()
	HideHudAndRadarThisFrame()
	HideHudComponentThisFrame(11)
	HideHudComponentThisFrame(12)
	HideHudComponentThisFrame(15)
	HideHudComponentThisFrame(18)
	HideHudComponentThisFrame(19)
end

local oldHud = false

RegisterCommand('oldhud', function()
  oldHud = not oldHud
  SendNUIMessage({
    action = 'hide'
  })
  vehState = false
end)

function getMapLoc()
  SetScriptGfxAlign(string.byte('L'), string.byte('B'))
  local minimapTopX, minimapTopY = GetScriptGfxPosition(-0.0045, 0.002 + (-0.188888))
  ResetScriptGfxAlign()
  local w, h = GetActiveScreenResolution()
  local ui = GetMinimapAnchor()

  return { x = w * (minimapTopX + 0.0045), y = h * minimapTopY, width = ui.width * w }
end

local inVehicle = false
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(150)
    if movie == false and showhud == true and showhud then
      local ped = GetPlayerPed(-1)
      if(IsPedInAnyVehicle(ped, false))then
        inVehicle = true
      else
        inVehicle = false
      end
    end
  end
end)

-- SPEED
local Speed = 0
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(5)
    if movie == false and showhud == true and inVehicle then
      Speed = GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false)) * 2.225
    else
      Speed = false
    end
	end
end)

local vehState = false

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(200)
    local playerPed = PlayerPedId()
    if(IsPedInAnyVehicle(playerPed)) and not oldHud and showhud then
      if(vehState == false) then
        SendNUIMessage({
          action = 'show',
          mapLoc = getMapLoc()
        })
        vehState = true
      end
    else
      if(vehState == true) then
        SendNUIMessage({
          action = 'hide'
        })
        vehState = false
      end
    end
  end
end)

local oldSpeed = -1

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(30)
    if(oldSpeed ~= Speed) and not oldhud then
      SendNUIMessage({
        action = 'updateSpeed',
        speed = Speed
      })
      oldSpeed = Speed
    end

    if not Speed then
      Citizen.Wait(800)
    end
  end
end)

local oldFuel = -1

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(300)
    if(oldFuel ~= _fuel) then
      SendNUIMessage({
        action = 'updateFuel',
        fuel = _fuel
      })
      oldFuel = _fuel
    end
  end
end)

local planeLowFuel = false
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    if planeLowFuel then
      lib.notify({
        title = 'HUD',
        description = 'Dochází ti palivo',
        type = 'success'
    })
      Citizen.Wait(60000)
    end
    planeLowFuel = false
  end
end)


-- SPEED
stressToAdd = 0
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(2000)
    if Speed and math.ceil(Speed) >= 90 and isVehicleAllowedForStress(GetPlayersLastVehicle()) then
      stressToAdd = stressToAdd + 0.3
    end
	end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(30000)
    if stressToAdd > 0 then
      TriggerServerEvent('sw_stress:add', stressToAdd)
      stressToAdd = 0
    end
	end
end)

-- FUEL
_fuel = nil
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1000)
    _fuel = nil
    local ped = GetPlayerPed(-1)
    if inVehicle and GetSeatPedIsIn(ped) == -1 then

      local vehicle = GetPlayersLastVehicle()
      local vehicleClass = GetVehicleClass(vehicle)
      if vehicleClass ~= 13 and vehicleClass ~= 14 then
        local fuel    = math.ceil(round(GetVehicleFuelLevel(vehicle), 1))
        if vehicleClass == 15 or vehicleClass == 16 then
          if fuel < 20 then
            planeLowFuel = true
          end
        end

        if fuel == 0 then
          fuel = "0"
        end
        _fuel = fuel
      else
        _fuel = "100"
      end
    end
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    if oldHud and movie == false and showhud == true and inVehicle then
      drawRct(UI.x + 0.11, 	UI.y + 0.932, 0.046,0.03,0,0,0,150) -- Speed panel
    end
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    if oldHud and Speed and movie == false and showhud == true and inVehicle then
      drawSpeedTxt(UI.x + 0.61, 	UI.y + 1.42, 1.0,1.0,0.64 , "~w~" .. math.ceil(Speed), 255, 255, 255, 255)
      drawSpeedTxt(UI.x + 0.636, 	UI.y + 1.432, 1.0,1.0,0.4, "~w~ mph", 255, 255, 255, 255)
    end
  end
end)

-- FUEL
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
    if oldHud and movie == false and showhud == true then
      if _fuel ~= nil then
        x = 0.01135
        y = 0.002
        DrawAdvancedText(0.245 - x, 0.918 - y, 0.005, 0.0028, 0.6, _fuel, 255, 255, 255, 255, 6, 1)
        DrawAdvancedText(0.228 - x, 0.932 - y, 0.005, 0.0028, 0.3, "Palivo:", 255, 255, 255, 255, 6, 1)
      end
    end
	end
end)


function isVehicleAllowedForStress(vehicle)
  local class = GetVehicleClass(vehicle)
  if class == 14 or class == 15 or class == 16 or class == 21 then
    return false
  end

  return true
end

function GetSeatPedIsIn(ped)
	local vehicle = GetVehiclePedIsIn(ped, false)

	for i = -2, GetVehicleMaxNumberOfPassengers(vehicle) do
		if GetPedInVehicleSeat(vehicle, i) == ped then
			return i
		end
	end

	return -2
end


function round(num, numDecimalPlaces)
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

-----------------
-- draw functions
-----------------

function drawRct(x,y,width,height,r,g,b,a)
  SetUiLayer(5)
	DrawRect(x + width/2, y + height/2, width, height, r, g, b, a)
end
-- TODO SPLIT THESE DRAW TEXT TOGETHER
function drawTxt(text)
  SetUiLayer(5)
  SetTextFont(6)
  SetTextProportional(0)
  SetTextScale(0.40, 0.40)
  SetTextColour(255, 255, 255, 255)
  SetTextDropShadow(0, 0, 0, 0,255)
  SetTextEdge(1, 0, 0, 0, 255)
  SetTextDropShadow()
  SetTextOutline()
  SetTextEntry("STRING")
  AddTextComponentString(text)
  DrawText(0.001, 0)
end

function drawLevel(r, g, b, a)
  SetUiLayer(5)
  SetTextFont(6)
  SetTextProportional(1)
  SetTextScale(0.425, 0.425)
  SetTextColour(r, g, b, a)
  SetTextDropShadow(0, 0, 0, 0, 255)
  SetTextEdge(1, 0, 0, 0, 255)
  SetTextDropShadow()
  SetTextOutline()
  SetTextEntry("STRING")
  AddTextComponentString("~s~" .. voice.metres)
  DrawText(0.001, 0.961)
end

function drawSpeedTxt(x,y ,width,height,scale, text, r,g,b,a)
  SetUiLayer(5)
  SetTextFont(4)
  SetTextProportional(0)
  SetTextScale(scale, scale)
  SetTextColour(r, g, b, a)
  SetTextDropShadow(0, 0, 0, 0,255)
  SetTextEdge(2, 0, 0, 0, 255)
  SetTextDropShadow()
  SetTextOutline()
  SetTextEntry("STRING")
  AddTextComponentString(text)
  DrawText(x - width/2, y - height/2 + 0.005)
end

function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)
    SetUiLayer(5)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(sc, sc)
	N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
	DrawText(x - 0.1+w, y - 0.02+h)
end
