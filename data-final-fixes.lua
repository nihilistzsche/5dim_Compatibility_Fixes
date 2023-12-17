function starts_with(str, tst) return str:sub(1, #tst) == tst end

local function remove_next_upgrade(item)
    if item then
        log("Removing next upgrade from " .. item.name)
        item.next_upgrade = nil
    end
end

for size = 2, 8 do
    remove_next_upgrade(data.raw["electric-pole"]["invisible-substation-" .. size .. "x" .. size])
end
remove_next_upgrade(data.raw["electric-pole"]["ee-super-electric-pole"])
remove_next_upgrade(data.raw["electric-pole"]["ee-super-substation"])
remove_next_upgrade(data.raw["lamp"]["small-lamp"])
remove_next_upgrade(data.raw["lamp"]["dect-small-lamp-glow"])
for tier = 1, 4 do
    remove_next_upgrade(data.raw["storage-tank"]["trader-tank-sel" .. (tier > 1 and "-mk" .. tier or "")])
    remove_next_upgrade(data.raw["storage-tank"]["trader-tank-buy" .. (tier > 1 and "-mk" .. tier or "")])
end
remove_next_upgrade(data.raw["heat-pipe"]["heat-pipe"])
remove_next_upgrade(data.raw["lab"]["is-infusion-lab"])
remove_next_upgrade(data.raw["radar"]["cm-combat-vision-tower"])
remove_next_upgrade(data.raw["radar"]["cm-combat-enhanced-radar"])
remove_next_upgrade(data.raw["lamp"]["Industrial-Lamp"])
remove_next_upgrade(data.raw["lamp"]["cm-item-nrg-large-lamp"])
remove_next_upgrade(data.raw["roboport"]["cm-item-log-dispatch"])
remove_next_upgrade(data.raw["roboport"]["cm-item-log-small-repeater"])
remove_next_upgrade(data.raw["roboport"]["cm-item-log-medium-repeater"])
remove_next_upgrade(data.raw["roboport"]["cm-item-log-big-repeater"])
remove_next_upgrade(data.raw["roboport"]["lognet-fcpu"])
for k, v in pairs(data.raw["mining-drill"]) do
    if starts_with(k, "cm-production-buddy") then remove_next_upgrade(v) end
end
for k, v in pairs(data.raw["ammo-turret"]) do
    if starts_with(k, "cm-") then remove_next_upgrade(v) end
end
for k, v in pairs(data.raw["electric-turret"]) do
    if starts_with(k, "cm-") then remove_next_upgrade(v) end
end
for k, v in pairs(data.raw["assembling-machine"]) do
    if k:sub(-14) == "-unit-deployer" then remove_next_upgrade(v) end
end
if mods["5dim_module"] then
    for i = 2, 10 do
        for _, key in pairs({"collision_box", "selection_box", "collision_mask"}) do
            data.raw.beacon["5d-beacon-"..(i < 10 and "0" or "")..i][key] = util.table.deepcopy(data.raw.beacon.beacon[key])
        end
    end
    remove_next_upgrade(data.raw.beacon["ee-super-beacon"])
    remove_next_upgrade(data.raw.beacon["ee-super-beacon-spaced"])
end
if mods["5dim_nuclear"] then
    for i = 2, 10 do
        data.raw.reactor["5d-nuclear-reactor-"..(i < 10 and "0" or "")..i].collision_mask = util.table.deepcopy(data.raw.reactor["nuclear-reactor"].collision_mask)
    end
end

if mods["space-exploration"] then
    local function find_furnace(name)
        if data.raw.furnace[name] then return data.raw.furnace[name] end
        if data.raw["assembling-machine"][name] then return data.raw["assembling-machine"][name] end
        if data.raw[name] then return data.raw[name] end
    end

    local function has_kiln(furnace)
        for _, cat in pairs(furnace.crafting_categories) do
            if cat == "kiln" then return true end
        end
        return false
    end

    local function add_kiln(furnace)
        log("Adding kiln crafting category to furnace " .. furnace.name)
        table.insert(furnace.crafting_categories, "kiln")
    end

    local function check_and_add(furnaceName)
        local furnace = find_furnace(furnaceName)
        if furnace and not has_kiln(furnace) then add_kiln(furnace) end
    end

    for i = 1, 10 do
        check_and_add("5d-electric-furnace-" .. (i < 10 and "0" or "") .. i)
        check_and_add("mini-furnace-" .. i)
        check_and_add("micro-furnace-" .. i)
    end
end

if mods["5dim_automation"] then
    for i = 2, 10 do
        local lab_name = "5d-lab-" .. (i < 10 and "0" or "") .. i
        data.raw.lab[lab_name].se_allow_in_space = true
        if mods["Krastorio2"] then
            data.raw.lab[lab_name].inputs = util.table.deepcopy(data.raw.lab["biusart-lab"].inputs)
        else
            data.raw.lab[lab_name].inputs = util.table.deepcopy(data.raw.lab["lab"].inputs)
        end
    end
end

for lab, labData in next, data.raw.lab do
    local inputs_seen = {}
    for i, input in ipairs(labData.inputs) do
        if inputs_seen[input] then
            labData.inputs[i] = nil
        else
            inputs_seen[input] = true
        end
    end
end
