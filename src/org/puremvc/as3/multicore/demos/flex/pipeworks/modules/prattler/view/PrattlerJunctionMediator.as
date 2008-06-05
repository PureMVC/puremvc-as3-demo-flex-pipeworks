/*
 PureMVC AS3 MultiCore Demo – Flex PipeWorks - Prattler Module
 Copyright (c) 2008 Cliff Hall <cliff.hall@puremvc.org>

 Parts originally from: 
 PureMVC AS3 Demo – AIR RSS Headlines 
 Copyright (c) 2007-08 Simon Bailey <simon.bailey@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package org.puremvc.as3.multicore.demos.flex.pipeworks.modules.prattler.view
{
	import mx.core.UIComponent;
	
	import org.puremvc.as3.multicore.demos.flex.pipeworks.common.LoggingJunctionMediator;
	import org.puremvc.as3.multicore.demos.flex.pipeworks.common.PipeAwareModule;
	import org.puremvc.as3.multicore.demos.flex.pipeworks.common.UIQueryMessage;
	import org.puremvc.as3.multicore.demos.flex.pipeworks.modules.PrattlerModule;
	import org.puremvc.as3.multicore.demos.flex.pipeworks.modules.prattler.ApplicationFacade;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Junction;
	
	public class PrattlerJunctionMediator extends LoggingJunctionMediator
	{
		public static const NAME:String = 'PrattlerJunctionMediator';

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
		public function PrattlerJunctionMediator( )
		{
			super( NAME, new Junction() );
			
		}

		/**
		 * List Notification Interests.
		 * <P>
		 * Adds subclass interests to those of the JunctionMediator.</P>
		 */
		override public function listNotificationInterests():Array
		{
			var interests:Array = super.listNotificationInterests();
			interests.push(ApplicationFacade.EXPORT_FEED_WINDOW);
			return interests;
		}

		/**
		 * Handle Junction related Notifications for the PrattlerModule.
		 * <P>
		 * For the Prattler, this consists of exporting the
		 * FeedWindow in a PipeMessage to STDSHELL, as well as the
		 * ordinary JunctionMediator duties of accepting input
		 * and output pipes from the Shell.</P>
		 * <P>
		 * Also send messages to the logger.</P>
		 */		
		override public function handleNotification( note:INotification ):void
		{
			
			switch( note.getName() )
			{
				// Send the LogWindow UI Component 
				case ApplicationFacade.EXPORT_FEED_WINDOW:
					var prattlerWindowMessage:UIQueryMessage = new UIQueryMessage( UIQueryMessage.SET, PrattlerModule.FEED_WINDOW_UI, UIComponent(note.getBody()) );
					junction.sendMessage( PipeAwareModule.STDSHELL, prattlerWindowMessage );
					break;
				
				// And let super handle the rest (ACCEPT_OUTPUT_PIPE, ACCEPT_INPUT_PIPE, SEND_TO_LOG)								
				default:
					super.handleNotification(note);
					
			}
		}
		
		
		/**
		 * Handle incoming pipe messages.
		 */
		override public function handlePipeMessage( message:IPipeMessage ):void
		{
			if ( message is UIQueryMessage )
			{
				//switch ( UIQueryMessage(message).name )
				//{
				//	default:
				//		break;
				//}
			}
		}
	}
}