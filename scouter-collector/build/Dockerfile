# 1) 경량 JRE 베이스 이미지
FROM eclipse-temurin:8-jre-jammy

# 2) 버전 파라미터
ARG SCOUTER_VERSION=2.15.0

ENV SCOUTER_HOME=/opt/scouter \
    SCOUTER_VERSION=${SCOUTER_VERSION}

WORKDIR ${SCOUTER_HOME}

# 3) curl 설치 + Scouter 공식 릴리즈 tar.gz 다운로드 & 압축해제
#    --strip-components=1 로 최상위 디렉터리 한 단계 제거해서
#    /opt/scouter 아래에 바로 server/, agent.* 가 오도록 정리
RUN apt-get update && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/* \
    && curl -L "https://github.com/scouter-project/scouter/releases/download/v${SCOUTER_VERSION}/scouter-all-${SCOUTER_VERSION}.tar.gz" \
       | tar zx --strip-components=1

RUN groupadd -g 2000 scgroup \
 && useradd  -u 1001 -g scgroup -m -s /sbin/nologin scuser

RUN mkdir -p /opt/scouter/server/data /opt/scouter/server/logs \
 && chown -R scuser:scgroup /opt/scouter


# 4) 커스터마이징된 scouter.conf 있으면 복사 (없으면 기본 conf 그대로 사용)
#    나중에 필요 없으면 이 COPY 줄은 빼도 됨
COPY conf/scouter.conf ${SCOUTER_HOME}/server/conf/scouter.conf

# 5) 데이터/로그 디렉터리 볼륨
VOLUME ["/opt/scouter/server/data", "/opt/scouter/server/logs"]

# 6) collector & web 포트
#    6100: TCP/UDP (agent용)
#    6180: web/api (scouter.conf 기준)
EXPOSE 6100 6180

# 7) collector를 foreground로 실행 (startup.sh는 nohup & 백그라운드라 컨테이너에 안 맞음)
WORKDIR ${SCOUTER_HOME}/server

USER scuser

ENTRYPOINT ["java", "-Xms512m", "-Xmx2048m", "-classpath", "./scouter-server-boot.jar", "scouter.boot.Boot", "./lib"]

