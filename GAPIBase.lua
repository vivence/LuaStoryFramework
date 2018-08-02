
------ private function ----->

------ private function -----<

GAPI = Ghost.class("GAPI")

function GAPI:ctor( )
end
------ virtual function ----->
function GAPI:call( context, ... )
	gassert(false, 'no api-call implementation')
end
------ virtual function -----<