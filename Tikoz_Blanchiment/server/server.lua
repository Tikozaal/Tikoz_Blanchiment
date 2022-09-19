ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_society:registerSociety', 'blanchi', 'blanchi', 'society_blanchi', 'society_blanchi', 'society_blanchi', {type = 'public'})

TriggerEvent('esx_addonaccount:getSharedAccount', 'society_blanchi', function(account)
	societyAccount = account
end)


RegisterServerEvent("Tikoz:BlanchimentJob")
AddEventHandler("Tikoz:BlanchimentJob", function(amount)
	local xPlayer = ESX.GetPlayerFromId(source)
    local cbsale = xPlayer.getAccount('black_money').money
    
    local taxe = 1 -- La valeur 1.43 est pour être taxé de 30%, pour ne pas être taxé la valeur est 1

    local amount = ESX.Math.Round(tonumber(amount))
    local pourcentage = amount / taxe
    local propre = ESX.Math.Round(tonumber(pourcentage))

    if amount > 0 and cbsale >= amount then

        xPlayer.removeAccountMoney('black_money', amount)    
        TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, 'Blanchiment', "~b~Argent sale", "Vous blanchissez : ~r~"..amount.."$", 'CHAR_LESTER_DEATHWISH', 9)

        Citizen.Wait(15000)

        xPlayer.addMoney(propre)
        TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, 'Blanchiment', "~b~Argent sale", "Vous avez récupéré : ~g~"..propre.."$", 'CHAR_LESTER_DEATHWISH', 9)
    else
        TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, 'Blanchiment', "~b~Argent sale", "Vous avez pas assez ~r~d'argent sale", 'CHAR_LESTER_DEATHWISH', 9)
    end
end)

-------------------- COFFRE ------------------------

ESX.RegisterServerCallback('Tikoz:InventaireBlanchi', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb({items = items})
end)

RegisterServerEvent("Tikoz:CoffreDeposeBlanchi")
AddEventHandler("Tikoz:CoffreDeposeBlanchi", function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_blanchi', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showNotification', _source, "Vous avez déposé ~y~x"..count.." ~b~"..inventoryItem.label)
		else
			TriggerClientEvent('esx:showNotification', _source, "quantité invalide")
		end
	end)
end)

ESX.RegisterServerCallback('Tikoz:InventaireSocietyBlanchi', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_blanchi', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterNetEvent('Tikoz:RetireCoffreBlanchi')
AddEventHandler('Tikoz:RetireCoffreBlanchi', function(itemName, count, itemLabel)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_blanchi', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		if count > 0 and inventoryItem.count >= count then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', _source, "Vous avez retiré ~y~x"..count.." ~b~"..itemLabel)
		else
			TriggerClientEvent('esx:showNotification', _source, "Quantité invalide")
		end
	end)
end)



---------------------------------- PATRON ----------------------------------

ESX.RegisterServerCallback('Tikoz:blanchisalaire', function(source, cb)

    local xPlayer = ESX.GetPlayerFromId(source)
    local salaireblanchi = {}

    MySQL.Async.fetchAll('SELECT * FROM job_grades', {

    }, function(result)

        for i=1, #result, 1 do

            table.insert(salaireblanchi, {
				id = result[i].id,
                job_name = result[i].job_name,
                label = result[i].label,
                salary = result[i].salary,
            })
        end
        cb(salaireblanchi)
    end)
end)

