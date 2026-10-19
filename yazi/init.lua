require("zoxide"):setup({ update_db = true })
require("rel-motions"):setup()

-- Double-click directories to enter them and files to open them.
local last_click_url = nil
local last_click_time = 0
local double_click_delay = 0.35

function Entity:click(event, up)
    if up or not event.is_left then
        return
    end

    local file = self._file
    if not file then
        return
    end

    local url = tostring(file.url)
    local now = os.clock()

    if url == last_click_url
        and now - last_click_time <= double_click_delay
    then
        last_click_url = nil
        last_click_time = 0

        if file.cha.is_dir then
            ya.emit("enter", {})
        else
            ya.emit("open", {})
        end
    else
        last_click_url = url
        last_click_time = now
        ya.emit("reveal", { file.url })
    end
end
