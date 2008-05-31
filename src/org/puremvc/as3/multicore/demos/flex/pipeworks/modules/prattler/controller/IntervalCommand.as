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
	import org.puremvc.as3.multicore.demos.flex.pipeworks.modules.prattler.model.FeedProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * Set the new reading rate interval. 
	 */
	public class IntervalCommand extends SimpleCommand
	{
		override public function execute( note:INotification ):void
		{	
     		var feedProxy:FeedProxy = facade.retrieveProxy( FeedProxy.NAME ) as FeedProxy;
     		var interval:Number = note.getBody() as Number;
     		feedProxy.setInterval( interval );
		}
	}
}