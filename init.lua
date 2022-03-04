
--TOFIX
--[[
making vectors with {} is deprecated 
should be vector.new(pos.x, pos.y+1, pos.z) ?
]]

local height=-9;

local get_node = minetest.get_node

--[[
removed for the following reasons:
 - abms are slow
 - mese isn't redily available
]]

--[[
minetest.register_abm({
	nodenames = {"default:mese"},
	interval = 10,
	action = function()
		height=math.sin(2*math.pi*minetest.get_timeofday())
		minetest.log(height)
	end
})
--]]

local timer = 0

--I'l just copy this over from https://forum.minetest.net/viewtopic.php?f=9&t=21600#p338643


--HEIGHT-- deactivated and replaced by a command fior testing purposes
-- might be modified later, or completely rewritten

--[[minetest.register_globalstep(function(dtime)
   -- increase time var
   timer = timer + dtime
   -- run every 2 seconds otherwise abort
   if timer < 2 then return end
   -- reset timer
   timer=0
   -- do calc stuff
   height=2*math.sin(2*math.pi*minetest.get_timeofday())
   minetest.log(height)
end)]]--


--TIDE ON COMMAND
minetest.register_privilege("tide", "player can use /tide command")

minetest.register_chatcommand("tide", {
    params = "<height>",
    description = "choose tide height",
    privs = {tide=true},
    func = function(name, param)
--      if param >= -2 and param <=2 then -- this gives a nil error
        height = tonumber(param)
        if not height then
            return false, "Missing or incorrect parameter?"
        end
                -- I don't understand what I am supposed to put here
        return true , "tide height = " .. height
--    end
  end,
})



--Thanks BuckarooBanzay!
--[[
minetest.register_abm({
	nodenames = {"default:water_source","default:air"},
	--neighbors = {"default:air"},
	interval = 5,
	chance = 5,
	action=
	function(pos, node, active_object_count,active_object_count_wider)
		minetest.log("tide abm called on ")
		minetest.log(dump(pos))
		--local pos = {x = pos.x, y = pos.y + 1, z = pos.z}
		if minetest.get_node(pos).name=="default:water_source" or minetest.get_node(pos).name=="default:air" then
			if pos.y<=height then
				--minetest.set_node(pos, {name = "default:water_source"})
				minetest.set_node(pos, {name = "default:mese"})
--				minetest.log()
			else
				minetest.remove_node(pos)
			end
		else
			minetest.log("not water or air")
        end
	end
})
--]]


--[[
using lbms, as per FaceDeer's sugestion
]]


--TIDES DOWN

minetest.register_node("tides:stink_air",{
	description="air that is below the tideline that, incidentally, stinks.",
	drawtype = "airlike",
	paramtype = "light",

	sunlight_propagates =true,
	walkable=false,
	pointable=false,
	diggable=false,
	buildable_to=true,
	air_equivalent=true, --no idea what it does, might have negative consequences?
	drop="",
	groups = {not_in_creative_inventory=1}

})

minetest.register_abm({
	name="tides:tide_down",
	nodenames = {"default:water_source"},
	neighbors = {air,"tides:stink_air"},
	interval = 1,
	chance = 1, -- chance or 1,
	catch_up = false,
	action = function(pos,node)
		if pos.y>height then --tides will also happen in pools, dunno how to solve.
			--minetest.remove_node(pos)
			minetest.set_node(pos,{name="tides:stink_air"})
		end
	end
})

minetest.register_lbm({
	name="tides:tide_down",
	nodenames = {"default:water_source"},
	run_at_every_load=true,
	action = function(pos,node)
		if pos.y>height then --tides will also happen in pools, dunno how to solve.
			--minetest.remove_node(pos)
			minetest.set_node(pos,{name="tides:stink_air"})
		end
	end
})

--[[

minetest.register_lbm({
	name="tides:tide_up",
	nodenames={"default:air","default:sand"}, --sand erodes above tidal cliffs.
	run_at_every_load=true,
	action = function(pos,node)
		pos2=pos
		pos2.y=pos.y-1
		if pos.y < height and minetest.get_node(pos2).name=="default:water_source" then
			minetest.set_node(pos,{name="default:water_source"})
		else
--			minetest.log(dump(minetest.get_node(pos2)))
		end
	end
})

--]]


-- TIDES UP

minetest.register_abm({
	name="tides:tide_up",
	nodenames={"tides:stink_air"},
	neighbors = {"default:water_source","default:river_water_source"},--,"tides:stink_air"}, --neighbors are also diagonal?
	interval = 1,
	chance = 1, -- chance or 1,
	catch_up = false,
	action=function(pos,node)
		if pos.y<=height then
			local water_source = "default:water_source"
			local river_water_source = "default:river_water_source"
			local check_pos_east = {x=pos.x+1, y=pos.y, z=pos.z}
			local check_pos_west = {x=pos.x-1, y=pos.y, z=pos.z}
			local check_pos_up = {x=pos.x, y=pos.y+1, z=pos.z}
			local check_pos_down = {x=pos.x, y=pos.y-1, z=pos.z}
			local check_pos_north = {x=pos.x, y=pos.y, z=pos.z+1}
			local check_pos_south = {x=pos.x, y=pos.y, z=pos.z-1}
			local check_node_east = get_node(check_pos_east)
			local check_node_west = get_node(check_pos_west)
			local check_node_up = get_node(check_pos_up)
			local check_node_down = get_node(check_pos_down)
			local check_node_north = get_node(check_pos_north)
			local check_node_south = get_node(check_pos_south)
			local east = check_node_east.name
			local west = check_node_west.name
			local up = check_node_up.name
			local down = check_node_down.name
			local north = check_node_north.name
			local south = check_node_south.name
			--if node above is water source, and no other water source around, then becomes a water source not affected by tides

			if (up == water_source or up == river_water_source) and down ~= water_source and north ~= water_source and south ~= water_source and east ~= water_source and west ~= water_source then 
				minetest.set_node(pos,{name="default:river_water_source"})
				minetest.chat_send_all("created river water at " .. tostring(pos))
			elseif up ~= water_source and (down == water_source or north == water_source or south == water_source or east == water_source or west == water_source) then
				minetest.after(0.2, function()
					minetest.set_node(pos,{name="default:water_source"})
				end)
			end
		end
	end
})

minetest.register_lbm({
	name="tides:tide_up",
	nodenames={"tides:stink_air"},
	run_at_every_load=true,
	action=function(pos,node)
		if pos.y<=height then
			minetest.set_node(pos,{name="default:water_source"})
		end
	end
})
