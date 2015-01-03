package com.newprogrammer.codehighlight.parser;

abstract ProductionRules(Map<String, String>) {
	public function new() {
		this = new Map<String, String>();
	}
	
	public function produce(type:String, token:String):String {
		var productionRule:String;
		if (!this.exists(type))
			productionRule = get("DEFAULT");
		else
		    productionRule = get(type);
		return (new EReg("\\$type", "g")).replace((new EReg("\\$value", "g")).replace(productionRule, token), type);
	}
	
	public static function fromJSON(json:ProductionRulesStructure):ProductionRules {
		var rules = new ProductionRules();
		for (production in json.productions)
			rules.set(production.type, production.production);
		return rules;
	}
	
	@:arrayAccess
	public inline function get(key:String):String {
		return this[key];
	}
	
	@:arrayAccess
	public inline function set(key:String, value:String):Void {
		this[key] = value;
	}
}

typedef ProductionStructure = {
	var type:String;
	var production:String;
}

typedef ProductionRulesStructure = {
	var name:String;
	var productions:Array<ProductionStructure>;
}