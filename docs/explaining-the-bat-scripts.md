# BAT scripts

Scripts that are used for integration testing. It can be used to have a all-in-one solution to start an emulator, run the integration test, and close the emulator afterwards.

> Note: The scripts are buggy and might not run. It is still in development.

- Found in `.scripts/` folder in root

## run_all.bat

- This script uses the two scripts `run_integration_test` and `run_shutdown_emulator`.

## run_integration_test.bat

- This looks for any existing open emulators to use. If none is found, it will open an Android Emulator. After starting an emulator, it will run the integration tests.

## run_shutdown_emulator.bat

- This will look for any running emulator instances and close them off.
