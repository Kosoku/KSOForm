## KSOForm

**This project is archived, we recommend you use [Eureka](https://github.com/xmartlabs/Eureka) instead.**

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](http://img.shields.io/cocoapods/v/KSOForm.svg)](http://cocoapods.org/?q=KSOForm)
[![Platform](http://img.shields.io/cocoapods/p/KSOForm.svg)]()
[![License](http://img.shields.io/cocoapods/l/KSOForm.svg)](https://github.com/Kosoku/KSOForm/blob/master/license.txt)

*KSOForm* is an iOS/tvOS framework for constructing and displaying views similar to Settings app or the Add Event sheet in the Calendar app. It provides value classes (`KSOFormModel`, `KSOFormSection`, and `KSOFormRow`) that represent a form. It also provides a `UITableViewController` subclass, `KSOFormTableViewController` that owns and displays an instance of `KSOFormModel`. It provides default classes that handle the display of the following controls:

- `UIImageView`
- `UILabel`
- `UITextField`
- `UITextView`
- `UISwitch`
- `UIPickerView`
- `UIDatePicker`
- `UIStepper`
- `UISlider`
- `UIButton`
- `UISegmentedControl`

It can push or modally present additional forms and custom view controller classes easily. It supports custom table view header, footer, section header, section footer, and cells. It supports validation and formatting of text input.

Demo icons by [Glyphish](http://www.glyphish.com/).

![iOS](screenshots/iOS.gif)

### Installation

You can install *KSOForm* using [cocoapods](https://cocoapods.org/), [Carthage](https://github.com/Carthage/Carthage), or as a framework.

When installing as a framework, ensure you also link to [Stanley](https://github.com/Kosoku/Stanley), [Ditko](https://github.com/Kosoku/Ditko), [Loki](https://github.com/Kosoku/Loki), [Agamotto](https://github.com/Kosoku/Agamotto), [Quicksilver](https://github.com/Kosoku/Quicksilver), [KSOTooltip](https://github.com/Kosoku/KSOTooltip), [KSOFontAwesomeExtensions](https://github.com/Kosoku/KSOFontAwesomeExtensions), and [KSOTextValidation](https://github.com/Kosoku/KSOTextValidation) as *KSOForm* relies on them.

### Dependencies

Third party:

- [Stanley](https://github.com/Kosoku/Stanley)
- [Loki](https://github.com/Kosoku/Loki)
- [Ditko](https://github.com/Kosoku/Ditko)
- [Agamotto](https://github.com/Kosoku/Agamotto)
- [Quicksilver](https://github.com/Kosoku/Quicksilver)
- [KSOTooltip](https://github.com/Kosoku/KSOTooltip)
- [KSOTextValidation](https://github.com/Kosoku/KSOTextValidation)
- [KSOFontAwesomeExtensions](https://github.com/Kosoku/KSOFontAwesomeExtensions)