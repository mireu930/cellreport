# 키스토어 파일 생성 방법
~~~
    keytool -genkey -v -keystore project-name.jks -keyalg RSA -keysize 2048 -validity 10000 -alias project-name
~~~

~~~
    storePassword=<앞서 설정한 비밀번호>
    keyPassword=<앞서 설정한 비밀번호>
    keyAlias=<project-name>
    storeFile=keystore/<project-name>.jks
~~~