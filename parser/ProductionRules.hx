package com.newprogrammer.codehighlight.parser;

/** ProductionRules Abstract
 *  @author		Timothy Foster
 * 	@version	0.00.141230
 *  A mapping from a production type to its format.  Generated from a production JSON file.
 */
abstract ProductionRules(Map<String, String>) {
/**
 *  Create a new ProductionRules object.
 */
	public function new() {
		this = new Map<String, String>();
	}
	
/**
 *  Transforms a token according to the given production type.  If the type does not exist, the special type DEFAULT is used.
 *  @param	type	Production rule to use when producing the output.
 *  @param	token	The token to transform using the given production rule.
 *  @return	Formatted string.
 */
	public function produce(type:String, token:String):String {
		var productionRule:String;
		if (!this.exists(type))
			productionRule = get("DEFAULT");
		else
		    productionRule = get(type);
		return (new EReg("\\$type", "g")).replace((new EReg("\\$value", "g")).replace(productionRule, token), type);
	}
	
/**
 *  Converts the output of Json.parse() into a structure of this type
 *  @param	value	Primitive structure that derives from a JSON file
 *  @return	An instance of the ProductionRules abstract so that it can be interacted with
 */
	public static function fromJSON(json:ProductionRulesStructure):ProductionRules {
		var rules = new ProductionRules();
		for (production in json.productions)
			rules.set(production.type, production.production);
		return rules;
	}
	
/**
 *  Retrieve the production format given the type.
 *  @param	key	The type of the production.
 *  @return	Production format.
 */
	@:arrayAccess
	public inline function get(key:String):String {
		return this[key];
	}
	
/**
 *  Sets the production format given the type.
 *  @param	key	The type of the production
 *  @param	value	The new format to use
 */
	@:arrayAccess
	public inline function set(key:String, value:String):Void {
		this[key] = value;
	}
}

/** ProductionStructure Structure
 *  Primitive structure that represents the format for a single production in the production JSON file.
 */
typedef ProductionStructure = {
	var type:String;
	var production:String;
}

/** ProductionRulesStructure Structure
 *  Primitive structure that represents the format for production JSON file.
 */
typedef ProductionRulesStructure = {
	var name:String;
	var productions:Array<ProductionStructure>;
}