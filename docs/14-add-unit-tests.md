# [Wrtie Unit Tests](https://github.com/ZanderCowboy/multichoice/issues/14)

## Coverage

As of now, the test coverage is at 90.3%.

## Setting up and Writing unit tests

- <https://marketplace.visualstudio.com/items?itemName=ryanluker.vscode-coverage-gutters>

## Setting up LCOV in Windows

- In an elevated terminal, use `choco install lcov` to install lcov
- Go to `"C:\ProgramData\chocolatey\lib\lcov\tools\bin\genhtml"` and add as System environment variable as `GENHTML`
- Install Strawberry Perl with <https://strawberryperl.com/>
- Add `perl` to PATH
- Open a new terminal in VS Code
- Change into directory where `coverage` folder lies
- Run `perl $env:GENHTML -o coverage\html coverage\lcov.info`
- In the same directory, use `start coverage\html\index.html` to open HTML file in a browser

### Running Tests on Windows

There is a `melos` command that can be used to get test coverage and open the report.
```bash
melos coverage:windows
```
