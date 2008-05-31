/*
 PureMVC AS3 MultiCore Demo – Flex PipeWorks - Prattler Module
 Copyright (c) 2008 Cliff Hall <cliff.hall@puremvc.org>

 Parts originally from: 
 PureMVC AS3 Demo – AIR RSS Headlines 
 Copyright (c) 2007-08 Simon Bailey <simon.bailey@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package org.puremvc.as3.multicore.demos.flex.pipeworks.modules.prattler.model.vo
{
	/**
	 * Feed Value Object. 
	 * <P>
	 * Carries information to describe a single article in a Feed.</P>
	 */
	[Bindable] public class FeedVO
	{
		public var channel:String;
		public var date:String;
		public var author:String;
		public var subject:String;
		public var articlebody:String;
		public var articlelink:String;
		
		public function FeedVO(){};
	}
}