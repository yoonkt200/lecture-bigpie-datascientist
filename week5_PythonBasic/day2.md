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

> **2.1 모듈과 패키지 개념**

- 모듈은 파이썬 파일 안에 함수, 클래스 등으로 modulation이 되어있는 기능들이 있는 것의 단위를 말한다.
- 즉, 다른 파이썬 파일에서 작성한 기능들을 module이라는 단위로 관리하며, 불러오는 것이 가능하다는 것.
- 표준 모듈 : 파이썬과 함께 따라오는 모듈
- 사용자 생성 모듈 : 프로그래머가 직접 작성한 모듈
- 서드 파티(3rd Party) 모듈 : 파이썬 재단도 프로그래머도 아닌 다른 프로그래머, 또는 업체에서 제공한 모듈
- import, from, as, * 등으로 사용한다. 너무 쉬운 내용이므로 생략.
- 패키지는 쉽게말해 모듈의 상위 단위라고 생각하면 되겠다.

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
-----------------------


#### **3. 언더스코어의 의미**

```
타 언어에서 언더스코어 '_'은 단순히 스네이크 표기법 정도로만 사용이 되곤 한다. 파이썬에서 언더스코어는
조금 특별한 기능을 하는데, 이는 파이썬이 인터프리터 언어라는 속성에 기인한다.


```