
-------------- private interface -------------->
local function _arrayPushBack(array, v)
	array[#array+1] = v
end

local function _createProxy(data, _data)
	local proxy = {}

	local mt = {}
	mt.__index = _data
	mt.__newindex = function ( t,k,v )
		data:_set(k, v)
	end
	mt.__pairs = function(t)
		return pairs(_data)
	end
	setmetatable(proxy, mt)

	return proxy
end
-------------- private interface --------------<

GData = Ghost.class("GData")

GData.Action = {
	SET_DATA = 'setData',
	THREAD_AWAKE = 'threadAwake',
	THREAD_SLEEP = 'threadSleep',
	API_CALL = 'apiCall',
	API_RETURN = 'apiReturn',
}

function GData:ctor()
	self._history = {}
	self._data = {}

	self.proxy = _createProxy(self, self._data)
end

function GData:setStory(story)
	self.story = story
end

function GData:getProxy()
	return self.proxy
end

function GData:record(action, ...)
	_arrayPushBack(self._history, {action, ...})
end

function GData:historyPrint()
	local history = self._history
	gprint('----history---->')
	local data = {}
	for i=1, #history do
		local node = history[i]
		if 1 < #node then
			gprint(string.format('[%d] %s(%s)', 
				i, 
				node[1], 
				table.concat(node, ",", 2)))
		else
			gprint(string.format('[%d] %s()', 
				i, 
				node[1]))
		end
	end
	gprint('----history----<')
end

-------------- private interface -------------->
function GData:_set(k, v)
	local story = self.story

	if story:isModeNormal() then
		local t = type(v)
		if 'nil' == t 
			or 'boolean' == t 
			or 'number' == t 
			or 'string' == t then
			v = v or '_nil'
			rawset(self._data, k, v)
			self:record(GData.Action.SET_DATA, k, v)
		else-- 'userdata','thread','table','function'
			gassert(false, 'set data invalid type')
		end
	elseif story:isModeRestore() then
		-- TODO
	elseif story:isModeClose() then
		-- TODO
	end
end
-------------- private interface --------------<













