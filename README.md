# arabicR

**Alpha 1** — GitHub tag `v0.1.0-alpha.1`, R package version `0.1.0.9000`. The API may change during alpha development.

Arabic text, connected letters, and right-aligned graphics for R, using **Noto Sans Arabic**, **ragg**, **textshaping**, and **Cairo**.

## Install

Install Noto Sans Arabic on your system first. On Debian/Ubuntu:

```sh
sudo apt-get install fonts-noto-core
```

In R:

```r
install.packages(c("systemfonts", "ragg", "textshaping", "ggplot2"))
install.packages("remotes")
remotes::install_github("mac860/1@v0.1.0-alpha.1")
```

For a local checkout, install the dependencies above and run `R CMD INSTALL .`. Source builds of the graphics dependencies may require development libraries for Fontconfig, FreeType, HarfBuzz, FriBidi, PNG, TIFF, and JPEG; Cairo must be enabled in R for the Cairo devices. Restart R after installing fonts. Font files are not bundled or downloaded by this package.

## Draw Arabic

```r
library(arabicR)
arabic_font() # Fails clearly if Noto Sans Arabic is missing
arabic_png("arabic.png") # ragg is the default
tryCatch({
  grid::grid.newpage()
  arabic_text("مرحباً بالعالم", y = 0.7, size = 32)
  arabic_text("تقرير R 2026: عدد الطلاب 123", y = 0.4)
}, finally = dev.off())
```

Text is supplied in ordinary **logical Unicode order**. Do not reverse characters: that can break connected letters, punctuation, and mixed Arabic/English text. Use ragg 1.4.0, systemfonts 1.3.1, and textshaping 1.0.5 or newer; older versions can corrupt fallback glyphs in mixed Arabic/Latin text. ragg uses HarfBuzz shaping and FriBidi bidirectional layout through textshaping. Right alignment controls the text's anchor; the renderer controls letter connections and bidirectional ordering.

```r
# Alternative Cairo devices (requires capabilities("cairo"))
arabic_png("arabic-cairo.png", backend = "cairo")
arabic_text("السَّلَامُ عَلَيْكُمْ")
dev.off()

arabic_pdf("arabic.pdf")
arabic_text("اللغة العربية — لا، لأ، لإ، لآ")
dev.off()

# Inspect shaped glyphs, not a reversed or pre-shaped string
arabic_shape("السلام عليكم")
```

For base graphics on these devices, use `text(..., family = arabic_font(), adj = 1)` for a right anchor. For grid use `arabic_text()` or `arabic_grob()`. For ggplot2 add `arabic_theme()` and save using a ragg device; the complete example is in [inst/examples/arabic.R](inst/examples/arabic.R).

## Examples and validation

From the repository root after installing the package:

```sh
Rscript inst/examples/arabic.R
Rscript tests/rendering.R
R CMD build .
R CMD check --no-manual arabicR_0.1.0.9000.tar.gz
```

With an installed package, you can also run `source(system.file("examples", "arabic.R", package = "arabicR"))`.

The example produces ragg and Cairo PNGs, a Cairo PDF, and an optional ggplot2 chart in `arabic-output/`. Set `ARABICR_OUTPUT_DIR` to choose another directory. Inspect the images for joining, lam-alef ligatures, diacritics, and mixed Arabic/Latin numbers. Automated tests check glyph shaping and device output; image creation alone cannot prove visual typography is correct.

Cairo's text handling depends on your R build and platform. Prefer ragg for consistent PNG output. The package does not change console direction, editor layout, axis order, or table column order. `arabic_theme()` right-aligns plot titles, subtitles, and captions; choose factor levels or axis direction separately when your chart requires them.

## Rendered example

![Arabic text rendered with Cairo](inst/examples/output/arabic-cairo.png)

A [PDF example](inst/examples/output/arabic-cairo.pdf) is also included.

In this prepared cloud workspace, activate the local R runtime before running commands:

```sh
. /workspace/.arabic-r/activate
cd /workspace/1
R CMD INSTALL .
Rscript inst/examples/arabic.R
```

On other machines use your normal R installation; the workspace activation step is specific to this cloud environment.

[شرح الأمثلة بالعربية](inst/examples/README-ar.md)
