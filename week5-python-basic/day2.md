# 2일차 


-----------------------


#### **1. 파이썬의 함수**


> **1.1 함수 사용 개념**

- 파이썬에서 함수는 정의(def keyword)로 표현.

- 파이썬에서는 함수를 일급 객체(First Class Object)로 다룸.

- 일급 객체란 프로그래밍 언어 설계에서 매개변수로 넘길 수 있고 함수가 반환할 수도 있으며 변수에 할당이 가능한 개체를 가리키는 용어

- 파이썬에서는 함수를 매개변수로도 사용할 수 있고 함수의 결과로 반환하는 것도 가능

> **1.2 함수 사용 예제**

```python
### 다중 리턴과 타입
def abc(a,b):
    re1 = a+b
    re2 = a-b
    re3 = a*b
    
    return re1,re2,re3


def abc2(a,b):
    re1 = a+b
    re2 = a-b
    re3 = a*b
    
    return [re1,re2,re3]


def abc3(a,b):
    re1 = a+b
    re2 = a-b
    re3 = a*b
    
    return (re1,re2,re3)

type(abc(3,1)) # tuple return
abc(3,1)[0]

type(abc2(3,1)) # list return
abc2(3,1)[0]

type(abc3(3,1)) # tuple return
abc3(3,1)[0]


### 기본값 매개변수
def print_string(text, count=1 ): 
    for i in range(count):
        print(text)
        
print_string("하이욤", 2)
print_string("하이욤")


### 키워드 매개변수
def print_personnel(name, position='staff', nationality='Korea'): 
    print('name = {0}'.format(name))
    print('position = {0}'.format(position))
    print('nationality = {0}'.format(nationality))
    
print_personnel(name='윤기태', nationality='ROK')
print_personnel('윤기태')


### 가변 매개변수
# 입력 개수가 달라질 수 있는 매개변수
# *를 이용하여 정의된 가변 매개변수는 튜플
# 딕셔너리는 **
# list처럼 *를 안써줘도 상관 없지만 튜플, 딕셔너리의 특수한 형태로 명시적으로 받고싶을때 사용.

def print_list(lists):
    print(type(lists))
    for k in lists:
        print(k)
        
a = ['아버지가', '방에', '들어가신다.']
print_list(a)

def print_tuple(*args):
    print(type(args))
    for k in args:
        print(k)
        
a = '아버지가', '방에', '들어가신다.'
print_tuple(a)

def print_team(**players):
    print(type(players))
    for k,v in players.items():
        print(k, v)
        
print_team(카시야스='GK', 호날두='FW', 알론소='MF', 페페 ='DF')


### 일반 + 가변 매개변수
def print_args(argc, *argv): 
    for i in range(argc):
        print(argv[i])
        
print_args(3, "argv1", "argv2", "argv3")

def print_args2(*argv, argc): 
    for i in range(argc):
        print(argv[i])
        
print_args2("argv1", "argv2", "argv3", argc=3)
print_args2("argv1", "argv2", "argv3", 3) # error
# 가변 매개변수 뒤에 정의된 일반 매개 변수는 반드시 키워드 매개변수로 호출 해야 함


### 재귀함수
def factorial(n):
    if n == 0:
        return 1
    elif n > 0:
        return factorial(n-1)*n
    
factorial(8)


### 함수와 전역변수
def scope_test():
    global a # 전역변수 a를 의미함
    a=1 
    print(a)
    
a = 0
scope_test()
a


### 중첩함수
import math
def stddev(*args):
    def mean():
        return sum(args)/len(args)
    
    def variance(m):
        total = 0
        for arg in args:
            total += (arg - m ) ** 2
        return total/(len(args)-1)
    
    v = variance(mean())
    return math.sqrt(v)

stddev(2.3, 1.7, 1.4, 0.7, 1.9)


### 구현 보류 함수
def empty_function():
    pass

class empty_class: 
	pass
```


-----------------------


#### **2. 모듈과 패키지**

> **2.1 모듈의 개념**

