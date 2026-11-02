# Arabic iris showcase: Rscript inst/examples/iris.R
# Requires: arabicR, ragg, textshaping, ggplot2, ggprism, Noto Sans Arabic.
library(arabicR)
library(ggplot2)
if (!requireNamespace("ggprism", quietly = TRUE)) {
  stop("Install the showcase dependency with install.packages('ggprism').")
}

# BEGIN shared
font <- arabic_font()
iris_ar <- datasets::iris
iris_ar$species_ar <- factor(
  iris_ar$Species,
  levels = c("setosa", "versicolor", "virginica"),
  labels = c("سيتوسا", "فيرسيكولور", "فيرجينيكا")
)
iris_output <- Sys.getenv("ARABICR_OUTPUT_DIR", "arabic-output")
dir.create(iris_output, recursive = TRUE, showWarnings = FALSE)
save_iris <- function(filename, draw) {
  arabic_png(file.path(iris_output, filename), width = 1600, height = 1000)
  on.exit(grDevices::dev.off(), add = TRUE)
  draw()
}
# END shared

# BEGIN barplot
save_iris("iris-barplot.png", function() {
  means <- tapply(iris_ar$Sepal.Length, iris_ar$species_ar, mean)
  graphics::par(family = font, mar = c(6, 11, 6, 3), las = 1)
  bars <- graphics::barplot(
    means, horiz = TRUE, col = c("#167d9a", "#46a89e", "#d99c3b"),
    border = NA, xlim = c(0, 8), xlab = "متوسط طول السبلة (سم)"
  )
  graphics::title(main = "متوسط طول السبلة حسب نوع السوسن", adj = 1)
  graphics::text(as.numeric(means) + 0.15, bars,
                 labels = formatC(means, digits = 2, format = "f"), adj = 0)
})
# END barplot

# BEGIN ggplot
save_iris("iris-ggplot.png", function() {
  p <- ggplot(iris_ar, aes(Sepal.Length, Petal.Length, colour = species_ar)) +
    geom_point(size = 2.8, alpha = 0.8) +
    scale_colour_manual(values = c("#167d9a", "#46a89e", "#d99c3b")) +
    labs(title = "العلاقة بين طول السبلة وطول البتلة",
         subtitle = "بيانات السوسن: ١٥٠ زهرة من ثلاثة أنواع",
         x = "طول السبلة (سم)", y = "طول البتلة (سم)", colour = "نوع السوسن") +
    arabic_theme(base_size = 14)
  print(p)
})
# END ggplot

# BEGIN ggprism
save_iris("iris-ggprism.png", function() {
  p <- ggplot(iris_ar, aes(species_ar, Sepal.Length, fill = species_ar)) +
    geom_boxplot(width = 0.55, outlier.shape = NA, alpha = 0.65) +
    geom_point(position = position_jitter(width = 0.12, height = 0, seed = 860),
               size = 1.7, alpha = 0.65) +
    ggprism::scale_fill_prism(palette = "floral") +
    labs(title = "توزيع طول السبلة حسب نوع السوسن",
         subtitle = "لكل نوع ٥٠ زهرة — الصندوق يوضح الوسيط والربيعات",
         x = "نوع السوسن", y = "طول السبلة (سم)") +
    ggprism::theme_prism(base_family = font, base_fontface = "plain", base_size = 14) +
    theme(text = element_text(lineheight = 1.2),
           legend.position = "none",
           plot.title = element_text(hjust = 1),
           plot.subtitle = element_text(hjust = 1, vjust = 0.5, size = 13),
           plot.margin = margin(16, 16, 24, 16),
           axis.title.x = element_text(vjust = 0.5, margin = margin(t = 10, b = 8)),
           axis.title.y = element_text(vjust = 0.5, margin = margin(r = 10, l = 8)))
  print(p)
})
# END ggprism
