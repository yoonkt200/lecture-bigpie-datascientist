```python
# -*- coding: utf-8 -*-

##### format 함수
inputpath = '/hello/world'
out = []
# :0>2 는 2자리보다 커지지 않게 숫자 앞을 0으로 채우는것
inputFormat = '{0}/{1}/{2:0>2}/{3:0>2}/time-{4:0>2}.*' 

out.append(inputFormat.format(inputpath, 2018, 2, 4, 12.1231131))
out.append(inputFormat.format(inputpath, 2018, 3, 5, 13.1231))
out.append(inputFormat.format(inputpath, 2018, 4, 1, 15))
out.append(inputFormat.format(inputpath, 2018, 5, 6, 1))

print(",".join(out))


##### map 함수 : map(func, list) - list를 func한 후에 리턴.
a = map(lambda x: x ** 2, range(5))
for i in a:
    print(i)


##### isinstance 함수
class A:
    def run(self):
        print("run!")

class B:
    def run(self):
        print("run!")

a = A()
b = B()
c = list()
d = 4
e = "adw"

print(isinstance(a, A))
print(isinstance(b, B))
print(isinstance(c, list))
print(isinstance(d, int))
print(isinstance(c, str))
```