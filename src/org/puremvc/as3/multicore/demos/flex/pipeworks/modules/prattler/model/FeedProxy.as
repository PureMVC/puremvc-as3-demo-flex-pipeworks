/*
 PureMVC AS3 MultiCore Demo – Flex PipeWorks - Prattler Module
 Copyright (c) 2008 Cliff Hall <cliff.hall@puremvc.org>

 Parts originally from: 
 PureMVC AS3 Demo – AIR RSS Headlines 
 Copyright (c) 2007-08 Simon Bailey <simon.bailey@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package org.puremvc.as3.multicore.demos.flex.pipeworks.modules.prattler.model
{
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.multicore.demos.flex.pipeworks.common.LogMessage;
	import org.puremvc.as3.multicore.demos.flex.pipeworks.modules.prattler.ApplicationFacade;
	import org.puremvc.as3.multicore.demos.flex.pipeworks.modules.prattler.model.vo.FeedVO;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	/**
	 * Feed Proxy.
	 */
	public class FeedProxy extends Proxy
	{	
		public static const NAME:String = "FeedProxy";
		
		private var ticker:Timer;
		private var urlLoader:URLLoader;
		private var urlRequest:URLRequest;
		private var entryNumber:uint;
		private var feedChange:Boolean = false;
		
		// Adjust starting values accordingly
		private var url:String = "http://weblogs.macromedia.com/mxna/xml/rss.cfm";

		// Duration 1000 = 1 second
		public var duration:uint = 3000;

		private static var feed:int = 0;
		private static var feeds:Array = [ "http://feeds.feedburner.com/oreilly/radar/atom",
										   "http://feeds.wired.com/wired/software?format=xml",
										   "http://rss.slashdot.org/Slashdot/slashdot",
										   "http://feeds.dzone.com/dzone/frontpage?format=xml",
										   "http://weblogs.macromedia.com/mxna/xml/rss.cfm",
										   ];
		
		public function FeedProxy( )
		{
			var contentAC:ArrayCollection = new ArrayCollection();
			super( NAME, contentAC );
		}
		
		/**
		 * As soon as FeedProxy is registered, fetch a feed.
		 */
		override public function onRegister():void
		{
			feed++; 
			if (feed > feeds.length-1) feed=0;
			url = feeds[feed];
			
			fetchURL();
		}
		
		/**
		 * Fetch the next feed URL.
		 */
		public function fetchURL():void
		{	
			// Debug fetch URL
			sendNotification( LogMessage.SEND_TO_LOG, 
				"Fetching:"+url, 
				LogMessage.LEVELS[LogMessage.DEBUG] );

			if( feedChange != false)
			{
				data = new ArrayCollection();
			}
			
			urlRequest = new URLRequest();
			var time:Date = new Date();
			urlRequest.url = url;
			
			urlLoader = new URLLoader();
			urlLoader.addEventListener( Event.COMPLETE, onComplete );
			urlLoader.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
			urlLoader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
			urlLoader.addEventListener( HTTPStatusEvent.HTTP_STATUS, onStatus );
					
			urlLoader.load( urlRequest );
			createTimer();
		}
		
		/**
		 * Return data property cast to proper type
		 */
		public function get feedContent():ArrayCollection
		{			
			if (data==null) data = new ArrayCollection();
			return data as ArrayCollection;
		}
		
		/**
		 * Handle service response.
		 * <P>
		 * Parse the XML feed into FeedVOs and add to the
		 * ArrayCollection this Proxy manages as a representation
		 * of the feed.</P>
		 */
		private function onComplete( event:Event ):void
		{
			entryNumber = 0;
			feedChange = false;
			
			// debug level log message
			sendNotification( LogMessage.SEND_TO_LOG, 
				"Received XML from "+url+" Preparing to parse..",
				LogMessage.LEVELS[LogMessage.DEBUG] );

			var feedXML:XML;
			
			try {
				feedXML = XML( urlLoader.data );
			} catch (e:Error) {
				
			// Error parsing feed XML.
			sendNotification( LogMessage.SEND_TO_LOG, 
				"Error parsing feed: "+e.message, 
				LogMessage.LEVELS[LogMessage.DEBUG] );
				return;
			}

			
			// Try to parse as RSS 2.0, most prevalent first
			var rss2:Boolean = tryRSS2( feedXML );
			if (rss2) {
				parseSuccess("Successfully parsed RSS 2.0 feed.");
				return;
			}     

			// Try to parse as RSS Atom 1.0, next most prevalent 
			var atom1:Boolean = tryAtom1( feedXML );
			if (atom1) {
				parseSuccess("Successfully parsed Atom 1.0 feed.");
				return;
			}     

			// Try to parse as RSS 1.0
			var rss1:Boolean = tryRSS1( feedXML );
			if (rss1) {
				parseSuccess("Successfully parsed RSS 1.0 feed.");
				return;
			}     

			// Error parsing feed XML.
			sendNotification( LogMessage.SEND_TO_LOG, 
				"Unable to parse feed as Atom 1.0, RSS 2.0 or RSS 1.0. Sorry giving up.", 
				LogMessage.LEVELS[LogMessage.ERROR] );
  		}
  		
  		/**
  		 * Successful parsing of feed.
  		 */
  		public function parseSuccess( message:String ):void
  		{
			// Info level log message
			sendNotification( LogMessage.SEND_TO_LOG, 
				message, 
				LogMessage.LEVELS[LogMessage.INFO] );

		    sendNotification( ApplicationFacade.XML_DATA );
		    startTimer();
  		}
  		
  		/**
  		 * Try to parse the feed as RSS 1.0
  		 */
  		public function tryRSS1( feedXML:XML ):Boolean
  		{
			// Debug level log message
			sendNotification( LogMessage.SEND_TO_LOG, 
				"Trying to parse as RSS 1.0", 
				LogMessage.LEVELS[LogMessage.DEBUG] );

			setData(new ArrayCollection());
 			var rss:Namespace = new Namespace("http://purl.org/rss/1.0/");
	        var dc:Namespace = new Namespace("http://purl.org/dc/elements/1.1/");
			var rdf:Namespace = new Namespace("http://purl.org/rss/1.0/");
			var channel:String = feedXML..rss::channel.rss::title;
			if (channel != null) {
		        for each(var item:XML in feedXML..rss::item)
		        {
		        	var feedArticle:FeedVO = new FeedVO();
		        	feedArticle.channel = channel;
		        	feedArticle.date = item..dc::date;
		        	feedArticle.subject = item..rss::title;
		        	feedArticle.articlebody = item..rss::description;
		        	feedArticle.articlelink = item..rss::link;
		        	feedContent.addItem( feedArticle );
		        }
			}
	        return (feedContent.length>0)?true:false;
  		}

  		/**
  		 * Try to parse the feed as RSS 2.0
  		 */
  		public function tryRSS2( feedXML:XML ):Boolean
  		{

			// Debug 
			sendNotification( LogMessage.SEND_TO_LOG, 
				"Trying to parse as RSS 2.0", 
				LogMessage.LEVELS[LogMessage.DEBUG] );

			setData(new ArrayCollection());
			var version:String = feedXML.@version;
			var channel:String = feedXML.channel.title;
			if (channel != null) {
		        for each(var item:XML in feedXML..item)
		        {
		        	var feedArticle:FeedVO = new FeedVO();
		        	feedArticle.channel = channel;
		        	feedArticle.date = item.pubDate;
		        	feedArticle.subject = item.title;
		        	feedArticle.articlebody = item.description;
		        	feedArticle.articlelink = item.link;
		        	feedContent.addItem( feedArticle );
		        }
			}
	        return (feedContent.length>0)?true:false;
  		}

 		/**
  		 * Try to parse the feed as Atom 1.0
  		 */
  		public function tryAtom1( feedXML:XML ):Boolean
  		{
			// Debug 
			sendNotification( LogMessage.SEND_TO_LOG, 
				"Trying to parse as Atom 1.0", 
				LogMessage.LEVELS[LogMessage.DEBUG] );

			setData(new ArrayCollection());
			var atom:Namespace = new Namespace("http://www.w3.org/2005/Atom");
			var channel:String = feedXML.atom::title;
			if (channel != '') {
		        for each(var entry:XML in feedXML..atom::entry)
		        {
		        	var feedArticle:FeedVO = new FeedVO();
		        	feedArticle.channel = channel;
		        	feedArticle.date = entry.atom::published;
		        	feedArticle.subject = entry.atom::title;
		        	feedArticle.articlebody = (entry.atom::summary||entry.atom::content);
		        	feedArticle.articlelink = entry.atom::link.@href;
		        	feedContent.addItem( feedArticle );
		        }
			}
	        return (feedContent.length>0)?true:false;
  		}
  		
  		/**
  		 * Set the Feed URL.
  		 */
  		public function setURL( url:String ):void
  		{
  			this.url = url;
  			feedChange = true;
  			resetTimer();
  			fetchURL();
  		}
  		
  		/**
  		 * Set the timer duration based on the reading rate interval.
  		 */
  		public function setInterval( interval:Number ):void
  		{
  			duration = Math.floor( interval*1000 );
  			resetTimer();
			startTimer();
  		}
  		
  		/**
  		 * Reset the reading timer.
  		 */
		public function resetTimer():void
		{
			if (ticker) ticker.stop();
			ticker.reset();
			ticker.removeEventListener( TimerEvent.TIMER, onTick );
			
			if( ! feedChange )
			{
				createTimer();
			}
		}

		/**
		 * Create the reading timer.
		 */
  		public function createTimer():void
		{	
			ticker = new Timer( duration );
            ticker.addEventListener( TimerEvent.TIMER, onTick );
		}
		
		/**
		 * Start the reading timer.
		 */
		public function startTimer():void
		{   
            ticker.start();
		}
		
		/**
		 * Tick Tock.
		 * <P>
		 * Display the next article in the feed or wrap around and display the first.</P> 
		 */
		private function onTick( e:TimerEvent ):void
		{	
			if ( feedContent.length == 0) return;
			if( entryNumber < feedContent.length-1 )
			{
				entryNumber++;
			} else
			{
				entryNumber = 0;
			}

			// Get the next article
			var feedArticle:FeedVO = feedContent.getItemAt( entryNumber ) as FeedVO;

			// Debug the advance of the article number
			sendNotification( LogMessage.SEND_TO_LOG, 
				"Advancing to "+entryNumber+' of '+feedContent.length+": "+feedArticle.subject, 
				LogMessage.LEVELS[LogMessage.DEBUG] );
			
			// display it
			sendNotification( ApplicationFacade.DATA, feedArticle );
		}

		/**
		 * Report an IOError.
		 */		
		private function onIOError( event:IOErrorEvent ):void
		{
			sendNotification( LogMessage.SEND_TO_LOG, event.text, String(LogMessage.ERROR) );
		}
		
		/**
		 * Report an IOError.
		 */		
		private function onSecurityError( event:SecurityErrorEvent ):void
		{       
            sendNotification( LogMessage.SEND_TO_LOG, event.text, String(LogMessage.ERROR));
        }

		/**
		 * Report an HTTPStatusEvent.
		 */		
		private function onStatus( event:HTTPStatusEvent ):void
		{
			if(event.status != 0)
			{
	            sendNotification( LogMessage.SEND_TO_LOG, "HTTP Result Status: "+event.status, String(LogMessage.INFO));
			}
		}

	}
}