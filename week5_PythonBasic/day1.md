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

# character 위치 찾기
a.rfind("M") # 없을때
a.rfind("h") # 있을때
a.rfind("o") # 여러개 있을때
```