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

![](https://raw.github.com/yoonkt200/DataScience/master/week4_Visualization/week4_images/1.png)

![](https://raw.github.com/yoonkt200/DataScience/master/week4_Visualization/week4_images/2.png)

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

{::nomarkdown}

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>CalendarID3af4535d3cf1</title>
<meta http-equiv="content-type" content="text/html;charset=utf-8" />
<style type="text/css">
body {
  color: #444444;
  font-family: Arial,Helvetica,sans-serif;
  font-size: 75%;
  }
  a {
  color: #4D87C7;
  text-decoration: none;
}
</style>
</head>
<body>
 <!-- Calendar generated in R 3.4.0 by googleVis 0.6.2 package -->
<!-- Fri Jul 21 15:59:07 2017 -->


<!-- jsHeader -->
<script type="text/javascript">
 
// jsData 
function gvisDataCalendarID3af4535d3cf1 () {
var data = new google.visualization.DataTable();
var datajson =
[
 [
new Date(2010,0,1),
21995
],
[
new Date(2010,0,2),
34109
],
[
new Date(2010,0,3),
21839
],
[
new Date(2010,0,4),
46387
],
[
new Date(2010,0,5),
45656
],
[
new Date(2010,0,6),
43154
],
[
new Date(2010,0,7),
40860
],
[
new Date(2010,0,8),
40758
],
[
new Date(2010,0,9),
30846
],
[
new Date(2010,0,10),
21285
],
[
new Date(2010,0,11),
39325
],
[
new Date(2010,0,12),
39707
],
[
new Date(2010,0,13),
36877
],
[
new Date(2010,0,14),
36819
],
[
new Date(2010,0,15),
39544
],
[
new Date(2010,0,16),
29930
],
[
new Date(2010,0,17),
21995
],
[
new Date(2010,0,18),
37358
],
[
new Date(2010,0,19),
40434
],
[
new Date(2010,0,20),
36920
],
[
new Date(2010,0,21),
39900
],
[
new Date(2010,0,22),
38642
],
[
new Date(2010,0,23),
29711
],
[
new Date(2010,0,24),
23338
],
[
new Date(2010,0,25),
37182
],
[
new Date(2010,0,26),
39716
],
[
new Date(2010,0,27),
39215
],
[
new Date(2010,0,28),
39931
],
[
new Date(2010,0,29),
38584
],
[
new Date(2010,0,30),
27629
],
[
new Date(2010,0,31),
19676
],
[
new Date(2010,1,1),
36200
],
[
new Date(2010,1,2),
39248
],
[
new Date(2010,1,3),
37127
],
[
new Date(2010,1,4),
38302
],
[
new Date(2010,1,5),
37716
],
[
new Date(2010,1,6),
25685
],
[
new Date(2010,1,7),
20720
],
[
new Date(2010,1,8),
34884
],
[
new Date(2010,1,9),
35627
],
[
new Date(2010,1,10),
37606
],
[
new Date(2010,1,11),
35724
],
[
new Date(2010,1,12),
33670
],
[
new Date(2010,1,13),
13809
],
[
new Date(2010,1,14),
15253
],
[
new Date(2010,1,15),
17910
],
[
new Date(2010,1,16),
33901
],
[
new Date(2010,1,17),
37800
],
[
new Date(2010,1,18),
39690
],
[
new Date(2010,1,19),
39426
],
[
new Date(2010,1,20),
28085
],
[
new Date(2010,1,21),
19101
],
[
new Date(2010,1,22),
36863
],
[
new Date(2010,1,23),
38585
],
[
new Date(2010,1,24),
36925
],
[
new Date(2010,1,25),
35286
],
[
new Date(2010,1,26),
37180
],
[
new Date(2010,1,27),
23702
],
[
new Date(2010,1,28),
20078
],
[
new Date(2010,2,1),
16130
],
[
new Date(2010,2,2),
37649
],
[
new Date(2010,2,3),
37479
],
[
new Date(2010,2,4),
37046
],
[
new Date(2010,2,5),
37485
],
[
new Date(2010,2,6),
25933
],
[
new Date(2010,2,7),
20151
],
[
new Date(2010,2,8),
36907
],
[
new Date(2010,2,9),
39539
],
[
new Date(2010,2,10),
38009
],
[
new Date(2010,2,11),
36940
],
[
new Date(2010,2,12),
37295
],
[
new Date(2010,2,13),
26956
],
[
new Date(2010,2,14),
20260
],
[
new Date(2010,2,15),
34587
],
[
new Date(2010,2,16),
37030
],
[
new Date(2010,2,17),
37480
],
[
new Date(2010,2,18),
36432
],
[
new Date(2010,2,19),
36745
],
[
new Date(2010,2,20),
24022
],
[
new Date(2010,2,21),
19368
],
[
new Date(2010,2,22),
36373
],
[
new Date(2010,2,23),
36595
],
[
new Date(2010,2,24),
36207
],
[
new Date(2010,2,25),
36356
],
[
new Date(2010,2,26),
37614
],
[
new Date(2010,2,27),
24921
],
[
new Date(2010,2,28),
18596
],
[
new Date(2010,2,29),
35504
],
[
new Date(2010,2,30),
35603
],
[
new Date(2010,2,31),
35403
],
[
new Date(2010,3,1),
32870
],
[
new Date(2010,3,2),
33973
],
[
new Date(2010,3,3),
20899
],
[
new Date(2010,3,4),
15244
],
[
new Date(2010,3,5),
32746
],
[
new Date(2010,3,6),
33612
],
[
new Date(2010,3,7),
33285
],
[
new Date(2010,3,8),
33668
],
[
new Date(2010,3,9),
34254
],
[
new Date(2010,3,10),
20910
],
[
new Date(2010,3,11),
14835
],
[
new Date(2010,3,12),
32048
],
[
new Date(2010,3,13),
33337
],
[
new Date(2010,3,14),
32838
],
[
new Date(2010,3,15),
32319
],
[
new Date(2010,3,16),
33135
],
[
new Date(2010,3,17),
21402
],
[
new Date(2010,3,18),
13881
],
[
new Date(2010,3,19),
31129
],
[
new Date(2010,3,20),
32896
],
[
new Date(2010,3,21),
33284
],
[
new Date(2010,3,22),
32811
],
[
new Date(2010,3,23),
33220
],
[
new Date(2010,3,24),
22897
],
[
new Date(2010,3,25),
15690
],
[
new Date(2010,3,26),
32765
],
[
new Date(2010,3,27),
33049
],
[
new Date(2010,3,28),
35346
],
[
new Date(2010,3,29),
33580
],
[
new Date(2010,3,30),
34175
],
[
new Date(2010,4,1),
21835
],
[
new Date(2010,4,2),
15961
],
[
new Date(2010,4,3),
32163
],
[
new Date(2010,4,4),
35197
],
[
new Date(2010,4,5),
20719
],
[
new Date(2010,4,6),
32589
],
[
new Date(2010,4,7),
35253
],
[
new Date(2010,4,8),
20931
],
[
new Date(2010,4,9),
17102
],
[
new Date(2010,4,10),
31966
],
[
new Date(2010,4,11),
33334
],
[
new Date(2010,4,12),
34118
],
[
new Date(2010,4,13),
34147
],
[
new Date(2010,4,14),
35196
],
[
new Date(2010,4,15),
24520
],
[
new Date(2010,4,16),
19037
],
[
new Date(2010,4,17),
33200
],
[
new Date(2010,4,18),
32607
],
[
new Date(2010,4,19),
33488
],
[
new Date(2010,4,20),
34974
],
[
new Date(2010,4,21),
22662
],
[
new Date(2010,4,22),
19249
],
[
new Date(2010,4,23),
13308
],
[
new Date(2010,4,24),
31995
],
[
new Date(2010,4,25),
33051
],
[
new Date(2010,4,26),
34114
],
[
new Date(2010,4,27),
34327
],
[
new Date(2010,4,28),
34240
],
[
new Date(2010,4,29),
23779
],
[
new Date(2010,4,30),
15417
],
[
new Date(2010,4,31),
31788
],
[
new Date(2010,5,1),
33152
],
[
new Date(2010,5,2),
17456
],
[
new Date(2010,5,3),
32859
],
[
new Date(2010,5,4),
32398
],
[
new Date(2010,5,5),
19799
],
[
new Date(2010,5,6),
12858
],
[
new Date(2010,5,7),
32379
],
[
new Date(2010,5,8),
33070
],
[
new Date(2010,5,9),
32806
],
[
new Date(2010,5,10),
32645
],
[
new Date(2010,5,11),
32716
],
[
new Date(2010,5,12),
18892
],
[
new Date(2010,5,13),
12157
],
[
new Date(2010,5,14),
30770
],
[
new Date(2010,5,15),
31806
],
[
new Date(2010,5,16),
31856
],
[
new Date(2010,5,17),
40365
],
[
new Date(2010,5,18),
31418
],
[
new Date(2010,5,19),
18919
],
[
new Date(2010,5,20),
12345
],
[
new Date(2010,5,21),
31825
],
[
new Date(2010,5,22),
33115
],
[
new Date(2010,5,23),
35480
],
[
new Date(2010,5,24),
32985
],
[
new Date(2010,5,25),
32764
],
[
new Date(2010,5,26),
24323
],
[
new Date(2010,5,27),
10272
],
[
new Date(2010,5,28),
31986
],
[
new Date(2010,5,29),
32632
],
[
new Date(2010,5,30),
31072
],
[
new Date(2010,6,1),
32412
],
[
new Date(2010,6,2),
30313
],
[
new Date(2010,6,3),
16294
],
[
new Date(2010,6,4),
11849
],
[
new Date(2010,6,5),
31135
],
[
new Date(2010,6,6),
32528
],
[
new Date(2010,6,7),
32111
],
[
new Date(2010,6,8),
33042
],
[
new Date(2010,6,9),
32734
],
[
new Date(2010,6,10),
19247
],
[
new Date(2010,6,11),
11938
],
[
new Date(2010,6,12),
31843
],
[
new Date(2010,6,13),
32749
],
[
new Date(2010,6,14),
31815
],
[
new Date(2010,6,15),
32149
],
[
new Date(2010,6,16),
32446
],
[
new Date(2010,6,17),
14457
],
[
new Date(2010,6,18),
12947
],
[
new Date(2010,6,19),
31343
],
[
new Date(2010,6,20),
32547
],
[
new Date(2010,6,21),
31995
],
[
new Date(2010,6,22),
32066
],
[
new Date(2010,6,23),
30920
],
[
new Date(2010,6,24),
17687
],
[
new Date(2010,6,25),
13240
],
[
new Date(2010,6,26),
31814
],
[
new Date(2010,6,27),
33204
],
[
new Date(2010,6,28),
32238
],
[
new Date(2010,6,29),
31684
],
[
new Date(2010,6,30),
33210
],
[
new Date(2010,6,31),
19712
],
[
new Date(2010,7,1),
13621
],
[
new Date(2010,7,2),
29893
],
[
new Date(2010,7,3),
32094
],
[
new Date(2010,7,4),
31266
],
[
new Date(2010,7,5),
29208
],
[
new Date(2010,7,6),
29283
],
[
new Date(2010,7,7),
15038
],
[
new Date(2010,7,8),
13285
],
[
new Date(2010,7,9),
29925
],
[
new Date(2010,7,10),
32022
],
[
new Date(2010,7,11),
31202
],
[
new Date(2010,7,12),
31518
],
[
new Date(2010,7,13),
32319
],
[
new Date(2010,7,14),
20063
],
[
new Date(2010,7,15),
42840
],
[
new Date(2010,7,16),
33479
],
[
new Date(2010,7,17),
35351
],
[
new Date(2010,7,18),
35131
],
[
new Date(2010,7,19),
35025
],
[
new Date(2010,7,20),
33885
],
[
new Date(2010,7,21),
22525
],
[
new Date(2010,7,22),
15574
],
[
new Date(2010,7,23),
30957
],
[
new Date(2010,7,24),
31858
],
[
new Date(2010,7,25),
30812
],
[
new Date(2010,7,26),
33831
],
[
new Date(2010,7,27),
41897
],
[
new Date(2010,7,28),
26589
],
[
new Date(2010,7,29),
15212
],
[
new Date(2010,7,30),
35915
],
[
new Date(2010,7,31),
35955
],
[
new Date(2010,8,1),
36283
],
[
new Date(2010,8,2),
33263
],
[
new Date(2010,8,3),
36177
],
[
new Date(2010,8,4),
28944
],
[
new Date(2010,8,5),
20070
],
[
new Date(2010,8,6),
34243
],
[
new Date(2010,8,7),
37004
],
[
new Date(2010,8,8),
37484
],
[
new Date(2010,8,9),
39045
],
[
new Date(2010,8,10),
38323
],
[
new Date(2010,8,11),
27132
],
[
new Date(2010,8,12),
19059
],
[
new Date(2010,8,13),
36084
],
[
new Date(2010,8,14),
37423
],
[
new Date(2010,8,15),
36623
],
[
new Date(2010,8,16),
37312
],
[
new Date(2010,8,17),
37063
],
[
new Date(2010,8,18),
23441
],
[
new Date(2010,8,19),
13602
],
[
new Date(2010,8,20),
29235
],
[
new Date(2010,8,21),
7787
],
[
new Date(2010,8,22),
12101
],
[
new Date(2010,8,23),
18471
],
[
new Date(2010,8,24),
29031
],
[
new Date(2010,8,25),
21896
],
[
new Date(2010,8,26),
15711
],
[
new Date(2010,8,27),
34675
],
[
new Date(2010,8,28),
38326
],
[
new Date(2010,8,29),
35963
],
[
new Date(2010,8,30),
36660
],
[
new Date(2010,9,1),
36893
],
[
new Date(2010,9,2),
25282
],
[
new Date(2010,9,3),
20778
],
[
new Date(2010,9,4),
35465
],
[
new Date(2010,9,5),
35967
],
[
new Date(2010,9,6),
37374
],
[
new Date(2010,9,7),
37522
],
[
new Date(2010,9,8),
38490
],
[
new Date(2010,9,9),
33160
],
[
new Date(2010,9,10),
19791
],
[
new Date(2010,9,11),
33810
],
[
new Date(2010,9,12),
36230
],
[
new Date(2010,9,13),
35778
],
[
new Date(2010,9,14),
37128
],
[
new Date(2010,9,15),
37212
],
[
new Date(2010,9,16),
27844
],
[
new Date(2010,9,17),
19097
],
[
new Date(2010,9,18),
35203
],
[
new Date(2010,9,19),
35340
],
[
new Date(2010,9,20),
35178
],
[
new Date(2010,9,21),
36424
],
[
new Date(2010,9,22),
38224
],
[
new Date(2010,9,23),
28380
],
[
new Date(2010,9,24),
19760
],
[
new Date(2010,9,25),
35416
],
[
new Date(2010,9,26),
36050
],
[
new Date(2010,9,27),
35696
],
[
new Date(2010,9,28),
36301
],
[
new Date(2010,9,29),
36805
],
[
new Date(2010,9,30),
28239
],
[
new Date(2010,9,31),
20478
],
[
new Date(2010,10,1),
34298
],
[
new Date(2010,10,2),
34354
],
[
new Date(2010,10,3),
34770
],
[
new Date(2010,10,4),
35324
],
[
new Date(2010,10,5),
38205
],
[
new Date(2010,10,6),
37737
],
[
new Date(2010,10,7),
27404
],
[
new Date(2010,10,8),
35706
],
[
new Date(2010,10,9),
37437
],
[
new Date(2010,10,10),
41092
],
[
new Date(2010,10,11),
39279
],
[
new Date(2010,10,12),
45033
],
[
new Date(2010,10,13),
39724
],
[
new Date(2010,10,14),
25114
],
[
new Date(2010,10,15),
35532
],
[
new Date(2010,10,16),
35807
],
[
new Date(2010,10,17),
36726
],
[
new Date(2010,10,18),
37798
],
[
new Date(2010,10,19),
37513
],
[
new Date(2010,10,20),
30074
],
[
new Date(2010,10,21),
20631
],
[
new Date(2010,10,22),
34858
],
[
new Date(2010,10,23),
35142
],
[
new Date(2010,10,24),
35883
],
[
new Date(2010,10,25),
35599
],
[
new Date(2010,10,26),
36250
],
[
new Date(2010,10,27),
23346
],
[
new Date(2010,10,28),
16067
],
[
new Date(2010,10,29),
34650
],
[
new Date(2010,10,30),
37482
],
[
new Date(2010,11,1),
36770
],
[
new Date(2010,11,2),
37244
],
[
new Date(2010,11,3),
37848
],
[
new Date(2010,11,4),
25098
],
[
new Date(2010,11,5),
16703
],
[
new Date(2010,11,6),
36193
],
[
new Date(2010,11,7),
37567
],
[
new Date(2010,11,8),
38244
],
[
new Date(2010,11,9),
37412
],
[
new Date(2010,11,10),
38722
],
[
new Date(2010,11,11),
25635
],
[
new Date(2010,11,12),
15746
],
[
new Date(2010,11,13),
34897
],
[
new Date(2010,11,14),
38355
],
[
new Date(2010,11,15),
36167
],
[
new Date(2010,11,16),
37085
],
[
new Date(2010,11,17),
40081
],
[
new Date(2010,11,18),
27684
],
[
new Date(2010,11,19),
19899
],
[
new Date(2010,11,20),
36791
],
[
new Date(2010,11,21),
40356
],
[
new Date(2010,11,22),
40829
],
[
new Date(2010,11,23),
42420
],
[
new Date(2010,11,24),
47012
],
[
new Date(2010,11,25),
28520
],
[
new Date(2010,11,26),
18396
],
[
new Date(2010,11,27),
39296
],
[
new Date(2010,11,28),
42479
],
[
new Date(2010,11,29),
41765
],
[
new Date(2010,11,30),
40185
],
[
new Date(2010,11,31),
41141
],
[
new Date(2011,0,1),
14820
],
[
new Date(2011,0,2),
16533
],
[
new Date(2011,0,3),
35884
],
[
new Date(2011,0,4),
37062
],
[
new Date(2011,0,5),
37909
],
[
new Date(2011,0,6),
37556
],
[
new Date(2011,0,7),
37814
],
[
new Date(2011,0,8),
25952
],
[
new Date(2011,0,9),
17697
],
[
new Date(2011,0,10),
35288
],
[
new Date(2011,0,11),
40442
],
[
new Date(2011,0,12),
36807
],
[
new Date(2011,0,13),
36751
],
[
new Date(2011,0,14),
39617
],
[
new Date(2011,0,15),
25232
],
[
new Date(2011,0,16),
13366
],
[
new Date(2011,0,17),
33659
],
[
new Date(2011,0,18),
37612
],
[
new Date(2011,0,19),
38107
],
[
new Date(2011,0,20),
37494
],
[
new Date(2011,0,21),
37184
],
[
new Date(2011,0,22),
24184
],
[
new Date(2011,0,23),
19788
],
[
new Date(2011,0,24),
36861
],
[
new Date(2011,0,25),
37896
],
[
new Date(2011,0,26),
37946
],
[
new Date(2011,0,27),
37201
],
[
new Date(2011,0,28),
38222
],
[
new Date(2011,0,29),
21501
],
[
new Date(2011,0,30),
14947
],
[
new Date(2011,0,31),
33578
],
[
new Date(2011,1,1),
30501
],
[
new Date(2011,1,2),
9746
],
[
new Date(2011,1,3),
8541
],
[
new Date(2011,1,4),
15919
],
[
new Date(2011,1,5),
19192
],
[
new Date(2011,1,6),
15333
],
[
new Date(2011,1,7),
34087
],
[
new Date(2011,1,8),
36916
],
[
new Date(2011,1,9),
36862
],
[
new Date(2011,1,10),
36538
],
[
new Date(2011,1,11),
36964
],
[
new Date(2011,1,12),
24676
],
[
new Date(2011,1,13),
17147
],
[
new Date(2011,1,14),
36474
],
[
new Date(2011,1,15),
36960
],
[
new Date(2011,1,16),
36728
],
[
new Date(2011,1,17),
36734
],
[
new Date(2011,1,18),
37617
],
[
new Date(2011,1,19),
24899
],
[
new Date(2011,1,20),
19114
],
[
new Date(2011,1,21),
35996
],
[
new Date(2011,1,22),
38166
],
[
new Date(2011,1,23),
38052
],
[
new Date(2011,1,24),
38223
],
[
new Date(2011,1,25),
39041
],
[
new Date(2011,1,26),
25051
],
[
new Date(2011,1,27),
15568
],
[
new Date(2011,1,28),
35927
],
[
new Date(2011,2,1),
21598
],
[
new Date(2011,2,2),
37687
],
[
new Date(2011,2,3),
36472
],
[
new Date(2011,2,4),
37255
],
[
new Date(2011,2,5),
26780
],
[
new Date(2011,2,6),
19361
],
[
new Date(2011,2,7),
37512
],
[
new Date(2011,2,8),
38343
],
[
new Date(2011,2,9),
37440
],
[
new Date(2011,2,10),
37692
],
[
new Date(2011,2,11),
38170
],
[
new Date(2011,2,12),
27995
],
[
new Date(2011,2,13),
20116
],
[
new Date(2011,2,14),
36756
],
[
new Date(2011,2,15),
37403
],
[
new Date(2011,2,16),
36240
],
[
new Date(2011,2,17),
36732
],
[
new Date(2011,2,18),
36644
],
[
new Date(2011,2,19),
24615
],
[
new Date(2011,2,20),
18107
],
[
new Date(2011,2,21),
36868
],
[
new Date(2011,2,22),
36718
],
[
new Date(2011,2,23),
37469
],
[
new Date(2011,2,24),
38025
],
[
new Date(2011,2,25),
38018
],
[
new Date(2011,2,26),
28175
],
[
new Date(2011,2,27),
18861
],
[
new Date(2011,2,28),
34863
],
[
new Date(2011,2,29),
36902
],
[
new Date(2011,2,30),
37745
],
[
new Date(2011,2,31),
36388
],
[
new Date(2011,3,1),
36476
],
[
new Date(2011,3,2),
25152
],
[
new Date(2011,3,3),
19228
],
[
new Date(2011,3,4),
35227
],
[
new Date(2011,3,5),
36922
],
[
new Date(2011,3,6),
37499
],
[
new Date(2011,3,7),
35097
],
[
new Date(2011,3,8),
38309
],
[
new Date(2011,3,9),
27375
],
[
new Date(2011,3,10),
18875
],
[
new Date(2011,3,11),
35509
],
[
new Date(2011,3,12),
35859
],
[
new Date(2011,3,13),
37413
],
[
new Date(2011,3,14),
37413
],
[
new Date(2011,3,15),
36591
],
[
new Date(2011,3,16),
27750
],
[
new Date(2011,3,17),
17752
],
[
new Date(2011,3,18),
33802
],
[
new Date(2011,3,19),
36001
],
[
new Date(2011,3,20),
37233
],
[
new Date(2011,3,21),
36476
],
[
new Date(2011,3,22),
34115
],
[
new Date(2011,3,23),
25213
],
[
new Date(2011,3,24),
17272
],
[
new Date(2011,3,25),
35166
],
[
new Date(2011,3,26),
34141
],
[
new Date(2011,3,27),
35607
],
[
new Date(2011,3,28),
37174
],
[
new Date(2011,3,29),
36422
],
[
new Date(2011,3,30),
21537
],
[
new Date(2011,4,1),
17300
],
[
new Date(2011,4,2),
36182
],
[
new Date(2011,4,3),
37413
],
[
new Date(2011,4,4),
39131
],
[
new Date(2011,4,5),
30718
],
[
new Date(2011,4,6),
35593
],
[
new Date(2011,4,7),
28301
],
[
new Date(2011,4,8),
18950
],
[
new Date(2011,4,9),
32054
],
[
new Date(2011,4,10),
17702
],
[
new Date(2011,4,11),
35732
],
[
new Date(2011,4,12),
36757
],
[
new Date(2011,4,13),
37657
],
[
new Date(2011,4,14),
27035
],
[
new Date(2011,4,15),
19155
],
[
new Date(2011,4,16),
36915
],
[
new Date(2011,4,17),
37477
],
[
new Date(2011,4,18),
38595
],
[
new Date(2011,4,19),
37251
],
[
new Date(2011,4,20),
36190
],
[
new Date(2011,4,21),
29348
],
[
new Date(2011,4,22),
22477
],
[
new Date(2011,4,23),
36643
],
[
new Date(2011,4,24),
40203
],
[
new Date(2011,4,25),
38265
],
[
new Date(2011,4,26),
37369
],
[
new Date(2011,4,27),
37079
],
[
new Date(2011,4,28),
28006
],
[
new Date(2011,4,29),
18840
],
[
new Date(2011,4,30),
36484
],
[
new Date(2011,4,31),
37417
],
[
new Date(2011,5,1),
35258
],
[
new Date(2011,5,2),
37310
],
[
new Date(2011,5,3),
37279
],
[
new Date(2011,5,4),
24790
],
[
new Date(2011,5,5),
18904
],
[
new Date(2011,5,6),
18992
],
[
new Date(2011,5,7),
36871
],
[
new Date(2011,5,8),
36007
],
[
new Date(2011,5,9),
35006
],
[
new Date(2011,5,10),
38334
],
[
new Date(2011,5,11),
27198
],
[
new Date(2011,5,12),
16557
],
[
new Date(2011,5,13),
35421
],
[
new Date(2011,5,14),
36032
],
[
new Date(2011,5,15),
36534
],
[
new Date(2011,5,16),
35766
],
[
new Date(2011,5,17),
35628
],
[
new Date(2011,5,18),
24974
],
[
new Date(2011,5,19),
15669
],
[
new Date(2011,5,20),
34451
],
[
new Date(2011,5,21),
35771
],
[
new Date(2011,5,22),
36982
],
[
new Date(2011,5,23),
34898
],
[
new Date(2011,5,24),
36104
],
[
new Date(2011,5,25),
22931
],
[
new Date(2011,5,26),
13067
],
[
new Date(2011,5,27),
34283
],
[
new Date(2011,5,28),
39286
],
[
new Date(2011,5,29),
36823
],
[
new Date(2011,5,30),
34295
],
[
new Date(2011,6,1),
35626
],
[
new Date(2011,6,2),
21558
],
[
new Date(2011,6,3),
11666
],
[
new Date(2011,6,4),
34945
],
[
new Date(2011,6,5),
36859
],
[
new Date(2011,6,6),
36750
],
[
new Date(2011,6,7),
35092
],
[
new Date(2011,6,8),
37669
],
[
new Date(2011,6,9),
22631
],
[
new Date(2011,6,10),
16596
],
[
new Date(2011,6,11),
33503
],
[
new Date(2011,6,12),
34118
],
[
new Date(2011,6,13),
36045
],
[
new Date(2011,6,14),
36013
],
[
new Date(2011,6,15),
36842
],
[
new Date(2011,6,16),
21149
],
[
new Date(2011,6,17),
17571
],
[
new Date(2011,6,18),
36742
],
[
new Date(2011,6,19),
37496
],
[
new Date(2011,6,20),
35952
],
[
new Date(2011,6,21),
37102
],
[
new Date(2011,6,22),
37329
],
[
new Date(2011,6,23),
24239
],
[
new Date(2011,6,24),
17881
],
[
new Date(2011,6,25),
35341
],
[
new Date(2011,6,26),
41053
],
[
new Date(2011,6,27),
34111
],
[
new Date(2011,6,28),
34128
],
[
new Date(2011,6,29),
37128
],
[
new Date(2011,6,30),
23213
],
[
new Date(2011,6,31),
15357
],
[
new Date(2011,7,1),
35218
],
[
new Date(2011,7,2),
36690
],
[
new Date(2011,7,3),
36064
],
[
new Date(2011,7,4),
35585
],
[
new Date(2011,7,5),
37326
],
[
new Date(2011,7,6),
22148
],
[
new Date(2011,7,7),
16264
],
[
new Date(2011,7,8),
31845
],
[
new Date(2011,7,9),
36337
],
[
new Date(2011,7,10),
37557
],
[
new Date(2011,7,11),
37076
],
[
new Date(2011,7,12),
37076
],
[
new Date(2011,7,13),
22795
],
[
new Date(2011,7,14),
19947
],
[
new Date(2011,7,15),
23406
],
[
new Date(2011,7,16),
35918
],
[
new Date(2011,7,17),
35315
],
[
new Date(2011,7,18),
37684
],
[
new Date(2011,7,19),
37000
],
[
new Date(2011,7,20),
25449
],
[
new Date(2011,7,21),
18393
],
[
new Date(2011,7,22),
35459
],
[
new Date(2011,7,23),
37580
],
[
new Date(2011,7,24),
36885
],
[
new Date(2011,7,25),
37158
],
[
new Date(2011,7,26),
38074
],
[
new Date(2011,7,27),
25963
],
[
new Date(2011,7,28),
17283
],
[
new Date(2011,7,29),
34851
],
[
new Date(2011,7,30),
36591
],
[
new Date(2011,7,31),
36063
],
[
new Date(2011,8,1),
36574
],
[
new Date(2011,8,2),
37416
],
[
new Date(2011,8,3),
26188
],
[
new Date(2011,8,4),
18436
],
[
new Date(2011,8,5),
35576
],
[
new Date(2011,8,6),
38002
],
[
new Date(2011,8,7),
37749
],
[
new Date(2011,8,8),
37274
],
[
new Date(2011,8,9),
35969
],
[
new Date(2011,8,10),
17186
],
[
new Date(2011,8,11),
10621
],
[
new Date(2011,8,12),
10069
],
[
new Date(2011,8,13),
16165
],
[
new Date(2011,8,14),
32796
],
[
new Date(2011,8,15),
36040
],
[
new Date(2011,8,16),
36809
],
[
new Date(2011,8,17),
26254
],
[
new Date(2011,8,18),
18101
],
[
new Date(2011,8,19),
35290
],
[
new Date(2011,8,20),
36989
],
[
new Date(2011,8,21),
36069
],
[
new Date(2011,8,22),
36801
],
[
new Date(2011,8,23),
36642
],
[
new Date(2011,8,24),
26541
],
[
new Date(2011,8,25),
19029
],
[
new Date(2011,8,26),
35011
],
[
new Date(2011,8,27),
36617
],
[
new Date(2011,8,28),
37236
],
[
new Date(2011,8,29),
35553
],
[
new Date(2011,8,30),
40180
],
[
new Date(2011,9,1),
24699
],
[
new Date(2011,9,2),
18859
],
[
new Date(2011,9,3),
20098
],
[
new Date(2011,9,4),
36486
],
[
new Date(2011,9,5),
37465
],
[
new Date(2011,9,6),
37371
],
[
new Date(2011,9,7),
38355
],
[
new Date(2011,9,8),
28758
],
[
new Date(2011,9,9),
19718
],
[
new Date(2011,9,10),
35429
],
[
new Date(2011,9,11),
36843
],
[
new Date(2011,9,12),
36873
],
[
new Date(2011,9,13),
36160
],
[
new Date(2011,9,14),
35852
],
[
new Date(2011,9,15),
24410
],
[
new Date(2011,9,16),
16674
],
[
new Date(2011,9,17),
36132
],
[
new Date(2011,9,18),
36393
],
[
new Date(2011,9,19),
36064
],
[
new Date(2011,9,20),
36638
],
[
new Date(2011,9,21),
38997
],
[
new Date(2011,9,22),
30817
],
[
new Date(2011,9,23),
19914
],
[
new Date(2011,9,24),
35692
],
[
new Date(2011,9,25),
37080
],
[
new Date(2011,9,26),
37417
],
[
new Date(2011,9,27),
37178
],
[
new Date(2011,9,28),
37296
],
[
new Date(2011,9,29),
26509
],
[
new Date(2011,9,30),
19866
],
[
new Date(2011,9,31),
36332
],
[
new Date(2011,10,1),
37069
],
[
new Date(2011,10,2),
37678
],
[
new Date(2011,10,3),
37750
],
[
new Date(2011,10,4),
43699
],
[
new Date(2011,10,5),
34647
],
[
new Date(2011,10,6),
19850
],
[
new Date(2011,10,7),
39044
],
[
new Date(2011,10,8),
40045
],
[
new Date(2011,10,9),
41515
],
[
new Date(2011,10,10),
40578
],
[
new Date(2011,10,11),
42289
],
[
new Date(2011,10,12),
36344
],
[
new Date(2011,10,13),
25213
],
[
new Date(2011,10,14),
38589
],
[
new Date(2011,10,15),
39688
],
[
new Date(2011,10,16),
40774
],
[
new Date(2011,10,17),
40013
],
[
new Date(2011,10,18),
39541
],
[
new Date(2011,10,19),
30809
],
[
new Date(2011,10,20),
21291
],
[
new Date(2011,10,21),
37404
],
[
new Date(2011,10,22),
38862
],
[
new Date(2011,10,23),
40026
],
[
new Date(2011,10,24),
40636
],
[
new Date(2011,10,25),
40541
],
[
new Date(2011,10,26),
29621
],
[
new Date(2011,10,27),
16641
],
[
new Date(2011,10,28),
39212
],
[
new Date(2011,10,29),
40307
],
[
new Date(2011,10,30),
38657
],
[
new Date(2011,11,1),
39153
],
[
new Date(2011,11,2),
39872
],
[
new Date(2011,11,3),
28022
],
[
new Date(2011,11,4),
17918
],
[
new Date(2011,11,5),
37839
],
[
new Date(2011,11,6),
38838
],
[
new Date(2011,11,7),
37749
],
[
new Date(2011,11,8),
40695
],
[
new Date(2011,11,9),
41217
],
[
new Date(2011,11,10),
27589
],
[
new Date(2011,11,11),
18136
],
[
new Date(2011,11,12),
37559
],
[
new Date(2011,11,13),
39121
],
[
new Date(2011,11,14),
40541
],
[
new Date(2011,11,15),
41059
],
[
new Date(2011,11,16),
42522
],
[
new Date(2011,11,17),
26336
],
[
new Date(2011,11,18),
19860
],
[
new Date(2011,11,19),
39506
],
[
new Date(2011,11,20),
41402
],
[
new Date(2011,11,21),
42017
],
[
new Date(2011,11,22),
43145
],
[
new Date(2011,11,23),
44343
],
[
new Date(2011,11,24),
31288
],
[
new Date(2011,11,25),
24137
],
[
new Date(2011,11,26),
37975
],
[
new Date(2011,11,27),
40930
],
[
new Date(2011,11,28),
43570
],
[
new Date(2011,11,29),
42315
],
[
new Date(2011,11,30),
39985
],
[
new Date(2011,11,31),
28041
],
[
new Date(2012,0,1),
15013
],
[
new Date(2012,0,2),
36991
],
[
new Date(2012,0,3),
39645
],
[
new Date(2012,0,4),
39117
],
[
new Date(2012,0,5),
39804
],
[
new Date(2012,0,6),
40273
],
[
new Date(2012,0,7),
24615
],
[
new Date(2012,0,8),
17606
],
[
new Date(2012,0,9),
36809
],
[
new Date(2012,0,10),
40155
],
[
new Date(2012,0,11),
40222
],
[
new Date(2012,0,12),
38315
],
[
new Date(2012,0,13),
39322
],
[
new Date(2012,0,14),
24265
],
[
new Date(2012,0,15),
18115
],
[
new Date(2012,0,16),
36970
],
[
new Date(2012,0,17),
38444
],
[
new Date(2012,0,18),
38936
],
[
new Date(2012,0,19),
39936
],
[
new Date(2012,0,20),
37158
],
[
new Date(2012,0,21),
16231
],
[
new Date(2012,0,22),
10456
],
[
new Date(2012,0,23),
6161
],
[
new Date(2012,0,24),
13269
],
[
new Date(2012,0,25),
34362
],
[
new Date(2012,0,26),
39464
],
[
new Date(2012,0,27),
39894
],
[
new Date(2012,0,28),
24932
],
[
new Date(2012,0,29),
17878
],
[
new Date(2012,0,30),
37563
],
[
new Date(2012,0,31),
45653
],
[
new Date(2012,1,1),
40474
],
[
new Date(2012,1,2),
37425
],
[
new Date(2012,1,3),
37644
],
[
new Date(2012,1,4),
23492
],
[
new Date(2012,1,5),
16833
],
[
new Date(2012,1,6),
37772
],
[
new Date(2012,1,7),
38651
],
[
new Date(2012,1,8),
37688
],
[
new Date(2012,1,9),
38038
],
[
new Date(2012,1,10),
38773
],
[
new Date(2012,1,11),
25400
],
[
new Date(2012,1,12),
18112
],
[
new Date(2012,1,13),
37381
],
[
new Date(2012,1,14),
40670
],
[
new Date(2012,1,15),
39748
],
[
new Date(2012,1,16),
40091
],
[
new Date(2012,1,17),
40144
],
[
new Date(2012,1,18),
25063
],
[
new Date(2012,1,19),
18527
],
[
new Date(2012,1,20),
37773
],
[
new Date(2012,1,21),
39829
],
[
new Date(2012,1,22),
41479
],
[
new Date(2012,1,23),
39502
],
[
new Date(2012,1,24),
40293
],
[
new Date(2012,1,25),
27045
],
[
new Date(2012,1,26),
18611
],
[
new Date(2012,1,27),
39483
],
[
new Date(2012,1,28),
40938
],
[
new Date(2012,1,29),
40078
],
[
new Date(2012,2,1),
24975
],
[
new Date(2012,2,2),
35285
],
[
new Date(2012,2,3),
26067
],
[
new Date(2012,2,4),
18216
],
[
new Date(2012,2,5),
39966
],
[
new Date(2012,2,6),
39098
],
[
new Date(2012,2,7),
39951
],
[
new Date(2012,2,8),
39562
],
[
new Date(2012,2,9),
39219
],
[
new Date(2012,2,10),
27443
],
[
new Date(2012,2,11),
20255
],
[
new Date(2012,2,12),
38898
],
[
new Date(2012,2,13),
39480
],
[
new Date(2012,2,14),
39745
],
[
new Date(2012,2,15),
38868
],
[
new Date(2012,2,16),
40322
],
[
new Date(2012,2,17),
26840
],
[
new Date(2012,2,18),
21044
],
[
new Date(2012,2,19),
37909
],
[
new Date(2012,2,20),
39544
],
[
new Date(2012,2,21),
38799
],
[
new Date(2012,2,22),
38755
],
[
new Date(2012,2,23),
39387
],
[
new Date(2012,2,24),
25953
],
[
new Date(2012,2,25),
19201
],
[
new Date(2012,2,26),
38841
],
[
new Date(2012,2,27),
38619
],
[
new Date(2012,2,28),
39658
],
[
new Date(2012,2,29),
38868
],
[
new Date(2012,2,30),
38013
],
[
new Date(2012,2,31),
24712
],
[
new Date(2012,3,1),
17339
],
[
new Date(2012,3,2),
37579
],
[
new Date(2012,3,3),
36626
],
[
new Date(2012,3,4),
38711
],
[
new Date(2012,3,5),
39427
],
[
new Date(2012,3,6),
39690
],
[
new Date(2012,3,7),
25613
],
[
new Date(2012,3,8),
18542
],
[
new Date(2012,3,9),
37199
],
[
new Date(2012,3,10),
38867
],
[
new Date(2012,3,11),
20587
],
[
new Date(2012,3,12),
38137
],
[
new Date(2012,3,13),
38344
],
[
new Date(2012,3,14),
25416
],
[
new Date(2012,3,15),
19507
],
[
new Date(2012,3,16),
37189
],
[
new Date(2012,3,17),
38226
],
[
new Date(2012,3,18),
38656
],
[
new Date(2012,3,19),
38821
],
[
new Date(2012,3,20),
39232
],
[
new Date(2012,3,21),
21209
],
[
new Date(2012,3,22),
13618
],
[
new Date(2012,3,23),
36359
],
[
new Date(2012,3,24),
37922
],
[
new Date(2012,3,25),
37228
],
[
new Date(2012,3,26),
38844
],
[
new Date(2012,3,27),
38673
],
[
new Date(2012,3,28),
25377
],
[
new Date(2012,3,29),
17409
],
[
new Date(2012,3,30),
35100
],
[
new Date(2012,4,1),
25798
],
[
new Date(2012,4,2),
39606
],
[
new Date(2012,4,3),
39912
],
[
new Date(2012,4,4),
41138
],
[
new Date(2012,4,5),
25507
],
[
new Date(2012,4,6),
18504
],
[
new Date(2012,4,7),
37871
],
[
new Date(2012,4,8),
38353
],
[
new Date(2012,4,9),
39281
],
[
new Date(2012,4,10),
38498
],
[
new Date(2012,4,11),
39885
],
[
new Date(2012,4,12),
28039
],
[
new Date(2012,4,13),
20697
],
[
new Date(2012,4,14),
36591
],
[
new Date(2012,4,15),
39284
],
[
new Date(2012,4,16),
38768
],
[
new Date(2012,4,17),
38800
],
[
new Date(2012,4,18),
41223
],
[
new Date(2012,4,19),
37264
],
[
new Date(2012,4,20),
24213
],
[
new Date(2012,4,21),
37712
],
[
new Date(2012,4,22),
38802
],
[
new Date(2012,4,23),
38810
],
[
new Date(2012,4,24),
39157
],
[
new Date(2012,4,25),
39844
],
[
new Date(2012,4,26),
26734
],
[
new Date(2012,4,27),
21790
],
[
new Date(2012,4,28),
22064
],
[
new Date(2012,4,29),
36672
],
[
new Date(2012,4,30),
37245
],
[
new Date(2012,4,31),
37482
],
[
new Date(2012,5,1),
37439
],
[
new Date(2012,5,2),
26205
],
[
new Date(2012,5,3),
17740
],
[
new Date(2012,5,4),
36582
],
[
new Date(2012,5,5),
37610
],
[
new Date(2012,5,6),
20648
],
[
new Date(2012,5,7),
36918
],
[
new Date(2012,5,8),
38231
],
[
new Date(2012,5,9),
25269
],
[
new Date(2012,5,10),
16518
],
[
new Date(2012,5,11),
36947
],
[
new Date(2012,5,12),
37517
],
[
new Date(2012,5,13),
37583
],
[
new Date(2012,5,14),
37295
],
[
new Date(2012,5,15),
37694
],
[
new Date(2012,5,16),
24980
],
[
new Date(2012,5,17),
16855
],
[
new Date(2012,5,18),
36522
],
[
new Date(2012,5,19),
36881
],
[
new Date(2012,5,20),
44369
],
[
new Date(2012,5,21),
37949
],
[
new Date(2012,5,22),
38001
],
[
new Date(2012,5,23),
24133
],
[
new Date(2012,5,24),
17282
],
[
new Date(2012,5,25),
36939
],
[
new Date(2012,5,26),
38298
],
[
new Date(2012,5,27),
38239
],
[
new Date(2012,5,28),
38505
],
[
new Date(2012,5,29),
38216
],
[
new Date(2012,5,30),
19446
],
[
new Date(2012,6,1),
16193
],
[
new Date(2012,6,2),
37327
],
[
new Date(2012,6,3),
38793
],
[
new Date(2012,6,4),
37372
],
[
new Date(2012,6,5),
38694
],
[
new Date(2012,6,6),
36928
],
[
new Date(2012,6,7),
24623
],
[
new Date(2012,6,8),
17479
],
[
new Date(2012,6,9),
38017
],
[
new Date(2012,6,10),
39822
],
[
new Date(2012,6,11),
37955
],
[
new Date(2012,6,12),
39730
],
[
new Date(2012,6,13),
39017
],
[
new Date(2012,6,14),
24081
],
[
new Date(2012,6,15),
16348
],
[
new Date(2012,6,16),
37047
],
[
new Date(2012,6,17),
39297
],
[
new Date(2012,6,18),
39300
],
[
new Date(2012,6,19),
36705
],
[
new Date(2012,6,20),
39814
],
[
new Date(2012,6,21),
24939
],
[
new Date(2012,6,22),
17574
],
[
new Date(2012,6,23),
36647
],
[
new Date(2012,6,24),
39768
],
[
new Date(2012,6,25),
39614
],
[
new Date(2012,6,26),
40491
],
[
new Date(2012,6,27),
38856
],
[
new Date(2012,6,28),
22196
],
[
new Date(2012,6,29),
16952
],
[
new Date(2012,6,30),
35533
],
[
new Date(2012,6,31),
36757
],
[
new Date(2012,7,1),
38154
],
[
new Date(2012,7,2),
36290
],
[
new Date(2012,7,3),
35523
],
[
new Date(2012,7,4),
20955
],
[
new Date(2012,7,5),
14114
],
[
new Date(2012,7,6),
33926
],
[
new Date(2012,7,7),
35658
],
[
new Date(2012,7,8),
35949
],
[
new Date(2012,7,9),
36770
],
[
new Date(2012,7,10),
36424
],
[
new Date(2012,7,11),
22723
],
[
new Date(2012,7,12),
16013
],
[
new Date(2012,7,13),
36369
],
[
new Date(2012,7,14),
39035
],
[
new Date(2012,7,15),
17937
],
[
new Date(2012,7,16),
37908
],
[
new Date(2012,7,17),
38224
],
[
new Date(2012,7,18),
22982
],
[
new Date(2012,7,19),
16528
],
[
new Date(2012,7,20),
34975
],
[
new Date(2012,7,21),
34456
],
[
new Date(2012,7,22),
36181
],
[
new Date(2012,7,23),
36758
],
[
new Date(2012,7,24),
38077
],
[
new Date(2012,7,25),
23304
],
[
new Date(2012,7,26),
17950
],
[
new Date(2012,7,27),
35844
],
[
new Date(2012,7,28),
27686
],
[
new Date(2012,7,29),
37522
],
[
new Date(2012,7,30),
35638
],
[
new Date(2012,7,31),
41121
],
[
new Date(2012,8,1),
26596
],
[
new Date(2012,8,2),
18626
],
[
new Date(2012,8,3),
36233
],
[
new Date(2012,8,4),
39109
],
[
new Date(2012,8,5),
38115
],
[
new Date(2012,8,6),
40196
],
[
new Date(2012,8,7),
41058
],
[
new Date(2012,8,8),
24615
],
[
new Date(2012,8,9),
17711
],
[
new Date(2012,8,10),
36345
],
[
new Date(2012,8,11),
38135
],
[
new Date(2012,8,12),
37401
],
[
new Date(2012,8,13),
36984
],
[
new Date(2012,8,14),
39142
],
[
new Date(2012,8,15),
24776
],
[
new Date(2012,8,16),
16737
],
[
new Date(2012,8,17),
33823
],
[
new Date(2012,8,18),
37344
],
[
new Date(2012,8,19),
38104
],
[
new Date(2012,8,20),
37934
],
[
new Date(2012,8,21),
38029
],
[
new Date(2012,8,22),
25544
],
[
new Date(2012,8,23),
19476
],
[
new Date(2012,8,24),
36057
],
[
new Date(2012,8,25),
37658
],
[
new Date(2012,8,26),
37590
],
[
new Date(2012,8,27),
37476
],
[
new Date(2012,8,28),
35515
],
[
new Date(2012,8,29),
11433
],
[
new Date(2012,8,30),
14106
],
[
new Date(2012,9,1),
20398
],
[
new Date(2012,9,2),
30744
],
[
new Date(2012,9,3),
25743
],
[
new Date(2012,9,4),
50782
],
[
new Date(2012,9,5),
41782
],
[
new Date(2012,9,6),
35777
],
[
new Date(2012,9,7),
25143
],
[
new Date(2012,9,8),
37182
],
[
new Date(2012,9,9),
38534
],
[
new Date(2012,9,10),
37275
],
[
new Date(2012,9,11),
38479
],
[
new Date(2012,9,12),
38687
],
[
new Date(2012,9,13),
25017
],
[
new Date(2012,9,14),
18990
],
[
new Date(2012,9,15),
37128
],
[
new Date(2012,9,16),
37634
],
[
new Date(2012,9,17),
37675
],
[
new Date(2012,9,18),
38271
],
[
new Date(2012,9,19),
40652
],
[
new Date(2012,9,20),
27307
],
[
new Date(2012,9,21),
19055
],
[
new Date(2012,9,22),
35049
],
[
new Date(2012,9,23),
37187
],
[
new Date(2012,9,24),
37542
],
[
new Date(2012,9,25),
38296
],
[
new Date(2012,9,26),
39271
],
[
new Date(2012,9,27),
22953
],
[
new Date(2012,9,28),
23850
],
[
new Date(2012,9,29),
38249
],
[
new Date(2012,9,30),
39586
],
[
new Date(2012,9,31),
39379
],
[
new Date(2012,10,1),
38408
],
[
new Date(2012,10,2),
41830
],
[
new Date(2012,10,3),
38026
],
[
new Date(2012,10,4),
19718
],
[
new Date(2012,10,5),
37536
],
[
new Date(2012,10,6),
38927
],
[
new Date(2012,10,7),
42225
],
[
new Date(2012,10,8),
41832
],
[
new Date(2012,10,9),
42955
],
[
new Date(2012,10,10),
35501
],
[
new Date(2012,10,11),
19509
],
[
new Date(2012,10,12),
39552
],
[
new Date(2012,10,13),
41115
],
[
new Date(2012,10,14),
40948
],
[
new Date(2012,10,15),
41887
],
[
new Date(2012,10,16),
43003
],
[
new Date(2012,10,17),
31936
],
[
new Date(2012,10,18),
24806
],
[
new Date(2012,10,19),
37726
],
[
new Date(2012,10,20),
40008
],
[
new Date(2012,10,21),
41315
],
[
new Date(2012,10,22),
39773
],
[
new Date(2012,10,23),
41635
],
[
new Date(2012,10,24),
25297
],
[
new Date(2012,10,25),
18429
],
[
new Date(2012,10,26),
39549
],
[
new Date(2012,10,27),
42068
],
[
new Date(2012,10,28),
38557
],
[
new Date(2012,10,29),
39663
],
[
new Date(2012,10,30),
41623
],
[
new Date(2012,11,1),
24420
],
[
new Date(2012,11,2),
17057
],
[
new Date(2012,11,3),
40901
],
[
new Date(2012,11,4),
40354
],
[
new Date(2012,11,5),
47624
],
[
new Date(2012,11,6),
43117
],
[
new Date(2012,11,7),
47687
],
[
new Date(2012,11,8),
42821
],
[
new Date(2012,11,9),
17034
],
[
new Date(2012,11,10),
40378
],
[
new Date(2012,11,11),
39909
],
[
new Date(2012,11,12),
42054
],
[
new Date(2012,11,13),
41998
],
[
new Date(2012,11,14),
41348
],
[
new Date(2012,11,15),
38240
],
[
new Date(2012,11,16),
18589
],
[
new Date(2012,11,17),
41035
],
[
new Date(2012,11,18),
54994
],
[
new Date(2012,11,19),
23306
],
[
new Date(2012,11,20),
43063
],
[
new Date(2012,11,21),
45218
],
[
new Date(2012,11,22),
27157
],
[
new Date(2012,11,23),
19582
],
[
new Date(2012,11,24),
43882
],
[
new Date(2012,11,25),
25071
],
[
new Date(2012,11,26),
40956
],
[
new Date(2012,11,27),
43035
],
[
new Date(2012,11,28),
42253
],
[
new Date(2012,11,29),
26407
],
[
new Date(2012,11,30),
21115
],
[
new Date(2012,11,31),
42258
],
[
new Date(2013,0,1),
15657
],
[
new Date(2013,0,2),
40881
],
[
new Date(2013,0,3),
39125
],
[
new Date(2013,0,4),
40265
],
[
new Date(2013,0,5),
22513
],
[
new Date(2013,0,6),
17477
],
[
new Date(2013,0,7),
38897
],
[
new Date(2013,0,8),
41340
],
[
new Date(2013,0,9),
40699
],
[
new Date(2013,0,10),
41887
],
[
new Date(2013,0,11),
40990
],
[
new Date(2013,0,12),
25582
],
[
new Date(2013,0,13),
18684
],
[
new Date(2013,0,14),
38258
],
[
new Date(2013,0,15),
39820
],
[
new Date(2013,0,16),
40504
],
[
new Date(2013,0,17),
40948
],
[
new Date(2013,0,18),
40736
],
[
new Date(2013,0,19),
26234
],
[
new Date(2013,0,20),
18039
],
[
new Date(2013,0,21),
36470
],
[
new Date(2013,0,22),
39755
],
[
new Date(2013,0,23),
40329
],
[
new Date(2013,0,24),
40819
],
[
new Date(2013,0,25),
38538
],
[
new Date(2013,0,26),
22861
],
[
new Date(2013,0,27),
16613
],
[
new Date(2013,0,28),
37423
],
[
new Date(2013,0,29),
38466
],
[
new Date(2013,0,30),
38495
],
[
new Date(2013,0,31),
38592
],
[
new Date(2013,1,1),
36049
],
[
new Date(2013,1,2),
24206
],
[
new Date(2013,1,3),
17046
],
[
new Date(2013,1,4),
39443
],
[
new Date(2013,1,5),
40282
],
[
new Date(2013,1,6),
39185
],
[
new Date(2013,1,7),
38363
],
[
new Date(2013,1,8),
32285
],
[
new Date(2013,1,9),
9072
],
[
new Date(2013,1,10),
8604
],
[
new Date(2013,1,11),
13250
],
[
new Date(2013,1,12),
32944
],
[
new Date(2013,1,13),
38715
],
[
new Date(2013,1,14),
40727
],
[
new Date(2013,1,15),
40567
],
[
new Date(2013,1,16),
27201
],
[
new Date(2013,1,17),
18084
],
[
new Date(2013,1,18),
38832
],
[
new Date(2013,1,19),
40857
],
[
new Date(2013,1,20),
41414
],
[
new Date(2013,1,21),
41078
],
[
new Date(2013,1,22),
40445
],
[
new Date(2013,1,23),
27145
],
[
new Date(2013,1,24),
20850
],
[
new Date(2013,1,25),
41984
],
[
new Date(2013,1,26),
40714
],
[
new Date(2013,1,27),
41485
],
[
new Date(2013,1,28),
40788
],
[
new Date(2013,2,1),
26331
],
[
new Date(2013,2,2),
23744
],
[
new Date(2013,2,3),
17008
],
[
new Date(2013,2,4),
37790
],
[
new Date(2013,2,5),
39559
],
[
new Date(2013,2,6),
38930
],
[
new Date(2013,2,7),
38638
],
[
new Date(2013,2,8),
40753
],
[
new Date(2013,2,9),
31021
],
[
new Date(2013,2,10),
21848
],
[
new Date(2013,2,11),
38326
],
[
new Date(2013,2,12),
39362
],
[
new Date(2013,2,13),
40233
],
[
new Date(2013,2,14),
41140
],
[
new Date(2013,2,15),
39210
],
[
new Date(2013,2,16),
29967
],
[
new Date(2013,2,17),
25304
],
[
new Date(2013,2,18),
37433
],
[
new Date(2013,2,19),
39453
],
[
new Date(2013,2,20),
39366
],
[
new Date(2013,2,21),
38695
],
[
new Date(2013,2,22),
39922
],
[
new Date(2013,2,23),
27714
],
[
new Date(2013,2,24),
22659
],
[
new Date(2013,2,25),
37858
],
[
new Date(2013,2,26),
39331
],
[
new Date(2013,2,27),
39133
],
[
new Date(2013,2,28),
38511
],
[
new Date(2013,2,29),
39221
],
[
new Date(2013,2,30),
26213
],
[
new Date(2013,2,31),
21631
],
[
new Date(2013,3,1),
36627
],
[
new Date(2013,3,2),
37762
],
[
new Date(2013,3,3),
39477
],
[
new Date(2013,3,4),
38926
],
[
new Date(2013,3,5),
39963
],
[
new Date(2013,3,6),
21594
],
[
new Date(2013,3,7),
19575
],
[
new Date(2013,3,8),
37064
],
[
new Date(2013,3,9),
37870
],
[
new Date(2013,3,10),
38258
],
[
new Date(2013,3,11),
38055
],
[
new Date(2013,3,12),
38930
],
[
new Date(2013,3,13),
29170
],
[
new Date(2013,3,14),
18784
],
[
new Date(2013,3,15),
35971
],
[
new Date(2013,3,16),
38456
],
[
new Date(2013,3,17),
39065
],
[
new Date(2013,3,18),
38573
],
[
new Date(2013,3,19),
38984
],
[
new Date(2013,3,20),
22070
],
[
new Date(2013,3,21),
21944
],
[
new Date(2013,3,22),
36852
],
[
new Date(2013,3,23),
37538
],
[
new Date(2013,3,24),
37782
],
[
new Date(2013,3,25),
37362
],
[
new Date(2013,3,26),
38444
],
[
new Date(2013,3,27),
26685
],
[
new Date(2013,3,28),
19410
],
[
new Date(2013,3,29),
35702
],
[
new Date(2013,3,30),
38804
],
[
new Date(2013,4,1),
28123
],
[
new Date(2013,4,2),
38865
],
[
new Date(2013,4,3),
41481
],
[
new Date(2013,4,4),
30912
],
[
new Date(2013,4,5),
23842
],
[
new Date(2013,4,6),
36844
],
[
new Date(2013,4,7),
38241
],
[
new Date(2013,4,8),
39738
],
[
new Date(2013,4,9),
39244
],
[
new Date(2013,4,10),
38594
],
[
new Date(2013,4,11),
34206
],
[
new Date(2013,4,12),
23505
],
[
new Date(2013,4,13),
37287
],
[
new Date(2013,4,14),
38635
],
[
new Date(2013,4,15),
40332
],
[
new Date(2013,4,16),
39411
],
[
new Date(2013,4,17),
29142
],
[
new Date(2013,4,18),
26031
],
[
new Date(2013,4,19),
17869
],
[
new Date(2013,4,20),
37083
],
[
new Date(2013,4,21),
38689
],
[
new Date(2013,4,22),
41089
],
[
new Date(2013,4,23),
44667
],
[
new Date(2013,4,24),
44978
],
[
new Date(2013,4,25),
35448
],
[
new Date(2013,4,26),
23238
],
[
new Date(2013,4,27),
36025
],
[
new Date(2013,4,28),
37961
],
[
new Date(2013,4,29),
37871
],
[
new Date(2013,4,30),
38651
],
[
new Date(2013,4,31),
38601
],
[
new Date(2013,5,1),
27567
],
[
new Date(2013,5,2),
19622
],
[
new Date(2013,5,3),
36417
],
[
new Date(2013,5,4),
38367
],
[
new Date(2013,5,5),
38367
],
[
new Date(2013,5,6),
22111
],
[
new Date(2013,5,7),
36212
],
[
new Date(2013,5,8),
25344
],
[
new Date(2013,5,9),
18547
],
[
new Date(2013,5,10),
36105
],
[
new Date(2013,5,11),
39363
],
[
new Date(2013,5,12),
37372
],
[
new Date(2013,5,13),
37431
],
[
new Date(2013,5,14),
38449
],
[
new Date(2013,5,15),
24864
],
[
new Date(2013,5,16),
18801
],
[
new Date(2013,5,17),
36365
],
[
new Date(2013,5,18),
36085
],
[
new Date(2013,5,19),
39001
],
[
new Date(2013,5,20),
38108
],
[
new Date(2013,5,21),
38576
],
[
new Date(2013,5,22),
25375
],
[
new Date(2013,5,23),
18028
],
[
new Date(2013,5,24),
37223
],
[
new Date(2013,5,25),
38143
],
[
new Date(2013,5,26),
37923
],
[
new Date(2013,5,27),
40204
],
[
new Date(2013,5,28),
39832
],
[
new Date(2013,5,29),
23671
],
[
new Date(2013,5,30),
16090
],
[
new Date(2013,6,1),
37031
],
[
new Date(2013,6,2),
36042
],
[
new Date(2013,6,3),
37793
],
[
new Date(2013,6,4),
37406
],
[
new Date(2013,6,5),
37611
],
[
new Date(2013,6,6),
24014
],
[
new Date(2013,6,7),
16154
],
[
new Date(2013,6,8),
36282
],
[
new Date(2013,6,9),
37826
],
[
new Date(2013,6,10),
37636
],
[
new Date(2013,6,11),
37075
],
[
new Date(2013,6,12),
39487
],
[
new Date(2013,6,13),
21855
],
[
new Date(2013,6,14),
15847
],
[
new Date(2013,6,15),
36384
],
[
new Date(2013,6,16),
38707
],
[
new Date(2013,6,17),
37932
],
[
new Date(2013,6,18),
37461
],
[
new Date(2013,6,19),
39228
],
[
new Date(2013,6,20),
24619
],
[
new Date(2013,6,21),
16564
],
[
new Date(2013,6,22),
35445
],
[
new Date(2013,6,23),
36120
],
[
new Date(2013,6,24),
38931
],
[
new Date(2013,6,25),
40133
],
[
new Date(2013,6,26),
38879
],
[
new Date(2013,6,27),
26383
],
[
new Date(2013,6,28),
15455
],
[
new Date(2013,6,29),
37537
],
[
new Date(2013,6,30),
39580
],
[
new Date(2013,6,31),
39788
],
[
new Date(2013,7,1),
39368
],
[
new Date(2013,7,2),
37741
],
[
new Date(2013,7,3),
24730
],
[
new Date(2013,7,4),
16890
],
[
new Date(2013,7,5),
34944
],
[
new Date(2013,7,6),
36672
],
[
new Date(2013,7,7),
39239
],
[
new Date(2013,7,8),
38410
],
[
new Date(2013,7,9),
38112
],
[
new Date(2013,7,10),
23904
],
[
new Date(2013,7,11),
18667
],
[
new Date(2013,7,12),
36988
],
[
new Date(2013,7,13),
39028
],
[
new Date(2013,7,14),
39209
],
[
new Date(2013,7,15),
27119
],
[
new Date(2013,7,16),
35518
],
[
new Date(2013,7,17),
24835
],
[
new Date(2013,7,18),
17329
],
[
new Date(2013,7,19),
35696
],
[
new Date(2013,7,20),
37679
],
[
new Date(2013,7,21),
38483
],
[
new Date(2013,7,22),
37324
],
[
new Date(2013,7,23),
38660
],
[
new Date(2013,7,24),
26490
],
[
new Date(2013,7,25),
18577
],
[
new Date(2013,7,26),
37376
],
[
new Date(2013,7,27),
38158
],
[
new Date(2013,7,28),
39400
],
[
new Date(2013,7,29),
35187
],
[
new Date(2013,7,30),
39334
],
[
new Date(2013,7,31),
26232
],
[
new Date(2013,8,1),
18643
],
[
new Date(2013,8,2),
36592
],
[
new Date(2013,8,3),
38162
],
[
new Date(2013,8,4),
38177
],
[
new Date(2013,8,5),
38858
],
[
new Date(2013,8,6),
40354
],
[
new Date(2013,8,7),
30081
],
[
new Date(2013,8,8),
20990
],
[
new Date(2013,8,9),
36987
],
[
new Date(2013,8,10),
40390
],
[
new Date(2013,8,11),
38163
],
[
new Date(2013,8,12),
40174
],
[
new Date(2013,8,13),
39191
],
[
new Date(2013,8,14),
24398
],
[
new Date(2013,8,15),
19658
],
[
new Date(2013,8,16),
35837
],
[
new Date(2013,8,17),
34350
],
[
new Date(2013,8,18),
11411
],
[
new Date(2013,8,19),
12395
],
[
new Date(2013,8,20),
17636
],
[
new Date(2013,8,21),
20973
],
[
new Date(2013,8,22),
15659
],
[
new Date(2013,8,23),
35082
],
[
new Date(2013,8,24),
36688
],
[
new Date(2013,8,25),
39384
],
[
new Date(2013,8,26),
39798
],
[
new Date(2013,8,27),
40841
],
[
new Date(2013,8,28),
29465
],
[
new Date(2013,8,29),
18484
],
[
new Date(2013,8,30),
37596
],
[
new Date(2013,9,1),
47378
],
[
new Date(2013,9,2),
39319
],
[
new Date(2013,9,3),
28362
],
[
new Date(2013,9,4),
40021
],
[
new Date(2013,9,5),
31243
],
[
new Date(2013,9,6),
23556
],
[
new Date(2013,9,7),
37065
],
[
new Date(2013,9,8),
39702
],
[
new Date(2013,9,9),
34752
],
[
new Date(2013,9,10),
39644
],
[
new Date(2013,9,11),
39655
],
[
new Date(2013,9,12),
28525
],
[
new Date(2013,9,13),
23260
],
[
new Date(2013,9,14),
37498
],
[
new Date(2013,9,15),
37754
],
[
new Date(2013,9,16),
39738
],
[
new Date(2013,9,17),
40022
],
[
new Date(2013,9,18),
41574
],
[
new Date(2013,9,19),
28847
],
[
new Date(2013,9,20),
26106
],
[
new Date(2013,9,21),
38591
],
[
new Date(2013,9,22),
37942
],
[
new Date(2013,9,23),
40982
],
[
new Date(2013,9,24),
40778
],
[
new Date(2013,9,25),
41489
],
[
new Date(2013,9,26),
31103
],
[
new Date(2013,9,27),
23243
],
[
new Date(2013,9,28),
39312
],
[
new Date(2013,9,29),
38759
],
[
new Date(2013,9,30),
39798
],
[
new Date(2013,9,31),
39827
],
[
new Date(2013,10,1),
42587
],
[
new Date(2013,10,2),
30387
],
[
new Date(2013,10,3),
26240
],
[
new Date(2013,10,4),
40274
],
[
new Date(2013,10,5),
41713
],
[
new Date(2013,10,6),
41751
],
[
new Date(2013,10,7),
42902
],
[
new Date(2013,10,8),
43975
],
[
new Date(2013,10,9),
32426
],
[
new Date(2013,10,10),
27402
],
[
new Date(2013,10,11),
41692
],
[
new Date(2013,10,12),
40694
],
[
new Date(2013,10,13),
42081
],
[
new Date(2013,10,14),
42832
],
[
new Date(2013,10,15),
43312
],
[
new Date(2013,10,16),
36089
],
[
new Date(2013,10,17),
26304
],
[
new Date(2013,10,18),
38304
],
[
new Date(2013,10,19),
39910
],
[
new Date(2013,10,20),
41702
],
[
new Date(2013,10,21),
43156
],
[
new Date(2013,10,22),
43745
],
[
new Date(2013,10,23),
28380
],
[
new Date(2013,10,24),
20072
],
[
new Date(2013,10,25),
38343
],
[
new Date(2013,10,26),
41940
],
[
new Date(2013,10,27),
41418
],
[
new Date(2013,10,28),
40335
],
[
new Date(2013,10,29),
41341
],
[
new Date(2013,10,30),
26909
],
[
new Date(2013,11,1),
18887
],
[
new Date(2013,11,2),
38439
],
[
new Date(2013,11,3),
42181
],
[
new Date(2013,11,4),
42153
],
[
new Date(2013,11,5),
42896
],
[
new Date(2013,11,6),
42244
],
[
new Date(2013,11,7),
28585
],
[
new Date(2013,11,8),
17510
],
[
new Date(2013,11,9),
38273
],
[
new Date(2013,11,10),
42987
],
[
new Date(2013,11,11),
42044
],
[
new Date(2013,11,12),
45971
],
[
new Date(2013,11,13),
43720
],
[
new Date(2013,11,14),
27060
],
[
new Date(2013,11,15),
18098
],
[
new Date(2013,11,16),
41044
],
[
new Date(2013,11,17),
43437
],
[
new Date(2013,11,18),
45101
],
[
new Date(2013,11,19),
45829
],
[
new Date(2013,11,20),
46735
],
[
new Date(2013,11,21),
30087
],
[
new Date(2013,11,22),
23322
],
[
new Date(2013,11,23),
43831
],
[
new Date(2013,11,24),
50154
],
[
new Date(2013,11,25),
29417
],
[
new Date(2013,11,26),
44245
],
[
new Date(2013,11,27),
43734
],
[
new Date(2013,11,28),
33935
],
[
new Date(2013,11,29),
19861
],
[
new Date(2013,11,30),
42408
],
[
new Date(2013,11,31),
46727
],
[
new Date(2014,0,1),
16863
],
[
new Date(2014,0,2),
42016
],
[
new Date(2014,0,3),
43569
],
[
new Date(2014,0,4),
26464
],
[
new Date(2014,0,5),
21186
],
[
new Date(2014,0,6),
40724
],
[
new Date(2014,0,7),
42177
],
[
new Date(2014,0,8),
42884
],
[
new Date(2014,0,9),
41212
],
[
new Date(2014,0,10),
41974
],
[
new Date(2014,0,11),
26217
],
[
new Date(2014,0,12),
19230
],
[
new Date(2014,0,13),
39092
],
[
new Date(2014,0,14),
40980
],
[
new Date(2014,0,15),
41863
],
[
new Date(2014,0,16),
42013
],
[
new Date(2014,0,17),
42005
],
[
new Date(2014,0,18),
27864
],
[
new Date(2014,0,19),
20546
],
[
new Date(2014,0,20),
41401
],
[
new Date(2014,0,21),
41822
],
[
new Date(2014,0,22),
42889
],
[
new Date(2014,0,23),
41994
],
[
new Date(2014,0,24),
41536
],
[
new Date(2014,0,25),
23725
],
[
new Date(2014,0,26),
20160
],
[
new Date(2014,0,27),
39534
],
[
new Date(2014,0,28),
41226
],
[
new Date(2014,0,29),
36105
],
[
new Date(2014,0,30),
9082
],
[
new Date(2014,0,31),
9688
],
[
new Date(2014,1,1),
13519
],
[
new Date(2014,1,2),
14726
],
[
new Date(2014,1,3),
37201
],
[
new Date(2014,1,4),
39687
],
[
new Date(2014,1,5),
39511
],
[
new Date(2014,1,6),
40107
],
[
new Date(2014,1,7),
40929
],
[
new Date(2014,1,8),
29360
],
[
new Date(2014,1,9),
20615
],
[
new Date(2014,1,10),
40319
],
[
new Date(2014,1,11),
41593
],
[
new Date(2014,1,12),
41823
],
[
new Date(2014,1,13),
41391
],
[
new Date(2014,1,14),
41401
],
[
new Date(2014,1,15),
29258
],
[
new Date(2014,1,16),
20537
],
[
new Date(2014,1,17),
39726
],
[
new Date(2014,1,18),
41041
],
[
new Date(2014,1,19),
41514
],
[
new Date(2014,1,20),
42216
],
[
new Date(2014,1,21),
42232
],
[
new Date(2014,1,22),
29990
],
[
new Date(2014,1,23),
21211
],
[
new Date(2014,1,24),
39498
],
[
new Date(2014,1,25),
45796
],
[
new Date(2014,1,26),
43581
],
[
new Date(2014,1,27),
42223
],
[
new Date(2014,1,28),
41643
],
[
new Date(2014,2,1),
29990
],
[
new Date(2014,2,2),
19755
],
[
new Date(2014,2,3),
40048
],
[
new Date(2014,2,4),
41449
],
[
new Date(2014,2,5),
41635
],
[
new Date(2014,2,6),
40527
],
[
new Date(2014,2,7),
41655
],
[
new Date(2014,2,8),
29863
],
[
new Date(2014,2,9),
21398
],
[
new Date(2014,2,10),
40943
],
[
new Date(2014,2,11),
41188
],
[
new Date(2014,2,12),
41567
],
[
new Date(2014,2,13),
40548
],
[
new Date(2014,2,14),
43853
],
[
new Date(2014,2,15),
30800
],
[
new Date(2014,2,16),
23960
],
[
new Date(2014,2,17),
39988
],
[
new Date(2014,2,18),
41422
],
[
new Date(2014,2,19),
41803
],
[
new Date(2014,2,20),
41328
],
[
new Date(2014,2,21),
43028
],
[
new Date(2014,2,22),
31513
],
[
new Date(2014,2,23),
24205
],
[
new Date(2014,2,24),
39673
],
[
new Date(2014,2,25),
41291
],
[
new Date(2014,2,26),
43415
],
[
new Date(2014,2,27),
41684
],
[
new Date(2014,2,28),
42757
],
[
new Date(2014,2,29),
28681
],
[
new Date(2014,2,30),
23812
],
[
new Date(2014,2,31),
38927
],
[
new Date(2014,3,1),
41549
],
[
new Date(2014,3,2),
42999
],
[
new Date(2014,3,3),
40495
],
[
new Date(2014,3,4),
42717
],
[
new Date(2014,3,5),
27345
],
[
new Date(2014,3,6),
24263
],
[
new Date(2014,3,7),
39762
],
[
new Date(2014,3,8),
40830
],
[
new Date(2014,3,9),
41151
],
[
new Date(2014,3,10),
41552
],
[
new Date(2014,3,11),
42886
],
[
new Date(2014,3,12),
27190
],
[
new Date(2014,3,13),
21043
],
[
new Date(2014,3,14),
39446
],
[
new Date(2014,3,15),
41196
],
[
new Date(2014,3,16),
41716
],
[
new Date(2014,3,17),
40715
],
[
new Date(2014,3,18),
42242
],
[
new Date(2014,3,19),
26756
],
[
new Date(2014,3,20),
19270
],
[
new Date(2014,3,21),
38445
],
[
new Date(2014,3,22),
39455
],
[
new Date(2014,3,23),
40975
],
[
new Date(2014,3,24),
40525
],
[
new Date(2014,3,25),
41182
],
[
new Date(2014,3,26),
30611
],
[
new Date(2014,3,27),
18322
],
[
new Date(2014,3,28),
39397
],
[
new Date(2014,3,29),
40651
],
[
new Date(2014,3,30),
41832
],
[
new Date(2014,4,1),
28133
],
[
new Date(2014,4,2),
41289
],
[
new Date(2014,4,3),
29479
],
[
new Date(2014,4,4),
24877
],
[
new Date(2014,4,5),
31723
],
[
new Date(2014,4,6),
24245
],
[
new Date(2014,4,7),
41449
],
[
new Date(2014,4,8),
41079
],
[
new Date(2014,4,9),
42898
],
[
new Date(2014,4,10),
29652
],
[
new Date(2014,4,11),
18685
],
[
new Date(2014,4,12),
39548
],
[
new Date(2014,4,13),
41240
],
[
new Date(2014,4,14),
41369
],
[
new Date(2014,4,15),
43115
],
[
new Date(2014,4,16),
42124
],
[
new Date(2014,4,17),
30735
],
[
new Date(2014,4,18),
20713
],
[
new Date(2014,4,19),
39483
],
[
new Date(2014,4,20),
40420
],
[
new Date(2014,4,21),
41856
],
[
new Date(2014,4,22),
41844
],
[
new Date(2014,4,23),
41312
],
[
new Date(2014,4,24),
31011
],
[
new Date(2014,4,25),
17553
],
[
new Date(2014,4,26),
38822
],
[
new Date(2014,4,27),
39602
],
[
new Date(2014,4,28),
41435
],
[
new Date(2014,4,29),
41351
],
[
new Date(2014,4,30),
41716
],
[
new Date(2014,4,31),
27495
],
[
new Date(2014,5,1),
17614
],
[
new Date(2014,5,2),
37497
],
[
new Date(2014,5,3),
40230
],
[
new Date(2014,5,4),
21524
],
[
new Date(2014,5,5),
37375
],
[
new Date(2014,5,6),
23052
],
[
new Date(2014,5,7),
23247
],
[
new Date(2014,5,8),
15986
],
[
new Date(2014,5,9),
37545
],
[
new Date(2014,5,10),
41054
],
[
new Date(2014,5,11),
40908
],
[
new Date(2014,5,12),
40664
],
[
new Date(2014,5,13),
41665
],
[
new Date(2014,5,14),
27627
],
[
new Date(2014,5,15),
20261
],
[
new Date(2014,5,16),
38265
],
[
new Date(2014,5,17),
40895
],
[
new Date(2014,5,18),
44182
],
[
new Date(2014,5,19),
40447
],
[
new Date(2014,5,20),
42253
],
[
new Date(2014,5,21),
27090
],
[
new Date(2014,5,22),
19909
],
[
new Date(2014,5,23),
41921
],
[
new Date(2014,5,24),
42354
],
[
new Date(2014,5,25),
42072
],
[
new Date(2014,5,26),
42868
],
[
new Date(2014,5,27),
48995
],
[
new Date(2014,5,28),
28730
],
[
new Date(2014,5,29),
19249
],
[
new Date(2014,5,30),
39391
],
[
new Date(2014,6,1),
40466
],
[
new Date(2014,6,2),
42033
],
[
new Date(2014,6,3),
39614
],
[
new Date(2014,6,4),
41017
],
[
new Date(2014,6,5),
24841
],
[
new Date(2014,6,6),
18495
],
[
new Date(2014,6,7),
39254
],
[
new Date(2014,6,8),
40338
],
[
new Date(2014,6,9),
41856
],
[
new Date(2014,6,10),
41612
],
[
new Date(2014,6,11),
42190
],
[
new Date(2014,6,12),
27303
],
[
new Date(2014,6,13),
19159
],
[
new Date(2014,6,14),
39315
],
[
new Date(2014,6,15),
41923
],
[
new Date(2014,6,16),
42985
],
[
new Date(2014,6,17),
41765
],
[
new Date(2014,6,18),
41592
],
[
new Date(2014,6,19),
27212
],
[
new Date(2014,6,20),
19228
],
[
new Date(2014,6,21),
38995
],
[
new Date(2014,6,22),
44786
],
[
new Date(2014,6,23),
41305
],
[
new Date(2014,6,24),
44675
],
[
new Date(2014,6,25),
41248
],
[
new Date(2014,6,26),
24367
],
[
new Date(2014,6,27),
20341
],
[
new Date(2014,6,28),
40958
],
[
new Date(2014,6,29),
42742
],
[
new Date(2014,6,30),
45286
],
[
new Date(2014,6,31),
42903
] 
];
data.addColumn('date','income_date');
data.addColumn('number','on_tot');
data.addRows(datajson);
return(data);
}
 
// jsDrawChart
function drawChartCalendarID3af4535d3cf1() {
var data = gvisDataCalendarID3af4535d3cf1();
var options = {};
options["width"] = 600;
options["height"] = 320;
options["title"] = "Daily traffic in Seoul";
options["calendar"] = {yearLabel: { fontName: 'Times-Roman',
                      fontSize: 32, color: '#1A8763', bold: true},
                      cellSize: 10,
                      cellColor: { stroke: 'red', strokeOpacity: 0.2 },
                      focusedCellColor: {stroke:'red'}};


    var chart = new google.visualization.Calendar(
    document.getElementById('CalendarID3af4535d3cf1')
    );
    chart.draw(data,options);
    

}
  
 
// jsDisplayChart
(function() {
var pkgs = window.__gvisPackages = window.__gvisPackages || [];
var callbacks = window.__gvisCallbacks = window.__gvisCallbacks || [];
var chartid = "calendar";
  
// Manually see if chartid is in pkgs (not all browsers support Array.indexOf)
var i, newPackage = true;
for (i = 0; newPackage && i < pkgs.length; i++) {
if (pkgs[i] === chartid)
newPackage = false;
}
if (newPackage)
  pkgs.push(chartid);
  
// Add the drawChart function to the global list of callbacks
callbacks.push(drawChartCalendarID3af4535d3cf1);
})();
function displayChartCalendarID3af4535d3cf1() {
  var pkgs = window.__gvisPackages = window.__gvisPackages || [];
  var callbacks = window.__gvisCallbacks = window.__gvisCallbacks || [];
  window.clearTimeout(window.__gvisLoad);
  // The timeout is set to 100 because otherwise the container div we are
  // targeting might not be part of the document yet
  window.__gvisLoad = setTimeout(function() {
  var pkgCount = pkgs.length;
  google.load("visualization", "1", { packages:pkgs, callback: function() {
  if (pkgCount != pkgs.length) {
  // Race condition where another setTimeout call snuck in after us; if
  // that call added a package, we must not shift its callback
  return;
}
while (callbacks.length > 0)
callbacks.shift()();
} });
}, 100);
}
 
// jsFooter
</script>
 
<!-- jsChart -->  
<script type="text/javascript" src="https://www.google.com/jsapi?callback=displayChartCalendarID3af4535d3cf1"></script>
 
<!-- divChart -->
  
<div id="CalendarID3af4535d3cf1" 
  style="width: 600; height: 320;">
</div>
 <div><span>Data: subway_specific_gwanghwa &#8226; Chart ID: <a href="Chart_CalendarID3af4535d3cf1.html">CalendarID3af4535d3cf1</a> &#8226; <a href="https://github.com/mages/googleVis">googleVis-0.6.2</a></span><br /> 
<!-- htmlFooter -->
<span> 
  R version 3.4.0 (2017-04-21) 
  &#8226; <a href="https://developers.google.com/terms/">Google Terms of Use</a> &#8226; <a href="https://google-developers.appspot.com/chart/interactive/docs/gallery/calendar">Documentation and Data Policy</a>
</span></div>
</body>
</html>


{:/}