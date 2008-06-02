/*
 PureMVC AS3 MultiCore Demo – Flex PipeWorks 
 Copyright (c) 2008 Cliff Hall <cliff.hall@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package org.puremvc.as3.multicore.demos.flex.pipeworks.shell.view
{
	import org.puremvc.as3.multicore.demos.flex.pipeworks.common.IPipeAware;
	import org.puremvc.as3.multicore.demos.flex.pipeworks.common.JunctionMediator;
	import org.puremvc.as3.multicore.demos.flex.pipeworks.common.LogMessage;
	import org.puremvc.as3.multicore.demos.flex.pipeworks.common.UIQueryMessage;
	import org.puremvc.as3.multicore.demos.flex.pipeworks.modules.LoggerModule;
	import org.puremvc.as3.multicore.demos.flex.pipeworks.modules.PrattlerModule;
	import org.puremvc.as3.multicore.demos.flex.pipeworks.shell.ApplicationFacade;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Junction;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Pipe;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.TeeMerge;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.TeeSplit;
	
	public class ShellJunctionMediator extends JunctionMediator
	{
		public static const NAME:String = 'ShellJunctionMediator';
		
		public function ShellJunctionMediator( )
		{
			super( NAME, new Junction() );
		}

		/**
		 * Called when the Mediator is registered.
		 * <P>
		 * Registers a Merging Tee for STDIN, 
		 * and sets this as the Pipe Listener.</P>
		 * <P>
		 * Registers a Pipe for STDLOG and 
		 * connects it to LoggerModule.</P>
		 */
		override public function onRegister():void
		{
			// The STDOUT pipe from the shell to all modules 
			junction.registerPipe( STDOUT,  Junction.OUTPUT, new TeeSplit() );
			
			// The STDIN pipe to the shell from all modules 
			junction.registerPipe( STDIN,  Junction.INPUT, new TeeMerge() );
			junction.addPipeListener( STDIN, this, handlePipeMessage );
			
			// The STDLOG pipe from the shell to the logger
			junction.registerPipe( STDLOG, Junction.OUTPUT, new Pipe() );
			sendNotification(ApplicationFacade.CONNECT_SHELL_TO_LOGGER, junction );

		}
		
		/**
		 * ShellJunction related Notification list.
		 * <P>
		 * Adds subclass interests to JunctionMediator interests.</P>
		 */
		override public function listNotificationInterests():Array
		{
			var interests:Array = super.listNotificationInterests();
			interests.push( ApplicationFacade.REQUEST_LOG_WINDOW );
			interests.push( ApplicationFacade.REQUEST_LOG_BUTTON );
			interests.push( ApplicationFacade.CONNECT_MODULE_TO_SHELL );
			return interests;
		}

		/**
		 * Handle ShellJunction related Notifications.
		 */
		override public function handleNotification( note:INotification ):void
		{
			
			switch( note.getName() )
			{
							
				case ApplicationFacade.REQUEST_LOG_BUTTON:
					sendNotification(LogMessage.SEND_TO_LOG,"Requesting log button from LoggerModule.",LogMessage.LEVELS[LogMessage.DEBUG]);
					junction.sendMessage(STDLOG,new UIQueryMessage(UIQueryMessage.GET,LoggerModule.LOG_BUTTON_UI));
					break;

				case ApplicationFacade.REQUEST_LOG_WINDOW:
					sendNotification(LogMessage.SEND_TO_LOG,"Requesting log window from LoggerModule.",LogMessage.LEVELS[LogMessage.DEBUG]);
					junction.sendMessage(STDLOG,new UIQueryMessage(UIQueryMessage.GET,LoggerModule.LOG_WINDOW_UI));
					break;

				case  ApplicationFacade.CONNECT_MODULE_TO_SHELL:
					sendNotification(LogMessage.SEND_TO_LOG,"Connecting new module instance to Shell.",LogMessage.LEVELS[LogMessage.DEBUG]);

					// Connect a module's STDSHELL to the shell's STDIN
					var module:IPipeAware = note.getBody() as IPipeAware;
					var moduleToShell:Pipe = new Pipe();
					module.acceptOutputPipe(JunctionMediator.STDSHELL, moduleToShell);
					var shellIn:TeeMerge = junction.retrievePipe(JunctionMediator.STDIN) as TeeMerge;
					shellIn.connectInput(moduleToShell);
					
					// Connect the shell's STDOUT to the module's STDIN
					var shellToModule:Pipe = new Pipe();
					module.acceptInputPipe(JunctionMediator.STDIN, shellToModule);
					var shellOut:IPipeFitting = junction.retrievePipe(JunctionMediator.STDOUT) as IPipeFitting;
					shellOut.connect(shellToModule);
					break;

				// Let super handle the rest (ACCEPT_OUTPUT_PIPE, ACCEPT_INPUT_PIPE, SEND_TO_LOG)								
				default:
					super.handleNotification(note);
					
			}
		}
		
		/**
		 * Handle incoming pipe messages for the ShellJunction.
		 * <P>
		 * The LoggerModule sends its LogButton and LogWindow instances
		 * to the Shell for display management via an output Pipe it 
		 * knows as STDSHELL. The PrattlerModule instances also send
		 * their manufactured FeedWindow instances to the shell via
		 * their STDSHELL pipe. Those messages all show up and are
		 * handled here.</P>
		 * <P>
		 * Note that we are handling PipeMessages with the same idiom
		 * as Notifications. Conceptually they are the same, and the
		 * Mediator role doesn't change much. It takes these messages
		 * and turns them into notifications to be handled by other 
		 * actors in the main app / shell.</P> 
		 * <P>
		 * Also, it is logging its actions by sending INFO messages
		 * to the STDLOG output pipe.</P> 
		 */
		override public function handlePipeMessage( message:IPipeMessage ):void
		{
			if ( message is UIQueryMessage )
			{
				switch ( UIQueryMessage(message).name )
				{
					case LoggerModule.LOG_BUTTON_UI:
						sendNotification(ApplicationFacade.SHOW_LOG_BUTTON, UIQueryMessage(message).component, UIQueryMessage(message).name )
						junction.sendMessage(STDLOG,new LogMessage(LogMessage.INFO,this.multitonKey,'Recieved the Log Button on STDSHELL'));
						break;

					case LoggerModule.LOG_WINDOW_UI:
						sendNotification(ApplicationFacade.SHOW_LOG_WINDOW, UIQueryMessage(message).component, UIQueryMessage(message).name )
						junction.sendMessage(STDLOG,new LogMessage(LogMessage.INFO,this.multitonKey,'Recieved the Log Window on STDSHELL'));
						break;

					case PrattlerModule.FEED_WINDOW_UI:
						sendNotification(ApplicationFacade.SHOW_FEED_WINDOW, UIQueryMessage(message).component, UIQueryMessage(message).name )
						junction.sendMessage(STDLOG,new LogMessage(LogMessage.INFO,this.multitonKey,'Recieved the Feed Window on STDSHELL'));
						break;
				}
			}
		}
		
		/**
		 * The Junction for this Module.
		 */
		private function get junction():Junction
		{
			return viewComponent as Junction;
		}
		
	
	}
}