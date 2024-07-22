# load packages ----------------------------------------------------------------

library(tidyverse)
library(scales)
library(here)
library(lubridate)

# load data --------------------------------------------------------------------

biden_raw <- read_csv(here::here("slides/1-3-tidying-data/data","biden/president_approval_polls.csv"))

# prep -------------------------------------------------------------------------

biden <- biden_raw |>
  filter(
    pollster == "YouGov",
    population %in% c("a", "rv") # adults
  ) |>
  mutate(
    date = mdy(end_date),
    population = if_else(population == "a", "All adults", "Registered voters")
  ) |>
  select(pollster, population, date, yes, no) |>
  rename(
    approval = yes,
    disapproval = no
  )

write_csv(biden, file = here::here("slides/1-3-tidying-data/data","biden/biden.csv"))

# plot -------------------------------------------------------------------------

biden_longer <- biden |>
  pivot_longer(
    cols = c(approval, disapproval),
    names_to = "rating_type",
    values_to = "rating_value"
  )

ggplot(biden_longer, aes(x = date, y = rating_value, color = rating_type, group = rating_type)) +
  geom_line() +
  facet_wrap(~ population) +
  scale_color_manual(values = c("darkgreen", "deeppink")) +
  scale_y_continuous(labels = label_percent(scale = 1)) +
  scale_x_date(date_breaks = "1 year", date_labels = "%b %e, %Y") +
  labs(
    x = "Date",
    y = "Rating",
    color = NULL,
    title = "How popular is Joe Biden?",
    subtitle = "Estimates based on polls of all adults and polls of registered voters",
    caption = "Source: FiveThirtyEight modeling estimates"
  ) +
  theme_minimal() +
  theme(legend.position = "bottom")