- 모듈은 파이썬 파일 안에 함수, 클래스 등으로 modulation이 되어있는 기능들이 있는 것의 단위를 말한다.
- 즉, 다른 파이썬 파일에서 작성한 기능들을 module이라는 단위로 관리하며, 불러오는 것이 가능하다는 것.
- 표준 모듈 : 파이썬과 함께 따라오는 모듈
- 사용자 생성 모듈 : 프로그래머가 직접 작성한 모듈
- 서드 파티(3rd Party) 모듈 : 파이썬 재단도 프로그래머도 아닌 다른 프로그래머, 또는 업체에서 제공한 모듈
- import, from, as, * 등으로 사용한다. 너무 쉬운 내용이므로 생략.

```python
### 현재 파일을 기준으로, 모듈을 찾는 working directory 들을 표시함.
import sys
for path in sys.path: 
    print(path)
```

> **2.2 메인모듈과 하위모듈**

- 모듈은 메인모듈과 하위모듈로 구분이 가능하다.
- 어떻게 실행하느냐에 따라 메인모듈이 결정된다.
- 파이썬의 전역변수인 __name__은, 메인모듈에서 __main__ 으로 지정된다.

```
----- main.py
  |
  |-- sub.py

이런 형태로 디렉토리에 모듈 2개가 존재한다고 하자. 여기서 start의 역할을 하는 메인 모듈이 main.py라고 할 때,

main.py, sub.py 의 코드가 다음과 같다고 하자.
```

```python
### sub.py
print("beginning of sub.py...") 
print('name : {0}'.format(__name__)) 
print("end of sub.py...")

### main.py
import sub
print("beginning of main.py...") 
print('name : {0}'.format(__name__)) 
print("end of main.py...")
```

```
main.py를 메인모듈로 실행했을 때의 결과는 다음과 같다.

beginning of sub.py... name : sub
end of sub.py... 
beginning of main.py... name : __main__
end of main.py...
```

> **2.3 패키지**

- 모듈을 모아놓는 디렉토리
- 모듈 꾸러미로 해석하면 이해하기 편함
- 디렉토리가 파이썬의 패키지로 인정받으려면 __init__.py 파일을 그 경로에 갖고 있어야 함
- 보통의 경우, init__.py 파일 내용은 대개 비워둠

```
----- main.py
  |
  |-- package(folder)
  |      |
  |      |-- calculator.py
  |      |-- __init__.py

이런 디렉토리 구조일때, 패키지로 사용할 디렉토리 안에 __init__.py가 있다면 패키지로 인정이 됨.
```

```python
### 사용 예시
from package import calculator

calculator.plus(1,3)
```

> site-packages : 파이썬의 기본 라이브러리 패키지 외에 추가적인 패키지를 설치하는 디렉토리. 
> "C:\\Python34\\lib\\site-packages" 이렇게 생긴 경로에 서드파티 모듈들을 설치한다.

```
이를 이용하여, site-packages 안에 자신만의 패키지를 넣어서 사용할 수 있다.

----- site-packages
  		|
  		|-- package(folder)
  		|      |
  		|      |-- calculator.py
  		|      |-- __init__.py

이렇게 해놓고, 
from package import calculator
이렇게 어디서든 사용할 수 있다는 것. (site-packages 하위에 있으므로, sys.path에 속하게 됨.)
```


-----------------------


#### **3. 클래스와 오브젝트**

