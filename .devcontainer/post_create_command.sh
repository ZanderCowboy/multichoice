#!/bin/bash

# chown -R developer:developer /workspaces/multichoice
# ls -l /workspaces/multichoice

# mkdir -p /home/developer/.ssh
# cp ~/.ssh/personal_github /home/developer/.ssh/personal_github 
# chmod 600 /home/developer/.ssh/personal_github
# mkdir -p /home/developer/.ssh
# cp ~/.ssh/personal_github /home/developer/.ssh/personal_github
# echo $YOUR_PRIVATE_KEY_CONTENT > /home/developer/.ssh/personal_github
# echo 'YOUR_PUBLIC_KEY_CONTENT' > /home/developer/.ssh/personal_github.pub
# chmod 600 /home/developer/.ssh/personal_github"

# Disable telemetry for Dart and Flutter
dart --disable-analytics

# Output a message indicating that telemetry has been disabled
echo "Telemetry for Dart and Flutter has been disabled."

# Run Flutter Pub Get
# flutter upgrade
flutter pub get
flutter pub outdated

echo git status
git status

echo git config --global --list
git config --global --list

# Change .gitconfig
git config --global user.name "ZanderCowboy"
git config --global user.email "zanderkotze99@gmail.com"
git config --global core.sshCommand "ssh -i /home/developer/.ssh/personal_github"

# Change HTTPS to SSH
echo git remote -v
git remote -v
ehco git remote set-url origin 'git@github.com:<your-username>/<repository>.git'
git remote set-url origin git@github.com:ZanderCowboy/multichoice.git

echo git config --global --list
git config --global --list
