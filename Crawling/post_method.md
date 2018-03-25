```python
# -*- coding: utf-8 -*-

import os
import sys
import urllib.request

client_id = "Your Client_ID" # Client_ID 입력
client_secret = "Your_Client_Password" # Client_Password 입력

encText = urllib.parse.quote("원하는 음성 내용 입력.")
data = "speaker=mijin&speed=0&text=" + encText;

url = "https://openapi.naver.com/v1/voice/tts.bin"
request = urllib.request.Request(url)
request.add_header("X-Naver-Client-Id", client_id)
request.add_header("X-Naver-Client-Secret", client_secret)
response = urllib.request.urlopen(request, data=data.encode('utf-8'))
rescode = response.getcode()

if(rescode==200):
    print("TTS mp3 저장")
    response_body = response.read()
    with open('fastcampus.mp3', 'wb') as f:
        f.write(response_body)
else:
    print("Error Code:" + rescode)
```