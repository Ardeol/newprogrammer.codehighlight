package com.newprogrammer.codehighlight.parser;

/** LanguageRules Abstract
 *  @author		Timothy Foster
 * 	@version	0.00.141230
 *  Structure that represents the format for a language JSON file.
 */
abstract LanguageRules(LanguageRulesStructure) from LanguageRulesStructure {
/**
 *  Name of the language
 */
	public var name(get, never):String;
	
/**
 *  Version of the file being used
 */
	public var version(get, never):String;
	
/**
 *  List of top-level TokenRules associated with the language
 */
	public var tokens(get, never):Array<TokenRule>;
	
/**
 *  Converts the output of Json.parse() into a structure of this type
 *  @param	value	Primitive structure that derives from a JSON file
 *  @return	An instance of the LanguageRules abstract so that it can be interacted with
 */
	public static function fromJSON(value:LanguageRulesStructure):LanguageRules {
	//  Direct cast is possible
		return value;
	}
	
	private inline function get_name():String {  return this.name; }
	private inline function get_version():String {  return this.version; }
	private inline function get_tokens():Array<TokenRule> {  return this.tokens; }
}

/** LanguageRulesStructure Structure
 *  Primitive structure that represents the format for a language JSON file.
 */
typedef LanguageRulesStructure = {
	var name:String;
	var version:String;
	var tokens:Array<TokenRule>;
}