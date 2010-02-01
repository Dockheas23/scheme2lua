require("parser")
require("scanner")

--
-- Create test input file
--
io.output("/tmp/s2ltest_parser.scm")
io.write("display \"abc\"\n")
io.write("123 #\\l\n")
io.write("#f #t")
io.write("5 (\"a\" (1 2 3) #t #\\m)")
io.close()

io.output(io.stdout)

--
-- Run tests
--
io.input("/tmp/s2ltest_parser.scm")
scanner.init()
if assert(parser.evaluate(scanner.peekToken()) == "display") 
    and assert(parser.evaluate(scanner.nextToken()) == "display") 
    and assert(parser.evaluate(scanner.nextToken()) == "\"abc\"") 
    and assert(parser.evaluate(scanner.nextToken()) == 123) 
    and assert(parser.evaluate(scanner.nextToken()) == "\"l\"") 
    and assert(parser.evaluate(scanner.nextToken()) == false) 
    and assert(parser.evaluate(scanner.nextToken()) == true) 
    and assert(parser.readDatum() == 5) 
    and assert(parser.readDatum()[2][3] == 3) 
    then
    print("Parsertest: All tests passed")
end

