ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) 
  ESX = obj
end)

RegisterServerEvent('esx_truck_inventory:getOwnedVehicule')
AddEventHandler('esx_truck_inventory:getOwnedVehicule', function()
  local vehicules = {}
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  MySQL.Async.fetchAll(
      'SELECT * FROM owned_vehicles WHERE owner = @owner',
   		{
   			['@owner'] = xPlayer.identifier
   		},
    function(result)
      if result ~= nil and #result > 0 then
          for _,v in pairs(result) do
      			local vehicle = json.decode(v.vehicle)
            --print(vehicle.plate)
      			table.insert(vehicules, {plate = vehicle.plate})
      		end
      end
    TriggerClientEvent('esx_truck_inventory:setOwnedVehicule', _source, vehicules)
    end)
end)

function getInventoryWeight(inventory)
  local weight = 0
  local itemWeight = 0

  if inventory ~= nil then
	  for i=1, #inventory, 1 do
	    if inventory[i] ~= nil then
	      itemWeight = Config.DefaultWeight
	      if arrayWeight[inventory[i].name] ~= nil then
	        itemWeight = arrayWeight[inventory[i].name]
	      end
	      weight = weight + (itemWeight * inventory[i].count)
	    end
	  end
  end
  return weight
end


RegisterServerEvent('esx_truck_inventory:getInventory')
AddEventHandler('esx_truck_inventory:getInventory', function(plate)
  local inventory_ = {}
  local _source = source
  MySQL.Async.fetchAll(
    'SELECT * FROM `truck_inventory` WHERE `plate` = @plate',
    {
      ['@plate'] = plate
    },
    function(inventory)
      if inventory ~= nil and #inventory > 0 then
        for i=1, #inventory, 1 do
          table.insert(inventory_, {
            name      = inventory[i].item,
            label      = inventory[i].name,
            count     = inventory[i].count
          })
        end
      end

    local xPlayer  = ESX.GetPlayerFromId(_source)
    TriggerClientEvent('esx_truck_inventory:getInventoryLoaded', xPlayer.source, inventory_)
    end)
end)

RegisterServerEvent('esx_truck_inventory:removeInventoryItem')
AddEventHandler('esx_truck_inventory:removeInventoryItem', function(plate, item, itemType, count)
  local _source = source
  MySQL.Async.fetchAll(
    'UPDATE `truck_inventory` SET `count`= `count` - @qty WHERE `plate` = @plate AND `item`= @item',
    {
      ['@plate'] = plate,
      ['@qty'] = count,
      ['@item'] = item,
      ['@itemt'] = itemType		
    },
    function(result)
      if itemType == 'item_standard' then
      local xPlayer  = ESX.GetPlayerFromId(_source)
      if xPlayer ~= nil then
      xPlayer.addInventoryItem(item, amount)
      end 
      
      if itemType == 'item_account' then
      xPlayer.addAccountMoney(item, amount)
      end

     if itemType == 'item_weapon' then
     xPlayer.addWeapon(item)
     end
    end)
end)

RegisterServerEvent('esx_truck_inventory:addInventoryItem')
AddEventHandler('esx_truck_inventory:addInventoryItem', function(type, model, plate, item, count, name, itemType, ownedV)

  local xPlayer = ESX.GetPlayerFromId(source)
  MySQL.Async.fetchAll(
    'INSERT INTO truck_inventory (item,count,plate,name,owned) VALUES (@item,@qty,@plate,@name,@owned) ON DUPLICATE KEY UPDATE count=count+ @qty',
    {
      ['@plate'] = plate,
      ['@qty'] = count,
      ['@item'] = item,
      ['@name'] = name,
      ['@itemt'] = itemType,
      ['@owned'] = ownedV,    
    },  
  function(result)
    if itemType == 'item_standard' then
    local label = xPlayer.getInventoryItem(item).count
   
    if playerItemCount <= amount then
       xPlayer.removeInventoryItem(item, amount)
    else
      ESX.ShowNotification('Invalid quantity')
    end
  end

  if itemType == 'item_account' then
    xPlayer.removeAccountMoney(item, amount)
  end

  if itemType == 'item_weapon' then
    xPlayer.removeWeapon(item)
  end

 end)
end)
