# Neovim language setup

This configuration automatically detects and configures Rust, Go, Python,
JavaScript, TypeScript, TSX/JSX, and Markdown files.

## Included tooling

| Language | Language server | Formatter |
| --- | --- | --- |
| Rust | `rust-analyzer` | `rustfmt` |
| Go | `gopls` | `goimports`, then `gofmt` |
| Python | `basedpyright`, `ruff` | `ruff format` |
| JavaScript / TypeScript | `typescript-language-server` | `prettier` |
| Markdown | `marksman` | `prettier` |

Mason installs the language servers, `goimports`, and `prettier` under
Neovim's data directory. `rustfmt` and `gofmt` come from the installed Rust
and Go toolchains. Tree-sitter parsers provide syntax highlighting.

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
