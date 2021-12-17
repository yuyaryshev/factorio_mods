local function is_identifer_start(c)
    return c >= "A" and c <= "Z" or c >= "a" and c <= "z" or c == "_"
end

local function is_identifer_char(c)
    return c >= "A" and c <= "Z" or c >= "a" and c <= "z" or c == "_" or c >= "0" and c <= "9"
end

local function is_digit(c)
    return c >= "0" and c <= "9"
end

local function is_space(c)
    return c == " " or c == "\t" or c == "\n" or c == "\r"
end

local function apply_lexer(input)
    if input == nil then
        return nil
    end
    
    local tokens = {}
    local token = {}
    local p = 1
    local line = 1
    local line_start = 0
    while p <= #input do
      local c = input:sub(p,p)
      local d = input:sub(p,p+1)
      
      if c == "\r" then
        p = p + 1
        c = input:sub(p,p)
        if c == "\n" then
            p = p + 1
        end
        line = line + 1
        line_start = p - 1
      elseif c == "\n" then
        p = p + 1
        line = line + 1
        line_start = p - 1
      elseif c == " " or c == "\t" then
        p = p + 1
      else
          token.p = p
          token.line_pos = p - line_start
          token.line = line
      
          -- Identifer
          if is_identifer_start(c) then
            token.type = "identifer"
            while is_identifer_char(c) do
                p = p + 1
                c = input:sub(p,p)
            end
            
          -- Numeric literal
          elseif is_digit(c) then
            token.type = "number"
            while is_digit(c) do
                p = p + 1
                c = input:sub(p,p)
            end
            if c == "." then
                p = p + 1
            end
            while is_digit(c) do
                p = p + 1
                c = input:sub(p,p)
            end
            token.value = tonumber(input:sub(token.p, p))
             
          -- Single quoted string literal
          elseif c == "\'" then
            token.type = "string"
            p = p + 1
            c = input:sub(p,p)
            token.value = ""
            while c ~= "\'" do
                p = p + 1
                c = input:sub(p,p)
            end
            p = p + 1
          
          -- Double quoted string literal
          elseif c == "\"" then
            token.type = "string"
            p = p + 1
            c = input:sub(p,p)
            token.value = ""
            while c ~= "\"" do
                if c == "\\" then
                    p = p + 1
                    c = input:sub(p,p)
                    if c == "n" then
                        token.value = token.value + "\n"
                    elseif c == "r" then
                        token.value = token.value + "\r"
                    elseif c == "t" then
                        token.value = token.value + "\t"
                    else
                        token.value = token.value + c
                    end
                else
                    p = p + 1
                    c = input:sub(p,p)
                end
            p = p + 1
            end
          elseif d == "++" 
              or d == "--" 
              or d == "==" 
              or d == "!=" 
              or d == ">=" 
              or d == "<=" 
              or d == "<>" 
              or d == "+=" 
              or d == "-=" 
              or d == "*=" 
              or d == "/=" 
              or d == "!=" 
              or d == "||" 
              or d == "&&" 
              then
              token.type = "punctuator"
              p = p + 2 
          elseif c == "+" 
              or c == "-" 
              or c == "*" 
              or c == "/" 
              or c == "=" 
              or c == "!" 
              or c == "(" 
              or c == ")" 
              or c == "{" 
              or c == "}" 
              or c == "[" 
              or c == "]" 
              or c == ";" 
              or c == ":" 
              or c == "%" 
              or c == "<" 
              or c == "?" 
              or c == "." 
			  then 
              token.type = "punctuator"
              p = p + 1
          end 
          
          token.len = p - token.p
          token.str = input:sub(token.p, p - 1)
          token.value = token.value or token.str
          table.insert(tokens, token)
          token = {}
      end -- if not is_space
    end -- while
return {p = 1, tokens = tokens, errors = {}, has_fatal_error = false}
end

-- Reads one token if token matches expected_value. Does nothing if not.
local function read_token_str(tokens_iterator, expected_value)
    local next_token = tokens_iterator.tokens[tokens_iterator.p]
    if next_token.str == expected_value then
        tokens_iterator.p = tokens_iterator.p + 1
        return next_token
    else
        return nil
    end
