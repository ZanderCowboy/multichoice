# [Create Dev Container](https://github.com/ZanderCowboy/multichoice/issues/36)

## Ticket: [36](https://github.com/ZanderCowboy/multichoice/issues/36)

### branch: `create-dev-container`

### Overview

### What was done

- [X] Create `devcontainer.json` file and add basic functionality
- [X] Create `Dockerfile` file and add basic functionality
- [X] Create `postCreateCommand` file to run after building devcontainer
- [X] Add `Flutter stable 3.16.9`  to Dockerfile
- [X] Investigate and add `Android SDK` to Dockerfile
- [X] Investigate and add `Java` to Dockerfile
- [ ] Code cleanup
- [X] Added `.markdownlint.json` ([Markdownlink Configure](https://github.com/DavidAnson/vscode-markdownlint#configure))

### What needs to be done

- [ ] When trying to run `java --version`, it still fails and returns
```sh
qemu-arm: Could not open '/lib/ld-linux-armhf.so.3': No such file or directory
```
as an error.
* [Adoptium Java Binaries Repository](https://github.com/adoptium/temurin17-binaries/releases)
* [Steps to Install Openjdk 17 ubuntu Linux such as 22.04 or 20.04
](https://linux.how2shout.com/steps-to-install-openjdk-17-ubuntu-linux-such-as-22-04-or-20-04/)

- [ ] Investigate and find out how to add `Google Chrome` or something similar
 in the `devcontainer`
- [ ] Investigate if it is possible to build `Dockerfile` before running the
 `devcontainer` which effectively enables the docker image not to be destroyed
 when the devcontainer is closed.
In the `.devcontainer` file:

```json
{
...
"image": "multichoice:androidsdk",
OR
"build": {
    "dockerfile": "Dockerfile"
},
...
}
```

### Resourses and References

- [Dev Containers Json](https://containers.dev/implementors/json_reference/)
- [Docker Docs](https://docs.docker.com/engine/reference/builder/)
- [VS Code: User and Workspace Settings](https://code.visualstudio.com/docs/getstarted/settings#:~:text=To%20modify%20user%20settings%2C%20you,keyboard%20shortcut%20(Ctrl%2B%2C).)
- [VS Code: Terminal Shell Integration](https://code.visualstudio.com/docs/terminal/shell-integration)
- [Using Images, Dockerfiles, and Docker Compose](https://containers.dev/guide/dockerfile)
- [VS Code: Create a Dev Container](https://code.visualstudio.com/docs/devcontainers/create-dev-container)
- [Docker CMD](https://docs.docker.com/engine/reference/builder/#cmd)
- [Supporting tools and services](https://containers.dev/supporting)
