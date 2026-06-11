# Etapa 1: Compilar el frontend (Astro → HTML/CSS/JS estático)
FROM node:24-alpine AS build-frontend
WORKDIR /usr/app
COPY frontend/ .
RUN npm ci
RUN npm run build

# Etapa 2: Compilar el backend (.NET 8)
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-backend
WORKDIR /app
COPY backend/ .
RUN dotnet publish -c Release -o out

# Etapa 3: Imagen final (solo el binario + los archivos estáticos)
FROM mcr.microsoft.com/dotnet/sdk:8.0
WORKDIR /app
COPY --from=build-backend /app/out .
COPY --from=build-frontend /usr/app/dist ./wwwroot
CMD ["dotnet", "MangaApi.dll"]
