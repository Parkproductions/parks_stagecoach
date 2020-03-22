Config               = {}

Config.DrawDistance  = 10.0
Config.MarkerColor   = {r = 204, g = 204, b = 0}
Config.Blip          = {sprite = 311, color = 1}

Config.Marker = {
  ["saint_dennis"] = {name = 'Saint Dennis', sprite = 0x3C5469D5, x = 2683.95, y = -1441.86, z = 46.16, h = 21.54},
  ["rhodes"] = {name = 'Rhodes', sprite = 0x3C5469D5, x = 1262.9, y = -1321.06, z = 76.89, h = 316.94}
}

Config.StageCoachSpawn = {
  ["Saint Dennis"] = {x = 2684.93, y = -1436.46, z = 46.07, h = 112.89},
  ["Rhodes"] = { x = 1269.4, y = -1315.75, z = 76.4, h = 38.42}
}

Config.StagecoachJobSprite = 1560611276 -- Stage Coach Job Blip sprite

Config.SetJob = true -- Set job after Start working
Config.JobName = "stage_coach_driver" -- Job name to set

Config.Coords = {
	vector3(1254.05, -1327.07, 76.89),
	vector3(2683.95, -1441.86, 46.16)
}
