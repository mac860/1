\name{arabicR}
\alias{arabicR}
\alias{arabic_font}
\alias{arabic_png}
\alias{arabic_pdf}
\alias{arabic_grob}
\alias{arabic_text}
\alias{arabic_theme}
\alias{arabic_shape}
\title{Arabic text and right-to-left graphics}
\description{Render logical-order Unicode Arabic through shaping-capable devices. Text helpers default to a right anchor; bidirectional layout and contextual letter shaping are performed by the graphics backend.}
\usage{
arabic_font(family = "Noto Sans Arabic")
arabic_png(filename, width = 1600, height = 900, res = 144,
           backend = c("ragg", "cairo"), background = "white")
arabic_pdf(filename, width = 10, height = 6,
           family = "Noto Sans Arabic", background = "white")
arabic_grob(label, x = 0.95, y = 0.5, family = "Noto Sans Arabic",
            size = 20, colour = "black", just = "right", ...)
arabic_text(label, ...)
arabic_theme(family = "Noto Sans Arabic", base_size = 14)
arabic_shape(text, family = "Noto Sans Arabic", size = 20)
}
\arguments{
\item{family}{An installed font family. The default is Noto Sans Arabic.}
\item{filename}{Output filename.}
\item{width, height}{Device dimensions: pixels for PNG, inches for PDF.}
\item{res}{PNG resolution in dots per inch.}
\item{backend}{PNG renderer: ragg or built-in Cairo.}
\item{background}{Device background colour.}
\item{label, text}{Character vector in logical Unicode order, without missing values.}
\item{x, y}{Grid positions, in normalized parent coordinates by default.}
\item{size, base_size}{Text size in points.}
\item{colour}{Text colour.}
\item{just}{Grid text justification; defaults to right alignment.}
\item{...}{Further arguments to textGrob, or arabic_grob for arabic_text.}
}
\details{Do not reverse Arabic strings or preconvert them to presentation forms. ragg uses HarfBuzz and FriBidi via textshaping. Cairo support depends on the R build and platform text stack. Use the supplied rendering example to inspect connected letters, diacritics, and mixed text. Right alignment is separate from bidirectional ordering. The ggplot2 theme aligns titles and captions; it does not reverse axes, tables, or factor levels. These helpers do not change the R console, editor, or arbitrary graphics devices. Close devices with dev.off().}
\value{arabic_font returns a family name. Device functions invisibly return the active device number. arabic_grob and arabic_text return a text grob (invisibly for arabic_text). arabic_theme returns a ggplot2 theme. arabic_shape returns textshaping's glyph and metric information for inspection, not a string for drawing.}
\examples{
if (requireNamespace("systemfonts", quietly = TRUE) &&
    "Noto Sans Arabic" \%in\% systemfonts::system_fonts()$family) {
  arabic_font()
  arabic_grob("\u0645\u0631\u062d\u0628\u0627")
}
}
