# ---------------------------
# Stage 1: Build Frontend (Vite + Vue)
# ---------------------------
FROM node:18 AS frontend
WORKDIR /app

# Copy package.json & package-lock.json for caching
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy all source files
COPY . .

# Build frontend
RUN npm run build

# ---------------------------
# Stage 2: Backend (Laravel + PHP + Composer)
# ---------------------------
FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git curl unzip libpq-dev libonig-dev libzip-dev zip \
    && docker-php-ext-install pdo pdo_mysql mbstring zip

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

# Copy composer files first for caching
COPY composer.json composer.lock ./

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Copy the rest of the Laravel app
COPY . .

# Copy built frontend from Stage 1
COPY --from=frontend /app/public/dist ./public/dist

# Clear Laravel caches
RUN php artisan config:clear \
    && php artisan route:clear \
    && php artisan view:clear

# Expose PHP-FPM port
EXPOSE 9000

# Start PHP-FPM
CMD ["php-fpm"]
