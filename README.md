# SwiftTemplate

The purpose of this project is to avoid repetition when creating a new swift project.
Every time I do the same things over and over again:

Create the project, delete the storyboards, make a clean hierarchy, add the SnapKit and SwiftLint pods, etc...

# Informations

This template includes the following features:
- A clean folder hierarchy
- No storyboards
- SwiftLint
- SnapKit for constraints
- Convenient extensions (See [Extensions/](https://github.com/R3J3CT3D/SwiftTemplate/tree/master/SwiftTemplate/Helpers/Extensions))
- And many others...

# Installation

1. Press the `Use this template` button at the top of this page (See: [Creating a repository from a template](https://help.github.com/en/github/creating-cloning-and-archiving-repositories/creating-a-repository-from-a-template))

2. From your repository, launch the `setup` script with the choosen name as argument
```
./setup.swift MyProjectName
```

3. You're good to go!

# Troubleshooting

If Xcode display an error message such as `Cannot open file` while opening the `.xcworkspace`, press `Ok`, then close Xcode and reopen the `.xcworkspace`

# Credits

`setup.swift` is based on [Xcode Project Renamer](https://github.com/appculture/xcode-project-renamer) by [appculture](https://github.com/appculture)
