
local story = {
	NAME = 'Sample',
	VERSION = '1.0',
}

function story.proc(data)
	apiPrint('sample begin')

	apiWaitOneFrame()

	data.kill_1 = 0
	data.kill_2 = 0
	data.kill_3 = 0

	apiParallel('sub_proc_1', function(data)
		apiWaitKill(1)
		data.kill_1 = data.kill_1+1
	end)

	apiParallel('sub_proc_2', function(data)
		apiWaitKill(2)
		data.kill_2 = data.kill_2+1
	end)
	
	apiParallel('sub_proc_3', function(data)
		apiWaitKill(3)
		data.kill_3 = data.kill_3+1
	end)
	
	apiWaitCondition(function()
		return 0 < data.kill_1 or 0 < data.kill_2 or 0 < data.kill_3
	end)

	apiParallelBreak('sub_proc_1')
	apiParallelBreak('sub_proc_2')
	apiParallelBreak('sub_proc_3')

	apiPrint('sample end')
end

return story