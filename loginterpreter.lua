require( "logapi" )
local comp = require( "component" )

local gpu = comp.gpu

local fs = require( "filesystem" )
local term = require( "term" )
local event = require( "event" )

local tdl = 17
local infl = 60
local pril = 16
local display_amount = 5
local curdisplay = 1

local whitecol = 0xFFFFFF
local blackcol = 0x000000
local selcol = 0x00AA55
local logfilecol = 0x00FFFF

path = "/"

gpu.setForeground( whitecol )
gpu.setBackground( blackcol )

function pad( str, lenpad )
	return str .. string.rep( " ", lenpad - #str )
end

function drawHeader( )
	term.write( "|" .. string.rep( "=", tdl ) .. "|" .. string.rep( "=", infl ) .. "|" .. string.rep( "=", pril ) .. "|\n" )
	term.write( "|----Date/Time----|----------------------------Info----------------------------|----Priority----|\n" )
end

function drawEntry( entry )
	i = 1
	while true do
		term.write(
		"|" .. pad( string.sub( entry.timedatestamp, (i*tdl)-(tdl-1), i*tdl ), tdl ) .. 
		"|" .. pad( string.sub( entry.info, (i*infl)-(infl-1), i*infl ), infl ) .. 
		"|" .. pad( string.sub( entry.priority, (i*pril)-(pril-1), i*pril ), pril ) ..
		"|\n")
		
		i = i + 1
		
		if ( ( #entry.timedatestamp < i*tdl ) and ( #entry.info < i*infl ) and ( #entry.priority < i*pril ) ) then
			term.write( "|" .. string.rep( "-", tdl ) .. "|" .. string.rep( "-", infl ) .. "|" .. string.rep( "-", pril ) .. "|\n" )
			break
		end	
	end
end

function interpretelogFile( path )
	local clog = logContainer( )
	clog:loadFrom( path )
	
	shownEntries = clog.entries
	
	while true do
		term.clear( )
		drawHeader( )
		for i = curdisplay, curdisplay + display_amount do
			if ( i > #shownEntries ) then
				break
			end
			drawEntry( shownEntries[ i ] )
		end
		term.write( "|" .. string.rep( "=", tdl ) .. "|" .. string.rep( "=", infl ) .. "|" .. string.rep( "=", pril ) .. "|\n" )
		
		term.write( "Use arrow keyes for navigation\nQ to (Q)uit\nF to (F)ind\nR to (R)eset\n" ) -- q 16 f 33 d 32 p 25 r 19
		
		ev, addr, ch, co, pl = event.pull( "key_down" )
		
		if ( co == 200 and curdisplay > 1 ) then
			curdisplay = curdisplay - 1
		elseif ( co == 208 and curdisplay < #shownEntries - display_amount ) then
			curdisplay = curdisplay + 1
		elseif ( co == 16 ) then
			term.clear( )
			break
		elseif ( co == 19 ) then
			shownEntries = clog.entries
		elseif ( co == 33 ) then
			curdisplay = 1
			while true do
				term.clear()
				term.write( "By (D)ate or by (P)riority?\nQ to (Q)uit\n" )
				ev, addr, ch, co, pl = event.pull( "key_down" )
				if ( co == 16 ) then
					break
				elseif ( co == 32 ) then
					term.write( "Date to filter: " )
					dtf = term.read( )
					shownEntries = clog:findEntriesByDateTime( string.sub( dtf, 1, #dtf-1 ) )
					break
				elseif ( co == 25 ) then
					term.write( "Priority to filter: " )
					ptf = term.read( )
					shownEntries = clog:findEntriesByPriority( string.sub( ptf, 1, #ptf-1 ) )
					break
				end
			end
		end

	end
	
end

function choose( options )
	local sel = 1
	
	while true do
		term.clear( )
		for k, v in ipairs( options ) do
			if ( k == sel ) then
				gpu.setForeground( selcol )
				term.write( v .. " <--\n" )
				gpu.setForeground( whitecol )
			else
				if ( string.sub( v, #v - 3, #v ) == ".log" ) then
					gpu.setForeground( logfilecol )
				end
				term.write( v .. "\n" )
				gpu.setForeground( whitecol )
			end
		end
		
		ev, addr, ch, co, pl = event.pull( "key_down" )
		
		if ( co == 200 ) then -- 200 208 28
			if ( sel > 1 ) then
				sel = sel - 1
			else
				sel = #options
			end
		elseif ( co == 208 ) then
			if ( sel < #options ) then
				sel = sel + 1
			else
				sel = 1
			end
		elseif ( co == 28 ) then
			return options[sel]
		end
		
	end
end

while true do
	dirs = { }
	
	table.insert( dirs, "<<exit>>" )
	table.insert( dirs, "<<root>>" )
	
	for dir in fs.list( path ) do
		table.insert( dirs, dir )
	end
	
	choice = choose( dirs )
	
	if ( choice == "<<root>>" ) then
		path = "/"
	elseif ( choice == "<<exit>>" ) then
		term.clear( )
		break
	else
		newpath = path .. "/" .. choice
		
		term.write( string.sub( newpath, #newpath-4, #newpath ) )

		if ( fs.isDirectory( newpath ) ) then
			path = newpath
		elseif ( string.sub( newpath, #newpath-3, #newpath ) == ".log" ) then
			interpretelogFile( newpath )
		end
	end
end