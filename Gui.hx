package com.newprogrammer.codehighlight;

import js.html.Document;
import js.html.Element;
import js.html.FormElement;
import js.html.InputElement;
import js.html.TextAreaElement;

import haxe.Json;

import com.newprogrammer.codehighlight.parser.LanguageRules;

class Gui {
//  IDs
	public static inline var MESSAGE_WELCOME = "welcome";
	public static inline var MESSAGE_SUCCESS = "success";
	public static inline var MESSAGE_ERROR   = "error";
	
	public static inline var CODE_TEXTAREA  = "code";
	public static inline var CODE_TYPENAMES = "typenames";
	public static inline var CODE_LINKS     = "links";
	
	public static inline var OPTION_TYPENAMES = "typenames";
	public static inline var OPTION_LINES     = "lines";
	public static inline var OPTION_LINKS     = "links";
	public static inline var OPTION_FORMAT    = "format";
	
	public static inline var ACTION_UNPARSE   = "unparse";
	public static inline var ACTION_TYPENAMES = "typenames";
	public static inline var ACTION_LINKS     = "links";
	public static inline var ACTION_RESET     = "reset";
	
	public static inline var LANGUAGE_FILE = "codehighlight_languages.json";
	
//  Private properties
	private var codeHighlight:CodeHighlight;
	private var doc:Document;
	
	private var messages:Map<String, Element>;
	private var textareas:Map<String, TextAreaElement>;
	private var options:Map<String, InputElement>;
	
	private var messageDelay:Int;
	
	public function new(codeHighlight:CodeHighlight, doc:Document) {
		this.codeHighlight = codeHighlight;
		this.doc = doc;
		this.messages = new Map<String, Element>();
		this.textareas = new Map<String, TextAreaElement>();
		this.options = new Map<String, InputElement>();
	}
	
	/*  Public Methods
	=========================================================================*/
/**
 *  Generates the HTML for the CodeHighlight App
 */
	public function render():Void {
		var container = constructElement("container", "container");
		var messageArea = constructElement("message-area");
		var formArea = constructElement("form-area");
		var footer = constructElement("footer");
		var footerP = doc.createParagraphElement();
		footerP.innerHTML = "Copyright Timothy Foster 2015";
		
	//	var noscript = doc.createElement("noscript");
		
		var form = constructForm();
		
		doc.body.appendChild(container);
		  container.appendChild(messageArea);
		    messageArea.appendChild(constructMessage(MESSAGE_WELCOME, "info", "Welcome to code.highlight()! ", "This widget will allow you to convert source code into Wikidot-readable code for new Programmer();. Simply paste your code in the box labeled \"Code\" and click on the button of the appropriate language.  Once the code has been process, simply copy what is in the code box and paste it into your web post!", false));
			messageArea.appendChild(constructMessage(MESSAGE_SUCCESS, "success", "Success! ", "Simply copy what is in the code box and paste it into your post."));
			messageArea.appendChild(constructMessage(MESSAGE_ERROR, "danger", "Error: ", "An unknown error has occurred."));
		  container.appendChild(formArea);
		    formArea.appendChild(form);
		  container.appendChild(footer);
		    footer.appendChild(footerP);
	}
	
	public inline function getCodeInput():String {
		return textareas[CODE_TEXTAREA].value;
	}
	public inline function setCodeOutput(value:String):Void {
		textareas[CODE_TEXTAREA].value = value;
	}
	
	public inline function getTypenamesInput():String {
		return textareas[CODE_TYPENAMES].value;
	}
	
	public inline function isOptionChecked(option:String):Bool {
		return options[option].checked;
	}
	
	public function displayWelcome():Void {
		this.messages[MESSAGE_WELCOME].classList.remove("hide");
		this.messages[MESSAGE_ERROR].classList.add("hide");
		this.messages[MESSAGE_SUCCESS].classList.add("hide");
		doc.defaultView.clearInterval(this.messageDelay);
	}
	
	public function displaySuccess():Void {
		doc.defaultView.clearInterval(this.messageDelay);
		this.messages[MESSAGE_WELCOME].classList.add("hide");
		this.messages[MESSAGE_ERROR].classList.add("hide");
		this.messages[MESSAGE_SUCCESS].classList.remove("hide");
		this.messageDelay = doc.defaultView.setInterval(displayWelcome, 4000);
	}
	
