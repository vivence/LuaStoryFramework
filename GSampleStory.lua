
local story = {
	NAME = 'sample',
	VERSION = '1.0',
}

-- context设置不同模式（运行、恢复、关闭），用于区分不同执行行为
-- 运行模式下就是正常的api和data操作（只有api被调用时，才会保存上一次api调用到这次调用之间的data变化）
-- 恢复模式下data设置将不生效，根据api调用顺序（block编号和block内api调用编号）
--    来一级级恢复data状态（依靠运行模式下每次api调用时记录的api编号、参数、返回值、data快照等）
--    以此保证恢复模式下，能够按照上次运行的轨迹走到上次停止运行的api
-- 关闭模式下所有api和data设置操作将失效，主要作用是让协程能够执行完毕（暂时没有找到能够直接中断退出协程的方法）
story.proc = function (context)
	apiPrint('step1')

	apiWaitOneFrame()

	apiPrint("step2")
	context:init('test_count', 0)

	apiParallel('sub_proc_1', function()
		apiWaitTest(1)
		context.test_count = context.test_count+1
		apiPrint('rest: '..(n-context.test_count))
	end)

	apiPrint("step3")

	apiParallel('sub_proc_2', function()
		apiWaitTest(2)
		context.test_count = context.test_count+1
		apiPrint('rest: '..(n-context.test_count))
	end)

	apiPrint("step4")

	apiParallel('sub_proc_3', function()
		apiWaitTest(3)
		context.test_count = context.test_count+1
		apiPrint('rest: '..(n-context.test_count))
	end)

	apiPrint("step5")

	apiWaitCondition(function ()
		return 2 <= context.test_count
	end)

	-- local n = 5
	-- context:init('test_count', 0)
	-- while (n > context.test_count) do
	-- 	apiWaitTest()
	-- 	context.test_count = context.test_count+1
	-- 	apiPrint('rest: '..(n-context.test_count))
	-- end

	apiPrint("end")

end

return story