# Scraping many eCommerce pages (complete)

# load packages ----------------------------------------------------------------

library(polite)
library(rvest)
library(tidyverse)
library(glue)

# check for scrape-ability -----------------------------------------------------

bow("https://www.scrapingcourse.com")

# read page --------------------------------------------------------------------

page_nos <- 1:5
urls <- glue("https://www.scrapingcourse.com/ecommerce/page/{page_nos}/")

# function to scrape page ------------------------------------------------------

scrape_items <- function(url){

  page <- read_html(url)

  # extract item names
  titles <- page |>
    html_elements(".woocommerce-loop-product__title") |>
    html_text()

  # extract item URLs
  urls <- page |>
    html_elements(".woocommerce-loop-product__link") |>
    html_attr("href")

  # extract item prices
  prices <- page |>
    html_elements(".price") |>
    html_text() |>
    str_remove("\\$") |>
    as.numeric()

  # make tibble
  tibble(
    title = titles,
    price = prices,
    urls = urls
  )

}

# test function ----------------------------------------------------------------

#scrape_items(urls[1])
#scrape_items(urls[2])
#scrape_items(urls[3])

# map function over urls -------------------------------------------------------

items <- map(urls, scrape_items) |>
  list_rbind()
