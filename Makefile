build:
	docker build . -t forward3d/mtr-web

run:
	docker run -it --rm -p 8000:8000 forward3d/mtr-web:latest

.PHONY: build
