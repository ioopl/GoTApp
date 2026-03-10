# About

This is an iOS App for the Game of Thrones characters.

# Installation guide

This project uses Xcode 16.2

## To check the Response run teh command to see the real JSON from the API printed in console.

```bash
curl -m 10 -H 'Authorization: Bearer 754t!si@glcE2qmOFEcN' \
https://yj8ke8qonl.execute-api.eu-west-1.amazonaws.com/characters | head -c 1000
```

or run the test

```bash
xcodebuild test -project GoTApp.xcodeproj -scheme GoTApp -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing GoTAppTests/NetworkIntegrationTests
```

## Installation

```bash

```
