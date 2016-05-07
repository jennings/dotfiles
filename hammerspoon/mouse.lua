local interceptBackForward = hs.eventtap.new({25}, function(evt)
    local key = evt:getProperty(3)
    if key == 3 then
        hs.eventtap.event.newKeyEvent({"cmd"}, "left", true):post()
    elseif key == 4 then
        hs.eventtap.event.newKeyEvent({"cmd"}, "right", true):post()
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
