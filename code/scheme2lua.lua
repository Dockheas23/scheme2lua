require("parser")
require("procedures")
require("scanner")

-- Output the preamble
-- io.input("procedures.lua")
-- io.write(io.read("*a"))
io.input(io.stdin)

-- The main loop for the translator
scanner.init()
local expression = parser.parse(scanner.nextToken())
while expression ~= nil do
    print(tostring(expression))
    expression = parser.parse(scanner.nextToken())
end
