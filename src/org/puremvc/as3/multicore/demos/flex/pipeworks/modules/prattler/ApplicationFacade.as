/*
 PureMVC AS3 MultiCore Demo – Flex PipeWorks - Prattler Module
 Copyright (c) 2008 Cliff Hall <cliff.hall@puremvc.org>

 Parts originally from: 
 PureMVC AS3 Demo – AIR RSS Headlines 
 Copyright (c) 2007-08 Simon Bailey <simon.bailey@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package org.puremvc.as3.multicore.demos.flex.pipeworks.modules.prattler
{
	import org.puremvc.as3.multicore.demos.flex.pipeworks.modules.PrattlerModule;
	import org.puremvc.as3.multicore.demos.flex.pipeworks.modules.logger.controller.LogMessageCommand;
	import org.puremvc.as3.multicore.demos.flex.pipeworks.modules.prattler.controller.ChangeFeedCommand;
	import org.puremvc.as3.multicore.demos.flex.pipeworks.modules.prattler.controller.IntervalCommand;
	import org.puremvc.as3.multicore.demos.flex.pipeworks.modules.prattler.controller.StartupCommand;
	import org.puremvc.as3.multicore.patterns.facade.Facade;

	/**
	 * Application Facade for Prattler Module.
	 */ 
	public class ApplicationFacade extends Facade
	{
		/**
		 * Notification name constants
		 */
		public static const STARTUP:String     			= "startup";
        public static const LOG_MSG:String				= 'logMessage';
        public static const GET_FEED_WINDOW:String		= 'getFeedWindow';
        public static const EXPORT_FEED_WINDOW:String	= 'exportFeedWindow';
		 
		public static const DATA:String        = "data";
		public static const XML_DATA:String    = "xmlData";
		public static const INTERVAL:String    = "interval";
		public static const CHANGE_FEED:String = "changeFeed";
		
        public function ApplicationFacade( key:String )
        {
            super(key);    
        }

        /**
         * ApplicationFacade Factory Method
         */
        public static function getInstance( key:String ) : ApplicationFacade 
        {
            if ( instanceMap[ key ] == null ) instanceMap[ key ]  = new ApplicationFacade( key );
            return instanceMap[ key ] as ApplicationFacade;
        }
        
        /**
         * Register Commands with the Controller 
         */
        override protected function initializeController( ) : void 
        {
            super.initializeController();            
            registerCommand( STARTUP, StartupCommand );
            registerCommand( LOG_MSG, LogMessageCommand );
			registerCommand( INTERVAL, IntervalCommand );
			registerCommand( CHANGE_FEED, ChangeFeedCommand );
        }
        
        /**
         * Application startup
         * 
         * @param app a reference to the application component 
         */  
        public function startup( app:PrattlerModule ):void
        {
            sendNotification( STARTUP, app );
        }
	}
}