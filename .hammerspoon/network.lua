-- Run the following script to allow sudo to run without a password:
--
-- sudo cat >|/private/etc/sudoers.d/hammerspoon_network <<HERE
-- $SUDO_USER ALL=(root) NOPASSWD: /sbin/ifconfig en0 down
-- $SUDO_USER ALL=(root) NOPASSWD: /sbin/ifconfig en0 up
-- HERE

local network = {}

local sudo = require "sudo"
local IFCONFIG = "/sbin/ifconfig"
local DEFAULT_INTERFACE = "en0"

local startNetwork, notifyNetwork

function network.restartNetwork(interface)
    print("Marking interface 'down': " .. interface)
    sudo(startNetwork(interface), { IFCONFIG, interface, "down" }):start()
end

startNetwork = function (interface)
    return function(exitCode, stdout, stderr)
        if exitCode == 0 then
            hs.timer.doAfter(1, function ()
                print("Marking interface 'up': " .. interface)
                sudo(notifyNetwork(interface), { IFCONFIG, interface, "up" }):start()
            end)
        else
            hs.notify.show("Error", "'ifconfig en0 down' exited with code: " .. exitCode, stderr)
            print(stderr)
        end
    end
end

notifyNetwork = function (interface)
    return function (exitCode, stdout, stderr)
        if exitCode == 0 then
            print("Complete")
            hs.notify.show("Network Restart complete", "", interface .. " has been restarted.")
        else
            hs.notify.show("Error", "'ifconfig " .. interface .. " up' exited with code: " .. exitCode, stderr)
            print(stderr)
        end
    end
end

hs.urlevent.bind("bounce-network", function (name, params)
    local interface = DEFAULT_INTERFACE
    if params.interface ~= nil then
        interface = params.interface
    end
    network.restartNetwork(interface)
end)

return network
