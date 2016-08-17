-- I have a mouse which has back/forward buttons, but OS X doesn't interpret
-- these as back and forward. This script listens for buttons 3 and 4 to be
-- pressed, and posts a CMD-Left or CMD-Right command instead.
--
-- I've also added an item in the menu bar so I can disable this interception,
-- just in case I run across something that this interception logic interferes
-- with (games, maybe?).

local interceptBackForward = hs.eventtap.new({25}, function(evt)
    -- Return true from this function to swallow the existing event.
    -- Return false to allow it through.
    local key = evt:getProperty(3)
    if key == 3 then
        hs.eventtap.event.newKeyEvent({"cmd"}, "left", true):post()
        return true
    elseif key == 4 then
        hs.eventtap.event.newKeyEvent({"cmd"}, "right", true):post()
        return true
    else
        -- Let the middle-click through
        return false
    end
end)

local mouseMenu = hs.menubar.new():setTitle("🖱")

function enableIntercept()
    interceptBackForward:start()
    mouseMenu:setMenu({
        { title="Send back/forward keys", state="on", fn=disableIntercept}
    })
end

function disableIntercept()
    interceptBackForward:stop()
    mouseMenu:setMenu({
        { title="Send back/forward keys", state="off", fn=enableIntercept}
    })
end

enableIntercept()
