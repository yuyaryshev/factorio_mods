-- YYA TODO	uncomment technology
--		data:extend({
--		  {
--		    type = "technology",
--		    name = "combinissimo",
--		    icon = MOD_NAME.."/graphics/combinissimo-technology.png",
--			icon_size = 64,
--		    prerequisites = {"circuit-network"},
--		    effects =
--		    {
--		      {
--		        type = "unlock-recipe",
--		        recipe = "combinissimo"
--		      },
--		      {
--		        type = "unlock-recipe",
--		        recipe = "combinissimo-input"
--		      },
--		      {
--		        type = "unlock-recipe",
--		        recipe = "combinissimo-output"
--		      },
--		    },
--		    unit =
--		    {
--		      count = 50,
--		      ingredients = {
--		         {"automation-science-pack", 1}
--		        ,{"logistic-science-pack", 1}
--		      },
--		      time = 2000
--		    },
--		    order = "c-g-c"
--		  }
--		})