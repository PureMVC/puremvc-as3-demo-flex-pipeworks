/*
 PureMVC AS3 MultiCore Demo – Flex PipeWorks 
 Copyright (c) 2008 Cliff Hall <cliff.hall@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package org.puremvc.as3.multicore.demos.flex.pipeworks.common
{
	import mx.modules.ModuleBase;
	
	import org.puremvc.as3.multicore.interfaces.IFacade;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;

	public class PipeAwareModule extends ModuleBase implements IPipeAware
	{
		
		public function PipeAwareModule( facade:IFacade )
		{
			super();
			this.facade = facade;
		}

		/**
		 * Accept an input pipe.
		 * <P>
		 * Registers an input pipe with this module's Junction.
		 */
		public function acceptInputPipe( name:String, pipe:IPipeFitting ):void
		{
			facade.sendNotification( JunctionMediator.ACCEPT_INPUT_PIPE, pipe, name );							
		}
		
		/**
		 * Accept an output pipe.
		 * <P>
		 * Registers an input pipe with this module's Junction.
		 */
		public function acceptOutputPipe( name:String, pipe:IPipeFitting ):void
		{
			facade.sendNotification( JunctionMediator.ACCEPT_OUTPUT_PIPE, pipe, name );							
		}

		protected var facade:IFacade;
	}
}