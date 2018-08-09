
local story = {
	NAME = 'Sample',
	VERSION = '1.0',
}

function story.proc(data)
	apiPrint('begin')

	apiWaitOneFrame()

	data.kill_1 = 0
	apiWaitKill(1)
	data.kill_1 = data.kill_1+1

	apiPrint('end')
end

return story