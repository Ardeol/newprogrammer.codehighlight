package com.newprogrammer.codehighlight.parser;

/** TokenRule Abstract
 *  @author		Timothy Foster
 * 	@version	0.00.141230
 *  Structure that represents the format for a token in a JSON language file.
 */
abstract TokenRule(TokenRuleStructure) from TokenRuleStructure {
/**
 *  The type of Production rule to invoke upon being parsed.
 */
	public var type(get, never):String;
	
/**
 *  A regular expression describing a valid string that parses into this token.
 */
	public var rule(get, never):EReg;
	
/**
 *  List of TokenRules to be investigated upon parsing this token.
 */
	public var tokens(get, never):Array<TokenRule>;

/**
 *  Allows the program to alter a token rule in the event that rules are dynamic.  Cannot be changed mid-parse.
 *  @param	newRule	String representing the new EReg
 */
	public function changeRule(newRule:String):Void {
		this.rule = newRule;
	}
	
/**
 *  Finds if the input string follows the token's rule
 *  @param	s	String to match against
 *  @return	Returns matched substring; returns empty string if no match
 */
	public function match(s:String):String {
		var r = rule;
		if (r.match(s))
			return r.matched(0);
		return "";
	}
	
	private inline function get_type():String {  return this.type; }
	private inline function get_rule():EReg {  return new EReg("^" + this.rule, ""); }
	private inline function get_tokens():Array<TokenRule> {  return this.tokens; }
}

/** TokenRuleStructure Structure
 *  Primitive structure that represents the format for a token in the language JSON file.
 */
private typedef TokenRuleStructure = {
	var type:String;
	var rule:String;
	var tokens:Array<TokenRule>;
}