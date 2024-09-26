FROM alpine/k8s:1.25.2

COPY . /

RUN chmod +x /refresh_access_token.sh

CMD ["/refresh_access_token.sh"]
