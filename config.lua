--Truck
Config	=	{}

 -- Limit, unit can be whatever you want. Originally grams (as average people can hold 25kg)
Config.Limit = 25000

-- Default weight for an item:
	-- weight == 0 : The item do not affect character inventory weight
	-- weight > 0 : The item cost place on inventory
	-- weight < 0 : The item add place on inventory. Smart people will love it.
Config.DefaultWeight = 0



-- If true, ignore rest of file
Config.WeightSqlBased = false

-- I Prefer to edit weight on the config.lua and I have switched Config.WeightSqlBased to false:
Config.localWeight = {
	bread = 125, -- french baguette du fromage (grams)
	water = 500  -- Small bottle (grams)
}

Config.VehicleLimit ={
	[0]=10000,
	[1]=30000,
	[2]=50000,
	[3]=30000,
	[4]=30000,
	[5]=20000,
	[6]=15000,
	[7]=15000,
	[8]=5000,
	[9]=5000,
	[10]=100000,
	[11]=80000,
	[12]=80000,
	[13]=0,
	[14]=10000,
	[15]=10000,
	[16]=100000,
	[17]=25000,
	[18]=50000,
	[19]=50000,
	[20]=80000,

}
