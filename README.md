
# Botcity Reusable Workflows


To facilitate the implementation of workflows shared by all botcity projects, it is necessary to include it in this project, for example the ci, linter and publish in pypi workflows.
## Available workflows

| Name              | Language  | Arguments | Description|
| ----------------- |-----------|-----------|------------|
| ci | python | list_os, list_version | Run tests in pytest |
| linter | python | flake8, mypy, list_os, list_version | Run flake8 and mypy.|
| pypi_upload | python | version_python | Build package and publish in pypi |



## Using reusable workflows example

## Workflows
### Python
#### ci
Using values default
```yml
name: ci

on:
  push:
  pull_request:

jobs:
    ci:
      uses: botcity-dev/botcity-reusable-workflows/.github/workflows/python/ci.yml@main

```
Using passing the arguments.

- list_os: List os to use in matrix. Default: "['ubuntu-latest']"
- list_version: List versions to use in matrix. "['3.7', 3.11']"

```yml
name: ci

on:
  push:
  pull_request:

jobs:
    ci:
      uses: botcity-dev/botcity-reusable-workflows/.github/workflows/python/ci.yml@main
      with: 
          list_os: "['ubuntu-latest', 'windows-latest']"
          list_version: "['3.7', '3.10', 3.11']"
```

#### Linter
Using values default:

```yml
name: linter

on:
  push:
  pull_request:

jobs:
    linter:
      uses: botcity-dev/botcity-reusable-workflows/.github/workflows/python/linter.yml@main

```
Using passing the arguments:

- list_os: List os to use in matrix. Default: "['ubuntu-latest']"
- list_version: List versions to use in matrix. Default: "['3.7']"
- mypy: Execute mypy or no. Default: false
- flake8: Execute flake8 or no. Default: true
- folder: Folder to execute flake8 and mypy. Default: "botcity"

```yml
name: linter

on:
  push:
  pull_request:

jobs:
    linter:
      uses: botcity-dev/botcity-reusable-workflows/.github/workflows/python/linter.yml@main
      with: 
          list_os: "['ubuntu-latest', 'windows-latest']"
          list_version: "['3.7', '3.11']"
          flake8: true 
          mypy: true
          folder: "botcity"
```

#### Pypi upload
Using values default:

```yml
name: Publish Python distributions to PyPI

on:
  release:
    types: [published]

jobs:
    pypi_upload:
      uses: botcity-dev/botcity-reusable-workflows/.github/workflows/python/pypi_upload.yml@main

```
Using passing the arguments:

- list_version: List versions to use in matrix. Default:  "['3.7']"

Using secrets required:
- PYPI_API_TOKEN


```yml
name: Publish Python distributions to PyPI

on:
  release:
    types: [published]

jobs:
    pypi_upload:
      uses: botcity-dev/botcity-reusable-workflows/.github/workflows/python/pypi_upload.yml@main
      with:
        list_version: "['3.7', '3.8']"
        secrets: inherit # Or ${{ secrets.PYPI_API_TOKEN }}
```