```python

#################################################################
#################################################################

### 클래스에서 self, cls, static의 역할
# class는 붕어빵 빵틀, object는 붕어빵이라고 비유가 가능.
# self는 붕어빵 각각이 가지는 속성이고, cls는 붕어빵 빵틀이 가지는 속성임.
# 클래스의 멤버변수를 선언할때 아래처럼 선언하면 빵틀 변수가 되는 것이고,
# init 에서 self로 선언하면 붕어빵의 변수가 되는 것이다.
class InstanceCounter:
    count = 0
    count2 = 0
    
    def __init__(self):
        self.count3 = 0
        InstanceCounter.count += 1
        self.count2 += 1
        
    @classmethod
    def print_instance_count(cls):
        print(cls.count)
        print(cls.count2)
        
    @staticmethod
    def print_static_count():
        print(InstanceCounter.count)
        print(InstanceCounter.count2)
        
a = InstanceCounter() 
InstanceCounter.print_instance_count()
InstanceCounter.print_static_count()

b = InstanceCounter()
InstanceCounter.print_instance_count()
InstanceCounter.print_static_count()

c = InstanceCounter()
c.print_instance_count()
InstanceCounter.print_static_count()

#################################################################
#################################################################

### 예제2
class Car:
    count = 0
    
    def __init__(self):
        Car.count += 1
        
    def print(self):
        print(self.count)
        
a = Car()
a.print()
b = Car()
b.print()
c = Car()
c.print() 
# --> init 할때마다 붕어빵 빵틀의 속성 자체가 변하고 있음,
# 새로 Car 오브젝트를 생성하면 붕어빵의 기본 count가 빵틀에서 나온 속성으로 설정됨.

#################################################################
#################################################################

### 클래스의 퍼블릭, 프라이빗
class HasPrivate:

    def __init__(self):
        self.public = "Public"
        self.__private = "Private"

    def print_from_internal(self):
        print(self.public)
        print(self.__private)
        
obj = HasPrivate()
obj.print_from_internal()
print(obj.public)
print(obj.__private) # error -> __membervariable은 외부접근 불가.


### 상속
class Base:
    def base_method(self):
        print("base_method")
                        
class Derived(Base):
    pass

base = Base()
base.base_method()
derived = Derived()
derived.base_method()

#################################################################
#################################################################

### super를 이용한 상속
class A:
    no_init = "hello no init"
    
    def __init__(self):
        self.hello = "hello"
        print("A.__init__()") 
        
        
class B(A):
    def __init__(self):
        #super().__init__()
        print("B.__init__()")
        
b = B()
b.hello
b.no_init
# super로 부모클래스를 init해주지 않으면 부모의 init에서부터 생성된 속성 사용 불가
# super로 init 안해줘도 no_init 같은 속성은 사용 가능.


### 다중상속
class A:
    pass

class B:
	pass

class C(A,B):
	pass

# super와 오버라이딩을 이용하면, 다중상속에서 다이아몬드 상속 문제를 해결 가능함.

#################################################################
#################################################################

### 데코레이터
# __call__() 메소드는 객체를 함수 호출 방식으로 사용하게 만듬.

# 첫번째 방법
class Callable:
    
    def __call__(self):
        print("I am called.")
        
obj = Callable()
obj()

class MyDecorator:

    def __init__(self, f):
        print("initialize decorator")
        self.func = f
        
    def __call__(self):
        print("begin :{0}".format(self.func.__name__))
        self.func()
        print("end :{0}".format(self.func.__name__))
        
def print_hello():
    print("hello world!")
    
obj = MyDecorator(print_hello)
obj()

# 두번째 방법
class MyDecorator: 
    
    def __init__(self, f):
        print("Initializing MyDecorator...") 
        self.func = f
        
    def __call__(self):
        print ("Begin :{0}".format( self.func.__name__)) 
        self.func()
        print ("End :{0}".format(self.func.__name__))
    
@MyDecorator
def print_hello(): 
    print("Hello.")
    
print_hello()

#################################################################
#################################################################

### 추상클래스와 메서드 implementation

from abc import ABCMeta
from abc import abstractmethod

class AbstractDuck(metaclass=ABCMeta):

    @abstractmethod 
    def Quack(self):
        pass
    

class Duck(AbstractDuck):
    
    def Quack(self):
        print("implementation")
        
duck = Duck()
duck.Quack()

```

-----------------------


#### **4. 언더스코어의 의미**

```
타 언어에서 언더스코어 '_'은 단순히 스네이크 표기법 정도로만 사용이 되곤 한다. 파이썬에서 언더스코어는
조금 특별한 기능을 하는데, 이는 파이썬이 인터프리터 언어라는 속성에 기인한다.
```

> **4.1 파이썬 인터프리터에서의 사용**

