/*
 PureMVC AS3 MultiCore Demo – Flex PipeWorks 
 Copyright (c) 2008 Cliff Hall <cliff.hall@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package org.puremvc.as3.multicore.demos.flex.pipeworks.modules
{
	import org.puremvc.as3.multicore.demos.flex.pipeworks.common.PipeAwareModule;
	import org.puremvc.as3.multicore.demos.flex.pipeworks.modules.logger.ApplicationFacade;

	public class LoggerModule extends PipeAwareModule
	{
		public static const NAME:String 			= 'LoggerModule';
		public static const LOG_BUTTON_UI:String 	= 'LogButtonUI';
		public static const LOG_WINDOW_UI:String 	= 'LogWindowUI';
		
		public function LoggerModule()
		{
			super(ApplicationFacade.getInstance( NAME ));
			ApplicationFacade(facade).startup( this );
		}
1
	}
}