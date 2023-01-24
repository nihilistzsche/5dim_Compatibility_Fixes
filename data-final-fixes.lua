local function fix_item(item)
    if not item then
        return
    end
    log("Fixing "..item.name)
    item.next_upgrade = nil
end

for size = 2, 8 do
    fix_item(data.raw["electric-pole"]["invisible-substation-"..size.."x"..size])
end
fix_item(data.raw["electric-pole"]["ee-super-electric-pole"])
fix_item(data.raw["electric-pole"]["ee-super-substation"])
fix_item(data.raw["lamp"]["small-lamp"])
fix_item(data.raw["lamp"]["dect-small-lamp-glow"])
for tier = 1, 4 do
    fix_item(data.raw["storage-tank"]["trader-tank-sel"..(tier > 1 and "-mk"..tier or "")])
    fix_item(data.raw["storage-tank"]["trader-tank-buy"..(tier > 1 and "-mk"..tier or "")])
end
fix_item(data.raw["heat-pipe"]["heat-pipe"])
fix_item(data.raw["lab"]["is-infusion-lab"])
fix_item(data.raw["radar"]["cm-combat-vision-tower"])
fix_item(data.raw["radar"]["cm-combat-enhanced-radar"])
fix_item(data.raw["lamp"]["Industrial-Lamp"])
fix_item(data.raw["lamp"]["cm-item-nrg-large-lamp"])
fix_item(data.raw["roboport"]["cm-item-log-dispatch"])
fix_item(data.raw["roboport"]["cm-item-log-small-repeater"])
fix_item(data.raw["roboport"]["cm-item-log-medium-repeater"])
fix_item(data.raw["roboport"]["cm-item-log-big-repeater"])
for k, v in pairs(data.raw["mining-drill"]) do
    if string.starts_with(k, "cm-production-buddy") then
        fix_item(v)
    end
end
for k, v in pairs(data.raw["ammo-turret"]) do
    if (string.starts_with(k, "cm-")) then
        fix_item(v)
    end
end
for k, v in pairs(data.raw["electric-turret"]) do
    if (string.starts_with(k, "cm-")) then
        fix_item(v)
    end
end
for k, v in pairs(data.raw["assembling-machine"]) do
	if k:sub(-14) == "-unit-deployer" then
		fix_item(v)
	end
end
data.raw.beacon.beacon.collision_box = table.deepcopy(data.raw.beacon["5d-beacon-02"].collision_box)
data.raw.beacon.beacon.selection_box = table.deepcopy(data.raw.beacon["5d-beacon-02"].selection_box)
data.raw.beacon.beacon.collision_mask = table.deepcopy(data.raw.beacon["5d-beacon-02"].collision_mask)
data.raw.reactor["nuclear-reactor"].collision_mask = table.deepcopy(data.raw.reactor["5d-nuclear-reactor-02"].collision_mask)
