local SUDO = "/usr/bin/sudo"

function sudo(done, args)
    return hs.task.new(SUDO, done, args)
end

return sudo
