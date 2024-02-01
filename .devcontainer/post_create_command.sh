#!/bin/bash

dart --disable-analytics
echo "Telemetry for Dart and Flutter has been disabled."


flutter pub get
echo "flutter pub get"
flutter pub outdated
echo "flutter pub outdated"

# Change .gitconfig
git config --global user.name "ZanderCowboy"
git config --global user.email "zanderkotze99@gmail.com"
git config --global core.sshCommand "ssh -i /home/developer/.ssh/personal_github"

# Change HTTPS to SSH
git remote -v
echo "git remote -v"
git remote set-url origin git@github.com:ZanderCowboy/multichoice.git
echo "git remote set-url origin 'git@github.com:ZanderCowboy/multichoice.git'"

git config --global --list
echo "git config --global --list"

git config --global --add safe.directory /workspaces/multichoice
