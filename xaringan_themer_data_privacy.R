library(xaringanthemer)

text_font   <- "Ubuntu"
header_font <- "Tinos"
prim_colour <- "#421460"
sec_colour <- "#b760f0"
font_size <- 11

style_duo_accent(
  primary_color = prim_colour,
  secondary_color = sec_colour,
  inverse_header_color = "#FFFFFF",
  header_font_google = google_font(header_font, "400"),
  text_font_google   = google_font(text_font, "400", "400i", "600i", "700"),
  code_font_google   = google_font("Fira Mono"),
  #title_slide_background_image="img/background.jpg",
  title_slide_text_color="white",
  header_h1_font_size = "3.5rem",
  header_h2_font_size = "2.25rem",
  text_slide_number_font_size="0.6rem",
  outfile = here::here("presentation","xaringan-themer.css")
)
