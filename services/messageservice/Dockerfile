FROM mcr.microsoft.com/dotnet/sdk:5.0.102-1-buster-slim AS build-env

WORKDIR /app

ADD *.csproj .
RUN dotnet restore

ADD . .
RUN dotnet publish \
  -c Release \
  -o ./output

FROM mcr.microsoft.com/dotnet/aspnet:5.0.2-buster-slim
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