end


-- Reads one token if token matches expected_type. Does nothing if not.
local function read_token_type(tokens_iterator, expected_type)
    local next_token = tokens_iterator.tokens[tokens_iterator.p]
    if next_token.type == expected_type then
        tokens_iterator.p = tokens_iterator.p + 1
        return next_token
    else
        return nil
    end
end

------------------ END OF LEXER ------------------

local function PARSE_ERROR(c, message)
    table.insert(c.errors, { token = c.tokens[c.p], message = message} )
end




local function PARSE_CHECK(c, condition, message)
    if not condition then
        PARSE_ERROR(c, message)
    end
end




local function PARSE_EXPECTED(c, str)
    if not read_token_str(c,str) then
        PARSE_ERROR(c, "Error: " .. str .. " expected")
    end
end

local expect_expression
local expect_statement

local function parse_literal_number(c)
	local token = read_token_type(c, "number")
	if token then
    	return {type = "literal", subtype = "number", value = token.value, token = token}
	end
end





local function parse_literal_string(c)
	local token = read_token_type(c, "number")
	if token then
    	return {type = "literal", subtype = "string", value = token.value, token = token}
	end
end





local function parse_literal_null(c)
	local token = read_token_str(c, "null") or read_token_str(c, "nil")
	if token then
    	return {type = "literal", subtype = "null", token = token}
	end
end





local function parse_literal_bool(c)
	local token = read_token_str(c, "true")
	if token then
    	return {type = "literal", subtype = "bool", value=true, token = token}
	end
	
	token = read_token_str(c, "false")
	if token then
    	return {type = "literal", subtype = "bool", value=false, token = token}
	end
end





local function parse_literal(c)
    return  parse_literal_number(c) 
        or  parse_literal_string(c)
        or  parse_literal_null(c)
        or  parse_literal_bool(c)
end





local function parse_rbraces(c)
    local token = read_token_str(c, "(")
	if token then
		local arg = expect_expression(c)
		PARSE_CHECK(c, arg, "Ioeaea i?e ?oaiee au?a?aiey")
		PARSE_EXPECTED(c, ")")
    	return {type = "operator", subtype = "rbrace", args = {arg}, token = token}
	end
end





local function parse_identifer(c)
    local token = read_token_type(c, "identifer")
	if token then
    	return {type = "identifer", token = token}
	end
end





local function parse_expr_value(c)
-- expression level 0
    return parse_literal(c)
        or parse_rbraces(c)
        or parse_identifer(c)
        or PARSE_ERROR(c, "Expression value expected")
end





local function parse_expr_suffix(c)
-- expression level 2
	local t = parse_expr_value(c);
	
	local operator_token

    ::L_continue::
    operator_token =   
            read_token_str(c, "++"		)
        or  read_token_str(c, "--"		)
        or  read_token_str(c, "."		)
        or  read_token_str(c, "->"		)
        or  read_token_str(c, "=>"	    )

    if operator_token ~= nil then
        t = {type = "operator", subtype = "suffix", operator = operator_token.str, args = {t}, token = operator_token}
        goto L_continue
    elseif read_token_str(c, "[" ) then
        local inner_expr = expect_expression(c);
        PARSE_CHECK(c, inner_expr, "Expression expected")
        t = {type = "operator", subtype = "suffix", operator = "index", args = {t,inner_expr}, token = operator_token}
        PARSE_EXPECTED("]")
        goto L_continue
    elseif read_token_str(c, "(" ) then
        t = {type = "operator", subtype = "suffix", operator = "function_call", args = {t}, token = operator_token}
        if not read_token_str(c, ")") then
            local arg_expr
            ::L_more_params::
            arg_expr = expect_expression(c);
            PARSE_CHECK(c, arg_expr, "Expression expected")
            table.insert(t.args, arg_expr)
            if read_token_str(c, ",") then
                goto L_more_params
            end
            PARSE_EXPECTED(c, ")")
        end
        goto L_continue
    end		

    return t
