# Run after installing arabicR: Rscript inst/examples/arabic.R
library(arabicR)
output <- Sys.getenv("ARABICR_OUTPUT_DIR", "arabic-output")
dir.create(output, recursive = TRUE, showWarnings = FALSE)
draw_page <- function() {
  grid::grid.newpage()
  arabic_text("اللغة العربية: حروف متصلة واتجاه من اليمين إلى اليسار", y = 0.80, size = 24)
  arabic_text("مرحباً بالعالم — لا، لأ، لإ، لآ", y = 0.60)
  arabic_text("تقرير R 2026: عدد الطلاب 123، والنسبة ٤٥٪", y = 0.40)
  arabic_text("السَّلَامُ عَلَيْكُمْ", y = 0.20, size = 28)
}
render <- function(open) {
  open()
  on.exit(grDevices::dev.off())
  draw_page()
}
render(function() arabic_png(file.path(output, "arabic-ragg.png")))
if (capabilities("cairo")) {
  render(function() arabic_png(file.path(output, "arabic-cairo.png"), backend = "cairo"))
  render(function() arabic_pdf(file.path(output, "arabic-cairo.pdf")))
}
if (requireNamespace("ggplot2", quietly = TRUE)) {
  p <- ggplot2::ggplot(data.frame(city = c("صنعاء", "عدن", "تعز"), value = c(8, 6, 4)),
                        ggplot2::aes(x = city, y = value)) +
    ggplot2::geom_col(fill = "#167d9a") +
    ggplot2::labs(title = "مثال للرسم باللغة العربية", x = "المدينة", y = "القيمة") +
    arabic_theme()
  render_plot <- function() {
    arabic_png(file.path(output, "arabic-ggplot.png"))
    on.exit(grDevices::dev.off())
    print(p)
  }
  render_plot()
}
