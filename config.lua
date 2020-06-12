Config               = {}

Config.DrawDistance  = 10.0

Config.MarkerColor   = {r = 204, g = 204, b = 0}

Config.Blip          = {sprite = 311, color = 1}

Config.Districts = {
	[178647645] = {name = 'Roanoke'},
	[1308232528] = {name = 'Bluewater Marsh'},
	[2025841068] = {name = 'Bayou Nwa'},
	[-864275692] = {name = 'Scarlett Meadows'},
	[131399519] = {name = 'Heartlands'},
	[-120156735] = {name = 'GrizzliesEast'},
	[1835499550] = {name = 'Cumberland'},
	[1645618177] = {name = 'GrizzliesWest'},
	[822658194] = {name = 'bigvalley'},
	[1684533001] = {name = 'TallTrees'},
	[476637847] = {name = 'greatPlains'},
	[892930832] = {name = 'HennigansStead'},
	[-108848014] = {name = 'ChollaSprings'},
	[-2145992129] = {name = 'RioBravo'},
	[-2066240242] = {name = 'GaptoothRidge'},
} 

Config.Marker = {
  ["saint_denis"] = {name = 'Saint Denis', sprite = 0x3C5469D5, x = 2683.95, y = -1441.86, z = 46.16, h = 21.54},
  ["rhodes"] = {name = 'Rhodes', sprite = 0x3C5469D5, x = 1262.9, y = -1321.06, z = 76.89, h = 316.94},
  ["annesburg"] = {name = 'Annesburg', sprite = 0x3C5469D5, x = 2916.26, y = 1260.84, z = 44.47, h = 67.27},
  ["vanhorn"] = {name = 'Vanhorn', sprite = 0x3C5469D5, x = 2970.66, y = 572.16, z = 44.48, h = 81.94},
  

}

Config.StageCoachSpawn = {
  ["Saint Denis"] = {x = 2684.93, y = -1436.46, z = 46.07, h = 112.89},
  ["Rhodes"] = { x = 1269.4, y = -1315.75, z = 76.4, h = 38.42},
  ["Annesburg"] = { x = 2913.53, y = 1263.97, z = 44.74, h = 153.37},
  ["Vanhorn"] = { x = 2965.97, y = 572.61, z = 44.33, h = 173.01},
}

Config.Cams = {
	["Saint Denis"] = {
		["cam_a"] = {x = 2684.95, y = -1437.48, z = 45.73, h = 112.89},
		["cam_b"] = {x = 2684.95, y = -1436.48, z = 45.73, h = 112.89}
	},

	["Rhodes"] = { 
		["cam_a"] = {x = 1271.71, y = -1318.75, z = 79.4, h = 38.42},
		["cam_b"] = {x = 1269.4, y = -1315.75, z = 79.4, h = 38.42}
	},
	["Annesburg"] = {
		["cam_a"] = {x = 2909.55 , y = 1262.1, z = 44.74, h = 245.36},
		["cam_b"] = {x = 2905.34, y = 1253.29, z = 44.79, h = 294.15},
	},
	["Vanhorn"] = {
		["cam_a"] = {x = 2965.25 , y = 566.5, z = 44.33, h = 167.52},
		["cam_b"] = {x = 2965.97, y = 572.61, z = 44.33, h = 173.01},
	},
	

}

Config.StagecoachJobSprite = 1560611276 -- Stage Coach Job Blip sprite

Config.SetJob = true -- Set job after Start working

Config.JobName = "stage_coach_driver" -- Job name to set

Config.Coords = {
	vector3(1254.05, -1327.07, 76.89),
	vector3(2683.95, -1441.86, 46.16),
	vector3(2931.1, 1266.37, 1266.37)
}

Config.PickUp = {
	["Braithwaite"] = {
		[1] = {name = 'Pick Up Point', model = "U_M_O_MaPWiseOldMan_01", sprite = 0xDDFBA6AB, x = 1875.4, y = -1853.53, z = 42.64, h = 61.03},
		[2]	= {name = 'Pick Up Point', model = "U_M_M_ISLBUM_01", sprite = 0xDDFBA6AB, x = 859.95, y = -1905.35, z = 44.17, h = 299.76},
	},
	["Caliga"] = {
		[1] = {name = 'Pick Up Point', model = "A_M_M_RANCHER_01", sprite = 0xDDFBA6AB, x = 1845.28, y = -1225.67, z= 42.02, h = 244.96},
		[2] = {name = 'Pick Up Point', model = "CS_braithwaitemaid", sprite = 0xDDFBA6AB, x = 1896.25, y = -1335.6, z= 42.75, h = 303.37},
	},
	["Saint Denis"] = {
		[1] = {name = 'Pick Up Point', model = "A_F_M_RhdProstitute_01", sprite = 0xDDFBA6AB, x = 2503.32, y = -1185.51, z = 49.22, h = 80.69},
		[2] = {name = 'Pick Up Point', model = "A_F_M_BTCObeseWomen_01", sprite = 0xDDFBA6AB, x = 2716.17, y = -1137.19, z = 50.24, h = 156.52},
	},

	["Rhodes"] = {
		[1] = {name = 'Pick Up Point', model = "A_F_M_BlWUpperClass_01", sprite = 0xDDFBA6AB, x = 1373.89, y = -1317.13, z = 77.37, h =  122.41},
		[2] = {name = 'Pick Up Point', model = "A_M_M_RhdTownfolk_02", sprite = 0xDDFBA6AB, x = 1059.16, y = -1130.54, z = 67.55, h =  126.78},	
	},
	["Annesburg"] = {
		[1] = {name = 'Pick Up Point', model = "U_M_M_BHT_MINEFOREMAN", sprite = 0xDDFBA6AB, x = 2859.54, y = 1354.76, z = 63.8, h = 178.0},
		[2] = {name = 'Pick Up Point', model = "CS_SOOTHSAYER", sprite = 0xDDFBA6AB, x = 2947.11, y = 1353.7, z = 44.1, h = 70.51},
	}

}

Config.Destination = {
	["Braithwaite"] = {
		[1] = {name = 'Destination', sprite = 0xDDFBA6AB, x = 2491.48, y = -1392.52, z = 45.69},
		[2] = {name = 'Destination', sprite = 0xDDFBA6AB, x = 1304.68, y = -1140.93, z = 81.24},
	},
	["Caliga"] = {
		[1] = {name = 'Destination', sprite = 0xDDFBA6AB, x = 1010.56, y = -1735.45, z = 45.69},
		[2] = {name = 'Destination', sprite = 0xDDFBA6AB, x = 2404.27, y = -1267.46, z = 45.62},
	},
	["Saint Denis"] = {
		[1] = {name = 'Destination', sprite = 0xDDFBA6AB, x = 1396.99, y = -1161.1, z = 343.83},
		[2] = {name = 'Destination', sprite = 0xDDFBA6AB, x = 908.84, y = -1797.07, z = 42.82},
	},
	["Rhodes"] = {
		[1] = {name = 'Destination', sprite = 0xDDFBA6AB, x = 1738.37, y = -1373.53, z = 44.05},
		[2] = {name = 'Destination', sprite = 0xDDFBA6AB, x = 1847.77, y = -1409.57, z = 41.41},
	},
	["Annesburg"] = {
		[1] = {name = 'Destination', sprite = 0xDDFBA6AB, x = 2510.26, y = 2269.55, z = 176.4},
		[2] = {name = 'Destination', sprite = 0xDDFBA6AB, x = 2632.28, y = 1719.53, z = 113.11},
	}
}

 