end





local function parse_expr_prefix(c)
-- expression level 3
    local operator_token =   
            read_token_str(c, "!"		)
        or  read_token_str(c, "not"		)
        or  read_token_str(c, "-"		)
        or  read_token_str(c, "+"		)
        or  read_token_str(c, "++"		)
        or  read_token_str(c, "--"	    )
        or  read_token_str(c, "*"	    )
        or  read_token_str(c, "&"	    )
        
	if operator_token then
	    local t = {type = "operator", subtype = "prefix", operator = operator_token.str, args = {parse_expr_prefix(c)}, token = operator_token}
        
        if operator_token.str == "!" or operator_token.str == "not" then
            t.operator = "!"                    -- Change operator name to unify different spelling of the meaning
        end
        
        if operator_token.str ~= "!" then
            t.operator = t.operator.."x"        -- Change operator name to destinguish from suffix ++ -- and from binary operators
        end
        return t
	else
    	-- up to expression level 2 (parse_expr_suffix)
    	return parse_expr_suffix(c);
	end
end





local function parse_expr_factor(c) -- * / % operators
-- expression level 5
	local left_operand = parse_expr_prefix(c);

	local operator_token =
            read_token_str(c, "*"		)
        or  read_token_str(c, "/"		)
        or  read_token_str(c, "%"		)
        
	if operator_token then
	    return {type = "operator", subtype = "binary", operator = operator_token.str, args = {left_operand, parse_expr_factor(c)}, token = operator_token}
	else
    	-- up to expression level 3 (parse_expr_prefix)
    	return left_operand;
	end
end





local function parse_expr_term(c) -- + - operators
-- expression level 6
	local left_operand = parse_expr_factor(c);

	local operator_token =
            read_token_str(c, "+"		)
        or  read_token_str(c, "-"		)
        
	if operator_token then
	    return {type = "operator", subtype = "binary", operator = operator_token.str, args = {left_operand, parse_expr_term(c)}, token = operator_token}
	else
    	-- up to expression level 5 (parse_expr_factor)
    	return left_operand;
	end
end





local function parse_expr_bit_shift(c) -- << >> <=> operators
-- expression level 7
	local left_operand = parse_expr_term(c);

	local operator_token =
            read_token_str(c, "<<"		)
        or  read_token_str(c, ">>"		)
        or  read_token_str(c, "<=>"		)
        
	if operator_token then
	    return {type = "operator", subtype = "binary", operator = operator_token.str, args = {left_operand, parse_expr_bit_shift(c)}, token = operator_token}
	else
    	-- up to expression level 6 (parse_expr_term)
    	return left_operand;
	end
end





local function parse_expr_comparison(c) -- < > >= <= operators
-- expression level 8
	local left_operand = parse_expr_bit_shift(c);

	local operator_token =
            read_token_str(c, "<="		)
        or  read_token_str(c, ">="		)
        or  read_token_str(c, ">"		)
        or  read_token_str(c, "<"		)

	if operator_token then     
	    return {type = "operator", subtype = "binary", operator = operator_token.str, args = {left_operand, parse_expr_comparison(c)}, token = operator_token}
	else
    	-- up to expression level 7 (parse_expr_bit_shift)
    	return left_operand;
	end
end





local function parse_expr_equality(c) -- == != <> operators
-- expression level 9
	local left_operand = parse_expr_comparison(c);

	local operator_token =
            read_token_str(c, "=="		)
        or  read_token_str(c, "~="		)
        or  read_token_str(c, "!="		)
        or  read_token_str(c, "<>"		)
                             
	if operator_token then
	    local t = {type = "operator", subtype = "binary", operator = operator_token.str, args = {left_operand, parse_expr_equality(c)}, token = operator_token}
        if operator_token.str == "~=" or operator_token.str == "!=" or operator_token.str == "<>"  then
            t.operator = "!="                    -- Change operator name to unify different spelling of the meaning
        end
	    return t
	else
    	-- up to expression level 8 (parse_expr_comparison)
    	return left_operand;
	end
