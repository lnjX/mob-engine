--[[
= Chicken for Creatures MOB-Engine (cme) =
Copyright (C) 2017 Mob API Developers and Contributors
Copyright (C) 2015-2016 BlockMen <blockmen2015@gmail.com>

init.lua

This software is provided 'as-is', without any express or implied warranty. In no
event will the authors be held liable for any damages arising from the use of
this software.

Permission is granted to anyone to use this software for any purpose, including
commercial applications, and to alter it and redistribute it freely, subject to the
following restrictions:

1. The origin of this software must not be misrepresented; you must not
claim that you wrote the original software. If you use this software in a
product, an acknowledgment in the product documentation is required.
2. Altered source versions must be plainly marked as such, and must not
be misrepresented as being the original software.
3. This notice may not be removed or altered from any source distribution.
]]

-- Global table
chicken = {}

-- Params

-- Time for AMB interval at nest node
chicken.nest_update_time = 30

chicken.chicken_timer = 10

-- Egg
dofile(core.get_modpath("chicken") .. "/egg.lua")

-- Idle 2
creatures.register_idle_mode("chicken:idle2")

-- Pick
creatures.register_idle_mode("chicken:pick")



-- Flesh
core.register_craftitem("chicken:chicken_flesh", {
	description = "Raw Chicken Flesh",
	inventory_image = "chicken_flesh.png",
	on_use = core.item_eat(1)
})

core.register_craftitem("chicken:chicken_meat", {
	description = "Chicken Meat",
	inventory_image = "chicken_meat.png",
	on_use = core.item_eat(3)
})

core.register_craft({
	type = "cooking",
	output = "chicken:chicken_meat",
	recipe = "chicken:chicken_flesh",
})

-- Feather
core.register_craftitem("chicken:feather", {
	description = "Feather",
	inventory_image = "chicken_feather.png",
})

local def = {
	-- general
	stats = {
		hp = 5,
		lifetime = 300, -- 5 Minutes
		can_jump = 0.55,
		can_swim = true,
		can_burn = true,
		can_panic = true,
		has_kockback = true,
		sneaky = true,
	},

	modes = {
		-- Standard Modes
		idle = {chance = 0.25, duration = 2, update_yaw = 3},
		panic = {moving_speed = 2.1},
		walk = {
			chance = 0.2, 
			duration = 20, 
			moving_speed = 0.7,
			search_radius = 3,
		},
		walk_around = {
			chance = 0.2, 
			duration = 20, 
			moving_speed = 0.7
		},
		follow = {chance = 0, duration = 20, radius = 4, moving_speed = 1, items = {["farming:seed_wheat"]=true}, search_timer = 4},
		-- Custom Modes
		["chicken:dropegg"] = {chance = 0.801, duration = 8},
		["chicken:idle2"] = {chance = 0.69, duration = 0.8, random_yaw = true},
		["chicken:pick"] = {chance = 0.2, duration = 2},
	},


	model = {
		mesh = "chicken.b3d",
		textures = {"chicken.png"},
		collisionbox_width = 0.5,
		collisionbox_height = 0.7,
		vision_height = 0.4,
		weight = 15,
		rotation = 180.0,
		collide_with_objects = false,
		animations = {
			-- Standard Animations
			idle = {start = 0, stop = 1, speed = 10},
			walk = {start = 4, stop = 36, speed = 50},
			-- special modes
			swim = {start = 51, stop = 87, speed = 40},
			panic = {start = 51, stop = 87, speed = 55},
			death = {start = 135, stop = 160, speed = 28, loop = false, duration = 2.12},
			-- Custom Animations
			["chicken:idle2"] = {start = 40, stop = 50, speed = 50},
			["chicken:pick"] = {start = 88, stop = 134, speed = 50},
		},
	},
	
	child = {
		name = "chicken:chicken_child",
		days_to_grow = 3,
		model = {
			scale = {x = 0.7, y = 0.7}
		},
	},
	
	mating = {
		child_mob = "chicken:chicken_child", 
		interval = 3, 
		spawn_type = "mob_node", 
	},
	
	sounds = {
		on_damage = {name = "chicken_chicken_hit", gain = 0.5, distance = 10},
		on_death = {name = "chicken_chicken_hit", gain = 0.5, distance = 10},
		swim = {name = "creatures_splash", gain = 1.0, distance = 10},
		random = {
			idle = {name = "chicken_chicken", gain = 0.9, distance = 12, time_min = 8, time_max = 50},
		},
	},

	spawning = {
		ambience = {
			
			max_number = 4,
			number = {min = 2, max = 4},
			light = {min = 8, max = 15},
			height_limit = {min = 1, max = 150},
			
			abm_nodes = {
				spawn_on = {"default:dirt_with_grass"},
			},
			abm_interval = 55,
			abm_chance = 7800,
			
			on_generated_nodes = {
				spawn_on = {"default:dirt_with_grass"},
			},
			on_generated_chance = 35,
		},
		spawn_egg = {
			description = "Chicken Spawn-Egg",
		},
	},

	drops = {
		{"chicken:chicken_flesh"},
		{"chicken:feather", {min = 1, max = 2}, chance = 0.45},
	},
	
}

creatures.register_mob("chicken:chicken", def)

-- Nest
dofile(core.get_modpath("chicken") .. "/nest.lua")
