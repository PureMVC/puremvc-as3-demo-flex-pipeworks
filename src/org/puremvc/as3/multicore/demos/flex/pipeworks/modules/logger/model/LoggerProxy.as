/*
 PureMVC AS3 MultiCore Demo – Flex PipeWorks 
 Copyright (c) 2008 Cliff Hall <cliff.hall@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package org.puremvc.as3.multicore.demos.flex.pipeworks.modules.logger.model
{
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.multicore.demos.flex.pipeworks.common.LogMessage;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	/**
	 * The Logger Proxy.
	 * <P>
	 * Maintains the list of <code>LogMessages</code>. 
	 * This class could be extended to write log 
	 * messages to a remote service as well.</P>
	 * 
	 * <P>
	 * An <code>ArrayCollection</code> is used to 
	 * hold the messages because it will be used
	 * as a data provider for UI controls, which
	 * will automatically be refreshed when the
	 * contents of the ArrayCollection changes.</P>
	 */
	public class LoggerProxy extends Proxy
	{
        public static const NAME:String = 'LoggerProxy';

		public function LoggerProxy()
        {
            super( NAME, new ArrayCollection() );
        }
        
        public function addLogEntry(message:LogMessage):void
        {
        	messages.addItem(message);
        }
		
		public function get messages():ArrayCollection
		{
			return data as ArrayCollection;
		}
	}
}