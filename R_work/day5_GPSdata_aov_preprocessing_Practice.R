setwd("/Users/yoon/Documents/DataScience/R_work") 
dyn.load("/Library/Java/JavaVirtualMachines/jdk1.8.0_131.jdk/Contents/Home/jre/lib/server/libjvm.dylib")
library(rJava)
Sys.setlocale("LC_ALL", "ko_KR.UTF-8") # 한글 인코딩 가능하게 해줌

tracking = read.csv("go_track_trackspoints.csv", header = T, fileEncoding="UTF-8")
app = read.csv("go_track_tracks.csv", header = T, fileEncoding="UTF-8")
colnames(app) = c("track_id", "id_android", "speed", "time", "distance", "rating", "rating_bus", "rating_weather", "car_or_bus", "linha")
# data1, data2 의 공통 column은 trackid

table(tracking$track_id)
table(app$id_android) # id_android는 유저id 라고 볼수있음.

car_idx_list = which(app$car == 1)
bus_idx_list = which(app$car == 2)
car1 = app[car_idx_list, ]
bus1 = app[bus_idx_list, ]
table(car1$rating)
table(bus1$rating) 

app$car_or_bus = as.factor(app$car_or_bus)
vehicle = aov(rating~car_or_bus, data=app)
summary(vehicle)
t = TukeyHSD(vehicle, "car_or_bus")
t
# 버스보다 차가 좋음

app$rating = as.factor(app$rating)
app$rating_bus = as.factor(app$rating_bus)
leveneTest(time~rating*rating_bus, app)
vehicle = aov(time~rating*rating_bus, data=app)
t = TukeyHSD(vehicle)
vehicle
t
# 시간과 평점에 관한 차이

app$rating = as.factor(app$rating) 
# factor형으로 안바꿔줘도 aov가 가능은 하지만, 뭔가 꼬여서 결과가 다르게 나올 수 있음.
# 따라서 factor형으로 변환을 해주는게 무조건 좋음.
car1 = app[app$car_or_bus==1, ]
bus1 = app[app$car_or_bus==2, ]
w1 = app[app$rating_weather==1, ]
w2 = app[app$rating_weather==2, ]
mm1 = aov(time~rating, car1)
mm2 = aov(time~rating, bus1)
summary(mm1)
summary(mm2)
View(bus1)
# 차와 버스 각각 시간에 대한 평점

app2 = app[app$rating_weather != 0, ]
app2$rating_weather = as.factor(app2$rating_weather)
var.test(rating~rating_weather, app2)
t.test(rating~rating_weather, app2, var.equal = T, paired = F)
# 귀무가설 : 날씨가 1,2인 경우 rating이 같나

merged_data = merge(tracking, app, by="track_id")