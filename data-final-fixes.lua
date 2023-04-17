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
remove_next_upgrade(data.raw["reactor"]["nuclear-reactor"])
remove_next_upgrade(data.raw["beacon"]["beacon"])

for k, v in pairs(data.raw["mining-drill"]) do
    if string.sub(k, 1, 20) == "cm-production-buddy" then remove_next_upgrade(v) end
end
for k, v in pairs(data.raw["ammo-turret"]) do
    if string.sub(k, 1, 3) == "cm-" then remove_next_upgrade(v) end
end
for k, v in pairs(data.raw["electric-turret"]) do
    if string.sub(k, 1, 3) == "cm-" then remove_next_upgrade(v) end
end
for k, v in pairs(data.raw["assembling-machine"]) do
    if string.sub(k, -14) == "-unit-deployer" then remove_next_upgrade(v) end
end

-----------------------------------------------------------------------------------
-- Dear Nihilistzsche, "string.starts_with" is not a thing, use string.sub instead
-----------------------------------------------------------------------------------


-- This checks if anything in the data.raw table isnt named "5d-" and if it has a next_upgrade that starts with "5d-" then it removes the next_upgrade
for k, v in pairs(data.raw) do
    -- step 1: loop through all the tables in data.raw
    for k2, v2 in pairs(v) do
        -- step 2: loop through all the items in the table
        if v2.next_upgrade then
            -- step 3: check if the item has a next_upgrade
            if v2.name:sub(1, 3) == "5d-" then
                -- step 4: check if the item is named "5d-" and if it is then skip to the next item
                return
            else
                -- step 5: check if the item is not named "5d-"
                if v2.next_upgrade:sub(1, 3) == "5d-" then
                    -- step 6: check if the next_upgrade is named "5d-" and if it is then remove the next_upgrade
                    log("Removing next upgrade from " .. v2.name)
                    v2.next_upgrade = nil
                end
            end
        end
    end
end

if mods["5dim_module"] then
    data.raw.beacon.beacon.collision_box = table.deepcopy(data.raw.beacon["5d-beacon-02"].collision_box)
    data.raw.beacon.beacon.selection_box = table.deepcopy(data.raw.beacon["5d-beacon-02"].selection_box)
    data.raw.beacon.beacon.collision_mask = table.deepcopy(data.raw.beacon["5d-beacon-02"].collision_mask)
end
if mods["5dim_nuclear"] then
    data.raw.reactor["nuclear-reactor"].collision_mask =
        table.deepcopy(data.raw.reactor["5d-nuclear-reactor-02"].collision_mask)
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

if (mods["Krastorio2"] or mods["space-exploration"]) and mods["5dim_automation"] then
    for i = 2, 10 do
        local lab_name = "5d-lab-" .. (i < 10 and "0" or "") .. i
        if mods["Krastorio2"] then
            table.insert(data.raw.lab[lab_name].inputs, "basic-tech-card")
            table.insert(data.raw.lab[lab_name].inputs, "production-science-pack")
            table.insert(data.raw.lab[lab_name].inputs, "utility-science-pack")
            table.insert(data.raw.lab[lab_name].inputs, "matter-tech-card")
        end
        if mods["space-exploration"] then
            if mods["Krastorio2"] then table.insert(data.raw.lab[lab_name].inputs, "kr-optimization-tech-card") end
            table.insert(data.raw.lab[lab_name].inputs, "se-rocket-science-pack")
        end
    end
end
