build:
ifndef HOST_URL
	$(error HOST_URL is not set. Usage: make build HOST_URL=https://yourdomain.com)
endif
	@if [ ! -f .env ]; then \
		echo "ERROR: .env file not found."; \
		echo "Copy one of the example files and edit it for your environment:"; \
		echo "  cp .env.example .env      # Full template with all options"; \
		echo "  cp .env.local_dev .env    # Quick-start local dev defaults"; \
		echo "Then edit .env and run make again."; \
		exit 1; \
	fi
	@echo "Building with HOST_URL=${HOST_URL}"
	@echo "Select Docker build type:"
	@echo "  1) image  - Pull pre-built images from Docker Hub"
	@echo "  2) source - Build from local source code"
	@read -p "Enter choice [1/2]: " choice; \
	if [ "$$choice" = "1" ]; then \
		cp docker-compose-image.yml docker-compose.yml; \
	elif [ "$$choice" = "2" ]; then \
		cp docker-compose-source.yml docker-compose.yml; \
	else \
		echo "Invalid choice"; exit 1; \
	fi
	cp .env .env.prod
	cd apps/OpenSign && cp ../../.env .env && npm install && npm run build
	HOST_URL=${HOST_URL} docker compose up --build --force-recreate

run:
ifndef HOST_URL
	$(error HOST_URL is not set. Usage: make run HOST_URL=https://yourdomain.com)
endif
	@if [ ! -f .env ]; then \
		echo "ERROR: .env file not found."; \
		echo "Copy one of the example files and edit it for your environment:"; \
		echo "  cp .env.example .env      # Full template with all options"; \
		echo "  cp .env.local_dev .env    # Quick-start local dev defaults"; \
		echo "Then edit .env and run make again."; \
		exit 1; \
	fi
	@echo "Building with HOST_URL=${HOST_URL}"
	@echo "Select Docker build type:"
	@echo "  1) image  - Pull pre-built images from Docker Hub"
	@echo "  2) source - Build from local source code"
	@read -p "Enter choice [1/2]: " choice; \
	if [ "$$choice" = "1" ]; then \
		cp docker-compose-image.yml docker-compose.yml; \
	elif [ "$$choice" = "2" ]; then \
		cp docker-compose-source.yml docker-compose.yml; \
	else \
		echo "Invalid choice"; exit 1; \
	fi
	cp .env .env.prod
	docker compose up -d
