/*
 PureMVC AS3 MultiCore Demo – Flex PipeWorks 
 Copyright (c) 2008 Cliff Hall <cliff.hall@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package org.puremvc.as3.multicore.demos.flex.pipeworks.modules.logger.controller
{
    import org.puremvc.as3.multicore.demos.flex.pipeworks.modules.logger.model.LoggerProxy;
    import org.puremvc.as3.multicore.demos.flex.pipeworks.modules.logger.view.LoggerJunctionMediator;
    import org.puremvc.as3.multicore.interfaces.ICommand;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * Startup the Logger Module.
	 * <P>
	 * Register's a new LoggerProxy to keep the log, and a 
	 * LoggerJunctionMediator which will mediate communications
	 * over the pipes of the LoggerJunction.</P>
	 */
    public class StartupCommand extends SimpleCommand implements ICommand
    {
        override public function execute(note:INotification):void
        {
        	// NOTE: There is no need to register an 
        	// ApplicationMediator with the reference to the 
        	// module that was passed in. This module extends 
        	// PipeAwareModule, which simply uses the Facade 
        	// to send Notifications to accept input pipes and 
        	// output pipes and therefore does not need a Mediator.
        	
       		facade.registerProxy( new LoggerProxy( ) );
       		facade.registerMediator( new LoggerJunctionMediator( ) );
        }
        
    }
}