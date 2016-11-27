local anybar = {}
local log = hs.logger.new('anybar', 'debug')

local WHITE = "⚪️"
local RED = "🔴"
local ORANGE = "🍊"
local YELLOW = "🌕"
local GREEN = "🍏"
local CYAN = "💧"
local BLUE = "🔵"
local PURPLE = "🍇"
local BLACK = "⚫️"
local QUESTION = "❓"
local EXCLAMATION = "⚠️"

local anybarMenu

local function setMenu(char)
    if anybarMenu == nil then
        anybarMenu = hs.menubar.new()
    end
    anybarMenu:setTitle(char)
end

local function removeMenu()
    if anybarMenu ~= nil then
        anybarMenu:delete()
        anybarMenu = nil
    end
end

local server = nil

local function handle(data, sockaddr)
    local char
    if data == "white" then
        char = WHITE
    elseif data == "red" then
        char = RED
    elseif data == "orange" then
        char = ORANGE
    elseif data == "yellow" then
        char = YELLOW
    elseif data == "green" then
        char = GREEN
    elseif data == "cyan" then
        char = CYAN
    elseif data == "blue" then
        char = BLUE
    elseif data == "purple" then
        char = PURPLE
    elseif data == "black" then
        char = BLACK
    elseif data == "question" then
        char = QUESTION
    elseif data == "exclamation" then
        char = EXCLAMATION
    else
        return
    end

    setMenu(char)
end

function anybar.stop()
    removeMenu()
    if server ~= nil and not server:closed() then
        server:close()
    end
    server = nil
end

function anybar.start()
    if server ~= nil then
        log.i('already started')
    else
        server = hs.socket.udp.server(1738, handle):receive()
        setMenu(WHITE)
    end
end

anybar.start()

return anybar
