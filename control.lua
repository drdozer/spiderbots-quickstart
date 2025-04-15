local spiderbot_item_name = "spiderbot"

script.on_init(function(event)
    local spiderbot_count = settings.global["spiderbot-starter-count"].value
    if spiderbot_count == nil or type(spiderbot_count) ~= "number" or spiderbot_count < 0 then
        spiderbot_count = 1
    end

    if spiderbot_count > 0 then
        if prototypes.item[spiderbot_item_name] ~= nil then
            if remote.interfaces['freeplay'] then
                local created_items = remote.call('freeplay', 'get_created_items')
                created_items[spiderbot_item_name] = spiderbot_count
                remote.call('freeplay', 'set_created_items', created_items)
            else
                log("Could not find freeplay")
            end
        else
            log("Spiderbots Quickstart: Spiderbots are not available in this game.")
        end
    end
end)
