# SwiftTemplate

The purpose of this project is to avoid repetition when creating a new swift project.
Every time I do the same things over and over again:

Create the project, delete the storyboards, make a clean architecture, add the SnapKit and SwiftLint pods, etc...

# Installation

1. Create a repository for your project

2. Clone this repository
```
git clone git@github.com:R3J3CT3D/SwiftTemplate.git
```
3. Move into SwiftTemplate
```
cd SwiftTemplate/
```
3. Mirror push into your repository

```
git push --mirror https://github.com/username/your-repository.git
```
4. From your repository, go to `SwiftTemplate/` and launch the `project-renamer` with the choosen name as argument
```
cd SwiftTemplate/

./swift-renamer.swift your-project-name
```
5. Double click on the `.xcworkspace`, if Xcode displays an error message such as `Cannot open file`, press `Ok`, then close Xcode and reopen the `.xcworkspace`

6. You're good to go!