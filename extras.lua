string.split = function(str, sep) -- split a string
    if sep == nil then
        sep = "%S+"
    end
    return string.gmatch(str, "([^"..sep.."]+)")
end

math.gcd = function(a, b)
    local remainder

    while (b ~= 0) do
        remainder = a % b
        a = b
        b = remainder
    end

    return a
end
  
-- local a = "1 / 3"
-- local test = {}
-- for i in string.split(a, "/") do
--     print(i)
--     table.insert(test,tonumber(i))
-- end

-- print(test[1] + test[2])
-- print(type(test[1]), type(test[2]))