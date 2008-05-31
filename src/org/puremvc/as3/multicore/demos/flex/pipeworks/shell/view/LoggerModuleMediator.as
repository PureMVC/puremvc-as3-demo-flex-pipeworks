/*
 PureMVC AS3 MultiCore Demo – Flex PipeWorks 
 Copyright (c) 2008 Cliff Hall <cliff.hall@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package org.puremvc.as3.multicore.demos.flex.pipeworks.shell.view
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Pipe;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.TeeMerge;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Junction;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;
	import org.puremvc.as3.multicore.demos.flex.pipeworks.common.IPipeAware;
	import org.puremvc.as3.multicore.demos.flex.pipeworks.common.JunctionMediator;
	import org.puremvc.as3.multicore.demos.flex.pipeworks.modules.LoggerModule;
	import org.puremvc.as3.multicore.demos.flex.pipeworks.shell.ApplicationFacade;
	
	/**
	 * Mediator for the LoggerModule.
	 * <P>
	 * Instantiates and manages the LoggerModule for the application.</P>
	 * <P>
	 * Listens for Notifications to connect things to the 
	 * LoggerModule, which implements IPipeAware, an interface that
	 * requires methods for accepting input and output pipes.</P>
	 */
	public class LoggerModuleMediator extends Mediator
	{
		public static const NAME:String = 'LoggerModuleMediator';
		
		public function LoggerModuleMediator( )
		{
			super( NAME, new LoggerModule() );
		}

		/**
		 * LoggerModule related Notification list.
		 */
		override public function listNotificationInterests():Array
		{
			return [ ApplicationFacade.CONNECT_MODULE_TO_LOGGER,
					 ApplicationFacade.CONNECT_SHELL_TO_LOGGER 
			       ];	
		}
		
		/**
		 * Handle LoggerModule related Notifications.
		 * <P>
		 * Connecting modules and the Shell to the LoggerModule.
		 */
		override public function handleNotification( note:INotification ):void
		{
			switch( note.getName() )
			{
				// Connect any Module's STDLOG to the logger's STDIN
				case  ApplicationFacade.CONNECT_MODULE_TO_LOGGER:
					var module:IPipeAware = note.getBody() as IPipeAware;
					var pipe:Pipe = new Pipe();
					module.acceptOutputPipe(JunctionMediator.STDLOG,pipe);
					logger.acceptInputPipe(JunctionMediator.STDIN,pipe);
					break;

				// Bidirectionally connect shell and logger on STDLOG/STDSHELL
				case  ApplicationFacade.CONNECT_SHELL_TO_LOGGER:
					// The junction was passed from ShellJunctionMediator
					var junction:Junction = note.getBody() as Junction;
					
					// Connect the shell's STDLOG to the logger's STDIN
					var shellToLog:IPipeFitting = junction.retrievePipe(JunctionMediator.STDLOG);
					logger.acceptInputPipe(JunctionMediator.STDIN, shellToLog);
					
					// Connect the logger's STDSHELL to the shell's STDIN
					var logToShell:Pipe = new Pipe();
					var shellIn:TeeMerge = junction.retrievePipe(JunctionMediator.STDIN) as TeeMerge;
					shellIn.connectInput(logToShell);
					logger.acceptOutputPipe(JunctionMediator.STDSHELL,logToShell);
					break;
			}
		}
		
		/**
		 * The Logger Module.
		 */
		private function get logger():LoggerModule
		{
			return viewComponent as LoggerModule;
		}
		
	
	}
}