	public function displayError(msg:String):Void {
		doc.defaultView.clearInterval(this.messageDelay);
		this.messages[MESSAGE_WELCOME].classList.add("hide");
		this.messages[MESSAGE_ERROR].classList.remove("hide");
		this.messages[MESSAGE_SUCCESS].classList.add("hide");
		this.messages[MESSAGE_ERROR].getElementsByClassName("message-message").item(0).textContent = msg;
	}
	
	public function toggleTypenameEditor() {
		if (doc.getElementById("input-area-" + CODE_TYPENAMES).classList.contains("collapsed"))
			expandTypenameEditor();
		else
			collapseTypenameEditor();
	}
	
	public function toggleLinksEditor() {
		if (doc.getElementById("input-area-" + CODE_LINKS).classList.contains("collapsed"))
			expandLinksEditor();
		else
			collapseLinksEditor();
	}
	
	public function reset():Void {
		for (textarea in this.textareas) {
			textarea.value = "";
		}
	}
	
	/*  Private Methods
	=========================================================================*/
	private function expandTypenameEditor():Void {
		collapseLinksEditor();
		collapseCodeEditor();
		doc.getElementById("input-area-" + CODE_TYPENAMES).classList.remove("collapsed");
		var typenameBtn = doc.getElementById("action-" + ACTION_TYPENAMES);
		typenameBtn.classList.remove("btn-info");
		typenameBtn.classList.add("btn-primary");
	}
	
	private function collapseTypenameEditor():Void {
		expandCodeEditor();
		doc.getElementById("input-area-" + CODE_TYPENAMES).classList.add("collapsed");
		var typenameBtn = doc.getElementById("action-" + ACTION_TYPENAMES);
		typenameBtn.classList.add("btn-info");
		typenameBtn.classList.remove("btn-primary");
	}
	
	private inline function expandCodeEditor():Void {
		doc.getElementById("input-area-" + CODE_TEXTAREA).classList.remove("collapsed");
	}
	
	private inline function collapseCodeEditor():Void {
		doc.getElementById("input-area-" + CODE_TEXTAREA).classList.add("collapsed");
	}
	
	private function expandLinksEditor():Void {
		collapseTypenameEditor();
		collapseCodeEditor();
		doc.getElementById("input-area-" + CODE_LINKS).classList.remove("collapsed");
		var linksBtn = doc.getElementById("action-" + ACTION_LINKS);
		linksBtn.classList.remove("btn-info");
		linksBtn.classList.add("btn-primary");
	}
	
	private function collapseLinksEditor():Void {
		expandCodeEditor();
		doc.getElementById("input-area-" + CODE_LINKS).classList.add("collapsed");
		var linksBtn = doc.getElementById("action-" + ACTION_LINKS);
		linksBtn.classList.add("btn-info");
		linksBtn.classList.remove("btn-primary");
	}
	
	/*  Construction Methods
	=========================================================================*/
	private function constructElement(id:String, className:String = "", elementType:String = "div"):Element {
		var elem = doc.createElement(elementType);
		elem.id = id;
		elem.className = className;
		return elem;
	}
	
