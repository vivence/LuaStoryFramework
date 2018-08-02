
local _apiCall = Ghost.apiCall

function apiPrint( ... )
	return _apiCall('PRINT', ...)
end

function apiParallel( name, proc )
	return _apiCall('PARALLEL', name, proc)
end

function apiWaitOneFrame()
	return _apiCall('ONE_FRAME')
end

function apiWaitCondition( condition )
	return _apiCall('CONDITION', condition)
end

function apiWaitTest(num)
	return _apiCall('TEST', num)
end