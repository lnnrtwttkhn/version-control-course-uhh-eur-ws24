pad_list <- function(lst) {
  for (ses in seq_along(lst)) {
    max_length <- max(lengths(lst[[ses]]))
    for (item in seq_along(lst[[ses]])) {
      current_length <- length(lst[[ses]][[item]])
      if (current_length < max_length & current_length > 1) {
        lst[[ses]][[item]] <- c(lst[[ses]][[item]], rep("", max_length - current_length))
      }
    }
  }
  return(lst)
}

create_schedule <- function() {
  library("magrittr")
  library("data.table")
  variables <- yaml::read_yaml("_schedule.yml")
  current_date <- Sys.Date()
  session_url <- "https://lennartwittkuhn.com/version-control-course-uhh-ss24/sessions/session%s"
  variables_padded = pad_list(variables)
  dt_load <- data.table::rbindlist(variables_padded, fill = TRUE, idcol = "session")
  cols = c("contents")
  dt = dt_load %>%
    replace(is.na(.), "") %>%
    .[, by = .(session), (cols) := lapply(.SD, paste, collapse = "<br>"), .SDcols = cols] %>%
    unique(.) %>%
    .[, date_dist := as.numeric(as.Date(date) - as.Date(current_date))] %>%
    .[, date_next := replace(rep(0, length(date_dist)), 1:which.max(1 / date_dist), 1)] %>%
    .[, No := seq.int(nrow(.))] %>%
    .[!(title == "") & date_next == 0, title := sprintf("**%s**", title)] %>%
    .[!(title == "") & date_next == 1, title := sprintf("**[%s](%s)**", title, sprintf(session_url, sprintf("%02d", No)))] %>%
    .[!(reading == ""), reading := paste("{{< fa book >}}", reading)] %>%
    setnames(.,
             old = c("No", "date", "title", "contents", "reading", "survey"),
             new = c("No", "Date", "Title", "Contents", "Reading", "Survey/Quiz")) %>%
    .[, c("No", "Date", "Title", "Contents", "Reading", "Survey/Quiz")] %>%
    setcolorder(., c("No", "Date", "Title", "Contents", "Reading", "Survey/Quiz"))
  knitr::kable(dt, format = "markdown", align = "l")
}

table_cheatsheet <- function(name = "all") {
  library("here")
  library("magrittr")
  library("jsonlite")
  json_data <- jsonlite::fromJSON(txt = here::here("cheatsheet.json"))
  df <- json_data %>%
    dplyr::bind_rows(.id = "Chapter") %>%
    tidyr::pivot_longer(cols = -c("Chapter"), names_to = "Command", values_to = "Description") %>%
    transform(Command = sprintf("`%s`", Command)) %>%
    na.omit(.)
  if (name != "all") {
    df <- df %>%
      subset(., Chapter == name) %>%
      subset(., select = c(Command, Description))
  }
  return(df)
}
