
local story = {
	NAME = 'Sample',
	VERSION = '1.0',
}

function story.proc(data)

	apiPrint('莫慌，我们来分析一下')
	apiWaitSecond(1)

	repeat
		apiPrint('想知道什么？')
		apiWaitSecond(1)
		apiPrint('1.离开')
		apiPrint('2.你是谁？')
		apiPrint('3.认识我？')
		apiPrint('4.危险吗？')

		apiWaitInput({1,2,3,4})
		local opt = data._last_return

		if 1 == opt then
			apiWaitSecond(1)
			apiPrint('再见')	
			break
		elseif 4 == opt then	
			apiWaitSecond(1)
			apiPrint('不危险')
			apiWaitSecond(1)

			repeat
				apiPrint('跟我回家吧？')
				apiWaitSecond(1)
				apiPrint('1.家？')
				apiPrint('2.留下？')
				apiPrint('3.走吧？')

				apiWaitInput({1,2,3})
				local opt = data._last_return
				if 2 == opt then
					apiWaitSecond(1)

					repeat
						apiPrint('等妮薇尔来')
						apiWaitSecond(1)
						apiPrint('1.妮薇尔？')
						apiPrint('2.参观一下？')

						apiWaitInput({1,2})
						local opt = data._last_return
						if 1 == opt then
							apiWaitSecond(1)
							apiPrint('是我朋友')
							break
						elseif 2 == opt then
							apiWaitSecond(1)
							apiPrint('别走远了')
							break
						end
					until true
					break
				elseif 3 == opt then
					apiWaitSecond(1)
					apiPrint('工房有吃的')
					break
				end
			until true

			break
		end
	until true

	apiPrint('结束')

	-- apiPrint('sample begin')

	-- apiWaitOneFrame()

	-- data.kill_1 = 0
	-- data.kill_2 = 0
	-- data.kill_3 = 0

	-- apiParallel('sub_proc_1', function(data)
	-- 	apiWaitKill(1)
	-- 	data.kill_1 = data.kill_1+1
	-- end)

	-- apiParallel('sub_proc_2', function(data)
	-- 	apiWaitKill(2)
	-- 	data.kill_2 = data.kill_2+1
	-- end)
	
	-- apiParallel('sub_proc_3', function(data)
	-- 	apiWaitKill(3)
	-- 	data.kill_3 = data.kill_3+1
	-- end)
	
	-- apiWaitCondition(function()
	-- 	return 0 < data.kill_1 
	-- 		or 0 < data.kill_2 
	-- 		or 0 < data.kill_3
	-- end)

	-- apiParallelBreak('sub_proc_1')
	-- apiParallelBreak('sub_proc_2')
	-- apiParallelBreak('sub_proc_3')

	-- apiPrint('sample end')
end

return story