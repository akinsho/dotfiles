local BIGFONT
local UNITS = {"B", "kB", "MB", "GB", "TB", "PB"}

function conky_init(bigfont)
    -- Decode spaces encoded in conkyrc.lua
    BIGFONT = (bigfont:gsub("\1", " "))
end

local function human_size(n)
    local unit
    for _, u in ipairs(UNITS) do
        if n < 1000 then
            unit = u
            break
        end
        n = n / 1000
    end

    if n >= 10 or n == 0.0 then
        return string.format("%.0f", n), unit
    else
        return string.format("%.1f", n), unit
    end
end

local function bigint(s)
    return (s:gsub("^([0-9]+)", "${font " .. BIGFONT .. "}%1${font}"))
end

function conky_fs_free(path)
    local bytes = tonumber(conky_parse(("${fs_free %s}"):format(path)))
    return bigint(("%s %s"):format(human_size(bytes)))
end

local function speedk(dir, iface)
    local n = tonumber(conky_parse(("${%sspeed %s}"):format(dir, iface))) / 1000
    if n >= 10 or n == 0 then
        return ("%.0f"):format(n)
    else
        return ("%.1f"):format(n)
    end
end

function conky_upspeedf(iface)
    return bigint(speedk("up", iface))
end

function conky_downspeedf(iface)
    return bigint(speedk("down", iface))
end