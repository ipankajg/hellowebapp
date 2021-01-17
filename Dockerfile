#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

#FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim-arm32v7 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["HelloWebApp.csproj", ""]
#RUN dotnet restore "./HelloWebApp.csproj"
RUN dotnet restore "./HelloWebApp.csproj" -r linux-arm
COPY . .
WORKDIR "/src/."
#RUN dotnet build "HelloWebApp.csproj" -c Release -o /app/build
RUN dotnet build "HelloWebApp.csproj" -c Release -o /app/build -r linux-arm

FROM build AS publish
#RUN dotnet publish "HelloWebApp.csproj" -c Release -o /app/publish
RUN dotnet publish "HelloWebApp.csproj" -c Release -o /app/publish -r linux-arm

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "HelloWebApp.dll"]
