# Markdown to PDF conversion

## Container image build

```sh
podman build -t md2pdf .
```

## Convert md file

```sh
podman run \
  --rm \
  --volume "$(pwd):/data" \
  md2pdf \
    --highlight-style solarized-light.theme \
    -H head.tex \
    -V urlcolor=NavyBlue \
    -V colorlinks \
    -V "geometry:top=2cm, bottom=1.5cm, left=2cm, right=2cm" \
    --toc \
    -o output.pdf \
    input.md
```

## Resources

- [Converting Markdown to Beautiful PDF with Pandoc](https://jdhao.github.io/2019/05/30/markdown2pdf_pandoc/)
- [pandoc-goodies](https://github.com/tajmone/pandoc-goodies/tree/master/skylighting/themes#kde-vs-pandoc-themes)
- [solarized kate theme](https://github.com/KDE/syntax-highlighting/blob/master/data/themes/solarized-light.theme)
