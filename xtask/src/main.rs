//! Repository automation, run with `cargo xtask <task>`.

use std::path::{Path, PathBuf};
use std::process::ExitCode;

use anyhow::{Context, bail};

const USAGE: &str = "\
Usage: cargo xtask <task>

Tasks:
  codegen          Regenerate the protocol JSON Schema
  codegen --check  Fail if the committed schema is out of date";

const SCHEMA_PATH: &str = "packages/protocol/schema/protocol.schema.json";

fn main() -> ExitCode {
    let args: Vec<String> = std::env::args().skip(1).collect();
    let args: Vec<&str> = args.iter().map(String::as_str).collect();
    let outcome = match args.as_slice() {
        ["codegen"] => codegen(false),
        ["codegen", "--check"] => codegen(true),
        _ => {
            eprintln!("{USAGE}");
            return ExitCode::FAILURE;
        }
    };
    match outcome {
        Ok(()) => ExitCode::SUCCESS,
        Err(error) => {
            eprintln!("error: {error:#}");
            ExitCode::FAILURE
        }
    }
}

fn codegen(check: bool) -> anyhow::Result<()> {
    let path = repo_root().join(SCHEMA_PATH);
    let mut schema = serde_json::to_string_pretty(&teloche_protocol::json_schema())?;
    schema.push('\n');

    if check {
        let committed = std::fs::read_to_string(&path).unwrap_or_default();
        if committed != schema {
            bail!("{SCHEMA_PATH} is out of date: run `just codegen` and commit the result");
        }
        println!("{SCHEMA_PATH} is up to date");
        return Ok(());
    }

    std::fs::create_dir_all(path.parent().context("schema path has a parent")?)?;
    std::fs::write(&path, schema).with_context(|| format!("cannot write {}", path.display()))?;
    println!("wrote {SCHEMA_PATH}");
    Ok(())
}

fn repo_root() -> PathBuf {
    Path::new(env!("CARGO_MANIFEST_DIR"))
        .parent()
        .expect("xtask lives in the repository root")
        .to_path_buf()
}
