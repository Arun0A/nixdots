--- @since 25.5.28

local DIGIT_KEYS = {
	{ on = "0" }, { on = "1" }, { on = "2" }, { on = "3" }, { on = "4" },
	{ on = "5" }, { on = "6" }, { on = "7" }, { on = "8" }, { on = "9" },
	{ on = "j" }, { on = "k" }, { on = "g" }, { on = "G" },
	{ on = "<Down>" }, { on = "<Up>" },
}

-----------------------------------------------
----------------- R E N D E R -----------------
-----------------------------------------------

-- Overrides the file-list number gutter to show relative offsets from the
-- hovered row.
local setup_numbers = ya.sync(function()
	Entity.number = function(_, index, _, file, hovered)
		local idx
		if hovered == index then
			idx = file.idx
		else
			idx = math.abs(hovered - index)
		end
		local pad = #tostring(idx) < 3 and 3 or #tostring(idx)
		if hovered == index then
			return ui.Span(string.format("%" .. pad .. "d ", idx))
		else
			return ui.Span(string.format(" %" .. pad .. "d", idx))
		end
	end

	Current.redraw = function(self)
		local files = self._folder.window
		if #files == 0 then
			return self:empty()
		end

		local hovered_index
		for i, f in ipairs(files) do
			if f.is_hovered then
				hovered_index = i
				break
			end
		end

		local entities, linemodes = {}, {}
		for i, f in ipairs(files) do
			linemodes[#linemodes + 1] = Linemode:new(f):redraw()
			local entity = Entity:new(f)
			entities[#entities + 1] = ui.Line({ Entity:number(i, #self._folder.files, f, hovered_index), entity:redraw() })
				:style(entity:style())
		end

		return {
			ui.List(entities):area(self._area),
			ui.Text(linemodes):area(self._area):align(ui.Align.RIGHT),
		}
	end

	if ui.render then ui.render() else ya.render() end
end)

-----------------------------------------------
--------- C O M M A N D   P A R S E R ---------
-----------------------------------------------

-- Reads digits, then a final j/k/g/G (or arrow), returning (count, verb).
-- Mirrors vim: a bare "j"/"k" with no digits means count = 1.
local function read_motion(first_digit)
	local digits = first_digit or ""

	while true do
		local key = ya.which { cands = DIGIT_KEYS, silent = true }
		if not key then
			return nil, nil
		end

		local on = DIGIT_KEYS[key].on
		if tonumber(on) then
			digits = digits .. on
		else
			if on == "<Down>" then on = "j" end
			if on == "<Up>" then on = "k" end
			return tonumber(digits) or 1, on
		end
	end
end

-----------------------------------------------
---------- E N T R Y   /   S E T U P ----------
-----------------------------------------------

return {
	entry = function(_, job)
		local first_digit
		local args = job.args
		if args and #args > 0 and tonumber(args[1]) then
			first_digit = tostring(args[1])
		end

		local count, verb = read_motion(first_digit)
		if not count or not verb then
			return
		end

		if verb == "j" then
			ya.emit("arrow", { count })
		elseif verb == "k" then
			ya.emit("arrow", { -count })
		elseif verb == "g" then
			-- gg goes to top, [count]g jumps to absolute line `count`
			if not first_digit and count == 1 then
				ya.emit("arrow", { "top" })
			else
				ya.emit("arrow", { "top" })
				ya.emit("arrow", { count - 1 })
			end
		elseif verb == "G" then
			if not first_digit and count == 1 then
				ya.emit("arrow", { "bot" })
			else
				ya.emit("arrow", { "top" })
				ya.emit("arrow", { count - 1 })
			end
		end
	end,

	setup = function(_, args)
		if args and args.show_numbers == false then
			return
		end
		setup_numbers()
	end,
}
