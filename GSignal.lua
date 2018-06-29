-- print('require GSignal')

------ private function ----->

------ private function -----<

-------------- public interface -------------->

GSignal = Ghost.class("GSignal")

local observer_map_swap = {}

function GSignal:ctor( name )
	self.name = name or 'no_name'
	self.observer_map = {}
end

function GSignal:register( observer, signal_proc, ... )
	self.observer_map[observer] = signal_proc
end

function GSignal:signal( ... )
	gprint(string.format('signal: %s', self.name))

	local map = self.observer_map
	self.observer_map = observer_map_swap
	observer_map_swap = nil

	for observer,signal_proc in pairs(map) do
		map[observer] = nil
		signal_proc(observer, ...)
	end

	observer_map_swap = map
end

GSingalMap = {
	ONE_FRAME = GSignal.new('one_frame'),
	TEST = GSignal.new('test'),
}

-------------- public interface --------------<