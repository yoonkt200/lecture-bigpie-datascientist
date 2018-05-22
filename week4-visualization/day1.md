# ggplot, googleVis, ggmap을 이용한 간단한 시각화


-----------------------


#### **1. 지하철 유동인구 지도표시**


> **1.1 ggmap, ggplot2, leaflet 활용**

```
지하철 역, 일자, 하루 총 이용객, 시간대별 이용객 feature를 가진 subway.csv라는 파일에서, 
구글 맵을 이용하여 지하철 유동인구를 지하철 역별로 시각화 해보는 연습.

먼저 두가지 방법으로 데이터를 전처리 하였다. 첫 번째로 2012년 5월 8일의 지하철 역 별 유동인구를 시각화했고,
두 번째로 2013년 총 유동인구가 가장 많은 지하철 역을 10순위까지 시각화 하였다.
```

```R
subway = read.csv("subway.csv", header = T, fileEncoding="utf-8")
subway_lonlat = read.csv("subway_latlong.csv", header = T, fileEncoding="utf-8")
head(subway)

colnames(subway_lonlat) = c("station", "stat_name", "LINE_NUM", "FR_CODE", "CYBER_ST_CODE",
                            "XPOINT", "YPOINT", "XPOINT_WGS", "YPOINT_WGS")
merged_subway = merge(x=subway, y=subway_lonlat, by="station")
data_2012_05_08 = subset(merged_subway, income_date=="20120508", select=c("XPOINT_WGS", "YPOINT_WGS", "on_tot", "stat_name.x", "LINE_NUM"))
str(data_2012_05_08)
data_2012_05_08$YPOINT_WGS <- droplevels(data_2012_05_08$YPOINT_WGS)
data_2012_05_08$XPOINT_WGS <- droplevels(data_2012_05_08$XPOINT_WGS)
data_2012_05_08$YPOINT_WGS <- as.character(data_2012_05_08$YPOINT_WGS)
data_2012_05_08$XPOINT_WGS <- as.character(data_2012_05_08$XPOINT_WGS)
data_2012_05_08$YPOINT_WGS <- as.numeric(data_2012_05_08$YPOINT_WGS)
data_2012_05_08$XPOINT_WGS <- as.numeric(data_2012_05_08$XPOINT_WGS)

library(lubridate)
str(merged_subway)
merged_subway$year <- substring(as.character(merged_subway$income_date),1,4)

library(doBy)
temp = summaryBy(on_tot~stat_name.x+year+YPOINT_WGS+XPOINT_WGS, merged_subway, FUN = sum)
data_2013 <- subset(temp, year=="2013")
data_2013$YPOINT_WGS <- droplevels(data_2013$YPOINT_WGS)
data_2013$XPOINT_WGS <- droplevels(data_2013$XPOINT_WGS)
data_2013$YPOINT_WGS <- as.character(data_2013$YPOINT_WGS)
data_2013$XPOINT_WGS <- as.character(data_2013$XPOINT_WGS)
data_2013$YPOINT_WGS <- as.numeric(data_2013$YPOINT_WGS)
data_2013$XPOINT_WGS <- as.numeric(data_2013$XPOINT_WGS)
data_2013_top10 <- data_2013[with(data_2013, order(on_tot.sum, decreasing = T)), ][1:10,]
data_2013_top10_fortext <- data_2013_top10
data_2013_top10_fortext$year <- NULL
data_2013_top10_fortext$on_tot.sum <- NULL
data_2013_top10_fortext$stat_name.x <- as.character(data_2013_top10_fortext$stat_name.x)
```

>> 아래는 위 두 가지 상황에 대한 시각화 결과이다.

![](https://raw.github.com/yoonkt200/lecture-bigpie-datascientist/master/week4-visualization/week4-images/1.png)

![](https://raw.github.com/yoonkt200/lecture-bigpie-datascientist/master/week4-visualization/week4-images/2.png)

> **1.2 googleVis 활용**

```
위의 데이터를 그대로 활용하여, 일자별로 특정 관측값의 경향을 캘린더의 형태로 볼 수 있게 해주는
googleVis의 gvisCalendar를 사용하였다.
```

```R
library(googleVis)
library(lubridate)
subway_specific_gwanghwa = subset(subway, stat_name=="광화문")
subway_specific_gwanghwa$income_date = ymd(subway_specific_gwanghwa$income_date)
Subway_graph <- gvisCalendar(subway_specific_gwanghwa, 
                    datevar="income_date", 
                    numvar="on_tot",
                    options=list(
                      title="Daily traffic in Seoul",
                      height=320,
                      calendar="{yearLabel: { fontName: 'Times-Roman',
                      fontSize: 32, color: '#1A8763', bold: true},
                      cellSize: 10,
                      cellColor: { stroke: 'red', strokeOpacity: 0.2 },
                      focusedCellColor: {stroke:'red'}}")
                    )
plot(Subway_graph)

subway_specific_dap = subset(subway, stat_name=="답십리")
subway_specific_dap$income_date = ymd(subway_specific_dap$income_date)
Subway_graph <- gvisCalendar(subway_specific_dap, 
                             datevar="income_date", 
                             numvar="on_tot",
                             options=list(
                               title="Daily traffic in Seoul",
                               height=320,
                               calendar="{yearLabel: { fontName: 'Times-Roman',
                      fontSize: 32, color: '#1A8763', bold: true},
                      cellSize: 10,
                      cellColor: { stroke: 'red', strokeOpacity: 0.2 },
                      focusedCellColor: {stroke:'red'}}")
)
plot(Subway_graph)
```