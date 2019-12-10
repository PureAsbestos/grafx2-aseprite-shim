-- A shim between grafx2 scripts and the Aseprite scripting API
-- (C) PureAsbestos, 2019


-- BEGIN [NECESSARY FOR DB_PALETTE_ANALYSIS] --

-- requires dialogs to be present in the API, so check that they are available
if not app.isUIAvailable then 
	print("Your version of Aseprite is incompatible with this script.")
	do return end
end


-- the simple textbox with an "OK" button
messagebox = app.alert

cel0 = nil
function get_cel0()
	if cel0 == nil then
		cel0 = app.activeSprite:newCel(app.activeLayer, 1)
	end
	return cel0
end

-- get the palette of the active sprite
function get_pal()
	local pal = app.activeSprite.palettes[1]
	if #pal ~= 256 then
		pal:resize(256)
	end
	return pal
end

math.pow = function(x,y) return x^y end

updatescreen = app.refresh
function waitbreak(...) end

function statusmessage(message)
	print(message)
end

-- foreground and background colors
function getforecolor() 
	return app.fgColor
end

function getbackcolor()
	return app.bgColor
end

-- get color from palette
function getcolor_obj(i)
	return get_pal():getColor(i)
end

function getcolor(i)
	local c = getcolor_obj(i)
	return c.red, c.green, c.blue
end

function setcolor(i, r, g, b)
	get_pal():setColor(i, Color{red=r, green=g, blue=b})
	app.refresh()
end

-- get nearest color in palette
function matchcolor(r, g, b)
	local pal = get_pal()
	local nearest_dist = 10000
	local nearest_index = 0
	local dist
	for i=0,(#pal-1) do
		c = pal:getColor(i)
		dist = math.sqrt( (r-c.red)*(r-c.red) + (g-c.green)*(g-c.green) + (b-c.blue)*(b-c.blue) )
		if dist < nearest_dist then
			nearest_dist = dist
			nearest_index = i
		end
	end
	return nearest_index
end
-- why do we need this??
matchcolor2 = matchcolor

-- sets the sprite size
function setpicturesize(x, y)
	app.command.SpriteSize { ui=false, width=x, height=y }
end

-- clears the first cel with the specified color
function clearpicture(color)
	get_cel0().image:clear(getcolor_obj(color))
end

-- draws a pixel
function putpicturepixel(x, y, c)
	local r, g, b = getcolor(c)
	get_cel0().image:drawPixel(x, y, app.pixelColor.rgba(r, g, b))
end

-- gets a pixel
function getpicturepixel(x, y)
	c = get_cel0().image:getPixel(x, y)
	r = app.pixelColor.rgbaR(c)
	g = app.pixelColor.rgbaG(c)
	b = app.pixelColor.rgbaB(c)
	return matchcolor(r, g, b)
end

function getpicturesize()
	return app.activeSprite.width, app.activeSprite.height
end

function drawfilledrect(x1, y1, x2, y2, c)
	app.useTool{ tool="filled_rectangle", color=getcolor_obj(c), points={Point(x1, y1), Point(x2, y2)}, cel=get_cel0() }
end

-- dialog to click a button in a select menu
function selectbox(title, ...)
	local args = {...}
	local dlg = Dialog(title)

	local function closethenrun(f)
		return function() dlg:close(); f(); end
	end

	for i=1,(#args/2) do
		local label = args[i*2-1]
		local func = args[i*2]
		dlg:button{ text=label, onclick=closethenrun(func) }
		dlg:newrow()
	end

	dlg:show()

end

-- dialog to get user input
function inputbox(title, ...)
	-- colors = get_pal()
	local args = {...}
	local dlg = Dialog(title)

	local function closethenrun(f)
		return function() dlg:close(); f(); end
	end

	local function okbutton()
		dlg:close()
	end

	for i=1,(#args/5) do
		local label     = args[i*5-4]
		local default   = args[i*5-3]
		local min       = args[i*5-2]
		local max       = args[i*5-1]
		local precision = args[i*5]

		if min == 0 and max == 1 and precision <= 0 then
			if precision == 0 then
				dlg:check{ id=tostring(i+1), label=label, selected=default }
			elseif precision < 0 then --!TODO Implement radio buttons properly
				dlg:check{ id=tostring(i+1), label=label, selected=default }
			end
		else
			dlg:number{ id=tostring(i+1), label=label, decimals=precision, text=tostring(default) }
		end

		dlg:newrow()

	end

	dlg:button{ id="1", text="OK"}
	dlg:button{ text="Cancel" }

	dlg:show()

	local data = dlg.data
	local out = {}
	for k,v in pairs(data) do
		if type(v) == "boolean" then
			out[math.tointeger(k)] = v and 1 or 0
		else
			out[math.tointeger(k)] = v
		end
	end

	if dlg.data["1"] then
		out[1] = true
	else
		out[1] = false
	end

	return table.unpack(out)

end

-- END [NECESSARY FOR DB_PALETTE_ANALYSIS] --

--!FIXME
function setbrushsize(size)
	app.alert("setbrushsize not in a working state yet")
	local abr = app.activeBrush
	local br = Brush{type=abr.type, size=Size{size, size}, angle=abr.angle, center=abr.center,
					 image=Image(size, size), pattern=abr.pattern, patternOrigin=abr.patternOrigin}
	app.activeBrush = br
end

--!FIXME
function putbrushpixel(x, y, c)
	app.alert("putbrushpixel not in a working state yet")
	r, g, b = getcolor(c)
	app.activeBrush.image:drawPixel(x, y, app.pixelColor.rgba(r, g, b))
end

