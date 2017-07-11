ind3 = c(5,7,8,5,NA,3,NA,7,NA)
length(ind3)
mean(ind3, na.rm = T)
ind3 = ifelse(is.na(ind3),
              round(mean(ind3, na.rm = T),0),
              ind3)
ind3 # --> 결측데이터를 중간값으로 처리하는 과정