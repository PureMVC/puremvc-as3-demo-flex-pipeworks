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
	 * Startup the Main Application/Shell.
	 * <P>
	 * Create and register ApplicationMediator which will own and 
	 * manage the app and its visual components.<P>
	 * <P>
	 * Create and register LoggerModuleMediator which will own
	 * the logger module and be responsible for connecting things
	 * to it via pipes.</P>
	 * <P>
	 * Create and register ShellJunctionMediator which will own
	 * and manage the Junction for the Main App/Shell.</P>
	 * <P>
	 * Send a notification to request the LogButton UI component.
	 * This will result in a UIQueryMessage being sent to the 
	 * LoggerModule, and the LoggerModule will respond by creating
	 * the button and sending it back to the shell, where it will
	 * be placed in the visual hierarchy of the Main Application.</P>
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