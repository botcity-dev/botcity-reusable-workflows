
# Botcity Reusable Workflows


To facilitate the implementation of workflows shared by all botcity projects, it is necessary to include it in this project, for example the ci, linter and publish in pypi workflows.
## Available workflows

| Name                   | Language | Arguments                                                                             | Secrets        | Description                                 |
| ---------------------- | -------- | ------------------------------------------------------------------------------------- | -------------- | ------------------------------------------- |
| **python_ci**          | python   | list_os_name, list_python_version                                                     |                | Run tests in pytest                         |
| **python_linter**      | python   | flake8, mypy, list_os_name, list_python_version, docstring, docstring_convention      |                | Run flake8, mypy and flake8-docstring.      |
| **python_pypi_upload** | python   |                                                                                       | PYPI_API_TOKEN | Build package and publish in pypi           |
| **docker-scan**        | docker   | docker-file, docker-image, build-command, with-maven, java-version, java-distribution, with-aws-login, aws-region, aws-ecr-registry, ignore-vulnerabilities |                | Run Docker vulnerability check using Grype. |


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
| ------------------- | ------------------------------------ | ------------------- | -------- |
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
| -------------------- | ------------------------------------ | ------------------- | -------- |
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

### Docker
#### docker-scan

Using values default:

```yml
name: docker-scan

on:
  pull_request:
  schedule:
    - cron: '0 8 * * 1'

jobs:
  scan:
    uses: botcity-dev/botcity-reusable-workflows/.github/workflows/docker-scan.yml@latest
    with:
      docker-image: my-image:latest
      build-command: docker build -t my-image:latest .
```

Using passing the arguments:

| Name                    | Description                                                                 | Default         | Required |
| ----------------------- | --------------------------------------------------------------------------- | --------------- | -------- |
| docker-file             | Dockerfile path                                                             | `Dockerfile`    | false    |
| docker-image            | Docker image name to scan                                                   |                 | **true** |
| build-command           | Command to build the Docker image                                           |                 | **true** |
| with-maven              | Whether to set up JDK/Maven before building                                 | `false`         | false    |
| java-version            | Java version to use (requires `with-maven: true`)                           | `21`            | false    |
| java-distribution       | Java distribution to use (requires `with-maven: true`)                      | `temurin`       | false    |
| with-aws-login          | Whether to authenticate with AWS ECR before building                        | `false`         | false    |
| aws-region              | AWS region (requires `with-aws-login: true`)                                | `us-east-1`     | false    |
| aws-ecr-registry        | AWS ECR registry URL (requires `with-aws-login: true`)                      | `NOT SET`       | false    |
| ignore-vulnerabilities  | Comma-separated list of additional CVE IDs to ignore. `CVE-2026-22184` is always ignored by default. | `''` | false    |

```yml
name: docker-scan

on:
  pull_request:
  schedule:
    - cron: '0 8 * * 1'

jobs:
  scan:
    uses: botcity-dev/botcity-reusable-workflows/.github/workflows/docker-scan.yml@latest
    with:
      docker-image: my-image:latest
      build-command: docker build -t my-image:latest .
      ignore-vulnerabilities: 'CVE-2023-1234,CVE-2024-5678'
```

#### Pypi upload

Using secrets required:

| Name           | Description          | Default | Required   |
| -------------- | -------------------- | ------- | ---------- |
| PYPI_API_TOKEN | Token to upload pipy |         | ** true ** |

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