#!/bin/bash

# Install Flutter
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable --depth 1
fi

export PATH="$PATH:`pwd`/flutter/bin"

# Check Flutter version
flutter --version

# Get dependencies
flutter pub get

# Build web app
flutter build web --release
