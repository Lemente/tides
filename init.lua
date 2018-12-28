
local height=1;

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

minetest.register_globalstep(function(dtime)
   -- increase time var
   timer = timer + dtime
   -- run every 2 seconds otherwise abort
   if timer < 2 then return end
   -- reset timer
   timer=0
   -- do calc stuff
   height=2*math.sin(2*math.pi*minetest.get_timeofday())
   minetest.log(height)
end)

--Thanks BuckarooBanzay!

minetest.register_abm({
	nodenames = {"default:water_source,default:air"},
	neighbors = {"default:air"},
	interval = 5,
	chance = 20,
	action=
	function(pos, node, active_object_count,active_object_count_wider)
		lminetest.log(dump(pos))
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
