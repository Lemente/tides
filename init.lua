
local height=1;

minetest.register_abm({
	nodenames = {"default:mese"},
	interval = 10,
	action = function()
		height=math.sin(2*math.pi*minetest.get_timeofday())
		minetest.log(height)
	end
})

minetest.register_abm({
	nodenames = {"default:water_source,default:air"},
	neighbors = {"default:air"},
	interval = 5,
	chance = 1,
	action=
	function(pos, node, active_object_count,active_object_count_wider)
		--local pos = {x = pos.x, y = pos.y + 1, z = pos.z}
		if minetest.get_node(pos).name=="default:water_source" or minetest.get_node(pos).name=="default:air" then
			if pos.y<=height then
				minetest.set_node(pos, {name = "default:water_source"})
			else
				minetest.remove_node(pos)
			end
        end
	end
})
