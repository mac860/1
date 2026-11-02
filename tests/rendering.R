library(arabicR)
stopifnot(inherits(try(arabic_font("arabicR nonexistent font"), silent = TRUE), "try-error"))
have_font <- "Noto Sans Arabic" %in% systemfonts::system_fonts()$family
if (!have_font) {
  message("SKIP rendering: install Noto Sans Arabic")
} else {
  label <- "مرحبا بالعالم 123 R"
  g <- arabic_grob(label)
  stopifnot(identical(g$label, enc2utf8(label)), identical(g$just, "right"))
  if (requireNamespace("textshaping", quietly = TRUE)) {
    shaped <- arabic_shape("لا")
    # Lam-alef should form a ligature, and every glyph must exist in the font.
    stopifnot(nrow(shaped$shape) == 1L, all(shaped$shape$index > 0))
    mixed <- arabic_shape(label)
    stopifnot(nrow(mixed$shape) > 0L, all(mixed$shape$index > 0))
    bidi <- arabic_shape("بب R 123")$shape
    # Source Arabic clusters appear right-to-left in visual glyph order;
    # Latin letters and digits retain their left-to-right order.
    stopifnot(match(2L, bidi$glyph) < match(1L, bidi$glyph),
              all(diff(match(4:8, bidi$glyph)) > 0))
  } else message("SKIP shaping: install textshaping")
  render <- function(backend) {
    path <- tempfile(fileext = ".png")
    arabic_png(path, width = 800, height = 300, backend = backend)
    tryCatch({grid::grid.newpage(); arabic_text(label)},
             finally = grDevices::dev.off())
    stopifnot(file.info(path)$size > 1000)
    signature <- readBin(path, "raw", 8)
    stopifnot(identical(signature, as.raw(c(137, 80, 78, 71, 13, 10, 26, 10))))
    unlink(path)
  }
  if (requireNamespace("ragg", quietly = TRUE)) render("ragg")
  else message("SKIP ragg device: install ragg")
  if (capabilities("cairo")) {
    render("cairo")
    path <- tempfile(fileext = ".pdf")
    arabic_pdf(path)
    tryCatch(arabic_text(label), finally = grDevices::dev.off())
    stopifnot(file.info(path)$size > 1000,
              identical(rawToChar(readBin(path, "raw", 4)), "%PDF"))
    unlink(path)
  } else message("SKIP Cairo devices: R has no Cairo support")
}
