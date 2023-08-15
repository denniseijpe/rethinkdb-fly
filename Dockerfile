# rethinkdb-probe is coded by Chris Dornsife
FROM golang:1 AS probe

WORKDIR /go/src/rethinkdb-probe
COPY probe.go go.mod go.sum /go/src/rethinkdb-probe/

RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-w -s' -o /target/rethinkdb-probe .


FROM rethinkdb:2.4.2

COPY entrypoint.sh /bin/
COPY --from=probe /target/rethinkdb-probe /bin/

HEALTHCHECK --interval=20s --timeout=10s --retries=3 \
  CMD /bin/rethinkdb-probe

ENTRYPOINT ["/bin/entrypoint.sh"]
CMD ["database"]

