use crate::ast::*;
use crate::error::{PbError, PbResult};
use crate::token::{Located, Token};
use std::collections::HashMap;

#[derive(Debug, Clone, Copy, PartialEq)]
enum BodyEnd {
    EndSub,
    EndFunction,
    EndIf,
    Else,
    ElseIf,
    Next,
    Loop,
    Wend,
    EndSelect,
    Case,
    CaseElse,
}

pub struct Parser {
    tokens: Vec<Located>,
    pos: usize,
    def_funcs: HashMap<String, (Vec<String>, Expr)>,
    pub error_count: usize,
    /// Set when the source contains `OPTION EXPLICIT` (same effect as
    /// `#DIM ALL`): every variable must be declared before it is used.
    pub option_explicit: bool,
}

impl Parser {
    pub fn new(tokens: Vec<Located>) -> Self {
        Parser {
            tokens,
            pos: 0,
            def_funcs: HashMap::new(),
            error_count: 0,
            option_explicit: false,
        }
    }

    fn peek(&self) -> &Token {
        self.tokens
            .get(self.pos)
            .map(|t| &t.token)
            .unwrap_or(&Token::Eof)
    }

    fn peek_located(&self) -> &Located {
        static EOF: Located = Located {
            token: Token::Eof,
            line: 0,
            col: 0,
            file: None,
        };
        self.tokens.get(self.pos).unwrap_or(&EOF)
    }

    fn current_line(&self) -> usize {
        self.peek_located().line
    }

    fn current_file(&self) -> Option<&str> {
        self.peek_located().file.as_deref()
    }

    fn advance(&mut self) -> &Token {
        let tok = self
            .tokens
            .get(self.pos)
            .map(|t| &t.token)
            .unwrap_or(&Token::Eof);
        if self.pos < self.tokens.len() {
            self.pos += 1;
        }
        tok
    }

    fn expect(&mut self, expected: &Token) -> PbResult<()> {
        if self.peek() == expected {
            self.advance();
            Ok(())
        } else {
            Err(PbError::parser(
                format!("Expected {:?}, got {:?}", expected, self.peek()),
                self.current_file(),
                self.current_line(),
            ))
        }
    }

    fn skip_eol(&mut self) {
        while matches!(self.peek(), Token::Eol | Token::Colon) {
            self.advance();
        }
    }

    fn at_end(&self) -> bool {
        matches!(self.peek(), Token::Eof)
    }

    fn at_eol_or_eof(&self) -> bool {
        matches!(self.peek(), Token::Eol | Token::Eof | Token::Colon)
    }

    fn consume_to_eol(&mut self) {
        while !matches!(
            self.peek(),
            Token::Eol | Token::Eof | Token::Colon | Token::Else | Token::ElseIf
        ) {
            self.advance();
        }
        // Consume Eol but NOT Colon/Else/ElseIf — these are statement-level
        // boundaries that callers need to detect
        // (e.g., single-line IF: IF cond THEN stmt ELSE stmt)
        if self.peek() == &Token::Eol {
            self.advance();
        }
    }

    #[allow(dead_code)]
    fn is_identifier(&self, name: &str) -> bool {
        matches!(self.peek(), Token::Identifier(ref s) if s == name)
    }

    #[allow(dead_code)]
    fn peek_identifier(&self) -> Option<&str> {
        match self.peek() {
            Token::Identifier(s) => Some(s.as_str()),
            _ => None,
        }
    }

    fn consume_identifier(&mut self) -> PbResult<String> {
        match self.peek().clone() {
            Token::Identifier(s) => {
                self.advance();
                Ok(s)
            }
            _ => Err(PbError::parser(
                format!("Expected identifier, got {:?}", self.peek()),
                self.current_file(),
                self.current_line(),
            )),
        }
    }

    pub fn parse(&mut self) -> PbResult<Program> {
        let mut items = Vec::new();
        self.skip_eol();

        while !self.at_end() {
            let saved_pos = self.pos;
            match self.parse_top_level() {
                Ok(Some(item)) => items.push(item),
                Ok(None) => {} // consumed but no item (e.g., comment)
                Err(e) => {
                    eprintln!("Error: Parse error: {}", e);
                    self.error_count += 1;
                    self.consume_to_eol();
                }
            }
            self.skip_eol();
            // Safety: prevent infinite loop at top level
            if self.pos == saved_pos && !self.at_end() {
                self.advance();
            }
        }

        Ok(Program { items })
    }

    fn parse_top_level(&mut self) -> PbResult<Option<TopLevel>> {
        self.skip_eol();
        if self.at_end() {
            return Ok(None);
        }
        let line = self.current_line();

        match self.peek().clone() {
            Token::Global => self.parse_global_decl(),
            Token::Dim => {
                let stmts = self.parse_dim_statement(DimScope::Dim)?;
                Ok(Some(TopLevel::DimDeclList(stmts)))
            }
            Token::Redim => {
                let stmt = self.parse_redim_statement()?;
                Ok(Some(TopLevel::DimDecl(stmt)))
            }
            Token::PercentConstant(_) => {
                let c = self.parse_percent_const_decl(line)?;
                Ok(Some(TopLevel::ConstDecl(c)))
            }
            Token::Type => {
                let td = self.parse_type_decl(line)?;
                Ok(Some(TopLevel::TypeDecl(td)))
            }
            Token::Sub => {
                let sd = self.parse_sub_decl()?;
                Ok(Some(TopLevel::SubDecl(sd)))
            }
            Token::Function => {
                let fd = self.parse_function_decl()?;
                Ok(Some(TopLevel::FunctionDecl(fd)))
            }
            Token::Declare => match self.parse_declare_stmt(line)? {
                Some(ds) => Ok(Some(TopLevel::DeclareStmt(ds))),
                None => Ok(None),
            },
            Token::HashInclude
            | Token::HashCompile
            | Token::HashDim
            | Token::HashRegister
            | Token::HashDebug => {
                self.consume_to_eol();
                Ok(None)
            }
            Token::Macro => {
                // MACRO name = body : END MACRO — skip to END MACRO
                self.advance();
                loop {
                    match self.peek() {
                        Token::EndMacro | Token::Eof => {
                            self.advance();
                            break;
                        }
                        _ => {
                            self.advance();
                        }
                    }
                }
                self.consume_to_eol();
                Ok(None)
            }
            Token::Callback => {
                self.advance();
                match self.peek() {
                    Token::Function => {
                        let fd = self.parse_function_decl()?;
                        Ok(Some(TopLevel::FunctionDecl(fd)))
                    }
                    Token::Sub => {
                        let sd = self.parse_sub_decl()?;
                        Ok(Some(TopLevel::SubDecl(sd)))
                    }
                    _ => {
                        self.consume_to_eol();
                        Ok(None)
                    }
                }
            }
            Token::Identifier(w) if w.eq_ignore_ascii_case("ASMDATA") => {
                let ad = self.parse_asmdata_decl(line)?;
                Ok(Some(TopLevel::AsmData(ad)))
            }
            Token::Identifier(w) if w.eq_ignore_ascii_case("CLASS") => {
                // CLASS ClassName ... END CLASS — OOP class block (simplified: skip entire block)
                self.advance(); // consume CLASS
                                // consume optional class name
                if let Token::Identifier(_) = self.peek() {
                    self.advance();
                }
                self.consume_to_eol();
                // skip block body until END CLASS (line-based: read lines until one starts with END CLASS)
                let mut depth = 1;
                while depth > 0 && self.peek() != &Token::Eof {
                    // check if current line starts with CLASS (nested) or END CLASS
                    let is_class_start = matches!(self.peek(), Token::Identifier(w2) if w2.eq_ignore_ascii_case("CLASS"));
                    let is_end = matches!(self.peek(), Token::End);
                    let next_is_class = matches!(self.peek_at(1), Some(Token::Identifier(w3)) if w3.eq_ignore_ascii_case("CLASS"));
                    if is_end && next_is_class {
                        depth -= 1;
                        self.advance(); // END
                        self.advance(); // CLASS
                        self.consume_to_eol();
                        continue;
                    }
                    if is_class_start {
                        depth += 1;
                    }
                    self.advance();
                }
                Ok(None)
            }
            Token::Identifier(w) if w.eq_ignore_ascii_case("OPTION") => {
                // OPTION EXPLICIT — official PB statement with the same effect
                // as #DIM ALL: all variables must be declared before use.
                // Nothing is emitted here; codegen enforces it.
                self.advance(); // consume OPTION
                if self.peek_plain_upper() == "EXPLICIT" {
                    self.advance();
                    self.option_explicit = true;
                }
                self.consume_to_eol();
                Ok(None)
            }
            Token::Identifier(w) if w.eq_ignore_ascii_case("METHOD") => {
            // METHOD name [([args])] — treat as SUB (simplified OOP method).
            // parse_sub_decl() consumes the leading keyword itself, so advancing
            // here would swallow the method name (batch 159 fix).
            let sd = self.parse_sub_decl()?;
            Ok(Some(TopLevel::SubDecl(sd)))
            }
            Token::Identifier(w) if w.eq_ignore_ascii_case("INTERFACE") => {
                // INTERFACE Name [DIRECT|IDBIND] ... END INTERFACE — OOP interface block (skip)
                self.advance(); // consume INTERFACE
                if let Token::Identifier(_) = self.peek() {
                    self.advance();
                }
                // optional DIRECT or IDBIND
                if let Token::Identifier(w2) = self.peek() {
                    let up = w2.to_uppercase();
                    if up == "DIRECT" || up == "IDBIND" {
                        self.advance();
                    }
                }
                self.consume_to_eol();
                let mut depth = 1;
                while depth > 0 && self.peek() != &Token::Eof {
                    let is_iface_start = matches!(self.peek(), Token::Identifier(w2) if w2.eq_ignore_ascii_case("INTERFACE"));
                    let is_end = matches!(self.peek(), Token::End);
                    let next_is_iface = matches!(self.peek_at(1), Some(Token::Identifier(w3)) if w3.eq_ignore_ascii_case("INTERFACE"));
                    if is_end && next_is_iface {
                        depth -= 1;
                        self.advance();
                        self.advance();
                        self.consume_to_eol();
                        continue;
                    }
                    if is_iface_start {
                        depth += 1;
                    }
                    self.advance();
                }
                Ok(None)
            }
            Token::Identifier(w) if w.eq_ignore_ascii_case("INSTANCE") => {
                // INSTANCE var AS ClassName — create object instance (simplified)
                self.advance(); // consume INSTANCE
                let _var_name = if let Token::Identifier(vn) = self.peek() {
                    let n = vn.clone();
                    self.advance();
                    n
                } else {
                    String::new()
                };
                // skip AS ClassName
                self.consume_to_eol();
                Ok(None) // simplified: no codegen (variable treated as LONG pointer)
            }
            Token::Identifier(w) if w.eq_ignore_ascii_case("RAISEEVENT") => {
                // RAISEEVENT eventname [(args)] — trigger event (simplified noop)
                self.advance(); // consume RAISEEVENT
                self.consume_to_eol();
                Ok(None)
            }
            Token::Identifier(w) if w.eq_ignore_ascii_case("EVENT") => {
                // EVENT SOURCE id | EVENTS eventname list — simplified noop
                self.advance(); // consume EVENT
                self.consume_to_eol();
                Ok(None)
            }
            Token::Identifier(w) if w.eq_ignore_ascii_case("DEF") => {
                // DEF fnName(params) = expr — single-line function, stored for inline
                self.advance(); // consume DEF
                let fname = self.consume_identifier()?;
                self.expect(&Token::LParen)?;
                let mut params: Vec<String> = Vec::new();
                if self.peek() != &Token::RParen {
                    loop {
                        params.push(self.consume_identifier()?);
                        if self.peek() != &Token::Comma {
                            break;
                        }
                        self.advance();
                    }
                }
                self.expect(&Token::RParen)?;
                self.expect(&Token::Eq)?;
                let body = self.parse_expression()?;
                self.def_funcs.insert(fname.to_uppercase(), (params, body));
                Ok(None)
            }
            Token::HashIf => {
                // Should have been handled by preprocessor, but skip if present
                self.skip_conditional_block();
                Ok(None)
            }
            Token::Identifier(name) => {
                eprintln!(
                    "Error: Parse error at line {}: unrecognized statement/keyword: `{}`",
                    line, name
                );
                self.error_count += 1;
                self.consume_to_eol();
                Ok(None)
            }
            Token::IntegerLiteral(n) => {
                eprintln!(
                    "Error: Parse error at line {}: unexpected number at top level: {}",
                    line, n
                );
                self.error_count += 1;
                self.consume_to_eol();
                Ok(None)
            }
            Token::FloatLiteral(f) => {
                eprintln!(
                    "Error: Parse error at line {}: unexpected number at top level: {}",
                    line, f
                );
                self.error_count += 1;
                self.consume_to_eol();
                Ok(None)
            }
            Token::StringLiteral(s) => {
                eprintln!(
                    "Error: Parse error at line {}: unexpected string at top level: `{}`",
                    line, s
                );
                self.error_count += 1;
                self.consume_to_eol();
                Ok(None)
            }
            _ => {
                // Other unknown tokens, skip silently
                self.consume_to_eol();
                Ok(None)
            }
        }
    }

    /// ASMDATA BlockName / DB|DW|DD|DQ values... / END ASMDATA
    fn parse_asmdata_decl(&mut self, line: usize) -> PbResult<AsmDataDecl> {
        self.advance(); // consume ASMDATA
        let name = match self.peek().clone() {
            Token::Identifier(w) => w.to_uppercase(),
            other => {
                return Err(PbError::parser(
                    format!(
                        "ASMDATA: expected block name after ASMDATA, found {:?}",
                        other
                    ),
                    None,
                    line,
                ))
            }
        };
        self.advance();
        let mut items: Vec<AsmDataItem> = Vec::new();
        loop {
            self.skip_eol();
            if self.at_end() {
                break;
            }
            let tok = self.peek().clone();
            match tok {
                Token::Identifier(w) if w.eq_ignore_ascii_case("DB") => {
                    self.advance();
                    items.push(AsmDataItem::Db(self.parse_asmdata_values(line)?));
                }
                Token::Identifier(w) if w.eq_ignore_ascii_case("DW") => {
                    self.advance();
                    items.push(AsmDataItem::Dw(self.parse_asmdata_values(line)?));
                }
                Token::Identifier(w) if w.eq_ignore_ascii_case("DD") => {
                    self.advance();
                    items.push(AsmDataItem::Dd(self.parse_asmdata_values(line)?));
                }
                Token::Identifier(w) if w.eq_ignore_ascii_case("DQ") => {
                    self.advance();
                    items.push(AsmDataItem::Dq(self.parse_asmdata_values(line)?));
                }
                Token::End => {
                    self.advance();
                    // expect ASMDATA after END
                    if let Token::Identifier(w2) = self.peek().clone() {
                        if w2.eq_ignore_ascii_case("ASMDATA") {
                            self.advance();
                            self.consume_to_eol();
                            break;
                        }
                    }
                    break;
                }
                _ => {
                    // tolerate unknown lines inside the block (skip)
                    self.consume_to_eol();
                }
            }
        }
        Ok(AsmDataDecl { name, items, line })
    }

    fn parse_asmdata_values(&mut self, line: usize) -> PbResult<Vec<AsmDataValue>> {
        let mut values: Vec<AsmDataValue> = Vec::new();
        loop {
            let tok = self.peek().clone();
            match tok {
                Token::IntegerLiteral(n) => {
                    self.advance();
                    values.push(AsmDataValue::Num(n));
                }
                Token::StringLiteral(s) => {
                    self.advance();
                    values.push(AsmDataValue::Str(s));
                }
                Token::Minus => {
                    self.advance();
                    match self.peek().clone() {
                        Token::IntegerLiteral(n) => {
                            self.advance();
                            values.push(AsmDataValue::Num(-n));
                        }
                        _ => break,
                    }
                }
                Token::Comma => {
                    self.advance();
                }
                _ => break,
            }
        }
        if values.is_empty() {
            return Err(PbError::parser(
                "ASMDATA: DB/DW/DD/DQ line needs at least one value",
                None,
                line,
            ));
        }
        Ok(values)
    }

    fn skip_conditional_block(&mut self) {
        let mut depth = 0;
        loop {
            match self.peek() {
                Token::HashIf => {
                    depth += 1;
                    self.advance();
                }
                Token::HashEndIf => {
                    self.advance();
                    depth -= 1;
                    if depth <= 0 {
                        self.consume_to_eol();
                        break;
                    }
                }
                Token::Eof => break,
                _ => {
                    self.advance();
                }
            }
        }
    }

    fn parse_global_decl(&mut self) -> PbResult<Option<TopLevel>> {
        let line = self.current_line();
        self.advance(); // consume GLOBAL

        // Parse first (and possibly only) variable
        let decls = self.parse_global_var_list(line)?;
        self.consume_to_eol();

        if decls.len() == 1 {
            return Ok(Some(TopLevel::GlobalDecl(
                decls.into_iter().next().unwrap(),
            )));
        }
        // Multiple globals on one line: emit as GlobalDeclList
        Ok(Some(TopLevel::GlobalDeclList(decls)))
    }

    fn parse_global_var_list(&mut self, line: usize) -> PbResult<Vec<VarDecl>> {
        let mut decls: Vec<VarDecl> = Vec::new();
        // PB semantics: a trailing AS type-fills the whole list, both
        // back-filling previously untyped names and propagating forward.
        // `GLOBAL a, b AS QUAD` declares both a and b as QUAD.
        let mut pending_type: Option<PbType> = None;
        let mut untyped: Vec<usize> = Vec::new();
        loop {
            let name = self.consume_identifier()?;

            // Check for array declaration: Name() [AS Type]
            if self.peek() == &Token::LParen {
                self.advance(); // (
                self.expect(&Token::RParen)?; // )
                let idx = decls.len();
                let pb_type = if self.peek() == &Token::As {
                    self.advance();
                    let t = self.parse_type()?;
                    for i in &untyped {
                        decls[*i].pb_type = t.clone();
                    }
                    untyped.clear();
                    pending_type = Some(t.clone());
                    t
                } else if let Some(t) = &pending_type {
                    t.clone()
                } else {
                    let t = type_from_suffix(&name);
                    untyped.push(idx);
                    t
                };
                decls.push(VarDecl {
                    name,
                    pb_type,
                    is_array: true,
                    line,
                });
            } else if self.peek() == &Token::As {
                self.advance();
                let t = self.parse_type()?;
                for i in &untyped {
                    decls[*i].pb_type = t.clone();
                }
                untyped.clear();
                pending_type = Some(t.clone());
                decls.push(VarDecl {
                    name,
                    pb_type: t,
                    is_array: false,
                    line,
                });
            } else if let Some(t) = &pending_type {
                decls.push(VarDecl {
                    name,
                    pb_type: t.clone(),
                    is_array: false,
                    line,
                });
            } else {
                // GLOBAL name (no type, infer from suffix)
                let idx = decls.len();
                let pb_type = type_from_suffix(&name);
                untyped.push(idx);
                decls.push(VarDecl {
                    name,
                    pb_type,
                    is_array: false,
                    line,
                });
            }

            // Check for comma-separated additional variables
            if self.peek() == &Token::Comma {
                self.advance();
            } else {
                break;
            }
        }
        Ok(decls)
    }

    fn parse_dim_statement(&mut self, scope: DimScope) -> PbResult<Vec<DimStatement>> {
        let line = self.current_line();
        self.advance(); // consume DIM/LOCAL/STATIC

        // DIM SHARED -> treat as global
        let actual_scope = if self.peek() == &Token::Shared {
            self.advance();
            DimScope::Global
        } else {
            scope
        };

        let mut stmts: Vec<DimStatement> = Vec::new();
        // PB semantics: a trailing AS type-fills the whole list, both
        // back-filling previously untyped names and propagating forward
        // until the next AS. E.g. `DIM a, b AS LONG` → a and b are LONG.
        let mut pending_type: Option<PbType> = None;
        let mut untyped: Vec<usize> = Vec::new();

        loop {
            let name = self.consume_identifier()?;

            // Array bounds
            let mut bounds = Vec::new();
            if self.peek() == &Token::LParen {
                self.advance();
                if self.peek() != &Token::RParen {
                    bounds = self.parse_dim_bounds()?;
                }
                self.expect(&Token::RParen)?;
            }

            let idx = stmts.len();
            let pb_type = if self.peek() == &Token::As {
                self.advance();
                let t = self.parse_type()?;
                for i in &untyped {
                    stmts[*i].pb_type = t.clone();
                }
                untyped.clear();
                pending_type = Some(t.clone());
                t
            } else if let Some(t) = &pending_type {
                t.clone()
            } else {
                let t = type_from_suffix(&name);
                untyped.push(idx);
                t
            };

            stmts.push(DimStatement {
                scope: actual_scope.clone(),
                name,
                pb_type,
                bounds,
                line,
                is_redim: false,
            });

            if self.peek() == &Token::Comma {
                self.advance();
            } else {
                break;
            }
        }

        self.consume_to_eol();
        Ok(stmts)
    }

    fn parse_redim_statement(&mut self) -> PbResult<DimStatement> {
        let line = self.current_line();
        self.advance(); // consume REDIM

        let name = self.consume_identifier()?;

        let mut bounds = Vec::new();
        if self.peek() == &Token::LParen {
            self.advance();
            if self.peek() != &Token::RParen {
                bounds = self.parse_dim_bounds()?;
            }
            self.expect(&Token::RParen)?;
        }

        let pb_type = if self.peek() == &Token::As {
            self.advance();
            self.parse_type()?
        } else {
            let t = type_from_suffix(&name);
            // REDIM without an explicit type: if the name has no type suffix,
            // mark it Variant so codegen can inherit the type declared earlier
            // (e.g. `LOCAL sarr() AS STRING` + `REDIM sarr(1 TO 4)`).
            if has_type_suffix(&name) {
                t
            } else {
                PbType::Variant
            }
        };

        self.consume_to_eol();
        Ok(DimStatement {
            scope: DimScope::Dim,
            name,
            pb_type,
            bounds,
            line,
            is_redim: true,
        })
    }

    fn parse_dim_bounds(&mut self) -> PbResult<Vec<DimBound>> {
        let mut bounds = Vec::new();
        loop {
            let first = self.parse_expression()?;
            // PB supports both TO and : as range separator: DIM arr(1 TO 10) or DIM arr(1:10)
            if self.peek() == &Token::To || self.peek() == &Token::Colon {
                self.advance();
                let upper = self.parse_expression()?;
                bounds.push(DimBound {
                    lower: first,
                    upper,
                });
            } else {
                // Just upper bound, lower is 0
                bounds.push(DimBound {
                    lower: Expr::IntegerLit(0),
                    upper: first,
                });
            }
            if self.peek() == &Token::Comma {
                self.advance();
            } else {
                break;
            }
        }
        Ok(bounds)
    }

    fn parse_type(&mut self) -> PbResult<PbType> {
        let t = self.parse_type_inner()?;
        // PTR suffix: DWORD PTR / ASCIIZ PTR / LONG PTR — x64 pointers are 64-bit
        if let Token::Identifier(s) = self.peek() {
            if s.eq_ignore_ascii_case("PTR") {
                self.advance();
                return Ok(PbType::Quad);
            }
        }
        // Bare PTR (already consumed as UserDefined("PTR"))
        if let PbType::UserDefined(n) = &t {
            if n.eq_ignore_ascii_case("PTR") {
                return Ok(PbType::Quad);
            }
        }
        Ok(t)
    }

    fn parse_type_inner(&mut self) -> PbResult<PbType> {
        // Skip LOCAL keyword if present (PB allows DIM arr() AS LOCAL STRING)
        if self.peek() == &Token::Local {
            self.advance();
        }
        match self.peek().clone() {
            Token::Long => {
                self.advance();
                Ok(PbType::Long)
            }
            Token::Identifier(w) if w.eq_ignore_ascii_case("OBJECT") => {
                self.advance();
                Ok(PbType::Long) // OBJECT = COM object pointer (simplified as LONG)
            }
            Token::Identifier(w) if w.eq_ignore_ascii_case("WSTRING") => {
                self.advance();
                Ok(PbType::String) // WSTRING = STRING alias (UTF-16 not yet modeled)
            }
            Token::Integer => {
                self.advance();
                Ok(PbType::Integer)
            }
            Token::Double => {
                self.advance();
                Ok(PbType::Double)
            }
            Token::Single => {
                self.advance();
                Ok(PbType::Single)
            }
            Token::String_ => {
                self.advance();
                // Check for STRING * N (fixed string)
                if self.peek() == &Token::Star {
                    self.advance();
                    if let Token::IntegerLiteral(n) = self.peek().clone() {
                        self.advance();
                        return Ok(PbType::FixedString(n as usize));
                    }
                }
                Ok(PbType::String)
            }
            Token::Quad => {
                self.advance();
                Ok(PbType::Quad)
            }
            Token::Dword => {
                self.advance();
                Ok(PbType::Dword)
            }
            Token::Ext => {
                self.advance();
                Ok(PbType::Ext)
            }
            Token::Cur => {
                self.advance();
                Ok(PbType::Cur)
            }
            Token::Identifier(ref s) => {
                let upper = s.to_uppercase();
                match upper.as_str() {
                    "BYTE" => {
                        self.advance();
                        Ok(PbType::Byte)
                    }
                    "WORD" => {
                        self.advance();
                        Ok(PbType::Word)
                    }
                    "CURRENCY" | "CUR" => {
                        self.advance();
                        Ok(PbType::Cur)
                    }
                    "ASCIIZ" | "ASCIZ" => {
                        self.advance();
                        // ASCIIZ * N — fixed-size null-terminated string
                        if self.peek() == &Token::Star {
                            self.advance();
                            if let Token::IntegerLiteral(n) = self.peek().clone() {
                                self.advance();
                                return Ok(PbType::FixedString(n as usize));
                            }
                        }
                        Ok(PbType::FixedString(260)) // default ASCIIZ size
                    }
                    "FIELD" => {
                        self.advance();
                        Ok(PbType::Field)
                    }
                    _ => {
                        let name = s.clone();
                        self.advance();
                        Ok(PbType::UserDefined(name))
                    }
                }
            }
            _ => {
                // Default
                Ok(PbType::Variant)
            }
        }
    }

    fn parse_percent_const_decl(&mut self, line: usize) -> PbResult<ConstDecl> {
        let name = match self.peek().clone() {
            Token::PercentConstant(s) => {
                self.advance();
                s
            }
            _ => {
                return Err(PbError::parser(
                    "Expected %CONSTANT",
                    self.current_file(),
                    line,
                ))
            }
        };
        self.expect(&Token::Eq)?;
        let value = self.parse_expression()?;
        self.consume_to_eol();
        Ok(ConstDecl { name, value, line })
    }

    fn parse_type_decl(&mut self, line: usize) -> PbResult<TypeDecl> {
        self.advance(); // TYPE
        let name = self.consume_identifier()?;
        self.consume_to_eol();
        self.skip_eol();

        let mut fields = Vec::new();
        loop {
            if self.peek() == &Token::End {
                self.advance();
                // END TYPE
                if self.peek() == &Token::Type {
                    self.advance();
                }
                self.consume_to_eol();
                break;
            }
            if self.at_end() {
                break;
            }

            // Parse field: name AS type
            let fname = self.consume_identifier()?;
            self.expect(&Token::As)?;
            let ftype = self.parse_type()?;
            fields.push(TypeField {
                name: fname,
                pb_type: ftype,
            });
            self.consume_to_eol();
            self.skip_eol();
        }

        Ok(TypeDecl { name, fields, line })
    }

    fn parse_sub_decl(&mut self) -> PbResult<SubDecl> {
        let line = self.current_line();
        self.advance(); // SUB
        let name = self.consume_identifier()?;

        // Optional: CALLBACK keyword after name (treat as decoration)
        if self.peek() == &Token::Callback {
            self.advance();
        }

        // Optional: CDECL/STDCALL calling convention (skip)
        while matches!(self.peek(), Token::Identifier(ref s) if {
            let u = s.to_uppercase();
            u == "CDECL" || u == "STDCALL" || u == "BDECL"
        }) {
            self.advance();
        }

        // Optional ALIAS "ExternalName"
        let alias = if self.peek() == &Token::Alias {
            self.advance();
            match self.peek().clone() {
                Token::StringLiteral(s) => {
                    self.advance();
                    Some(s)
                }
                _ => None,
            }
        } else {
            None
        };

        let params = if self.peek() == &Token::LParen {
            self.advance();
            let p = self.parse_params()?;
            self.expect(&Token::RParen)?;
            p
        } else {
            Vec::new()
        };

        // Optional EXPORT keyword
        let export = if self.peek() == &Token::Export {
            self.advance();
            true
        } else {
            false
        };

        self.consume_to_eol();
        let body = self.parse_body(&[BodyEnd::EndSub])?;

        Ok(SubDecl {
            name,
            params,
            body,
            alias,
            export,
            line,
        })
    }

    fn parse_function_decl(&mut self) -> PbResult<FunctionDecl> {
        let line = self.current_line();
        self.advance(); // FUNCTION
        let name = self.consume_identifier()?;

        // Optional: CDECL/STDCALL calling convention (skip)
        while matches!(self.peek(), Token::Identifier(ref s) if {
            let u = s.to_uppercase();
            u == "CDECL" || u == "STDCALL" || u == "BDECL"
        }) {
            self.advance();
        }

        // Optional ALIAS "ExternalName"
        let alias = if self.peek() == &Token::Alias {
            self.advance();
            match self.peek().clone() {
                Token::StringLiteral(s) => {
                    self.advance();
                    Some(s)
                }
                _ => None,
            }
        } else {
            None
        };

        let params = if self.peek() == &Token::LParen {
            self.advance();
            let p = if self.peek() == &Token::RParen {
                Vec::new()
            } else {
                self.parse_params()?
            };
            self.expect(&Token::RParen)?;
            p
        } else {
            Vec::new()
        };

        // Optional EXPORT keyword — comes BEFORE the AS return type in PB:
        //   FUNCTION Foo (x AS LONG) EXPORT AS STRING
        let export = if self.peek() == &Token::Export {
            self.advance();
            true
        } else {
            false
        };

        let return_type = if self.peek() == &Token::As {
            self.advance();
            self.parse_type()?
        } else {
            type_from_suffix(&name)
        };

        self.consume_to_eol();
        let body = self.parse_body(&[BodyEnd::EndFunction])?;

        Ok(FunctionDecl {
            name,
            params,
            return_type,
            body,
            alias,
            export,
            line,
        })
    }

    fn parse_params(&mut self) -> PbResult<Vec<Param>> {
        let mut params = Vec::new();
        loop {
            if self.peek() == &Token::RParen || self.at_end() {
                break;
            }

            let mut is_byval = false;
            let mut is_optional = false;

            // OPTIONAL, BYVAL, BYREF modifiers
            loop {
                match self.peek() {
                    Token::Optional => {
                        is_optional = true;
                        self.advance();
                    }
                    Token::Byval => {
                        is_byval = true;
                        self.advance();
                    }
                    Token::Byref => {
                        self.advance(); // BYREF is default
                    }
                    _ => break,
                }
            }

            let name = self.consume_identifier()?;
            let is_array = if self.peek() == &Token::LParen {
                self.advance();
                self.expect(&Token::RParen)?;
                true
            } else {
                false
            };

            let pb_type = if self.peek() == &Token::As {
                self.advance();
                self.parse_type()?
            } else {
                type_from_suffix(&name)
            };

            params.push(Param {
                name,
                pb_type,
                is_byval,
                is_optional,
                is_array,
            });

            if self.peek() == &Token::Comma {
                self.advance();
            } else {
                break;
            }
        }
        Ok(params)
    }

    fn parse_declare_stmt(&mut self, line: usize) -> PbResult<Option<DeclareStmt>> {
        self.advance(); // consume DECLARE

        // Optional CALLBACK keyword (treat as decoration)
        if self.peek() == &Token::Callback {
            self.advance();
        }

        // SUB or FUNCTION
        let is_function = match self.peek() {
            Token::Function => {
                self.advance();
                true
            }
            Token::Sub => {
                self.advance();
                false
            }
            _ => {
                self.consume_to_eol();
                return Ok(None);
            }
        };

        let name = self.consume_identifier()?;

        // Optional: CDECL, STDCALL, etc. — skip any identifier that's a calling convention
        while matches!(self.peek(), Token::Identifier(ref s) if {
            let u = s.to_uppercase();
            u == "CDECL" || u == "STDCALL" || u == "BDECL"
        }) {
            self.advance();
        }

        // Optional LIB "dll.dll"
        let lib = if self.peek() == &Token::Lib {
            self.advance();
            match self.peek().clone() {
                Token::StringLiteral(s) => {
                    self.advance();
                    Some(s)
                }
                _ => None,
            }
        } else {
            None
        };

        // Optional ALIAS "ExternalName"
        let alias = if self.peek() == &Token::Alias {
            self.advance();
            match self.peek().clone() {
                Token::StringLiteral(s) => {
                    self.advance();
                    Some(s)
                }
                _ => None,
            }
        } else {
            None
        };

        // Optional parameter list
        let params = if self.peek() == &Token::LParen {
            self.advance();
            let p = if self.peek() == &Token::RParen {
                Vec::new()
            } else {
                self.parse_params()?
            };
            self.expect(&Token::RParen)?;
            p
        } else {
            Vec::new()
        };

        // Optional AS type (for FUNCTION)
        let return_type = if is_function && self.peek() == &Token::As {
            self.advance();
            self.parse_type()?
        } else if is_function {
            type_from_suffix(&name)
        } else {
            PbType::Variant // SUB has no return type
        };

        self.consume_to_eol();

        Ok(Some(DeclareStmt {
            name,
            is_function,
            params,
            return_type,
            lib,
            alias,
            line,
        }))
    }

