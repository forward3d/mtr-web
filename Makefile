build:
	docker build . -t mtr-web

run:
	docker run -it --rm -p 8000:8000 mtr-web:latest

.PHONY: build
