---@diagnostic disable-next-line: lowercase-global
minetest = minetest

local function update()
    local text = ""
    for _, p in pairs(minetest.get_connected_players()) do
        text = text .. p:get_player_name() .. ": killed " .. p:get_meta():get_int("score:kills") .. " ppl\n"
    end
    for _, p in pairs(minetest.get_connected_players()) do
    p:hud_change(p:get_meta():get_int("hud"), "text", text)
    end
end

---@diagnostic disable-next-line: undefined-global
minetest.register_on_joinplayer(function(ObjectRef, last_login)
    local meta = ObjectRef:get_meta()
    local text = ""
    local t = ""
    ---@diagnostic disable-next-line: undefined-global
    local idx = ObjectRef:hud_add({
     hud_elem_type = "text",
     position      = {x = 1, y = 0.1},
     offset        = {x = -100,   y = 0},
     text          = "",
     alignment     = {x = 0, y = 0},
     scale         = {x = 100, y = 100},
     number = "0xFF2222"
    })
    meta:set_int("hud",idx)
    ---@diagnostic disable-next-line: undefined-global
    minetest.chat_send_all("welcome " .. ObjectRef:get_player_name())
    update()
end)

minetest.register_on_dieplayer(function(ObjectRef,reason)
    local killer = reason.object
    if killer then
        minetest.chat_send_all(killer:get_player_name().." killed "..ObjectRef:get_player_name())
        local meta = killer:get_meta()
        meta:set_int("score:kills",meta:get_int("score:kills")+1)
    end
    update()
end)

minetest.register_on_leaveplayer(function(ObjectRef, timed_out)
    update()
end)