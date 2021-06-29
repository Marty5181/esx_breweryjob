-----------------------------------------
-- Created and modify by L'ile Légale RP
-- SenSi and Kaminosekai
-----------------------------------------

ESX = nil
local PlayersTransforming  = {}
local PlayersSelling       = {}
local PlayersHarvesting = {}
local pivo = 1
local chmeljus = 1
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'brewery', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'brewery', _U('brewery_client'), true, true)
TriggerEvent('esx_society:registerSociety', 'brewery', 'Pivovar', 'society_brewery', 'society_brewery', 'society_brewery', {type = 'private'})
local function Harvest(source, zone)
	if PlayersHarvesting[source] == true then

		local xPlayer  = ESX.GetPlayerFromId(source)
		if zone == "ChmelFarm" then
			local itemQuantity = xPlayer.getInventoryItem('chmel').count
			if itemQuantity >= 100 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_place'))
				return
			else
				SetTimeout(1800, function()
					xPlayer.addInventoryItem('chmel', 1)
					Harvest(source, zone)
				end)
			end
		end
	end
end

RegisterServerEvent('esx_breweryjob:startHarvest')
AddEventHandler('esx_breweryjob:startHarvest', function(zone)
	local _source = source
  	
	if PlayersHarvesting[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, '~r~C\'est pas bien de glitch ~w~')
		PlayersHarvesting[_source]=false
	else
		PlayersHarvesting[_source]=true
		TriggerClientEvent('esx:showNotification', _source, _U('chmel_taken'))  
		Harvest(_source,zone)
	end
end)


RegisterServerEvent('esx_breweryjob:stopHarvest')
AddEventHandler('esx_breweryjob:stopHarvest', function()
	local _source = source
	
	if PlayersHarvesting[_source] == true then
		PlayersHarvesting[_source]=false
		TriggerClientEvent('esx:showNotification', _source, 'Vous sortez de la ~r~zone')
	else
		TriggerClientEvent('esx:showNotification', _source, 'Vous pouvez ~g~récolter')
		PlayersHarvesting[_source]=true
	end
end)


local function Transform(source, zone)

	if PlayersTransforming[source] == true then

		local xPlayer  = ESX.GetPlayerFromId(source)
		if zone == "TraitementPivo" then
			local itemQuantity = xPlayer.getInventoryItem('chmel').count
			
			if itemQuantity <= 0 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_chmel'))
				return
			else
				local rand = math.random(0,100)
				if (rand >= 98) then
					SetTimeout(1800, function()
						xPlayer.removeInventoryItem('chmel', 1)
						xPlayer.addInventoryItem('specialpivo', 1)
						TriggerClientEvent('esx:showNotification', source, _U('specialpivo'))
						Transform(source, zone)
					end)
				else
					SetTimeout(1800, function()
						xPlayer.removeInventoryItem('chmel', 1)
						xPlayer.addInventoryItem('pivo', 1)
				
						Transform(source, zone)
					end)
				end
			end
		elseif zone == "TraitementChmeljus" then
			local itemQuantity = xPlayer.getInventoryItem('chmel').count
			if itemQuantity <= 0 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_chmel'))
				return
			else
				SetTimeout(1800, function()
					xPlayer.removeInventoryItem('chmel', 1)
					xPlayer.addInventoryItem('chmeljus', 1)
		  
					Transform(source, zone)	  
				end)
			end
		end
	end	
end

RegisterServerEvent('esx_breweryjob:startTransform')
AddEventHandler('esx_breweryjob:startTransform', function(zone)
	local _source = source
  	
	if PlayersTransforming[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, '~r~C\'est pas bien de glitch ~w~')
		PlayersTransforming[_source]=false
	else
		PlayersTransforming[_source]=true
		TriggerClientEvent('esx:showNotification', _source, _U('transforming_in_progress')) 
		Transform(_source,zone)
	end
end)

RegisterServerEvent('esx_breweryjob:stopTransform')
AddEventHandler('esx_breweryjob:stopTransform', function()

	local _source = source
	
	if PlayersTransforming[_source] == true then
		PlayersTransforming[_source]=false
		TriggerClientEvent('esx:showNotification', _source, 'Vous sortez de la ~r~zone')
		
	else
		TriggerClientEvent('esx:showNotification', _source, 'Vous pouvez ~g~transformer votre chmel')
		PlayersTransforming[_source]=true
		
	end
end)

