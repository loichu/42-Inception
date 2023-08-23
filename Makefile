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

up:
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

build:
	$(DKC) build --no-cache

install: volumes build
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

clean: down clean-containers clean-volumes clean-images info
fclean: down clean-containers fclean-volumes fclean-images info
re: down clean all
reset-all: fclean install all logs
