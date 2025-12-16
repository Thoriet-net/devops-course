.PHONY: help venv install lint run clean

VENV=.venv
PY=$(VENV)/bin/python
PIP=$(VENV)/bin/pip

help:
	@echo "Targets:"
	@echo "  make venv     - create virtual environment"
	@echo "  make install  - install dependencies"
	@echo "  make run      - run the tool"
	@echo "  make lint     - lint the code"
	@echo "  make clean    - remove venv"

venv:
	python3 -m venv $(VENV)

install: venv
	$(PIP) install --upgrade pip
	$(PIP) install -r requirements.txt

run:
	$(PY) src/main.py

clean:
	rm -rf $(VENV)
lint:
	$(VENV)/bin/ruff check src	