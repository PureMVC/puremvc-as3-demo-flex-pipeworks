/*
 PureMVC AS3 MultiCore Demo – Flex PipeWorks - Prattler Module
 Copyright (c) 2008 Cliff Hall <cliff.hall@puremvc.org>

 Parts originally from: 
 PureMVC AS3 Demo – AIR RSS Headlines 
 Copyright (c) 2007-08 Simon Bailey <simon.bailey@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package org.puremvc.as3.multicore.demos.flex.pipeworks.modules.prattler.controller
{
    import org.puremvc.as3.multicore.demos.flex.pipeworks.common.LogMessage;
    import org.puremvc.as3.multicore.demos.flex.pipeworks.modules.prattler.model.FeedProxy;
    import org.puremvc.as3.multicore.demos.flex.pipeworks.modules.prattler.view.FeedWindowMediator;
    import org.puremvc.as3.multicore.demos.flex.pipeworks.modules.prattler.view.PrattlerJunctionMediator;
    import org.puremvc.as3.multicore.demos.flex.pipeworks.modules.prattler.view.components.FeedWindow;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * Startup the Prattler Module.
	 * <P>
	 * Create and register new FeedProxy to manage the the feed.</P>
	 * <P>
	 * Create and register new PrattlerJunctionMediator which 
	 * will mediate communications over the pipes of the 
	 * PrattlerJunction to manage the the feed.</P>
	 */
    public class StartupCommand extends SimpleCommand
    {
        override public function execute(note:INotification):void
        {
        	// NOTE: There is no need to register an 
        	// ApplicationMediator with the reference to the 
        	// module that was passed in. This module extends 
        	// PipeAwareModule, which simply uses the Facade 
        	// to send Notifications to accept input pipes and 
        	// output pipes and therefore does not need a Mediator.
			// Error parsing feed XML.
		 	facade.registerProxy( new FeedProxy( ) );

			// create and register the Junction Mediator
			facade.registerMediator( new PrattlerJunctionMediator());
			
			// Create and register the FeedWindow and its 
			// Mediator for this module instance.
		 	var feedWindow:FeedWindow = new FeedWindow( );
			facade.registerMediator( new FeedWindowMediator( feedWindow ) );

        }
        
    }
}