end





local function parse_expr_bit_and(c) -- & operator
-- expression level 10

	local left_operand = parse_expr_equality(c);

	local operator_token =
            read_token_str(c, "&"		)
        
	if operator_token then
	    return {type = "operator", subtype = "binary", operator = operator_token.str, args = {left_operand, parse_expr_bit_and(c)}, token = operator_token}
	else
    	-- up to expression level 9 (parse_expr_equality)
    	return left_operand;
	end
-------------------	
end





local function parse_expr_bit_xor(c) -- ^ operator
-- expression level 11
	local left_operand = parse_expr_bit_and(c);

	local operator_token =
            read_token_str(c, "&"		)
        
	if operator_token then
	    return {type = "operator", subtype = "binary", operator = operator_token.str, args = {left_operand, parse_expr_bit_xor(c)}, token = operator_token}
	else
    	-- up to expression level 11 (parse_expr_bit_and)
    	return left_operand;
	end
end





local function parse_expr_bit_or(c) -- | operator
-- expression level 12
	local left_operand = parse_expr_bit_xor(c);

	local operator_token =
            read_token_str(c, "|"		)
        
	if operator_token then
	    return {type = "operator", subtype = "binary", operator = operator_token.str, args = {left_operand, parse_expr_bit_or(c)}, token = operator_token}
	else
    	-- up to expression level 11 (parse_expr_bit_xor)
    	return left_operand;
	end
end





local function parse_expr_logical_and(c) -- && operator
-- expression level 13
	local left_operand = parse_expr_bit_or(c);

	local operator_token =
              read_token_str(c, "&&"		)
          or  read_token_str(c, "and"		)

	if operator_token then
	    return {type = "operator", subtype = "binary", operator = "&&", args = {left_operand, parse_expr_logical_and(c)}, token = operator_token}
	else
    	-- up to expression level 12 (parse_expr_bit_or)
    	return left_operand;
	end
end





local function parse_expr_logical_or(c) -- || operator
-- expression level 14
	local left_operand = parse_expr_logical_and(c);

	local operator_token =
            read_token_str(c, "||"		)
        or  read_token_str(c, "or"		)
        
	if operator_token then
	    return {type = "operator", subtype = "binary", operator = "||", args = {left_operand, parse_expr_logical_or(c)}, token = operator_token}
	else
    	-- up to expression level 13 (parse_expr_logical_and)
    	return left_operand;
	end
end





local function parse_expr_assignment(c) -- ?: = += /= *= ... operators
-- expression level 15
	local left_operand = parse_expr_logical_or(c);


	local operator_token = read_token_str(c, "?" )
    if operator_token then -- inline if (ternary operator: condition ? value_if_true : value_if_false )
		local mid_operand = parse_expr_assignment(c);
		PARSE_EXPECTED(":");
        local right_operand = parse_expr_assignment(c);
		return {type = "operator", subtype = "inline_if", operator = "?:", args = {left_operand, mid_operand, right_operand}, token = operator_token};
    end

	operator_token =
            read_token_str(c, "+="		)
        or  read_token_str(c, "-="		)
        or  read_token_str(c, "*="		)
        or  read_token_str(c, "/="		)
        or  read_token_str(c, "%="		)
        or  read_token_str(c, "&="		)
        or  read_token_str(c, "^="		)
        or  read_token_str(c, "|="		)
        or  read_token_str(c, "&&="		)
        or  read_token_str(c, "||="		)
        or  read_token_str(c, ">>="		)
        or  read_token_str(c, "<<="		)
        or  read_token_str(c, "="		)
        
	if operator_token then
	    return {type = "operator", subtype = "binary", operator = operator_token.str, args = {left_operand, parse_expr_assignment(c)}, token = operator_token}
	else
    	-- up to expression level 14 (parse_expr_logical_or)
    	return left_operand;
	end
end





local function parse_expression(c)
	return parse_expr_assignment(c);
end





