#!/bin/sh

####################################
##       Get new project name     ##
####################################
echo Enter your project name:
read projectName


####################################
##        Check dependencies      ##
####################################
echo "- Check dependencies"

if ! command -v rename >/dev/null; then
    if ! command -v brew >/dev/null; then
        echo "\033[31mError: this script requires rename which requires Homebrew to be installed."
        echo "To install Homebrew launch see:"
        echo "\033[39mhttps://brew.sh/"
        echo
        exit 1
    else
        echo "\033[31mError: this script requires rename to work."
        echo "To install rename, launch the following command into your terminal:"
        echo "\033[39m$> brew install rename"
        echo
        exit 1
    fi
fi

if ! command -v rename >/dev/null; then
    if ! command -v brew >/dev/null; then
        echo "\033[31mError: this script requires SwiftLint which requires Homebrew to be installed."
        echo "To install Homebrew launch see:"
        echo "\033[39mhttps://brew.sh/"
        echo
        exit 1
    else
        echo "\033[31mError: this script requires SwiftLint to work."
        echo "To install rename, launch the following command into your terminal:"
        echo "\033[39m$> brew install swiftlint"
        echo
        exit 1
    fi
fi


####################################
##           Remove pods          ##
####################################
echo "- Remove pods"

rm -rf SwiftTemplate/Pods/


####################################
##  Rename directories and files  ##
####################################
echo "- Rename directories and files"

find . -not -path '*/\.*' -type d -d -execdir rename "s/SwiftTemplate/$projectName/" {} \;
find . -not -path '*/\.*' -type f -exec rename "s/SwiftTemplate/$projectName/" {} \;


####################################
##      Replace files content     ##
####################################
echo "- Replace files content"

unset LANG && find . -type f -exec sed -i '' -e "s/SwiftTemplate/$projectName/g" {} +


####################################
##          Install pods          ##
####################################
echo "- Install pods"

export LANG=en_US.UTF-8 && cd $projectName/ && pod install


####################################
##        Setup git hooks         ##
####################################
echo "- Setup git hooks"

git config core.hooksPath .githooks


####################################
##         Open xcworkspace       ##
####################################
echo "- Open project"

open ProjectName.xcworkspace


####################################
##         Autodestuction         ##
####################################
echo "- Autodestruction"$

rm ./setup.sh