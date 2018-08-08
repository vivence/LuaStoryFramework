
local story = {
	NAME = 'Sample',
	VERSION = '1.0',
}

function story.proc(data)
	apiPrint('begin')

	apiWaitOneFrame()

	apiWaitKill(1)

	apiPrint('end')
end

return story