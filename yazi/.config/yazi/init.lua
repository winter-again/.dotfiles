function Status:name()
    local h = cx.active.current.hovered
    if h == nil then
        return ui.Span("")
    end

    local linked = ""
    if h.link_to ~= nil then
        linked = " -> " .. tostring(h.link_to)
    end
    return ui.Span(" " .. h.name .. linked)
end

function Linemode:size_and_mtime()
    local time = math.floor(self._file.cha.modified or 0)
    if time == 0 then
        time = ""
    elseif os.date("%Y", time) == os.date("%Y") then
        time = os.date("%b %d %H:%M", time)
    else
        time = os.date("%b %d  %Y", time)
    end

    local size = self._file:size()
    return ui.Line(string.format("%s %s", size and ya.readable_size(size) or "-", time))
end
