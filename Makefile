.PHONY: install notebook test lint report

install:
	python -m pip install -r requirements.txt

notebook:
	jupyter lab

test:
	pytest -q

lint:
	ruff check src tests

report:
	jupyter nbconvert \
		--to html \
		--execute \
		notebooks/03_executive_report.ipynb