![](https://raw.github.com/yoonkt200/lecture-bigpie-datascientist/master/week5-python-basic/week5-images/1.png)

```
위 그림은 IPython으로 파이썬 인터프리터를 실행한 것이다. 
언더스코어는 다음에서 볼 수 있듯, 마지막 변수를 저장하는 역할을 한다.
```

> **4.2 특정 값을 skip할 때**

```python
a, _, b = 1, 3, 2
# a=1, b=2
a, _, b = [1, 2, 3]
# a=1, b=3

for _ in range(10):
    print("hello")
```

> **4.3 숫자의 구분자로써 활용**

```python
a = 1_000_00_0
# a=1000000
b = 0b_11_0_1
# b=13
```

> **4.4 네이밍의 용도**

```
언더스코어 네이밍은 주로 파이썬에서 public, private을 구분하기 위한 용도로 많이 사용한다.
더블 언더스코어로 멤버 변수나 멤버 함수를 선언하게 되면, 마치 private처럼 동작하게 된다.
언더스코어를 싱글로 사용하게 되면 같은 모듈 안에서는 public처럼 동작하면서
명시적으로 사용하는 것이 가능하지만, 다른 모듈에서 해당 변수에 접근하려고 하면 private처럼 동작한다. 
즉, 모듈로써 다른곳에서 사용할 경우에는 import가 되지 않는다.
```

```python
### 더블 언더스코어 사용 시, private처럼 활용 가능.
class HasPrivate:

    def __init__(self):
        self.public = "Public"
        self.__private = "Private"

    def print_from_internal(self):
        print(self.public)
        print(self.__private)

    def public_print(self):
        print("public print")
        self.__private_print()
        
    def __private_print(self):
        print("private print")
        
obj = HasPrivate()
obj.print_from_internal()
print(obj.public)
print(obj.__private) # error
obj.public_print()
obj.__private_print() # error
# 다른 모듈에서는 '_' 만 해줘도 접근 불가능!
```

> **4.5 스페셜 변수 혹은 스페셜 메서드**

```
__name__이나 __init__, __len__ 처럼 파이썬에서 특별한 문법적 기능이나, 
특별한 기능을 제공하는 스페셜 변수나 메서드의 구성을 언더스코어로 표현한다. 
네이밍과 더불어 언더스코어를 가장 빈번히 사용하는 용도이다.
```

> **4.6 맹글링을 위한 용도**

```
맹글링이란, 프로그래밍 언어 자체적으로 일정한 규칙에 의해 변수나 함수의 이름을 변경하는 것이다.
파이썬에서 맹글링은 _Class+[name] 의 형식으로 이루어지는데, 맹글링을 호출하는 것이 바로 언더스코어이다.

다음의 두 이미지는 맹글링이 적용되어 오버라이딩이 되지 않는 예와, 맹글링이 적용되지 않아 오버라이딩 된 예이다.
```

![](https://raw.github.com/yoonkt200/lecture-bigpie-datascientist/master/week5-python-basic/week5-images/2.png)

![](https://raw.github.com/yoonkt200/lecture-bigpie-datascientist/master/week5-python-basic/week5-images/3.png)

-----------------------


#### **5. 파일 입출력**

> **5.1 기본 입력**

- open() 함수와 함께 with ~ as문을 사용하면 명시적으로 close() 함 수를 호출하지 않아도 파일이 항상 닫힘.
- with ~ as 문을 사용하는 방법은 다음과 같음.

```python
with open('test.txt', 'r') as file: 
    str = file.read()
    print(str)
```

> **5.2 pandas를 이용한 데이터 입력**

```python
### 기본적인 json read
import json
path = '/Users/yoon/Downloads/pydata/pydata-book-master/'
path = path + 'ch02/usagov_bitly_data2012-03-16-1331923249.txt'

records = [json.loads(line) for line in open(path, encoding="utf-8")]
records[0]['tz']


### pandas를 이용한 json read
import pandas as pd

data1 = pd.read_json(path, lines=True, encoding="utf-8")
type(data1)
data1.loc
data1.index
data1.columns
data1['tz']


### 행렬 단위로 접근
data1[0:2]
data1.loc[0:2] # loc == ix, ix는 decreated
data1.loc[0]
data1.loc[0, 'tz']
```