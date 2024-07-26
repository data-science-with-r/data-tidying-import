# Scraping an eCommerce page (complete)

# load packages ----------------------------------------------------------------

library(polite)
library(rvest)
library(tidyverse)

# check for scrape-ability -----------------------------------------------------

bow("https://www.scrapingcourse.com")

# read page --------------------------------------------------------------------

url <- "https://www.scrapingcourse.com/ecommerce/"
page <- read_html(url)

# extract item names -----------------------------------------------------------

titles <- page |>
  html_elements(".woocommerce-loop-product__title") |>
  html_text()

# extract item URLs ------------------------------------------------------------

urls <- page |>
  html_elements(".woocommerce-loop-product__link") |>
  html_attr("href")

# extract item prices ----------------------------------------------------------

prices <- page |>
  html_elements(".price") |>
  html_text() |>
  str_remove("\\$") |>
  as.numeric()

# make tibble ------------------------------------------------------------------

items <- tibble(
  title = titles,
  price = prices,
  urls = urls
)

# write csv --------------------------------------------------------------------

#write_csv(items, "data/items.csv")
