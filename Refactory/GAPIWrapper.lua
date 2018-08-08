

------ private function ----->
local _registerAPI = Ghost.registerAPI

local function _apiPrint( story, str )
	story:debugLog(str)
end
------ private function -----<

------ static function ----->
function Ghost.registerAPIAll()
	_registerAPI('print', GAPIPost.new(_apiPrint))
	_registerAPI('waitOneFrame', GAPIWait.new())
	_registerAPI('waitKill', GAPIWaitValue.new())
	-- TODO
end
------ static function -----<

function apiPrint(str)
	return Ghost.callAPI('print', str)
end

function apiWaitOneFrame()
	return Ghost.callAPI('waitOneFrame')
end

function apiWaitKill(id)
	return Ghost.callAPI('waitKill', id)
end