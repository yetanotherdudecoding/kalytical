FROM instance-1.us-east1-b.c.sandbox-224519.internal:8080/explorepod:201812262
WORKDIR /
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["sh", "-c", "/entrypoint.sh"]