expect_expression = function(c)
	local expr = parse_expression(c);
	if expr then
	    return expr
	else
		PARSE_ERROR(c, "expression_expected");
	end
end





local function parse_if(c)
    local token = read_token_str(c, "if" )
    if token then
        PARSE_EXPECTED(c, "(")
        local expr = expect_expression(c)
        PARSE_EXPECTED(c, ")")
        local stmt = expect_statement(c)
        local else_stmt
        
        if read_token_str(c, "else" ) then
            else_stmt = expect_statement(c)
        end
        return {type = "if", cond = expr, stmt = stmt, else_stmt = else_stmt, token = token}
    end
end





local function parse_for(c)
    local token = read_token_str(c, "for" )
    local token_foreach 
    if not token then 
        token_foreach = read_token_str(c, "foreach" )
    end
    if token or token_foreach then
        PARSE_EXPECTED(c, "(")
        local init_expr = expect_expression(c)
        local token_colon = read_token_str(c, ":" )
        if not token_colon then
            token_colon = read_token_str(c, "in" )
        end
        if token_foreach and not token_colon then
            PARSE_ERROR(c, "expected :")
        end
        if token_colon then
            -- foreach(...) stmt
            local container_expr = expect_expression(c)
            PARSE_EXPECTED(c, ")")
            local stmt = expect_statement(c)
            return {type = "foreach", init = init_expr, container = container_expr, stmt = stmt, token = token}
        else
            -- for(...;...;...) stmt
            PARSE_EXPECTED(c, ";")
            local cond_expr = expect_expression(c)
            PARSE_EXPECTED(c, ";")
            local incr_expr = expect_expression(c)
            PARSE_EXPECTED(c, ")")
            local stmt = expect_statement(c)
            return {type = "for", init = init_expr, cond = cond_expr, incr_expr = incr_expr, stmt = stmt, token = token}
        end
    end
end





local function parse_while(c)
    local token = read_token_str(c, "while")
    if token then
        PARSE_EXPECTED(c, "(")
        local cond_expr = expect_expression(c)
        PARSE_EXPECTED(c, ")")
        local stmt = expect_statement(c)
        return {type = "while", cond = cond_expr, stmt = stmt, token = token}
    end
end











local function parse_block(c)
	local t = {type = "block", stmts = {}}
	if read_token_str(c, "{") then
    	if not read_token_str(c, "}") then
    	    table.insert(t.stmts, expect_statement(c))
    	else
        	return t
    	end
	end
end





local function expect_block(c)
	local stmt = parse_block(c);
	PARSE_CHECK(c, stmt, "block expected");
	return stmt;
end





local function parse_switch(c)
	local token = read_token_str(c, "switch")
	if token then
	    PARSE_EXPECTED(c, "(")
        local cond = expect_expression(c)
	    PARSE_EXPECTED(c, ")")
        return {type = "switch", cond = cond, block = expect_block(c), token = token}
    end
end





local function parse_case(c)
	local token = read_token_str(c, "case")
	if token then
        local cond = expect_expression(c)
        PARSE_EXPECTED(c, ":")
        return {type = "case", cond = cond, token = token}
    end
end





local function parse_break(c)
	local token = read_token_str(c, "break")
	if token then
	    local depth_token = read_token_type(c, "number")
        return {type = "break", depth = depth_token and depth_token.value or 1, token = token}
    end
end





local function parse_continue(c)
	local token = read_token_str(c, "continue")
	if token then
	    local depth_token = read_token_type(c, "number")
        return {type = "break", depth = depth_token and depth_token.value or 1, token = token}
    end
end





local function parse_label(c)
	local token = read_token_str(c, "#")
	if token then
	    local name = read_token_type(c, "identifer")
        return {type = "label", label_name = name, token = token}
    end
end





local function parse_goto(c)
	local token = read_token_str(c, "goto")
	if token then
	    local name = read_token_type(c, "identifer")
        return {type = "goto", label_name = name, token = token}
    end
end


