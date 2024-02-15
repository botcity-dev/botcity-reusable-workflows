
# Botcity Reusable Workflows


To facilitate the implementation of workflows shared by all botcity projects, it is necessary to include it in this project, for example the ci, linter and publish in pypi workflows.
## Available workflows

| Name            | Language | Arguments                                                                         | Secrets          | Description                            |
|-----------------|----------|-----------------------------------------------------------------------------------|------------------|----------------------------------------|
| **ci**          | python   | list_os_name, list_python_version                                                 |                  | Run tests in pytest                    |
| **linter**      | python   | flake8, mypy, list_os_name, list_python_version, docstring, docstring_convention  |                  | Run flake8, mypy and flake8-docstring. |
| **pypi_upload** | python   |                                                                                   | PYPI_API_TOKEN   | Build package and publish in pypi      |



## Using reusable workflows example

## Workflows
### Python
#### ci
Using values default:

```yml
name: ci

on:
  push:
  pull_request:

jobs:
    ci:
      uses: botcity-dev/botcity-reusable-workflows/.github/workflows/python_ci.yml@latest

```
Using passing the arguments:

| Name                | Description                          | Default             | Required |
|---------------------|--------------------------------------|---------------------|----------|
 | list_os_name        | List os name to use in matrix        | "['ubuntu-latest']" | false    | 
| list_python_version | List version python to use in matrix | "['3.9', 3.12']"    | false    |

```yml
name: ci

on:
  push:
  pull_request:

jobs:
    ci:
      uses: botcity-dev/botcity-reusable-workflows/.github/workflows/python_ci.yml@latest
      with: 
          list_os_name: "['ubuntu-latest', 'windows-latest']"
          list_python_version: "['3.9', '3.10', '3.12']"
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
      uses: botcity-dev/botcity-reusable-workflows/.github/workflows/python_linter.yml@latest

```
Using passing the arguments:

| Name                 | Description                          | Default             | Required |
|----------------------|--------------------------------------|---------------------|----------|
 | list_os_name         | List os name to use in matrix        | "['ubuntu-latest']" | false    | 
| list_python_version  | List version python to use in matrix | "['3.9']"           | false    |
 | mypy                 | Execute mypy or no                   | false               | false    |
 | flake8               | Execute flake8 or no                 | true                | false    | 
 | docstring            | Execute flake8-docstring or no.      | false               | false    |
 | folder               | Folder to execute flake8 and mypy    | "botcity"           | false    |
 | docstring_convention | Convention that will be used.        | "google"            | false    | 



```yml
name: linter

on:
  push:
  pull_request:

jobs:
    linter:
      uses: botcity-dev/botcity-reusable-workflows/.github/workflows/python_linter.yml@latest
      with: 
          list_os_name: "['ubuntu-latest', 'windows-latest']"
          list_python_version: "['3.9', '3.12']"
          flake8: true 
          mypy: true
          folder: "botcity"
          docstring: true
          docstring_convention: "google"
```

#### Pypi upload

Using secrets required:

| Name                | Description          | Default | Required   |
|---------------------|----------------------|---------|------------|
 | PYPI_API_TOKEN      | Token to upload pipy |         | ** true ** | 

```yml
name: Publish Python distributions to PyPI

on:
  release:
    types: [published]

jobs:
    pypi_upload:
      uses: botcity-dev/botcity-reusable-workflows/.github/workflows/python_pypi_upload.yml@latest
      with:
        list_version: "['3.9', '3.8']"
        secrets: inherit # Or ${{ secrets.PYPI_API_TOKEN }}
```