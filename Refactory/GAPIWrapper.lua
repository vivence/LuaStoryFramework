

------ private function ----->
local _registerAPI = Ghost.registerAPI

local function _apiPrint( story, str )
	-- story:debugLog(str)
	gprint(str)
end

local function _apiParallel( story, name, proc )
	return story:createSubThread(name, proc)
end

local function _apiBreakParallel( story, name )
	return story:destroySubThread(name)
end
------ private function -----<

------ static function ----->
function Ghost.registerAPIAll()
	_registerAPI('print', GAPIPost.new(_apiPrint))
	_registerAPI('waitOneFrame', GAPIWait.new())
	_registerAPI('waitKill', GAPIWaitValue.new())
	_registerAPI('waitCondition', GAPIWaitCondition.new())
	_registerAPI('waitInput', GAPIWaitInput.new())
	_registerAPI('parallel', GAPIPost.new(_apiParallel))
	_registerAPI('parallelBreak', GAPIPost.new(_apiBreakParallel))
	-- TODO
end
------ static function -----<

function apiPrint(str)
	return Ghost.callAPI('print', str)
end

function apiWaitOneFrame()
	return Ghost.callAPI('waitOneFrame')
end

function apiWaitSecond(s)
	local frames = s*5 -- 0.2s per frame
	for i=1, frames do
		apiWaitOneFrame()
	end
end

function apiWaitKill(id)
	return Ghost.callAPI('waitKill', id)
end

function apiWaitCondition(condition)
	return Ghost.callAPI('waitCondition', condition)
end

function apiWaitInput(options)
	return Ghost.callAPI('waitInput', options)
end

function apiParallel(name, proc)
	return Ghost.callAPI('parallel', name, proc)
end

function apiParallelBreak(name)
	return Ghost.callAPI('parallelBreak', name)
end








