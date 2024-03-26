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
  variables_padded = pad_list(variables)
  dt_load <- data.table::rbindlist(variables_padded, fill = TRUE, idcol = "session") %>%
    .[!is.na(commands), commands := sprintf("`%s`", commands)] %>%
    .[commands == "``", commands := NA] 
  cols = c("contents")
  dt = dt_load %>%
    replace(is.na(.), "") %>%
    .[, by = .(session), (cols) := lapply(.SD, paste, collapse = "<br>"), .SDcols = cols] %>%
    unique(.) %>%
    .[!(title == ""), title := sprintf("**%s**", title)] %>%
    .[!(reading == ""), reading := paste("{{< fa book >}}", reading)] %>%
    .[, No := seq.int(nrow(.))] %>%
    setnames(.,
             old = c("No", "date", "title", "contents", "reading", "survey"),
             new = c("No", "Date", "Title", "Contents", "Reading", "Survey/Quiz")) %>%
    .[, c("No", "Date", "Title", "Contents", "Reading", "Survey/Quiz")]
  knitr::kable(dt, format = "markdown", align = "l")
}
