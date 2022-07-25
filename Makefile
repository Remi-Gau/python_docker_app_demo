.PHONY: Dockerfile

## DOCKER

Dockerfile:
	docker run --rm repronim/neurodocker:0.7.0 generate docker \
	--base python:3.9-buster \
	--pkg-manager apt \
	--run "mkdir -p /home/neuro/my_app" \
	--copy . /home/neuro/my_app \
	--workdir /home/neuro/my_app \
	--run "pip install -r requirements.txt" \
	--run "pip install ." \
	--entrypoint my_app \
	> Dockerfile

# --user neuro 
Docker_build: Dockerfile
	docker build --tag my_app:dev --file Dockerfile .

Docker_build_no_cache: Dockerfile
	docker build --tag my_app:dev --no-cache --file Dockerfile .
