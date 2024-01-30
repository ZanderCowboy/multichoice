#!/bin/bash

dart --disable-analytics

# Output a message indicating that telemetry has been disabled
echo "Telemetry for Dart and Flutter has been disabled."

# Run Flutter Pub Get
# flutter upgrade
echo "flutter pub get"
flutter pub get
echo "flutter pub outdated"
flutter pub outdated

echo "git config --global --list"
git config --global --list

# Change .gitconfig
git config --global user.name "ZanderCowboy"
git config --global user.email "zanderkotze99@gmail.com"
git config --global core.sshCommand "ssh -i /home/developer/.ssh/personal_github"

# Change HTTPS to SSH
echo "git remote -v"
git remote -v
echo "git remote set-url origin 'git@github.com:<your-username>/<repository>.git'"
git remote set-url origin git@github.com:ZanderCowboy/multichoice.git

echo "git config --global --list"
git config --global --list

git config --global --add safe.directory /workspaces/multichoice
