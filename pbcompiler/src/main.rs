use std::collections::HashMap;
use std::path::Path;
use std::process;

use pb::error::PbResult;
use pb::lexer::Lexer;
use pb::parser::Parser;
use pb::preprocessor::Preprocessor;

mod codegen;
mod llvm_ir;
mod symbols;

fn main() {
    let args: Vec<String> = std::env::args().collect();

    if args.len() < 3 || args[1] != "build" {
        eprintln!(
            "Usage: pbcompiler build <file.bas> [-o output] [--dll] [--exe] [--session-struct]"
        );
        eprintln!("       [--emit-llvm] [--parse-only] [--runtime-lib path] [--lib-dir path]");
        eprintln!("       [--debug] [--target triple]");
        process::exit(2);
    }

    let file_path = &args[2];
    let dll_mode = args.iter().any(|a| a == "--dll");
    let exe_mode = args.iter().any(|a| a == "--exe");
    let session_mode = args.iter().any(|a| a == "--session-struct");
    let parse_only = args.iter().any(|a| a == "--parse-only");
    let emit_llvm = args.iter().any(|a| a == "--emit-llvm");
    let debug_mode = args.iter().any(|a| a == "--debug");

    let output = get_flag_value(&args, "-o").unwrap_or_else(|| {
        let p = Path::new(file_path);
        p.with_extension("obj").to_string_lossy().into_owned()
    });

    let runtime_lib = get_flag_value(&args, "--runtime-lib");
    let lib_dir = get_flag_value(&args, "--lib-dir").or_else(|| {
        let d = detect_sdk_lib_dir();
        match &d {
            Some(path) => {
                eprintln!(
                    "[pbcompiler] Auto-detected Windows SDK lib dir: {}",
                    path
                )
            }
            None => {
                if exe_mode {
                    eprintln!(
                        "[pbcompiler] Warning: --lib-dir not given and no Windows SDK found under C:\\Program Files (x86)\\Windows Kits\\10\\Lib; linking may fail."
                    );
                }
            }
        }
        d
    });
    let split_threshold = get_flag_value(&args, "--split-threshold")
        .and_then(|s| s.parse::<usize>().ok())
        .unwrap_or(0);
    let target =
        get_flag_value(&args, "--target").unwrap_or_else(|| codegen::DEFAULT_TARGET.to_string());

    let opts = codegen::CompileOptions {
        dll_mode,
        exe_mode,
        session_mode,
        emit_llvm,
        debug_mode,
        runtime_lib,
        lib_dir,
        split_threshold,
        target,
    };

    match compile_file(file_path, &output, parse_only, &opts) {
        Ok(()) => {
            eprintln!("[pbcompiler] Success: {}", output);
        }
        Err(e) => {
            eprintln!("Error: {}", e);
            process::exit(1);
        }
    }
}

/// Get the value following a flag like "--runtime-lib /path/to/file"
fn get_flag_value(args: &[String], flag: &str) -> Option<String> {
    args.iter()
        .position(|a| a == flag)
        .and_then(|pos| args.get(pos + 1).cloned())
}
/// Auto-detect the Windows SDK import-library directory so users do not have
/// to pass --lib-dir by hand. Scans the standard install roots and picks the
/// newest installed version whose `um\x64` folder exists.
fn detect_sdk_lib_dir() -> Option<String> {
    let roots = [
        r"C:\Program Files (x86)\Windows Kits\10\Lib",
        r"C:\Program Files\Windows Kits\10\Lib",
    ];
    let mut best: Option<(Vec<u64>, String)> = None;
    for root in roots.iter() {
        let root_path = Path::new(root);
        let entries = match std::fs::read_dir(root_path) {
            Ok(e) => e,
            Err(_) => continue,
        };
        for entry in entries.flatten() {
            let name = entry.file_name().to_string_lossy().into_owned();
            // Version folders look like "10.0.26100.0"; skip non-version names.
            let ver: Vec<u64> = name
                .split('.')
                .filter_map(|s| s.parse::<u64>().ok())
                .collect();
            if ver.is_empty() {
                continue;
            }
            let um64 = root_path.join(&name).join("um").join("x64");
            if !um64.is_dir() {
                continue;
            }
            if best.as_ref().is_none_or(|(bv, _)| ver > *bv) {
                best = Some((ver, um64.to_string_lossy().into_owned()));
            }
        }
    }
    best.map(|(_, path)| path)
}

fn compile_file(
    path: &str,
    output: &str,
    parse_only: bool,
    opts: &codegen::CompileOptions,
) -> PbResult<()> {
    let path = Path::new(path);

    // Phase 1: Preprocess
    let t0 = std::time::Instant::now();
    let mut preprocessor = Preprocessor::new();
    let source_lines = preprocessor.process_file(path)?;
    eprintln!(
        "[pbcompiler] Preprocessed {} lines ({:.1}s)",
        source_lines.len(),
        t0.elapsed().as_secs_f64()
    );

    // Reassemble into single source string for lexing
    let mut combined = String::new();
    for sl in &source_lines {
        combined.push_str(&sl.text);
        combined.push('\n');
    }

    // Phase 2: Lex
    let t1 = std::time::Instant::now();
    let mut lexer = Lexer::new(&combined, path.to_str());
    let tokens = lexer.tokenize()?;
    eprintln!(
        "[pbcompiler] Lexed {} tokens ({:.1}s)",
        tokens.len(),
        t1.elapsed().as_secs_f64()
    );

    // Phase 3: Parse
    let t2 = std::time::Instant::now();
    let mut parser = Parser::new(tokens);
    let program = parser.parse()?;
    eprintln!(
        "[pbcompiler] Parsed {} top-level items ({:.1}s)",
        program.items.len(),
        t2.elapsed().as_secs_f64()
    );

    if parse_only {
        eprintln!("[pbcompiler] Parse-only mode, skipping codegen");
        return Ok(());
    }

    // Phase 4: Codegen
    let t3 = std::time::Instant::now();
    let output_path = Path::new(output);
    let pp_constants: HashMap<String, i64> = preprocessor.constants().clone();
    codegen::compile(&program, output_path, opts, &pp_constants)?;
    eprintln!(
        "[pbcompiler] Codegen complete ({:.1}s)",
        t3.elapsed().as_secs_f64()
    );

    Ok(())
}
