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

menujob = {
    Base = { Header = {"commonmenu", "interaction_bgd"}, Color = {color_black}, HeaderColor = {0, 251, 255}, Title = "Blanchisseur"},
    Data = { currentMenu = "Menu :"},
    Events = {
        onSelected = function(self, _, btn, PMenu, menuData, result)

            if btn.name == "Recruter" then 
                if ESX.PlayerData.job2.grade_name == 'boss'  then
                    Tikozaal.closestPlayer, Tikozaal.closestDistance = ESX.Game.GetClosestPlayer()
                    if Tikozaal.closestPlayer == -1 or Tikozaal.closestDistance > 3.0 then
                        ESX.ShowNotification('Aucun joueur à ~b~proximité')
                    else
                        TriggerServerEvent('Tikoz:BlanchiRecruter', GetPlayerServerId(Tikozaal.closestPlayer), ESX.PlayerData.job2.name, 0)
                    end
                else
                    ESX.ShowNotification('Vous n\'avez pas les ~r~droits~w~')
                end
            elseif btn.name == "Promouvoir" then
                if ESX.PlayerData.job2.grade_name == 'boss' then
                    Tikozaal.closestPlayer, Tikozaal.closestDistance = ESX.Game.GetClosestPlayer()
                    if Tikozaal.closestPlayer == -1 or Tikozaal.closestDistance > 3.0 then
                        ESX.ShowNotification('Aucun joueur à ~b~proximité')
                    else
                        TriggerServerEvent('Tikoz:PromotionBlanchi', GetPlayerServerId(Tikozaal.closestPlayer))
                    end
                else
                    ESX.ShowNotification('Vous n\'avez pas les ~r~droits~w~')
                end
            elseif btn.name == "Virer" then 
                if ESX.PlayerData.job2.grade_name == 'boss' then
                    Tikozaal.closestPlayer, Tikozaal.closestDistance = ESX.Game.GetClosestPlayer()
                    if Tikozaal.closestPlayer == -1 or Tikozaal.closestDistance > 3.0 then
                        ESX.ShowNotification('Aucun joueur à ~b~proximité')
                    else
                        TriggerServerEvent('Tikoz:BlanchiVirer', GetPlayerServerId(Tikozaal.closestPlayer))
                    end
                else
                    ESX.ShowNotification('Vous n\'avez pas les ~r~droits~w~')
                end
            elseif btn.name == "Destituer" then 
                if ESX.PlayerData.job2.grade_name == 'boss' then
                    Tikozaal.closestPlayer, Tikozaal.closestDistance = ESX.Game.GetClosestPlayer()
                    if Tikozaal.closestPlayer == -1 or Tikozaal.closestDistance > 3.0 then
                        ESX.ShowNotification('Aucun joueur à ~b~proximité')
                    else
                        TriggerServerEvent('Tikoz:BlanchiRetrograder', GetPlayerServerId(Tikozaal.closestPlayer))
                    end
                else
                    ESX.ShowNotification('Vous n\'avez pas les ~r~droits~w~')
                end
            end
            
        end,
},
    Menu = {
        ["Menu :"] = {
            b = {
                {name = "Recruter", ask = "", askX = true},
                {name = "Promouvoir", ask = "", askX = true},
                {name = "Virer", ask = "", askX = true},
                {name = "Destituer", ask = "", askX = true},
            }
        }
    }
}

RegisterCommand("blanchi", function() 

    if ESX.PlayerData.job2.name == "blanchi" then
        CreateMenu(menujob)
    else 
        ESX.ShowNotification("Cette commande est réservée aux p ~b~~h~blanchisseurs")
    end

end, false)