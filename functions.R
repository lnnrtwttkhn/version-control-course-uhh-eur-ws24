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
