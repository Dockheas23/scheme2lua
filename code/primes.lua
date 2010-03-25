function primes(n)
    local i = 1
    local k = 2
    while i <= n do
        if isPrime(k) then
            print(i .. ": " .. k)
            i = i + 1
        end
        k = k + 1
    end
end

function isPrime(n)
    if n < 2 then
        return false
    else
        local k = 2
        while k < n do
            if n % k == 0 then
                return false
            end
            k = k + 1
        end
        return true
    end
end

primes(2000)
