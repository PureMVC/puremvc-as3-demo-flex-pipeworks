/*
 PureMVC AS3 MultiCore Demo – Flex PipeWorks - Prattler Module
 Copyright (c) 2008 Cliff Hall <cliff.hall@puremvc.org>

 Parts originally from: 
 PureMVC AS3 Demo – AIR RSS Headlines 
 Copyright (c) 2007-08 Simon Bailey <simon.bailey@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package org.puremvc.as3.multicore.demos.flex.pipeworks.modules
{
	import org.puremvc.as3.multicore.demos.flex.pipeworks.common.PipeAwareModule;
	import org.puremvc.as3.multicore.demos.flex.pipeworks.modules.prattler.ApplicationFacade;
	
	/**
	 * Prattler Module. 
	 * <P>
	 * This reads an RSS 1.0 Feed and displays its entry
	 * excerpts at an adjustable interval. You can
	 * also change the URL of the feed.</P>
	 * <P>
	 * The Module writes information about its activiites
	 * to the logger module on STDLOG in the form of
	 * LogMessagess. This includes messages at various
	 * levels, including INFO, DEBUG, ERROR, etc.</P> 
	 * <P>
	 * Most of the reader functionality is derived from 
	 * Simon Bailey's PureMVC AS3/AIR demo called 
	 * RSSHeadlines.</P>
	 */
	public class PrattlerModule extends PipeAwareModule
	{
		public static const NAME:String 			= 'PrattlerModule';
		public static const FEED_WINDOW_UI:String 	= 'FeedWindowUI';

		public function PrattlerModule()
		{
			super( ApplicationFacade.getInstance( moduleID ) );
			ApplicationFacade(facade).startup( this );
		}

		/**
		 * Get the unique id of module instance.
		 */
		public function getID():String
		{
			return moduleID;
		}

		/**
		 * Export the Feed Window please.
		 * <P>
		 * Note this is a different way of getting the module
		 * to give up its UI component than the LoggerModule
		 * uses. In the LoggerModule a UIQueryMessage is sent
		 * down the STDLOG pipe from the shell. That is a convenience 
		 * that the multiple-instantiated module doesn't have.</P>
		 * <P>
		 * The shell has a STDOUT that's TeeSplit to the STDIN 
		 * of all instances of the PrattlerModule. So any message
		 * written on STDOUT goes to all instances. So that
		 * one to one collaboration the shell and log share doesn't
		 * work. So the main app instantiates a lightweight
		 * mediator for each instance of this module, and that
		 * mediator calls this method when the pipes are in
		 * place and the shell is ready to receive the exported
		 * FeedWindow.</p>
		 */
		public function exportFeedWindow():void
		{
			facade.sendNotification(ApplicationFacade.GET_FEED_WINDOW);
		}

		/**
		 * Get the next unique id.
		 * <P>
		 * This module can be instantiated multiple times, 
		 * so each instance needs to have it's own unique
		 * id for use as a multiton key.
		 */
		private static function getNextID():String
		{
			return NAME + '/' + serial++;
		}
		
		private static var serial:Number = 0;
		private var moduleID:String = PrattlerModule.getNextID();
	}
}