all: cleanup dc-slides dc-pdf dc-epub dc-docbook

cleanup:
	rm -rf docs;

prepare:
	mkdir -p docs/fragments/assets
move-assets:
	cp -r _content/fragments/assets docs/fragments;

dc-slides: prepare move-assets
	docker compose run --rm build-slides;
dc-pdf:
	docker compose run --rm build-pdf
dc-epub:
	docker compose run --rm build-epub
dc-docbook:
	docker compose run --rm build-docbook
dc-docx:
	docker compose run --rm build-docx

all-no-docker: slides pdf epub docbook docx

slides: prepare move-assets
	asciidoctor-revealjs -a revealjsdir=https://cdnjs.cloudflare.com/ajax/libs/reveal.js/3.9.2 _content/index.adoc -o docs/index.html; rm -rf docs/fragments/assets; cp -r _content/fragments/assets docs/fragments
pdf:
	asciidoctor-pdf -a toc _content/index.adoc -o docs/output.pdf
epub:
	asciidoctor-epub3 _content/index.adoc -o docs/output.epub
docbook:
	asciidoctor -b docbook _content/index.adoc -o docs/output.docbook.xml
docx:
	./generate-docx.sh

# In CI, all asciidoctor make targets can be launched from the docker image : `asciidoctor/docker-asciidoctor`
ci-adoc: slides pdf epub docbook

