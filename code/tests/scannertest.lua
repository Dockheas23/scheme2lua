require("scanner")

--
-- Create test input file
--
io.output("/tmp/s2ltest_chars.scm")
io.write("(+ 1 2)\n")
io.write("(display \"abc\")\n")
io.close()

io.output("/tmp/s2ltest_tokens.scm")
io.write("(newline) ; This should print a newline\n")
io.write("#| Commented out section\n")
io.write("(+ 1 2)\n")
io.write("(define x #| Nested #| Another nest |# block comment |# 5)\n")
io.write("(display \"abc\")\n")
io.write("End of commented out section |#\n")
io.write("; Another one-line comment|#\n")
io.write("(lambda (->x) (+ ->x 1))\n")
io.write("(* (+ 3 5) 2 3)\n")
io.close()

io.output(io.stdout)

characters = {
    "(", "+", " ", "1", " ", "2", ")", "\n",
    "(", "d", "i", "s", "p", "l", "a", "y", " ",
    "\"", "a", "b", "c", "\"", ")", "\n", 
}

tokens = {
    {"("}, {"symbol", "newline"}, {")"},
    {"("}, {"symbol", "lambda"},
	{"("}, {"symbol", "->x"}, {")"},
	{"("}, {"+"}, {"symbol", "->x"}, {"number", 1}, {")"},
    {")"},
    {"("}, {"symbol", "*"},
	{"("}, {"+"}, {"number", 3}, {"number", 5}, {")"},
	{"number", 2}, {"number", 3},
    {")"}
}

--
-- Run tests
--

-- Test char functions
io.input("/tmp/s2ltest_chars.scm")
scanner.init()
local index = 1
while scanner.peekChar() ~= "" do
    assert(scanner.peekChar() == characters[index]
    and scanner.nextChar() == characters[index])
    index = index + 1
end

-- Test token functions
io.input("/tmp/s2ltest_tokens.scm")
scanner.init()
index = 1
while scanner.peekToken() ~= "EOF" do
    local token, value = scanner.peekToken()
    assert(token == tokens[index][1] and value == tokens[index][2])
    token, value = scanner.nextToken()
    assert(token == tokens[index][1] and value == tokens[index][2])
    index = index + 1
end

print("Scannertest: All tests passed")
