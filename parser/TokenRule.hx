package com.newprogrammer.codehighlight.parser;

abstract TokenRule(TokenRuleStructure) from TokenRuleStructure {
	public var type(get, never):String;
	public var rule(get, never):EReg;
	public var tokens(get, never):Array<TokenRule>;
	
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

private typedef TokenRuleStructure = {
	var type:String;
	var rule:String;
	var tokens:Array<TokenRule>;
}