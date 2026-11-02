# Text is kept in logical Unicode order. Reversing strings breaks shaping and bidi.
.need <- function(package, minimum = NULL) {
  if (!requireNamespace(package, quietly = TRUE))
    stop("Install the '", package, "' package to use this function.", call. = FALSE)
  if (!is.null(minimum) && utils::packageVersion(package) < minimum)
    stop("Update '", package, "' to version ", minimum, " or later.", call. = FALSE)
}

#' Find an installed Arabic font
#' @export
arabic_font <- function(family = "Noto Sans Arabic") {
  if (!is.character(family) || length(family) != 1L || is.na(family) || !nzchar(family))
    stop("family must be one nonempty font family name.", call. = FALSE)
  fonts <- systemfonts::system_fonts()
  matches <- unique(fonts$family[tolower(fonts$family) == tolower(family)])
  if (!length(matches))
    stop("Font '", family, "' is not installed. Install Noto Sans Arabic (for example, fonts-noto-core on Debian/Ubuntu), then restart R.", call. = FALSE)
  matches[[1L]]
}

#' Open a PNG device with Arabic shaping support
#' @export
arabic_png <- function(filename, width = 1600, height = 900, res = 144,
                       backend = c("ragg", "cairo"), background = "white") {
  backend <- match.arg(backend)
  if (backend == "ragg") {
    .need("ragg", "1.4.0")
    .need("textshaping", "1.0.5")
    ragg::agg_png(filename, width = width, height = height, units = "px",
                  res = res, background = background)
  } else {
    if (!capabilities("cairo")) stop("This R build has no Cairo support.", call. = FALSE)
    grDevices::png(filename, width = width, height = height, units = "px",
                   res = res, bg = background, type = "cairo")
  }
  invisible(grDevices::dev.cur())
}

#' Open a Cairo PDF device
#' @export
arabic_pdf <- function(filename, width = 10, height = 6,
                       family = "Noto Sans Arabic", background = "white") {
  if (!capabilities("cairo")) stop("This R build has no Cairo support.", call. = FALSE)
  grDevices::cairo_pdf(filename, width = width, height = height,
                       family = arabic_font(family), bg = background)
  invisible(grDevices::dev.cur())
}

#' Create right-aligned Arabic grid text
#' @export
arabic_grob <- function(label, x = 0.95, y = 0.5, family = "Noto Sans Arabic",
                        size = 20, colour = "black", just = "right", ...) {
  if (!is.character(label) || anyNA(label))
    stop("label must be character text without missing values.", call. = FALSE)
  grid::textGrob(enc2utf8(label), x = x, y = y, just = just,
                 gp = grid::gpar(fontfamily = arabic_font(family),
                                 fontsize = size, col = colour), ...)
}

#' Draw right-aligned Arabic grid text
#' @export
arabic_text <- function(label, ...) {
  grob <- arabic_grob(label, ...)
  grid::grid.draw(grob)
  invisible(grob)
}

#' A right-aligned ggplot2 theme
#' @export
arabic_theme <- function(family = "Noto Sans Arabic", base_size = 14) {
  .need("ggplot2")
  ggplot2::theme_minimal(base_size = base_size, base_family = arabic_font(family)) +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 1),
                   plot.subtitle = ggplot2::element_text(hjust = 1),
                   plot.caption = ggplot2::element_text(hjust = 1),
                   legend.position = "right",
                   plot.margin = ggplot2::margin(12, 12, 20, 12),
                   axis.title.x = ggplot2::element_text(margin = ggplot2::margin(t = 10, b = 8)),
                   axis.title.y = ggplot2::element_text(margin = ggplot2::margin(r = 10, l = 8)))
}

#' Inspect Arabic shaping with textshaping
#' @export
arabic_shape <- function(text, family = "Noto Sans Arabic", size = 20) {
  .need("textshaping", "1.0.5")
  if (!is.character(text) || anyNA(text))
    stop("text must be character text without missing values.", call. = FALSE)
  textshaping::shape_text(enc2utf8(text), family = arabic_font(family), size = size)
}