RegisterServerEvent("Tikoz:blanchiNouveauSalaire")
AddEventHandler("Tikoz:blanchiNouveauSalaire", function(id, label, amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    MySQL.Async.fetchAll("UPDATE job_grades SET salary = "..amount.." WHERE id = "..id,
	{
		['@id'] = id,
		['@salary'] = amount
	}, function (rowsChanged)
	end)
end)

ESX.RegisterServerCallback('Tikoz:getSocietyMoney', function(source, cb, societyName)
	if societyName ~= nil then
	  local society = "society_blanchi"
	  TriggerEvent('esx_addonaccount:getSharedAccount', society, function(account)
		cb(account.money)
	  end)
	else
	  cb(0)
	end
end)

ESX.RegisterServerCallback('Tikoz:blanchiArgentEntreprise', function(source, cb)

    local xPlayer = ESX.GetPlayerFromId(source)
    local compteblanchi = {}


    MySQL.Async.fetchAll('SELECT * FROM addon_account_data WHERE account_name = "society_blanchi"', {

    }, function(result)

        for i=1, #result, 1 do
            table.insert(compteblanchi, {
                account_name = result[i].account_name,
                money = result[i].money,
            })
        end

        cb(compteblanchi)
    end)
end)

RegisterServerEvent("Tikoz:blanchidepotentreprise")
AddEventHandler("Tikoz:blanchidepotentreprise", function(money)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local total = money
    local xMoney = xPlayer.getAccount("bank").money
    
    TriggerEvent('esx_addonaccount:getSharedAccount', "society_blanchi", function (account)
        if xMoney >= total then
            account.addMoney(total)
            xPlayer.removeAccountMoney('bank', total)
            TriggerClientEvent('esx:showAdvancedNotification', source, 'Banque Société', "~b~Blanchiment", "Vous avez déposé ~g~"..total.." $~s~ dans votre ~b~entreprise", 'CHAR_BANK_FLEECA', 9)
        else
            TriggerClientEvent('esx:showNotification', source, "<C>~r~Vous n'avez pas assez d'argent !")
        end
    end)   
end)

RegisterServerEvent("Tikoz:blanchiRetraitEntreprise")
AddEventHandler("Tikoz:blanchiRetraitEntreprise", function(money)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local total = money
	local xMoney = xPlayer.getAccount("bank").money
	
	TriggerEvent('esx_addonaccount:getSharedAccount', "society_blanchi", function (account)
		if account.money >= total then
			account.removeMoney(total)
			xPlayer.addAccountMoney('bank', total)
			TriggerClientEvent('esx:showAdvancedNotification', source, 'Banque Société', "~b~Blanchiment", "Vous avez retiré ~g~"..total.." $~s~ de votre ~b~entreprise", 'CHAR_BANK_FLEECA', 9)
		else
			TriggerClientEvent('esx:showAdvancedNotification', source, 'Banque Société', "~b~Blanchiment", "Vous avez pas assez d'argent dans votre ~b~entreprise", 'CHAR_BANK_FLEECA', 9)
		end
	end)
end) 

RegisterServerEvent('Tikoz:BlanchiRecruter')
AddEventHandler('Tikoz:BlanchiRecruter', function(target, job, grade)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	targetXPlayer.setJob2(job, grade)
	TriggerClientEvent('esx:showNotification', _source, "Vous avez ~g~recruté " .. targetXPlayer.name .. "~w~.")
	TriggerClientEvent('esx:showNotification', target, "Vous avez été ~g~embauché par " .. sourceXPlayer.name .. "~w~.")
end)

RegisterServerEvent('Tikoz:PromotionBlanchi')
AddEventHandler('Tikoz:PromotionBlanchi', function(target)
	local _source = source

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if (targetXPlayer.job2.grade == 3) then
		TriggerClientEvent('esx:showNotification', _source, "Vous ne pouvez pas plus ~b~promouvoir~w~ d'avantage.")
	else
		if (sourceXPlayer.job2.name == targetXPlayer.job2.name) then
			local grade = tonumber(targetXPlayer.job2.grade) + 1
			local job = targetXPlayer.job2.name

			targetXPlayer.setJob2(job, grade)

			TriggerClientEvent('esx:showNotification', _source, "Vous avez ~b~promu " .. targetXPlayer.name .. "~w~.")
			TriggerClientEvent('esx:showNotification', target, "Vous avez été ~b~promu~s~ par " .. sourceXPlayer.name .. "~w~.")
		end
	end
end)


RegisterServerEvent('Tikoz:BlanchiRetrograder')
AddEventHandler('Tikoz:BlanchiRetrograder', function(target)
	local _source = source

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if (targetXPlayer.job2.grade == 0) then
		TriggerClientEvent('esx:showNotification', _source, "Vous ne pouvez pas plus ~r~rétrograder~w~ d'avantage.")
	else
		if (sourceXPlayer.job2.name == targetXPlayer.job2.name) then
			local grade = tonumber(targetXPlayer.job2.grade) - 1
			local job = targetXPlayer.job2.name

			targetXPlayer.setJob2(job, grade)

			TriggerClientEvent('esx:showNotification', _source, "Vous avez ~r~rétrogradé " .. targetXPlayer.name .. "~w~.")
			TriggerClientEvent('esx:showNotification', target, "Vous avez été ~r~rétrogradé par " .. sourceXPlayer.name .. "~w~.")
		else
			TriggerClientEvent('esx:showNotification', _source, "Vous n'avez pas ~r~l'autorisation~w~.")
		end
	end
end)

RegisterServerEvent('Tikoz:BlanchiVirer')
AddEventHandler('Tikoz:BlanchiVirer', function(target)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local job = "unemployed"
	local grade = "0"
	if (sourceXPlayer.job2.name == targetXPlayer.job2.name) then
		targetXPlayer.setJob2(job, grade)
		TriggerClientEvent('esx:showNotification', _source, "Vous avez ~r~viré " .. targetXPlayer.name .. "~w~.")
		TriggerClientEvent('esx:showNotification', target, "Vous avez été ~g~viré par " .. sourceXPlayer.name .. "~w~.")
	else
		TriggerClientEvent('esx:showNotification', _source, "Vous n'avez pas ~r~l'autorisation~w~.")
	end
end)
