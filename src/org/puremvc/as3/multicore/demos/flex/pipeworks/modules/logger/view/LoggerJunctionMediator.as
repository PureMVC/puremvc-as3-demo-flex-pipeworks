/*
 PureMVC AS3 MultiCore Demo – Flex PipeWorks 
 Copyright (c) 2008 Cliff Hall <cliff.hall@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package org.puremvc.as3.multicore.demos.flex.pipeworks.modules.logger.view
{
	import mx.core.UIComponent;
	
	import org.puremvc.as3.multicore.demos.flex.pipeworks.common.JunctionMediator;
	import org.puremvc.as3.multicore.demos.flex.pipeworks.common.LogFilterMessage;
	import org.puremvc.as3.multicore.demos.flex.pipeworks.common.LogMessage;
	import org.puremvc.as3.multicore.demos.flex.pipeworks.common.UIQueryMessage;
	import org.puremvc.as3.multicore.demos.flex.pipeworks.modules.LoggerModule;
	import org.puremvc.as3.multicore.demos.flex.pipeworks.modules.logger.ApplicationFacade;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Filter;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Junction;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.PipeListener;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.TeeMerge;
	
	public class LoggerJunctionMediator extends JunctionMediator
	{
		public static const NAME:String = 'LoggerJunctionMediator';

		/**
		 * Constructor.
		 * <P>
		 * Creates and registers its own STDIN pipe
		 * and adds this instance as a listener, 
		 * because the logger uses a TeeMerge and 
		 * new inputs are added to it rather than
		 * as separate pipes registered with the
		 * Junction.</P>
		 */ 		
		public function LoggerJunctionMediator( )
		{
			super( NAME, new Junction() );
			
		}

		/**
		 * Called when Mediator is registered.
		 * <P>
		 * Registers a short pipeline consisting of
		 * a Merging Tee connected to a Filter for STDIN, 
		 * setting the LoggerJunctionMediator as the 
		 * Pipe Listener.</P>
		 * <P>
		 * The filter is used to filter messages by log
		 * level. LogMessages falling below the current
		 * LogLevel are rejected by the filter.</P>
		 */
		override public function onRegister():void
		{
//			var teeMerge:TeeMerge = new TeeMerge();
//			var filter:Filter = new Filter(LogFilterMessage.LOG_FILTER);
//			filter.connect(new PipeListener(this,handlePipeMessage));
//			teeMerge.connect(filter);
//			junction.registerPipe( STDIN, Junction.INPUT, teeMerge );
			var teeMerge:TeeMerge = new TeeMerge();
			var filter:Filter = new Filter( LogFilterMessage.LOG_FILTER_NAME,
										    null,
										    LogFilterMessage.filterLogByLevel as Function
										    );
			filter.connect(new PipeListener(this,handlePipeMessage));
			teeMerge.connect(filter);
			junction.registerPipe( STDIN, Junction.INPUT, teeMerge );
		}
		
		/**
		 * List Notification Interests.
		 * <P>
		 * Adds subclass interests to those of the JunctionMediator.</P>
		 */
		override public function listNotificationInterests():Array
		{
			var interests:Array = super.listNotificationInterests();
			interests.push(ApplicationFacade.EXPORT_LOG_BUTTON);
			interests.push(ApplicationFacade.EXPORT_LOG_WINDOW);
			return interests;
		}

		/**
		 * Handle Junction related Notifications for the LoggerModule.
		 * <P>
		 * For the Logger, this consists of exporting the
		 * LogButton and LogWindow in a PipeMessage to STDSHELL, 
		 * as well as the ordinary JunctionMediator duties of 
		 * accepting input and output pipes from the Shell.</P>
		 * <P>
		 * It handles accepting input pipes instead of letting
		 * the superclass do it because the STDIN to the logger
		 * is Merging Tee and not a pipe, so the details of 
		 * connecting it differ.</P>
		 */		
		override public function handleNotification( note:INotification ):void
		{
			
			switch( note.getName() )
			{
				// Send the LogButton UI Component 
				case ApplicationFacade.EXPORT_LOG_BUTTON:
					var logButtonMessage:UIQueryMessage = new UIQueryMessage( UIQueryMessage.SET, LoggerModule.LOG_BUTTON_UI, UIComponent(note.getBody()) );
					var buttonExported:Boolean = junction.sendMessage( STDSHELL, logButtonMessage );
					break;
				
				// Send the LogWindow UI Component 
				case ApplicationFacade.EXPORT_LOG_WINDOW:
					var logWindowMessage:UIQueryMessage = new UIQueryMessage( UIQueryMessage.SET, LoggerModule.LOG_WINDOW_UI, UIComponent(note.getBody()) );
					junction.sendMessage( STDSHELL, logWindowMessage );
					break;
				
				// Add an input pipe (special handling for LoggerModule) 
				case JunctionMediator.ACCEPT_INPUT_PIPE:
					var name:String = note.getType();
					
					// STDIN is a Merging Tee. Overriding super to handle this.
					if (name == STDIN) {
						var pipe:IPipeFitting = note.getBody() as IPipeFitting;
						var tee:TeeMerge = junction.retrievePipe(STDIN) as TeeMerge;
						tee.connectInput(pipe);
					} 
					// Use super for any other input pipe
					else {
						super.handleNotification(note); 
					} 
					break;

				// And let super handle the rest (ACCEPT_OUTPUT_PIPE)								
				default:
					super.handleNotification(note);
					
			}
		}
		
		/**
		 * Handle incoming pipe messages.
		 */
		override public function handlePipeMessage( message:IPipeMessage ):void
		{
			if ( message is LogMessage ) 
			{
				sendNotification( ApplicationFacade.LOG_MSG, message );
			} 
			else if ( message is UIQueryMessage )
			{
				switch ( UIQueryMessage(message).name )
				{
					case LoggerModule.LOG_BUTTON_UI:
						sendNotification(ApplicationFacade.CREATE_LOG_BUTTON)
						break;

					case LoggerModule.LOG_WINDOW_UI:
						sendNotification(ApplicationFacade.CREATE_LOG_WINDOW )
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