local nazwaNarkotyku1 = 'weed20g'
local nazwaNarkotyku2 = 'banko_dokumentai'
local nazwaNarkotyku3 = 'meth_pooch'
local nazwaNarkotyku4 = 'opium_pooch'

local wynagrodzenieWeed = math.random(1, 1) --<< zakres wynagrodzenia za 1 sztuke narkotyku nr.1 (weed) | Domyslnie: od 200 - 400$ brudnego
local wynagrodzenieCoke = math.random(1, 1) --<< zakres wynagrodzenia za 1 sztuke narkotyku nr.2 (coke) | Domyslnie: od 400 - 600$ brudnego
local wynagrodzenieMeth = math.random(1, 1) --<< zakres wynagrodzenia za 1 sztuke narkotyku nr.3 (meth) | Domyslnie: od 600 - 800$ brudnego
local wynagrodzenieOpium = math.random(1, 1) --<< zakres wynagrodzenia za 1 sztuke narkotyku nr.4 (opium) | Domyslnie: od 600 - 800$ brudnego ]]

local waitingForClient = 0

---======================---
---Written by Tościk#9715---
---======================---

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)


RegisterCommand('selldrugs', function(source, rawCommand)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local Iweed = xPlayer.getInventoryItem(nazwaNarkotyku1).count 
	local Icoke = xPlayer.getInventoryItem(nazwaNarkotyku2).count 
	local Imeth = xPlayer.getInventoryItem(nazwaNarkotyku3).count  
	local Iopium = xPlayer.getInventoryItem(nazwaNarkotyku4).count

	local copsOnDuty = 0
    local Players = ESX.GetPlayers()

    for i = 1, #Players do
        local xPlayer = ESX.GetPlayerFromId(Players[i])

        if xPlayer["job"]["name"] == "police" then
            copsOnDuty = copsOnDuty + 1
        end
    end

	if copsOnDuty < 1 then  ---- policijos kiekis kiek jos turi buti
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', length = 6000, text = "Need at least 1 Cops in town." })	
	--- TriggerClientEvent('esx:showNotification', _source, '~r~Potrzeba przynajmniej 2 LSPD.')
	return
    end
	
	if waitingForClient == 1 then
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', length = 6000, text = "You already have an appointment with the client." })	
	--- TriggerClientEvent('esx:showNotification', _source, '~r~Jesteś już umówiony z klientem.')
        return
	end
	
	if Iweed > 0 then
	TriggerClientEvent("tostdrugs:getcustomer", _source)
	waitingForClient = 0
	 elseif Icoke > 0 then
	TriggerClientEvent("tostdrugs:getcustomer", _source)
	waitingForClient = 1
	elseif Imeth > 0 then
	TriggerClientEvent("tostdrugs:getcustomer", _source)
	waitingForClient = 1
	elseif Iopium > 0 then
	TriggerClientEvent("tostdrugs:getcustomer", _source)
	waitingForClient = 1 
	else
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', length = 6000, text = "You do not have the required number of items!" })	
	---TriggerClientEvent('esx:showNotification', _source, '~r~Nie masz przy sobie żadnego narkotyku na sprzedaż.')
	end
	
end)

RegisterServerEvent('tostdrugs:udanyzakup')
AddEventHandler('tostdrugs:udanyzakup', function(x, y, z)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local Iweed = xPlayer.getInventoryItem(nazwaNarkotyku1).count 
	local Icoke = xPlayer.getInventoryItem(nazwaNarkotyku2).count 
	local Imeth = xPlayer.getInventoryItem(nazwaNarkotyku3).count 
	local Iopium = xPlayer.getInventoryItem(nazwaNarkotyku4).count
	
	local niezadowolenie = math.random(1,100)
	
	if niezadowolenie <= 5 then --<< 3% szans ze klient będzie niezadowolony i zwróci towar i nie zapłaci
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', length = 6000, text = "What's the shit too? I expected weed and you don’t have it!." })	
	---TriggerClientEvent('esx:showNotification', _source, '~r~Co to za gówno? Oczekiwałem dobrego towaru a to jakis syf, zabieraj to oszuście.')
	waitingForClient = 0
	return
	end


	if Iweed > 0 then
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', length = 4000, text = "You exchanged weed for black money!." })	
	---TriggerClientEvent('esx:showNotification', _source, '~g~Skutecznie sprzedajesz ~y~marihuanę~g~ za ~y~'..wynagrodzenieWeed..'$')
	xPlayer.removeInventoryItem(nazwaNarkotyku1, 40)
	xPlayer.addAccountMoney('black_money', wynagrodzenieWeed)
	waitingForClient = 0
	elseif Icoke > 0 then
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', length = 6000, text = "Jūs iškeitėt banko dokumentus į ak ginklo receptą!." })	
	---TriggerClientEvent('esx:showNotification', _source, '~g~Skutecznie sprzedajesz ~y~kokainę~g~ za ~y~'..wynagrodzenieCoke..'$')
	xPlayer.removeInventoryItem(nazwaNarkotyku2, 40)
	xPlayer.addAccountMoney('black_money', wynagrodzenieCoke)
	waitingForClient = 0
	elseif Imeth > 0 then
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', length = 6000, text = "Jūsų prekė prasta, bandykit parduoti kitam pirkėjui!." })	
	--- TriggerClientEvent('esx:showNotification', _source, '~g~Skutecznie sprzedajesz ~y~amfetaminę~g~ za ~y~'..wynagrodzenieMeth..'$')
	xPlayer.removeInventoryItem(nazwaNarkotyku3, 1)
	xPlayer.addAccountMoney('black_money', wynagrodzenieMeth)
	waitingForClient = 0
	elseif Iopium > 0 then
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', length = 6000, text = "Jūsų prekė prasta, bandykit parduoti kitam pirkėjui!." })	
	---TriggerClientEvent('esx:showNotification', _source, '~g~Skutecznie sprzedajesz ~y~opium~g~ za ~y~'..wynagrodzenieOpium..'$')
	xPlayer.removeInventoryItem(nazwaNarkotyku4, 1)
	xPlayer.addAccountMoney('black_money', wynagrodzenieOpium)
	waitingForClient = 0
	else 
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', length = 6000, text = "Jūs neturite ką parduoti!." })		
	---TriggerClientEvent('esx:showNotification', _source, '~r~Jūs neturite ką parduoti už šį apgaviko pranešimą?!')
	waitingForClient = 0
	end
	
	
	local infoPsy = math.random(1,100)
	
	if infoPsy <= 50 then --<< 30% ze zostanie wezwana policja
	TriggerClientEvent('tostdrugs:infoPolicja', -1, x, y, z)
	Wait(500)
	end
	
end)


RegisterServerEvent('tostdrugs:clientpassed')
AddEventHandler('tostdrugs:clientpassed', function()
waitingForClient = 0
end)