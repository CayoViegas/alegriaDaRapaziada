require(readxl)
require(dplyr)
library(lubridate)
library(ggplot2)

date <- read.csv("out.csv")
base = 14400
hour_four=date$begin_stamp[1] + base
date <- date %>% mutate(date = ymd_hms(as.POSIXct(begin_stamp, origin="1970-01-01")))

date <- date %>% mutate(hour = trunc((window-1)/240)) 

date <- date %>% mutate(begin_stamp=(((hour_four+(base*hour))-begin_stamp)/60))

date <- date %>% mutate(median = median * 10 * 10 * 10)
date <- date %>% mutate(max = max * 10 * 10 * 10)
date <- date %>% mutate(min = min * 10 * 10 * 10)
date <- date %>% mutate(mean = mean * 10 * 10 * 10)

plot <- date %>% ggplot() + geom_point(aes(begin_stamp, log(median), color="median"), alpha = 0.5) +
                                   geom_point(aes(begin_stamp, log(max), color="max" ), alpha = 0.5) +
                                   geom_point(aes(begin_stamp, log(min), color="min"), alpha = 0.5) +
                                   geom_point(aes(begin_stamp, log(mean), color="mean"), alpha = 0.5) +
                                   labs(colour="Values") + facet_wrap(~hour, ncol=6)
plot
