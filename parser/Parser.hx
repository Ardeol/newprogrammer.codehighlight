package com.newprogrammer.codehighlight.parser;

/** Parser Class
 *  @author		Timothy Foster
 * 	@version	0.00.141230
 ** Wrapper for the parse() method.  parse() will take an input string and transform it
 *  according to the rules of the given language and productions.
 */
class Parser {
/**
 *  Highlights code according to a language into a provided format
 *  @param	code	The code to highlight using the provided production rules
 *  @param	language	The programming language to highlight for
 *  @param	format	Rules governing the format of the output
 */
	public static function parse(code:String, language:LanguageRules, productions:ProductionRules):String {
		var input = code;
		var output = new StringBuf();
		while (input.length > 0)
			input = parseToken(input, output, language.tokens, productions);
		return output.toString();
	}
	
	private static function parseToken(input:String, output:StringBuf, tokenRules:Array<TokenRule>, productions:ProductionRules):String {
	/*  This recursive method will repeatedly parse tokens until there is nothing left
	 *  to parse or until a null/0-length token array is encountered.
	 *  This method modifies the output StringBuf and returns the String to parse next (the next input)
	 */
		var token:String = "";
		var nextInput:String = "";
		for (tokenRule in tokenRules) {
		//  Order matters!  More specific rules should be first.
			token = tokenRule.match(input);
			if (token.length > 0) {
				nextInput = input.substr(token.length);
				if (tokenRule.tokens != null && tokenRule.tokens.length > 0) {
				//  Allows for the embedding of tokens, in the case that tokens can be inside other tokens
					var tokenOut = new StringBuf();
					while (token.length > 0)
						token = parseToken(token, tokenOut, tokenRule.tokens, productions);
					token = tokenOut.toString();
				}
				output.add(productions.produce(tokenRule.type, token));
				break;
			}
		}
		
		if (token.length == 0) {
		//  If none of the rules matched, read a single character
			token = input.charAt(0);
			nextInput = input.substr(1);
			output.add(token);
		}
	//  The String to parse next.  The output is a StringBuf, so it is remembered throughout
		return nextInput;
	}
}