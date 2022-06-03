--[[ fractions.lua 0.1.0v
    by NonSuspicious
    docs: 
]]--
local extras = require("extras")
local fraction
local fractionMeta

fraction = {
    new = function(numerator, denominator, simplify) -- define a new fraction
        if type(numerator) == "string" and string.find( numerator, "/") then -- aditional feature, accepting one string input
            local frac = {}
            local counter = 1
            for i in string.split(numerator, "/") do
                if counter == 1 then
                    frac["n"] = tonumber(i)
                    counter = counter + 1
                elseif counter == 2 then
                    frac["d"] = tonumber(i)
                end
            end
            if denominator then -- simplify?
                frac = fraction.fix(frac)
                return setmetatable(frac, fractionMeta)
            end
            return setmetatable(frac, fractionMeta)
        end

        if numerator == nil or type(numerator) ~= "number" then -- check for bad input
            numerator = 1
        end
        if denominator == nil or type(denominator) ~= "number" then
            denominator = 1
        end

        local frac = {}
        frac["n"] = numerator
        frac["d"] = denominator

        if simplify then -- simplify?
            frac = fraction.fix(frac)
            return setmetatable(frac, fractionMeta)
        end

        return setmetatable(frac, fractionMeta)
    end,

    tostring = function(frac) -- convert fraction to string
        return frac["n"] .. "/" .. frac["d"]
    end,

    tonumber = function(fraction)
        return fraction["n"] / fraction["d"]
    end,

    simplify = function(a)
        local c = math.gcd(a["n"], a["d"])

        return fraction.new(a["n"] / c, a["d"] / c)
    end,

    fix = function(a) -- fix a fraction / make a fraction
        if type(a) == "table" then
            if a["n"] % 1 ~= 0 or a["d"] % 1 ~= 0 then -- non integer numerator or denominator

                local lenN = 1
                local lenD = 1

                if a["n"] % 1 ~= 0 then 
                    lenN = tostring(a["n"]):match("%.(%d+)"):len() -- get number count after the decimal point
                end
                if a["d"] % 1 ~= 0 then
                    lenD = tostring(a["d"]):match("%.(%d+)"):len()
                end

                local pwr = lenN > lenD and lenN or lenD

                print(pwr)

                a["n"] = a["n"] * 10 ^ pwr
                a["d"] = a["d"] * 10 ^ pwr

                return a -- return a fraction containing only integers

            end
        end
        if type(a) == "number" then -- number input

            if a % 1 == 0 then -- integer

                return fraction.new(a, 1)

            else -- non integer

                local pwr = tostring(a):match("%.(%d+)"):len()
                local d

                a = a * 10 ^ pwr
                d = 10 ^ pwr
                return fraction.new(a, d)

            end

        end

        return fraction.simplify(a) -- no need for fixes
    end,

    add = function(a, b) -- add two fractions
        a = fraction.fix(a)
        b = fraction.fix(b)

        local n = a["n"] * b["d"] + b["n"] * a["d"]
        local d = a["d"] * b["d"]

        local c = math.gcd(n, d)

        return fraction.new(n / c, d / c)
    end,

    sub = function(a, b) -- subtract
        a = fraction.fix(a)
        b = fraction.fix(b)

        local n = a["n"] * b["d"] - b["n"] * a["d"]
        local d = a["d"] * b["d"]

        local c = math.gcd(n, d)

        return fraction.new(n / c, d / c)
    end,

    neg = function(a) -- make fraction negative just like (negative fraction becomes positive)
        a = fraction.fix(a) -- make sure it's a fraction
        a["n"] = -a["n"]
        
        return a -- return -fraction
    end,

    multiply = function(a, b) -- multiply 2 fractions
        a = fraction.fix(a)
        b = fraction.fix(b)

        local n = a["n"] * b["n"]
        local d = a["d"] * b["d"]

        local c = math.gcd(n, d)
        return fraction.new(n / c, d / c)
    end,

    flip = function(a) -- flip a fraction, get an inverse fraction
        a = fraction.fix(a)

        local temp = a["n"]

        a["n"] = a["d"]
        a["d"] = temp

        return a
    end,

    divide = function(a, b) -- divide a by b
        a = fraction.fix(a)
        b = fraction.flip(b)

        return fraction.multiply(a, b)
    end,

    power = function(a, pwr) -- fraction ^ pwr

        a = fraction.fix(a)
        pwr = fraction.fix(pwr)
        
        if pwr["n"] < 0 then
            a = fraction.flip(a)
            pwr = -pwr
        end
        
        pwr = pwr["n"] / pwr["d"] -- fraction to number

        return fraction.new( a["n"] ^ pwr, a["d"] ^ pwr, true )

    end

}

fractionMeta = {
    __index = fraction,

    __tostring = fraction.tostring,
    __tonumber = fraction.tonumber,

    __unm = fraction.neg,

    __add = fraction.add,
    __sub = fraction.sub,
    __mul = fraction.multiply,
    __div = fraction.divide,
    __pow = fraction.power
}

return fraction