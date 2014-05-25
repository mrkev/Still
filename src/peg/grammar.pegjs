/*
 * Grammar and AST generator for Netword. Draft 1.
 * For use with PEG.js.
 */

{
	/**
	 * Parses an array of digits into an integer. 
	 * @param  {[type]} str Array of strings representing 
	 *                      the digits of the number
	 * @return {[type]}     The integer value of the parsed
	 *                      array of strings.
	 */
	function pnum (str) {
		return parseInt(str.join(""), 10);
	}

	/**
	 * Concatenates an array of strings into a string object.
	 * @param  {[type]} str [description]
	 * @return {[type]}     [description]
	 */
	function pstr (str) {
		return str.join("");
	}

	function ptype (type) {
		switch (type) {
			case "#": return 0; break;
			case ".": return 1; break;
			case "-": return 2; break;
			case "/": return 3; break;
			case "<": return 4; break;
			case ">": return 5; break;

		return -1;
		}
	}

	function pprop(p1, prest) {
		if (!prest) prest = []
		prest.unshift(p1);
		return prest;
	}

	function flatten (arr) {
		return arr.reduce(function (prev, curr) {
			return prev.concat(curr.constructor === Array ? flatten(curr) : curr);
		}, []);
	}

	function pdict (key, value) {
		var d = {};
		d[key] = value;
		return d;
	}

	function clean (array, element) {
		for(var i = array.length-1; i>0; i--){
		   if (array[i] == element) array.splice(i,1);
		}
	}
}






graph 
	= expr
	/ (expr "\n")*						

expr 
	= term *

term 
	= t:type i:id? p:properties?				{return {type : ptype(t), id : i, properties : p}}

type 
	= "#" / "." / "-" / "/" / "<" / ">"

properties 
	= "(" p1:property p:("," property)* ")" 	{return pprop(p1, clean(flatten(p)), ","); }

property 
	= k: variable_name "=" v:value 				{return pdict(k, v);}

value 
	= num: number 								{return num}
	/ ('"' str:string '"')						{return str}

id 
	= chars:[a-zA-Z0-9$_]+							{ return pstr(chars);  }

variable_name 
	= chars: ([a-zA-Z_$][a-zA-Z0-9$_]*)			{ return pstr(flatten(chars)); }

number 
	= digits:[0-9]+ 							{ return pnum(digits); }

string 
	= chars:[^\"]* 								{ return pstr(chars);  }
