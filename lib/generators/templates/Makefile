GO := go
MYAPP := myapp
IMAGE := $(MYAPP)
TAG := latest

$(MYAPP):
	$(GO) build -o $(MYAPP)

clean:
	-rm $(MYAPP)

build: $(MYAPP)
	@:

deps:
	$(GO) get -u github.com/jmoiron/sqlx \
		github.com/gin-gonic/gin \
		github.com/railstack/go-sqlite3 \
		github.com/go-sql-driver/mysql \
		github.com/lib/pq \
		github.com/asaskevich/govalidator

test:
	$(GO) test -v ./...

run: $(MYAPP)
	./$(MYAPP)

image: clean
	docker build -t $(USER)/$(IMAGE):$(TAG) .

.PHONY: build clean deps test run image
