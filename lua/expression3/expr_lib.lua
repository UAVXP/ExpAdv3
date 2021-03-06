--[[
	   ____      _  _      ___    ___       ____      ___      ___     __     ____      _  _          _        ___     _  _       ____   
	  F ___J    FJ  LJ    F _ ", F _ ",    F ___J    F __".   F __".   FJ    F __ ]    F L L]        /.\      F __".  FJ  L]     F___ J  
	 J |___:    J \/ F   J `-' |J `-'(|   J |___:   J (___|  J (___|  J  L  J |--| L  J   \| L      //_\\    J |--\ LJ |  | L    `-__| L 
	 | _____|   /    \   |  __/F|  _  L   | _____|  J\___ \  J\___ \  |  |  | |  | |  | |\   |     / ___ \   | |  J |J J  F L     |__  ( 
	 F L____:  /  /\  \  F |__/ F |_\  L  F L____: .--___) \.--___) \ F  J  F L__J J  F L\\  J    / L___J \  F L__J |J\ \/ /F  .-____] J 
	J________LJ__//\\__LJ__|   J__| \\__LJ________LJ\______JJ\______JJ____LJ\______/FJ__L \\__L  J__L   J__LJ______/F \\__//   J\______/F
	|________||__/  \__||__L   |__|  J__||________| J______F J______F|____| J______F |__L  J__|  |__L   J__||______F   \__/     J______F 
	
	::Expression Advanced 3 Library::
	`````````````````````````````````
		Some operators, methods and functions can return more then one value of the same type at once.
		You need to tell the compiler how many results it returns even if that is 0.
		Parameters should always be class id's separated by a comma (,); e.g "n,n,s".
		All documentation below is to be considered work in progress and this api will more then likely change.
	
	::HOOKS::
		Expression3.RegisterExtenstions					-> Called when extensions should be registered.
		Expression3.LoadClasses							-> Classes must be registered inside this hook.
		Expression3.LoadConstructors					-> Constructors must be registered inside this hook.
		Expression3.LoadMethods							-> Methods must be registered inside this hook.
		Expression3.LoadMethods							-> Methods must be registered inside this hook.
		Expression3.LoadAtributes						-> Atributes must be registered inside this hook.
		Expression3.LoadLibraries						-> Libraries must be registered inside this hook.
		Expression3.LoadFunctions						-> Functions must be registered inside this hook.
		Expression3.PostRegisterExtenstions				-> This is called once expadv3 has loaded its extensions.
		Expression3.PostCompile.System.<function>		-> This is called after compiling every function on the system library,		-> ressult class, result count = (comiler, instruction, token, expressions)
												  		   (replace <function> with the name of the function on the library..		
		Expression3.Entity.BuildSandbox					-> This is called when building the sandboxed enviroment for an entity.		-> (entity, context, enviroment)
		Expression3.Start.Entity						-> This is called when an entity is about to run for the first time.		-> (entity, context)
		Expression3.Entity.Think						-> Called by all expression 3 entitys during the entitys think function 	-> (entity, context)
		Expression3.Entity.Update						-> This is called when an entity has sucessfuly executed.					-> (entity, context)
		Expression3.Entity.Stop							-> This is called when an entity has shutdown for any given reason.			-> (entity, context)
		Expression3.GolemInit							-> this is called when the editor is created.
		Expression3.OpenGolem							-> this is called when the editor opens.
		Expression3.CloseGolem							-> this is called when the editor closes.
		Expression3.AddGolemTabTypes					-> This is called when custom tab types should be registered on the editor. -> (Editor)
		Expression3.LoadWiki							-> This is called when its time to register the helpers to the wiki.

		
	::IMPORTANT::
		You should use 'Extension = EXPR_LIB.RegisterExtenstion(string)' to create a new Extension object.
		You should then use the api methods on the new Extension to register everything.
		Doing it this way means you do not need to add the hooks yourself as the extension will load the contents at the correct time.
		Do not forget to call Extension:EnableExtenstion() once your done otherwise the extension will not load itself.
		It is possible to register an extension outside the extension folder by creating it inside Expression3.RegisterExtenstions hook.
		
	::RULES::
		A constructor's function can be a string, if so the compiler will attempt to use a native lua function at the given string; e.g string.replace.
		The first parameter to a constructor's function will always be context unless exclude context is true;
		Some operator's and casting operator's function is optional, if not given the compiler will attempt to use lua's native method.
		The first parameter to an operator / casting operator function will always be context unless exclude context is true;
		A method's function can be a string, if so the compiler will attempt to use a native lua method on that object.
		The first parameter to a method's function will always be context unless exclude context is true;
		NO LONGER SUPPORTED: A function's function can be a string, if so the compiler will attempt to use a native lua function at the given string; e.g string.replace.
		The first parameter to a function's function will always be context unless exclude context is true;
	
	::Examples::
		Using a string as an operation.
		Operator: 	extension:RegisterConstructor("v", "n,n,n", "Vector", true);
		Input:		new vector(1,2,3);
		OutPut:		Vector(1,2,3);
		
		Using a function as operation with context.
		Operator: 	extension:RegisterConstructor("v", "n,n,n", function(c,x,y,z) end, false);
		Input:		new vector(1,2,3);
		OutPut:		_Ops["v(n,n,n)"](context, 1,2,3);
		
		using a function as operation with out context.
		Operator: 	extension:RegisterConstructor("v", "n,n,n", function(x,y,z) end, true);
		Input:		new vector(1,2,3);
		OutPut:		_Ops["v(n,n,n)"](1,2,3);

	::EXPR_LIB::
		EXPR_LIB.RegisterClass(string short name, string class name, string class boolean = function(object) isType, boolean = function(object) isValid)
			Registers a new class with expression 3.
		
		EXPR_LIB.RegisterExtendedClass(string short name, string class name, string base class name, boolean = function(object) isType, boolean = function(object) isValid)
			Registers a new class based of an existing class.

		EXPR_LIB.RegisterConstructor(str class, str parameters, obj = function(ctx, ...) constructor, boolean exclude context)
			Registers a constructor for class with expression 3; new vector(1, 2, 3)

		EXPR_LIB.RegisterMethod(class, str name, str parameters, str type, number amount of values returned, (obj = function(ctx*, ...) method / string)*, boolean exclude context)
			Registers a method with expression 3 on class;
			if operator is a string then it will use the method str on object with out context as a parameter.

		EXPR_LIB.RegisterAtribute(class, str name, str type, string native feild)
			Adds an atribute to a class, this does not take an operator or a function.
				-> E3)Var.Atribute = Value :: Lua)Var.Feild = Value

		EXPR_LIB.RegisterOperator(str operation, str parameters, str type, number amount of values returned, obj = function(ctx*, ...) operator*, boolean exclude context)
			Registers an operator with expression 3;
			if operator is nil then it will use the native operator on object.
		
		::OPERATORS::
			This list will expand as time goes on and more are added.
			
			and		(type1, type2)			type1 && type2
			or		(type1, type2)			type1 || type2
			add		(type1, type2)			type1 + type2
			sub		(type1, type2)			type1 - type2
			div		(type1, type2)			type1 / type2
			mul		(type1, type2)			type1 * type2
			exp		(type1, type2)			type1 ^ type2
			mod		(type1, type2)			type1 % type2
			ten		(type1, type2, type3)	type1 ? type2 : type3
			or		(type1, type2)			type1 || type2
			and		(type1, type2)			type1 && type2
			bxor	(type1, type2)			type1 ^^ type2
			bor		(type1, type2)			type1 | type2
			band	(type1, type2) 			type1 & type2
			eq*		(type1, ...)			type1 == [...]
			neq		(type1, type2)			type1 != type2
			eq		(type1, type2)			type1 == type2
			neq*	(type1, ...)			type1 != [...]
			lth		(type1, type2)			type1 < type2
			leg		(type1, type2)			type1 <= type2
			gth		(type1, type2)			type1 > type2
			geq		(type1, type2)			type1 >= type2
			bshl	(type1, type2)			type1 << type2
			bshr	(type1, type2)			type1 >> type2
			neg		(type1)					-type1
			not		(type1)					!type1
			len		(type1)					#type1
			call 	(type1, ...)			type(...)

		EXPR_LIB.RegisterCastingOperator(str type, str parameter, obj = function(ctx*, ...) operator, boolean exclude context)
			Registers a casting operator with expression 3 for casting from one class to another;
			type1(type2)					type1 = (type1) type2

		EXPR_LIB.RegisterLibrary(name)
			Registers a new library with expression 3.
			Every function must part of a library.

		EXPR_LIB.RegisterFunction(str library, str name, str parameters, str type, number amount of values returned, (obj = function(ctx, ...) / str) function, boolean exclude context)
			Registers a function with library, these functions are overloaded.
			NO LONGER SUPPORTED: If function is a string then expression 3 will use _G[str function]() with out context as a parameter.

		REMOVED: EXPR_LIB.RegisterEvent(str name, str parameters, str type, number amount of values returned)
			Registers an event with expression 3.

		EXPR_LIB.GetClass(str class)

		EXPR_LIB.RegisterExtenstion(str name)
			Returns and registers a new extension with expression 3;
			This will allow you to add to the api with out manually using the required events.
	
	::Extension::
		Extension:RegisterClass(string short name, string class name, boolean = function(object) isType, boolean = function(object) isValid)
			Calls EXPR_LIB.RegisterClass(...) at the correct time with all given valid parameter.
		
		Extension:RegisterExtendedClass(string short name, string class name, string base class name, boolean = function(object) isType, boolean = function(object) isValid)
			Calls EXPR_LIB.RegisterExtendedClass(...) at the correct time with all given valid parameter.

		Extension.RegisterConstructorRegisterConstructor(str class, str parameters, obj = function(ctx*, ...) constructor, boolean exclude context)
			Calls EXPR_LIB.RegisterConstructorRegisterConstructor(...) at the correct time with all given valid parameters.

		Extension:RegisterMethod(class, str name, str parameters, str type, number amount of values returned, (obj = function(ctx*, ...) method) / string*, boolean exclude context)
			Calls EXPR_LIB.RegisterMethod(...) at the correct time with all given valid parameters.
		
		Extension:RegisterAtribute(class, str name, str type, string native feild)
			Calls EXPR_LIB.RegisterAtribute(...) at the correct time with all given valid parameters.
		
		Extension:RegisterOperator(str operation, str parameters, str type, number amount of values returned, obj = function(ctx*, ...) operator*, boolean exclude context)
			Calls EXPR_LIB.RegisterOperator(...) at the correct time with all given valid parameters.

		Extension:RegisterCastingOperator(str type, str parameter, obj = function(ctx, ...) operator, boolean exclude context)
			Calls EXPR_LIB.RegisterCastingOperator(...) at the correct time with all given valid parameters.

		Extension:RegisterLibrary(name)
			Calls EXPR_LIB.RegisterLibrary(...) at the correct time with all given valid parameters.

		Extension:RegisterFunction(str library, str name, str parameters, str type, number amount of values returned, (obj = function(ctx*, ...)) function, boolean exclude context)
			Calls EXPR_LIB.RegisterFunction(...) at the correct time with all given valid parameters.

		REMOVED: Extension:RegisterEvent(str name, str parameters, str type, number amount of values returned)
			Calls EXPR_LIB.RegisterEvent(...) at the correct time with all given valid parameters.

		Extension:EnableExtenstion()
			Must be called to allow the extension to register its contents.
		
	::Editor Extention::
		Extension.RegisterEditorMenu(str name, str icon, panel function(panel editor), function(panel editor, panel tab, boolean save))
			CLIENTSIDE ONLY: Used to add a new tab to the lefthand menu with its own menu icon to open it.
			The first function (arg #3) is called when the tab is created for the first time. The panel returned is used as the tabs main panel.
			The second function (arg #4) is called when the tab is closed.

	::WIKI::
		EXPR_WIKI.RegisterConstructor(str class, str parameter, str html)
			Creates a wiki section for this constructor.

		EXPR_WIKI.RegisterMethod(str class, str name, str parameter, str html)
			Creates a wiki section for this method.

		EXPR_WIKI.RegisterFunction(str library, str name, str parameter, str html)
			Creates a wiki section for this function.

		EXPR_WIKI.RegisterPage(str title, str catagory, str html)
			Creates a new wiki page.

]]

EXPR_LIB = {};

--[[
]]

print("E3 Lib Loading.");

if (not CLIENT) then
	print("Adding E3 message names.");

	util.AddNetworkString("Expression3.SubmitToServer");

	util.AddNetworkString("Expression3.RequestUpload");

	util.AddNetworkString("Expression3.SendToClient");
end

--[[
]]

function EXPR_LIB.ThrowInternal(level, msg, fst, ...)
	if (fst) then
		msg = string.format(msg, fst, ...);
	end

	error(msg, level);
end

--[[
]]

local classes;
local classIDs;
local loadClasses = false;

--[[

]]

local STATE = 1;

EXPR_SERVER = 0;
EXPR_SHARED = 1;
EXPR_CLIENT = 2;

function EXPR_LIB.SetServerState()
	STATE = EXPR_SERVER;
end

function EXPR_LIB.SetSharedState()
	STATE = EXPR_SHARED;
end

function EXPR_LIB.SetClientState()
	STATE = EXPR_CLIENT;
end

--[[
]]

function EXPR_LIB.RegisterClass(id, name, isType, isValid)
	if (not loadClasses) then
		EXPR_LIB.ThrowInternal(0, "Attempt to register class %s outside of Hook::Expression3.LoadClasses }}", name);
	end

	if (string.len(id) > 1) then
		id = "_" .. id;
	end

	if (classIDs[id]) then
		EXPR_LIB.ThrowInternal(0, "Attempt to register class %s with conflicting id %s", name, id);
	end

	local class = {};

	if (type(name) == "table") then
		-- Register aliases for classes.
		for _, v in pairs(name) do
			classes[string.lower(v)] = class;
		end

		name = name[1];
	end

	class.id = string.lower(id);
	class.name = string.lower(name);
	class.base = "o";
	class.state = STATE;

	class.isType = isType;
	class.isValid = isValid;
	
	class.atributes = {};
	class.constructors = {};

	classIDs[class.id] = class;
	classes[class.name] = class;

	MsgN("Registered Class: ", class.id, " - ", class.name);

	return class;
end

function EXPR_LIB.RegisterExtendedClass(id, name, base, isType, isValid)
	if (not loadClasses) then
		EXPR_LIB.ThrowInternal(0, "Attempt to register class %s outside of Hook::Expression3.LoadClasses", name);
	end

	local cls = EXPR_LIB.GetClass(base);

	if (not cls) then
		EXPR_LIB.ThrowInternal(0, "Attempt to register extended class %s for none existing class", class, base);
	end

	local class = EXPR_LIB.RegisterClass(id, name, isType, isValid);

	class.base = cls.id;

	return class;
end

function EXPR_LIB.RegisterWiredInport(class, wiretype, func)
	local cls = EXPR_LIB.GetClass(class);

	if (not cls) then
		EXPR_LIB.ThrowInternal(0, "Attempt to register wired inport for none existing class %s", class);
	end

	if (SERVER) then
		if (not WireLib.DT[wiretype]) then
			EXPR_LIB.ThrowInternal(0, "Attempt to register wired inport for class %s, with invalid wire type %s", class, wiretype);
		end
	end

	cls.wire_out_func = func;
	cls.wire_out_class = wiretype;
end

function EXPR_LIB.RegisterWiredOutport(class, wiretype, func)
	local cls = EXPR_LIB.GetClass(class);

	if (not cls) then
		EXPR_LIB.ThrowInternal(0, "Attempt to register wired outport for none existing class %s", class);
	end

	if (SERVER) then
		if (not WireLib.DT[wiretype]) then
			EXPR_LIB.ThrowInternal(0, "Attempt to register wired outport for class %s, with invalid wire type %s", class, wiretype);
		end
	end

	cls.wire_in_func = func;
	cls.wire_in_class = wiretype;
end

local loadConstructors = false;

function EXPR_LIB.RegisterConstructor(class, parameter, constructor, excludeContext)
	if (not loadConstructors) then
		EXPR_LIB.ThrowInternal(0, "Attempt to register Constructor new %s(%s) outside of Hook::Expression3.LoadConstructors", class, parameter);
	end

	local cls = EXPR_LIB.GetClass(class);

	if (not cls) then
		EXPR_LIB.ThrowInternal(0, "Attempt to register Constructor new %s(%s) for none existing class", class, parameter);
	end

	local state, signature = EXPR_LIB.SortArgs(parameter);

	if (not state) then
		EXPR_LIB.ThrowInternal(0, "%s for Constructor new %s(%s)", signature, class, parameter);
	end

	local op = {};
	op.name = name;
	op.class = cls.id;
	op.state = STATE;
	op.parameter = signature;
	op.signature = string.format("%s(%s)", cls.id, signature);
	op.result = cls.id;
	op.rCount = count;
	op.operator = constructor;
	op.context = not excludeContext;

	cls.constructors[op.signature] = op;

	return op;
end

local methods;
local loadMethods = false;

function EXPR_LIB.RegisterMethod(class, name, parameter, type, count, method, excludeContext)
	-- if method is nil lua, compiler will use native Object:(...);

	if (not loadMethods) then
		EXPR_LIB.ThrowInternal(0, "Attempt to register method %s.%s(%s) outside of Hook::Expression3.LoadMethods", class, name, parameter);
	end

	local cls = EXPR_LIB.GetClass(class);

	if (not cls) then
		EXPR_LIB.ThrowInternal(0, "Attempt to register method %s.%s(%s) for none existing class %s", class, name, parameter, class);
	end

	local state, signature = EXPR_LIB.SortArgs(parameter);

	if (not state) then
		EXPR_LIB.ThrowInternal(0, "%s for method %s.%s(%s)", signature, class, name, parameter);
	end

	local res = EXPR_LIB.GetClass(type);

	if (not res) then
		EXPR_LIB.ThrowInternal(0, "Attempt to register method %s.%s(%s) with none existing return class %s", class, name, parameter, type);
	end

	local meth = {};
	meth.name = name;
	meth.class = cls.id;
	meth.state = STATE;
	meth.parameter = signature;
	meth.signature = string.format("%s.%s(%s)", cls.id, name, signature);
	meth.result = res.id;
	meth.rCount = count;
	meth.operator = method;
	meth.context = not excludeContext;

	methods[meth.signature] = meth;
	-- <Insert Heisenburg joke here>

	return meth;
end

local loadAtributes;

function EXPR_LIB.RegisterAtribute(class, atribute, type, native)
	native = native or atribute;

	if (not loadAtributes) then
		EXPR_LIB.ThrowInternal(0, "Attempt to register atribute %s.%s outside of Hook::Expression3.LoadAtributes", class, atribute);
	end

	local cls = EXPR_LIB.GetClass(class);

	if (not cls) then
		EXPR_LIB.ThrowInternal(0, "Attempt to register atribute %s.%s for none existing class %s", class, atribute, class);
	end

	local typ = EXPR_LIB.GetClass(type);

	if (not typ) then
		EXPR_LIB.ThrowInternal(0, "Attempt to register atribute %s.%s of none existing class %s", class, atribute, type);
	end

	local atr = {};
	atr.feild = feild;
	atr.class = typ.id;
	atr.atribute = atribute;

	cls.atributes[atribute] = atr;

	MsgN("Registered atribute: ", class .. "." .. atribute);

	return atr;
end
	
local operators;
local loadOperators = false;

function EXPR_LIB.RegisterOperator(operation, parameter, type, count, operator, excludeContext)
	-- if operator is nil lua, compiler will use native if possible (+, -, /, *, ^, etc)

	if (not loadOperators) then
		EXPR_LIB.ThrowInternal(0, "Attempt to register operator %s(%s) outside of Hook::Expression3.LoadOperators", operation, parameter);
	end

	local state, signature = EXPR_LIB.SortArgs(parameter);

	if (not state) then
		EXPR_LIB.ThrowInternal(0, "%s for operator %s(%s)", signature, operation, parameter);
	end

	local res = EXPR_LIB.GetClass(type);

	if (not res) then
		EXPR_LIB.ThrowInternal(0, "Attempt to register operator %s(%s) with none existing return class %s", operation, parameter, type);
	end

	local op = {};
	op.name = operation;
	op.state = STATE;
	op.parameter = signature;
	op.signature = string.format("%s(%s)", operation, signature);
	op.result = res.id;
	op.rCount = count;
	op.operator = operator;
	op.context = not excludeContext;
	op.operation = operation;
	
	operators[op.signature] = op;

	return op;
end

local castOperators;

function EXPR_LIB.RegisterCastingOperator(type, parameter, operator, excludeContext)
	if (not loadOperators) then
		EXPR_LIB.ThrowInternal(0, "Attempt to register casting operator [(%s) %s] outside of Hook::Expression3.LoadOperators", type, parameter);
	end

	if (not operator) then
		EXPR_LIB.ThrowInternal(0, "Attempt to register native casting operator [(%s) %s] an operation function is required.", type, parameter);
	end

	local state, signature = EXPR_LIB.SortArgs(parameter);

	if (not state) then
		EXPR_LIB.ThrowInternal(0, "%s for casting operator [(%s) %s]", signature, type, parameter);
	end

	local res = EXPR_LIB.GetClass(type);

	if (not res) then
		EXPR_LIB.ThrowInternal(0, "Attempt to register casting operator [(%s) %s] for none existing class %s", type, parameter, type);
	end

	local op = {};
	op.parameter = signature;
	op.state = STATE;
	op.signature = string.format("(%s)%s", type, signature);
	op.result = res.id;
	op.rCount = 1;
	op.operator = operator;
	op.context = not excludeContext;

	castOperators[op.signature] = op;

	return op;
end

local libraries;
local loadLibraries = false;

function EXPR_LIB.RegisterLibrary(name)
	if (not loadLibraries) then
		EXPR_LIB.ThrowInternal(0, "Attempt to register library %s) outside of Hook::Expression3.LoadLibariess", name);
	end

	local lib = {};
	lib.name = string.lower(name);
	lib._functions = {};
	lib.constants = {}; -- Future implementation.

	libraries[lib.name] = lib;

	MsgN("Registered library: ", lib.name);
end

local functions;
local loadFunctions = false;
local blank = function() end

function EXPR_LIB.RegisterFunction(library, name, parameter, type, count, _function, excludeContext)
	if (not loadFunctions) then
		EXPR_LIB.ThrowInternal(0, "Attempt to register function %s.%s(%s) outside of Hook::Expression3.LoadFunctions", library, name, parameter);
	end

	local lib = libraries[string.lower(library)];

	if (not lib) then
		EXPR_LIB.ThrowInternal(0, "Attempt to register function %s.%s(%s) to none existing library %s", library, name, parameter, library);
	end

	local state, signature = EXPR_LIB.SortArgs(parameter);

	if (not state) then
		EXPR_LIB.ThrowInternal(0, "%s for function %s.%s(%s)", signature, library, name, parameter);
	end

	local res = EXPR_LIB.GetClass(type);

	if (not res) then
		EXPR_LIB.ThrowInternal(0, "Attempt to register function %s.%s(%s) with none existing return class %s", library, name, parameter, type);
	end

	local op = {};
	op.name = name;
	op.state = STATE;
	op.parameter = signature;
	op.signature = string.format("%s(%s)", name, signature);
	op.result = res.id;
	op.rCount = count;
	op.operator = _function or blank;
	op.context = not excludeContext;

	lib._functions[op.signature] = op;

	MsgN("Registered function ", library, ".", op.signature);

	return op;
end

--[[
]]

function EXPR_LIB.GetAllClasses()
	local res = {};

	if ( EXPR_CLASSES ) then
		for _, v in pairs(EXPR_CLASSES) do
			res[v] = v;
		end
	end

	return res;
end

function EXPR_LIB.GetClass(class)
	if (not class or class == "") then
		class = "void";
	end

	if (classes[class]) then
		return classes[class];
	end

	if (string.len(class) > 1 and string.sub(class, 1, 1) ~= "_") then
		class = "_" .. class;
	end

	return classIDs[class];
end

function EXPR_LIB.IsValidClass(class)
	return EXPR_LIB.GetClass(class) ~= nil;
end

function EXPR_LIB.SortArgs(parameter)
	if (parameter == "") then
		return true, "";
	end

	local varg = false;
	local signature = {};
	local split = string.Explode(",", parameter);

	if (split[#split] == "...") then
		split[#split] = nil;
		varg = true;
	end

	for k, v in pairs(split) do
		local cls = EXPR_LIB.GetClass(v);

		if (v == "...") then
			return false, string.format("Vararg (...) must be last parameter", v, k);
		elseif (not cls) then
			return false, string.format("Invalid class (%s) for parameter #%i", v, k);
		end

		signature[k] = cls.id;
	end

	if (varg) then
		signature[#signature + 1] = "...";
	end

	return true, table.concat(signature, ","), varg;
end

--[[
	:::Extension Base For Loading Sainly:::
	'''''''''''''''''''''''''''''''''''''''
	Since we need to add everything in a specific order, this is a extension base that can do this for you.
]]

local Extension = {};
Extension.__index = Extension;

function EXPR_LIB.RegisterExtenstion(name)
	local ext = {};

	ext.name = name;
	ext.classes = {};
	ext.state = EXPR_SHARED;
	ext.constructors = {};
	ext.methods = {};
	ext.atributes = {};
	ext.operators = {};
	ext.castOperators = {};
	ext.libraries = {};
	ext.functions = {};
	ext.events = {};

	return setmetatable(ext, Extension);
end

function EXPR_LIB.GetExtensionMetatable()
	return Extension;
end

function Extension.SetServerState(this)
	this.state = EXPR_SERVER;
end

function Extension.SetSharedState(this)
	this.state = EXPR_SHARED;
end

function Extension.SetClientState(this)
	this.state = EXPR_CLIENT;
end

function Extension.RegisterClass(this, id, name, isType, isValid)
	local entry = {id, name, isType, isValid, this.state};
	this.classes[#this.classes + 1] = entry;
end

function Extension.RegisterExtendedClass(this, id, name, base, isType, isValid)
	local entry = {[0] = base, id, name, isType, isValid, this.state};
	this.classes[#this.classes + 1] = entry;
end

function Extension.RegisterWiredInport(this, class, wiretype, func)
	hook.Add("Expression3.LoadConstructors", "Expression3.WireInput." .. class, function()
		if this.enabled then
			EXPR_LIB.RegisterWiredInport(class, wiretype, func);
		end
	end);
end

function Extension.RegisterWiredOutport(this, class, wiretype, func)
	hook.Add("Expression3.LoadConstructors", "Expression3.WireOutput." .. class, function()
		if (this.enabled) then
			EXPR_LIB.RegisterWiredOutport(class, wiretype, func);
		end
	end);
end

function Extension.RegisterConstructor(this, class, parameter, constructor, excludeContext)
	local entry = {class, parameter, constructor, excludeContext, this.state};
	this.constructors[#this.constructors + 1] = entry;
end

function Extension.RegisterMethod(this, class, name, parameter, type, count, method, excludeContext)
	local entry = {class, name, parameter, type, count, method, excludeContext, this.state};
	this.methods[#this.methods + 1] = entry;
end

function Extension.RegisterAtribute(this, class, atribute, type, native)
	local entry = {class, atribute, type, native, this.state};
	this.atributes[#this.atributes + 1] = entry;
end

function Extension.RegisterOperator(this, operation, parameter, type, count, operator, excludeContext)
	local entry = {operation, parameter, type, count, operator, excludeContext, this.state};
	this.operators[#this.operators + 1] = entry;
end

function Extension.RegisterCastingOperator(this, type, parameter, operator, excludeContext)
	local entry = {type, parameter, operator, excludeContext, this.state};
	this.castOperators[#this.castOperators + 1] = entry;
end

function Extension.RegisterLibrary(this, name)
	local entry = {name, name};
	this.libraries[#this.libraries + 1] = entry;
end

function Extension.RegisterFunction(this, library, name, parameter, type, count, _function, excludeContext)
	local entry = {library, name, parameter, type, count, _function, excludeContext, this.state};
	this.functions[#this.functions + 1] = entry;
end

function Extension.CheckRegistration(this, _function, ...)
	local state, err = pcall(_function, ...);

	if (not state) then
		EXPR_LIB.ThrowInternal(0, "%s in component %s", err, this.name);
	end

	return err;
end

function Extension.PostLoadClasses()
end

local enabledExtentions = {};

function Extension.EnableExtenstion(this)
	this.enabled = true;

	local classes = {};

	hook.Add("Expression3.LoadClasses", "Expression3.Extension." .. this.name, function()
		for _, v in pairs(this.classes) do
			STATE = v[5];

			if (not v[0]) then
				local op = this:CheckRegistration(EXPR_LIB.RegisterClass, v[1], v[2], v[3], v[4]);
				op.extension = this.name;
				classes[op.id] = op;
			else
				local op = this:CheckRegistration(EXPR_LIB.RegisterExtendedClass, v[1], v[2], v[0], v[3], v[4]);
				op.extension = this.name;
				classes[op.id] = op;
			end
		end
	end);

	local constructors = {};

	hook.Add("Expression3.LoadConstructors", "Expression3.Extension." .. this.name, function()
		for _, v in pairs(this.constructors) do
			STATE = v[5];
			local op = this:CheckRegistration(EXPR_LIB.RegisterConstructor, v[1], v[2], v[3], v[4]);
			op.extension = this.name;
			constructors[op.signature] = op;
		end

		this:PostLoadClasses(EXPR_LIB.GetAllClasses());
	end);
	
	local methods = {};

	hook.Add("Expression3.LoadMethods", "Expression3.Extension." .. this.name, function()
		for _, v in pairs(this.methods) do
			STATE = v[8];
			local op = this:CheckRegistration(EXPR_LIB.RegisterMethod, v[1], v[2], v[3], v[4], v[5], v[6], v[7]);
			op.extension = this.name;
			methods[op.signature] = op;
		end
	end);

	local atributes = {};

	hook.Add("Expression3.LoadAtributes", "Expression3.Extension." .. this.name, function()
		for _, v in pairs(this.atributes) do
			STATE = v[5];
			local atr = this:CheckRegistration(EXPR_LIB.RegisterAtribute, v[1], v[2], v[3], v[4]);
			atr.extension = this.name;
			atributes[atr.atribute] = atr;
		end
	end);

	local operators = {};

	hook.Add("Expression3.LoadOperators", "Expression3.Extension." .. this.name, function()
		for _, v in pairs(this.operators) do
			STATE = v[7];
			local op = this:CheckRegistration(EXPR_LIB.RegisterOperator, v[1], v[2], v[3], v[4], v[5], v[6]);
			op.extension = this.name;
			operators[op.signature] = op;
		end

		for _, v in pairs(this.castOperators) do
			STATE = v[5];
			local op = this:CheckRegistration(EXPR_LIB.RegisterCastingOperator, v[1], v[2], v[3], v[4]);
			op.extension = this.name;
			operators[op.signature] = op;
		end
	end);

	hook.Add("Expression3.LoadLibraries", "Expression3.Extension." .. this.name, function()
		for _, v in pairs(this.libraries) do
			this:CheckRegistration(EXPR_LIB.RegisterLibrary, v[1]);
		end
	end);

	local functions = {};

	hook.Add("Expression3.LoadFunctions", "Expression3.Extension." .. this.name, function()
		for _, v in pairs(this.functions) do
			STATE = v[8];
			local op = this:CheckRegistration(EXPR_LIB.RegisterFunction, v[1], v[2], v[3], v[4], v[5], v[6], v[7]);
			op.extension = this.name;
			functions[op.signature] = op;
		end
	end);

	hook.Add("Expression3.BuildExtensionData","Expression3.Extension." .. this.name, function()
		this.classes = classes;
		this.constructors = constructors;
		this.methods = methods;
		this.operators = operators;
		this.functions = functions;
		this.atributes = atributes;
		enabledExtentions[this.name] = this;

		MsgN("Registered extention: ", this.name);
	end)
end

-- emtpty table before: Expression3.PostRegisterExtenstions
function EXPR_LIB.GetEnabledExtensions()
	return enabledExtentions or {};
end
--[[
	:::Hooks For Loading extensions:::
	''''''''''''''''''''''''''''''''''
]]

local extendClass;

function extendClass(class, base)
	local c = EXPR_LIB.GetClass(class);
	local b = EXPR_LIB.GetClass(base);

	if (not c or not b) then
		return;
	end

	if (not c.extends) then
		c.extends = {};
	end

	if (c.extends[b.id]) then
		return;
	end

	if (c.id == b.id) then
		return;
	end

	if (b.base) then
		extendClass(base, b.base)
	end

	if (not c.isType) then
		c.isType = b.isType;
	end

	if (not c.isValid) then
		c.isValid = b.isValid;
	end

	local constructors = c.constructors;

	for _, op in pairs(b.constructors) do
		local signature = string.format("%s(%s)", class, op.parameter);

		if (not constructors[signature]) then
			constructors[signature] = op;
		end
	end

	for _, op in pairs(methods) do
		if (op.class == base) then
			local signature = string.format("%s.%s(%s)", class, op.name, op.parameter);

			if (not methods[signature]) then
				methods[signature] = op;
			end
		end
	end

	c.extends[b.id] = true;

	MsgN("Extended Class: ", c.name, " from ", b.name);
end

function EXPR_LIB.ToString(context, type, value)
	local op = EXPR_CAST_OPERATORS["(s)" .. type];

	if (not op or not op.operator) then
		return tostring(value);
	elseif (not op.context) then
		return op.operator(value);
	else
		return op.operator(context, value);
	end
end

function EXPR_LIB.Initalize()
	MsgN("Loading Expression 3");

	include("expression3/extensions/core.lua");

	hook.Run("Expression3.RegisterExtenstions");

	classes = {};
	classIDs = {};
	loadClasses = true;
	hook.Run("Expression3.LoadClasses");

	loadClasses = false;
	EXPR_CLASSES = classes;

	loadConstructors = true;
	hook.Run("Expression3.LoadConstructors");
	loadConstructors = false;

	methods = {};
	loadMethods = true;
	hook.Run("Expression3.LoadMethods");
	loadMethods = false;
	EXPR_METHODS = methods;

	loadAtributes = true;
	hook.Run("Expression3.LoadAtributes");
	loadAtributes = false;

	operators = {};
	castOperators = {};
	loadOperators = true;
	hook.Run("Expression3.LoadOperators");
	loadOperators = false;
	EXPR_OPERATORS = operators;
	EXPR_CAST_OPERATORS = castOperators;

	libraries = {};
	loadLibraries = true;
	hook.Run("Expression3.LoadLibraries");
	loadLibraries = false;
	EXPR_LIBRARIES = libraries;

	functions = {};
	loadFunctions = true;
	hook.Run("Expression3.LoadFunctions");
	loadFunctions = false;

	for id, class in pairs(classes) do
		extendClass(id, class.base);
	end

	if (CLIENT) then
		include("expression3/editor/expr_editor_lib.lua");
	end

	hook.Run("Expression3.BuildExtensionData");

	hook.Run("Expression3.PostRegisterExtenstions");

	include("expression3/tokenizer.lua");
	include("expression3/parser.lua");
	include("expression3/compiler.lua");

	if (CLIENT) then
		hook.Run("Expression3.LoadGolem");
	end

	include("expression3/debuger.lua");

	MsgN("Expression 3 has loaded.");
end


--[[
	:::TRANSMITION OF DATA:::
	'''''''''''''''''''''''''
]]

EXPR_CHAT = 0
EXPR_CONSOLE = 1

if (SERVER) then
	util.AddNetworkString("Expression3.Print");
	util.AddNetworkString("Expression3.RelayToClient");
	util.AddNetworkString("Expression3.InitalizedClient");

	function EXPR_LIB.SendToPlayer(ply, ent, const, ...)
		local t = {...};

		net.Start("Expression3.Print");
			net.WriteEntity(ent);
			net.WriteInt(const, 3);
			net.WriteInt(#t, 16);

			for _, v in pairs(t) do
				if (not IsColor(v)) then
					net.WriteBit(0);
					net.WriteString(tostring(v));
				else
					net.WriteBit(1);
					net.WriteInt(v.r, 16);
					net.WriteInt(v.g, 16);
					net.WriteInt(v.b, 16);
				end
			end

		net.Send(ply);
	end

	function EXPR_LIB.SendToChat(ply, ent, ...)
		return EXPR_LIB.SendToPlayer(ply, ent, EXPR_CHAT, ...);
	end

	function EXPR_LIB.SendToConsole(ply, ent, ...)
		return EXPR_LIB.SendToPlayer(ply, ent, EXPR_CONSOLE, ...);
	end

	net.Receive("Expression3.RelayToClient", function(len, ply)
		local ent = net.ReadEntity();
		local trg = net.ReadEntity();
		local const = net.ReadInt(3);
		local count = net.ReadInt(16);
		local output = {};

		for i = 1, count do
			if (net.ReadBit() == 0) then
				output[i] = net.ReadString();
			else
				output[i] = Color(
					net.ReadInt(16),
					net.ReadInt(16),
					net.ReadInt(16)
				);
			end
		end

		if (IsValid(trg)) then
			net.Start("Expression3.RelayToClient");
				net.WriteEntity(ent);
				net.WriteEntity(ply);
				net.WriteInt(const, 3);
				net.WriteInt(count, 16);

				for _, v in pairs(output) do
					if (not istable(v)) then
						net.WriteBit(0);
						net.WriteString(tostring(v));
					else
						net.WriteBit(1);
						net.WriteInt(v.r, 16);
						net.WriteInt(v.g, 16);
						net.WriteInt(v.b, 16);
					end
				end

			net.Send(trg);
		end
	end)

end

if (CLIENT) then
	net.Receive("Expression3.Print", function()
		local ent = net.ReadEntity();
		local const = net.ReadInt(3);
		local count = net.ReadInt(16);
		local output = {};

		for i = 1, count do
			if (net.ReadBit() == 0) then
				output[i] = net.ReadString();
			else
				output[i] = Color(
					net.ReadInt(16),
					net.ReadInt(16),
					net.ReadInt(16)
				);
			end
		end

		-- Might pass this to the entity instead later.

		if (const == EXPR_CHAT) then
			chat.AddText(unpack(output));
		elseif (const == EXPR_CONSOLE) then
			-- TODO: Console tab per entity :D
			Golem.Print(tostring(ent), ":", unpack(output));
		end
	end)

	function EXPR_LIB.SendToClient(ply, ent, const, ...)
		local t = {...};

		net.Start("Expression3.RelayToClient");
			net.WriteEntity(ent);
			net.WriteEntity(ply);
			net.WriteInt(const, 3);
			net.WriteInt(#t, 16);

			for _, v in pairs(t) do
				if (not IsColor(v)) then
					net.WriteBit(0);
					net.WriteString(tostring(v));
				else
					net.WriteBit(1);
					net.WriteInt(v.r, 16);
					net.WriteInt(v.g, 16);
					net.WriteInt(v.b, 16);
				end
			end

		net.SendToServer();
	end

	net.Receive("Expression3.RelayToClient", function()
		local ent = net.ReadEntity();
		local frm = net.ReadEntity();
		local const = net.ReadInt(3);
		local count = net.ReadInt(16);
		local output = {};

		for i = 1, count do
			if (net.ReadBit() == 0) then
				output[i] = net.ReadString();
			else
				output[i] = Color(
					net.ReadInt(16),
					net.ReadInt(16),
					net.ReadInt(16)
				);
			end
		end

		-- Todo: Pass this to entity :D
	end)
end

--[[
	:::Hooks For Loading Golem Editor:::
	''''''''''''''''''''''''''''''''''''
]]

if (CLIENT) then
	hook.Add("Expression3.LoadGolem", "Expression3.Golem.Init", function()
		include("expression3/editor.lua");
		print("Golem::", Golem);
		Golem.Reload();
	end);
end

--[[
	:::Context Registry:::
	''''''''''''''''''''''
]]

local AllRunning = {};

function EXPR_LIB.GetAll()
	return AllRunning;
end

function EXPR_LIB.RegisterContext(context)
	AllRunning[context] = context;
end

function EXPR_LIB.UnregisterContext(context)
	AllRunning[context] = nil;
end

--[[
]]

local SysTime, bench = SysTime;

local token_run = function(this)
	local i = 0;
	local vldr = this.vldr;

	while (this.__char ~= nil) do
		i = i + 1;

		this:Loop();

		if (i > 25) then

			local b = SysTime() - bench;

			vldr.tokenizerTime = vldr.tokenizerTime + b;

			vldr.tokenizerCount = vldr.tokenizerCount + 1;

			-- print("Tokeinizer step " .. i .. " took ", b);

			coroutine.yield();

			i = 0;

			bench = SysTime();
		end
	end

	local result = {};
	result.tokens = this.__tokens;
	result.script = this.__buffer;

	return result;
end

function EXPR_LIB.Validate(cb, script, files)
	local vldr = {};
	local ok, res;
	vldr.timer = "Validator:" .. tostring(vldr);

	vldr.func = coroutine.create(function()
		local a, b = pcall(function()
			bench = SysTime();

			vldr.tokenizer = EXPR_TOKENIZER.New();

			vldr.tokenizerTime = 0;

			vldr.tokenizerCount = 0; 

			vldr.tokenizer.vldr = vldr;

			vldr.tokenizer._Run = token_run;

			vldr.tokenizer:Initalize("EXPADV", script);

			ok, res = vldr.tokenizer:Run();

			vldr.tokenizerTime = vldr.tokenizerTime + (SysTime() - bench);

			if ok then
				coroutine.yield();

				bench = SysTime();

				vldr.parser = EXPR_PARSER.New();

				vldr.parser:Initalize(res, files);

				ok, res = vldr.parser:Run();

				vldr.parserTime = SysTime() - bench;

				if ok then
					coroutine.yield();
					
					bench = SysTime();

					vldr.compiler = EXPR_COMPILER.New();

					vldr.compiler:Initalize(res, files);

					ok, res = vldr.compiler:Run();

					vldr.compilerTime = SysTime() - bench;

					if ok then
						coroutine.yield();

						bench = SysTime();

						res.build();

						vldr.buildTime = SysTime() - bench;
					end
				end
			end
		end);

		if (not a) then
			ok = a;
			res = {msg = b, state == "internal", line = 0, char = 0};
		end

		--print(vldr.timer);
		--print("Tokenizer", vldr.tokenizerTime, " - ", vldr.tokenizerCount);
		--print("Parser", vldr.parserTime);
		--print("Compiler", vldr.compilerTime);
		--print("Build", vldr.buildTime);

		vldr.finished = true;
	end);

	vldr.start = function()
		timer.Create(vldr.timer, 0.1, 0, vldr.resume);

		timer.Create(vldr.timer .. 2, 60, 1, function()
			if (not vldr.finished) then
				timer.Destroy(vldr.timer);
				cb(false, "Validation took to long.");
			end
		end);

		return vldr.resume();
	end;

	vldr.stop = function()
		timer.Destroy(vldr.timer);
	end;

	vldr.resume = function()
		if (not vldr.finished) then
			coroutine.resume(vldr.func);
		end

		if (vldr.finished) then
			vldr.stop();
			cb(ok, res);
			return true;
		end

		return false;
	end;

	return vldr;
end


--[[
	:::Load Expression 3:::
	'''''''''''''''''''''''
]]

timer.Simple(5, EXPR_LIB.Initalize);
