function primes(n)
    local primecount = 1
    local current = 2
    repeat
        if primecount > n then
            print("\n")
            break
        elseif isPrime(current) then
            print(primecount .. ": " .. current)
            primecount = primecount + 1
            current = current + 1
        else
            current = current + 1
        end
    until false
end

function isPrime(n)
    if n < 2 then
        return false
    else
        local k = 2
        repeat
            if n == k then
                return true
            elseif n % k == 0 then
                return false
            else
                k = k + 1
            end
        until false
    end
end

primes(5000)
