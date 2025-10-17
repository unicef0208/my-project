# 1. 베이스 이미지 선택 (어떤 환경에서 시작할지)
FROM nginx:alpine

# 2. 내 컴퓨터의 파일을 이미지 안으로 복사
#    (예시로 index.html 파일을 만든다고 가정)
COPY index.html /usr/share/nginx/html

# 3. 컨테이너가 시작될 때 실행할 명령어 (필요시)
#    NGINX는 기본 실행 명령어가 있으므로 이 줄은 생략 가능
