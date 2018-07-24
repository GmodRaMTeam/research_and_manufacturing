---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Комерад.
--- DateTime: 5/26/2018 2:16 PM
---

-- Like string.FormatTime but simpler (and working), always a string, no hour
-- support
function util.SimpleTime(seconds, fmt)
	if not seconds then seconds = 0 end

    local ms = (seconds - math.floor(seconds)) * 100
    seconds = math.floor(seconds)
    local s = seconds % 60
    seconds = (seconds - s) / 60
    local m = seconds % 60

    return string.format(fmt, m, s, ms)
end