	private function constructForm():FormElement {
		var form = doc.createFormElement();
		form.name = "io";
		
		var inputArea = constructElement("input-area");
		inputArea.appendChild(constructTextarea(CODE_TEXTAREA, "main", "Code"));
		inputArea.appendChild(constructTextarea(CODE_TYPENAMES, "collapsed aux", "Typenames"));
		inputArea.appendChild(constructTextarea(CODE_LINKS, "collapsed aux", "Links"));
		
		var optionArea = constructElement("option-area");
		optionArea.appendChild(constructOption(OPTION_TYPENAMES, "Attempt to find user-defined types automatically", true));
		optionArea.appendChild(constructOption(OPTION_LINES, "Automatically add line numbers", true));
		optionArea.appendChild(constructOption(OPTION_LINKS, "Automatically link known types"));
		optionArea.appendChild(constructOption(OPTION_FORMAT, "Output for HTML instead of Wikidot"));
		
	//  Language data is loaded from a JSON file.  Therefore, adding a new language 
	//  is as simple as editing the JSON file and uploading the language JSON file.
		var languageArea = constructElement("language-area", "btn-group");
		CodeHighlight.loadFile(LANGUAGE_FILE, function(raw:String):Void {
			var data:Array<LanguageElement> = Json.parse(raw);
			for (lang in data)
				languageArea.appendChild(constructLanguageButton(lang));
		});
		
		var actionArea = constructElement("action-area", "btn-group");
		actionArea.appendChild(constructActionButton(ACTION_UNPARSE, "warning", "Unparse", null));
		actionArea.appendChild(constructActionButton(ACTION_TYPENAMES, "info", "Define Typenames", function(e:Dynamic):Void {  toggleTypenameEditor(); }));
		actionArea.appendChild(constructActionButton(ACTION_LINKS, "info", "Define Links", function(e:Dynamic):Void {  toggleLinksEditor(); }));
		actionArea.appendChild(constructActionButton(ACTION_RESET, "danger", "Reset", function(e:Dynamic):Void {  reset(); } ));
		
		form.appendChild(inputArea);
		form.appendChild(optionArea);
		form.appendChild(languageArea);
		form.appendChild(actionArea);
		
		return form;
	}
	
	private function constructMessage(name:String, type:String, title:String, message:String, hidden:Bool = true):Element {
		var messageContainer = constructElement('message-$name', 'alert alert-$type');
		if (hidden)
			messageContainer.classList.add("hide");
			
		var messageParagraph = constructElement("", "", "p");
		var messageTitle = constructElement('message-$name-title', "message-title", "strong");
		var messageSpan = constructElement('message-$name-message', "message-message", "span");
		messageTitle.innerHTML = title;
		messageSpan.innerHTML = message;
		
		messageContainer.appendChild(messageParagraph);
		  messageParagraph.appendChild(messageTitle);
		  messageParagraph.appendChild(messageSpan);
		
		this.messages[name] = messageContainer;
		
		return messageContainer;
	}
	
	private function constructTextarea(name:String, classes:String, title:String):Element {
		var textareaContainer = constructElement('input-area-$name', 'input-area-element $classes');
		
		var textareaTitle = constructElement("", "input-area-title");
		var textareaTitleInner = doc.createSpanElement();
		textareaTitleInner.innerHTML = '$title:';
		textareaTitle.appendChild(textareaTitleInner);
		
		var textareaContainerInner = constructElement("", "input-area-textarea");
		var textarea = doc.createTextAreaElement();
		textarea.id = 'textarea-$name';
		textarea.name = textarea.id;
		textarea.rows = 20;
		textareaContainerInner.appendChild(textarea);
		
		textareaContainer.appendChild(textareaTitle);
		textareaContainer.appendChild(textareaContainerInner);
		
		this.textareas[name] = textarea;
		
		return textareaContainer;
	}
	
	private function constructOption(name:String, text:String, checked:Bool = false):Element {
		var optionContainer = constructElement("", "option");
		var optionInput = doc.createInputElement();
		var optionText = doc.createSpanElement();
		
		optionInput.id = "option-" + name;
		optionInput.name = "option-" + name;
		optionInput.type = "checkbox";
		optionInput.checked = checked;
		this.options[name] = optionInput;
		
		optionText.innerHTML = text;
		optionContainer.appendChild(optionInput);
		optionContainer.appendChild(optionText);
		
		return optionContainer;
	}
	
	private function constructLanguageButton(language:LanguageElement):Element {
		var btn = doc.createInputElement();
		btn.id = "language-" + language.id;
		btn.name = btn.id;
		btn.type = "button";
		btn.value = language.text;
		btn.className = "btn btn-" + language.id;
		btn.onclick = function(e:Dynamic):Void {
			codeHighlight.highlight(language.id);
		};
		
		return btn;
	}
	
	private function constructActionButton(name:String, type:String, title:String, action:Dynamic->Void):InputElement {
		var btn = doc.createInputElement();
		btn.id = 'action-$name';
		btn.name = btn.id;
		btn.className = 'btn btn-$type';
		btn.type = "button";
		btn.value = title;
		btn.onclick = action;
		
		return btn;
	}
}

/*  Helper Structures
=============================================================================*/
private typedef LanguageElement = {
	var id:String;
	var text:String;
}