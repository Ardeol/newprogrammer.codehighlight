package com.newprogrammer.codehighlight;

import js.Browser;
import js.Lib;
import js.html.Document;
import js.html.Node;
import js.html.Element;
import js.html.TextAreaElement;
import js.html.InputElement;

import haxe.Http;
import haxe.Json;

import com.newprogrammer.codehighlight.parser.*;

class CodeHighlight {
	private static inline var PRODUCTION_WIKIDOT = "wikidot";
	private static inline var PRODUCTION_HTML    = "html";
	
	private var doc:Document;
	private var page:Gui;
	
	private var languageData:Map<String, LanguageRules>;  // remembers loaded languages
	private var productionData:Map<String, ProductionRules>;  // remembers production rules
	
	public function new(doc:Document) {
		this.doc = doc;
		this.page = new Gui(this, doc);
		this.languageData = new Map<String, LanguageRules>();
		this.productionData = new Map<String, ProductionRules>();
		
		this.page.render();
		
	//  For the moment, we only have two, so we can upload them immediately
		loadFile("productions_wikidot.json", function(raw:String):Void {
			productionData[PRODUCTION_WIKIDOT] = ProductionRules.fromJSON(Json.parse(raw));
		});
		loadFile("productions_html.json", function(raw:String):Void {
			productionData[PRODUCTION_HTML] = ProductionRules.fromJSON(Json.parse(raw));
		});
	}
	
/**
 *  The Master Method.  This is the primary highlight method, called when the user has 
 *  filled in the textarea with code to highlight.  This method handles production 
 *  generation and outputs to the field.  This should only be invoked on a present 
 *  CodeHighlight object.
 *  @param	langId	ID for the language being parsed
 */
	public function highlight(langId:String):Void {
	/*  Process:
		 * Obtain language data, fetching it if need be.  Recalls highlight upon load.
		 * Obtain input data from textarea (user's code)
		 * Generate ProductionRules from options/language if need be
		 * Perform parse
		 * Output the data
	*/
		if (!languageData.exists(langId)) {
			loadFile('language_$langId.json', function(raw:String):Void {
				var data:LanguageRules = Json.parse(raw);
				languageData[langId] = data;
				highlight(langId);  // now it is loaded
			});
		}
		else {
			try{
				var input:String = page.getCodeInput();
				var currentProduction:ProductionRules = selectProduction();
				
				adjustProduction(currentProduction);
				if (!~/\n/.match(input))
					currentProduction["language"] = currentProduction["languageSingleLine"];
				currentProduction.set("language", StringTools.replace(currentProduction.get("language"), "$language", langId));
				
				addCustomTypenames(languageData[langId]);
				
				var output = Parser.parse(input, languageData[langId], currentProduction);
				if (page.isOptionChecked(Gui.OPTION_FORMAT))
					page.setCodeOutput(output);
				else
					page.setCodeOutput(fixForWikidot(output));
					
				page.displaySuccess();
			}
			catch (err:Dynamic) {
				page.displayError(Std.string(err));
			}
		}
	}
	
	/*  Class Methods
	=========================================================================*/
	public static function loadFile(filename:String, callback:String->Void):Void {
		var loader = new Http(filename);
		loader.onData = function(raw:String):Void {
			try {
				callback(raw);
			}
			catch (err:Dynamic) {
				Main.debug(err);
			}
		};
		loader.onError = function(msg:String):Void {
			Main.debug("File cannot be found");
		};
		loader.request();
	}
	
	/*  Private Methods
	=========================================================================*/
	private inline function selectProduction():ProductionRules {
		if (page.isOptionChecked(Gui.OPTION_FORMAT))
			return productionData[PRODUCTION_HTML];
		return productionData[PRODUCTION_WIKIDOT];
	}
	
/**
 *  @private
 *  Adjusts the production so that it matches the options the user has selected
 *  @param	productions	ProductionRules that define behavior for producing code both with and without lines.  Modified by this method.
 */
	private inline function adjustProduction(productions:ProductionRules):Void {
	//  Note that newlineWith[out]Lines and languageWith[out]Lines must be defined 
    //  in the production file
		if (page.isOptionChecked(Gui.OPTION_LINES)) {
			productions["blanknewline"] = productions["blanknewlineWithLines"];
			productions["newline"] = productions["newlineWithLines"];
			productions["language"] = productions["languageWithLines"];
		}
		else {
			productions["blanknewline"] = productions["blanknewlineWithoutLines"];
			productions["newline"] = productions["newlineWithoutLines"];
			productions["language"] = productions["languageWithoutLines"];
		}
		
		if (page.isOptionChecked(Gui.OPTION_TYPENAMES))
			productions["inferredtype"] = productions["inferredtypeUsed"];
		else
			productions["inferredtype"] = productions["inferredtypeIgnored"];
	}
	
	private inline function addCustomTypenames(language:LanguageRules):Void {
	//  Requires a customtypes definition in language
		var typenames:Array<String> = page.getTypenamesInput().split("\n");
		var ruleStr:String = "";
		if (typenames.length > 0 && typenames[0].length > 0) {
			var rule = new StringBuf();
			rule.add("(");
			for (type in typenames) {
				if (~/[A-Za-z0-9_]+/.match(type))
					rule.add('$type|');
			}
			ruleStr = rule.toString().substring(0, rule.length - 1) + ")";
		}
		
		var customTypesToken:TokenRule = null;
		for (token in language.tokens[0].tokens) {
			if (token.type == "customtypes") {
				customTypesToken = token;
				break;
			}
		}
		customTypesToken.changeRule(ruleStr);
	}
	
	private function fixForWikidot(text:String):String {
		text = StringTools.replace(text, "**", "@<**>@");
		text = StringTools.replace(text, "//", "@<//>@");
		text = StringTools.replace(text, "__", "@<__>@");
		text = StringTools.replace(text, "^^", "@<^^>@");
		text = StringTools.replace(text, ",,", "@<,,>@");
		text = StringTools.replace(text, "--", "@<-->@");
		text = StringTools.replace(text, "==", "@<==>@");
		text = StringTools.replace(text, "<<", "@<&#60;&#60;>@");
		text = StringTools.replace(text, ">>", "@<&#62;&#62;>@");
		text = StringTools.replace(text, "...", "@<...>@");
		return text;
	}
}