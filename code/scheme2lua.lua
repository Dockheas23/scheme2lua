require("parser")
require("procedures")
require("scanner")

-- Output the preamble
-- io.input("procedures.lua")
-- io.write(io.read("*a"))
io.input(io.stdin)

-- The main loop for the translator
scanner.init()
local token = parser.translate(scanner.nextToken())
while token ~= nil do
    print(token)
    token = parser.translate(scanner.nextToken())
end
