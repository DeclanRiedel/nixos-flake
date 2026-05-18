# LaTeX Nix Dev Shell

```sh
nix develop
latex-build main.tex
latex-watch main.tex
latex-clean
```

The generated PDF is written next to the source file. Intermediate files live in
`build/`.
