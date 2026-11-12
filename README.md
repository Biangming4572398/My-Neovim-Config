# Neovim language setup

This configuration automatically detects and configures Rust, Go, Python,
JavaScript, TypeScript, TSX/JSX, Markdown, and PostgreSQL files.

## Included tooling

| Language | Language server | Formatter |
| --- | --- | --- |
| Rust | `rust-analyzer` | `rustfmt` |
| Go | `gopls` | `goimports`, then `gofmt` |
| Python | `basedpyright`, `ruff` | `ruff format` |
| JavaScript / TypeScript | `typescript-language-server` | `prettier` |
| Markdown | `marksman` | `prettier` |
| PostgreSQL | `postgres-language-server` | No standalone formatter |

Mason installs the language servers, `goimports`, and `prettier` under
Neovim's data directory. `rustfmt` and `gofmt` come from the installed Rust
and Go toolchains. Tree-sitter parsers provide syntax highlighting.

## PostgreSQL

SQL files use the PostgreSQL dialect from [pgsql.vim](https://codeberg.org/lifepillar/pgsql.vim).
Keyword, function, and type suggestions appear automatically, without a database connection.
Static suggestions use the plugin's PostgreSQL 14.1 vocabulary.
Use `Ctrl-N` / `Ctrl-P` to select a suggestion and `Ctrl-Y` to accept it.
`Ctrl-Space` closes the syntax menu and requests LSP suggestions when the server is attached.
Table and column suggestions require a database connection.

Mason installs and enables `postgres_lsp`. To use it in a SQL project:

1. Open Neovim in the project root directory.
2. Run `:!postgres-language-server init` to create `postgres-language-server.jsonc`.
3. Set the database connection in that file, then open a `.sql` file.

The server requires `postgres-language-server.jsonc` in the project root.
For syntax checks without a database connection, set
`"db": { "disableConnection": true }` in that file.
See the [database configuration guide](https://pg-language-server.com/main/guides/configure_database/)
for connection settings.

### SQL inside Go files

PostgreSQL keyword completion also works inside Go string literals.
Strings that start with `SELECT`, `WITH`, `INSERT`, `UPDATE`, `DELETE`,
`CREATE`, `ALTER`, `DROP`, `TRUNCATE`, or `EXPLAIN` are detected automatically.
For completion from the first word, start the string with `-- sql`:

```go
query := `-- sql
SELECT jsonb_build_object('id', id) FROM users
`
```

The Go file keeps its `go` filetype. Go completion uses `gopls`.
Embedded SQL uses the keyword list; database table and column suggestions
remain available only in SQL files.

## Useful commands

- `:checkhealth vim.lsp` checks language-server attachment.
- `:Mason` shows installed language tools.
- `:ConformInfo` shows the formatter selected for the current file.
- `:FormatDisable` disables format-on-save globally.
- `:FormatDisable!` disables format-on-save for the current buffer.
- `:FormatEnable` enables format-on-save again.
- `:set filetype?` shows the language detected for the current file.

## Useful keys

- `gd` goes to a definition; `grr` finds references; `K` shows documentation.
- `grr` works in Normal mode and with a Visual selection. It finds references
  to the symbol under the cursor, without replacing the selected text.
- `<Space>rn` renames a symbol; `<Space>ca` opens code actions.
- `<Space>f` formats the current file or visual selection.
- `<Space>th` toggles inlay hints.
- Completion suggestions appear automatically while typing names or member access.
- `Tab` / `Shift-Tab` select the next / previous suggestion; `Enter` accepts it.
  With no suggestion selected, `Enter` inserts a newline.
- `Ctrl-Space` requests completion manually; `Ctrl-N` / `Ctrl-P` also navigate,
  `Ctrl-Y` accepts, and `Ctrl-E` dismisses the menu.
- After accepting a function snippet, `Tab` / `Shift-Tab` move between its fields.
  Outside completion and snippets, `Tab` keeps its normal indentation behavior.
- Typing `(`, `[`, or `{` inserts its matching closing bracket. Typing an
  existing closing bracket moves past it; Backspace removes an empty pair.
- `[d` and `]d` move between diagnostics and open their details.
- `<Space>e` shows full diagnostics for the current line, including their source.
- `<Space>q` opens all diagnostics for the current file; `Enter` jumps to an item.
  Run `:lclose` to close the list.

## Updating

1. Run `:lua vim.pack.update()`, review the plugin changes, and save the
   confirmation buffer.
2. Restart Neovim so the updated plugin code is loaded.
3. Run `:TSUpdate` to keep parser binaries synchronized with Tree-sitter.
4. Run `:MasonToolsUpdate` when you want to update standalone formatters;
   language servers can be updated from `:Mason`.
