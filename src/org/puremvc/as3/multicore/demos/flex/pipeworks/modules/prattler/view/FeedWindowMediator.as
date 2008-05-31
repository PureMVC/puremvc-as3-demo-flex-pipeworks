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
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.demos.flex.pipeworks.common.LogMessage;
	import org.puremvc.as3.multicore.demos.flex.pipeworks.modules.prattler.ApplicationFacade;
	import org.puremvc.as3.multicore.demos.flex.pipeworks.modules.prattler.model.FeedProxy;
	import org.puremvc.as3.multicore.demos.flex.pipeworks.modules.prattler.model.vo.FeedVO;
	import org.puremvc.as3.multicore.demos.flex.pipeworks.modules.prattler.view.components.FeedControls;
	import org.puremvc.as3.multicore.demos.flex.pipeworks.modules.prattler.view.components.FeedWindow;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class FeedWindowMediator extends Mediator
	{
		public static const NAME:String = "FeedWindowMediator";
		
		public function FeedWindowMediator( viewComponent:FeedWindow )
		{
			super( NAME, viewComponent );
		}
		
		/**
		 * Register event listeners with the FeedWindow and its controls.
		 */
		override public function onRegister():void
		{
			feedWindow.addEventListener( FeedControls.INTERVAL, onInterval );
			feedWindow.addEventListener( FeedControls.SUBMIT, onSubmit );
			feedWindow.addEventListener( Event.CLOSE, onWindowClose );
			feedWindow.moduleName = this.multitonKey;
		}
		
		/**
		 * The viewComponent cast to type FeedWindow.
		 */
		private function get feedWindow():FeedWindow
		{
			return viewComponent as FeedWindow;
		}
		
		/**
		 * A reference to the view componen'ts feed controls.
		 */
		private function get feedControls():FeedControls
		{
			return feedWindow.feedControls as FeedControls;
		}
		
		/**
		 * Submit the user's adjust the reader rate interval value.
		 */
		private function onInterval( e:Event ):void
		{
			sendNotification( ApplicationFacade.INTERVAL, feedControls.interval );
		}
		
		/**
		 * Submit the new feed URL entered by the user.
		 */ 
		private function onSubmit( e:Event ):void
		{
			sendNotification( ApplicationFacade.CHANGE_FEED, feedControls.url );
		}

		/**
		 * Handle window close.
		 * <P>
		 * Remove all references to the window that exist inside 
		 * the module, then unregister this Mediator.</P>
		 * <P>
		 * Note that the main app has a listener on the component
		 * as well, which it will use to remove it from the view 
		 * hierarchy and then will remove all refs in the app 
		 * itself.</P> 
		 * <P>
		 * After that the module instance and all its contents 
		 * should be garbage collected.</P>
		 */
		private function onWindowClose( e:Event ):void
		{
			feedWindow.removeEventListener( FeedControls.INTERVAL, onInterval );
			feedWindow.removeEventListener( FeedControls.SUBMIT, onSubmit );
			feedWindow.removeEventListener( Event.CLOSE, onWindowClose );
			setViewComponent( null );
			var feedProxy:FeedProxy = facade.retrieveProxy(FeedProxy.NAME) as FeedProxy;
			feedProxy.resetTimer();
			facade.removeMediator(this.getMediatorName());
			sendNotification( LogMessage.SEND_TO_LOG, 
				"Closing window: removing references and timer. Bye, Bye.", 
				String(LogMessage.INFO) );
		}

		/**
		 * FeedWindow related Notification list.
		 */ 
		override public function listNotificationInterests():Array
		{
			return [
					ApplicationFacade.GET_FEED_WINDOW,
					ApplicationFacade.DATA
				   ];
		}
		
		/**
		 * Handle FeedWindow related Notifications.
		 * <P>
		 * Responds to Notifications from the Proxy containing
		 * feed data. 
		 * <P>
		 * Exports the FeedWindow when requested by sending
		 * a Notification with the FeedWindow as the body. 
		 * This will be captured by the PrattlerJunctionMediator
		 * which will send it to the shell via a pipe message.</P>
		 */
		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() )
			{
				case ApplicationFacade.DATA:
					feedWindow.feedArticle = note.getBody() as FeedVO;
					break;

				case ApplicationFacade.GET_FEED_WINDOW:
					sendNotification( ApplicationFacade.EXPORT_FEED_WINDOW, feedWindow );
					break;
			}
		}
	}
}