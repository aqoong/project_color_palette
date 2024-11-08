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

## License

MIT License

Copyright (c) 2024 AQoong(cooldnjsdn@gmail.com)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.