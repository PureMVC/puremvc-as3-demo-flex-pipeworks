/*
 PureMVC AS3 MultiCore Demo – Flex PipeWorks 
 Copyright (c) 2008 Cliff Hall <cliff.hall@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package org.puremvc.as3.multicore.demos.flex.pipeworks.modules.logger
{
	import org.puremvc.as3.multicore.demos.flex.pipeworks.modules.LoggerModule;
	import org.puremvc.as3.multicore.demos.flex.pipeworks.modules.logger.controller.CreateLogButtonCommand;
	import org.puremvc.as3.multicore.demos.flex.pipeworks.modules.logger.controller.CreateLogWindowCommand;
	import org.puremvc.as3.multicore.demos.flex.pipeworks.modules.logger.controller.LogMessageCommand;
	import org.puremvc.as3.multicore.demos.flex.pipeworks.modules.logger.controller.StartupCommand;
	import org.puremvc.as3.multicore.patterns.facade.Facade;

	/**
	 * Application Facade for Logger Module.
	 */ 
	public class ApplicationFacade extends Facade
	{
        public static const STARTUP:String 				= 'startup';
        public static const LOG_MSG:String 				= 'logMessage';
        public static const CREATE_LOG_BUTTON:String	= 'createLogButton';
        public static const CREATE_LOG_WINDOW:String	= 'createLogWindow';
        public static const EXPORT_LOG_BUTTON:String	= 'exportLogButton';
        public static const EXPORT_LOG_WINDOW:String	= 'exportLogWindow';
                
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
            registerCommand( CREATE_LOG_WINDOW, CreateLogWindowCommand );
            registerCommand( CREATE_LOG_BUTTON, CreateLogButtonCommand );
        }
        
        /**
         * Application startup
         * 
         * @param app a reference to the application component 
         */  
        public function startup( app:LoggerModule ):void
        {
            sendNotification( STARTUP, app );
        }
	}
}