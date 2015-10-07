local fs = require( "filesystem" )
local term = require( "term" )

--Container

local logContainerMeta = { }

logContainerMeta.__index = logContainerMeta

function logContainer( inPath ) -- Creates a log container ( sort of a massive list for entries ).
	slc = {
		path = inPath
		entries = { }
	}
	setmetatable( slc, logContainerMeta )
	
	if ( fs.exists( inPath ) ) then
		slc:loadFrom( inPath )
	end
	
	return slc
end

function logContainerMeta:addEntry( newEntry ) -- Adds an entry "object" to the specified container.
	table.insert( self.entries, newEntry )
	file = io.open( self.path, "wa" )
	io.output( file )
	io.write( newEntry.serialize, "\n" )
	io.flush( file )
	io.close( file )
end

-- Looks through container and returns a new table of entries that are matching the filter.

function logContainerMeta:findEntriesByPriority( filterPriority ) 
	retTable = { }
	
	for k, v in ipairs( self.entries ) do
		if ( v.priority == tostring( filterPriority ) ) then
			table.insert( retTable, v )
		end
	end
	
	return retTable
end

-- Looks through container and returns a new table of entries that are matching the filter.
-- Note that the filter can be either dd/mm/yy, hh/mm/ss, or dd/mm/yy hh/mm/ss.

function logContainerMeta:findEntriesByDateTime( filtertd )
	retTable = { }
	
	for k, v in ipairs( self.entries ) do
		if (
		v.timedatestamp == filtertd or
		string.sub( v.timedatestamp, 1, 8 ) == filtertd or
		string.sub( v.timedatestamp, 10, 18 ) == filtertd
		) then
			table.insert( retTable, v )
		end
	end
	
	return retTable
end

function logContainerMeta:loadFrom( path ) -- Loads an entry list from the specified path
	io.input( path )
	for line in io.lines( ) do
		self:addEntry( entryUnserialize( line ) )
	end
end

function logContainerMeta:save( path ) -- Saves the entry list to the specified path
	io.output( path )
	for k, v in ipairs( self.entries ) do
		io.write( v:serialize( ), "\n" )
	end
	io.flush( )
	io.close( )
end

function logContainerMeta:exportCSV( path )
	io.output( path )
	io.write( "Date/Time,Log Info,Priority\n" )
	for k, v in ipairs( self.entries ) do
		io.write( v:serializeCSV( ), "\n" )
	end
	io.flush( )
	io.close( )
end

--Entry

local entryMeta = { }

entryMeta.__index = entryMeta

function entry( intds, inInfo, inPriority ) -- Create new entry "object", intds can be either nil ( get current time ) or you can specify a time, make sure it's in the correct format
	e = {
		timedatestamp = "",
		info = tostring( inInfo ),
		priority = tostring( inPriority )
	}
	
	if ( intds == nil ) then
		e.timedatestamp = tostring( os.date( ) )
	else
		e.timedatestamp = tostring( intds )
	end
	
	setmetatable( e, entryMeta )
	return e
end

function entryUnserialize( entrystring ) -- Takes a string and creates an entry from it
	part = 0
	
	tds = ""
	inf = ""
	pri = ""
	
	for i = 1, #entrystring do
		cchar = string.sub( entrystring, i, i )
		if ( cchar == "|" ) then
			part = part + 1
		else
			if ( cchar ~= "\t" ) then
				if ( part == 1 ) then
					tds = tds .. cchar
				elseif ( part == 2 ) then
					inf = inf .. cchar
				elseif ( part == 3 ) then
					pri = pri .. cchar
				end
			end
			
		end
		
	end
	
	return entry( tds, inf, pri )
	
end

function entryMeta:serialize( ) -- Serializes entry for transmission or storage
	return "|" .. self.timedatestamp .. "|" .. self.info .. "|" .. self.priority .. "|"
end

function entryMeta:serializeCSV( ) -- Serializes entry for transmission or storage
	return "\"" .. self.timedatestamp .. "\",\"" .. self.info .. "\",\"" .. self.priority .. "\""
end