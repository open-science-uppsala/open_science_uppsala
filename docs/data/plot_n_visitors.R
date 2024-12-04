#!/bin/env Rscript
t <- readr::read_csv("n_visitors_in_time.csv", show_col_types = FALSE)
max_n_visitors <- max(t$n_visitors)
seasons <- tibble::tribble(
  ~season, ~xmin, ~xmax,
  1, readr::parse_date("2023-01-01"), readr::parse_date("2023-07-31"),
  2, readr::parse_date("2023-08-01"), readr::parse_date("2023-12-31"),
  3, readr::parse_date("2024-01-01"), readr::parse_date("2024-07-31"),
  4, readr::parse_date("2024-08-01"), readr::parse_date("2024-12-31")
)
seasons$season <- as.factor(seasons$season)
seasons$ymin <- 0
seasons$ymax <- max_n_visitors
ggplot2::ggplot(t, ggplot2::aes(x = date, y = n_visitors)) + 
  ggplot2::scale_x_date(name = "Date") +
  ggplot2::scale_y_continuous(
    name = "Number of visitors",
    limits = c(0, max_n_visitors)
  ) +
  ggplot2::geom_point(size = 10) +
  ggplot2::geom_line() +
  ggplot2::geom_smooth(color = "white", formula = y ~ x, method = "loess") +
  ggplot2::geom_rect(
    data = seasons, 
    inherit.aes = FALSE,
    ggplot2::aes(
      xmin = xmin,
      xmax = xmax,
      ymin = ymin,
      ymax = ymax,
      fill = season
    ),
    alpha = 0.2
  ) +
  ggplot2::labs(
    title = "Number of visitors per event",
    caption = "The number of visitors excludes the speaker(s) and 1 organizer"
  ) +
  ggplot2::theme(text = ggplot2::element_text(size = 20)) +
  ggplot2::theme(
    axis.text.x = ggplot2::element_text(angle = 90, vjust = 0.5, hjust = 1)
  ) +
  ggplot2::theme(legend.position = "bottom")
  
ggplot2::ggsave("n_visitors_in_time.png", width = 7, height = 7)