    // ===== Body parsing (inside SUB/FUNCTION) =====

    fn parse_body(&mut self, terminators: &[BodyEnd]) -> PbResult<Vec<Statement>> {
        self.parse_body_with_terminator(terminators)
            .map(|(stmts, _)| stmts)
    }

    /// Like parse_body but also returns which terminator was matched (if any).
    fn parse_body_with_terminator(
        &mut self,
        terminators: &[BodyEnd],
    ) -> PbResult<(Vec<Statement>, Option<BodyEnd>)> {
        let mut stmts = Vec::new();
        self.skip_eol();

        let mut matched_terminator = None;

        loop {
            if self.at_end() {
                break;
            }

            // Check for terminators
            if let Some(t) = self.which_terminator(terminators) {
                self.consume_terminator(terminators);
                matched_terminator = Some(t);
                break;
            }

            self.skip_eol();
            if self.at_end() {
                break;
            }
            if let Some(t) = self.which_terminator(terminators) {
                self.consume_terminator(terminators);
                matched_terminator = Some(t);
                break;
            }

            // Safety: break on END SUB/END FUNCTION even if not in our terminator
            // list — this indicates we've overrun into a parent scope (e.g., a CASE
            // body encountering the enclosing function's END SUB).
            if self.peek() == &Token::End {
                match self.peek_at(1) {
                    Some(&Token::Sub) | Some(&Token::Function)
                        if !terminators
                            .iter()
                            .any(|t| matches!(t, BodyEnd::EndSub | BodyEnd::EndFunction)) =>
                    {
                        break; // don't consume, let parent handle it
                    }
                    _ => {}
                }
            }

            // Safety: if we see a top-level declaration keyword that shouldn't
            // be inside a body, break out to avoid consuming the rest of the file.
            if self.is_top_level_keyword() {
                break;
            }

            let saved_pos = self.pos;
            match self.parse_statement() {
                Ok(stmt) => stmts.push(stmt),
                Err(e) => {
                    eprintln!("Error: Parse error: {}", e);
                    self.error_count += 1;
                    self.consume_to_eol();
                }
            }

            self.skip_eol();

            // Safety: if no progress was made, force advance to prevent infinite loops.
            if self.pos == saved_pos {
                self.advance();
            }
        }

        Ok((stmts, matched_terminator))
    }

    /// Check if current position looks like a top-level declaration that shouldn't be inside a body
    fn is_top_level_keyword(&self) -> bool {
        match self.peek() {
            Token::Sub => {
                // SUB followed by identifier = new sub declaration
                matches!(self.peek_at(1), Some(Token::Identifier(_)))
            }
            Token::Function => {
                // FUNCTION followed by identifier (not =) = new function declaration
                match self.peek_at(1) {
                    Some(Token::Eq) => false,           // FUNCTION = expr (return value)
                    Some(Token::Identifier(_)) => true, // New function declaration
                    _ => false,
                }
            }
            Token::Declare => true,
            Token::Type => {
                // TYPE at start of line (new type decl, not inside body).
                // TYPE SET (statement) is NOT a top-level keyword.
                match self.peek_at(1) {
                    Some(Token::Identifier(w)) if w.to_uppercase() == "SET" => false,
                    Some(Token::Identifier(_)) => true,
                    _ => false,
                }
            }
            _ => false,
        }
    }

    fn which_terminator(&self, terminators: &[BodyEnd]) -> Option<BodyEnd> {
        for t in terminators {
            if self.matches_terminator(t) {
                return Some(*t);
            }
        }
        None
    }

    fn matches_terminator(&self, term: &BodyEnd) -> bool {
        match term {
            BodyEnd::EndSub => self.peek() == &Token::End && self.peek_at(1) == Some(&Token::Sub),
            BodyEnd::EndFunction => {
                self.peek() == &Token::End && self.peek_at(1) == Some(&Token::Function)
            }
            BodyEnd::EndIf => self.peek() == &Token::End && self.peek_at(1) == Some(&Token::If),
            BodyEnd::Else => self.peek() == &Token::Else,
            BodyEnd::ElseIf => self.peek() == &Token::ElseIf,
            BodyEnd::Next => self.peek() == &Token::Next,
            BodyEnd::Loop => self.peek() == &Token::Loop,
            BodyEnd::Wend => self.peek() == &Token::Wend,
            BodyEnd::EndSelect => {
                self.peek() == &Token::End && self.peek_at(1) == Some(&Token::Select)
            }
            BodyEnd::Case => self.peek() == &Token::Case,
            BodyEnd::CaseElse => {
                self.peek() == &Token::Case && self.peek_at(1) == Some(&Token::Else)
            }
        }
    }

    fn consume_terminator(&mut self, terminators: &[BodyEnd]) {
        for t in terminators {
            if self.matches_terminator(t) {
                match t {
                    BodyEnd::EndSub | BodyEnd::EndFunction | BodyEnd::EndIf => {
                        self.advance(); // END
                        self.advance(); // SUB/FUNCTION/IF
                        self.consume_to_eol();
                    }
                    BodyEnd::EndSelect
                    | BodyEnd::Else
                    | BodyEnd::ElseIf
                    | BodyEnd::Next
                    | BodyEnd::Loop
                    | BodyEnd::Wend
                    | BodyEnd::Case
                    | BodyEnd::CaseElse => {
                        // Don't consume — caller needs to see it
                    }
                }
                return;
            }
        }
    }

    fn peek_at(&self, offset: usize) -> Option<&Token> {
        self.tokens.get(self.pos + offset).map(|t| &t.token)
    }

    fn parse_data_items(&mut self) -> Vec<String> {
        let mut items = Vec::new();
        loop {
            match self.peek().clone() {
                Token::StringLiteral(s) => {
                    items.push(s);
                    self.advance();
                }
                Token::IntegerLiteral(n) => {
                    items.push(n.to_string());
                    self.advance();
                }
                Token::FloatLiteral(f) => {
                    items.push(f.to_string());
                    self.advance();
                }
                Token::Identifier(s) => {
                    items.push(s);
                    self.advance();
                }
                Token::Minus => {
                    self.advance();
                    match self.peek().clone() {
                        Token::IntegerLiteral(n) => {
                            items.push(format!("-{}", n));
                            self.advance();
                        }
                        Token::FloatLiteral(f) => {
                            items.push(format!("-{}", f));
                            self.advance();
                        }
                        _ => items.push("-".to_string()),
                    }
                }
                _ => break,
            }
            if self.at_eol_or_eof() {
                break;
            }
            if self.peek() == &Token::Comma {
                self.advance();
            } else {
                break;
            }
        }
        items
    }

