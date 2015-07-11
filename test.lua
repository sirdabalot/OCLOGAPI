require("logapi")
term = require("term")

newlog = logContainer( )

for i = 1, 10 do
	newlog:addEntry( entry( nil,string.rep( "test" .. i, 20), i + 1 ) )
end

newlog:save("testser.log")