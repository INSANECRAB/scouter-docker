# Dockerfile 요구사항

아래 내용이 Dockerfile에 반드시 포함되어야 합니다.

## Scouter 설정

```dockerfile
# Scouter 디렉토리 생성 및 파일 복사
RUN mkdir -p /scouter
COPY ./scouter/scouter.agent.jar /scouter/
COPY ./scouter/scouter.conf /scouter/

# 권한 설정
RUN chown -R user:group /scouter

# Scouter Agent 적용
ENTRYPOINT ["java", \
    "-javaagent:/scouter/scouter.agent.jar", \
    "-Dscouter.config=/scouter/scouter.conf", \
    "-jar", \
    "app.jar"]
```

## 배포 파일 구성

어플리케이션 배포 시 `scouter` 폴더 하위에 아래 파일이 포함되어야 합니다.

```
scouter/
├── scouter.agent.jar
└── scouter.conf
```
