# [Create Packages for Models and Core](https://github.com/ZanderCowboy/multichoice/issues/98)

## Ticket: [98](https://github.com/ZanderCowboy/multichoice/issues/98)

### branch: `98-create-packages-for-models-and-core`

### Overview

This ticket was to set up `packages` and to separate our backend code from our frontend code, ensuring encapsulation and code maintainability

### What was done

- [X] Created `core` package and implemented code changes
- [X] Created `models` package and implemented code changes
- [X] After an issue with running `build_runner`, added `melos` and implemented it
- [X] Moved `app` files and UI code into `apps` folder as explained on the [getting started](https://melos.invertase.dev/getting-started) site of melos
- The new structure is as follows:
```sh
--- root
    --- apps
        --- multichoice
            --- android
            --- lib
            --- rest of the UI
    --- packages
        --- core
        --- models
    --- rest of the files
```
- [X] Fixed workflow files
- [X] Multiple file changes and clean up

### What needs to be done

- [ ] Create and implement `workflows` for the new packages

### Resources

- [Developing packages & plugins](https://docs.flutter.dev/packages-and-plugins/developing-packages)
- [Managing Multi-Package Flutter Projects with Melos — A Leap Towards Efficient Development](https://seniorturkmen.medium.com/managing-multi-package-flutter-projects-with-melos-a-leap-towards-efficient-development-a305e696fe73)
- [Melos - Getting Started](https://melos.invertase.dev/getting-started)