    /// LISTVIEW <sub-command> ...  -- batch 158 (common control, Tier-3 DDT GUI)
    ///
    /// Syntax per the official PowerBASIC documentation. Sub-commands
    /// implemented here:
    ///   LISTVIEW RESET          hDlg, id&
    ///   LISTVIEW GET COUNT      hDlg, id& TO datav&
    ///   LISTVIEW GET TEXT       hDlg, id&, item&, col& TO txtv$
    ///   LISTVIEW SET TEXT       hDlg, id&, item&, col&, StrExpr
    ///   LISTVIEW INSERT COLUMN  hDlg, id&, col&, StrExpr, ColWidth&, format&
    ///   LISTVIEW INSERT ITEM    hDlg, id&, item&, image&, StrExpr
    ///   LISTVIEW DELETE ITEM    hDlg, id&, item&
    fn parse_listview_statement(&mut self, line: usize) -> PbResult<Statement> {
        self.advance(); // consume LISTVIEW
        let sub = self.peek_plain_upper();
        match sub.as_str() {
            "RESET" => {
                self.advance();
                let h = self.parse_expression()?;
                self.expect(&Token::Comma)?;
                let id = self.parse_expression()?;
                self.consume_to_eol();
                Ok(Statement::Call(CallStmt {
                    name: "LISTVIEW_RESET".to_string(),
                    args: vec![h, id],
                    line,
                }))
            }
            "GET" => {
                self.advance();
                let what = self.peek_plain_upper();
                self.advance();
                if what == "COUNT" {
                    let h = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let id = self.parse_expression()?;
                    if self.peek() == &Token::To {
                        self.advance();
                    }
                    let target = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "LISTVIEW_GET_COUNT".to_string(),
                        args: vec![h, id, target],
                        line,
                    }));
                }
                if what == "TEXT" {
                    let h = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let id = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let item = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let col = self.parse_expression()?;
                    if self.peek() == &Token::To {
                        self.advance();
                    }
                    let target = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "LISTVIEW_GET_TEXT".to_string(),
                        args: vec![h, id, item, col, target],
                        line,
                    }));
                }
                self.consume_to_eol();
                Ok(Statement::Noop("LISTVIEW GET".to_string(), line))
            }
            "SET" => {
                self.advance();
                let what = self.peek_plain_upper();
                self.advance();
                if what == "TEXT" {
                    let h = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let id = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let item = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let col = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let text = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "LISTVIEW_SET_TEXT".to_string(),
                        args: vec![h, id, item, col, text],
                        line,
                    }));
                }
                self.consume_to_eol();
                Ok(Statement::Noop("LISTVIEW SET".to_string(), line))
            }
            "INSERT" => {
                self.advance();
                let what = self.peek_plain_upper();
                self.advance();
                if what == "COLUMN" {
                    let h = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let id = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let col = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let text = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let width = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let fmt = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "LISTVIEW_INSERT_COLUMN".to_string(),
                        args: vec![h, id, col, text, width, fmt],
                        line,
                    }));
                }
                if what == "ITEM" {
                    let h = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let id = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let item = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let image = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let text = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "LISTVIEW_INSERT_ITEM".to_string(),
                        args: vec![h, id, item, image, text],
                        line,
                    }));
                }
                self.consume_to_eol();
                Ok(Statement::Noop("LISTVIEW INSERT".to_string(), line))
            }
            "DELETE" => {
                self.advance();
                let what = self.peek_plain_upper();
                self.advance();
                if what == "ITEM" {
                    let h = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let id = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let item = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "LISTVIEW_DELETE_ITEM".to_string(),
                        args: vec![h, id, item],
                        line,
                    }));
                }
                self.consume_to_eol();
                Ok(Statement::Noop("LISTVIEW DELETE".to_string(), line))
            }
            _ => {
                self.consume_to_eol();
                Ok(Statement::Noop("LISTVIEW".to_string(), line))
            }
        }
    }

    /// TREEVIEW <sub-command> ...  -- batch 158 (common control, Tier-3 DDT GUI)
    ///
    /// Syntax per the official PowerBASIC documentation. Sub-commands
    /// implemented here:
    ///   TREEVIEW RESET        hDlg, id&
    ///   TREEVIEW GET COUNT    hDlg, id& TO datav&
    ///   TREEVIEW GET TEXT     hDlg, id&, hItem TO txtv$
    ///   TREEVIEW INSERT ITEM  hDlg, id&, hPrnt, hIAftr, image&, simage&, txt$ TO hItem
    ///   TREEVIEW DELETE       hDlg, id&, hItem
    fn parse_treeview_statement(&mut self, line: usize) -> PbResult<Statement> {
        self.advance(); // consume TREEVIEW
        let sub = self.peek_plain_upper();
        match sub.as_str() {
            "RESET" => {
                self.advance();
                let h = self.parse_expression()?;
                self.expect(&Token::Comma)?;
                let id = self.parse_expression()?;
                self.consume_to_eol();
                Ok(Statement::Call(CallStmt {
                    name: "TREEVIEW_RESET".to_string(),
                    args: vec![h, id],
                    line,
                }))
            }
            "GET" => {
                self.advance();
                let what = self.peek_plain_upper();
                self.advance();
                if what == "COUNT" {
                    let h = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let id = self.parse_expression()?;
                    if self.peek() == &Token::To {
                        self.advance();
                    }
                    let target = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "TREEVIEW_GET_COUNT".to_string(),
                        args: vec![h, id, target],
                        line,
                    }));
                }
                if what == "TEXT" {
                    let h = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let id = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let item = self.parse_expression()?;
                    if self.peek() == &Token::To {
                        self.advance();
                    }
                    let target = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "TREEVIEW_GET_TEXT".to_string(),
                        args: vec![h, id, item, target],
                        line,
                    }));
                }
                self.consume_to_eol();
                Ok(Statement::Noop("TREEVIEW GET".to_string(), line))
            }
            "INSERT" => {
                self.advance();
                let what = self.peek_plain_upper();
                self.advance();
                if what == "ITEM" {
                    let h = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let id = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let hparent = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let hafter = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let image = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let simage = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let text = self.parse_expression()?;
                    if self.peek() == &Token::To {
                        self.advance();
                    }
                    let target = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "TREEVIEW_INSERT_ITEM".to_string(),
                        args: vec![h, id, hparent, hafter, image, simage, text, target],
                        line,
                    }));
                }
                self.consume_to_eol();
                Ok(Statement::Noop("TREEVIEW INSERT".to_string(), line))
            }
            "DELETE" => {
                self.advance();
                let h = self.parse_expression()?;
                self.expect(&Token::Comma)?;
                let id = self.parse_expression()?;
                self.expect(&Token::Comma)?;
                let item = self.parse_expression()?;
                self.consume_to_eol();
                Ok(Statement::Call(CallStmt {
                    name: "TREEVIEW_DELETE".to_string(),
                    args: vec![h, id, item],
                    line,
                }))
            }
            _ => {
                self.consume_to_eol();
                Ok(Statement::Noop("TREEVIEW".to_string(), line))
            }
        }
    }

    fn parse_statement(&mut self) -> PbResult<Statement> {
        self.skip_eol();
        let line = self.current_line();

        match self.peek().clone() {
            Token::If => self.parse_if_statement(),
            Token::For => self.parse_for_statement(),
            Token::Do => self.parse_do_loop(),
            Token::While => self.parse_while_wend(),
            Token::Select => self.parse_select_case(),
            Token::Print => self.parse_print_statement(),
            Token::Input => {
                self.advance(); // consume INPUT
                                // INPUT FLUSH — discard buffered console input
                if let Token::Identifier(s) = self.peek() {
                    if s.eq_ignore_ascii_case("FLUSH") {
                        self.advance();
                        self.consume_to_eol();
                        return Ok(Statement::InputFlush);
                    }
                }
                // INPUT #filenum, var1, var2, ...
                if self.peek() == &Token::Hash {
                    self.advance(); // consume #
                    let file_num = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let mut vars = Vec::new();
                    vars.push(self.parse_expression()?);
                    while self.peek() == &Token::Comma {
                        self.advance();
                        vars.push(self.parse_expression()?);
                    }
                    self.consume_to_eol();
                    return Ok(Statement::InputFile(InputFileStmt {
                        file_num,
                        vars,
                        line,
                    }));
                }
                // Plain INPUT (console) — read from stdin
                let mut prompt = None;
                let mut no_newline = false;
                // optional leading ; means no newline
                if self.peek() == &Token::Semicolon {
                    no_newline = true;
                    self.advance();
                }
                // optional prompt string
                if let Token::StringLiteral(_) = self.peek() {
                    prompt = Some(self.parse_expression()?);
                    if self.peek() == &Token::Semicolon || self.peek() == &Token::Comma {
                        self.advance();
                    }
                }
                // variable list
                let mut vars = Vec::new();
                vars.push(self.parse_expression()?);
                while self.peek() == &Token::Comma {
                    self.advance();
                    vars.push(self.parse_expression()?);
                }
                self.consume_to_eol();
                Ok(Statement::InputConsole(InputConsoleStmt {
                    prompt,
                    no_newline,
                    vars,
                    line,
                }))
            }
            Token::Open => self.parse_open_statement(),
            Token::Close => self.parse_close_statement(),
            Token::Call => {
                self.advance();
                // CALL DWORD TargetPtr [USING proto(args)] [TO result]
                if let Token::Identifier(w) = self.peek() {
                    if w.to_uppercase() == "DWORD" {
                        return self.parse_call_dword(line);
                    }
                }
                if matches!(self.peek(), Token::Dword) {
                    return self.parse_call_dword(line);
                }
                let name = self.consume_identifier()?;
                let args = if self.peek() == &Token::LParen {
                    self.advance();
                    let a = self.parse_arg_list()?;
                    self.expect(&Token::RParen)?;
                    a
                } else {
                    Vec::new()
                };
                self.consume_to_eol();
                Ok(Statement::Call(CallStmt { name, args, line }))
            }
            Token::Incr => {
                self.advance();
                let target = self.parse_expression()?;
                let amount = if self.peek() == &Token::Comma {
                    self.advance();
                    Some(self.parse_expression()?)
                } else {
                    None
                };
                self.consume_to_eol();
                Ok(Statement::Incr(IncrDecrStmt {
                    target,
                    amount,
                    line,
                }))
            }
            Token::Decr => {
                self.advance();
                let target = self.parse_expression()?;
                let amount = if self.peek() == &Token::Comma {
                    self.advance();
                    Some(self.parse_expression()?)
                } else {
                    None
                };
                self.consume_to_eol();
                Ok(Statement::Decr(IncrDecrStmt {
                    target,
                    amount,
                    line,
                }))
            }
            Token::Exit => {
                self.advance();
                let stmt = match self.peek() {
                    Token::Sub => {
                        self.advance();
                        Statement::ExitSub
                    }
                    Token::Function => {
                        self.advance();
                        Statement::ExitFunction
                    }
                    Token::For => {
                        self.advance();
                        Statement::ExitFor
                    }
                    Token::Do => {
                        self.advance();
                        Statement::ExitDo
                    }
                    Token::Select => {
                        self.advance();
                        Statement::ExitSelect
                    }
                    // EXIT TRY (batch 26)
                    Token::Identifier(ref kw) if kw.eq_ignore_ascii_case("TRY") => {
                        self.advance();
                        Statement::ExitTry
                    }
                    _ => Statement::ExitSub,
                };
                self.consume_to_eol();
                Ok(stmt)
            }
            Token::Function => {
                // FUNCTION = expr (return value)
                self.advance();
                self.expect(&Token::Eq)?;
                let value = self.parse_expression()?;
                self.consume_to_eol();
                Ok(Statement::FunctionReturn(FunctionReturnStmt {
                    value,
                    line,
                }))
            }
            Token::Local => {
                let dims = self.parse_local_decl()?;
                if dims.len() == 1 {
                    Ok(Statement::Dim(dims.into_iter().next().unwrap()))
                } else {
                    Ok(Statement::Block(
                        dims.into_iter().map(Statement::Dim).collect(),
                    ))
                }
            }
            // REGISTER var [AS type] [, ...] 鈥?optimization hint; accepted as LOCAL
            Token::Register => {
                let dims = self.parse_local_decl()?;
                if dims.len() == 1 {
                    Ok(Statement::Dim(dims.into_iter().next().unwrap()))
                } else {
                    Ok(Statement::Block(
                        dims.into_iter().map(Statement::Dim).collect(),
                    ))
                }
            }
            // Inline assembly shortcut: ! opcode ... (raw text captured by lexer)
            Token::AsmText(text) => {
                let t = text.clone();
                self.advance();
                Ok(Statement::Asm(t))
            }
            Token::Dim => {
                let dims = self.parse_dim_statement(DimScope::Dim)?;
                if dims.len() == 1 {
                    Ok(Statement::Dim(dims.into_iter().next().unwrap()))
                } else {
                    Ok(Statement::Block(
                        dims.into_iter().map(Statement::Dim).collect(),
                    ))
                }
            }
            Token::Redim => {
                let dim = self.parse_redim_statement()?;
                Ok(Statement::Redim(dim))
            }
            Token::Static => {
                let dims = self.parse_dim_statement(DimScope::Static)?;
                if dims.len() == 1 {
                    Ok(Statement::Dim(dims.into_iter().next().unwrap()))
                } else {
                    Ok(Statement::Block(
                        dims.into_iter().map(Statement::Dim).collect(),
                    ))
                }
            }
            Token::Threaded => {
                let dims = self.parse_dim_statement(DimScope::Threaded)?;
                if dims.len() == 1 {
                    Ok(Statement::Dim(dims.into_iter().next().unwrap()))
                } else {
                    Ok(Statement::Block(
                        dims.into_iter().map(Statement::Dim).collect(),
                    ))
                }
            }
            Token::Type => {
                // TYPE SET dest = src : copy bytes into a TYPE variable
                if matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase() == "SET")
                {
                    self.advance(); // consume TYPE
                    self.advance(); // consume SET
                                    // parse_primary (not parse_expression): `dest = src` must not be
                                    // swallowed as an Eq comparison expression
                    let dest = self.parse_primary()?;
                    self.expect(&Token::Eq)?;
                    let src = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "TYPE SET".to_string(),
                        args: vec![dest, src],
                        line,
                    }));
                }
                // Bare TYPE (no SET) inside a body: skip the line
                self.consume_to_eol();
                Ok(Statement::Noop("TYPE".to_string(), line))
            }
            Token::Global => {
                // GLOBAL inside a sub (shouldn't happen but handle gracefully)
                let dims = self.parse_dim_statement(DimScope::Global)?;
                if dims.len() == 1 {
                    Ok(Statement::Dim(dims.into_iter().next().unwrap()))
                } else {
                    Ok(Statement::Block(
                        dims.into_iter().map(Statement::Dim).collect(),
                    ))
                }
            }
            Token::On => {
                self.advance();
                // ON ERROR GOTO label
                if self.peek() == &Token::Error {
                    self.advance();
                    if self.peek() == &Token::GoTo {
                        self.advance();
                        if let Token::IntegerLiteral(0) = self.peek() {
                            self.advance();
                            self.consume_to_eol();
                            return Ok(Statement::OnErrorGotoZero);
                        }
                        let label = match self.peek().clone() {
                            Token::Identifier(s) => {
                                self.advance();
                                s
                            }
                            Token::IntegerLiteral(n) => {
                                self.advance();
                                n.to_string()
                            }
                            _ => {
                                self.consume_to_eol();
                                return Ok(Statement::Noop("ON ERROR GOTO".to_string(), line));
                            }
                        };
                        self.consume_to_eol();
                        return Ok(Statement::OnErrorGoto(label));
                    }
                    // ON ERROR RESUME NEXT 鈥?disable error trapping
                    if matches!(self.peek(), Token::Resume) || self.peek_plain_upper() == "RESUME" {
                        self.advance();
                        self.consume_to_eol();
                        return Ok(Statement::OnErrorGotoZero);
                    }
                }
                // ON expr GOTO label1, label2, ... / ON expr GOSUB ... / ON expr CALL proc() ...
                let expr = self.parse_expression()?;
                if self.peek() == &Token::Call {
                    // ON expr CALL Procedure() [, Function() TO RetVar] ...
                    self.advance(); // consume CALL
                    let mut targets: Vec<OnCallTarget> = Vec::new();
                    loop {
                        let name = self.consume_identifier()?;
                        let args = if self.peek() == &Token::LParen {
                            self.advance();
                            let a = self.parse_arg_list()?;
                            self.expect(&Token::RParen)?;
                            a
                        } else {
                            Vec::new()
                        };
                        let mut ret_var = None;
                        if self.peek() == &Token::To
                            || matches!(self.peek(), Token::Identifier(id) if id.eq_ignore_ascii_case("TO"))
                        {
                            self.advance();
                            ret_var = Some(self.consume_identifier()?);
                        }
                        targets.push(OnCallTarget {
                            name,
                            args,
                            ret_var,
                        });
                        if self.peek() == &Token::Comma {
                            self.advance();
                        } else {
                            break;
                        }
                    }
                    self.consume_to_eol();
                    if targets.is_empty() {
                        return Ok(Statement::Noop("ON CALL".to_string(), line));
                    }
                    return Ok(Statement::OnCall {
                        expr: Box::new(expr),
                        targets,
                    });
                }
                let is_gosub = match self.peek() {
                    Token::GoTo => {
                        self.advance();
                        false
                    }
                    Token::GoSub => {
                        self.advance();
                        true
                    }
                    _ => {
                        self.consume_to_eol();
                        return Ok(Statement::Noop("ON".to_string(), line));
                    }
                };
                let mut labels: Vec<String> = Vec::new();
                loop {
                    match self.peek().clone() {
                        Token::Identifier(s) => {
                            self.advance();
                            labels.push(s);
                        }
                        Token::IntegerLiteral(n) => {
                            self.advance();
                            labels.push(n.to_string());
                        }
                        _ => break,
                    }
                    if self.peek() == &Token::Comma {
                        self.advance();
                    } else {
                        break;
                    }
                }
                self.consume_to_eol();
                if labels.is_empty() {
                    return Ok(Statement::Noop("ON GOTO/GOSUB".to_string(), line));
                }
                if is_gosub {
                    Ok(Statement::OnGoSub {
                        expr: Box::new(expr),
                        labels,
                    })
                } else {
                    Ok(Statement::OnGoTo {
                        expr: Box::new(expr),
                        labels,
                    })
                }
            }
            Token::Error => {
                // ERROR n — set the PB error code (readable via ERR)
                self.advance(); // consume ERROR
                let args = if !self.at_eol_or_eof() {
                    vec![self.parse_expression()?]
                } else {
                    Vec::new()
                };
                self.consume_to_eol();
                Ok(Statement::Call(CallStmt {
                    name: "ERROR".to_string(),
                    args,
                    line,
                }))
            }
            Token::Replace => {
                // REPLACE old$ WITH new$ IN target$
                self.advance();
                let old = self.parse_expression()?;
                if matches!(self.peek(), Token::Identifier(id) if id.eq_ignore_ascii_case("WITH")) {
                    self.advance();
                }
                let new_s = self.parse_expression()?;
                if matches!(self.peek(), Token::Identifier(id) if id.eq_ignore_ascii_case("IN")) {
                    self.advance();
                }
                let target = self.parse_expression()?;
                self.consume_to_eol();
                Ok(Statement::Call(CallStmt {
                    name: "REPLACE".to_string(),
                    args: vec![target, old, new_s],
                    line,
                }))
            }
            Token::Remove => {
                // REMOVE$ is usually a function but REMOVE can be a statement
                self.advance();
                self.consume_to_eol();
                Ok(Statement::Noop("REMOVE".to_string(), line))
            }
            Token::Resume => {
                self.advance();
                // RESUME NEXT
                if matches!(self.peek(), Token::Next) || self.peek_plain_upper() == "NEXT" {
                    self.advance();
                    self.consume_to_eol();
                    return Ok(Statement::ResumeNext);
                }
                // RESUME FLUSH
                if self.peek_plain_upper() == "FLUSH" {
                    self.advance();
                    self.consume_to_eol();
                    return Ok(Statement::ResumeFlush);
                }
                // RESUME label / line_number
                match self.peek().clone() {
                    Token::Identifier(s) => {
                        self.advance();
                        self.consume_to_eol();
                        return Ok(Statement::ResumeLabel(s));
                    }
                    Token::IntegerLiteral(n) => {
                        self.advance();
                        self.consume_to_eol();
                        return Ok(Statement::ResumeLabel(n.to_string()));
                    }
                    _ => {}
                }
                // bare RESUME: re-execute the statement that errored
                self.consume_to_eol();
                Ok(Statement::Resume)
            }
            Token::GoSub => {
                self.advance();
                let label = match self.peek().clone() {
                    Token::Identifier(s) => {
                        self.advance();
                        s
                    }
                    Token::IntegerLiteral(n) => {
                        self.advance();
                        n.to_string()
                    }
                    _ => {
                        return Err(PbError::parser(
                            format!("Expected label after GOSUB, got {:?}", self.peek()),
                            self.current_file(),
                            line,
                        ))
                    }
                };
                self.consume_to_eol();
                Ok(Statement::GoSub(label))
            }
            Token::GoTo => {
                self.advance();
                let label = match self.peek().clone() {
                    Token::Identifier(s) => {
                        self.advance();
                        s
                    }
                    Token::IntegerLiteral(n) => {
                        self.advance();
                        n.to_string()
                    }
                    _ => {
                        return Err(PbError::parser(
                            format!("Expected label after GOTO, got {:?}", self.peek()),
                            self.current_file(),
                            line,
                        ))
                    }
                };
                self.consume_to_eol();
                Ok(Statement::GoTo(label))
            }
            Token::Return => {
                self.advance();
                self.consume_to_eol();
                Ok(Statement::Return)
            }
            Token::Iterate => {
                self.advance();
                let target = match self.peek() {
                    Token::For => {
                        self.advance();
                        IterateTarget::For
                    }
                    Token::Do => {
                        self.advance();
                        IterateTarget::Do
                    }
                    _ => IterateTarget::For,
                };
                self.consume_to_eol();
                Ok(Statement::Iterate(target))
            }
            Token::HashInclude => {
                // #INCLUDE inside a SUB (e.g., SetupDims including DIMFILE.INC)
                // We need to treat the included content as statements
                // For now, skip — the preprocessor should have resolved this
                self.consume_to_eol();
                Ok(Statement::Noop("#INCLUDE".to_string(), line))
            }
            Token::PercentConstant(_) => {
                // %CONSTANT = value inside a sub
                self.consume_to_eol();
                Ok(Statement::Noop("%CONSTANT".to_string(), line))
            }
            Token::End => {
                // Check what follows END
                match self.peek_at(1) {
                    Some(Token::Sub) | Some(Token::Function) => {
                        // END SUB/FUNCTION should be handled as body terminators,
                        // not consumed here. Return error to let body parser deal with it.
                        Err(PbError::parser(
                            "Unexpected END SUB/FUNCTION inside body",
                            None,
                            self.current_line(),
                        ))
                    }
                    Some(Token::If) | Some(Token::Select) | Some(Token::Type) => {
                        // Mismatched block-end — consume and skip
                        self.consume_to_eol();
                        Ok(Statement::Noop("END (mismatched block)".to_string(), line))
                    }
                    _ => {
                        // Standalone END (program termination)
                        self.advance(); // consume END
                        self.consume_to_eol();
                        Ok(Statement::Noop("END".to_string(), line))
                    }
                }
            }
            Token::IntegerLiteral(n) => {
                // Numeric label: 30300 followed by anything (used with GOSUB/GOTO)
                let label = n.to_string();
                self.advance(); // consume the number
                Ok(Statement::Label(label))
            }
            Token::Identifier(ref name) => {
                let name_upper = name.to_uppercase();

                // DATA item1, item2, ... — string constants for READ
                if name_upper == "DATA" {
                    self.advance(); // consume DATA
                    let items = self.parse_data_items();
                    self.consume_to_eol();
                    return Ok(Statement::Data(items));
                }
                // RESTORE [label] — reset the DATA cursor
                if name_upper == "RESTORE" {
                    self.advance();
                    self.consume_to_eol();
                    return Ok(Statement::Restore);
                }
                // READ var1, var2, ... — read next DATA items
                if name_upper == "READ" {
                    self.advance(); // consume READ
                    let mut args = Vec::new();
                    while !self.at_eol_or_eof() {
                        args.push(self.parse_expression()?);
                        if self.peek() == &Token::Comma {
                            self.advance();
                        } else {
                            break;
                        }
                    }
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "READ".to_string(),
                        args,
                        line,
                    }));
                }
                // LINE INPUT #filenum, var$
                if name_upper == "LINE" {
                    // Peek ahead: LINE INPUT #...
                    if let Some(Token::Input) = self.peek_at(1) {
                        self.advance(); // consume LINE
                        self.advance(); // consume INPUT
                        if self.peek() == &Token::Hash {
                            self.advance(); // consume #
                            let file_num = self.parse_expression()?;
                            self.expect(&Token::Comma)?;
                            let var = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::LineInputFile(LineInputFileStmt {
                                file_num,
                                var,
                                line,
                            }));
                        }
                        // LINE INPUT without # — console, read whole line
                        let mut prompt = None;
                        if self.peek() == &Token::Semicolon {
                            self.advance();
                        }
                        if let Token::StringLiteral(_) = self.peek() {
                            prompt = Some(self.parse_expression()?);
                            if self.peek() == &Token::Semicolon {
                                self.advance();
                            }
                        }
                        let var = self.parse_expression()?;
                        self.consume_to_eol();
                        return Ok(Statement::LineInputConsole(LineInputConsoleStmt {
                            prompt,
                            var,
                            line,
                        }));
                    }
                    // LINE (not INPUT) — DDT drawing or other, consume
                    self.advance();
                    self.consume_to_eol();
                    return Ok(Statement::Noop("LINE".to_string(), line));
                }

                // KILL filename$
                if name_upper == "KILL" {
                    self.advance(); // consume KILL
                    let filename = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Kill(filename));
                }

                // MENU NEW BAR TO hMenu | MENU NEW POPUP TO hPop
                // MENU ADD STRING, hMenu, txt$, id&, state& | MENU ADD POPUP, hMenu, hSub, id&
                // MENU DELETE hMenu, pos& (batch 50)
                // GRAPHIC BITMAP NEW w&, h& TO hBmp | GRAPHIC BITMAP END [hBmp]
                // Memory DIB bitmap — not visible, console-testable (batch 51)
                if name_upper == "GRAPHIC" {
                    self.advance(); // consume GRAPHIC
                    let gop = self.peek_plain_upper();
                    if gop == "ATTACH" {
                        self.advance();
                        let mut args = vec![self.parse_expression()?];
                        while self.peek() == &Token::Comma {
                            self.advance();
                            args.push(self.parse_expression()?);
                        }
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "GRAPHIC_ATTACH".to_string(),
                            args,
                            line,
                        }));
                    }
                    if gop == "GET" {
                        // GRAPHIC GET CANVAS TO hbmp | GRAPHIC GET DC TO hdc | GRAPHIC GET MIX TO mix&
                        // GRAPHIC GET SIZE TO w,h | GRAPHIC GET TEXTALIGN TO align&
                        self.advance();
                        let sub = self.peek_plain_upper();
                        if sub == "SIZE" {
                            self.advance();
                            self.expect(&Token::To)?;
                            let w = self.parse_expression()?;
                            self.expect(&Token::Comma)?;
                            let h = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "GRAPHIC_GET_SIZE".to_string(),
                                args: vec![w, h],
                                line,
                            }));
                        }
                        if sub == "TEXTALIGN" {
                            self.advance();
                            self.expect(&Token::To)?;
                            let dst = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "GRAPHIC_GET_TEXTALIGN".to_string(),
                                args: vec![dst],
                                line,
                            }));
                        }
                        if sub == "CLIENT" {
                            // GRAPHIC GET CLIENT TO w&, h&
                            self.advance();
                            self.expect(&Token::To)?;
                            let w = self.parse_expression()?;
                            self.expect(&Token::Comma)?;
                            let h = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "GRAPHIC_GET_CLIENT".to_string(),
                                args: vec![w, h],
                                line,
                            }));
                        }
                        if sub == "LOC" {
                            // GRAPHIC GET LOC TO x&, y&
                            self.advance();
                            self.expect(&Token::To)?;
                            let x = self.parse_expression()?;
                            self.expect(&Token::Comma)?;
                            let y = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "GRAPHIC_GET_LOC".to_string(),
                                args: vec![x, y],
                                line,
                            }));
                        }
                        if sub == "CLIP" || sub == "VIEW" || sub == "LINES" || sub == "WRAP" {
                            // GRAPHIC GET CLIP TO w!, h! | GRAPHIC GET VIEW TO x!, y!
                            // GRAPHIC GET LINES TO n& | GRAPHIC GET WRAP TO w&  (batch 63)
                            self.advance();
                            self.expect(&Token::To)?;
                            let a = self.parse_expression()?;
                            let mut args = vec![a];
                            if sub == "CLIP" || sub == "VIEW" {
                                self.expect(&Token::Comma)?;
                                let b = self.parse_expression()?;
                                args.push(b);
                            }
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: format!("GRAPHIC_GET_{}", sub),
                                args,
                                line,
                            }));
                        }
                        if sub == "BITS" {
                            // GRAPHIC GET BITS TO bitvar$ — whole bitmap as DIB string (batch 64)
                            self.advance();
                            self.expect(&Token::To)?;
                            let dst = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "GRAPHIC_GET_BITS".to_string(),
                                args: vec![dst],
                                line,
                            }));
                        }
                        if sub == "SCALE" {
                            // GRAPHIC GET SCALE TO x1!, y1!, x2!, y2!  (batch 64)
                            self.advance();
                            self.expect(&Token::To)?;
                            let a = self.parse_expression()?;
                            let mut args = vec![a];
                            for _ in 0..3 {
                                self.expect(&Token::Comma)?;
                                args.push(self.parse_expression()?);
                            }
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "GRAPHIC_GET_SCALE".to_string(),
                                args,
                                line,
                            }));
                        }
                        if sub == "WORDWRAP" {
                            // GRAPHIC GET WORDWRAP TO n&  (batch 65)
                            self.advance();
                            self.expect(&Token::To)?;
                            let dst = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "GRAPHIC_GET_WORDWRAP".to_string(),
                                args: vec![dst],
                                line,
                            }));
                        }
                        if sub == "PIXEL" {
                            // GRAPHIC GET PIXEL (x,y) TO dst&
                            self.advance();
                            self.expect(&Token::LParen)?;
                            let x = self.parse_expression()?;
                            self.expect(&Token::Comma)?;
                            let y = self.parse_expression()?;
                            self.expect(&Token::RParen)?;
                            self.expect(&Token::To)?;
                            let dst = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "GRAPHIC_GET_PIXEL".to_string(),
                                args: vec![x, y, dst],
                                line,
                            }));
                        }
                        if sub == "PPI" {
                            self.advance();
                            self.expect(&Token::To)?;
                            let x = self.parse_expression()?;
                            self.expect(&Token::Comma)?;
                            let y = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "GRAPHIC_GET_PPI".to_string(),
                                args: vec![x, y],
                                line,
                            }));
                        }
                        if sub == "POS" {
                            self.advance();
                            self.expect(&Token::To)?;
                            let x = self.parse_expression()?;
                            self.expect(&Token::Comma)?;
                            let y = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "GRAPHIC_GET_POS".to_string(),
                                args: vec![x, y],
                                line,
                            }));
                        }
                        if sub == "STRETCHMODE" {
                            self.advance();
                            self.expect(&Token::To)?;
                            let m = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "GRAPHIC_GET_STRETCHMODE".to_string(),
                                args: vec![m],
                                line,
                            }));
                        }
                        if sub == "CAPTION" {
                            self.advance();
                            self.expect(&Token::To)?;
                            let c = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "GRAPHIC_GET_CAPTION".to_string(),
                                args: vec![c],
                                line,
                            }));
                        }
                        if sub == "CANVAS" || sub == "DC" || sub == "MIX" {
                            self.advance();
                            self.expect(&Token::To)?;
                            let dst = self.parse_expression()?;
                            self.consume_to_eol();
                            let name = match sub.as_str() {
                                "CANVAS" => "GRAPHIC_GET_CANVAS",
                                "DC" => "GRAPHIC_GET_DC",
                                _ => "GRAPHIC_GET_MIX",
                            };
                            return Ok(Statement::Call(CallStmt {
                                name: name.to_string(),
                                args: vec![dst],
                                line,
                            }));
                        }
                    }
                    if gop == "SET" {
                        // GRAPHIC SET MIX (mix&) | GRAPHIC SET PIXEL (x,y),color | GRAPHIC SET TEXTALIGN (align&)
                        self.advance();
                        let sub = self.peek_plain_upper();
                        if sub == "SIZE" {
                            // GRAPHIC SET SIZE nWide&, nHigh&  (batch 65)
                            self.advance();
                            let w = self.parse_expression()?;
                            self.expect(&Token::Comma)?;
                            let h = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "GRAPHIC_SET_SIZE".to_string(),
                                args: vec![w, h],
                                line,
                            }));
                        }
                        if sub == "CLIP" {
                            // GRAPHIC SET CLIP l!, t!, r!, b!  (batch 65)
                            self.advance();
                            let mut args = Vec::new();
                            for k in 0..4 {
                                if k > 0 {
                                    self.expect(&Token::Comma)?;
                                }
                                args.push(self.parse_expression()?);
                            }
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "GRAPHIC_SET_CLIP".to_string(),
                                args,
                                line,
                            }));
                        }
                        if sub == "VIRTUAL" {
                            // GRAPHIC SET VIRTUAL nWide&, nHigh& [,USERSIZE]  (batch 65)
                            self.advance();
                            let mut args = vec![self.parse_expression()?];
                            while matches!(self.peek(), Token::Comma) {
                                self.advance();
                                if self.peek_plain_upper() == "USERSIZE" {
                                    self.advance();
                                    break;
                                }
                                args.push(self.parse_expression()?);
                            }
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "GRAPHIC_SET_VIRTUAL".to_string(),
                                args,
                                line,
                            }));
                        }
                        if sub == "FIXED" {
                            // GRAPHIC SET FIXED  (batch 66)
                            self.advance();
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "GRAPHIC_SET_FIXED".to_string(),
                                args: vec![],
                                line,
                            }));
                        }
                        if sub == "FONT" {
                            // GRAPHIC SET FONT fonthndl&  (batch 66)
                            self.advance();
                            let h = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "GRAPHIC_SET_FONT".to_string(),
                                args: vec![h],
                                line,
                            }));
                        }
                        if sub == "WORDWRAP" {
                            // GRAPHIC SET WORDWRAP n&  (batch 65)
                            self.advance();
                            let n = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "GRAPHIC_SET_WORDWRAP".to_string(),
                                args: vec![n],
                                line,
                            }));
                        }
                        if sub == "PIXEL" {
                            self.advance();
                            self.expect(&Token::LParen)?;
                            let x = self.parse_expression()?;
                            self.expect(&Token::Comma)?;
                            let y = self.parse_expression()?;
                            self.expect(&Token::RParen)?;
                            self.expect(&Token::Comma)?;
                            let color = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "GRAPHIC_SET_PIXEL".to_string(),
                                args: vec![x, y, color],
                                line,
                            }));
                        }
                        if sub == "TEXTALIGN" {
                            self.advance();
                            if matches!(self.peek(), Token::LParen) {
                                self.advance();
                            }
                            let align = self.parse_expression()?;
                            if matches!(self.peek(), Token::RParen) {
                                self.advance();
                            }
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "GRAPHIC_SET_TEXTALIGN".to_string(),
                                args: vec![align],
                                line,
                            }));
                        }
                        if sub == "BITS" {
                            // GRAPHIC SET BITS bitexpr$ — replace bitmap from DIB string (batch 64)
                            self.advance();
                            let src = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "GRAPHIC_SET_BITS".to_string(),
                                args: vec![src],
                                line,
                            }));
                        }
                        if sub == "AUTOSIZE" {
                            // GRAPHIC SET AUTOSIZE nWidth, nHeight [,USERSIZE]  (batch 64)
                            self.advance();
                            let mut args = vec![self.parse_expression()?];
                            while matches!(self.peek(), Token::Comma) {
                                self.advance();
                                if self.peek_plain_upper() == "USERSIZE" {
                                    self.advance();
                                    break;
                                }
                                args.push(self.parse_expression()?);
                            }
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "GRAPHIC_SET_AUTOSIZE".to_string(),
                                args,
                                line,
                            }));
                        }
                        if sub == "VIEW" || sub == "WRAP" {
                            // GRAPHIC SET VIEW x!, y! | GRAPHIC SET WRAP [n&]  (batch 63)
                            self.advance();
                            let a = self.parse_expression()?;
                            let mut args = vec![a];
                            if sub == "VIEW" {
                                self.expect(&Token::Comma)?;
                                let b = self.parse_expression()?;
                                args.push(b);
                            }
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: format!("GRAPHIC_SET_{}", sub),
                                args,
                                line,
                            }));
                        }
                        if sub == "POS" {
                            self.advance();
                            if matches!(self.peek(), Token::Step) {
                                self.advance();
                            }
                            self.expect(&Token::LParen)?;
                            let x = self.parse_expression()?;
                            self.expect(&Token::Comma)?;
                            let y = self.parse_expression()?;
                            self.expect(&Token::RParen)?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "GRAPHIC_SET_POS".to_string(),
                                args: vec![x, y],
                                line,
                            }));
                        }
                        if sub == "STRETCHMODE" {
                            self.advance();
                            let m = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "GRAPHIC_SET_STRETCHMODE".to_string(),
                                args: vec![m],
                                line,
                            }));
                        }
                        if sub == "CAPTION" {
                            self.advance();
                            let c = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "GRAPHIC_SET_CAPTION".to_string(),
                                args: vec![c],
                                line,
                            }));
                        }
                        if sub == "MIX" {
                            self.advance();
                            if matches!(self.peek(), Token::LParen) {
                                self.advance();
                            }
                            let mix = self.parse_expression()?;
                            if matches!(self.peek(), Token::RParen) {
                                self.advance();
                            }
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "GRAPHIC_SET_MIX".to_string(),
                                args: vec![mix],
                                line,
                            }));
                        }
                    }
                    if gop == "TEXT" {
                        // GRAPHIC TEXT SIZE txt$ TO w!, h!
                        self.advance();
                        self.expect(&Token::Identifier("SIZE".to_string()))?;
                        let txt = self.parse_expression()?;
                        self.expect(&Token::To)?;
                        let w = self.parse_expression()?;
                        self.expect(&Token::Comma)?;
                        let h = self.parse_expression()?;
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "GRAPHIC_TEXT_SIZE".to_string(),
                            args: vec![txt, w, h],
                            line,
                        }));
                    }
                    if gop == "CHR" {
                        // GRAPHIC CHR SIZE (text$) TO w&, h&
                        self.advance();
                        self.expect(&Token::Identifier("SIZE".to_string()))?;
                        self.expect(&Token::LParen)?;
                        let txt = self.parse_expression()?;
                        self.expect(&Token::RParen)?;
                        self.expect(&Token::To)?;
                        let w = self.parse_expression()?;
                        self.expect(&Token::Comma)?;
                        let h = self.parse_expression()?;
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "GRAPHIC_CHR_SIZE".to_string(),
                            args: vec![txt, w, h],
                            line,
                        }));
                    }
                    if gop == "CELL" {
                        // GRAPHIC CELL SIZE (rows,cols) TO w,h  |  GRAPHIC CELL (row,col) TO x,y
                        self.advance();
                        let sub = self.peek_plain_upper();
                        if sub == "SIZE" {
                            self.advance();
                        }
                        self.expect(&Token::LParen)?;
                        let a0 = self.parse_expression()?;
                        self.expect(&Token::Comma)?;
                        let a1 = self.parse_expression()?;
                        self.expect(&Token::RParen)?;
                        self.expect(&Token::To)?;
                        let o0 = self.parse_expression()?;
                        self.expect(&Token::Comma)?;
                        let o1 = self.parse_expression()?;
                        self.consume_to_eol();
                        let name = if sub == "SIZE" {
                            "GRAPHIC_CELL_SIZE".to_string()
                        } else {
                            "GRAPHIC_CELL".to_string()
                        };
                        return Ok(Statement::Call(CallStmt {
                            name,
                            args: vec![a0, a1, o0, o1],
                            line,
                        }));
                    }
                    if gop == "CIRCLE" {
                        // GRAPHIC CIRCLE (x,y), r [, color&]
                        self.advance();
                        let mut args = Vec::new();
                        self.expect(&Token::LParen)?;
                        args.push(self.parse_expression()?);
                        self.expect(&Token::Comma)?;
                        args.push(self.parse_expression()?);
                        self.expect(&Token::RParen)?;
                        self.expect(&Token::Comma)?;
                        args.push(self.parse_expression()?);
                        if self.peek() == &Token::Comma {
                            self.advance();
                            args.push(self.parse_expression()?);
                        }
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "GRAPHIC_CIRCLE".to_string(),
                            args,
                            line,
                        }));
                    }
                    if gop == "POLYGON" {
                        // GRAPHIC POLYGON (x1,y1)-(x2,y2)-... [, color&]
                        self.advance();
                        let mut args = Vec::new();
                        loop {
                            self.expect(&Token::LParen)?;
                            args.push(self.parse_expression()?);
                            self.expect(&Token::Comma)?;
                            args.push(self.parse_expression()?);
                            self.expect(&Token::RParen)?;
                            if self.peek() == &Token::Minus {
                                self.advance();
                            } else {
                                break;
                            }
                        }
                        if self.peek() == &Token::Comma {
                            self.advance();
                            args.push(self.parse_expression()?);
                        }
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "GRAPHIC_POLYGON".to_string(),
                            args,
                            line,
                        }));
                    }
                    if gop == "SCALE" {
                        // GRAPHIC SCALE (x1!,y1!)-(x2!,y2!) | GRAPHIC SCALE PIXELS  (batch 64)
                        self.advance();
                        if matches!(self.peek(), Token::LParen) {
                            self.advance();
                            let x1 = self.parse_expression()?;
                            self.expect(&Token::Comma)?;
                            let y1 = self.parse_expression()?;
                            self.expect(&Token::RParen)?;
                            if matches!(self.peek(), Token::Minus) {
                                self.advance();
                            }
                            self.expect(&Token::LParen)?;
                            let x2 = self.parse_expression()?;
                            self.expect(&Token::Comma)?;
                            let y2 = self.parse_expression()?;
                            self.expect(&Token::RParen)?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "GRAPHIC_SCALE".to_string(),
                                args: vec![x1, y1, x2, y2],
                                line,
                            }));
                        }
                        // SCALE PIXELS
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "GRAPHIC_SCALE_PIXELS".to_string(),
                            args: vec![],
                            line,
                        }));
                    }
                    if gop == "GET" {
                        // GRAPHIC GET CLIENT TO w&, h& / GET LOC TO x&, y&
                        self.advance();
                        let sub = self.peek_plain_upper();
                        if sub == "CLIENT" {
                            self.advance();
                            self.expect(&Token::To)?;
                            let w = self.parse_expression()?;
                            self.expect(&Token::Comma)?;
                            let h = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "GRAPHIC_GET_CLIENT".to_string(),
                                args: vec![w, h],
                                line,
                            }));
                        } else if sub == "LOC" {
                            self.advance();
                            self.expect(&Token::To)?;
                            let x = self.parse_expression()?;
                            self.expect(&Token::Comma)?;
                            let y = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "GRAPHIC_GET_LOC".to_string(),
                                args: vec![x, y],
                                line,
                            }));
                        } else {
                            // GRAPHIC GET PIXEL (x,y) TO var&
                            // sub already matched; consume PIXEL only if present
                            if self.peek_plain_upper() == "PIXEL" {
                                self.advance();
                            }
                            if self.peek() != &Token::LParen {
                                self.consume_to_eol();
                                let gname = if sub.is_empty() {
                                    "GRAPHIC GET".to_string()
                                } else {
                                    format!("GRAPHIC GET {}", sub)
                                };
                                return Ok(Statement::Noop(gname, line));
                            }
                            self.advance(); // (
                            let x = self.parse_expression()?;
                            self.expect(&Token::Comma)?;
                            let y = self.parse_expression()?;
                            self.expect(&Token::RParen)?;
                            self.expect(&Token::To)?;
                            let dst = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "GRAPHIC_GET_PIXEL".to_string(),
                                args: vec![x, y, dst],
                                line,
                            }));
                        }
                    }
                    if gop == "COLOR" {
                        self.advance();
                        let mut args = vec![self.parse_expression()?];
                        if self.peek() == &Token::Comma {
                            self.advance();
                            args.push(self.parse_expression()?);
                        }
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "GRAPHIC_COLOR".to_string(),
                            args,
                            line,
                        }));
                    }
                    if gop == "PRINT" {
                        // GRAPHIC PRINT [expr][;|, expr]... (batch 118)
                        self.advance(); // consume PRINT
                        let mut pargs = Vec::new();
                        while self.peek() != &Token::Eol
                            && self.peek() != &Token::Eof
                            && self.peek() != &Token::Colon
                        {
                            if self.peek() == &Token::Comma || self.peek() == &Token::Semicolon {
                                self.advance();
                                continue;
                            }
                            pargs.push(self.parse_expression()?);
                        }
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "GRAPHIC_PRINT".to_string(),
                            args: pargs,
                            line,
                        }));
                    }
                    if gop == "COPY" {
                        // GRAPHIC COPY (x1,y1)-(x2,y2), (x3,y3)
                        self.advance();
                        let mut args = Vec::new();
                        self.expect(&Token::LParen)?;
                        args.push(self.parse_expression()?);
                        self.expect(&Token::Comma)?;
                        args.push(self.parse_expression()?);
                        self.expect(&Token::RParen)?;
                        if self.peek() == &Token::Minus {
                            self.advance();
                        }
                        self.expect(&Token::LParen)?;
                        args.push(self.parse_expression()?);
                        self.expect(&Token::Comma)?;
                        args.push(self.parse_expression()?);
                        self.expect(&Token::RParen)?;
                        if self.peek() == &Token::Comma {
                            self.advance();
                        }
                        self.expect(&Token::LParen)?;
                        args.push(self.parse_expression()?);
                        self.expect(&Token::Comma)?;
                        args.push(self.parse_expression()?);
                        self.expect(&Token::RParen)?;
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "GRAPHIC_COPY".to_string(),
                            args,
                            line,
                        }));
                    }
                    if gop == "WIDTH" || gop == "STYLE" {
                        self.advance();
                        let args = if self.peek() != &Token::Eol && self.peek() != &Token::Eof {
                            vec![self.parse_expression()?]
                        } else {
                            Vec::new()
                        };
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: if gop == "STYLE" {
                                "GRAPHIC_STYLE".to_string()
                            } else {
                                "GRAPHIC_WIDTH".to_string()
                            },
                            args,
                            line,
                        }));
                    }
                    if gop == "SAVE" {
                        self.advance();
                        let args = vec![self.parse_expression()?];
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "GRAPHIC_SAVE".to_string(),
                            args,
                            line,
                        }));
                    }
                    if gop == "ARC" || gop == "PIE" {
                        // GRAPHIC ARC (x1,y1)-(x2,y2), start, end [, color& [, ...]]
                        self.advance();
                        let mut args = Vec::new();
                        self.expect(&Token::LParen)?;
                        args.push(self.parse_expression()?);
                        self.expect(&Token::Comma)?;
                        args.push(self.parse_expression()?);
                        self.expect(&Token::RParen)?;
                        self.expect(&Token::Minus)?;
                        self.expect(&Token::LParen)?;
                        args.push(self.parse_expression()?);
                        self.expect(&Token::Comma)?;
                        args.push(self.parse_expression()?);
                        self.expect(&Token::RParen)?;
                        self.expect(&Token::Comma)?;
                        args.push(self.parse_expression()?);
                        self.expect(&Token::Comma)?;
                        args.push(self.parse_expression()?);
                        while self.peek() == &Token::Comma {
                            self.advance();
                            args.push(self.parse_expression()?);
                        }
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: if gop == "ARC" {
                                "GRAPHIC_ARC".to_string()
                            } else {
                                "GRAPHIC_PIE".to_string()
                            },
                            args,
                            line,
                        }));
                    }
                    if gop == "POLYLINE" {
                        // GRAPHIC POLYLINE (x1,y1)-(x2,y2)-... [, color&]
                        self.advance();
                        let mut args = Vec::new();
                        while matches!(self.peek(), Token::LParen) {
                            self.advance();
                            args.push(self.parse_expression()?);
                            if self.peek() == &Token::Comma {
                                self.advance();
                                args.push(self.parse_expression()?);
                            }
                            if matches!(self.peek(), Token::RParen) {
                                self.advance();
                            }
                            if matches!(self.peek(), Token::Minus) {
                                self.advance();
                            }
                        }
                        while self.peek() == &Token::Comma {
                            self.advance();
                            args.push(self.parse_expression()?);
                        }
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "GRAPHIC_POLYLINE".to_string(),
                            args,
                            line,
                        }));
                    }
                    if gop == "PAINT" {
                        // GRAPHIC PAINT [BORDER|REPLACE] [STEP] (x,y) [, fill& [, border& [, style&]]]
                        self.advance();
                        let mut args = Vec::new();
                        loop {
                            let u = self.peek_plain_upper();
                            if u == "BORDER" || u == "REPLACE" || u == "STEP" {
                                self.advance();
                            } else {
                                break;
                            }
                        }
                        self.expect(&Token::LParen)?;
                        args.push(self.parse_expression()?);
                        self.expect(&Token::Comma)?;
                        args.push(self.parse_expression()?);
                        self.expect(&Token::RParen)?;
                        while self.peek() == &Token::Comma {
                            self.advance();
                            args.push(self.parse_expression()?);
                        }
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "GRAPHIC_PAINT".to_string(),
                            args,
                            line,
                        }));
                    }
                    if gop == "LINE" || gop == "BOX" || gop == "ELLIPSE" {
                        self.advance();
                        let mut args = Vec::new();
                        // [STEP] (x1,y1) - [STEP] (x2,y2) [, color& [, ...]]
                        while matches!(self.peek(), Token::LParen) {
                            self.advance();
                            args.push(self.parse_expression()?);
                            if self.peek() == &Token::Comma {
                                self.advance();
                                args.push(self.parse_expression()?);
                            }
                            if matches!(self.peek(), Token::RParen) {
                                self.advance();
                            }
                            if matches!(self.peek(), Token::Minus) {
                                self.advance();
                            }
                        }
                        while self.peek() == &Token::Comma {
                            self.advance();
                            args.push(self.parse_expression()?);
                        }
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: match gop.as_str() {
                                "BOX" => "GRAPHIC_BOX".to_string(),
                                "ELLIPSE" => "GRAPHIC_ELLIPSE".to_string(),
                                _ => "GRAPHIC_LINE".to_string(),
                            },
                            args,
                            line,
                        }));
                    }
                    if gop == "DETACH" {
                        self.advance();
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "GRAPHIC_DETACH".to_string(),
                            args: Vec::new(),
                            line,
                        }));
                    }
                    if gop == "CLEAR" {
                        self.advance();
                        let mut args = Vec::new();
                        if self.peek() != &Token::Eol && self.peek() != &Token::Eof {
                            args.push(self.parse_expression()?);
                            while self.peek() == &Token::Comma {
                                self.advance();
                                args.push(self.parse_expression()?);
                            }
                        }
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "GRAPHIC_CLEAR".to_string(),
                            args,
                            line,
                        }));
                    }
                    if self.peek_plain_upper() == "BITMAP" {
                        self.advance();
                        let op = self.peek_plain_upper();
                        if op == "LOAD" {
                            // GRAPHIC BITMAP LOAD "file.bmp" TO hbmp
                            self.advance();
                            let fname = self.parse_expression()?;
                            if matches!(self.peek(), Token::To) {
                                self.advance();
                            }
                            let dst = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "GRAPHIC_BITMAP_LOAD".to_string(),
                                args: vec![fname, dst],
                                line,
                            }));
                        }
                        if op == "NEW" {
                            self.advance();
                            let mut args = vec![self.parse_expression()?];
                            while self.peek() == &Token::Comma {
                                self.advance();
                                args.push(self.parse_expression()?);
                            }
                            if matches!(self.peek(), Token::To) {
                                self.advance();
                                args.push(self.parse_expression()?);
                            }
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "GRAPHIC_BITMAP_NEW".to_string(),
                                args,
                                line,
                            }));
                        }
                        if matches!(self.peek(), Token::End) {
                            self.advance();
                            let mut args = Vec::new();
                            if self.peek() != &Token::Eol && self.peek() != &Token::Eof {
                                args.push(self.parse_expression()?);
                            }
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "GRAPHIC_BITMAP_END".to_string(),
                                args,
                                line,
                            }));
                        }
                    }
                }

                // XPRINT (batch 68): host-based printer GDI operations
                if name_upper == "XPRINT" {
                    self.advance(); // consume XPRINT
                    let xop = self.peek_plain_upper();
                    if xop == "ATTACH" {
                        // XPRINT ATTACH {DEFAULT | PrinterName$} [, JobName$]
                        self.advance();
                        let first = self.peek_plain_upper();
                        let printer = if first == "DEFAULT" {
                            self.advance();
                            Expr::StringLit(String::new())
                        } else {
                            self.parse_expression()?
                        };
                        let mut args = vec![printer];
                        if self.peek() == &Token::Comma {
                            self.advance();
                            args.push(self.parse_expression()?);
                        }
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "XPRINT_ATTACH".to_string(),
                            args,
                            line,
                        }));
                    }
                    if xop == "CLOSE" {
                        self.advance();
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "XPRINT_CLOSE".to_string(),
                            args: vec![],
                            line,
                        }));
                    }
                    if xop == "SCALE" {
                        self.advance();
                        let w = self.parse_expression()?;
                        self.expect(&Token::Comma)?;
                        let h = self.parse_expression()?;
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "XPRINT_SCALE".to_string(),
                            args: vec![w, h],
                            line,
                        }));
                    }
                    if xop == "CELL" {
                        self.advance();
                        // XPRINT CELL SIZE TO w, h is the official form and must be tested
                        // before the two-argument XPRINT CELL, otherwise SIZE is parsed as a
                        // variable and the following TO raises "Expected Comma, got To".
                        if self.peek_plain_upper() == "SIZE" {
                            self.advance();
                            self.expect(&Token::To)?;
                            let w = self.parse_expression()?;
                            self.expect(&Token::Comma)?;
                            let h = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_CELL_SIZE".to_string(),
                                args: vec![w, h],
                                line,
                            }));
                        }
                        let x = self.parse_expression()?;
                        self.expect(&Token::Comma)?;
                        let y = self.parse_expression()?;
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "XPRINT_CELL".to_string(),
                            args: vec![x, y],
                            line,
                        }));
                    }
                    if xop == "PREVIEW" {
                        self.advance();
                        let mode = if self.peek() != &Token::Eol && self.peek() != &Token::Eof {
                            self.parse_expression()?
                        } else {
                            Expr::IntegerLit(0)
                        };
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "XPRINT_PREVIEW".to_string(),
                            args: vec![mode],
                            line,
                        }));
                    }
                    if xop == "RENDER" {
                        self.advance();
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "XPRINT_RENDER".to_string(),
                            args: vec![],
                            line,
                        }));
                    }
                    if xop == "SPLIT" {
                        self.advance();
                        let mut args = vec![];
                        for i in 0..4 {
                            args.push(self.parse_expression()?);
                            if i < 3 {
                                self.expect(&Token::Comma)?;
                            }
                        }
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "XPRINT_SPLIT".to_string(),
                            args,
                            line,
                        }));
                    }
                    if xop == "STRETCH" {
                        self.advance();
                        let mut args = vec![];
                        for i in 0..8 {
                            args.push(self.parse_expression()?);
                            if i < 7 {
                                self.expect(&Token::Comma)?;
                            }
                        }
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "XPRINT_STRETCH".to_string(),
                            args,
                            line,
                        }));
                    }
                    if xop == "IMAGELIST" {
                        self.advance();
                        let mut args = vec![];
                        for i in 0..3 {
                            args.push(self.parse_expression()?);
                            if i < 2 {
                                self.expect(&Token::Comma)?;
                            }
                        }
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "XPRINT_IMAGELIST".to_string(),
                            args,
                            line,
                        }));
                    }
                    if xop == "POLYGON" {
                        self.advance();
                        let mut args = vec![];
                        while self.peek() != &Token::Eol && self.peek() != &Token::Eof {
                            args.push(self.parse_expression()?);
                            if self.peek() == &Token::Comma {
                                self.advance();
                            } else {
                                break;
                            }
                        }
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "XPRINT_POLYGON".to_string(),
                            args,
                            line,
                        }));
                    }
                    if xop == "POLYLINE" {
                        self.advance();
                        let mut args = vec![];
                        while self.peek() != &Token::Eol && self.peek() != &Token::Eof {
                            args.push(self.parse_expression()?);
                            if self.peek() == &Token::Comma {
                                self.advance();
                            } else {
                                break;
                            }
                        }
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "XPRINT_POLYLINE".to_string(),
                            args,
                            line,
                        }));
                    }
                    if xop == "COPY" {
                        self.advance();
                        let mut args = vec![];
                        for i in 0..6 {
                            args.push(self.parse_expression()?);
                            if i < 5 {
                                self.expect(&Token::Comma)?;
                            }
                        }
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "XPRINT_COPY".to_string(),
                            args,
                            line,
                        }));
                    }
                    if xop == "CHR" {
                        self.advance();
                        if self.peek_plain_upper() == "SIZE" {
                            self.advance();
                            self.expect(&Token::To)?;
                            let w = self.parse_expression()?;
                            self.expect(&Token::Comma)?;
                            let h = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_CHR_SIZE".to_string(),
                                args: vec![w, h],
                                line,
                            }));
                        }
                    }
                    if xop == "TEXT" {
                        self.advance();
                        if self.peek_plain_upper() == "SIZE" {
                            self.advance();
                            let txt = self.parse_expression()?;
                            self.expect(&Token::To)?;
                            let w = self.parse_expression()?;
                            self.expect(&Token::Comma)?;
                            let h = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_TEXT_SIZE".to_string(),
                                args: vec![txt, w, h],
                                line,
                            }));
                        }
                    }
                    if xop == "ARC" {
                        self.advance();
                        let mut args = vec![];
                        for i in 0..8 {
                            args.push(self.parse_expression()?);
                            if i < 7 {
                                self.expect(&Token::Comma)?;
                            }
                        }
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "XPRINT_ARC".to_string(),
                            args,
                            line,
                        }));
                    }
                    if xop == "ELLIPSE" {
                        self.advance();
                        let mut args = vec![];
                        for i in 0..4 {
                            args.push(self.parse_expression()?);
                            if i < 3 {
                                self.expect(&Token::Comma)?;
                            }
                        }
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "XPRINT_ELLIPSE".to_string(),
                            args,
                            line,
                        }));
                    }
                    if xop == "PIE" {
                        self.advance();
                        let mut args = vec![];
                        for i in 0..8 {
                            args.push(self.parse_expression()?);
                            if i < 7 {
                                self.expect(&Token::Comma)?;
                            }
                        }
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "XPRINT_PIE".to_string(),
                            args,
                            line,
                        }));
                    }
                    if xop == "CANCEL" {
                        self.advance();
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "XPRINT_CANCEL".to_string(),
                            args: vec![],
                            line,
                        }));
                    }
                    if xop == "FORMFEED" {
                        self.advance();
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "XPRINT_FORMFEED".to_string(),
                            args: vec![],
                            line,
                        }));
                    }
                    if xop == "LINE" {
                        self.advance();
                        let x1 = self.parse_expression()?;
                        self.expect(&Token::Comma)?;
                        let y1 = self.parse_expression()?;
                        self.expect(&Token::Comma)?;
                        let x2 = self.parse_expression()?;
                        self.expect(&Token::Comma)?;
                        let y2 = self.parse_expression()?;
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "XPRINT_LINE".to_string(),
                            args: vec![x1, y1, x2, y2],
                            line,
                        }));
                    }
                    if xop == "BOX" {
                        self.advance();
                        let x1 = self.parse_expression()?;
                        self.expect(&Token::Comma)?;
                        let y1 = self.parse_expression()?;
                        self.expect(&Token::Comma)?;
                        let x2 = self.parse_expression()?;
                        self.expect(&Token::Comma)?;
                        let y2 = self.parse_expression()?;
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "XPRINT_BOX".to_string(),
                            args: vec![x1, y1, x2, y2],
                            line,
                        }));
                    }
                    if xop == "COLOR" {
                        // XPRINT COLOR r[, g[, b]] RGB components (batch 118)
                        self.advance(); // consume COLOR
                        let mut cargs = vec![self.parse_expression()?];
                        while self.peek() == &Token::Comma {
                            self.advance();
                            cargs.push(self.parse_expression()?);
                        }
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "XPRINT_COLOR".to_string(),
                            args: cargs,
                            line,
                        }));
                    }
                    if xop == "WIDTH" {
                        self.advance();
                        let w = self.parse_expression()?;
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "XPRINT_WIDTH".to_string(),
                            args: vec![w],
                            line,
                        }));
                    }
                    if xop == "STYLE" {
                        self.advance();
                        let st = self.parse_expression()?;
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "XPRINT_STYLE".to_string(),
                            args: vec![st],
                            line,
                        }));
                    }
                    if xop == "PRINT" {
                        self.advance();
                        let mut args = Vec::new();
                        while !matches!(self.peek(), Token::Eol | Token::Colon | Token::Eof) {
                            if matches!(self.peek(), Token::Comma | Token::Semicolon) {
                                self.advance();
                                continue;
                            }
                            args.push(self.parse_expression()?);
                        }
                        return Ok(Statement::Call(CallStmt {
                            name: "XPRINT_PRINT".to_string(),
                            args,
                            line,
                        }));
                    }
                    if xop == "GET" {
                        self.advance();
                        let sub = self.peek_plain_upper();
                        if sub == "PPI" || sub == "SIZE" {
                            // XPRINT GET PPI TO x&, y& | XPRINT GET SIZE TO w&, h&
                            self.advance();
                            self.expect(&Token::To)?;
                            let a = self.parse_expression()?;
                            self.expect(&Token::Comma)?;
                            let b = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: format!("XPRINT_GET_{}", sub),
                                args: vec![a, b],
                                line,
                            }));
                        }
                        if sub == "DC" {
                            // XPRINT GET DC TO hdc&
                            self.advance();
                            self.expect(&Token::To)?;
                            let dst = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_GET_DC".to_string(),
                                args: vec![dst],
                                line,
                            }));
                        }
                        if sub == "ATTACH" {
                            self.advance();
                            self.expect(&Token::To)?;
                            let v = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_GET_ATTACH".to_string(),
                                args: vec![v],
                                line,
                            }));
                        }
                        if sub == "POS" {
                            self.advance();
                            self.expect(&Token::To)?;
                            let x = self.parse_expression()?;
                            self.expect(&Token::Comma)?;
                            let y = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_GET_POS".to_string(),
                                args: vec![x, y],
                                line,
                            }));
                        }
                        if sub == "MIX" {
                            self.advance();
                            self.expect(&Token::To)?;
                            let v = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_GET_MIX".to_string(),
                                args: vec![v],
                                line,
                            }));
                        }
                        if sub == "STRETCHMODE" {
                            self.advance();
                            self.expect(&Token::To)?;
                            let v = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_GET_STRETCHMODE".to_string(),
                                args: vec![v],
                                line,
                            }));
                        }
                        if sub == "CLIENT" {
                            self.advance();
                            self.expect(&Token::To)?;
                            let w = self.parse_expression()?;
                            self.expect(&Token::Comma)?;
                            let h = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_GET_CLIENT".to_string(),
                                args: vec![w, h],
                                line,
                            }));
                        }
                        if sub == "CANVAS" {
                            self.advance();
                            self.expect(&Token::To)?;
                            let w = self.parse_expression()?;
                            self.expect(&Token::Comma)?;
                            let h = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_GET_CANVAS".to_string(),
                                args: vec![w, h],
                                line,
                            }));
                        }
                        if sub == "WRAP" {
                            self.advance();
                            self.expect(&Token::To)?;
                            let v = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_GET_WRAP".to_string(),
                                args: vec![v],
                                line,
                            }));
                        }
                        if sub == "WORDWRAP" {
                            self.advance();
                            self.expect(&Token::To)?;
                            let v = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_GET_WORDWRAP".to_string(),
                                args: vec![v],
                                line,
                            }));
                        }
                        if sub == "OVERLAP" {
                            self.advance();
                            self.expect(&Token::To)?;
                            let v = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_GET_OVERLAP".to_string(),
                                args: vec![v],
                                line,
                            }));
                        }
                        if sub == "CLIP" {
                            self.advance();
                            self.expect(&Token::To)?;
                            let x1 = self.parse_expression()?;
                            self.expect(&Token::Comma)?;
                            let y1 = self.parse_expression()?;
                            self.expect(&Token::Comma)?;
                            let x2 = self.parse_expression()?;
                            self.expect(&Token::Comma)?;
                            let y2 = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_GET_CLIP".to_string(),
                                args: vec![x1, y1, x2, y2],
                                line,
                            }));
                        }
                        if sub == "SCALE" {
                            self.advance();
                            self.expect(&Token::To)?;
                            let w = self.parse_expression()?;
                            self.expect(&Token::Comma)?;
                            let h = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_GET_SCALE".to_string(),
                                args: vec![w, h],
                                line,
                            }));
                        }
                        if sub == "LINES" {
                            self.advance();
                            self.expect(&Token::To)?;
                            let n = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_GET_LINES".to_string(),
                                args: vec![n],
                                line,
                            }));
                        }
                        if sub == "COPIES" {
                            self.advance();
                            self.expect(&Token::To)?;
                            let v = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_GET_COPIES".to_string(),
                                args: vec![v],
                                line,
                            }));
                        }
                        if sub == "ORIENTATION" {
                            self.advance();
                            self.expect(&Token::To)?;
                            let v = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_GET_ORIENTATION".to_string(),
                                args: vec![v],
                                line,
                            }));
                        }
                        if sub == "QUALITY" {
                            self.advance();
                            self.expect(&Token::To)?;
                            let v = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_GET_QUALITY".to_string(),
                                args: vec![v],
                                line,
                            }));
                        }
                        if sub == "DUPLEX" {
                            self.advance();
                            self.expect(&Token::To)?;
                            let v = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_GET_DUPLEX".to_string(),
                                args: vec![v],
                                line,
                            }));
                        }
                        if sub == "COLLATE" {
                            self.advance();
                            self.expect(&Token::To)?;
                            let v = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_GET_COLLATE".to_string(),
                                args: vec![v],
                                line,
                            }));
                        }
                        if sub == "COLORMODE" {
                            self.advance();
                            self.expect(&Token::To)?;
                            let v = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_GET_COLORMODE".to_string(),
                                args: vec![v],
                                line,
                            }));
                        }
                        if sub == "PAGES" {
                            self.advance();
                            self.expect(&Token::To)?;
                            let v = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_GET_PAGES".to_string(),
                                args: vec![v],
                                line,
                            }));
                        }
                        if sub == "SELECTION" {
                            self.advance();
                            self.expect(&Token::To)?;
                            let v = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_GET_SELECTION".to_string(),
                                args: vec![v],
                                line,
                            }));
                        }
                        if sub == "PAPER" {
                            self.advance();
                            self.expect(&Token::To)?;
                            let v = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_GET_PAPER".to_string(),
                                args: vec![v],
                                line,
                            }));
                        }
                        if sub == "TRAY" {
                            self.advance();
                            self.expect(&Token::To)?;
                            let v = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_GET_TRAY".to_string(),
                                args: vec![v],
                                line,
                            }));
                        }
                        if sub == "PAPERS" {
                            self.advance();
                            self.expect(&Token::To)?;
                            let v = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_GET_PAPERS".to_string(),
                                args: vec![v],
                                line,
                            }));
                        }
                        if sub == "TRAYS" {
                            self.advance();
                            self.expect(&Token::To)?;
                            let v = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_GET_TRAYS".to_string(),
                                args: vec![v],
                                line,
                            }));
                        }
                        if sub == "MARGIN" {
                            self.advance();
                            self.expect(&Token::To)?;
                            let l = self.parse_expression()?;
                            self.expect(&Token::Comma)?;
                            let t = self.parse_expression()?;
                            self.expect(&Token::Comma)?;
                            let r = self.parse_expression()?;
                            self.expect(&Token::Comma)?;
                            let b = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_GET_MARGIN".to_string(),
                                args: vec![l, t, r, b],
                                line,
                            }));
                        }
                        if sub == "COLOR" {
                            self.advance();
                            self.expect(&Token::To)?;
                            let c = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_GET_COLOR".to_string(),
                                args: vec![c],
                                line,
                            }));
                        }
                        if sub == "PIXEL" {
                            self.advance();
                            let x = self.parse_expression()?;
                            self.expect(&Token::Comma)?;
                            let y = self.parse_expression()?;
                            self.expect(&Token::To)?;
                            let c = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_GET_PIXEL".to_string(),
                                args: vec![x, y, c],
                                line,
                            }));
                        }
                        if sub == "TEXTALIGN" {
                            self.advance();
                            self.expect(&Token::To)?;
                            let a = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_GET_TEXTALIGN".to_string(),
                                args: vec![a],
                                line,
                            }));
                        }
                    }
                    if xop == "SET" {
                        self.advance();
                        let sub = self.peek_plain_upper();
                        if sub == "POS" {
                            self.advance();
                            let x = self.parse_expression()?;
                            self.expect(&Token::Comma)?;
                            let y = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_SET_POS".to_string(),
                                args: vec![x, y],
                                line,
                            }));
                        }
                        if sub == "FONT" {
                            self.advance();
                            let name = self.parse_expression()?;
                            self.expect(&Token::Comma)?;
                            let size = self.parse_expression()?;
                            self.expect(&Token::Comma)?;
                            let bold = self.parse_expression()?;
                            self.expect(&Token::Comma)?;
                            let italic = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_SET_FONT".to_string(),
                                args: vec![name, size, bold, italic],
                                line,
                            }));
                        }
                        if sub == "MIX" {
                            self.advance();
                            let v = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_SET_MIX".to_string(),
                                args: vec![v],
                                line,
                            }));
                        }
                        if sub == "STRETCHMODE" {
                            self.advance();
                            let v = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_SET_STRETCHMODE".to_string(),
                                args: vec![v],
                                line,
                            }));
                        }
                        if sub == "WRAP" {
                            self.advance();
                            let v = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_SET_WRAP".to_string(),
                                args: vec![v],
                                line,
                            }));
                        }
                        if sub == "WORDWRAP" {
                            self.advance();
                            let v = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_SET_WORDWRAP".to_string(),
                                args: vec![v],
                                line,
                            }));
                        }
                        if sub == "OVERLAP" {
                            self.advance();
                            let v = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_SET_OVERLAP".to_string(),
                                args: vec![v],
                                line,
                            }));
                        }
                        if sub == "CLIP" {
                            self.advance();
                            let x1 = self.parse_expression()?;
                            self.expect(&Token::Comma)?;
                            let y1 = self.parse_expression()?;
                            self.expect(&Token::Comma)?;
                            let x2 = self.parse_expression()?;
                            self.expect(&Token::Comma)?;
                            let y2 = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_SET_CLIP".to_string(),
                                args: vec![x1, y1, x2, y2],
                                line,
                            }));
                        }
                        if sub == "COPIES" {
                            self.advance();
                            let v = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_SET_COPIES".to_string(),
                                args: vec![v],
                                line,
                            }));
                        }
                        if sub == "ORIENTATION" {
                            self.advance();
                            let v = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_SET_ORIENTATION".to_string(),
                                args: vec![v],
                                line,
                            }));
                        }
                        if sub == "QUALITY" {
                            self.advance();
                            let v = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_SET_QUALITY".to_string(),
                                args: vec![v],
                                line,
                            }));
                        }
                        if sub == "DUPLEX" {
                            self.advance();
                            let v = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_SET_DUPLEX".to_string(),
                                args: vec![v],
                                line,
                            }));
                        }
                        if sub == "COLLATE" {
                            self.advance();
                            let v = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_SET_COLLATE".to_string(),
                                args: vec![v],
                                line,
                            }));
                        }
                        if sub == "COLORMODE" {
                            self.advance();
                            let v = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_SET_COLORMODE".to_string(),
                                args: vec![v],
                                line,
                            }));
                        }
                        if sub == "PAGES" {
                            self.advance();
                            let v = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_SET_PAGES".to_string(),
                                args: vec![v],
                                line,
                            }));
                        }
                        if sub == "PAPER" {
                            self.advance();
                            let v = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_SET_PAPER".to_string(),
                                args: vec![v],
                                line,
                            }));
                        }
                        if sub == "TRAY" {
                            self.advance();
                            let v = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_SET_TRAY".to_string(),
                                args: vec![v],
                                line,
                            }));
                        }
                        if sub == "COLOR" {
                            self.advance();
                            let c = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_SET_COLOR".to_string(),
                                args: vec![c],
                                line,
                            }));
                        }
                        if sub == "PIXEL" {
                            self.advance();
                            let x = self.parse_expression()?;
                            self.expect(&Token::Comma)?;
                            let y = self.parse_expression()?;
                            self.expect(&Token::Comma)?;
                            let c = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_SET_PIXEL".to_string(),
                                args: vec![x, y, c],
                                line,
                            }));
                        }
                        if sub == "TEXTALIGN" {
                            self.advance();
                            let a = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "XPRINT_SET_TEXTALIGN".to_string(),
                                args: vec![a],
                                line,
                            }));
                        }
                    }
                    // fallback: consume rest as noop for unimplemented XPRINT verbs
                    self.consume_to_eol();
                    return Ok(Statement::Noop("XPRINT_".to_string() + &xop, line));
                }

                if name_upper == "MENU" {
                    self.advance(); // consume MENU
                    let op = self.peek_plain_upper();
                    if op == "NEW" {
                        self.advance();
                        let kind = self.peek_plain_upper();
                        if kind == "BAR" || kind == "POPUP" {
                            self.advance();
                        }
                        let mut args = Vec::new();
                        if matches!(self.peek(), Token::To) {
                            self.advance();
                            args.push(self.parse_expression()?);
                        }
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: if kind == "POPUP" {
                                "MENU_NEW_POPUP".to_string()
                            } else {
                                "MENU_NEW_BAR".to_string()
                            },
                            args,
                            line,
                        }));
                    }
                    if op == "ADD" {
                        self.advance();
                        let mut kind = String::new();
                        if matches!(self.peek(), Token::String_) {
                            self.advance();
                            kind = "STRING".to_string();
                        } else {
                            let k2 = self.peek_plain_upper();
                            if k2 == "POPUP" || k2 == "STRING" {
                            self.advance();
                            kind = k2;
                            }
                            }
                            // Official PB syntax separates the sub-keyword from the first argument
                            // with a comma:  MENU ADD STRING, hMenu, txt$, id&, state&  and
                            // MENU ADD POPUP, hMenu, txt$, hPopup, state&.
                            // Accept it (and the comma-less form) alike.
                            if matches!(self.peek(), Token::Comma) {
                            self.advance();
                            }
                            let mut args = Vec::new();
                        // First arg: hMenu (before first comma)
                        if !self.at_eol_or_eof() {
                            args.push(self.parse_expression()?);
                        }
                        while self.peek() == &Token::Comma {
                            self.advance();
                            args.push(self.parse_expression()?);
                        }
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: if kind == "POPUP" {
                                "MENU_ADD_POPUP".to_string()
                            } else {
                                "MENU_ADD_STRING".to_string()
                            },
                            args,
                            line,
                        }));
                    }
                    if op == "DELETE" {
                        self.advance();
                        let mut args = vec![self.parse_expression()?];
                        while self.peek() == &Token::Comma {
                            self.advance();
                            args.push(self.parse_expression()?);
                        }
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "MENU_DELETE".to_string(),
                            args,
                            line,
                        }));
                    }
                    if op == "GET" || op == "SET" {
                        self.advance();
                        let sub = self.peek_plain_upper();
                        let is_text = sub == "TEXT";
                        if is_text || sub == "STATE" {
                            self.advance();
                            let h = self.parse_expression()?;
                            let mut args = vec![h];
                            // optional BYCMD flag: MENU GET/SET ... h [, BYCMD] item TO dst
                            let bycmd;
                            if matches!(self.peek(), Token::Comma) {
                                self.advance();
                                if self.peek_plain_upper() == "BYCMD" {
                                    self.advance();
                                    bycmd = 1;
                                    self.expect(&Token::Comma)?;
                                } else {
                                    bycmd = 0;
                                }
                            } else {
                                bycmd = 0;
                            }
                            args.push(Expr::IntegerLit(bycmd));
                            let pos = self.parse_expression()?;
                            args.push(pos);
                            if op == "GET" {
                                self.expect(&Token::To)?;
                                let dst = self.parse_expression()?;
                                args.push(dst);
                            } else {
                                self.expect(&Token::Comma)?;
                                let val = self.parse_expression()?;
                                args.push(val);
                            }
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: if is_text {
                                    if op == "GET" {
                                        "MENU_GET_TEXT".to_string()
                                    } else {
                                        "MENU_SET_TEXT".to_string()
                                    }
                                } else if op == "GET" {
                                    "MENU_GET_STATE".to_string()
                                } else {
                                    "MENU_SET_STATE".to_string()
                                },
                                args,
                                line,
                            }));
                        }
                    }
                }

                // COLOR fore& [, back&] — console text attribute (PB/CC, batch 49)
                if name_upper == "COLOR" {
                    self.advance(); // consume COLOR
                    let mut args = Vec::new();
                    if self.peek() != &Token::Eol {
                        args.push(self.parse_expression()?);
                        if self.peek() == &Token::Comma {
                            self.advance();
                            args.push(self.parse_expression()?);
                        }
                    }
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "COLOR".to_string(),
                        args,
                        line,
                    }));
                }

                // MEMORY COPY src&, dst&, count& | MEMORY SWAP src&, dst&, count&
                // MEMORY FILL dst&, count&, BYTE|WORD|DWORD expr | MEMORY FILL dst&, count&, str$
                if name_upper == "MEMORY" {
                    self.advance(); // consume MEMORY
                    let op = self.peek_plain_upper();
                    if op == "COPY" || op == "SWAP" {
                        self.advance(); // consume COPY / SWAP
                        let src = self.parse_expression()?;
                        self.expect(&Token::Comma)?;
                        let dst = self.parse_expression()?;
                        self.expect(&Token::Comma)?;
                        let cnt = self.parse_expression()?;
                        return Ok(Statement::Call(CallStmt {
                            name: format!("MEMORY_{}", op),
                            args: vec![src, dst, cnt],
                            line,
                        }));
                    } else if op == "FILL" {
                        self.advance(); // consume FILL
                        let dst = self.parse_expression()?;
                        self.expect(&Token::Comma)?;
                        let cnt = self.parse_expression()?;
                        self.expect(&Token::Comma)?;
                        // optional BYTE|WORD|DWORD width prefix before the value
                        let w = self.peek_plain_upper();
                        if w == "BYTE" || w == "WORD" || w == "DWORD" {
                            self.advance(); // consume width keyword
                            let v = self.parse_expression()?;
                            let width = if w == "BYTE" {
                                1
                            } else if w == "WORD" {
                                2
                            } else {
                                4
                            };
                            return Ok(Statement::Call(CallStmt {
                                name: "MEMORY_FILL".to_string(),
                                args: vec![dst, cnt, v, Expr::IntegerLit(width as i64)],
                                line,
                            }));
                        }
                        let v = self.parse_expression()?;
                        return Ok(Statement::Call(CallStmt {
                            name: "MEMORY_FILLS".to_string(),
                            args: vec![dst, cnt, v],
                            line,
                        }));
                    }
                }

                // FONT NEW fontname$ [, points! , style& , charset& , pitch& , escapement& ] TO fhndl
                // FONT END fhndl
                if name_upper == "FONT" {
                    self.advance(); // consume FONT
                    let op = self.peek_plain_upper();
                    if op == "NEW" {
                        self.advance(); // consume NEW
                        let mut args = vec![self.parse_expression()?]; // fontname$
                                                                       // optional comma-separated args (points, style, charset, pitch, escapement)
                        while self.peek() == &Token::Comma {
                            self.advance();
                            args.push(self.parse_expression()?);
                        }
                        // TO fhndl (TO is a reserved-word token, not an Identifier)
                        if matches!(self.peek(), Token::To) {
                            self.advance();
                            args.push(self.parse_expression()?);
                        }
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "FONT_NEW".to_string(),
                            args,
                            line,
                        }));
                    }
                    if op == "END" {
                        self.advance(); // consume END
                        let args = vec![self.parse_expression()?];
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "FONT_END".to_string(),
                            args,
                            line,
                        }));
                    }
                }

                // IMAGELIST NEW BITMAP|ICON w&, h&, depth&, initial& TO hLst
                // IMAGELIST GET COUNT hLst TO dataValue&
                // IMAGELIST KILL hLst
                if name_upper == "IMAGELIST" {
                    self.advance(); // consume IMAGELIST
                    let op = self.peek_plain_upper();
                    if op == "NEW" {
                        self.advance(); // consume NEW
                        let kind = self.peek_plain_upper();
                        if kind == "BITMAP" || kind == "ICON" {
                            self.advance();
                        }
                        let mut args = vec![self.parse_expression()?]; // nWidth
                        while self.peek() == &Token::Comma {
                            self.advance();
                            args.push(self.parse_expression()?);
                        }
                        if matches!(self.peek(), Token::To) {
                            self.advance();
                            args.push(self.parse_expression()?);
                        }
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "IMAGELIST_NEW".to_string(),
                            args,
                            line,
                        }));
                    }
                    if op == "GET" {
                        self.advance(); // consume GET
                        if self.peek_plain_upper() == "COUNT" {
                            self.advance(); // consume COUNT
                        }
                        let mut args = vec![self.parse_expression()?]; // hLst
                        if matches!(self.peek(), Token::To) {
                            self.advance();
                            args.push(self.parse_expression()?);
                        }
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "IMAGELIST_COUNT".to_string(),
                            args,
                            line,
                        }));
                    }
                    if op == "KILL" {
                        self.advance(); // consume KILL
                        let args = vec![self.parse_expression()?];
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "IMAGELIST_KILL".to_string(),
                            args,
                            line,
                        }));
                    }
                }

                // MAT a() = CON | CON(expr) | IDN | ZER | src() | src()+src() |
                //      src()-src() | src()*src() | (expr)*src() | INV(src()) | TRN(src())
                if name_upper == "MAT" {
                    self.advance(); // consume MAT
                    return self.parse_mat_statement(line);
                }

                // REGEXPR mask$ IN target$ [AT start&] TO iPos& [, iLen&]
                if name_upper == "REGEXPR" {
                    self.advance(); // consume REGEXPR
                    let mask = self.parse_expression()?;
                    // expect IN
                    if !matches!(self.peek(), Token::Identifier(id) if id.eq_ignore_ascii_case("IN"))
                    {
                        return Err(PbError::parser(
                            "REGEXPR: expected IN".to_string(),
                            self.current_file(),
                            self.current_line(),
                        ));
                    }
                    self.advance();
                    let target = self.parse_expression()?;
                    let mut start = None;
                    if matches!(self.peek(), Token::Identifier(id) if id.eq_ignore_ascii_case("AT"))
                    {
                        self.advance();
                        start = Some(self.parse_expression()?);
                    }
                    // expect TO
                    if !matches!(self.peek(), Token::To) {
                        return Err(PbError::parser(
                            "REGEXPR: expected TO".to_string(),
                            self.current_file(),
                            self.current_line(),
                        ));
                    }
                    self.advance();
                    let pos_var = self.parse_expression()?;
                    let mut len_var = None;
                    if matches!(self.peek(), Token::Comma) {
                        self.advance();
                        len_var = Some(self.parse_expression()?);
                    }
                    self.consume_to_eol();
                    return Ok(Statement::Regexpr {
                        mask,
                        target,
                        start,
                        pos_var,
                        len_var,
                    });
                }

                // REGREPL mask$ IN target$ WITH repl$ [AT start&] TO iPos&, newtarget$
                if name_upper == "REGREPL" {
                    self.advance(); // consume REGREPL
                    let mask = self.parse_expression()?;
                    if !matches!(self.peek(), Token::Identifier(id) if id.eq_ignore_ascii_case("IN"))
                    {
                        return Err(PbError::parser(
                            "REGREPL: expected IN".to_string(),
                            self.current_file(),
                            self.current_line(),
                        ));
                    }
                    self.advance();
                    let target = self.parse_expression()?;
                    if !matches!(self.peek(), Token::Identifier(id) if id.eq_ignore_ascii_case("WITH"))
                    {
                        return Err(PbError::parser(
                            "REGREPL: expected WITH".to_string(),
                            self.current_file(),
                            self.current_line(),
                        ));
                    }
                    self.advance();
                    let repl = self.parse_expression()?;
                    let mut start = None;
                    if matches!(self.peek(), Token::Identifier(id) if id.eq_ignore_ascii_case("AT"))
                    {
                        self.advance();
                        start = Some(self.parse_expression()?);
                    }
                    if !matches!(self.peek(), Token::To) {
                        return Err(PbError::parser(
                            "REGREPL: expected TO".to_string(),
                            self.current_file(),
                            self.current_line(),
                        ));
                    }
                    self.advance();
                    let pos_var = self.parse_expression()?;
                    if !matches!(self.peek(), Token::Comma) {
                        return Err(PbError::parser(
                            "REGREPL: expected , before target".to_string(),
                            self.current_file(),
                            self.current_line(),
                        ));
                    }
                    self.advance();
                    let out_var = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Regrepl {
                        mask,
                        target,
                        repl,
                        start,
                        pos_var,
                        out_var,
                    });
                }

                // PROFILE filename$ — dump per-procedure call counts + ms
                if name_upper == "PROFILE" {
                    self.advance(); // consume PROFILE
                    let filename = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Profile(filename));
                }

                // CALLSTK filename$ — dump call stack to a sequential file
                if name_upper == "CALLSTK" {
                    self.advance(); // consume CALLSTK
                    let filename = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::CallStk(filename));
                }

                // FIELD #n, size AS var [, size2 AS var2 ...]
                // FIELD dyn$, size AS var [, ...]
                // FIELD RESET var [, ...]  /  FIELD STRING var [, ...]
                if name_upper == "FIELD" {
                    self.advance(); // consume FIELD
                    return self.parse_field_statement(line);
                }

                // ASM opcode ... — inline assembly (keyword form). Rebuild the
                // line text from tokens (brackets, commas, identifiers, ints).
                if name_upper == "ASM" {
                    self.advance(); // consume ASM
                    let mut parts: Vec<String> = Vec::new();
                    loop {
                        match self.peek() {
                            Token::Eol | Token::Eof | Token::Colon => break,
                            Token::Semicolon => {
                                self.consume_to_eol();
                                break;
                            }
                            Token::Identifier(w) => {
                                parts.push(w.clone());
                                self.advance();
                            }
                            Token::IntegerLiteral(v) => {
                                parts.push(v.to_string());
                                self.advance();
                            }
                            Token::Minus => {
                                parts.push("-".to_string());
                                self.advance();
                            }
                            Token::Comma => {
                                parts.push(",".to_string());
                                self.advance();
                            }
                            Token::LBracket => {
                                parts.push("[".to_string());
                                self.advance();
                            }
                            Token::RBracket => {
                                parts.push("]".to_string());
                                self.advance();
                            }
                            _ => {
                                self.advance();
                            }
                        }
                    }
                    // Rebuild with Intel spacing: "MOV EAX, 123", negatives merged.
                    let mut out = String::new();
                    let mut prev_minus = false;
                    for pt in &parts {
                        if pt == "-" {
                            prev_minus = true;
                            continue;
                        }
                        if prev_minus {
                            out.push('-');
                            out.push_str(pt);
                            prev_minus = false;
                            continue;
                        }
                        if pt == "," {
                            out.push_str(", ");
                            continue;
                        }
                        if !out.is_empty() {
                            out.push(' ');
                        }
                        out.push_str(pt);
                    }
                    return Ok(Statement::Asm(out));
                }

                // DIR mask [, [ONLY] attr] TO s$ | DIR NEXT TO s$ | DIR CLOSE | DIR$ CLOSE
                if name_upper == "DIR" || name_upper == "DIR$" {
                    self.advance(); // consume DIR / DIR$
                    let up2 = self.peek_plain_upper();
                    if up2 == "CLOSE" || matches!(self.peek(), Token::Close) {
                        self.advance();
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "DIR CLOSE".to_string(),
                            args: Vec::new(),
                            line,
                        }));
                    }
                    if up2 == "NEXT" || matches!(self.peek(), Token::Next) {
                        self.advance();
                        self.expect(&Token::To)?;
                        let target = self.parse_expression()?;
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "DIR NEXT".to_string(),
                            args: vec![target],
                            line,
                        }));
                    }
                    // DIR mask [, [ONLY] attr] TO target$
                    let mask = self.parse_expression()?;
                    let mut args = vec![mask];
                    while self.peek() == &Token::Comma {
                        self.advance();
                        if let Token::Identifier(w) = self.peek() {
                            if w.eq_ignore_ascii_case("ONLY") {
                                self.advance();
                                let attr = self.parse_expression()?;
                                args.push(Expr::IntegerLit(1)); // ONLY flag
                                args.push(attr);
                                continue;
                            }
                        }
                        let attr = self.parse_expression()?;
                        args.push(attr);
                    }
                    self.expect(&Token::To)?;
                    let target = self.parse_expression()?;
                    args.push(target);
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "DIR".to_string(),
                        args,
                        line,
                    }));
                }

                // TRY ... CATCH ... [FINALLY ...] END TRY  (batch 26)
                // Structured error trap: body until CATCH/FINALLY/END TRY,
                // catch until FINALLY/END TRY, finally until END TRY.
                if name_upper == "TRY" {
                    self.advance(); // consume TRY
                    self.skip_eol();
                    let line_start = line;
                    let mut try_body = Vec::new();
                    let mut catch_body = Vec::new();
                    let mut finally_body = Vec::new();
                    let mut in_catch = false;
                    let mut in_finally = false;
                    loop {
                        // Block keywords: CATCH / FINALLY / END TRY
                        if let Token::Identifier(ref kw) = self.peek().clone() {
                            let kw_upper = kw.to_uppercase();
                            if kw_upper == "CATCH" && !in_catch && !in_finally {
                                self.advance();
                                self.consume_to_eol();
                                self.skip_eol();
                                in_catch = true;
                                continue;
                            }
                            if kw_upper == "FINALLY" && !in_finally {
                                self.advance();
                                self.consume_to_eol();
                                self.skip_eol();
                                in_finally = true;
                                in_catch = false;
                                continue;
                            }
                        }
                        if let Token::End = self.peek() {
                            if let Some(Token::Identifier(ref kw)) = self.peek_at(1) {
                                if kw.eq_ignore_ascii_case("TRY") {
                                    self.advance(); // consume END
                                    self.advance(); // consume TRY
                                    self.skip_eol();
                                    return Ok(Statement::Try(TryStmt {
                                        body: try_body,
                                        catch: catch_body,
                                        finally: finally_body,
                                        line: line_start,
                                    }));
                                }
                            }
                        }
                        if self.peek() == &Token::Eof {
                            break;
                        }
                        let stmt = self.parse_statement()?;
                        if in_finally {
                            finally_body.push(stmt);
                        } else if in_catch {
                            catch_body.push(stmt);
                        } else {
                            try_body.push(stmt);
                        }
                        self.skip_eol();
                    }
                    return Ok(Statement::Try(TryStmt {
                        body: try_body,
                        catch: catch_body,
                        finally: finally_body,
                        line: line_start,
                    }));
                }

                // SWAP var1, var2 — exchange two variables
                if name_upper == "SWAP" {
                    self.advance(); // consume SWAP
                    let mut args = Vec::new();
                    if !self.at_eol_or_eof() {
                        args.push(self.parse_expression()?);
                        while self.peek() == &Token::Comma {
                            self.advance();
                            args.push(self.parse_expression()?);
                        }
                    }
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "SWAP".to_string(),
                        args,
                        line,
                    }));
                }

                // DDT statements: DIALOG, CONTROL, MENU, TOOLBAR, STATUSBAR
                // COMBOBOX, LISTBOX, TREEVIEW, LISTVIEW, XPRINT — DDT UI verbs
                // SLEEP, RANDOMIZE, MKDIR, BEEP — parse arg, emit as function call
                if matches!(
                    name_upper.as_str(),
                    "SLEEP" | "RANDOMIZE" | "MKDIR" | "RMDIR" | "CHDIR" | "BEEP"
                ) {
                    let call_name = name_upper.clone();
                    self.advance();
                    let args = if !self.at_eol_or_eof() {
                        vec![self.parse_expression()?]
                    } else {
                        Vec::new()
                    };
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: call_name,
                        args,
                        line,
                    }));
                }

                // DESKTOP GET SIZE/CLIENT/LOC/PPI TO ...
                if name_upper == "DESKTOP"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase() == "GET")
                {
                    let what = match self.peek_at(2) {
                        Some(Token::Identifier(w)) => w.to_uppercase(),
                        _ => String::new(),
                    };
                    if matches!(what.as_str(), "SIZE" | "CLIENT" | "LOC" | "PPI") {
                        self.advance(); // consume DESKTOP
                        self.advance(); // consume GET
                        self.advance(); // consume SIZE/CLIENT/LOC/PPI
                        if self.peek() == &Token::To {
                            self.advance(); // consume TO (reserved word)
                        }
                        let mut args = vec![self.parse_expression()?];
                        while self.peek() == &Token::Comma {
                            self.advance();
                            args.push(self.parse_expression()?);
                        }
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: format!("DESKTOP GET {what}"),
                            args,
                            line,
                        }));
                    }
                }

                // DISPLAY common dialogs (batch 118): wire parser to existing codegen/runtime.
                //   DISPLAY OPENFILE title$, filter$, initialdir$ TO result$
                //   DISPLAY SAVEFILE title$, filter$, initialdir$ TO result$
                //   DISPLAY BROWSE   title$, initialdir$ TO result$
                //   DISPLAY COLOR    TO result&
                //   DISPLAY FONT     TO result$
                if name_upper == "DISPLAY" {
                    if let Some(Token::Identifier(w)) = self.peek_at(1) {
                        let sub = w.to_uppercase();
                        if matches!(
                            sub.as_str(),
                            "OPENFILE" | "SAVEFILE" | "BROWSE" | "COLOR" | "FONT"
                        ) {
                            self.advance(); // consume DISPLAY
                            self.advance(); // consume sub-op
                            let mut args = Vec::new();
                            if sub == "COLOR" || sub == "FONT" {
                                if self.peek() == &Token::To {
                                    self.advance(); // consume TO
                                }
                                args.push(self.parse_expression()?);
                            } else {
                                // input string expressions, then `TO result`
                                args.push(self.parse_expression()?);
                                while self.peek() == &Token::Comma {
                                    self.advance();
                                    args.push(self.parse_expression()?);
                                }
                                if self.peek() == &Token::To {
                                    self.advance(); // consume TO
                                    args.push(self.parse_expression()?);
                                }
                            }
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: format!("DISPLAY_{sub}"),
                                args,
                                line,
                            }));
                        }
                    }
                }

                if matches!(name_upper.as_str(), "LSET" | "RSET") {
                    self.advance(); // consume LSET/RSET
                                    // LSET target$ = value  (and RSET)
                    let target = self.parse_primary()?;
                    if self.peek() == &Token::Eq {
                        self.advance();
                    }
                    let value = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: name_upper.clone(),
                        args: vec![target, value],
                        line,
                    }));
                }

                if matches!(name_upper.as_str(), "CSET") {
                    self.advance(); // consume CSET
                                    // CSET [ABS] result_var = string_expression [USING ...]
                                    // (ABS / USING not supported yet — plain centering only)
                    let target = self.parse_primary()?;
                    if self.peek() == &Token::Eq {
                        self.advance();
                    }
                    let value = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "CSET".to_string(),
                        args: vec![target, value],
                        line,
                    }));
                }

                // WRITE #filenum, expr, ...  (CSV-style record)
                if name_upper == "WRITE" && self.peek_at(1) == Some(&Token::Hash) {
                    self.advance(); // consume WRITE
                    self.advance(); // consume #
                    let file_num = self.parse_expression()?;
                    let mut args = vec![file_num];
                    while self.peek() == &Token::Comma {
                        self.advance();
                        args.push(self.parse_expression()?);
                    }
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "WRITE".to_string(),
                        args,
                        line,
                    }));
                }
                // RESOURCE SAVE FILE resname$, filename$ (batch 118 wiring fix)
                if name_upper == "RESOURCE"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase() == "SAVE")
                    && matches!(self.peek_at(2), Some(Token::Identifier(w)) if w.to_uppercase() == "FILE")
                {
                    self.advance(); // RESOURCE
                    self.advance(); // SAVE
                    self.advance(); // FILE
                    let rn = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let fn_ = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "RESOURCE_SAVE_FILE".to_string(),
                        args: vec![rn, fn_],
                        line,
                    }));
                }
                // PLAY WAVE "file.wav" — two-word statement
                if name_upper == "PLAY"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase() == "WAVE")
                {
                    self.advance(); // consume PLAY
                    self.advance(); // consume WAVE
                    let mut args = vec![self.parse_expression()?];
                    while self.peek() == &Token::Comma {
                        self.advance();
                        args.push(self.parse_expression()?);
                    }
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "PLAY WAVE".to_string(),
                        args,
                        line,
                    }));
                }
                // PLAY SOUND freq&, dur& - two-word statement (batch 118 wiring fix)
                if name_upper == "PLAY"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase() == "SOUND")
                {
                    self.advance(); // consume PLAY
                    self.advance(); // consume SOUND
                    let mut args = vec![self.parse_expression()?];
                    while self.peek() == &Token::Comma {
                        self.advance();
                        args.push(self.parse_expression()?);
                    }
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "PLAY SOUND".to_string(),
                        args,
                        line,
                    }));
                }
                // MESSAGE LOOP — run Windows message pump
                if name_upper == "MESSAGE" && self.peek_at(1) == Some(&Token::Loop) {
                    self.advance();
                    self.advance();
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "PB_MESSAGE_LOOP".to_string(),
                        args: vec![],
                        line,
                    }));
                }
                // WINDOW SET TEXT hwnd, text$ / WINDOW GET TEXT hwnd TO var$
                if name_upper == "WINDOW"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase() == "SET")
                    && matches!(self.peek_at(2), Some(Token::Identifier(w)) if w.to_uppercase() == "TEXT")
                {
                    self.advance(); // consume WINDOW
                    self.advance(); // consume SET
                    self.advance(); // consume TEXT
                    let mut args = vec![self.parse_expression()?]; // hwnd
                    self.expect(&Token::Comma)?;
                    args.push(self.parse_expression()?); // text
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "WINDOW SET TEXT".to_string(),
                        args,
                        line,
                    }));
                }
                if name_upper == "WINDOW"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase() == "GET")
                    && matches!(self.peek_at(2), Some(Token::Identifier(w)) if w.to_uppercase() == "TEXT")
                {
                    self.advance(); // consume WINDOW
                    self.advance(); // consume GET
                    self.advance(); // consume TEXT
                    let mut args = vec![self.parse_expression()?]; // hwnd
                    self.expect(&Token::To)?;
                    args.push(self.parse_expression()?); // target var
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "WINDOW GET TEXT".to_string(),
                        args,
                        line,
                    }));
                }
                // WINDOW title$, x, y, w, h TO hWnd&  (Tier-3 DDT GUI #1)
                if name_upper == "WINDOW"
                    && !matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase()=="SET" || w.to_uppercase()=="GET")
                {
                    self.advance(); // consume WINDOW
                    let title = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let x = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let y = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let w = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let h = self.parse_expression()?;
                    self.expect(&Token::To)?;
                    let target = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "WINDOW_NEW".to_string(),
                        args: vec![title, x, y, w, h, target],
                        line,
                    }));
                }
                // CONTROL ADD BUTTON, hWnd, id, "text", x, y, w, h TO hCtrl&  (Tier-3 DDT GUI #2)
                if name_upper == "CONTROL"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase()=="ADD")
                    && matches!(self.peek_at(2), Some(Token::Identifier(w)) if w.to_uppercase()=="BUTTON")
                {
                    self.advance(); // CONTROL
                    self.advance(); // ADD
                    self.advance(); // BUTTON
                    self.expect(&Token::Comma)?;
                    let hwnd = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let id = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let text = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let x = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let y = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let w = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let h = self.parse_expression()?;
                    let target = if matches!(self.peek(), Token::To) {
                        self.advance();
                        self.parse_expression()?
                    } else {
                        Expr::Variable("_ctl_dummy".to_string())
                    };
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "CONTROL_ADD_BUTTON".to_string(),
                        args: vec![hwnd, id, text, x, y, w, h, target],
                        line,
                    }));
                }
                // CONTROL ADD EDITBOX, hWnd, id, "text", x, y, w, h TO hCtrl&  (Tier-3 DDT GUI #3)
                if name_upper == "CONTROL"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase()=="ADD")
                    && matches!(self.peek_at(2), Some(Token::Identifier(w)) if w.to_uppercase()=="EDITBOX" || w.to_uppercase()=="TEXTBOX")
                {
                    self.advance();
                    self.advance();
                    self.advance();
                    self.expect(&Token::Comma)?;
                    let hwnd = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let id = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let text = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let x = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let y = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let w = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let h = self.parse_expression()?;
                    let target = if matches!(self.peek(), Token::To) {
                        self.advance();
                        self.parse_expression()?
                    } else {
                        Expr::Variable("_ctl_dummy".to_string())
                    };
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "CONTROL_ADD_EDITBOX".to_string(),
                        args: vec![hwnd, id, text, x, y, w, h, target],
                        line,
                    }));
                }
                // CONTROL GET TEXT hCtrl TO var$  OR  CONTROL GET TEXT hDlg, id TO var$  (Tier-3 DDT GUI)
                if name_upper == "CONTROL"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase()=="GET")
                    && matches!(self.peek_at(2), Some(Token::Identifier(w)) if w.to_uppercase()=="TEXT")
                {
                    self.advance();
                    self.advance();
                    self.advance();
                    let first = self.parse_expression()?;
                    if matches!(self.peek(), Token::Comma) {
                        // By-ID form: CONTROL GET TEXT hDlg, id TO var$
                        self.advance(); // comma
                        let id = self.parse_expression()?;
                        self.expect(&Token::To)?;
                        let target = self.parse_expression()?;
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "CONTROL_GET_TEXT_ID".to_string(),
                            args: vec![first, id, target],
                            line,
                        }));
                    } else {
                        // By-handle form: CONTROL GET TEXT hCtrl TO var$
                        self.expect(&Token::To)?;
                        let target = self.parse_expression()?;
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "CONTROL_GET_TEXT".to_string(),
                            args: vec![first, target],
                            line,
                        }));
                    }
                }
                // CONTROL SET TEXT hCtrl, "text"  (Tier-3 DDT GUI)
                if name_upper == "CONTROL"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase()=="SET")
                    && matches!(self.peek_at(2), Some(Token::Identifier(w)) if w.to_uppercase()=="TEXT")
                {
                    self.advance();
                    self.advance();
                    self.advance();
                    let hctrl = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let text = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "CONTROL_SET_TEXT".to_string(),
                        args: vec![hctrl, text],
                        line,
                    }));
                }
                // CONTROL SHOW/HIDE/ENABLE/DISABLE/FOCUS hCtrl&  (Tier-3 DDT GUI)
                if name_upper == "CONTROL" {
                    if let Some(Token::Identifier(w)) = self.peek_at(1) {
                        let op = w.to_uppercase();
                        let mapping = [
                            ("SHOW", "CONTROL_SHOW"),
                            ("HIDE", "CONTROL_HIDE"),
                            ("ENABLE", "CONTROL_ENABLE"),
                            ("DISABLE", "CONTROL_DISABLE"),
                            ("FOCUS", "CONTROL_FOCUS"),
                        ];
                        for (kw, arm) in mapping {
                            if op == kw {
                                self.advance();
                                self.advance();
                                let hctrl = self.parse_expression()?;
                                self.consume_to_eol();
                                return Ok(Statement::Call(CallStmt {
                                    name: arm.to_string(),
                                    args: vec![hctrl],
                                    line,
                                }));
                            }
                        }
                    }
                }
                // CONTROL CHECK/UNCHECK hCtrl&  (Tier-3 DDT GUI)
                if name_upper == "CONTROL" {
                    if let Some(Token::Identifier(w)) = self.peek_at(1) {
                        let op = w.to_uppercase();
                        let mapping = [
                            ("CHECK", "CONTROL_CHECK", false),
                            ("UNCHECK", "CONTROL_UNCHECK", false),
                        ];
                        for (kw, arm, _is_get) in mapping {
                            if op == kw {
                                self.advance();
                                self.advance();
                                let hctrl = self.parse_expression()?;
                                self.consume_to_eol();
                                return Ok(Statement::Call(CallStmt {
                                    name: arm.to_string(),
                                    args: vec![hctrl],
                                    line,
                                }));
                            }
                        }
                        // CONTROL GET CHECK hCtrl& TO var&
                        if op == "GET"
                            && matches!(self.peek_at(2), Some(Token::Identifier(w2)) if w2.to_uppercase()=="CHECK")
                        {
                            self.advance(); // CONTROL
                            self.advance(); // GET
                            self.advance(); // CHECK
                            let hctrl = self.parse_expression()?;
                            self.expect(&Token::To)?;
                            let target = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "CONTROL_GET_CHECK".to_string(),
                                args: vec![hctrl, target],
                                line,
                            }));
                        }
                    }
                }
                // CONTROL CMD hCtrl, subname  (Tier-3 DDT GUI event dispatch)
                if name_upper == "CONTROL"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase()=="CMD")
                {
                    self.advance(); // CONTROL
                    self.advance(); // CMD
                    let hctrl = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let subname = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "CONTROL_CMD".to_string(),
                        args: vec![hctrl, subname],
                        line,
                    }));
                }
                // CONTROL ADD HSCROLLBAR, hWnd, id, x, y, w, h TO hCtrl&
                if name_upper == "CONTROL"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase()=="ADD")
                    && matches!(self.peek_at(2), Some(Token::Identifier(w)) if w.to_uppercase()=="HSCROLLBAR")
                {
                    self.advance();
                    self.advance();
                    self.advance();
                    self.expect(&Token::Comma)?;
                    let parent = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let id = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let x = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let y = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let w = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let h = self.parse_expression()?;
                    self.expect(&Token::To)?;
                    let target = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "CONTROL_ADD_HSCROLLBAR".to_string(),
                        args: vec![parent, id, x, y, w, h, target],
                        line,
                    }));
                }
                // CONTROL ADD SCROLLBAR, hWnd, id, x, y, w, h TO hCtrl&
                if name_upper == "CONTROL"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase()=="ADD")
                    && matches!(self.peek_at(2), Some(Token::Identifier(w)) if w.to_uppercase()=="SCROLLBAR")
                {
                    self.advance();
                    self.advance();
                    self.advance();
                    self.expect(&Token::Comma)?;
                    let parent = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let id = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let x = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let y = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let w = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let h = self.parse_expression()?;
                    self.expect(&Token::To)?;
                    let target = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "CONTROL_ADD_SCROLLBAR".to_string(),
                        args: vec![parent, id, x, y, w, h, target],
                        line,
                    }));
                }
                // CONTROL SET POS hCtrl, pos / CONTROL GET POS hCtrl TO var
                if name_upper == "CONTROL" {
                    if let Some(Token::Identifier(w)) = self.peek_at(1) {
                        let op = w.to_uppercase();
                        if op == "SET"
                            && matches!(self.peek_at(2), Some(Token::Identifier(w2)) if w2.to_uppercase()=="POS")
                        {
                            self.advance();
                            self.advance();
                            self.advance();
                            let hc = self.parse_expression()?;
                            self.expect(&Token::Comma)?;
                            let pos = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "CONTROL_SET_POS".to_string(),
                                args: vec![hc, pos],
                                line,
                            }));
                        }
                        if op == "GET"
                            && matches!(self.peek_at(2), Some(Token::Identifier(w2)) if w2.to_uppercase()=="POS")
                        {
                            self.advance();
                            self.advance();
                            self.advance();
                            let hc = self.parse_expression()?;
                            self.expect(&Token::To)?;
                            let target = self.parse_expression()?;
                            self.consume_to_eol();
                            return Ok(Statement::Call(CallStmt {
                                name: "CONTROL_GET_POS".to_string(),
                                args: vec![hc, target],
                                line,
                            }));
                        }
                    }
                }
                // CONTROL ADD COMBOBOX, hWnd, id, x, y, w, h TO hCtrl&
                if name_upper == "CONTROL"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase()=="ADD")
                    && matches!(self.peek_at(2), Some(Token::Identifier(w)) if w.to_uppercase()=="COMBOBOX")
                {
                    self.advance();
                    self.advance();
                    self.advance();
                    self.expect(&Token::Comma)?;
                    let hwnd = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let id = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    // optional text (string literal)
                    if matches!(self.peek(), Token::StringLiteral(_)) {
                        self.parse_expression()?;
                        self.expect(&Token::Comma)?;
                    }
                    let x = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let y = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let w = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let h = self.parse_expression()?;
                    self.expect(&Token::To)?;
                    let target = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "CONTROL_ADD_COMBOBOX".to_string(),
                        args: vec![hwnd, id, x, y, w, h, target],
                        line,
                    }));
                }
                // CONTROL ADD LISTBOX, hWnd, id, x, y, w, h TO hCtrl&
                if name_upper == "CONTROL"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase()=="ADD")
                    && matches!(self.peek_at(2), Some(Token::Identifier(w)) if w.to_uppercase()=="LISTBOX")
                {
                    self.advance();
                    self.advance();
                    self.advance();
                    self.expect(&Token::Comma)?;
                    let hwnd = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let id = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    // optional text (string literal)
                    if matches!(self.peek(), Token::StringLiteral(_)) {
                        self.parse_expression()?;
                        self.expect(&Token::Comma)?;
                    }
                    let x = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let y = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let w = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let h = self.parse_expression()?;
                    self.expect(&Token::To)?;
                    let target = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "CONTROL_ADD_LISTBOX".to_string(),
                        args: vec![hwnd, id, x, y, w, h, target],
                        line,
                    }));
                }
                // COMBOBOX ADD hCombo, "text"
                if name_upper == "COMBOBOX"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase()=="ADD")
                {
                    self.advance();
                    self.advance();
                    let hc = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let txt = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "COMBOBOX_ADD".to_string(),
                        args: vec![hc, txt],
                        line,
                    }));
                }
                // LISTBOX ADD hList, "text"
                if name_upper == "LISTBOX"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase()=="ADD")
                {
                    self.advance();
                    self.advance();
                    let hl = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let txt = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "LISTBOX_ADD".to_string(),
                        args: vec![hl, txt],
                        line,
                    }));
                }

                // LISTVIEW <sub-command> ...  (batch 158)
                if name_upper == "LISTVIEW" {
                    return self.parse_listview_statement(line);
                }
                // TREEVIEW <sub-command> ...  (batch 158)
                if name_upper == "TREEVIEW" {
                    return self.parse_treeview_statement(line);
                }
                // CONTROL ADD CHECKBOX, hWnd, id, "text", x, y, w, h TO hCtrl&
                if name_upper == "CONTROL"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase()=="ADD")
                    && matches!(self.peek_at(2), Some(Token::Identifier(w)) if w.to_uppercase()=="CHECKBOX")
                {
                    self.advance();
                    self.advance();
                    self.advance();
                    self.expect(&Token::Comma)?;
                    let hwnd = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let id = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let text = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let x = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let y = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let w = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let h = self.parse_expression()?;
                    let target = if matches!(self.peek(), Token::To) {
                        self.advance();
                        self.parse_expression()?
                    } else {
                        Expr::Variable("_ctl_dummy".to_string())
                    };
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "CONTROL_ADD_CHECKBOX".to_string(),
                        args: vec![hwnd, id, text, x, y, w, h, target],
                        line,
                    }));
                }
                // CONTROL ADD RADIOBUTTON, hWnd, id, "text", x, y, w, h TO hCtrl&
                if name_upper == "CONTROL"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase()=="ADD")
                    && matches!(self.peek_at(2), Some(Token::Identifier(w)) if w.to_uppercase()=="RADIOBUTTON" || w.to_uppercase()=="OPTION")
                {
                    self.advance();
                    self.advance();
                    self.advance();
                    self.expect(&Token::Comma)?;
                    let hwnd = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let id = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let text = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let x = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let y = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let w = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let h = self.parse_expression()?;
                    self.expect(&Token::To)?;
                    let target = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "CONTROL_ADD_RADIOBUTTON".to_string(),
                        args: vec![hwnd, id, text, x, y, w, h, target],
                        line,
                    }));
                }
                // CONTROL ADD GROUPBOX, hWnd, id, "text", x, y, w, h TO hCtrl&
                if name_upper == "CONTROL"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase()=="ADD")
                    && matches!(self.peek_at(2), Some(Token::Identifier(w)) if w.to_uppercase()=="GROUPBOX" || w.to_uppercase()=="FRAME")
                {
                    self.advance();
                    self.advance();
                    self.advance();
                    self.expect(&Token::Comma)?;
                    let hwnd = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let id = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let text = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let x = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let y = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let w = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let h = self.parse_expression()?;
                    self.expect(&Token::To)?;
                    let target = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "CONTROL_ADD_GROUPBOX".to_string(),
                        args: vec![hwnd, id, text, x, y, w, h, target],
                        line,
                    }));
                }
                // CONTROL ADD LABEL, hWnd, id, "text", x, y, w, h TO hCtrl&
                if name_upper == "CONTROL"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase()=="ADD")
                    && matches!(self.peek_at(2), Some(Token::Identifier(w)) if w.to_uppercase()=="LABEL")
                {
                    self.advance();
                    self.advance();
                    self.advance();
                    self.expect(&Token::Comma)?;
                    let hwnd = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let id = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let text = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let x = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let y = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let w = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let h = self.parse_expression()?;
                    let target = if matches!(self.peek(), Token::To) {
                        self.advance();
                        self.parse_expression()?
                    } else {
                        Expr::Variable("_ctl_dummy".to_string())
                    };
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "CONTROL_ADD_LABEL".to_string(),
                        args: vec![hwnd, id, text, x, y, w, h, target],
                        line,
                    }));
                }
                // CONTROL ADD PROGRESSBAR, hWnd, id, x, y, w, h TO hCtrl&
                if name_upper == "CONTROL"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase()=="ADD")
                    && matches!(self.peek_at(2), Some(Token::Identifier(w)) if w.to_uppercase()=="PROGRESSBAR")
                {
                    self.advance();
                    self.advance();
                    self.advance();
                    self.expect(&Token::Comma)?;
                    let hwnd = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let id = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let x = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let y = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let w = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let h = self.parse_expression()?;
                    self.expect(&Token::To)?;
                    let target = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "CONTROL_ADD_PROGRESSBAR".to_string(),
                        args: vec![hwnd, id, x, y, w, h, target],
                        line,
                    }));
                }
                // CONTROL ADD LISTVIEW, hWnd, id, x, y, w, h TO hCtrl&  (batch 158)
                if name_upper == "CONTROL"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase()=="ADD")
                    && matches!(self.peek_at(2), Some(Token::Identifier(w)) if w.to_uppercase()=="LISTVIEW")
                {
                    self.advance();
                    self.advance();
                    self.advance();
                    self.expect(&Token::Comma)?;
                    let hwnd = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let id = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let x = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let y = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let w = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let h = self.parse_expression()?;
                    self.expect(&Token::To)?;
                    let target = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "CONTROL_ADD_LISTVIEW".to_string(),
                        args: vec![hwnd, id, x, y, w, h, target],
                        line,
                    }));
                }
                // CONTROL ADD TREEVIEW, hWnd, id, x, y, w, h TO hCtrl&  (batch 158)
                if name_upper == "CONTROL"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase()=="ADD")
                    && matches!(self.peek_at(2), Some(Token::Identifier(w)) if w.to_uppercase()=="TREEVIEW")
                {
                    self.advance();
                    self.advance();
                    self.advance();
                    self.expect(&Token::Comma)?;
                    let hwnd = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let id = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let x = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let y = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let w = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let h = self.parse_expression()?;
                    self.expect(&Token::To)?;
                    let target = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "CONTROL_ADD_TREEVIEW".to_string(),
                        args: vec![hwnd, id, x, y, w, h, target],
                        line,
                    }));
                }
                // DIALOG NEW hParent, "title", x, y, w, h TO hDlg
                if name_upper == "DIALOG"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase()=="NEW")
                {
                    self.advance();
                    self.advance();
                    let parent = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let title = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    // x: empty if comma immediately follows (,,)
                    let x = if matches!(self.peek(), Token::Comma) {
                        Expr::IntegerLit(0)
                    } else {
                        self.parse_expression()?
                    };
                    self.expect(&Token::Comma)?;
                    let y = if matches!(self.peek(), Token::Comma) {
                        Expr::IntegerLit(0)
                    } else {
                        self.parse_expression()?
                    };
                    self.expect(&Token::Comma)?;
                    let w = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let h = self.parse_expression()?;
                    // Optional style, exstyle: after h, either comma (style) or To
                    let style = if matches!(self.peek(), Token::Comma) {
                        self.advance();
                        self.parse_expression()?
                    } else {
                        Expr::IntegerLit(0)
                    };
                    let exstyle = if matches!(self.peek(), Token::Comma) {
                        self.advance();
                        self.parse_expression()?
                    } else {
                        Expr::IntegerLit(0)
                    };
                    self.expect(&Token::To)?;
                    let target = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "DIALOG_NEW".to_string(),
                        args: vec![parent, title, x, y, w, h, style, exstyle, target],
                        line,
                    }));
                }
                // DIALOG SHOW MODAL hDlg CALL proc
                if name_upper == "DIALOG"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase()=="SHOW")
                {
                    self.advance();
                    self.advance();
                    // skip MODAL
                    if matches!(self.peek(), Token::Identifier(w) if w.to_uppercase()=="MODAL") {
                        self.advance();
                    }
                    let hd = self.parse_expression()?;
                    // skip CALL (Token::Call)
                    if self.peek() == &Token::Call {
                        self.advance();
                    }
                    let proc = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "DIALOG_SHOW_MODAL".to_string(),
                        args: vec![hd, proc],
                        line,
                    }));
                }
                // DIALOG END hDlg, result
                if name_upper == "DIALOG" && self.peek_at(1) == Some(&Token::End) {
                    self.advance();
                    self.advance();
                    let hd = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let result = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "DIALOG_END".to_string(),
                        args: vec![hd, result],
                        line,
                    }));
                }
                // DIALOG SET TEXT hDlg, "title"
                if name_upper == "DIALOG"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase()=="SET")
                {
                    self.advance();
                    self.advance();
                    self.advance();
                    let hd = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let txt = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "DIALOG_SET_TEXT".to_string(),
                        args: vec![hd, txt],
                        line,
                    }));
                }
                // DIALOG DOEVENTS - process pending messages non-blocking
                if name_upper == "DIALOG"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase()=="DOEVENTS")
                {
                    self.advance();
                    self.advance();
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "DIALOG_DOEVENTS".to_string(),
                        args: vec![],
                        line,
                    }));
                }
                // DIALOG CENTER hDlg
                if name_upper == "DIALOG"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase()=="CENTER")
                {
                    self.advance();
                    self.advance();
                    let hd = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "DIALOG_CENTER".to_string(),
                        args: vec![hd],
                        line,
                    }));
                }
                // CONTROL ADDSTRING hCtrl, "text"
                if name_upper == "CONTROL"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase()=="ADDSTRING")
                {
                    self.advance();
                    self.advance();
                    let hc = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let txt = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "CONTROL_ADDSTRING".to_string(),
                        args: vec![hc, txt],
                        line,
                    }));
                }
                // DIALOG GET TEXT hDlg TO var$
                if name_upper == "DIALOG"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase()=="GET")
                    && matches!(self.peek_at(2), Some(Token::Identifier(w)) if w.to_uppercase()=="TEXT")
                {
                    self.advance();
                    self.advance();
                    self.advance();
                    let hd = self.parse_expression()?;
                    self.expect(&Token::To)?;
                    let target = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "DIALOG_GET_TEXT".to_string(),
                        args: vec![hd, target],
                        line,
                    }));
                }
                // DIALOG SHOW STATE hDlg, nCmdShow (1=normal, 2=min, 3=max)
                if name_upper == "DIALOG"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase()=="SHOW")
                    && matches!(self.peek_at(2), Some(Token::Identifier(w)) if w.to_uppercase()=="STATE")
                {
                    self.advance();
                    self.advance();
                    self.advance();
                    let hd = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let state = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "DIALOG_SHOW_STATE".to_string(),
                        args: vec![hd, state],
                        line,
                    }));
                }
                // CONTROL KILL hCtrl
                if name_upper == "CONTROL"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase()=="KILL")
                {
                    self.advance();
                    self.advance();
                    let hc = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "CONTROL_KILL".to_string(),
                        args: vec![hc],
                        line,
                    }));
                }
                // CONTROL SET CHECK hCtrl, state
                if name_upper == "CONTROL"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase()=="SET")
                    && matches!(self.peek_at(2), Some(Token::Identifier(w)) if w.to_uppercase()=="CHECK")
                {
                    self.advance();
                    self.advance();
                    self.advance();
                    let hc = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let st = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "CONTROL_SET_CHECK".to_string(),
                        args: vec![hc, st],
                        line,
                    }));
                } // DIALOG MENU hDlg, hMenu
                if name_upper == "DIALOG"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase()=="MENU")
                {
                    self.advance();
                    self.advance();
                    let hd = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let hm = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "DIALOG_MENU".to_string(),
                        args: vec![hd, hm],
                        line,
                    }));
                }
                // ARRAY COPY src(), dest() / ARRAY SWAP a(), b()
                if name_upper == "ARRAY"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w))
                        if matches!(w.to_uppercase().as_str(), "COPY" | "SWAP" | "ADD"))
                {
                    let op = {
                        if let Token::Identifier(w) = self.peek_at(1).unwrap() {
                            w.to_uppercase()
                        } else {
                            unreachable!()
                        }
                    };
                    self.advance(); // consume ARRAY
                    self.advance(); // consume COPY/SWAP
                    let src = self.parse_primary()?;
                    self.expect(&Token::Comma)?;
                    let dst = self.parse_primary()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: format!("ARRAY {}", op),
                        args: vec![src, dst],
                        line,
                    }));
                }
                // ARRAY ASSIGN target() = source()
                if name_upper == "ARRAY"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase() == "ASSIGN")
                {
                    self.advance(); // consume ARRAY
                    self.advance(); // consume ASSIGN
                    let target = self.parse_primary()?;
                    self.expect(&Token::Eq)?;
                    let src = self.parse_primary()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "ARRAY ASSIGN".to_string(),
                        args: vec![target, src],
                        line,
                    }));
                }
                // ARRAY UNIQUE arr() [FOR count]
                if name_upper == "ARRAY"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase() == "UNIQUE")
                {
                    self.advance(); // consume ARRAY
                    self.advance(); // consume UNIQUE
                    let arr = self.parse_primary()?;
                    let mut args = vec![arr];
                    if self.peek() == &Token::For {
                        self.advance(); // consume FOR
                        args.push(self.parse_expression()?);
                    }
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "ARRAY UNIQUE".to_string(),
                        args,
                        line,
                    }));
                }
                // ARRAY SCAN arr(), OP expr, TO var& (op: = <> < > <= >=)
                if name_upper == "ARRAY"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase() == "SCAN")
                {
                    self.advance(); // consume ARRAY
                    self.advance(); // consume SCAN
                    let arr_expr = self.parse_primary()?;
                    let mut args = vec![arr_expr];
                    if self.peek() == &Token::For {
                        self.advance(); // consume FOR (count currently not applied)
                        let _count = self.parse_expression()?;
                    }
                    self.expect(&Token::Comma)?;
                    let op_sym = match self.peek() {
                        Token::Eq => "=",
                        Token::Neq => "<>",
                        Token::Lt => "<",
                        Token::Gt => ">",
                        Token::Lte => "<=",
                        Token::Gte => ">=",
                        _ => {
                            return Err(PbError::parser(
                                format!(
                                    "ARRAY SCAN: expected relational operator, got {:?}",
                                    self.peek()
                                ),
                                self.current_file(),
                                self.current_line(),
                            ));
                        }
                    };
                    self.advance(); // consume operator
                    args.push(self.parse_expression()?); // value
                    if self.peek() == &Token::Comma {
                        self.advance(); // optional comma before TO
                    }
                    if self.peek() == &Token::To {
                        self.advance(); // consume TO
                    }
                    args.push(self.parse_expression()?); // target var
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: format!("ARRAY SCAN {}", op_sym),
                        args,
                        line,
                    }));
                }
                // ARRAY INSERT arr(index), value
                if name_upper == "ARRAY"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase() == "INSERT")
                {
                    self.advance(); // consume ARRAY
                    self.advance(); // consume INSERT
                    let arr_expr = self.parse_primary()?;
                    let mut args = vec![arr_expr];
                    self.expect(&Token::Comma)?;
                    args.push(self.parse_expression()?);
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "ARRAY INSERT".to_string(),
                        args,
                        line,
                    }));
                }
                // ARRAY DELETE arr(index) [FOR count]
                if name_upper == "ARRAY"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase() == "DELETE")
                {
                    self.advance(); // consume ARRAY
                    self.advance(); // consume DELETE
                    let arr_expr = self.parse_primary()?;
                    let mut args = vec![arr_expr];
                    if self.peek() == &Token::For {
                        self.advance(); // consume FOR
                        args.push(self.parse_expression()?);
                    }
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "ARRAY DELETE".to_string(),
                        args,
                        line,
                    }));
                }
                // ARRAY ARRAYIX arr()
                if name_upper == "ARRAY"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase() == "ARRAYIX")
                {
                    self.advance(); // consume ARRAY
                    self.advance(); // consume ARRAYIX
                    let args = vec![self.parse_primary()?];
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "ARRAY ARRAYIX".to_string(),
                        args,
                        line,
                    }));
                }
                // FILESCAN [#] fnum&, RECORDS TO y& [, WIDTH TO x&]
                if name_upper == "FILESCAN" {
                    self.advance(); // consume FILESCAN
                    let mut args = Vec::new();
                    if self.peek() == &Token::Hash {
                        self.advance(); // consume #
                    }
                    args.push(self.parse_expression()?); // file number
                    self.expect(&Token::Comma)?;
                    if let Token::Identifier(w) = self.peek() {
                        if w.to_uppercase() == "RECORDS" {
                            self.advance(); // consume RECORDS
                            self.expect(&Token::To)?;
                            args.push(self.parse_expression()?); // records target
                        }
                    }
                    if self.peek() == &Token::Comma {
                        self.advance(); // consume comma
                        if let Token::Identifier(w) = self.peek() {
                            if w.to_uppercase() == "WIDTH" {
                                self.advance(); // consume WIDTH
                                self.expect(&Token::To)?;
                                args.push(self.parse_expression()?); // width target
                            }
                        }
                    }
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "FILESCAN".to_string(),
                        args,
                        line,
                    }));
                }
                // BIT {SET|RESET|TOGGLE} intvar, bitnumber / BIT CALC intvar, bitnumber, expr
                if name_upper == "BIT"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w))
                        if matches!(w.to_uppercase().as_str(), "SET" | "RESET" | "TOGGLE" | "CALC"))
                {
                    self.advance(); // consume BIT
                    let op = self.consume_identifier()?.to_uppercase(); // SET/RESET/TOGGLE/CALC
                    let mut args = vec![self.parse_expression()?];
                    self.expect(&Token::Comma)?;
                    args.push(self.parse_expression()?);
                    if op == "CALC" {
                        self.expect(&Token::Comma)?;
                        args.push(self.parse_expression()?);
                    }
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: format!("BIT {}", op),
                        args,
                        line,
                    }));
                }
                // PROCESS GET PRIORITY TO var / PROCESS SET PRIORITY pri
                if name_upper == "PROCESS"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w))
                        if matches!(w.to_uppercase().as_str(), "GET" | "SET"))
                    && matches!(self.peek_at(2), Some(Token::Identifier(w)) if w.to_uppercase() == "PRIORITY")
                {
                    self.advance(); // consume PROCESS
                    let op = self.consume_identifier()?.to_uppercase(); // GET / SET
                    self.advance(); // consume PRIORITY
                    let mut args = Vec::new();
                    if op == "GET" {
                        if self.peek() == &Token::To {
                            self.advance(); // consume TO
                        }
                        args.push(self.parse_expression()?);
                    } else {
                        args.push(self.parse_expression()?);
                    }
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: format!("PROCESS {} PRIORITY", op),
                        args,
                        line,
                    }));
                }
                // SPLIT [WORD] MainStr, Part1Len TO Part1Var, Part2Var
                if name_upper == "SPLIT" {
                    self.advance(); // consume SPLIT
                    if matches!(self.peek(), Token::Identifier(w) if w.to_uppercase() == "WORD") {
                        self.advance(); // consume optional WORD (ignored)
                    }
                    let mut args = vec![self.parse_expression()?];
                    self.expect(&Token::Comma)?;
                    args.push(self.parse_expression()?);
                    if self.peek() == &Token::To {
                        self.advance(); // consume TO
                    }
                    args.push(self.parse_expression()?);
                    self.expect(&Token::Comma)?;
                    args.push(self.parse_expression()?);
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "SPLIT".to_string(),
                        args,
                        line,
                    }));
                }
                // SHIFT [SIGNED] {LEFT|RIGHT} ivar, count / ROTATE {LEFT|RIGHT} ivar, count
                if (name_upper == "SHIFT" || name_upper == "ROTATE")
                    && matches!(self.peek_at(1), Some(Token::Identifier(w))
                        if matches!(w.to_uppercase().as_str(), "LEFT" | "RIGHT" | "SIGNED"))
                {
                    let mut parts = vec![name_upper.clone()];
                    self.advance(); // consume SHIFT/ROTATE
                    if name_upper == "SHIFT"
                        && matches!(self.peek(), Token::Identifier(w) if w.to_uppercase() == "SIGNED")
                    {
                        parts.push("SIGNED".to_string());
                        self.advance();
                    }
                    if let Token::Identifier(w) = self.peek() {
                        let d = w.to_uppercase();
                        if d == "LEFT" || d == "RIGHT" {
                            parts.push(d);
                            self.advance();
                        }
                    }
                    let stmt_name = parts.join(" ");
                    let mut args = vec![self.parse_expression()?];
                    while self.peek() == &Token::Comma {
                        self.advance();
                        args.push(self.parse_expression()?);
                    }
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: stmt_name,
                        args,
                        line,
                    }));
                }
                // ARRAY SHUFFLE arr() [FOR n]
                if name_upper == "ARRAY"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase() == "SHUFFLE")
                {
                    self.advance(); // consume ARRAY
                    self.advance(); // consume SHUFFLE
                    let mut args = vec![self.parse_expression()?];
                    while self.peek() == &Token::Comma {
                        self.advance();
                        args.push(self.parse_expression()?);
                    }
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "ARRAY SHUFFLE".to_string(),
                        args,
                        line,
                    }));
                }
                // ARRAY REVERSE arr() [FOR n]
                if name_upper == "ARRAY"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase() == "REVERSE")
                {
                    self.advance(); // consume ARRAY
                    self.advance(); // consume REVERSE
                    let mut args = vec![self.parse_expression()?];
                    while self.peek() == &Token::Comma {
                        self.advance();
                        args.push(self.parse_expression()?);
                    }
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "ARRAY REVERSE".to_string(),
                        args,
                        line,
                    }));
                }
                // ARRAY SORT arr() [FOR n] [, DESCEND|ASCEND]
                if name_upper == "ARRAY"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase() == "SORT")
                {
                    self.advance(); // consume ARRAY
                    self.advance(); // consume SORT
                    let mut args = vec![self.parse_expression()?];
                    while self.peek() == &Token::Comma {
                        self.advance();
                        args.push(self.parse_expression()?);
                    }
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "ARRAY SORT".to_string(),
                        args,
                        line,
                    }));
                }
                // ARRAY SELECT arr(), start, end
                if name_upper == "ARRAY"
                    && (matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase() == "SELECT")
                        || matches!(self.peek_at(1), Some(&Token::Select)))
                {
                    self.advance();
                    self.advance();
                    let arr = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    // op form: = <> < > <= >= expr TO var
                    let op_code = match self.peek() {
                        Token::Eq => Some(0),
                        Token::Neq => Some(1),
                        Token::Lt => Some(2),
                        Token::Gt => Some(3),
                        Token::Lte => Some(4),
                        Token::Gte => Some(5),
                        _ => None,
                    };
                    if let Some(op) = op_code {
                        self.advance(); // consume op
                        let val = self.parse_expression()?;
                        // The operator form is written both as `> 25 TO i` and `> 25, TO i`;
                        // accept the comma when it is present.
                        if self.peek() == &Token::Comma {
                            self.advance();
                        }
                        self.expect(&Token::To)?;
                        let dst = self.parse_expression()?;
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "ARRAY_SELECT_OP".to_string(),
                            args: vec![arr, Expr::IntegerLit(op), val, dst],
                            line,
                        }));
                    }
                    // range form: start, end
                    let start = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let end = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "ARRAY_SELECT".to_string(),
                        args: vec![arr, start, end],
                        line,
                    }));
                }
                // ARRAY TAGARRAY arr(), tagarr() / ARRAY TAGARRAY ERASE arr()
                if name_upper == "ARRAY"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase() == "TAGARRAY")
                {
                    self.advance();
                    self.advance();
                    if self.peek_plain_upper() == "ERASE" {
                        self.advance();
                        let arr = self.parse_expression()?;
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: "ARRAY_TAGARRAY_ERASE".to_string(),
                            args: vec![arr],
                            line,
                        }));
                    }
                    let arr = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let tag = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "ARRAY_TAGARRAY".to_string(),
                        args: vec![arr, tag],
                        line,
                    }));
                }

                // ACCEL ATTACH hDlg, id() — accelerator table (accepted; no-op until GUI)
                if name_upper == "ACCEL"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase() == "ATTACH")
                {
                    self.advance();
                    self.advance();
                    let mut args = Vec::new();
                    if self.peek() != &Token::Eol {
                        args.push(self.parse_expression()?);
                        while self.peek() == &Token::Comma {
                            self.advance();
                            args.push(self.parse_expression()?);
                        }
                    }
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "ACCEL_ATTACH".to_string(),
                        args,
                        line,
                    }));
                }
                // TCP NOTIFY ... / UDP NOTIFY ... — async notify window (accepted; no-op)
                if (name_upper == "TCP" || name_upper == "UDP")
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase() == "NOTIFY")
                {
                    let kw = name_upper.clone();
                    self.advance();
                    self.advance();
                    let mut args = Vec::new();
                    if self.peek() != &Token::Eol {
                        args.push(self.parse_expression()?);
                        while self.peek() == &Token::Comma {
                            self.advance();
                            args.push(self.parse_expression()?);
                        }
                    }
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: format!("{}_NOTIFY", kw),
                        args,
                        line,
                    }));
                }
                // EVENT SOURCE id — accepted; no-op until OOP runtime
                if name_upper == "EVENT"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase() == "SOURCE")
                {
                    self.advance();
                    self.advance();
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "EVENT_SOURCE".to_string(),
                        args: vec![],
                        line,
                    }));
                }
                // EVENTS ... — accepted; no-op
                if name_upper == "EVENTS" {
                    self.advance();
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "EVENTS".to_string(),
                        args: vec![],
                        line,
                    }));
                }
                // RAISEEVENT name[(args)] — accepted; no-op
                if name_upper == "RAISEEVENT" {
                    self.advance();
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "RAISEEVENT".to_string(),
                        args: vec![],
                        line,
                    }));
                }
                // INSTANCE var AS ClassName — accepted; no-op (treated as LONG pointer)
                if name_upper == "INSTANCE" {
                    self.advance();
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "INSTANCE".to_string(),
                        args: vec![],
                        line,
                    }));
                }
                // LET obj2 = expr (plain LET keyword) — consume LET, then normal assignment
                if name_upper == "LET" && self.peek_at(1) != Some(&Token::Star) {
                    self.advance(); // consume LET
                    let primary = self.parse_primary()?;
                    if self.peek() == &Token::Eq {
                        self.advance();
                        let value = self.parse_expression()?;
                        self.consume_to_eol();
                        return Ok(Statement::Assign(AssignStmt {
                            target: primary,
                            value,
                            line,
                        }));
                    }
                    self.consume_to_eol();
                    return Ok(Statement::Noop("LET".to_string(), line));
                }
                // LET *ptr = obj / LET *ptr = variant — object/variant pointer assign (accepted; no-op)
                if name_upper == "LET" && self.peek_at(1) == Some(&Token::Star) {
                    self.advance(); // consume LET
                    self.advance(); // consume *
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "LET_PTR".to_string(),
                        args: vec![],
                        line,
                    }));
                }
                // DEF fnName(params) = expr — single-line function, stored for inline expansion
                if name_upper == "DEF" {
                    self.advance(); // consume DEF
                    let fname = self.consume_identifier()?;
                    self.expect(&Token::LParen)?;
                    let mut params: Vec<String> = Vec::new();
                    if self.peek() != &Token::RParen {
                        loop {
                            params.push(self.consume_identifier()?);
                            if self.peek() != &Token::Comma {
                                break;
                            }
                            self.advance();
                        }
                    }
                    self.expect(&Token::RParen)?;
                    self.expect(&Token::Eq)?;
                    let body = self.parse_expression()?;
                    self.def_funcs.insert(fname.to_uppercase(), (params, body));
                    return Ok(Statement::Call(CallStmt {
                        name: "DEF_FN".to_string(),
                        args: vec![],
                        line,
                    }));
                }

                // ARRAY REDIM INCR arr(), n / ARRAY REDIM DECR arr(), n
                if name_upper == "ARRAY"
                    && (matches!(self.peek_at(1), Some(Token::Identifier(w)) if w.to_uppercase() == "REDIM")
                        || matches!(self.peek_at(1), Some(&Token::Redim)))
                {
                    self.advance(); // ARRAY
                    self.advance(); // REDIM
                    let is_incr = if matches!(*self.peek(), Token::Incr) {
                        self.advance();
                        true
                    } else if matches!(*self.peek(), Token::Decr) {
                        self.advance();
                        false
                    } else if let Token::Identifier(w) = self.peek() {
                        let up = w.to_uppercase();
                        self.advance();
                        up == "INCR"
                    } else {
                        false
                    };
                    let arr = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let n = self.parse_expression()?;
                    self.consume_to_eol();
                    let call_name = if is_incr {
                        "ARRAY_REDIM_INCR"
                    } else {
                        "ARRAY_REDIM_DECR"
                    };
                    return Ok(Statement::Call(CallStmt {
                        name: call_name.to_string(),
                        args: vec![arr, n],
                        line,
                    }));
                }
                // GET #filenum [, pos], var / PUT #filenum [, pos], var
                // (binary file read/write; args = [filenum, (pos), var])
                // PUT$ [#] filenum&, StrgExpr — write ANSI string at file position
                if name_upper == "PUT$" {
                    self.advance(); // consume PUT$
                    if self.peek() == &Token::Hash {
                        self.advance(); // consume optional #
                    }
                    let mut args = vec![self.parse_expression()?];
                    while self.peek() == &Token::Comma {
                        self.advance();
                        args.push(self.parse_expression()?);
                    }
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "PUT_STR".to_string(),
                        args,
                        line,
                    }));
                }
                // PUT$$ [#] filenum&, StrgExpr — write WIDE (UTF-16LE) string at file position
                if name_upper == "PUT$$" {
                    self.advance(); // consume PUT$$
                    if self.peek() == &Token::Hash {
                        self.advance(); // consume optional #
                    }
                    let mut args = vec![self.parse_expression()?];
                    while self.peek() == &Token::Comma {
                        self.advance();
                        args.push(self.parse_expression()?);
                    }
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "PUT_WSTR".to_string(),
                        args,
                        line,
                    }));
                }
                // GET$ [#] filenum&, Count&, StrgVar — read Count bytes into a string var
                if name_upper == "GET$" {
                    self.advance(); // consume GET$
                    if self.peek() == &Token::Hash {
                        self.advance(); // consume optional #
                    }
                    let mut args = vec![self.parse_expression()?];
                    while self.peek() == &Token::Comma {
                        self.advance();
                        args.push(self.parse_expression()?);
                    }
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "GET_STR".to_string(),
                        args,
                        line,
                    }));
                }
                // GET$$ [#] filenum&, Count&, StrgVar — read Count WIDE chars into a string var
                if name_upper == "GET$$" {
                    self.advance(); // consume GET$$
                    if self.peek() == &Token::Hash {
                        self.advance(); // consume optional #
                    }
                    let mut args = vec![self.parse_expression()?];
                    while self.peek() == &Token::Comma {
                        self.advance();
                        args.push(self.parse_expression()?);
                    }
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "GET_WSTR".to_string(),
                        args,
                        line,
                    }));
                }
                if (name_upper == "GET" || name_upper == "PUT")
                    && self.peek_at(1) == Some(&Token::Hash)
                {
                    self.advance(); // consume GET/PUT
                    self.advance(); // consume #
                    let mut args = vec![self.parse_expression()?];
                    while self.peek() == &Token::Comma {
                        self.advance();
                        args.push(self.parse_expression()?);
                    }
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: name_upper,
                        args,
                        line,
                    }));
                }
                // SEEK #filenum, position&
                if name_upper == "SEEK" && self.peek_at(1) == Some(&Token::Hash) {
                    self.advance(); // consume SEEK
                    self.advance(); // consume #
                    let file_num = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let pos = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "SEEK".to_string(),
                        args: vec![file_num, pos],
                        line,
                    }));
                }
                // SETEOF #filenum — truncate at current position
                if name_upper == "SETEOF" && self.peek_at(1) == Some(&Token::Hash) {
                    self.advance(); // consume SETEOF
                    self.advance(); // consume #
                    let mut args = vec![self.parse_expression()?];
                    while self.peek() == &Token::Comma {
                        self.advance();
                        args.push(self.parse_expression()?);
                    }
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "SETEOF".to_string(),
                        args,
                        line,
                    }));
                }
                if name_upper == "CLIPBOARD" {
                    return self.parse_clipboard_statement(line);
                }
                if name_upper == "GLOBALMEM" {
                    return self.parse_globalmem_statement(line);
                }
                if name_upper == "MOUSEPTR" {
                    return self.parse_mouseptr_statement(line);
                }
                if name_upper == "UCODEPAGE" {
                    return self.parse_ucodepage_statement(line);
                }
                // TCP / UDP socket statements (batch 19)
                if name_upper == "TCP" || name_upper == "UDP" {
                    return self.parse_net_statement(line);
                }
                // HOST ADDR [hostname$] TO ip&  /  HOST NAME [ip&] TO hostname$
                if name_upper == "HOST"
                    && matches!(self.peek_at(1), Some(Token::Identifier(w))
                    if matches!(w.to_uppercase().as_str(), "ADDR" | "NAME"))
                {
                    let op = {
                        if let Token::Identifier(w) = self.peek_at(1).unwrap() {
                            w.to_uppercase()
                        } else {
                            unreachable!()
                        }
                    };
                    self.advance(); // consume HOST
                    self.advance(); // consume ADDR/NAME
                    let mut args = Vec::new();
                    if self.peek() != &Token::To {
                        args.push(self.parse_expression()?);
                    }
                    self.expect(&Token::To)?;
                    args.push(self.parse_expression()?);
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: format!("HOST {}", op),
                        args,
                        line,
                    }));
                }
                // LOCK / UNLOCK #filenum [, record& [, length&]]
                if (name_upper == "LOCK" || name_upper == "UNLOCK")
                    && self.peek_at(1) == Some(&Token::Hash)
                {
                    let stmt_name = name_upper.clone();
                    self.advance(); // consume LOCK/UNLOCK
                    self.advance(); // consume #
                    let file_num = self.parse_expression()?;
                    let mut args = vec![file_num];
                    while self.peek() == &Token::Comma {
                        self.advance();
                        args.push(self.parse_expression()?);
                    }
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: stmt_name,
                        args,
                        line,
                    }));
                }
                // FLUSH #filenum
                if name_upper == "FLUSH" && self.peek_at(1) == Some(&Token::Hash) {
                    self.advance(); // consume FLUSH
                    self.advance(); // consume #
                    let file_num = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "FLUSH".to_string(),
                        args: vec![file_num],
                        line,
                    }));
                }
                // NAME oldfile$ AS newfile$
                if name_upper == "NAME" {
                    self.advance(); // consume NAME
                    let old_name = self.parse_expression()?;
                    if matches!(self.peek(), Token::As) {
                        self.advance();
                    }
                    let new_name = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "NAME".to_string(),
                        args: vec![old_name, new_name],
                        line,
                    }));
                }
                // COMM serial port statements
                if name_upper == "COMM" {
                    return self.parse_comm_statement(line);
                }
                // THREAD statements
                if name_upper == "THREAD" {
                    return self.parse_thread_statement(line);
                }
                // LPRINT statements (direct line-printer output)
                if name_upper == "LPRINT" {
                    return self.parse_lprint_statement(line);
                }
                // TRACE statements (explicit trace file logging)
                if name_upper == "TRACE" {
                    return self.parse_trace_statement(line);
                }
                // IMPORT statements (explicit DLL loading)
                if name_upper == "IMPORT" {
                    return self.parse_import_statement(line);
                }
                // PROGRESSBAR / HEADER statements, official PB syntax.  These
                // must be handled before the bare-control-name fallback below,
                // which would otherwise swallow the whole line as a Noop and
                // make codegen report the statement as unimplemented.
                if name_upper == "PROGRESSBAR" || name_upper == "HEADER" {
                    let head = name_upper.clone();
                    // STEP is a keyword token, not an identifier (token.rs:214).
                    let verb: Option<String> = if matches!(self.peek_at(1), Some(Token::Step)) {
                        Some("STEP".to_string())
                    } else if let Some(Token::Identifier(w)) = self.peek_at(1) {
                        let u = w.to_uppercase();
                        if u == "GET" || u == "SET" || u == "SEND" || u == "STEP" {
                            Some(u)
                        } else {
                            None
                        }
                    } else {
                        None
                    };
                    if let Some(verb) = verb {
                        self.advance(); // PROGRESSBAR / HEADER
                        self.advance(); // verb
                        let want_noun = if head == "PROGRESSBAR" {
                            verb != "STEP"
                        } else {
                            verb == "GET" || verb == "SET"
                        };
                        let mut noun = String::new();
                        if want_noun {
                            if matches!(self.peek(), Token::Step) {
                                noun = "STEP".to_string();
                                self.advance();
                            } else if let Token::Identifier(w2) = self.peek() {
                                let t = w2.to_uppercase();
                                if t == "POS" || t == "RANGE" || t == "COUNT" || t == "ITEM" {
                                    noun = t;
                                    self.advance();
                                }
                            }
                        }
                        let mut args = Vec::new();
                        args.push(self.parse_expression()?);
                        self.expect(&Token::Comma)?;
                        args.push(self.parse_expression()?);
                        if self.peek() == &Token::To {
                            self.advance();
                            args.push(self.parse_expression()?);
                        }
                        while self.peek() == &Token::Comma {
                            self.advance();
                            args.push(self.parse_expression()?);
                        }
                        // PROGRESSBAR STEP hDlg, id& [, incramt&] - the increment
                        // is optional, so default it to 0 for codegen.
                        if head == "PROGRESSBAR" && verb == "STEP" && args.len() == 2 {
                            args.push(Expr::IntegerLit(0));
                        }
                        self.consume_to_eol();
                        let stmt_name = if noun.is_empty() {
                            format!("{}_{}", head, verb)
                        } else {
                            format!("{}_{}_{}", head, verb, noun)
                        };
                        return Ok(Statement::Call(CallStmt {
                            name: stmt_name,
                            args,
                            line,
                        }));
                    }
                }
                if matches!(
                    name_upper.as_str(),
                    "DIALOG"
                        | "CONTROL"
                        | "MENU"
                        | "TOOLBAR"
                        | "STATUSBAR"
                        | "COMBOBOX"
                        | "LISTBOX"
                        | "TREEVIEW"
                        | "LISTVIEW"
                ) {
                    self.advance();
                    self.consume_to_eol();
                    return Ok(Statement::Noop(name_upper.clone(), line));
                }

                let name_clone = name.clone();

                // Check for label: IDENTIFIER:
                if self.peek_at(1) == Some(&Token::Colon) {
                    self.advance(); // consume identifier
                    self.advance(); // consume colon
                    return Ok(Statement::Label(name_clone));
                }

                // Or assignment: IDENTIFIER = expr
                // Or sub call: IDENTIFIER args
                // Or array assignment: IDENTIFIER(idx) = expr

                // Peek ahead to decide
                if self.peek_at(1) == Some(&Token::Eq) {
                    // Simple assignment: name = expr
                    self.advance(); // consume name
                    self.advance(); // consume =
                    let value = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Assign(AssignStmt {
                        target: Expr::Variable(name_clone),
                        value,
                        line,
                    }));
                }

                if self.peek_at(1) == Some(&Token::Dot) {
                    // TYPE member assignment: name.member = expr
                    let primary = self.parse_primary()?;
                    if self.peek() == &Token::Eq {
                        self.advance(); // consume =
                        let value = self.parse_expression()?;
                        self.consume_to_eol();
                        return Ok(Statement::Assign(AssignStmt {
                            target: primary,
                            value,
                            line,
                        }));
                    }
                    self.consume_to_eol();
                    return Ok(Statement::Noop(name_clone.clone(), line));
                }

                if self.peek_at(1) == Some(&Token::LParen) {
                    // Could be: arr(idx) = expr  (array assignment)
                    // Or:       Sub(args)        (sub call)
                    // Or:       arr(idx).member = expr (UDT array member)
                    // Parse just the primary expression (no comparison operators)
                    let primary = self.parse_primary()?;

                    if self.peek() == &Token::Eq {
                        // Array assignment: arr(idx) = expr
                        self.advance(); // consume =
                        let value = self.parse_expression()?;
                        self.consume_to_eol();
                        return Ok(Statement::Assign(AssignStmt {
                            target: primary,
                            value,
                            line,
                        }));
                    }

                    // It's a sub call with parenthesized args
                    if let Expr::FunctionCall(func_name, func_args) = primary {
                        self.consume_to_eol();
                        return Ok(Statement::Call(CallStmt {
                            name: func_name,
                            args: func_args,
                            line,
                        }));
                    }

                    self.consume_to_eol();
                    return Ok(Statement::Noop(name_clone.clone(), line));
                }

                // No LParen after identifier — could be a SUB call: SubName arg1, arg2
                // Or a label target in single-line IF: IF cond THEN LabelName ELSE ...
                self.advance(); // consume identifier
                let mut args = Vec::new();
                // PEEK/POKE datatype keyword as first arg: POKE LONG, addr, 12345
                if args.is_empty() && !self.at_eol_or_eof() {
                    let dt = match self.peek() {
                        Token::Long => Some("LONG"),
                        Token::Double => Some("DOUBLE"),
                        Token::Dword => Some("DWORD"),
                        Token::Integer => Some("INTEGER"),
                        Token::Quad => Some("QUAD"),
                        Token::Single => Some("SINGLE"),
                        _ => None,
                    };
                    if let Some(d) = dt {
                        self.advance();
                        args.push(Expr::Variable(d.to_string()));
                        if self.peek() == &Token::Comma {
                            self.advance();
                        }
                    }
                }
                if !self.at_eol_or_eof() && !matches!(self.peek(), Token::Else | Token::ElseIf) {
                    // BYVAL/BYCOPY modifier in no-paren calls: Foo a, BYVAL %NULL
                    let mut has_byval = matches!(self.peek(), Token::Byval);
                    if has_byval {
                        self.advance(); // consume BYVAL
                    }
                    if matches!(self.peek(), Token::Identifier(ref s) if s.eq_ignore_ascii_case("BYCOPY"))
                    {
                        has_byval = true;
                        self.advance(); // consume BYCOPY
                    }
                    let e = self.parse_expression()?;
                    args.push(if has_byval {
                        Expr::ByvalOverride(Box::new(e))
                    } else {
                        e
                    });
                    while self.peek() == &Token::Comma {
                        self.advance();
                        // Each subsequent arg may also carry BYVAL/BYCOPY
                        let mut hb = matches!(self.peek(), Token::Byval);
                        if hb {
                            self.advance();
                        }
                        if matches!(self.peek(), Token::Identifier(ref s2) if s2.eq_ignore_ascii_case("BYCOPY"))
                        {
                            hb = true;
                            self.advance();
                        }
                        let e2 = self.parse_expression()?;
                        args.push(if hb {
                            Expr::ByvalOverride(Box::new(e2))
                        } else {
                            e2
                        });
                    }
                }
                // Check for leftover tokens (syntax error like MSGBOX "text"hgkugyj)
                if !matches!(self.peek(), Token::Eol | Token::Eof | Token::Colon) {
                    let loc = self.peek_located();
                    let leftover = format!("Unexpected token after arguments: {:?}", self.peek());
                    return Err(PbError::parser_at(
                        leftover,
                        loc.file.as_deref(),
                        loc.line,
                        loc.col,
                    ));
                }
                self.consume_to_eol();
                Ok(Statement::Call(CallStmt {
                    name: name_clone,
                    args,
                    line,
                }))
            }
            _ => {
                self.consume_to_eol();
                Ok(Statement::Noop("<unknown token>".to_string(), line))
            }
        }
    }

    fn parse_local_decl(&mut self) -> PbResult<Vec<DimStatement>> {
        let line = self.current_line();
        self.advance(); // LOCAL

        let mut dims: Vec<DimStatement> = Vec::new();
        // PB semantics: `LOCAL aaa, bbb, ccc AS INTEGER` declares ALL names
        // with the trailing type. So a trailing AS both (a) back-fills every
        // previously untyped name in the list and (b) propagates forward to
        // later names until the next AS.
        let mut pending_type: Option<PbType> = None;
        let mut untyped: Vec<usize> = Vec::new(); // indices of names w/o AS yet

        loop {
            let name = self.consume_identifier()?;

            let mut bounds = Vec::new();
            if self.peek() == &Token::LParen {
                self.advance();
                if self.peek() != &Token::RParen {
                    bounds = self.parse_dim_bounds()?;
                }
                self.expect(&Token::RParen)?;
            }

            let idx = dims.len();
            let pb_type = if self.peek() == &Token::As {
                self.advance();
                let t = self.parse_type()?;
                // Back-fill all previously untyped names with this type
                for i in &untyped {
                    dims[*i].pb_type = t.clone();
                }
                untyped.clear();
                pending_type = Some(t.clone());
                t
            } else if let Some(t) = &pending_type {
                t.clone()
            } else {
                let t = type_from_suffix(&name);
                untyped.push(idx);
                t
            };

            dims.push(DimStatement {
                scope: DimScope::Local,
                name,
                pb_type,
                bounds,
                line,
                is_redim: false,
            });

            if self.peek() == &Token::Comma {
                self.advance();
            } else {
                break;
            }
        }

        self.consume_to_eol();
        Ok(dims)
    }

    fn parse_if_statement(&mut self) -> PbResult<Statement> {
        let line = self.current_line();
        self.advance(); // IF
        let condition = self.parse_expression()?;
        self.expect(&Token::Then)?;

        // Check for single-line IF: IF cond THEN stmt1[:stmt2...] [ELSE stmt3[:stmt4...]]
        if !self.at_eol_or_eof() {
            // Single-line IF — parse one or more colon-separated THEN statements
            let if_line = self.current_line();
            let mut then_body = Vec::new();
            loop {
                let stmt = self.parse_statement()?;
                then_body.push(stmt);
                // Continue with more colon-separated statements on the same line
                if self.peek() == &Token::Colon && self.current_line() == if_line {
                    self.advance(); // consume :
                                    // But check if next token is ELSE (IF cond THEN stmt : ELSE stmt)
                    if self.peek() == &Token::Else {
                        break;
                    }
                } else {
                    break;
                }
            }

            let mut else_body = Vec::new();

            // Check for ELSE on the SAME line only.
            // After parse_statement, we may have crossed a line boundary
            // (e.g. PRINT calls consume_to_eol). Only match ELSE if still
            // on the same line to avoid stealing an outer block IF's ELSE.
            if self.peek() == &Token::Else && self.current_line() == if_line {
                self.advance(); // consume ELSE
                loop {
                    let stmt = self.parse_statement()?;
                    else_body.push(stmt);
                    if self.peek() == &Token::Colon && self.current_line() == if_line {
                        self.advance(); // consume :
                    } else {
                        break;
                    }
                }
            }

            return Ok(Statement::If(IfStmt {
                condition,
                then_body,
                elseif_clauses: Vec::new(),
                else_body,
                line,
            }));
        }

        self.skip_eol();

        // Multi-line IF
        let (then_body, matched) =
            self.parse_body_with_terminator(&[BodyEnd::EndIf, BodyEnd::Else, BodyEnd::ElseIf])?;

        let mut elseif_clauses = Vec::new();
        let mut else_body = Vec::new();

        // Only check for ELSEIF/ELSE if the then_body wasn't terminated by END IF.
        // When a nested IF...END IF is inside an ELSEIF body, the END IF belongs
        // to the nested IF, and the next ELSEIF/ELSE belongs to the OUTER IF.
        if matched != Some(BodyEnd::EndIf) {
            // Check for ELSEIF
            while self.peek() == &Token::ElseIf {
                self.advance();
                let elif_cond = self.parse_expression()?;
                self.expect(&Token::Then)?;
                self.consume_to_eol();
                let (elif_body, elif_matched) = self.parse_body_with_terminator(&[
                    BodyEnd::EndIf,
                    BodyEnd::Else,
                    BodyEnd::ElseIf,
                ])?;
                elseif_clauses.push(ElseIfClause {
                    condition: elif_cond,
                    body: elif_body,
                });
                // If this ELSEIF body ended with END IF, the IF statement is complete
                if elif_matched == Some(BodyEnd::EndIf) {
                    break;
                }
            }

            // Check for ELSE (only if not already terminated by END IF)
            if self.peek() == &Token::Else {
                self.advance();
                self.consume_to_eol();
                else_body = self.parse_body(&[BodyEnd::EndIf])?;
            }
        }

        Ok(Statement::If(IfStmt {
            condition,
            then_body,
            elseif_clauses,
            else_body,
            line,
        }))
    }

    fn parse_for_statement(&mut self) -> PbResult<Statement> {
        let line = self.current_line();
        self.advance(); // FOR
        let var = self.consume_identifier()?;
        self.expect(&Token::Eq)?;
        let start = self.parse_expression()?;
        self.expect(&Token::To)?;
        let end = self.parse_expression()?;
        let step = if self.peek() == &Token::Step {
            self.advance();
            Some(self.parse_expression()?)
        } else {
            None
        };
        self.consume_to_eol();

        let body = self.parse_body(&[BodyEnd::Next])?;

        // NEXT [var]
        if self.peek() == &Token::Next {
            self.advance();
            // Optionally consume the variable name
            if let Token::Identifier(_) = self.peek() {
                self.advance();
            }
            self.consume_to_eol();
        }

        Ok(Statement::For(ForStmt {
            var,
            start,
            end,
            step,
            body,
            line,
        }))
    }

    fn parse_do_loop(&mut self) -> PbResult<Statement> {
        let line = self.current_line();
        self.advance(); // DO

        let mut condition = None;
        let mut is_while = true;
        let mut is_pre_test = false;

        // DO WHILE/UNTIL cond
        if self.peek() == &Token::While {
            self.advance();
            condition = Some(self.parse_expression()?);
            is_while = true;
            is_pre_test = true;
        } else if self.peek() == &Token::Until {
            self.advance();
            condition = Some(self.parse_expression()?);
            is_while = false;
            is_pre_test = true;
        }
        self.consume_to_eol();

        let body = self.parse_body(&[BodyEnd::Loop])?;

        // LOOP [WHILE/UNTIL cond]
        if self.peek() == &Token::Loop {
            self.advance();
            if condition.is_none() {
                if self.peek() == &Token::While {
                    self.advance();
                    condition = Some(self.parse_expression()?);
                    is_while = true;
                } else if self.peek() == &Token::Until {
                    self.advance();
                    condition = Some(self.parse_expression()?);
                    is_while = false;
                }
            }
            self.consume_to_eol();
        }

        Ok(Statement::DoLoop(DoLoopStmt {
            condition,
            is_while,
            is_pre_test,
            body,
            line,
        }))
    }

    fn parse_while_wend(&mut self) -> PbResult<Statement> {
        let line = self.current_line();
        self.advance(); // WHILE
        let condition = self.parse_expression()?;
        self.consume_to_eol();

        let body = self.parse_body(&[BodyEnd::Wend])?;

        if self.peek() == &Token::Wend {
            self.advance();
            self.consume_to_eol();
        }

        Ok(Statement::WhileWend(WhileWendStmt {
            condition,
            body,
            line,
        }))
    }

    fn parse_select_case(&mut self) -> PbResult<Statement> {
        let line = self.current_line();
        self.advance(); // SELECT
        self.expect(&Token::Case)?;
        // Optional AS LONG / AS QUAD type specifier
        if matches!(self.peek(), Token::As) {
            self.advance(); // AS
                            // Skip the type keyword (LONG, QUAD, SINGLE, etc.)
            self.advance();
        }
        let expr = self.parse_expression()?;
        self.consume_to_eol();
        self.skip_eol();

        let mut cases = Vec::new();
        let mut else_body = Vec::new();

        loop {
            if self.at_end() {
                break;
            }
            if self.peek() == &Token::End {
                if self.peek_at(1) == Some(&Token::Select) {
                    self.advance(); // END
                    self.advance(); // SELECT
                    self.consume_to_eol();
                    break;
                }
                // Break on END SUB/FUNCTION — we've overrun into parent scope
                if matches!(self.peek_at(1), Some(&Token::Sub) | Some(&Token::Function)) {
                    break;
                }
            }
            // Break on top-level keywords (new SUB/FUNCTION declaration)
            if self.is_top_level_keyword() {
                break;
            }
            if self.peek() == &Token::Case {
                self.advance();
                if self.peek() == &Token::Else {
                    self.advance();
                    self.consume_to_eol();
                    else_body = self.parse_body(&[BodyEnd::EndSelect, BodyEnd::Case])?;
                    continue;
                }
                // Parse case patterns
                let patterns = self.parse_case_patterns()?;
                self.consume_to_eol();
                let body =
                    self.parse_body(&[BodyEnd::EndSelect, BodyEnd::Case, BodyEnd::CaseElse])?;
                cases.push(CaseClause { patterns, body });
            } else {
                let saved = self.pos;
                self.consume_to_eol();
                self.skip_eol();
                // Safety: prevent infinite loop if consume_to_eol makes no progress
                // (e.g., stuck on Token::Else which consume_to_eol won't consume)
                if self.pos == saved {
                    self.advance();
                }
            }
        }

        Ok(Statement::SelectCase(SelectCaseStmt {
            expr,
            cases,
            else_body,
            line,
        }))
    }

    fn parse_case_patterns(&mut self) -> PbResult<Vec<CasePattern>> {
        let mut patterns = Vec::new();
        loop {
            if self.at_eol_or_eof() {
                break;
            }
            // CASE IS <op> expr
            if self.peek() == &Token::Is {
                self.advance();
                let op = match self.peek() {
                    Token::Lt => CaseOp::Lt,
                    Token::Gt => CaseOp::Gt,
                    Token::Lte => CaseOp::Lte,
                    Token::Gte => CaseOp::Gte,
                    Token::Eq => CaseOp::Eq,
                    Token::Neq => CaseOp::Neq,
                    _ => CaseOp::Eq,
                };
                self.advance();
                let expr = self.parse_expression()?;
                patterns.push(CasePattern::Is(op, expr));
            // CASE < expr, CASE > expr, CASE <= expr, CASE >= expr (without IS keyword)
            } else if matches!(self.peek(), Token::Lt | Token::Gt | Token::Lte | Token::Gte) {
                let op = match self.peek() {
                    Token::Lt => CaseOp::Lt,
                    Token::Gt => CaseOp::Gt,
                    Token::Lte => CaseOp::Lte,
                    Token::Gte => CaseOp::Gte,
                    _ => unreachable!(),
                };
                self.advance();
                let expr = self.parse_expression()?;
                patterns.push(CasePattern::Is(op, expr));
            } else {
                let expr = self.parse_expression()?;
                // Check for range: expr TO expr
                if self.peek() == &Token::To {
                    self.advance();
                    let upper = self.parse_expression()?;
                    patterns.push(CasePattern::Range(expr, upper));
                } else {
                    patterns.push(CasePattern::Value(expr));
                }
            }
            if self.peek() == &Token::Comma {
                self.advance();
            } else {
                break;
            }
        }
        Ok(patterns)
    }

    fn parse_comm_statement(&mut self, line: usize) -> PbResult<Statement> {
        self.advance(); // consume COMM
        let op = match self.peek() {
            Token::Identifier(w) => w.to_uppercase(),
            Token::Open => "OPEN".to_string(),
            Token::Close => "CLOSE".to_string(),
            Token::Print => "PRINT".to_string(),
            _ => {
                self.consume_to_eol();
                return Ok(Statement::Noop("COMM".to_string(), line));
            }
        };
        self.advance(); // consume op
        match op.as_str() {
            "OPEN" => {
                // COMM OPEN "COM1:" AS #1 [, BAUD n] [, PARITY p$] [, DATA n] [, STOP n]
                let port = self.parse_expression()?;
                let mut args = vec![port];
                if matches!(self.peek(), Token::As) {
                    self.advance();
                    if self.peek() == &Token::Hash {
                        self.advance();
                    }
                    let ch = self.parse_expression()?;
                    args.push(ch);
                }
                let mut baud = Expr::IntegerLit(0);
                let mut parity = Expr::StringLit(String::new());
                let mut data = Expr::IntegerLit(0);
                let mut stop = Expr::IntegerLit(0);
                while self.peek() == &Token::Comma {
                    self.advance();
                    if let Token::Identifier(w) = self.peek() {
                        let opt = w.to_uppercase();
                        self.advance();
                        let v = self.parse_expression()?;
                        match opt.as_str() {
                            "BAUD" => baud = v,
                            "PARITY" => parity = v,
                            "DATA" => data = v,
                            "STOP" => stop = v,
                            _ => {}
                        }
                    } else {
                        break;
                    }
                }
                self.consume_to_eol();
                args.push(baud);
                args.push(parity);
                args.push(data);
                args.push(stop);
                Ok(Statement::Call(CallStmt {
                    name: "COMM OPEN".to_string(),
                    args,
                    line,
                }))
            }
            "LINE" => {
                // COMM LINE INPUT [#]f, var$
                if let Token::Input = self.peek() {
                    self.advance();
                    if self.peek() == &Token::Hash {
                        self.advance();
                    }
                    let f = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let var = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "COMM LINE INPUT".to_string(),
                        args: vec![f, var],
                        line,
                    }));
                }
                self.consume_to_eol();
                Ok(Statement::Noop("COMM LINE".to_string(), line))
            }
            "PRINT" => {
                // COMM PRINT [#]f, exprlist
                if self.peek() == &Token::Hash {
                    self.advance();
                }
                let mut args = vec![self.parse_expression()?];
                while self.peek() == &Token::Comma {
                    self.advance();
                    args.push(self.parse_expression()?);
                }
                self.consume_to_eol();
                Ok(Statement::Call(CallStmt {
                    name: "COMM PRINT".to_string(),
                    args,
                    line,
                }))
            }
            "RECV" => {
                // COMM RECV [#]f, bytes&, var$
                if self.peek() == &Token::Hash {
                    self.advance();
                }
                let f = self.parse_expression()?;
                self.expect(&Token::Comma)?;
                let bytes = self.parse_expression()?;
                self.expect(&Token::Comma)?;
                let var = self.parse_expression()?;
                self.consume_to_eol();
                Ok(Statement::Call(CallStmt {
                    name: "COMM RECV".to_string(),
                    args: vec![f, bytes, var],
                    line,
                }))
            }
            "RESET" => {
                self.consume_to_eol();
                Ok(Statement::Call(CallStmt {
                    name: "COMM RESET".to_string(),
                    args: vec![],
                    line,
                }))
            }
            "SEND" => {
                // COMM SEND [#]f, string$
                if self.peek() == &Token::Hash {
                    self.advance();
                }
                let f = self.parse_expression()?;
                self.expect(&Token::Comma)?;
                let s = self.parse_expression()?;
                self.consume_to_eol();
                Ok(Statement::Call(CallStmt {
                    name: "COMM SEND".to_string(),
                    args: vec![f, s],
                    line,
                }))
            }
            "SET" => {
                // COMM SET [#]f, option ON|OFF  (option: DTR/RTS/BREAK)
                if self.peek() == &Token::Hash {
                    self.advance();
                }
                let f = self.parse_expression()?;
                self.expect(&Token::Comma)?;
                let opt = self.parse_expression()?;
                let onoff = if matches!(self.peek(), Token::Identifier(w) if w.eq_ignore_ascii_case("ON"))
                {
                    self.advance();
                    Expr::IntegerLit(1)
                } else if matches!(self.peek(), Token::Identifier(w) if w.eq_ignore_ascii_case("OFF"))
                {
                    self.advance();
                    Expr::IntegerLit(0)
                } else {
                    Expr::IntegerLit(0)
                };
                self.consume_to_eol();
                Ok(Statement::Call(CallStmt {
                    name: "COMM SET".to_string(),
                    args: vec![f, opt, onoff],
                    line,
                }))
            }
            "TIMEOUT" => {
                // COMM TIMEOUT [#]f, ms&
                if self.peek() == &Token::Hash {
                    self.advance();
                }
                let f = self.parse_expression()?;
                self.expect(&Token::Comma)?;
                let ms = self.parse_expression()?;
                self.consume_to_eol();
                Ok(Statement::Call(CallStmt {
                    name: "COMM TIMEOUT".to_string(),
                    args: vec![f, ms],
                    line,
                }))
            }
            "CLOSE" => {
                if self.peek() == &Token::Hash {
                    self.advance();
                }
                let f = self.parse_expression()?;
                self.consume_to_eol();
                Ok(Statement::Call(CallStmt {
                    name: "COMM CLOSE".to_string(),
                    args: vec![f],
                    line,
                }))
            }
            _ => {
                self.consume_to_eol();
                Ok(Statement::Noop(format!("COMM {op}"), line))
            }
        }
    }

    fn parse_thread_statement(&mut self, line: usize) -> PbResult<Statement> {
        self.advance(); // consume THREAD
        let op = match self.peek() {
            Token::Identifier(w) => w.to_uppercase(),
            Token::Close => "CLOSE".to_string(),
            Token::Resume => "RESUME".to_string(),
            _ => {
                self.consume_to_eol();
                return Ok(Statement::Noop("THREAD".to_string(), line));
            }
        };
        self.advance(); // consume op
        match op.as_str() {
            "CREATE" => {
                // THREAD CREATE func [TO id&]  /  THREAD CREATE func(args) TO id&
                let func = self.parse_primary()?;
                let mut args = vec![func];
                if matches!(self.peek(), Token::To) {
                    self.advance();
                    let id = self.parse_expression()?;
                    args.push(id);
                }
                self.consume_to_eol();
                Ok(Statement::Call(CallStmt {
                    name: "THREAD CREATE".to_string(),
                    args,
                    line,
                }))
            }
            "CLOSE" | "SUSPEND" | "RESUME" => {
                let id = self.parse_expression()?;
                self.consume_to_eol();
                Ok(Statement::Call(CallStmt {
                    name: format!("THREAD {op}"),
                    args: vec![id],
                    line,
                }))
            }
            "STATUS" => {
                // THREAD STATUS id& TO st&
                let id = self.parse_expression()?;
                let mut args = vec![id];
                if matches!(self.peek(), Token::To) {
                    self.advance();
                    let st = self.parse_expression()?;
                    args.push(st);
                }
                self.consume_to_eol();
                Ok(Statement::Call(CallStmt {
                    name: "THREAD STATUS".to_string(),
                    args,
                    line,
                }))
            }
            "GET" => {
                // THREAD GET PRIORITY id& TO p&
                let sub = match self.peek() {
                    Token::Identifier(w) => w.to_uppercase(),
                    _ => String::new(),
                };
                self.advance();
                let id = self.parse_expression()?;
                let mut args = vec![id];
                if matches!(self.peek(), Token::To) {
                    self.advance();
                    let p = self.parse_expression()?;
                    args.push(p);
                }
                self.consume_to_eol();
                Ok(Statement::Call(CallStmt {
                    name: format!("THREAD GET {sub}"),
                    args,
                    line,
                }))
            }
            "SET" => {
                // THREAD SET PRIORITY id&, p&
                let sub = match self.peek() {
                    Token::Identifier(w) => w.to_uppercase(),
                    _ => String::new(),
                };
                self.advance();
                let id = self.parse_expression()?;
                self.expect(&Token::Comma)?;
                let p = self.parse_expression()?;
                self.consume_to_eol();
                Ok(Statement::Call(CallStmt {
                    name: format!("THREAD SET {sub}"),
                    args: vec![id, p],
                    line,
                }))
            }
            _ => {
                self.consume_to_eol();
                Ok(Statement::Noop(format!("THREAD {op}"), line))
            }
        }
    }

    // LPRINT: LPRINT [expr list] / LPRINT ATTACH device$ / LPRINT CLOSE / FLUSH / FORMFEED
    /// Upper-case the next token as a plain word, mapping reserved-word
    /// tokens that double as TRACE/IMPORT operators (CLOSE, PRINT, OPEN, ON).
    fn peek_plain_upper(&self) -> String {
        match self.peek() {
            Token::Identifier(w) => w.to_uppercase(),
            Token::Close => "CLOSE".to_string(),
            Token::Print => "PRINT".to_string(),
            Token::Open => "OPEN".to_string(),
            Token::On => "ON".to_string(),
            Token::Dword => "DWORD".to_string(),
            Token::End => "END".to_string(),
            _ => String::new(),
        }
    }

    /// Like `peek_plain_upper()`, but also reports the STRING keyword token as
    /// the word "STRING".  The lexer emits Token::String_ for the word STRING
    /// (it is a type keyword, not an identifier), so plain identifier matching
    /// silently misses it - the cause of several batch 159 parser defects.
    fn peek_ident_or_string_keyword(&self) -> Option<String> {
        match self.peek() {
            Token::Identifier(w) => Some(w.clone()),
            Token::String_ => Some("STRING".to_string()),
            _ => None,
        }
    }

    fn parse_lprint_statement(&mut self, line: usize) -> PbResult<Statement> {
        self.advance(); // consume LPRINT
        match self.peek() {
            Token::Identifier(w) if w.eq_ignore_ascii_case("ATTACH") => {
                self.advance();
                let device = self.parse_expression()?;
                self.consume_to_eol();
                Ok(Statement::Call(CallStmt {
                    name: "LPRINT ATTACH".to_string(),
                    args: vec![device],
                    line,
                }))
            }
            Token::Close => {
                self.advance();
                self.consume_to_eol();
                Ok(Statement::Call(CallStmt {
                    name: "LPRINT CLOSE".to_string(),
                    args: vec![],
                    line,
                }))
            }
            Token::Identifier(w) if w.eq_ignore_ascii_case("CLOSE") => {
                self.advance();
                self.consume_to_eol();
                Ok(Statement::Call(CallStmt {
                    name: "LPRINT CLOSE".to_string(),
                    args: vec![],
                    line,
                }))
            }
            Token::Identifier(w) if w.eq_ignore_ascii_case("FLUSH") => {
                self.advance();
                self.consume_to_eol();
                Ok(Statement::Call(CallStmt {
                    name: "LPRINT FLUSH".to_string(),
                    args: vec![],
                    line,
                }))
            }
            Token::Identifier(w) if w.eq_ignore_ascii_case("FORMFEED") => {
                self.advance();
                self.consume_to_eol();
                Ok(Statement::Call(CallStmt {
                    name: "LPRINT FORMFEED".to_string(),
                    args: vec![],
                    line,
                }))
            }
            _ => {
                // LPRINT [expr][SPC(n)][TAB(n)][,][;] — same arg grammar as PRINT
                let args = self.parse_print_args()?;
                self.consume_to_eol();
                Ok(Statement::Call(CallStmt {
                    name: "LPRINT".to_string(),
                    args,
                    line,
                }))
            }
        }
    }

    // TRACE: TRACE NEW fname$ / ON / OFF / PRINT expr / CLOSE
    fn parse_trace_statement(&mut self, line: usize) -> PbResult<Statement> {
        self.advance(); // consume TRACE
        let op = self.peek_plain_upper();
        self.advance();
        match op.as_str() {
            "NEW" => {
                let fname = self.parse_expression()?;
                self.consume_to_eol();
                Ok(Statement::Call(CallStmt {
                    name: "TRACE NEW".to_string(),
                    args: vec![fname],
                    line,
                }))
            }
            "PRINT" => {
                let expr = self.parse_expression()?;
                self.consume_to_eol();
                Ok(Statement::Call(CallStmt {
                    name: "TRACE PRINT".to_string(),
                    args: vec![expr],
                    line,
                }))
            }
            "ON" | "OFF" => {
                self.consume_to_eol();
                Ok(Statement::Call(CallStmt {
                    name: format!("TRACE {op}"),
                    args: vec![],
                    line,
                }))
            }
            "CLOSE" => {
                self.consume_to_eol();
                Ok(Statement::Call(CallStmt {
                    name: "TRACE CLOSE".to_string(),
                    args: vec![],
                    line,
                }))
            }
            _ => {
                self.consume_to_eol();
                Ok(Statement::Noop("TRACE".to_string(), line))
            }
        }
    }

    // IMPORT: IMPORT ADDR ProcName$, LibName$ TO AddrVar& [,HndlVar&] / IMPORT CLOSE Hndl
    fn parse_import_statement(&mut self, line: usize) -> PbResult<Statement> {
        self.advance(); // consume IMPORT
        let op = self.peek_plain_upper();
        self.advance();
        match op.as_str() {
            "ADDR" => {
                let procname = self.parse_expression()?;
                if self.peek() == &Token::Comma {
                    self.advance();
                }
                let libname = self.parse_expression()?;
                let mut args = vec![procname, libname];
                if matches!(self.peek(), Token::To) {
                    self.advance();
                    args.push(self.parse_expression()?);
                }
                if self.peek() == &Token::Comma {
                    self.advance();
                    args.push(self.parse_expression()?);
                }
                self.consume_to_eol();
                Ok(Statement::Call(CallStmt {
                    name: "IMPORT ADDR".to_string(),
                    args,
                    line,
                }))
            }
            "CLOSE" => {
                let hndl = self.parse_expression()?;
                self.consume_to_eol();
                Ok(Statement::Call(CallStmt {
                    name: "IMPORT CLOSE".to_string(),
                    args: vec![hndl],
                    line,
                }))
            }
            _ => {
                self.consume_to_eol();
                Ok(Statement::Noop("IMPORT".to_string(), line))
            }
        }
    }

    // CALL DWORD TargetPtr [USING proto(args)] [TO result]
    fn parse_call_dword(&mut self, line: usize) -> PbResult<Statement> {
        self.advance(); // consume DWORD
        let target = self.parse_expression()?;
        let mut args = vec![target];
        let mut has_result = false;
        if let Token::Identifier(w) = self.peek() {
            if w.eq_ignore_ascii_case("USING") {
                self.advance();
                // proto name — parse as primary (may be a plain identifier)
                let _proto = self.parse_primary()?;
                if self.peek() == &Token::LParen {
                    self.advance();
                    while !self.at_eol_or_eof() && self.peek() != &Token::RParen {
                        args.push(self.parse_expression()?);
                        if self.peek() == &Token::Comma {
                            self.advance();
                        } else {
                            break;
                        }
                    }
                    if self.peek() == &Token::RParen {
                        self.advance();
                    }
                }
                if matches!(self.peek(), Token::To) {
                    self.advance();
                    args.push(self.parse_expression()?);
                    has_result = true;
                }
            }
        }
        self.consume_to_eol();
        Ok(Statement::Call(CallStmt {
            name: if has_result {
                "CALL DWORD TO".to_string()
            } else {
                "CALL DWORD".to_string()
            },
            args,
            line,
        }))
    }

    fn parse_clipboard_statement(&mut self, line: usize) -> PbResult<Statement> {
        self.advance(); // consume CLIPBOARD
        match self.peek() {
            Token::Identifier(s) if s.eq_ignore_ascii_case("SET") => {
                self.advance();
                if let Token::Identifier(s2) = self.peek() {
                    if s2.eq_ignore_ascii_case("TEXT") {
                        self.advance();
                        let text = self.parse_expression()?;
                        let result = if self.peek() == &Token::Comma {
                            self.advance();
                            Some(self.parse_expression()?)
                        } else {
                            None
                        };
                        self.consume_to_eol();
                        return Ok(Statement::ClipboardSetText { text, result });
                    }
                }
                self.consume_to_eol();
                Ok(Statement::Noop("CLIPBOARD SET".to_string(), line))
            }
            Token::Identifier(s) if s.eq_ignore_ascii_case("GET") => {
                self.advance();
                if let Token::Identifier(s2) = self.peek() {
                    if s2.eq_ignore_ascii_case("TEXT") {
                        self.advance();
                        if self.peek() == &Token::To {
                            self.advance();
                            let target = self.parse_expression()?;
                            let result = if self.peek() == &Token::Comma {
                                self.advance();
                                Some(self.parse_expression()?)
                            } else {
                                None
                            };
                            self.consume_to_eol();
                            return Ok(Statement::ClipboardGetText { target, result });
                        }
                    }
                }
                self.consume_to_eol();
                Ok(Statement::Noop("CLIPBOARD GET TEXT".to_string(), line))
            }
            Token::Identifier(s) if s.eq_ignore_ascii_case("RESET") => {
                self.advance();
                let result = if self.peek() == &Token::Comma {
                    self.advance();
                    Some(self.parse_expression()?)
                } else {
                    None
                };
                self.consume_to_eol();
                Ok(Statement::ClipboardReset { result })
            }
            _ => {
                self.consume_to_eol();
                Ok(Statement::Noop("CLIPBOARD".to_string(), line))
            }
        }
    }

    fn parse_globalmem_statement(&mut self, line: usize) -> PbResult<Statement> {
        self.advance(); // consume GLOBALMEM
        let op = match self.peek() {
            Token::Identifier(w) => w.to_uppercase(),
            _ => {
                self.consume_to_eol();
                return Ok(Statement::Noop("GLOBALMEM".to_string(), line));
            }
        };
        if !matches!(op.as_str(), "ALLOC" | "FREE" | "LOCK" | "SIZE" | "UNLOCK") {
            self.consume_to_eol();
            return Ok(Statement::Noop(format!("GLOBALMEM {op}"), line));
        }
        self.advance(); // consume op
        let mut args = vec![self.parse_expression()?];
        // Parse remaining comma-separated args
        while self.peek() == &Token::Comma {
            self.advance();
            if self.peek() == &Token::To {
                self.advance();
            }
            if !matches!(self.peek(), Token::Eol | Token::Colon) {
                args.push(self.parse_expression()?);
            }
        }
        self.consume_to_eol();
        Ok(Statement::Call(CallStmt {
            name: format!("GLOBALMEM {op}"),
            args,
            line,
        }))
    }

    fn parse_mouseptr_statement(&mut self, line: usize) -> PbResult<Statement> {
        self.advance(); // consume MOUSEPTR
        let mut args = vec![self.parse_expression()?];
        if self.peek() == &Token::To {
            self.advance(); // consume TO (reserved word)
            args.push(self.parse_expression()?);
        }
        self.consume_to_eol();
        Ok(Statement::Call(CallStmt {
            name: "MOUSEPTR".to_string(),
            args,
            line,
        }))
    }

    fn parse_net_statement(&mut self, line: usize) -> PbResult<Statement> {
        let proto = if let Token::Identifier(w) = self.peek() {
            w.to_uppercase()
        } else {
            self.consume_to_eol();
            return Ok(Statement::Noop("NET".to_string(), line));
        };
        self.advance(); // consume TCP/UDP
        let op = match self.peek() {
            Token::Identifier(w) => w.to_uppercase(),
            Token::Open => "OPEN".to_string(),
            Token::Print => "PRINT".to_string(),
            Token::Close => "CLOSE".to_string(),
            _ => {
                self.consume_to_eol();
                return Ok(Statement::Noop(proto.clone(), line));
            }
        };
        self.advance(); // consume op

        match op.as_str() {
            "OPEN" => {
                if proto == "UDP" {
                    // UDP OPEN [PORT expr] AS #f [TIMEOUT t]
                    let mut port = Expr::IntegerLit(0);
                    if let Token::Identifier(w) = self.peek() {
                        if w.eq_ignore_ascii_case("PORT") {
                            self.advance();
                            port = self.parse_expression()?;
                        }
                    }
                    let mut filenum = Expr::IntegerLit(0);
                    if self.peek() == &Token::As {
                        self.advance();
                        if self.peek() == &Token::Hash {
                            self.advance();
                        }
                        filenum = self.parse_expression()?;
                    }
                    let mut timeout = Expr::IntegerLit(-1);
                    if let Token::Identifier(w) = self.peek() {
                        if w.eq_ignore_ascii_case("TIMEOUT") {
                            self.advance();
                            timeout = self.parse_expression()?;
                        }
                    }
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "UDP OPEN".to_string(),
                        args: vec![port, filenum, timeout],
                        line,
                    }));
                }
                // TCP OPEN [SERVER] {PORT expr | srvc_expr} [AT addr_expr] AS #f [TIMEOUT t]
                let mut mode = Expr::IntegerLit(0);
                let mut port: Option<Expr> = None;
                let mut addr = Expr::StringLit("".to_string());
                let mut timeout = Expr::IntegerLit(-1);
                if let Token::Identifier(w) = self.peek() {
                    if w.eq_ignore_ascii_case("SERVER") {
                        self.advance();
                        mode = Expr::IntegerLit(1);
                    }
                }
                if let Token::Identifier(w) = self.peek() {
                    if w.eq_ignore_ascii_case("PORT") {
                        self.advance();
                        port = Some(self.parse_expression()?);
                    } else if !w.eq_ignore_ascii_case("AT")
                        && !w.eq_ignore_ascii_case("AS")
                        && !w.eq_ignore_ascii_case("TIMEOUT")
                    {
                        // service name or numeric service string
                        port = Some(self.parse_expression()?);
                    }
                }
                let port_v = port.unwrap_or(Expr::IntegerLit(0));
                if let Token::Identifier(w) = self.peek() {
                    if w.eq_ignore_ascii_case("AT") {
                        self.advance();
                        addr = self.parse_expression()?;
                    }
                }
                // AS #f
                let mut filenum = Expr::IntegerLit(0);
                if self.peek() == &Token::As {
                    self.advance();
                    if self.peek() == &Token::Hash {
                        self.advance();
                    }
                    filenum = self.parse_expression()?;
                }
                while let Token::Identifier(w) = self.peek() {
                    if w.eq_ignore_ascii_case("TIMEOUT") {
                        self.advance();
                        timeout = self.parse_expression()?;
                        break;
                    }
                    self.advance();
                }
                self.consume_to_eol();
                Ok(Statement::Call(CallStmt {
                    name: "TCP OPEN".to_string(),
                    args: vec![mode, port_v, addr, filenum, timeout],
                    line,
                }))
            }
            "ACCEPT" => {
                if self.peek() == &Token::Hash {
                    self.advance();
                }
                let srv = self.parse_expression()?;
                self.expect(&Token::As)?;
                if self.peek() == &Token::Hash {
                    self.advance();
                }
                let newf = self.parse_expression()?;
                self.consume_to_eol();
                Ok(Statement::Call(CallStmt {
                    name: format!("{proto} ACCEPT"),
                    args: vec![srv, newf],
                    line,
                }))
            }
            "LINE" => {
                if let Token::Input = self.peek() {
                    self.advance();
                }
                if self.peek() == &Token::Hash {
                    self.advance();
                }
                let f = self.parse_expression()?;
                self.expect(&Token::Comma)?;
                let var = self.parse_expression()?;
                self.consume_to_eol();
                Ok(Statement::Call(CallStmt {
                    name: format!("{proto} LINE INPUT"),
                    args: vec![f, var],
                    line,
                }))
            }
            "PRINT" => {
                if self.peek() == &Token::Hash {
                    self.advance();
                }
                let f = self.parse_expression()?;
                self.expect(&Token::Comma)?;
                let data = self.parse_expression()?;
                let mut nl = Expr::IntegerLit(1);
                if self.peek() == &Token::Semicolon {
                    self.advance();
                    nl = Expr::IntegerLit(0);
                }
                self.consume_to_eol();
                Ok(Statement::Call(CallStmt {
                    name: format!("{proto} PRINT"),
                    args: vec![f, data, nl],
                    line,
                }))
            }
            "SEND" => {
                if proto == "UDP" {
                    // UDP SEND #f, AT ip&, port&, data$
                    if self.peek() == &Token::Hash {
                        self.advance();
                    }
                    let f = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    if let Token::Identifier(w) = self.peek() {
                        if w.eq_ignore_ascii_case("AT") {
                            self.advance();
                        }
                    }
                    let ip = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let port = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let data = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "UDP SEND".to_string(),
                        args: vec![f, ip, port, data],
                        line,
                    }));
                }
                if self.peek() == &Token::Hash {
                    self.advance();
                }
                let f = self.parse_expression()?;
                self.expect(&Token::Comma)?;
                let data = self.parse_expression()?;
                self.consume_to_eol();
                Ok(Statement::Call(CallStmt {
                    name: "TCP SEND".to_string(),
                    args: vec![f, data],
                    line,
                }))
            }
            "RECV" => {
                if proto == "UDP" {
                    // UDP RECV #f, FROM ip&, port&, buf$
                    if self.peek() == &Token::Hash {
                        self.advance();
                    }
                    let f = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    if let Token::Identifier(w) = self.peek() {
                        if w.eq_ignore_ascii_case("FROM") {
                            self.advance();
                        }
                    }
                    let ip = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let port = self.parse_expression()?;
                    self.expect(&Token::Comma)?;
                    let buf = self.parse_expression()?;
                    self.consume_to_eol();
                    return Ok(Statement::Call(CallStmt {
                        name: "UDP RECV".to_string(),
                        args: vec![f, ip, port, buf],
                        line,
                    }));
                }
                if self.peek() == &Token::Hash {
                    self.advance();
                }
                let f = self.parse_expression()?;
                self.expect(&Token::Comma)?;
                let count = self.parse_expression()?;
                self.expect(&Token::Comma)?;
                let var = self.parse_expression()?;
                self.consume_to_eol();
                Ok(Statement::Call(CallStmt {
                    name: "TCP RECV".to_string(),
                    args: vec![f, count, var],
                    line,
                }))
            }
            "CLOSE" => {
                if self.peek() == &Token::Hash {
                    self.advance();
                }
                let f = self.parse_expression()?;
                self.consume_to_eol();
                Ok(Statement::Call(CallStmt {
                    name: format!("{proto} CLOSE"),
                    args: vec![f],
                    line,
                }))
            }
            _ => {
                self.consume_to_eol();
                Ok(Statement::Noop(format!("{proto} {op}"), line))
            }
        }
    }

    fn parse_ucodepage_statement(&mut self, line: usize) -> PbResult<Statement> {
        self.advance(); // consume UCODEPAGE
        let first = match self.peek() {
            Token::Identifier(w) => {
                let u = w.to_uppercase();
                if u == "ANSI" {
                    self.advance();
                    Expr::IntegerLit(0)
                } else if u == "OEM" {
                    self.advance();
                    Expr::IntegerLit(1)
                } else {
                    self.parse_expression()?
                }
            }
            _ => self.parse_expression()?,
        };
        let mut args = vec![first];
        if self.peek() == &Token::To {
            self.advance();
            args.push(self.parse_expression()?);
        }
        self.consume_to_eol();
        Ok(Statement::Call(CallStmt {
            name: "UCODEPAGE".to_string(),
            args,
            line,
        }))
    }

    fn parse_print_statement(&mut self) -> PbResult<Statement> {
        let line = self.current_line();
        self.advance(); // PRINT

        // PRINT #filenum, args
        if self.peek() == &Token::Hash {
            self.advance();
            let file_num = self.parse_expression()?;
            self.expect(&Token::Comma)?;
            let args = self.parse_print_args()?;
            self.consume_to_eol();
            return Ok(Statement::PrintFile(PrintFileStmt {
                file_num,
                args,
                line,
            }));
        }

        let args = self.parse_print_args()?;
        self.consume_to_eol();
        Ok(Statement::Print(PrintStmt { args, line }))
    }

    fn parse_print_args(&mut self) -> PbResult<Vec<Expr>> {
        let mut args = Vec::new();
        while !self.at_eol_or_eof() {
            args.push(self.parse_expression()?);
            // PRINT uses ; or , for concatenation
            match self.peek() {
                Token::Semicolon | Token::Comma => {
                    self.advance();
                }
                _ => break,
            }
        }
        Ok(args)
    }

    fn parse_open_statement(&mut self) -> PbResult<Statement> {
        let line = self.current_line();
        self.advance(); // OPEN

        let filename = self.parse_expression()?;

        self.expect(&Token::For)?;

        let mode = match self.peek() {
            Token::Output => {
                self.advance();
                OpenMode::Output
            }
            Token::Append => {
                self.advance();
                OpenMode::Append
            }
            Token::Input => {
                self.advance();
                OpenMode::Input
            }
            Token::Identifier(w) if w.to_uppercase() == "BINARY" => {
                self.advance();
                OpenMode::Binary
            }
            Token::Identifier(w) if w.to_uppercase() == "RANDOM" => {
                self.advance();
                OpenMode::Random
            }
            _ => {
                self.consume_to_eol();
                return Ok(Statement::Noop("OPEN (unknown mode)".to_string(), line));
            }
        };

        self.expect(&Token::As)?;
        // # is optional: OPEN file FOR OUTPUT AS #num  or  AS num
        if self.peek() == &Token::Hash {
            self.advance();
        }
        let file_num = self.parse_expression()?;

        // Optional LEN=nnn for RANDOM mode (record length)
        let mut reclen: Option<Expr> = None;
        if let Token::Identifier(w) = self.peek() {
            if w.eq_ignore_ascii_case("LEN") {
                self.advance();
                // '=' may be Eq token or part of identifier context; consume any '='
                // '=' is Token::Eq
                if self.peek() == &Token::Eq {
                    self.advance();
                }
                reclen = Some(self.parse_expression()?);
            }
        }

        self.consume_to_eol();
        Ok(Statement::Open(OpenStmt {
            filename,
            mode,
            file_num,
            reclen,
            line,
        }))
    }

    fn parse_close_statement(&mut self) -> PbResult<Statement> {
        let line = self.current_line();
        self.advance(); // CLOSE
                        // # is optional in PowerBASIC: CLOSE #filenum or CLOSE filenum
        if self.peek() == &Token::Hash {
            self.advance();
        }
        if self.at_eol_or_eof() {
            // Bare CLOSE with no file number — close all files
            self.consume_to_eol();
            return Ok(Statement::Noop("CLOSE (no file)".to_string(), line));
        }
        let file_num = self.parse_expression()?;
        self.consume_to_eol();
        Ok(Statement::Close(CloseStmt { file_num, line }))
    }

    /// FIELD #n, size AS var [, size2 AS var2 ...]
    /// FIELD dyn$, size AS var [, FROM nStart TO nEnd AS var ...]
    /// FIELD RESET var [, ...]  /  FIELD STRING var [, ...]
    /// MAT a() = RHS — matrix algebra (batch 32).
    /// RHS: CON | CON(expr) | IDN | ZER | src() | src()+src() | src()-src() |
    ///      src()*src() | (expr)*src() | INV(src()) | TRN(src())
    fn parse_mat_statement(&mut self, line: usize) -> PbResult<Statement> {
        // Destination array: identifier with optional ()
        let dst = match self.peek().clone() {
            Token::Identifier(v) => {
                self.advance();
                v
            }
            _ => {
                self.consume_to_eol();
                return Ok(Statement::Noop("MAT".to_string(), line));
            }
        };
        // optional ()
        if self.peek() == &Token::LParen {
            self.advance();
            if self.peek() == &Token::RParen {
                self.advance();
            } else {
                // DIM-style bounds inside — skip to closing paren
                while !matches!(self.peek(), Token::RParen | Token::Eol | Token::Eof) {
                    self.advance();
                }
                if self.peek() == &Token::RParen {
                    self.advance();
                }
            }
        }
        self.expect(&Token::Eq)?;

        // RHS
        let mut op;
        let mut src1: Option<String> = None;
        let mut src2: Option<String> = None;
        let mut scalar: Option<Expr> = None;

        match self.peek().clone() {
            Token::Identifier(w) => {
                let up = w.to_uppercase();
                self.advance();
                match up.as_str() {
                    "CON" | "IDN" | "ZER" => {
                        // optional (expr) for CON
                        if self.peek() == &Token::LParen {
                            self.advance();
                            scalar = Some(self.parse_expression()?);
                            self.expect(&Token::RParen)?;
                            op = MatOp::ConScalar;
                        } else if up == "CON" {
                            op = MatOp::Con;
                        } else if up == "IDN" {
                            op = MatOp::Idn;
                        } else {
                            op = MatOp::Zer;
                        }
                    }
                    "INV" | "TRN" => {
                        self.expect(&Token::LParen)?;
                        if let Token::Identifier(sv) = self.peek().clone() {
                            self.advance();
                            src1 = Some(sv);
                        }
                        // optional ()
                        if self.peek() == &Token::LParen {
                            self.advance();
                            if self.peek() == &Token::RParen {
                                self.advance();
                            }
                        }
                        self.expect(&Token::RParen)?;
                        op = if up == "INV" { MatOp::Inv } else { MatOp::Trn };
                    }
                    _ => {
                        // bare array or a() op b()
                        src1 = Some(w);
                        op = MatOp::Assign;
                        // optional ()
                        if self.peek() == &Token::LParen {
                            self.advance();
                            if self.peek() == &Token::RParen {
                                self.advance();
                            }
                        }
                        // operator?
                        if let Token::Plus = self.peek() {
                            self.advance();
                            op = MatOp::Add;
                            src2 = self.parse_mat_array_name()?;
                        } else if let Token::Minus = self.peek() {
                            self.advance();
                            op = MatOp::Sub;
                            src2 = self.parse_mat_array_name()?;
                        } else if let Token::Star = self.peek() {
                            self.advance();
                            op = MatOp::Mul;
                            src2 = self.parse_mat_array_name()?;
                        }
                    }
                }
            }
            Token::LParen => {
                // (expr) * array
                self.advance();
                scalar = Some(self.parse_expression()?);
                self.expect(&Token::RParen)?;
                self.expect(&Token::Star)?;
                src1 = self.parse_mat_array_name()?;
                op = MatOp::Scale;
            }
            _ => {
                self.consume_to_eol();
                return Ok(Statement::Noop("MAT".to_string(), line));
            }
        }

        self.consume_to_eol();
        Ok(Statement::Mat(MatStmt {
            dst,
            op,
            src1,
            src2,
            scalar,
            line,
        }))
    }

    /// Parse an array name with optional () after a MAT operator.
    fn parse_mat_array_name(&mut self) -> PbResult<Option<String>> {
        let name = match self.peek().clone() {
            Token::Identifier(v) => {
                self.advance();
                v
            }
            _ => return Ok(None),
        };
        if self.peek() == &Token::LParen {
            self.advance();
            if self.peek() == &Token::RParen {
                self.advance();
            }
        }
        Ok(Some(name))
    }

    fn parse_field_statement(&mut self, line: usize) -> PbResult<Statement> {
        // FIELD RESET / FIELD STRING
        // The lexer maps the word STRING to Token::String_, so match through the
        // helper rather than Token::Identifier alone.
        if let Some(w) = self.peek_ident_or_string_keyword() {
            let up = w.to_uppercase();
            if up == "RESET" || up == "STRING" {
                self.advance();
                let kind = if up == "RESET" {
                    FieldKind::Reset
                } else {
                    FieldKind::ToStr
                };
                let mut specs = Vec::new();
                loop {
                    if matches!(self.peek(), Token::Eol | Token::Eof | Token::Colon) {
                        break;
                    }
                    if let Token::Identifier(v) = self.peek().clone() {
                        self.advance();
                        specs.push(FieldSpec {
                            size: 0,
                            name: v,
                            offset: -1,
                        });
                    } else {
                        break;
                    }
                    if self.peek() == &Token::Comma {
                        self.advance();
                    } else {
                        break;
                    }
                }
                self.consume_to_eol();
                return Ok(Statement::Field(FieldStmt {
                    kind,
                    filenum: None,
                    dyn_expr: None,
                    specs,
                    line,
                }));
            }
        }

        // First token after FIELD: #filenum  or  dynamic-string expr
        let mut filenum: Option<Expr> = None;
        let mut dyn_expr: Option<Expr> = None;
        if self.peek() == &Token::Hash {
            self.advance();
            filenum = Some(self.parse_expression()?);
        } else {
            dyn_expr = Some(self.parse_expression()?);
        }

        self.expect(&Token::Comma)?;

        let mut specs = Vec::new();
        loop {
            // Optional FROM nStart TO nEnd
            if let Token::Identifier(w) = self.peek() {
                if w.eq_ignore_ascii_case("FROM") {
                    self.advance();
                    if let Token::IntegerLiteral(n) = self.peek().clone() {
                        self.advance();
                        // optional TO nEnd
                        if let Token::Identifier(w2) = self.peek() {
                            if w2.eq_ignore_ascii_case("TO") {
                                self.advance();
                                if let Token::IntegerLiteral(e) = self.peek().clone() {
                                    self.advance();
                                    specs.push(FieldSpec {
                                        size: e - n + 1,
                                        name: String::new(), // filled below
                                        offset: n - 1,
                                    });
                                }
                            }
                        }
                    }
                    // FROM form still requires "AS var" next
                }
            }
            // nSize
            let size = match self.peek().clone() {
                Token::IntegerLiteral(n) => {
                    self.advance();
                    n
                }
                _ => 0,
            };
            self.expect(&Token::As)?;
            let name = match self.peek().clone() {
                Token::Identifier(v) => {
                    self.advance();
                    v
                }
                _ => String::new(),
            };
            // Merge with pending FROM-spec (if any)
            if let Some(last) = specs.last_mut() {
                if last.name.is_empty() && last.size > 0 {
                    last.name = name;
                } else {
                    specs.push(FieldSpec {
                        size,
                        name,
                        offset: -1,
                    });
                }
            } else {
                specs.push(FieldSpec {
                    size,
                    name,
                    offset: -1,
                });
            }
            if self.peek() == &Token::Comma {
                self.advance();
            } else {
                break;
            }
        }
        self.consume_to_eol();
        Ok(Statement::Field(FieldStmt {
            kind: if filenum.is_some() {
                FieldKind::File
            } else {
                FieldKind::Str
            },
            filenum,
            dyn_expr,
            specs,
            line,
        }))
    }

    // ===== Expression parsing with precedence climbing =====

    fn parse_expression(&mut self) -> PbResult<Expr> {
        self.parse_imp_expr()
    }

    fn parse_imp_expr(&mut self) -> PbResult<Expr> {
        let mut left = self.parse_eqv_expr()?;
        while self.peek() == &Token::Imp {
            self.advance();
            let right = self.parse_eqv_expr()?;
            left = Expr::BinaryOp(BinaryOp::Imp, Box::new(left), Box::new(right));
        }
        Ok(left)
    }

    fn parse_eqv_expr(&mut self) -> PbResult<Expr> {
        let mut left = self.parse_or_expr()?;
        while self.peek() == &Token::Eqv {
            self.advance();
            let right = self.parse_or_expr()?;
            left = Expr::BinaryOp(BinaryOp::Eqv, Box::new(left), Box::new(right));
        }
        Ok(left)
    }

    fn parse_or_expr(&mut self) -> PbResult<Expr> {
        let mut left = self.parse_xor_expr()?;
        while self.peek() == &Token::Or {
            self.advance();
            let right = self.parse_xor_expr()?;
            left = Expr::BinaryOp(BinaryOp::Or, Box::new(left), Box::new(right));
        }
        Ok(left)
    }

    fn parse_xor_expr(&mut self) -> PbResult<Expr> {
        let mut left = self.parse_and_expr()?;
        while self.peek() == &Token::Xor {
            self.advance();
            let right = self.parse_and_expr()?;
            left = Expr::BinaryOp(BinaryOp::Xor, Box::new(left), Box::new(right));
        }
        Ok(left)
    }

    fn parse_and_expr(&mut self) -> PbResult<Expr> {
        let mut left = self.parse_not_expr()?;
        while self.peek() == &Token::And {
            self.advance();
            let right = self.parse_not_expr()?;
            left = Expr::BinaryOp(BinaryOp::And, Box::new(left), Box::new(right));
        }
        Ok(left)
    }

    fn parse_not_expr(&mut self) -> PbResult<Expr> {
        if self.peek() == &Token::Not {
            self.advance();
            let expr = self.parse_comparison()?;
            return Ok(Expr::UnaryOp(UnaryOp::Not, Box::new(expr)));
        }
        self.parse_comparison()
    }

    fn parse_comparison(&mut self) -> PbResult<Expr> {
        let mut left = self.parse_concat_expr()?;
        loop {
            let op = match self.peek() {
                Token::Eq => {
                    // PB allows =< and => as alternatives to <= and >=
                    match self.peek_at(1) {
                        Some(Token::Lt) => {
                            self.advance(); // consume =
                            BinaryOp::Lte
                        }
                        Some(Token::Gt) => {
                            self.advance(); // consume =
                            BinaryOp::Gte
                        }
                        _ => BinaryOp::Eq,
                    }
                }
                Token::Neq => BinaryOp::Neq,
                Token::Lt => BinaryOp::Lt,
                Token::Gt => BinaryOp::Gt,
                Token::Lte => BinaryOp::Lte,
                Token::Gte => BinaryOp::Gte,
                _ => break,
            };
            self.advance();
            let right = self.parse_concat_expr()?;
            left = Expr::BinaryOp(op, Box::new(left), Box::new(right));
        }
        Ok(left)
    }

    fn parse_concat_expr(&mut self) -> PbResult<Expr> {
        let mut left = self.parse_add_sub()?;
        while self.peek() == &Token::Ampersand {
            self.advance();
            let right = self.parse_add_sub()?;
            left = Expr::BinaryOp(BinaryOp::StrConcat, Box::new(left), Box::new(right));
        }
        Ok(left)
    }

    fn parse_add_sub(&mut self) -> PbResult<Expr> {
        let mut left = self.parse_mul_div()?;
        loop {
            let op = match self.peek() {
                Token::Plus => BinaryOp::Add,
                Token::Minus => BinaryOp::Sub,
                _ => break,
            };
            self.advance();
            let right = self.parse_mul_div()?;
            left = Expr::BinaryOp(op, Box::new(left), Box::new(right));
        }
        Ok(left)
    }

    fn parse_mul_div(&mut self) -> PbResult<Expr> {
        let mut left = self.parse_int_div()?;
        loop {
            let op = match self.peek() {
                Token::Star => BinaryOp::Mul,
                Token::Slash => BinaryOp::Div,
                _ => break,
            };
            self.advance();
            let right = self.parse_int_div()?;
            left = Expr::BinaryOp(op, Box::new(left), Box::new(right));
        }
        Ok(left)
    }

    fn parse_int_div(&mut self) -> PbResult<Expr> {
        let mut left = self.parse_mod_expr()?;
        while self.peek() == &Token::Backslash {
            self.advance();
            let right = self.parse_mod_expr()?;
            left = Expr::BinaryOp(BinaryOp::IntDiv, Box::new(left), Box::new(right));
        }
        Ok(left)
    }

    fn parse_mod_expr(&mut self) -> PbResult<Expr> {
        let mut left = self.parse_power()?;
        while self.peek() == &Token::Mod {
            self.advance();
            let right = self.parse_power()?;
            left = Expr::BinaryOp(BinaryOp::Mod, Box::new(left), Box::new(right));
        }
        Ok(left)
    }

    fn parse_power(&mut self) -> PbResult<Expr> {
        let base = self.parse_unary()?;
        if self.peek() == &Token::Caret {
            self.advance();
            let exp = self.parse_unary()?;
            return Ok(Expr::BinaryOp(BinaryOp::Pow, Box::new(base), Box::new(exp)));
        }
        Ok(base)
    }

    fn parse_unary(&mut self) -> PbResult<Expr> {
        if self.peek() == &Token::Minus {
            self.advance();
            let expr = self.parse_primary()?;
            return Ok(Expr::Negate(Box::new(expr)));
        }
        if self.peek() == &Token::Plus {
            self.advance();
            return self.parse_primary();
        }
        self.parse_primary()
    }

    fn parse_primary(&mut self) -> PbResult<Expr> {
        // CB.MSG / CB.HNDL / CB.CTL / CB.CTLMSG / CB.WPARAM / CB.LPARAM
        if let Token::Identifier(w) = self.peek() {
            if w.to_uppercase() == "CB" && self.peek_at(1) == Some(&Token::Dot) {
                if let Some(Token::Identifier(field)) = self.peek_at(2) {
                    let fn_name = match field.to_uppercase().as_str() {
                        "MSG" => "PB_GET_CB_MSG",
                        "HNDL" => "PB_GET_CB_HNDL",
                        "CTL" => "PB_GET_CB_CTL",
                        "CTLMSG" => "PB_GET_CB_CTLMSG",
                        "WPARAM" => "PB_GET_CB_WPARAM",
                        "LPARAM" => "PB_GET_CB_LPARAM",
                        _ => "",
                    };
                    if !fn_name.is_empty() {
                        self.advance();
                        self.advance();
                        self.advance();
                        return Ok(Expr::FunctionCall(fn_name.to_string(), Vec::new()));
                    }
                }
            }
        }
        match self.peek().clone() {
            Token::IntegerLiteral(n) => {
                self.advance();
                Ok(Expr::IntegerLit(n))
            }
            Token::FloatLiteral(f) => {
                self.advance();
                Ok(Expr::FloatLit(f))
            }
            Token::StringLiteral(s) => {
                self.advance();
                Ok(Expr::StringLit(s))
            }
            Token::PercentConstant(name) => {
                self.advance();
                Ok(Expr::PercentConst(name))
            }
            Token::FreeFile => {
                self.advance();
                Ok(Expr::FunctionCall("FREEFILE".to_string(), Vec::new()))
            }
            Token::Ubound | Token::Lbound => {
                let name = if matches!(self.peek(), Token::Ubound) {
                    "UBOUND"
                } else {
                    "LBOUND"
                };
                let name = name.to_string();
                self.advance();
                if self.peek() == &Token::LParen {
                    self.advance();
                    let args = self.parse_arg_list()?;
                    self.expect(&Token::RParen)?;
                    Ok(Expr::FunctionCall(name, args))
                } else {
                    Ok(Expr::FunctionCall(name, Vec::new()))
                }
            }
            Token::LParen => {
                self.advance();
                let expr = self.parse_expression()?;
                self.expect(&Token::RParen)?;
                Ok(expr)
            }
            Token::Identifier(name) if name.eq_ignore_ascii_case("DIR$") => {
                // DIR$(NEXT) or DIR$(mask [, ONLY attr]) — NEXT is a keyword token
                self.advance();
                self.expect(&Token::LParen)?;
                let mut args = Vec::new();
                if self.peek() == &Token::Next {
                    self.advance();
                    args.push(Expr::StringLit("\u{0}DIRNEXT".to_string())); // sentinel
                } else if self.peek() != &Token::RParen {
                    args = self.parse_arg_list()?;
                }
                self.expect(&Token::RParen)?;
                Ok(Expr::FunctionCall("DIR$".to_string(), args))
            }
            Token::Identifier(name) if name.eq_ignore_ascii_case("FILEATTR") => {
                // FILEATTR([#] filenum&, fattr) — optional # before the file number.
                self.advance();
                self.expect(&Token::LParen)?;
                let mut args = Vec::new();
                if self.peek() == &Token::Hash {
                    self.advance();
                }
                args.push(self.parse_expression()?);
                while self.peek() == &Token::Comma {
                    self.advance();
                    args.push(self.parse_expression()?);
                }
                self.expect(&Token::RParen)?;
                Ok(Expr::FunctionCall("FILEATTR".to_string(), args))
            }
            Token::Identifier(name)
                if name.eq_ignore_ascii_case("BITS") || name.eq_ignore_ascii_case("BITS$") =>
            {
                // BITS$(STRING, s$) / BITS$(WSTRING, s$) — director STRING is the String_ keyword,
                // WSTRING is an Identifier token; map both to string modes.
                self.advance();
                self.expect(&Token::LParen)?;
                let mut args = Vec::new();
                if self.peek() == &Token::String_ {
                    self.advance();
                    args.push(Expr::StringLit("STRING".to_string()));
                    if self.peek() == &Token::Comma {
                        self.advance();
                    }
                    args.extend(self.parse_arg_list()?);
                } else if let Token::Identifier(ref w) = self.peek().clone() {
                    let u = w.to_uppercase();
                    if u == "WSTRING" {
                        self.advance();
                        args.push(Expr::StringLit(u));
                        if self.peek() == &Token::Comma {
                            self.advance();
                        }
                        args.extend(self.parse_arg_list()?);
                    } else if self.peek() != &Token::RParen {
                        args = self.parse_arg_list()?;
                    }
                }
                self.expect(&Token::RParen)?;
                Ok(Expr::FunctionCall("BITS$".to_string(), args))
            }
            Token::Identifier(name)
                if name.eq_ignore_ascii_case("EXTRACT")
                    || name.eq_ignore_ascii_case("EXTRACT$") =>
            {
                // EXTRACT$([start,] MainStr, [ANY] MatchStr) — ANY is an Identifier
                // token here; convert it to a sentinel string so codegen can reorder.
                self.advance();
                self.expect(&Token::LParen)?;
                let mut args = Vec::new();
                loop {
                    if let Token::Identifier(ref w) = self.peek().clone() {
                        if w.eq_ignore_ascii_case("ANY") {
                            args.push(Expr::StringLit("__ANY__".to_string()));
                            self.advance();
                        } else {
                            args.push(self.parse_expression()?);
                        }
                    } else {
                        args.push(self.parse_expression()?);
                    }
                    if self.peek() != &Token::Comma {
                        break;
                    }
                    self.advance();
                }
                self.expect(&Token::RParen)?;
                Ok(Expr::FunctionCall("EXTRACT".to_string(), args))
            }
            Token::Identifier(name)
                if name.eq_ignore_ascii_case("PATHSCAN")
                    || name.eq_ignore_ascii_case("PATHSCAN$") =>
            {
                // PATHSCAN$(director, filespec$ [, pathspec$]) — director words are
                // Identifier tokens (FULL/PATH/NAME/EXTN/NAMEX); convert to strings.
                self.advance();
                self.expect(&Token::LParen)?;
                let mut args = Vec::new();
                if let Token::Identifier(ref w) = self.peek().clone() {
                    args.push(Expr::StringLit(w.to_uppercase()));
                    self.advance();
                } else {
                    args.push(self.parse_expression()?);
                }
                while self.peek() == &Token::Comma {
                    self.advance();
                    args.push(self.parse_expression()?);
                }
                self.expect(&Token::RParen)?;
                Ok(Expr::FunctionCall("PATHSCAN".to_string(), args))
            }
            Token::Identifier(name)
                if name.eq_ignore_ascii_case("HI")
                    || name.eq_ignore_ascii_case("HI$")
                    || name.eq_ignore_ascii_case("LO")
                    || name.eq_ignore_ascii_case("LO$") =>
            {
                // HI(DataType, value) / LO(DataType, value) — DataType is a type keyword
                // (BYTE/WORD are Identifiers; INTEGER/DWORD/LONG are keyword tokens).
                self.advance();
                self.expect(&Token::LParen)?;
                let dtype = match self.peek().clone() {
                    Token::Integer => "INTEGER".to_string(),
                    Token::Dword => "DWORD".to_string(),
                    Token::Long => "LONG".to_string(),
                    Token::String_ => "STRING".to_string(),
                    Token::Identifier(ref w) => w.to_uppercase(),
                    _ => {
                        return Err(PbError::parser(
                            format!("HI/LO: expected a data type, got {:?}", self.peek()),
                            self.peek_located().file.as_deref(),
                            self.current_line(),
                        ))
                    }
                };
                self.advance();
                self.expect(&Token::Comma)?;
                let val = self.parse_expression()?;
                self.expect(&Token::RParen)?;
                Ok(Expr::FunctionCall(
                    name.to_uppercase().trim_end_matches('$').to_string(),
                    vec![Expr::StringLit(dtype), val],
                ))
            }
            Token::Identifier(name)
                if name.eq_ignore_ascii_case("PATHNAME")
                    || name.eq_ignore_ascii_case("PATHNAME$") =>
            {
                // PATHNAME$(FULL|PATH|NAME|EXTN|NAMEX, filespec$) — director words are Identifier tokens
                self.advance();
                self.expect(&Token::LParen)?;
                let mut args = Vec::new();
                if let Token::Identifier(ref w) = self.peek().clone() {
                    let u = w.to_uppercase();
                    if matches!(u.as_str(), "FULL" | "PATH" | "NAME" | "EXTN" | "NAMEX") {
                        self.advance();
                        args.push(Expr::StringLit(u));
                        if self.peek() == &Token::Comma {
                            self.advance();
                        }
                        args.extend(self.parse_arg_list()?);
                    } else if self.peek() != &Token::RParen {
                        args = self.parse_arg_list()?;
                    }
                }
                self.expect(&Token::RParen)?;
                Ok(Expr::FunctionCall("PATHNAME$".to_string(), args))
            }
            Token::Identifier(name)
                if name.eq_ignore_ascii_case("CLIP") || name.eq_ignore_ascii_case("CLIP$") =>
            {
                // CLIP$(LEFT str, n) / CLIP$(RIGHT str, n) / CLIP$(MID str, start, n)
                // LEFT/RIGHT/MID are keyword tokens — map them to string modes.
                self.advance();
                self.expect(&Token::LParen)?;
                let mut args = Vec::new();
                let mode = match self.peek() {
                    Token::Identifier(ref w) if w.eq_ignore_ascii_case("LEFT") => {
                        self.advance();
                        "LEFT"
                    }
                    Token::Identifier(ref w) if w.eq_ignore_ascii_case("RIGHT") => {
                        self.advance();
                        "RIGHT"
                    }
                    Token::Identifier(ref w) if w.eq_ignore_ascii_case("MID") => {
                        self.advance();
                        "MID"
                    }
                    _ => "",
                };
                if !mode.is_empty() {
                    args.push(Expr::StringLit(mode.to_string()));
                    if self.peek() == &Token::Comma {
                        self.advance();
                    }
                    args.extend(self.parse_arg_list()?);
                } else if self.peek() != &Token::RParen {
                    args = self.parse_arg_list()?;
                }
                self.expect(&Token::RParen)?;
                Ok(Expr::FunctionCall("CLIP".to_string(), args))
            }
            Token::Identifier(name) if name.eq_ignore_ascii_case("VARPTR") => {
                self.advance();
                self.expect(&Token::LParen)?;
                let inner = self.parse_expression()?;
                self.expect(&Token::RParen)?;
                Ok(Expr::Varptr(Box::new(inner)))
            }
            Token::Identifier(name) => {
                // DEF fn inline expansion: name(params) -> subst body
                let def_key = name.to_uppercase();
                if self.def_funcs.contains_key(&def_key) && self.peek_at(1) == Some(&Token::LParen)
                {
                    self.advance(); // consume name
                    self.advance(); // consume (
                    let args = if self.peek() == &Token::RParen {
                        Vec::new()
                    } else {
                        self.parse_arg_list()?
                    };
                    self.expect(&Token::RParen)?;
                    let (params, body) = self.def_funcs.get(&def_key).unwrap().clone();
                    return Ok(subst_def_params(&body, &params, &args));
                }
                self.advance();
                // Check for function call or array access
                let mut expr = if self.peek() == &Token::LParen {
                    self.advance();
                    let args = if self.peek() == &Token::RParen {
                        Vec::new()
                    } else {
                        self.parse_arg_list()?
                    };
                    self.expect(&Token::RParen)?;
                    // Determine if this is a function call or array access
                    // We can't tell at parse time — interpreter will resolve
                    Expr::FunctionCall(name, args)
                } else if name.eq_ignore_ascii_case("DATACOUNT")
                    || name.eq_ignore_ascii_case("THREADCOUNT")
                    || name.eq_ignore_ascii_case("PRINTERCOUNT")
                    || name.eq_ignore_ascii_case("ERL")
                    || name.eq_ignore_ascii_case("ERL$")
                    || name.eq_ignore_ascii_case("ERROR")
                    || name.eq_ignore_ascii_case("ERROR$")
                    || name.eq_ignore_ascii_case("FRE")
                    || name.eq_ignore_ascii_case("THREADID")
                    || name.eq_ignore_ascii_case("FUNCNAME")
                    || name.eq_ignore_ascii_case("FUNCNAME$")
                {
                    // No-argument functions without parentheses (PB syntax: n = DATACOUNT)
                    Expr::FunctionCall(name.to_uppercase(), Vec::new())
                } else {
                    Expr::Variable(name)
                };
                // Chained .member access: obj.field1.field2...
                while self.peek() == &Token::Dot {
                    self.advance();
                    let member = self.consume_identifier()?;
                    expr = Expr::TypeMember(Box::new(expr), member);
                }
                Ok(expr)
            }
            _ => Err(PbError::parser(
                format!("Unexpected token in expression: {:?}", self.peek()),
                self.current_file(),
                self.current_line(),
            )),
        }
    }

    fn parse_arg_list(&mut self) -> PbResult<Vec<Expr>> {
        let mut args = Vec::new();
        loop {
            if self.peek() == &Token::RParen || self.at_end() {
                break;
            }
            // PEEK/POKE datatype keyword as first argument: PEEK(LONG, addr)
            if args.is_empty() {
                let dt = match self.peek() {
                    Token::Long => Some("LONG"),
                    Token::Double => Some("DOUBLE"),
                    Token::Dword => Some("DWORD"),
                    Token::Integer => Some("INTEGER"),
                    Token::Quad => Some("QUAD"),
                    Token::Single => Some("SINGLE"),
                    _ => None,
                };
                if let Some(d) = dt {
                    self.advance();
                    args.push(Expr::Variable(d.to_string()));
                    if self.peek() == &Token::Comma {
                        self.advance();
                    }
                    continue;
                }
            }
            // Skip ANY keyword (used in PARSE$ calls: PARSE$(str$, ANY "|"))
            if matches!(self.peek(), Token::Identifier(ref s) if s.eq_ignore_ascii_case("ANY"))
                && matches!(self.peek_at(1), Some(Token::StringLiteral(_)))
            {
                self.advance(); // skip ANY
            }
            // BYVAL/BYCOPY modifier at call site: Foo(BYVAL x) or Foo(BYCOPY s$)
            // Both override BYREF parameter to pass value directly
            let mut has_byval = matches!(self.peek(), Token::Byval);
            if has_byval {
                self.advance(); // consume BYVAL
            }
            if matches!(self.peek(), Token::Identifier(ref s) if s.eq_ignore_ascii_case("BYCOPY")) {
                has_byval = true;
                self.advance(); // consume BYCOPY
            }
            let expr = self.parse_expression()?;
            args.push(if has_byval {
                Expr::ByvalOverride(Box::new(expr))
            } else {
                expr
            });
            if self.peek() == &Token::Comma {
                self.advance();
            } else {
                break;
            }
        }
        Ok(args)
    }
}

