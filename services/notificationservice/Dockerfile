# Build
FROM node:14-buster As build-env
WORKDIR /build
COPY . .
RUN npm install

# Run
FROM node:14-alpine
RUN adduser \
  --disabled-password \
  --home /app \
  --gecos '' app \
  && chown -R app /app
USER app
WORKDIR /app
COPY --from=build-env /build .

EXPOSE 5005
ENTRYPOINT [ "npm", "start" ]
