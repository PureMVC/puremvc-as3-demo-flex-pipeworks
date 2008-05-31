package org.puremvc.as3.multicore.demos.flex.pipeworks.common
{
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;
	
	public interface IPipeAware
	{
		function acceptInputPipe(name:String, pipe:IPipeFitting):void;
		function acceptOutputPipe(name:String, pipe:IPipeFitting):void;
	}
}