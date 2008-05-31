/*
 PureMVC AS3 MultiCore Demo – Flex PipeWorks 
 Copyright (c) 2008 Cliff Hall <cliff.hall@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package org.puremvc.as3.multicore.demos.flex.pipeworks.shell
{
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.demos.flex.pipeworks.shell.controller.PrattleCommand;
	import org.puremvc.as3.multicore.demos.flex.pipeworks.shell.controller.StartupCommand;

	/**
	 * Concrete Facade for the Main App / Shell.
	 */
	public class ApplicationFacade extends Facade
	{
        public static const STARTUP:String 					= 'startup';
        public static const CONNECT_SHELL_TO_LOGGER:String  = 'connectShellToLogger';
        public static const CONNECT_MODULE_TO_LOGGER:String = 'connectModuleToLogger';
        public static const CONNECT_MODULE_TO_SHELL:String  = 'connectModuleToShell';
        public static const REQUEST_LOG_BUTTON:String 		= 'requestLogButton';
        public static const REQUEST_LOG_WINDOW:String 		= 'requestLogWindow';
        public static const REQUEST_FEED_WINDOW:String 		= 'requestFeedWindow';
        public static const SHOW_LOG_BUTTON:String 			= 'showLogButton';
        public static const SHOW_LOG_WINDOW:String 			= 'showLogWindow';
        public static const SHOW_FEED_WINDOW:String 		= 'showFeedWindow';
        public static const REMOVE_FEED_WINDOW:String 		= 'removeFeedWindow';

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
            registerCommand( REQUEST_FEED_WINDOW, PrattleCommand );
        }
        
        /**
         * Application startup
         * 
         * @param app a reference to the application component 
         */  
        public function startup( app:PipeWorks ):void
        {
            sendNotification( STARTUP, app );
        }
	}
}