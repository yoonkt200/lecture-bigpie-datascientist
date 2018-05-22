setwd("/Users/yoon/Documents/DataScience/week4_Visualization") 
Sys.setlocale("LC_ALL", "ko_KR.UTF-8") # 한글 인코딩 가능하게 해줌
library(ggmap)
library(ggplot2)
library(leaflet)

### 데이터 전처리
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

### 시각화
MM <- qmap('seoul',zoom = 11, maptype = 'toner')
MM2 <- MM+geom_point(aes(x=YPOINT_WGS, y=XPOINT_WGS, size=on_tot/4, colour =as.factor(LINE_NUM)), data=data_2012_05_08)
MM2 + scale_size_area(name=c("탑승객수")) + scale_colour_discrete(name=c ("노선")) + labs(x="경도", y="위도")

MMM <- qmap('seoul',zoom = 11, maptype = 'toner')
MMM2 <- MMM+geom_point(aes(x=YPOINT_WGS, y=XPOINT_WGS, size=on_tot.sum/2, colour = as.factor(stat_name.x)), data=data_2013_top10)
MMM2 + scale_size_area(name=c("tot")) + scale_colour_discrete(name=c ("station")) + theme_bw(base_family = "AppleGothic")
MMM2 + geom_text(data = data_2013_top10,
                 aes(x = YPOINT_WGS, y = XPOINT_WGS),
                 label = data_2013_top10$stat_name.x,
                 size = 2.5, family = "AppleGothic")

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
