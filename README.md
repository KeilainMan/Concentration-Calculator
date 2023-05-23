# Concentration-Calculator
 
## Purpose 

This program shall provide an alternative environment for LC-MS concentration calculation. A commen way to access and calculate compound concentrations from LC-MS meassurements is through excel. Although excel provides a quick and accessable workflow, it sometimes is not as user friendly and one can quickly loose overview through a lack of visibility. 
This calculator shall provide visibility and security and personal confidence through standardization when calculating compound concentrations.

## Disclaimer

This calculator is in build-up phase! The methods were only tested with provided test datasets until now. In internal tests the calculation process worked, but it is advised to check your results with other calculation methods in the beginning to assure yourself. Further see known bugs.

## Feature-Checkpoints v.1.0

 - [x] loading data from txt files (tab delimited)
 - [x] viewing data in speadsheet format
 - [x] generate calculation presets for customized workflows and metabolite sets (Internal Standard)
 - [x] generate calculation presets for customized workflows and metabolite sets (Calibration Curve)
 - [x] saving of customized presets
 - [x] customizable "quick preset" option for fast preset access
 - [x] calculation of metabolite concnetrations with Internal Standard method
 - [x] calculation of metabolite concentrations with Calibration Curve method
 - [x] export results as txt (tab delimited)
 
## future checkpoints
 
 - [ ] QOL feature: displaying the rownumbers
 - [ ] QOL feature: adding selectable curve concentrations in table format
 - [ ] show live summary of all tabs for personal confirmation
 - [ ] export summary of all tabs for personal confirmation
 - [ ] support of more import formats
 - [ ] support of more export formats
 - [ ] additional calibration methods(?)
 
## How to use
Download the release .exe and .pck and put them together in a folder. It is advisable to have an purposeful folder structure for quicker access of made presets and data.
Follow the instructions using your own data or the provided test data. To use the test data download "TestDataIS.txt" and "TestDataCC" from the test_data folder for presets download "phytohormones.tres" and "PAOx.tres" form the preset folder, respectivle. Both folder can be fonud in the repository.  

### Open your data
Open your file through the open file menu dialog. You can only open tab delimited txt files. After opening it should be visible in the left part of the window, as spreadsheet format. Only the currently displayed data is loaded for calculation.

### New preset
Make a new preset for calculation through the corresponding menu dialog. A new tab called "Main" should open where general information can be put.

### Load preset
To load a preset choose a .tres file through the file dialog. 

### Prepare your  preset
For calculation several information are necessary. In the "Main" tab the extraction volume and your masses column name must be provided. 
For Internal Standard Tabs you must provide IS concentration, response factor and column name of your sample data.
For Calibration Curve Tabs you must provide column name, the known curve concentrations, and in which rows of the dataset you can find them. Select a proper linear regression fit (curve style). Confirm your entrys with the provided plot. 

### Save your preset
If you want to save your preset, do so through the corresponding menu file dialog. you do not need to append .tres.

### Calculate your sample concentrations. 
If you finished your preset properties, click the calculation button on the top right of the window. You need to choose a filename and path. where to store your calculations. After calculation a tab delimited .txt file will be generated. 

## Known Bugs

1. Loading a preset on a existing preset changes tab names (reason: no duplicates allowed). This should not impact calculation
2. Provided datapoints in the plot of CC Tabs seem to be off sometimes. This should not impact calculations as long as they are inserted correctly.
3. R^2 value of linear regression with intercept through the origin is wrong. This does not impact calculations. The value is solely for validation purpose.
