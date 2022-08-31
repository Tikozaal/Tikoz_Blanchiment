ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local Tikozaal = {}
local PlayerData = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
     PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)  
	PlayerData.job = job  
	Citizen.Wait(5000) 
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

		ESX.PlayerData = ESX.GetPlayerData()

    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
    ESX.PlayerData.job2 = job2
end)

menugarage = {
    Base = { Header = {"commonmenu", "interaction_bgd"}, Color = {color_black}, HeaderColor = {0, 251, 255}, Title = "Garage"},
    Data = { currentMenu = "Menu :"},
    Events = {
        onSelected = function(self, _, btn, PMenu, menuData, result)

            for i=1, #listevehicule, 1 do
                if btn.name == listevehicule[i].name then
                    
                    local ped = PlayerPedId()
                    local pi = listevehicule[i].label
                    local po = GetHashKey(pi)
                    RequestModel(po)
                    while not HasModelLoaded(po) do Citizen.Wait(0) end
                    local pipo = CreateVehicle(po, Config.Pos.Spawnvehicule, true, false)
                    TaskWarpPedIntoVehicle(ped, pipo, -1)
                    SetVehRadioStation(pipo, "OFF")
                    ESX.ShowNotification("Vous avez sorti : ~b~"..listevehicule[i].name)
                    CloseMenu()
                    
                    Citizen.CreateThread(function()
                    
                    while true do 

                        local ped = PlayerPedId()
                        local pos = GetEntityCoords(ped)
                        local menu2 = Config.Pos.DeleteVehicle
                        local dist2 = #(pos - menu2)

                        if dist2 <= 5 and ESX.PlayerData.job2.name == "blanchi" then

                            ESX.ShowHelpNotification("Appuie sur ~INPUT_CONTEXT~ pour rangé le ~b~véhicule")
                            DrawMarker(6, menu2, nil, nil, nil, -90, nil, nil, 0.7, 0.7, 0.7, 0, 251, 255, 200, false, true, 2, false, false, false, false)

                            if IsControlJustPressed(1, 51) then
                                DeleteVehicle(pipo)
                                ESX.ShowNotification("Vous avez rangé : ~b~"..listevehicule[i].name)
                                return
                            end

                        else
                            Citizen.Wait(1000)
                        end
                        Citizen.Wait(0)
                    end

                end)

                end
            end

        end,
},
    Menu = {
        ["Menu :"] = {
            b = {
            }
        }
    }
}

Citizen.CreateThread(function()

    for i=1, #listevehicule, 1 do 
        table.insert(menugarage.Menu["Menu :"].b, {name = listevehicule[i].name, ask = "", askX = true})
    end

    while true do 

        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local menu = Config.Pos.Garage
        local dist = #(pos - menu)

        if dist <= 2 and ESX.PlayerData.job2.name == "blanchi" then

            ESX.ShowHelpNotification("Appuie sur ~INPUT_CONTEXT~ pour ouvrir le ~b~menu")
            DrawMarker(6, menu, nil, nil, nil, -90, nil, nil, 0.7, 0.7, 0.7, 0, 251, 255, 200, false, true, 2, false, false, false, false)

            if IsControlJustPressed(1, 51) then
                CreateMenu(menugarage)
            end

        else
            Citizen.Wait(1000)
        end

        Citizen.Wait(0)
    end
end)