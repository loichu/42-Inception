include srcs/.env
export

COMPOSE_DIR = srcs
COMPOSE_FILE = $(COMPOSE_DIR)/docker-compose.yml

BIN = docker compose
ARGS = -f $(COMPOSE_FILE)
DKC = $(BIN) $(ARGS)
DKC_CONFIG = $(DKC) config

COMPOSE_PROJECT_NAME ?= $(COMPOSE_DIR)
HOST_VOLUME_ROOT ?= /home/$(USER)/data

VOLUME_MOUNTS = wordpress mariadb
VOLUME_PATHS = $(addprefix $(HOST_VOLUME_ROOT)/, $(VOLUME_MOUNTS))
VOLUME_NAMES = $(addprefix	$(COMPOSE_PROJECT_NAME)_, \
							$(shell $(DKC_CONFIG) --volumes))  

IMAGES = $(shell $(DKC_CONFIG) --images)

all: install

$(COMPOSE_DIR)/.env:
	@echo Please create .env file by copying and modifying $(COMPOSE_DIR)/.sample.env
	exit 1

up: $(COMPOSE_DIR)/.env
	$(DKC) up -d

down:
	$(DKC) down --remove-orphans

logs:
	$(DKC) logs -f

volumes:
	mkdir -p $(VOLUME_PATHS)

info:
	@echo -e "IMAGES:"
	@$(DKC_CONFIG) --images
	@echo -e "\nVOLUMES:"
	@$(DKC_CONFIG) --volumes
	@echo -e "\nCONTAINERS:"
	@$(DKC) ps -a

build: $(COMPOSE_DIR)/.env
	$(DKC) build --no-cache

build-quick: $(COMPOSE_DIR)/.env
	$(DKC) build

install: $(COMPOSE_DIR)/.env volumes build
	$(DKC) create
	@$(MAKE) -s info
	@$(MAKE) -s up

clean-volumes:
	-docker volume rm $(VOLUME_NAMES)

fclean-volumes: clean-volumes
	sudo rm -rf $(VOLUME_PATHS)

clean-images:
	-docker rmi -f $(IMAGES)

fclean-images:
	-docker rmi -f $(IMAGES)

clean-containers:
	$(DKC) kill --remove-orphans
	$(DKC) rm -f

reload-nginx:
	$(DKC) build nginx
	$(DKC) create nginx
	$(DKC) start nginx

nginx-logs:
	$(DKC) exec nginx tail -f /var/log/nginx/access.log /var/log/nginx/error.log

clean: down clean-containers clean-volumes clean-images info
fclean: down clean-containers fclean-volumes fclean-images info
re: down clean all
reset-all: fclean all
re-quick: down build-quick up
