# project_color_palette

This package is a tool for collaboration between designers and Flutter developers. csv to color_palette

### Feature
* Generates Dart objects to access CSV files located in the assets folder.

## How to Use
1. Place CSV files in the `assets/color_palette` folder. The CSV file names must contain "color".
2. Run `flutter pub run build_runner build` in the terminal to generate Dart classes.
3. The class files are stored in the `lib/palette` folder and have a '.g.dart' extension.

The format of the CSV is as follows:
```
name,value,Comment,,,
White,#FFFFFF,Comment test,,,
```
![Excel format](https://aqoong.github.io/readme-assets/project_color_palette/example_excel_image.png)