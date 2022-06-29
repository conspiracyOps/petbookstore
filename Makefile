DOCKER_FOLDER  = cd docker;
DOCKER_COMPOSE = $(DOCKER_FOLDER) docker-compose
EXEC_PHP       = $(DOCKER_COMPOSE) exec php-fpm

prod-build: dc-build init-prod
dev-build: dc-build init-dev
init-dev: dc-down dc-up composer-i migrate jwt-ssl-key-generate swagger-generate clear-cache
init-prod: dc-down dc-up composer-i migrate jwt-ssl-key-generate clear-cache

dc-build:
	$(DOCKER_COMPOSE) build postgres php-fpm nginx

dc-up:
	$(DOCKER_COMPOSE) up -d postgres php-fpm nginx

dc-down:
	$(DOCKER_COMPOSE) down

bash:
	$(EXEC_PHP) bash

fixtures:
	$(EXEC_PHP) sh -c "cd backend; php bin/console doctrine:fixtures:load --no-interaction"

test:
	$(EXEC_PHP) sh -c "cd backend; APP_ENV=test php bin/phpunit"

composer-i:
	$(EXEC_PHP) sh -c "cd backend; composer install"

clear-cache:
	$(EXEC_PHP) bash -c "cd backend; rm -rf var"

test-init:
	$(EXEC_PHP) sh -c "cd backend; php bin/console doctrine:database:drop --env=test --force --if-exists; php bin/console doctrine:database:create --env=test --ansi; php bin/console  doctrine:schema:creat --env=test;"

migrate:
	$(EXEC_PHP) sh -c "cd backend; php bin/console doctrine:migrations:migrate --no-interaction"

migrate-diff:
	$(EXEC_PHP) sh -c "cd backend; php bin/console doctrine:migrations:diff"

nginx-restart:
	cd docker; docker exec -it nginx sh -c "nginx -t && nginx -s reload"

swagger-generate:
	$(EXEC_PHP) sh -c "./backend/vendor/bin/openapi /var/www/backend/src -o /var/www/api/openApi/swagger.json"

jwt-ssl-key-generate:
	$(EXEC_PHP) sh -c "cd backend; php bin/console lexik:jwt:generate-keypair --skip-if-exists"

admin-install:
	$(EXEC_PHP) sh -c "cd admin; yarn install"

admin-watch:
	$(EXEC_PHP) sh -c "cd admin; yarn start"

admin-build:
	$(EXEC_PHP) sh -c "cd admin; yarn build"