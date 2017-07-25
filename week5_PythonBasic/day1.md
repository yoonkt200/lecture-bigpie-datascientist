# 1일차 


-----------------------


#### **1. 파이썬 기본 문법**


> **1.1 수 다루기**

```python
### 2,16,10 진법 관련
# Ob xxxxx -> 2진법
# Oc xxxxx -> 16진법
# Ox xxxxx -> 10진법

# >>> bin(8)
# '0b1000'
# >>> hex(10)
# '0xa'
# >>> oct(10)
# '0o12'

### math module
import math

# 여러 수를 표현 가능
math.pi
math.e

math.abs() # 절대값
round() # 반올림
math.trunc() # 버림
```

> **1.2 텍스트 다루기**

```python
a = "hello world!"
b = "헬로 월드!"
print("'어서와파이썬은처음이지?'", "ㅁㅇ", "adad")
print("'어서와파이썬은처음이지?'" + "ㅁㅇ" + "adad")

s = "Good Morning"
s[0]
s[0:7:2] # 0~6 index의 character에서, index의 간격은 2로, 값을 가져옴.
s[0:-2] # 0~ 끝에서 거꾸로 2 index까지.
s[-1::-1] # 문자열 역

'Good' in s # string search
len(s) # string length
a.startswith("he")

# character 위치 찾기 - rfind는 뒤에서 부터, find는 앞에서부터
a.find("M") # 없을때
a.find("h") # 있을때
a.rfind("o") # 여러개 있을때
a.find("o") # 여러개 있을때

a.count("l") # 등장 횟수 검색
' Left Strip '.lstrip() # 왼쪽 공백 제거
' Right Strip '.rstrip() # 오른쪽 공백 제거
'  Strip  '.strip() # 양쪽 공백 제거
```

> **1.3 자료 다루기**

```python

### list, format 관련
a = "Apple, Orange, Kiwi"
b = a.split(',')
type(b)
type(b[0])
b[0][0]

print("Hello %s" %"World")

### format, input 사용
a = 'My name is {0}. I am {1} years old.'.format('Mario', 40)
a
a = input()
b = input()
result = int(a)*int(b)
print("{0} * {1} = {2}".format(a, b, result))

### 비트 다루기

# 시프트 연산
a = 240
a << 2
a = 13
a << 2

# 비트 논리 연산
# 논리곱: 두 비트 모두가 1(참)이어야 결과도 1(참)
9 & 10

# 논리합: 둘 중 하나라도 참(1)이면 결과도 참(1)
9 | 10

# 배타적 논리합: 두 피연산자의 진리값이 서로 달라야 참(1)
9 ^ 10

# 보수 연산: 피연산자의 비트를 0에서 1로, 1에서 0으로 뒤집음.
~255
```


-----------------------


#### **2. 파이썬 자료구조**

> **1.1 리스트 자료구조**

```python
### 리스트의 생성 / 접근
a = ['김개똥', '박짱구', '이멍충']
a[0]

### 리스트의 슬라이싱
a = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] 

a[0:5] # 0~4 index
a[5:] # 5~end index
a[:3] # 0~2 index

### 리스트 결합
a = [1, 2, 3, 5] 
b = [5, 6, 7]
a+b

### 리스트 길이
a = [1, 2, 3]
len(a)

### 리스트 조작
b2 = a # 얕은 복사 : 참조
b2 = a.copy() # 깊은 복사 : 내용 완전 복사

a = [1, 2, 3, 4, 5] 
a[2] = 30

### 리스트 메소드
a = [1, 2, 3] 
a.append(4) # 뒤에 추가
a.extend([4, 5, 6]) # 뒤에 이어붙임
a.insert(2, 3) # 특정 위치에 삽입

a = ['BMW', 'BENZ', 'VOLKSWAGEN', 'AUDI', 'BMW']
a.remove('BMW') # 검색에서 발견한 첫번째 요소 삭제

a = [1, 2, 3, 4, 5]
a.pop() # 마지막 요소 삭제

a = ['abc', 'def', 'ghi', 'def']
a.index('def') # 검색된 요소 첫번째 인덱스 추출

a = [1, 100, 2, 100, 3, 100]
a.count(100) # 검색 결과 갯수 세줌

a = [3, 4, 5, 1, 2]
a.sort() # a.sort(reverse = True)

a = [3, 4, 5, 1, 2] 
a.reverse() # 뒤집음
```

> **1.2 튜플 자료구조**

- List는 데이터 변경 가능(리스트 생성 후 추가/수정/삭제 가능)
- Tuple은 데이터 변경 불가능(튜플 생성 후 추가/수정/삭제 불가능)
- List는 이름 그대로 목록형식의 데이터를 다루는데 적합
- Tuple은 위경도 좌표나 RGB 색상처럼 작은 규모의 자료구조를 구성하기에 적합

```python
### 튜플의 생성
a = (1, 2, 3)
a = 1, 2, 3, 4
type(a)

a = (1,) # 요소가 하나인 튜플 생성
a = (1) # 튜플이 아님

### 슬라이싱
a = (1, 2, 3, 4, 5, 6) 
a[:3]

### 튜플 결합
a = (1, 2, 3) 
b = (4, 5, 6) 
c = a + b

### 변경 불가능
a = (1, 2, 3)
a[0] = 2

### 패킹과 언패킹
a = 1, 2, 3
one, two, three = a
one

a = [1,2,3] # 리스트 언패킹도 가능
one, two, three = a

### 메소드
a = ('abc', 'def', 'ghi', 'abc')
a.index('abc')
a.count('abc')
```

> **1.3 딕셔너리 자료구조**

- 파이썬 자료구조의 꽃
- 딕셔너리는 key, value 의 묶음 형태로 구성된 자료구조. 리스트처럼 접근이 가능하면서 hash처럼 사용됨.
- 자료를 검색하기 위해 리스트처럼 순차적으로 모든 내용을 찾는 것이 아니라, key값을 검색하게 됨.

```python
### 딕셔너리 생성
dic = {}
dic['파이썬'] = 'www.python.org'
dic['마이크로소프트'] = 'www.microsoft.com'
dic['애플'] = 'www.apple.com'

dic['파이썬']
dic

### 딕셔너리의 keys(), values() 메소드
dic.keys()
dic.values(["a","b","c"])

### 딕셔너리의 items() 메소드
dic.items()

### 딕셔너리의 in
'애플' in dic.keys()
'www.microsoft.com' in dic.values()

### 딕셔너리의 pop, clear
dic.pop('애플')
dic.clear()
```