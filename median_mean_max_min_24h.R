require(readxl)
require(dplyr)
library(lubridate)
library(ggplot2)

data <- read.csv("out.csv")
base = 14400
hour_4=data$begin_stamp[1] + base
data <- data %>% mutate(date = ymd_hms(as.POSIXct(begin_stamp, origin="1970-01-01")))

data <- data %>% mutate(hour = trunc((window-1)/240)) 

data <- data %>% mutate(begin_stamp=(((hour_4+(base*hour))-begin_stamp)/60))

data <- data %>% mutate(median=median*1000)
data <- data %>% mutate(max=max*1000)
data <- data %>% mutate(min=min*1000)
data <- data %>% mutate(mean=mean*1000)

plot <- data %>% ggplot() + geom_point(aes(begin_stamp, log(median), color="median"), alpha = 0.5) +
                                   geom_point(aes(begin_stamp, log(max), color="max" ), alpha = 0.5) +
                                   geom_point(aes(begin_stamp, log(min), color="min"), alpha = 0.5) +
                                   geom_point(aes(begin_stamp, log(mean), color="mean"), alpha = 0.5) +
                                   labs(colour="Values") + facet_wrap(~hour, ncol=6)
plot
