/*
 PureMVC AS3 MultiCore Demo – Flex PipeWorks 
 Copyright (c) 2008 Cliff Hall <cliff.hall@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package org.puremvc.as3.multicore.demos.flex.pipeworks.shell.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.TitleWindow;
	import mx.controls.Button;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.multicore.demos.flex.pipeworks.common.LogFilterMessage;
	import org.puremvc.as3.multicore.demos.flex.pipeworks.common.LogMessage;
	import org.puremvc.as3.multicore.demos.flex.pipeworks.shell.ApplicationFacade;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class ApplicationMediator extends Mediator
	{
		public static const NAME:String = 'ApplicationMediator';
		
		public function ApplicationMediator( viewComponent:PipeWorks )
		{
			super( NAME, viewComponent );
		}

		/**
		 * Register event listeners with the app and its fixed controls.
		 */
		override public function onRegister():void
		{
			app.addEventListener( PipeWorks.PRATTLE, onPrattle);		
			app.addEventListener( PipeWorks.LOG_LEVEL, onLogLevel );		
		}
		
		/**
		 * Application related Notification list.
		 */
		override public function listNotificationInterests():Array
		{
			return [ ApplicationFacade.SHOW_LOG_WINDOW,
					 ApplicationFacade.SHOW_LOG_BUTTON,
					 ApplicationFacade.SHOW_FEED_WINDOW
			       ];	
		}
		
		/**
		 * Handle MainApp / Shell related notifications.
		 * <P>
		 * Display and/or remove the module-manufactured LogButton, 
		 * LogWindow, and FeedWindows.</P>
		 */
		override public function handleNotification( note:INotification ):void
		{
			switch( note.getName() )
			{
				case  ApplicationFacade.SHOW_LOG_BUTTON:
					var logButton:Button = note.getBody() as Button;
					logButton.addEventListener(MouseEvent.CLICK, onLogButtonClick);
					app.addLogButton(note.getBody() as Button); 
					break;

				case  ApplicationFacade.SHOW_LOG_WINDOW:
					if (logWindow == null) {
						logWindow = UIComponent(note.getBody()) as TitleWindow;
						logWindow.addEventListener(Event.CLOSE, onLogWindowClose);
					}
					PopUpManager.addPopUp(UIComponent(note.getBody()), app);
					PopUpManager.centerPopUp(logWindow); 
					logWindowDisplayed=true;
					break;

				case  ApplicationFacade.SHOW_FEED_WINDOW:
					var feedWindowToAdd:TitleWindow = UIComponent(note.getBody()) as TitleWindow;
					feedWindowToAdd.addEventListener(Event.CLOSE, onFeedWindowClose);
					app.addFeedWindow(feedWindowToAdd); 
					break;

			}
		}
		
		/**
		 * Prattle button clicked.
		 * <P>
		 * Request a new FeedWindow.</P>
		 */
		private function onPrattle(event:Event):void
		{
			sendNotification(ApplicationFacade.REQUEST_FEED_WINDOW);
			sendNotification(LogMessage.SEND_TO_LOG,"Requesting feed window from PrattlerModule.",LogMessage.LEVELS[LogMessage.INFO]);
		}

		/**
		 * Log LevelChanged.
		 * <P>
		 * Change the LogLevel.</P>
		 */
		private function onLogLevel(event:Event):void
		{
			sendNotification(LogFilterMessage.SET_LOG_LEVEL,app.logLevel);
		}

		/**
		 * Log Window button clicked.
		 * <P>
		 * If the window hasn't been created yet, request
		 * it. If the window exists but is open, close it,
		 * or visaversa.</P>
		 */
		private function onLogButtonClick(event:Event):void
		{
			if (logWindowDisplayed) return onLogWindowClose(event);
			if (logWindow != null) {
				sendNotification(ApplicationFacade.SHOW_LOG_WINDOW, logWindow)
			} else {
				sendNotification(ApplicationFacade.REQUEST_LOG_WINDOW);
			}
		}

		/**
		 * Close the Log Window Popup. 
		 * <P>
		 * We keep the log window around and reuse 
		 * it each time you, so we leave the event listener in place.</P>
		 */
		private function onLogWindowClose(event:Event):void
		{
			PopUpManager.removePopUp(logWindow); 
			logWindowDisplayed=false;
		}
		
		/**
		 * Close a FeedWindow.
		 * <P>
		 * We want references to these windows to go away 
		 * once closed.</P>
		 */ 
		private function onFeedWindowClose(event:Event):void
		{
			var feedWindowToRemove:TitleWindow = event.target as TitleWindow;
			app.removeFeedWindow(feedWindowToRemove); 		
			sendNotification(ApplicationFacade.REMOVE_FEED_WINDOW, feedWindowToRemove);
		}
		
		/**
		 * The Application component.
		 */
		private function get app():PipeWorks
		{
			return viewComponent as PipeWorks;
		}
		
		private var logWindowDisplayed:Boolean = false;
		private var logWindow:TitleWindow;
	
	}
}