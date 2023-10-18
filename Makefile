IMAGES_URL=https://cloud.uni-hamburg.de/s/ZndexSjSH9ZqxTG/download
IMAGES_ARCHIVE=version-control-course.zip
IMAGES_DIR=images/

.PHONY: preview
preview:
	quarto preview

.PHONY: deploy
deploy: clean
	quarto publish gh-pages

.PHONY: images
images:
	wget $(IMAGES_URL) -O $(IMAGES_ARCHIVE)
	unzip -j -o $(IMAGES_ARCHIVE) -d $(IMAGES_DIR)
	rm -f $(IMAGES_ARCHIVE)

.PHONY: clean
clean:
	rm -rf _site $(IMAGES_DIR)*
