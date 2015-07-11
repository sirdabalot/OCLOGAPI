require( "logapi" )
term = require( "term" )

newlog = logContainer( )

newlog:loadFrom("testser.log")

for k, v in ipairs ( newlog.entries ) do
	term.write( v.timedatestamp .. "#" .. v.info .. "#" .. v.priority .. "\n")
end

for k, v in ipairs ( newlog:findEntryByPriority( "5" ) ) do
	term.write( v:serialize() )
end