/*
 PureMVC AS3 MultiCore Demo – Flex PipeWorks 
 Copyright (c) 2008 Cliff Hall <cliff.hall@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package org.puremvc.as3.multicore.demos.flex.pipeworks.shell.controller
{
    import org.puremvc.as3.multicore.demos.flex.pipeworks.modules.PrattlerModule;
    import org.puremvc.as3.multicore.demos.flex.pipeworks.shell.ApplicationFacade;
    import org.puremvc.as3.multicore.demos.flex.pipeworks.shell.view.PrattlerModuleMediator;
    import org.puremvc.as3.multicore.interfaces.ICommand;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * Create a new PrattlerModule.
	 * <P>
	 * The new module is instantiated, and connected via pipes to the 
	 * logger and the shell. Finally a Mediator is registered for it.</P>
	 */
    public class PrattleCommand extends SimpleCommand implements ICommand
    {
        override public function execute(note:INotification):void
        {
			var prattler:PrattlerModule = new PrattlerModule();
   			sendNotification(ApplicationFacade.CONNECT_MODULE_TO_LOGGER, prattler );
   			sendNotification(ApplicationFacade.CONNECT_MODULE_TO_SHELL, prattler );
       		facade.registerMediator( new PrattlerModuleMediator( prattler ) );
		}
    }
}