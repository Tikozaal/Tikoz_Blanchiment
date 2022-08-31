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


function Keyboardput(TextEntry, ExampleText, MaxStringLength) 
    AddTextEntry('FMMC_KEY_TIP1', TextEntry .. ':')
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
    blockinput = true
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        blockinput = false
        return result
    else
        Citizen.Wait(500)
        blockinput = false
        return nil
    end
end

menublanchi = {
    Base = { Header = {"commonmenu", "interaction_bgd"}, Color = {color_black}, HeaderColor = {0, 251, 255}, Title = "Blanchisseur"},
    Data = { currentMenu = "Menu :"},
    Events = {
        onSelected = function(self, _, btn, PMenu, menuData, result)

            if btn.name == "Blanchir de l'argent sale" then
                local amount = Keyboardput("Combien voulez-vous blanchir ? ", "", 15)
                local ped = PlayerPedId()
                    
                RequestAnimDict("missmechanic")
                while not HasAnimDictLoaded("missmechanic") do 
                    Citizen.Wait(0) 
                end
                SetBlockingOfNonTemporaryEvents(ped, true)
                TaskPlayAnim(ped, "missmechanic", "work2_base", 1.0,-1.0, 15000, 1, 1, true, true, true)

                TriggerServerEvent('Tikoz:BlanchimentJob', amount)
                CloseMenu()
                
            elseif btn.name == "~r~Fermé" then
                CloseMenu()
            end
        end,
},
    Menu = {
        ["Menu :"] = {
            b = {
                {name = "Blanchir de l'argent sale", ask = "", askX = true},
                {name = "~r~Fermé", ask = "", askX = true},
            }
        }
    }
}

Citizen.CreateThread(function()

    while true do 

        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local menu = Config.Pos.Blanchiment
        local dist = #(pos - menu)
        
        if Config.Job == true then
            if dist <= 2 and ESX.PlayerData.job2.name == "blanchi" then

            ESX.ShowHelpNotification("Appuie sur ~INPUT_CONTEXT~ pour ouvrir le ~b~menu")
            DrawMarker(6, menu, nil, nil, nil, -90, nil, nil, 0.7, 0.7, 0.7, 0, 251, 255, 200, false, true, 2, false, false, false, false)

                if IsControlJustPressed(1, 51) then
                    CreateMenu(menublanchi)
                end
            else
                Citizen.Wait(1000)
            end

        else 

            if dist <= 2 then

                ESX.ShowHelpNotification("Appuie sur ~INPUT_CONTEXT~ pour ouvrir le ~b~menu")
                DrawMarker(6, menu, nil, nil, nil, -90, nil, nil, 0.7, 0.7, 0.7, 0, 251, 255, 200, false, true, 2, false, false, false, false)
    
                if IsControlJustPressed(1, 51) then
                    CreateMenu(menublanchi)
                end
            else
                Citizen.Wait(1000)
            end
        end
        Citizen.Wait(0)
    end
end)