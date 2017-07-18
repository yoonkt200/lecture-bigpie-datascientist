str(iris3)
iris3[1]
iris3[, , 1]
iris3[1, 1, ]
View(iris3)

dyn.load("/Library/Java/JavaVirtualMachines/jdk1.8.0_131.jdk/Contents/Home/jre/lib/server/libjvm.dylib")
library(rJava)
install.packages("readbitmap") # even jpg, png possible
library(readbitmap)

bmp1 = read.bitmap("7.bmp")
str(bmp1)
dim(bmp1)

jpg1 = read.bitmap("7.jpg")
str(jpg1)
dim(jpg1)

png1 = read.bitmap("7.png") # png is 4dim for transparency
dim(png1)

bmp_m = matrix(bmp1, nrow=1, byrow = T)
jpg_m = matrix(jpg1, nrow=1, byrow = T)
png_m = matrix(png1, nrow=1, byrow = T)

dim(png_m)
jpg_m[1:10]

list1 = list.dirs("testfolder", full.names = T) # get list in directory.

for (i in 2:length(list1)){
  list2 = list.files(list1[1], full.names = T,
                     pattern = '.png',
                     include.dirs = T) # get files in directory.
  print(list2)
}