local function parse_statement(c)
	local stmt = false
        or parse_if(c)
        or parse_for(c)
        or parse_while(c)
        or parse_break(c)
        or parse_continue(c)
        or parse_switch(c)
        or parse_case(c)
        or parse_label(c)
        or parse_goto(c)
        or parse_block(c)
--        or parse_return(c)
--        or parse_do_while(c)
--        or parse_try_catch(c)
--        or parse_declaration(c)
        or parse_expression(c)
        
    read_token_str(c,";")
    return stmt;
end





expect_statement = function(c)
	local stmt = parse_statement(c);
	PARSE_CHECK(c, stmt, "statement expected");
	return stmt;
end



--[[

local function parse_do_while(c)
-- TODO_lo
	stmt_do_while_t t;
	if(!read_token_str(c, kw_do_tt))
		return t;

	c.create_t(t);
	t.statement().put(expect_statement(c));	
	if(!read_token_str(c, kw_while_tt))
	c.rd->expect("(");
	t.condition().put(expect_expression(c));
	c.rd->expect(")");
	return t;
end





local function parse_try_catch(c)
-- TODO_lo
	stmt_try_catch_t t;
	if(!read_token_str(c, kw_try_tt))
		return t;

	c.create_t(t);
	t.statement().put(expect_statement(c));
	
	if(!read_token_str(c, kw_catch_tt))
	c.rd->expect("(");
	t.exception_var().put(expect_declaration(c));
	c.rd->expect(")");
	t.catch_statement().put(expect_statement(c));
	return t;
end



local function parse_cpp_function(c)
-- TODO_lo
	cpp_function_t r;
	if(!read_token_str(c, kw_function_tt))
		return r;

	auto auto_restore_top_parent = auto_restore(c.sources_save_context.top_parent);
	r = parse_concept_id<cpp_function_t>(c,true);
	if(!r.is_valid())
		c.create_t(r, true);

	auto auto_restore_parent = auto_restore<entity_abstract_t>(c.current_parent, r);

	const token_t* name = 0;
	if(!read_token_str(c, name, token_prmtype_t::identifer))
		PARSE_ERROR(L"I?eaaaony eiy ooieoee", warning_identifer_tt);
	r.name().put(name->str());

	cpp_type_t type;
	type = parse_type(c);
	if(!type.is_valid())
		PARSE_ERROR(L"I?eaaaony oei ooieoee", warning_identifer_tt);
	r.type().put(type);

	if(read_token_str(c, "("))
		{
		cpp_field_t st = parse_declaration(c);
		if(st.is_valid())
			r.params().put(st);

		while(read_token_str(c, comma_tt))
			{
			cpp_field_t st = parse_declaration(c);
			if(!st.is_valid())
				PARSE_ERROR(L"parameter definintion expected", warning_identifer_tt);
			r.params().put(st);
			}

		PARSE_EXPECTED(")")
		}

	r.statement().put(expect_statement(c));
	c.cpp_name.add_child(r);
	return r;
end





local function parse_cpp_field(c)
-- TODO_lo
	cpp_field_t r;
	if(!read_token_str(c, kw_field_tt))
		return r;

	auto auto_restore_top_parent = auto_restore(c.sources_save_context.top_parent);
	r = parse_concept_id<cpp_field_t>(c,true);
	if(!r.is_valid())
		c.create_t(r, true);

	auto auto_restore_parent = auto_restore<entity_abstract_t>(c.current_parent, r);

	const token_t* name = 0;
	if(!read_token_str(c, name, token_prmtype_t::identifer))
		PARSE_ERROR(L"I?eaaaony eiy iiey", warning_identifer_tt);
	r.name().put(name->str());

	r = parse_declaration(c);
	if(!r.is_valid())
		PARSE_ERROR(L"field definintion expected", warning_identifer_tt);

	c.cpp_name.add_child(r);
	return r;
end





local function parse_cpp_class(c)
-- TODO_lo
	cpp_class_t r;
	if(!read_token_str(c, kw_class_tt))
		return r;

	auto auto_restore_top_parent = auto_restore(c.sources_save_context.top_parent);
	r = parse_concept_id<cpp_class_t>(c,true);
	if(!r.is_valid())
		c.create_t(r, true);

	auto auto_restore_parent = auto_restore<entity_abstract_t>(c.current_parent, r);

	const token_t* name = 0;
	if(!read_token_str(c, name, token_prmtype_t::identifer))
		PARSE_ERROR(L"I?eaaaony eiy eeanna", warning_identifer_tt);

	r.name().put(name->str());

	while(true)
		if(read_token_str(c, kw_extern_tt))
			r.is_extern().put(true);
		else
			break;

	c.cpp_name.add_child(r);

	-- ?eoaou ee e ienaou ee eiaia iieae e ooieoee eeanna?
	return r;
end





local function parse(const s16& source_code, sources_save_context_t& sources_save_context, const s16& source_path, const wchar_t* filename, int line)
-- TODO_lo
	auto lexer_context = apply_lexer(source_code, source_path, filename, line);
	token_stream_reader_t rd(lexer_context.token_stream);
	
	parse_context_t c(sources_save_context);
	c.rd = &rd;
	c.cpp_name = cpp_global_namespace;

	entity_abstract_t r;
	if(!(
			(r = parse_cpp_function(c)).is_valid()
		||	(r = parse_cpp_class(c)).is_valid()
		||	(r = parse_cpp_field(c)).is_valid()
		))
		PARSE_ERROR(L"Unknown concept", lcbrace_tt);
	return r;
end





--------------------------------------------------------------------------
-- if               -> if
-- for              -> for
-- goto             -> goto
-- variable decl    -> variable decl
-- local function call    -> local function call
-- + - * /          -> local function call
-- == !=            -> local function call 
-- []               -> get one signal
--------------------------------------------------------------------------
-- get(<port_name> [, red/green])   -- reads signal from port. If color is specified reads signals only from color
-- emit(port, signal)               -- emits a signal into port, only 5-8 ports are supported
-- ingredients(signal)              -- replaces all inputs with it's ingredients. Counts are applied accordingly
-- wire(port1,port2,red/green)      -- makes a wire between ports
-- unwire(port1,port2,red/green)    -- destroys a wire between ports (does nothing if there is no wire)

-- require an item in [requester/simple] chest near it
------------------------------------------------
-- Should be DECLARATIVE
------------------------------------------------
-- wire                        -- creates a wire between ports and internal combinators
-- decider                     -- creates a decider combinator
-- arithmetic                  -- creates an arithmetic combinator with specified parameters
-- const                       -- creates a constant combinator with specified parameters
--------------------------------------------------------------------------
*/


local function parse_declaration(c)
-- TODO_lo
	-- Declaration or local function parameter
	auto t = parse_concept_id<cpp_field_t>(c);

	auto ss = auto_restore(*c.rd);
	bool is_auto = false;

	cpp_type_t type;
	type = parse_type(c);
	if(!type.is_valid())
		return t;

	const token_t* name = 0;
	if(!read_token_str(c, name, token_prmtype_t::identifer))
		return t;

	if(!t.is_valid())
		c.create_t(t);

	t.type().put(type);
	t.name().put(name->str());

	if(read_token_str(c, let_tt))
		{
		expression_t expr = parse_expression(c);
		t.def_value().put(expr);
		}

	c.cpp_name.add_child(t);

	ss.no_restore();
	return t;
end





local function expect_declaration(c)
-- TODO_lo
	auto decl = parse_declaration(c);
	if(!decl.is_valid())
		PARSE_ERROR(L"Variable declaration expected", nullptr);
	return decl;
end





local function parse_return(c)
-- TODO_lo
	stmt_return_t t;
	if(!read_token_str(c, kw_return_tt))
		return t;

	expression_t expr = parse_expression(c);

	c.create_t(t);
	if(expr.is_valid())
		t.expression().put(expr);
	return t;
end

--]]


local function apply_parser(source_code)
	local t = apply_lexer(source_code)
	t.ast = parse_statement(t)
	return t
end
