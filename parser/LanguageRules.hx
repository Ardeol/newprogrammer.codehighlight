package com.newprogrammer.codehighlight.parser;

abstract LanguageRules(LanguageRulesStructure) from LanguageRulesStructure {
	public var name(get, never):String;
	public var version(get, never):String;
	public var tokens(get, never):Array<TokenRule>;
	
	public static function fromJSON(value:LanguageRulesStructure):LanguageRules {
	//  Direct cast is possible
		return value;
	}
	
	private inline function get_name():String {  return this.name; }
	private inline function get_version():String {  return this.version; }
	private inline function get_tokens():Array<TokenRule> {  return this.tokens; }
}

typedef LanguageRulesStructure = {
	var name:String;
	var version:String;
	var tokens:Array<TokenRule>;
}