/// Infer PB type from variable name suffix
fn type_from_suffix(name: &str) -> PbType {
    if name.ends_with("##") {
        PbType::Ext
    } else if name.ends_with('#') {
        PbType::Double
    } else if name.ends_with("&&") {
        PbType::Quad
    } else if name.ends_with('&') {
        PbType::Long
    } else if name.ends_with("%%") {
        PbType::Word
    } else if name.ends_with('%') {
        PbType::Integer
    } else if name.ends_with('!') {
        PbType::Single
    } else if name.ends_with("@@") || name.ends_with('@') {
        PbType::Cur
    } else if name.ends_with('$') {
        PbType::String
    } else {
        PbType::Long // PB default numeric type
    }
}

fn has_type_suffix(name: &str) -> bool {
    name.ends_with("##")
        || name.ends_with('#')
        || name.ends_with("&&")
        || name.ends_with('&')
        || name.ends_with("%%")
        || name.ends_with('%')
        || name.ends_with('!')
        || name.ends_with("@@")
        || name.ends_with('@')
        || name.ends_with('$')
}

fn subst_def_params(e: &Expr, params: &[String], args: &[Expr]) -> Expr {
    match e {
        Expr::Variable(n) => {
            if let Some(i) = params.iter().position(|p| p.eq_ignore_ascii_case(n)) {
                args[i].clone()
            } else {
                Expr::Variable(n.clone())
            }
        }
        Expr::UnaryOp(op, x) => {
            Expr::UnaryOp(op.clone(), Box::new(subst_def_params(x, params, args)))
        }
        Expr::BinaryOp(op, a, b) => Expr::BinaryOp(
            op.clone(),
            Box::new(subst_def_params(a, params, args)),
            Box::new(subst_def_params(b, params, args)),
        ),
        Expr::FunctionCall(n, xs) => Expr::FunctionCall(
            n.clone(),
            xs.iter()
                .map(|x| subst_def_params(x, params, args))
                .collect(),
        ),
        Expr::ArrayAccess(n, xs) => Expr::ArrayAccess(
            n.clone(),
            xs.iter()
                .map(|x| subst_def_params(x, params, args))
                .collect(),
        ),
        Expr::TypeMember(x, m) => {
            Expr::TypeMember(Box::new(subst_def_params(x, params, args)), m.clone())
        }
        Expr::Negate(x) => Expr::Negate(Box::new(subst_def_params(x, params, args))),
        Expr::Varptr(x) => Expr::Varptr(Box::new(subst_def_params(x, params, args))),
        Expr::ByvalOverride(x) => Expr::ByvalOverride(Box::new(subst_def_params(x, params, args))),
        _ => e.clone(),
    }
}
