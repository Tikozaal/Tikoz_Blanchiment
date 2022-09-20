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


function depotargentblanchi()
    local amount = Keyboardput("Montant", "", 25)
    amount = tonumber(amount)
    if amount == nil then
        ESX.ShowAdvancedNotification('Banque societé', "~b~Bahama's", "Vous avez pas assez ~r~d'argent", 'CHAR_BANK_FLEECA', 9)
    else
        TriggerServerEvent("Tikoz:blanchidepotentreprise", amount)
    end
end

function retraitargentblanchi()
    local amount = Keyboardput("Montant", "", 25)
    amount = tonumber(amount)
    if amount == nil then
        ESX.ShowAdvancedNotification('Banque societé', "~b~Bahama's", "Vous avez pas assez ~r~d'argent", 'CHAR_BANK_FLEECA', 9)
    else
        TriggerServerEvent("Tikoz:blanchiRetraitEntreprise", amount)
    end
end


menuboss = {
    Base = { Header = {"commonmenu", "interaction_bgd"}, Color = {color_black}, HeaderColor = {0, 251, 255}, Title = "blanchi"},
    Data = { currentMenu = "Menu :"},
    Events = {
        onSelected = function(self, _, btn, PMenu, menuData, result)

            ESX.TriggerServerCallback("Tikoz:blanchiArgentEntreprise", function(compteblanchi) 

                if btn.name == "Compte de l'entreprise" then
                    for i=1, #compteblanchi, 1 do 
                        menuboss.Menu["Compte en banque"].b = {}
                        table.insert(menuboss.Menu["Compte en banque"].b, { name = "Déposé de l'argent", ask = "", askX = true})
                        table.insert(menuboss.Menu["Compte en banque"].b, { name = "Retiré de l'argent", ask = "", askX = true})
                        table.insert(menuboss.Menu["Compte en banque"].b, { name = "Argent societé :", ask = "~g~"..compteblanchi[i].money.."$", askX = true})
                    end
                    OpenMenu('Compte en banque')
                end

            end, args)

            if btn.name == "Déposé de l'argent" then
                depotargentblanchi()
                OpenMenu('Menu :')
            elseif btn.name == "Retiré de l'argent" then
                retraitargentblanchi()
                OpenMenu('Menu :')

            end
        
            ESX.TriggerServerCallback('Tikoz:blanchisalaire', function(salaireblanchi) 
               

                if btn.name == "Salaire employé" then
                    menuboss.Menu["Salaire"].b = {}
                    for i=1, #salaireblanchi, 1 do
                        if salaireblanchi[i].job_name == "blanchi" then
                            table.insert(menuboss.Menu["Salaire"].b, { name = salaireblanchi[i].label, ask = "~g~"..salaireblanchi[i].salary.."$", askX = true})
                        end
                    end
                    OpenMenu('Salaire')
                end

                for i=1, #salaireblanchi, 1 do
                    if btn.name == salaireblanchi[i].label then
                        if salaireblanchi[i].job_name == "blanchi" then
                            local amount = Keyboardput("Quelle est le nouveau salaire ? ", "", 15)
                            local label = salaireblanchi[i].label
                            local id = salaireblanchi[i].id
                            TriggerServerEvent('Tikoz:blanchiNouveauSalaire', id, label, amount)
                            OpenMenu("Menu :")
                            return
                        end
                    end
                end

            end, args)
            
            
          

        end,
},
    Menu = {
        ["Menu :"] = {
            b = {
                {name = "Compte de l'entreprise", ask = ">", askX = true},
                {name = "Salaire employé", ask = ">", askX = true},
            }
        },
        ["Compte en banque"] = {
            b = {
            }
        },
        ["Liste des employés"] = {
            b = {
            }
        },
        ["Salaire"] = {
            b = {
            }
        },
    }
}

Citizen.CreateThread(function()

    while true do 

        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local menu = Config.Pos.Boss
        local dist = #(pos - menu)

        if dist <= 2 and ESX.PlayerData.job2.name == "blanchi" and ESX.PlayerData.job2.grade_name == "boss" then

            ESX.ShowHelpNotification("Appuie sur ~INPUT_CONTEXT~ pour ouvrir le ~b~menu")
            DrawMarker(6, menu, nil, nil, nil, -90, nil, nil, 0.7, 0.7, 0.7, 0, 251, 255, 200, false, true, 2, false, false, false, false)

            if IsControlJustPressed(1, 51) then
                CreateMenu(menuboss)
            end

        else
            Citizen.Wait(1000)
        end
        Citizen.Wait(0)
    end
end)
