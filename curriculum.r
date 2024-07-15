library(tidyverse)
library(dplyr)

# Read in the CSV file
master <- read.csv("curriculum.csv", header = TRUE)

# Replace blank cells with NA
master[master == ""] <- NA

# Initialize points and total counters
points <- 0
total <- 0

# Function to compare sets of words
compare_sets <- function(a, b) {
  set_a <- unlist(strsplit(a, ", "))
  set_b <- unlist(strsplit(b, ", "))
  return(all(set_a %in% set_b) && all(set_b %in% set_a))
}

# Define a function to handle the comparison and calculation for each column
calculate_matches <- function(df, column_name) {
  irr <- df %>%
    select(Email, TikTok, {{ column_name }}) %>%
    pivot_wider(names_from = Email, values_from = {{ column_name }})
  
  irr['match'] = 0
  local_points <- 0
  
  for (i in 1:nrow(irr)) {
    row <- irr[i, ]
    row[is.na(row)] <- "NA"  # Replace NA with the string "NA"
    if (compare_sets(toString(row[2]), toString(row[3])) && compare_sets(toString(row[3]), toString(row[4]))) {
      irr$match[i] <- 1
      local_points <- local_points + 1  # Increment the local points counter
    } else {
      irr$match[i] <- 0
    }
  }
  
  total <- nrow(irr)
  
  return(list(irr = irr, points = local_points, total = total))
}

# Apply the function to each relevant column
columns <- c("Production", "Coding_Kind", "Language", "Field", "other")
results <- list()

for (col in columns) {
  res <- calculate_matches(master, !!sym(col))
  irr <- res$irr
  points <- points + res$points
  total <- total + res$total
  
  # Save the results to a CSV file
  write.csv(irr, paste0("curriculum_irr_", col, ".csv"), row.names = TRUE)
  
  # Store the results in the list
  results[[col]] <- irr
}

# Calculate the final result
final_result <- (points / total) * 100
print(final_result)
