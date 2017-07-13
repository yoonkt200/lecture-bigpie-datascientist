install.packages("rvest")
install.packages("httr")

library(rvest)
library(httr)

txt = GET("http://terms.naver.com/entry.nhn?docId=1691554&cid=42171&categoryId=42183")
txt2 = read_html(txt)
