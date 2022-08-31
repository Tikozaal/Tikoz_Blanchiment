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

menucoffre = {
    Base = { Header = {"commonmenu", "interaction_bgd"}, Color = {color_black}, HeaderColor = {0, 251 ,255}, Title = "Coffre"},
    Data = { currentMenu = "Menu :"},
    Events = {
        onSelected = function(self, _, btn, PMenu, menuData, result)

            ESX.TriggerServerCallback("Tikoz:InventaireBlanchi", function(inventory) 
                if btn.name == "Déposé" then
                
                    menucoffre.Menu["Déposé"].b = {}

                    for i=1, #inventory.items, 1 do 
                        local item = inventory.items[i]
                        
                        if item.count > 0 then
                            table.insert(menucoffre.Menu["Déposé"].b, { name = item.name, ask = "~b~x"..item.count, askX = true})
                        end
    
                    end
                    OpenMenu("Déposé")
                end

                for i=1, #inventory.items, 1 do 
                    local item = inventory.items[i]

                    if btn.name == item.name then
                       
                        count = Keyboardput("Combien voulez vous déposé ? ", "", 15)
                        TriggerServerEvent('Tikoz:CoffreDeposeBlanchi', item.name, tonumber(count))
                        OpenMenu("Menu :")

                    end

                end

            end)

            ESX.TriggerServerCallback("Tikoz:InventaireSocietyBlanchi", function(items)
                
               itemstock = {} 
               itemstock = items

               if btn.name == "Retiré" then
                    menucoffre.Menu["Retiré"].b = {}

                    for i=1, #itemstock, 1 do

                        if itemstock[i].count > 0 then
                            table.insert(menucoffre.Menu["Retiré"].b, { name = itemstock[i].label, ask = "~b~x"..itemstock[i].count, askX = true})
                        end
                    end
                    OpenMenu("Retiré")
                end
            

                for i=1, #itemstock, 1 do 
                
                    if btn.name == itemstock[i].label then
                    
                        itemLabel = itemstock[i].label
                        count = Keyboardput("Combien voulez vous déposé ? ", "", 15)
                        TriggerServerEvent('Tikoz:RetireCoffreBlanchi', itemstock[i].name, tonumber(count), itemLabel)
                        OpenMenu("Menu :")
                    end

                end

            end)

        end,
},
    Menu = {
        ["Menu :"] = {
            b = {
                {name = "Déposé", ask = ">", askX = true},
                {name = "Retiré", ask = ">", askX = true},
            }
        },
        ["Déposé"] = {
            b = {
            }
        },
        ["Retiré"] = {
            b = {
            }
        },
    }
}


Citizen.CreateThread(function()

    while true do 
       
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local menu = Config.Pos.Coffre
        local dist = #(pos - menu)

        if dist <= 2 and ESX.PlayerData.job2.name == "blanchi" then

            ESX.ShowHelpNotification("Appuie sur ~INPUT_CONTEXT~ pour ouvrir le ~b~coffre")
            DrawMarker(6, menu, nil, nil, nil, -90, nil, nil, 0.7, 0.7, 0.7, 0, 251, 255, 200, false, true, 2, false, false, false, false)

            if IsControlJustPressed(1, 51) then
                CreateMenu(menucoffre)
            end

        else
            Citizen.Wait(1000)
        end
        Citizen.Wait(0)
    end
end)