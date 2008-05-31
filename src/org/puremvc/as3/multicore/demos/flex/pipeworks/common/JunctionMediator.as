/*
 PureMVC AS3 MultiCore Demo – Flex PipeWorks 
 Copyright (c) 2008 Cliff Hall <cliff.hall@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package org.puremvc.as3.multicore.demos.flex.pipeworks.common
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
	import org.puremvc.as3.multicore.utilities.pipes.messages.FilterControlMessage;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Junction;
	
	/**
	 * Junction Mediator.
	 * <P>
	 * A base class for handling the Pipe Junction in a Module.</P>
	 */
	public class JunctionMediator extends Mediator
	{
		/**
		 * Accept input pipe notification name constant.
		 */ 
        public static const ACCEPT_INPUT_PIPE:String 	= 'acceptInputPipe';
		
		/**
		 * Accept output pipe notification name constant.
		 */ 
        public static const ACCEPT_OUTPUT_PIPE:String 	= 'acceptOutputPipe';

		/**
		 * Standard output pipe name constant.
		 */
		public static const STDOUT:String 				= 'standardOutput';
		
		/**
		 * Standard input pipe name constant.
		 */
		public static const STDIN:String 				= 'standardInput';
		
		/**
		 * Standard log pipe name constant.
		 */
		public static const STDLOG:String 				= 'standardLog';
		
		/**
		 * Standard shell pipe name constant.
		 */
		public static const STDSHELL:String 			= 'standardShell';

		/**
		 * Constructor.
		 */
		public function JunctionMediator( name:String, viewComponent:Junction )
		{
			super( name, viewComponent );
		}

		/**
		 * List Notification Interests.
		 * <P>
		 * Returns the notification interests for this base class.
		 * Override in subclass and call <code>super.listNotificationInterests</code>
		 * to get this list, then add any sublcass interests to 
		 * the array before returning.</P>
		 */
		override public function listNotificationInterests():Array
		{
			return [ JunctionMediator.ACCEPT_INPUT_PIPE, 
			         JunctionMediator.ACCEPT_OUTPUT_PIPE,
			         LogMessage.SEND_TO_LOG,
			         LogFilterMessage.SET_LOG_LEVEL
			       ];	
		}
		
		/**
		 * Handle Notification.
		 * <P>
		 * This provides the handling for common junction activities.</P>
		 * <P>
		 * Accepts input and output pipes, and handles sending LogMessages</P>
		 * <P>
		 * Override in subclass, and call <code>super.handleNotification</code>
		 * if none of the subclass-specific notification names are matched.</P>
		 */
		override public function handleNotification( note:INotification ):void
		{
			switch( note.getName() )
			{
				// accept an input pipe
				// register the pipe and if successful 
				// set this mediator as its listener
				case JunctionMediator.ACCEPT_INPUT_PIPE:
					var inputPipeName:String = note.getType();
					var inputPipe:IPipeFitting = note.getBody() as IPipeFitting;
					if ( junction.registerPipe(inputPipeName, Junction.INPUT, inputPipe) ) 
					{
						junction.addPipeListener( inputPipeName, this, handlePipeMessage );		
					} 
					break;
				
				// accept an output pipe
				case JunctionMediator.ACCEPT_OUTPUT_PIPE:
					var outputPipeName:String = note.getType();
					var outputPipe:IPipeFitting = note.getBody() as IPipeFitting;
					junction.registerPipe( outputPipeName, Junction.OUTPUT, outputPipe );
					break;
					
				// Send messages to the Log
				case LogMessage.SEND_TO_LOG:
					var level:int;
					switch (note.getType())
					{
						case LogMessage.LEVELS[LogMessage.DEBUG]:
							level = LogMessage.DEBUG;
							break;

						case LogMessage.LEVELS[LogMessage.ERROR]:
							level = LogMessage.ERROR;
							break;
						
						case LogMessage.LEVELS[LogMessage.FATAL]:
							level = LogMessage.FATAL;
							break;
						
						case LogMessage.LEVELS[LogMessage.INFO]:
							level = LogMessage.INFO;
							break;
						
						case LogMessage.LEVELS[LogMessage.WARN]:
							level = LogMessage.WARN;
							break;
						
						default:
							level = LogMessage.INFO;
							break;
						
					}
					var logMessage:LogMessage = new LogMessage( level, this.multitonKey, note.getBody() as String);
					junction.sendMessage( STDLOG, logMessage );
					break;

				// Modify the Log Level filter 
				case LogFilterMessage.SET_LOG_LEVEL:
					var logLevel:number = note.getBody() as Number;
					var setLogLevelMessage:LogFilterMessage = new LogFilterMessage(FilterControlMessage.SET_PARAMS, logLevel);
					var changedLevel:Boolean = junction.sendMessage( STDLOG, setLogLevelMessage );
					var changedLevelMessage:LogMessage = new LogMessage( LogMessage.CHANGE, this.multitonKey, "Changed Log Level to: "+LogMessage.LEVELS[logLevel])
					var logChanged:Boolean = junction.sendMessage( STDLOG, changedLevelMessage );
					break;


			}
		}
		
		/**
		 * Handle incoming pipe messages.
		 * <P>
		 * Override in subclass and handle messages appropriately for the module.</P>
		 */
		public function handlePipeMessage( message:IPipeMessage ):void
		{
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