# Build
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /app
ADD *.csproj .
RUN dotnet restore
ADD . .
RUN dotnet publish \
  -c Release \
  -o ./output

# Run
FROM mcr.microsoft.com/dotnet/aspnet:6.0
# Connect the container image with the github repository
LABEL org.opencontainers.image.source https://github.com/whiteducksoftware/dapr-demo
RUN adduser \
  --disabled-password \
  --home /app \
  --gecos '' app \
  && chown -R app /app
USER app
WORKDIR /app
COPY --from=build-env /app/output .
ENV DOTNET_RUNNING_IN_CONTAINER=true

EXPOSE 5002
ENTRYPOINT ["dotnet", "Demo.Dapr.MessageService.dll"]
