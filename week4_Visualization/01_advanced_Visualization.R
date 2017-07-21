setwd("/Users/yoon/Documents/DataScience/week4_Visualization") 
Sys.setlocale("LC_ALL", "ko_KR.UTF-8") # 한글 인코딩 가능하게 해줌

# example 1
library(networkD3)
library(dplyr)
library(yaml)

# example 2
library(ggmap)
library(ggplot2)
library(leaflet)

### example 1 : 네트워크 시각화

# 데이터
data(MisLinks,MisNodes)

MisLinks
MisNodes
# 구현
force_network = forceNetwork(Links = MisLinks, Nodes = MisNodes,
                             width = 500,
                             Source = 'source', Target = 'target',
                             Value = 'value',
                             NodeID = 'name', Group = 'group',
                             opacity = 0.9)

force_network

### example 2 : 인터랙티브 맵핑


geocode('Seoul',output = 'latlona') # 위도,경도 반환 source : google



station_list = c('시청역','을지로입구역','을지로3가역','을지로4가역',
                 '동대문역사문화공원','신당역','상왕십리역','왕십리역',
                 '한양대역','뚝섬역','성수역','건대입구역','구의역',
                 '강변역','잠실나루역','잠실역','신천역','종합운동장역',
                 '삼성역','선릉역','역삼역','강남역','2호선 교대역',
                 '서초역','방배역','사당역','낙성대역','서울대입구역',
                 '봉천역','신림역','신대방역','구로디지털단지역','대림역',
                 '신도림역','문래역','영등포구청역','당산역','합정역',
                 '홍대입구역','신촌역','이대역','아현역','충정로역')
station_df = data.frame(station_list, stringsAsFactors=FALSE)

station_df
# UTF-8 인코딩 한글이여서 인코딩 필요
station_df$station_list = enc2utf8(station_df$station_list)

# 위도 경도가 포함된 역들 (dataframe)
station_lonlat = mutate_geocode(station_df, station_list, source = 'google')
station_lonlat

qmap('seoul',zoom = 11, maptype = 'roadmap') # 지도, seoul 은 서울을 가운데로 놓고 보겠다. 
qmap('seoul',zoom = 11, maptype = 'toner') # 지도를 흑백으로
qmap('seoul',zoom = 11, maptype = 'watercolor')

# 지도위에 레이어 얹기
seoul_map <- qmap('seoul', zoom = 11, maptype = 'toner')
seoul_map

# point 찍기
seoul_map + geom_point(data = station_lonlat,
                       aes(x = lon, y = lat),
                       colour = 'red',
                       size = 2.5)

seoul_map + geom_text(data = station_lonlat,
                      aes(x = lon, y = lat),
                      label = station_lonlat$station_list,
                      colour = 'red',
                      size = 2.5, family = "AppleGothic")
