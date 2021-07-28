# Latime

Helps you to keep out of mind the number of days left until an important date. Now with uberpower of splitting these dates on phases.

## Specs
- UIIkit with no storyboard
- VIPER architecture
- CoreData as a persistent storage
- URLSesion as a networking tool
- ~~Unsplash API provides visual notations~~ (excluded temporarily)
- ~~SwiftLynt with Cocoapods as codestyle enforcer~~ (removed temporarily)
- Russian/English localization

## Glance timepoints screen
- Animated indicator is made using CALayer
- Classic UITableView with DataSource and Delegate implementation
- Includes Interactor CoreData UnitTests
    
## Inspector screen
#### Features
- Messenger-style input row
- Unsplash image picker with targeted preview
- View - View comunication implemented using closures
- View - ViewController communication works using Delegates
- Layouted using ModernCollectionView and Diffable DataSource 

#### Image Picker
- Unsplash picker works using URLSession
- Image passing between VC implemented using NSNotification

## Inline phases screen
- ModernCollectionView and Diffable DataSource 
