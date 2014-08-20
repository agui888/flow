local flow = require 'flow'
local actual = {}

local thread1 = coroutine.create(function(down)
    table.insert(actual, 'thread1-down')
    coroutine.yield(down)
    table.insert(actual, 'thread1-up')
end)

local thread2 = coroutine.create(function(down)
    table.insert(actual, 'thread2-down')
    coroutine.yield(down)
    table.insert(actual, 'thread2-up')
end)

local arr = {
    thread1,
    function(down)
        table.insert(actual, 1)
        assert(false, 'customerror')
        down()
    end,
    thread2,
    function(down)
        table.insert(actual, 2)
        down()
    end,
}

local expect = {'thread1-down', 1}

local ok, msg = flow(arr)()

assert(ok == false)
assert(type(msg) == 'string')
assert(msg:find('customerror'))
assert(#expect == #actual)

for i = 1, #expect do
    assert(actual[i] == expect[i])
end

print('error catch test ok!')
