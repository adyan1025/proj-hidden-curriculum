library(tidyverse)
library(dplyr)

master <- read.csv("master.csv", header= TRUE)

irr <- master %>%
  select(TikTok, Email, Type) %>%
  pivot_wider(names_from = Email, values_from = Type)

irr['match'] = 0
for(i in 1:nrow(irr)) {
    row <- irr[i,]
    if (toString(row[2]) == toString(row[3]) && toString(row[3]) == toString(row[4])) {
        irr$match[i] <- 1
    } else {
        irr$match[i] <- 0
    }
}

View(irr)
result <- (sum(irr$match)/nrow(irr)) * 100
print(result)
write.csv(irr, "irr.csv", row.names = TRUE)