local function Sell(source, zone)

	if PlayersSelling[source] == true then
		local xPlayer  = ESX.GetPlayerFromId(source)
		
		if zone == 'SellFarm' then
			if xPlayer.getInventoryItem('pivo').count <= 0 then
				pivo = 0
			else
				pivo = 1
			end
			
			if xPlayer.getInventoryItem('chmeljus').count <= 0 then
				chmeljus = 0
			else
				chmeljus = 1
			end
		
			if pivo == 0 and chmeljus == 0 then
				TriggerClientEvent('esx:showNotification', source, _U('no_product_sale'))
				return
			elseif xPlayer.getInventoryItem('pivo').count <= 0 and chmeljus == 0 then
				TriggerClientEvent('esx:showNotification', source, _U('no_pivo_sale'))
				pivo = 0
				return
			elseif xPlayer.getInventoryItem('chmeljus').count <= 0 and pivo == 0then
				TriggerClientEvent('esx:showNotification', source, _U('no_chmeljus_sale'))
				chmeljus = 0
				return
			else
				if (chmeljus == 1) then
					SetTimeout(1100, function()
						local money = math.random(18,25)
						xPlayer.removeInventoryItem('chmeljus', 1)
						local societyAccount = nil

						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_brewery', function(account)
							societyAccount = account
						end)
						if societyAccount ~= nil then
							societyAccount.addMoney(money)
							TriggerClientEvent('esx:showNotification', xPlayer.source, _U('comp_earned') .. money)
						end
						Sell(source,zone)
					end)
				elseif (pivo == 1) then
					SetTimeout(1100, function()
						local money = math.random(30,35)
						xPlayer.removeInventoryItem('pivo', 1)
						local societyAccount = nil

						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_brewery', function(account)
							societyAccount = account
						end)
						if societyAccount ~= nil then
							societyAccount.addMoney(money)
							TriggerClientEvent('esx:showNotification', xPlayer.source, _U('comp_earned') .. money)
						end
						Sell(source,zone)
					end)
				end
				
			end
		end
	end
end

RegisterServerEvent('esx_breweryjob:startSell')
AddEventHandler('esx_breweryjob:startSell', function(zone)

	local _source = source
	
	if PlayersSelling[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, '~r~C\'est pas bien de glitch ~w~')
		PlayersSelling[_source]=false
	else
		PlayersSelling[_source]=true
		TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))
		Sell(_source, zone)
	end

end)

RegisterServerEvent('esx_breweryjob:stopSell')
AddEventHandler('esx_breweryjob:stopSell', function()

	local _source = source
	
	if PlayersSelling[_source] == true then
		PlayersSelling[_source]=false
		TriggerClientEvent('esx:showNotification', _source, 'Vous sortez de la ~r~zone')
		
	else
		TriggerClientEvent('esx:showNotification', _source, 'Vous pouvez ~g~vendre')
		PlayersSelling[_source]=true
	end

end)

RegisterServerEvent('esx_breweryjob:getStockItem')
AddEventHandler('esx_breweryjob:getStockItem', function(itemName, count)

	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_brewery', function(inventory)

		local item = inventory.getItem(itemName)

		if item.count >= count then
			inventory.removeItem(itemName, count)
			xPlayer.addInventoryItem(itemName, count)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
		end

		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn') .. count .. ' ' .. item.label)

	end)

end)

ESX.RegisterServerCallback('esx_breweryjob:getStockItems', function(source, cb)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_brewery', function(inventory)
		cb(inventory.items)
	end)

end)

RegisterServerEvent('esx_breweryjob:putStockItems')
AddEventHandler('esx_breweryjob:putStockItems', function(itemName, count)

	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_brewery', function(inventory)

		local item = inventory.getItem(itemName)

		if item.count >= 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
		end

		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('added') .. count .. ' ' .. item.label)

	end)
end)

ESX.RegisterServerCallback('esx_breweryjob:getPlayerInventory', function(source, cb)

	local xPlayer    = ESX.GetPlayerFromId(source)
	local items      = xPlayer.inventory

	cb({
		items      = items
	})

end)


ESX.RegisterUsableItem('chmeljus', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('chmeljus', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 40000)
	TriggerClientEvent('esx_status:add', source, 'thirst', 120000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_chmeljus'))

end)

ESX.RegisterUsableItem('specialpivo', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('specialpivo', 1)

	TriggerClientEvent('esx_status:add', source, 'drunk', 400000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_specialpivo'))

end)
