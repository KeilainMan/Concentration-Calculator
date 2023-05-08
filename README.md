# Concentration-Calculator
 
## Purpose 

This program shall provide an alternative environment for LC-MS concentration calculation. A commen way to access and calculate compound concentrations from LC-MS meassurements is through excel. Although excel provides a quick and accessable workflow, it sometimes is not as user friendly and one can quickly loose overview through a lack of visibility. 
This calculator shall provide visibility and security and personal confidence through standardization when calculating compound concentrations.

## Disclaimer

This calculator is in build-up phase and does only provide calculations through internal standard method! In internal tests the calculation process worked, but it is advised to check your results with other calculation methods in the beginning to assure yourself. 

## Feature-Checkpoints

 - [x] loading data from txt files (tab delimited)
 - [x] viewing data in speadsheet format
 - [x] generate calculation presets for customized workflows and metabolite sets (Internal Standard)
 - [x] generate calculation presets for customized workflows and metabolite sets (Calibration Curve)
 - [x] saving of customized presets
 - [ ] integration of premade presets
 - [x] calculation of metabolite concnetrations with Internal Standard method
 - [ ] calculation of metabolite concentrations with Calibration Curve method
 - [x] export results as txt (tab delimited)
 
## possible extension Checkpoints
 
 - [ ] support of more import formats
 - [ ] support of more export formats
 - [ ] additional calibration methods(?)
 
## How to use

Clone the repository or download as zip and extract in a folder. Open "ConcentrationCalculator.exe" int the export folder. Follow the instructions using your own data or the provided test data. For the test data use "data_raw.txt" ind the test_data folder and as a preset "phytohormones.tres" from the preset folder. 

### Open your data
Open your file through the open file menu dialog. You can only open tab delimited txt files. After opening it should be visible in the left part of the window, as spreadsheet format. Only the currently displayed data is loaded for calculation.

### New preset
Make a new preset for calculation through the corresponding menu dialog. A new tab called "Main" should open where general information can be put.

### Load preset
To load a preset choose a .tres file through the file dialog. 

### Prepare your  preset
For calculation several information are necessary. In the "Main" tab the extraction volume and your masses column name must be provided. For Internal Standard Tabs you must provide IS concentration, response factor and column name of your sample data.

### Save your preset
If you want to save your preset, do so through the corresponding menu file dialog. you do not need to append .tres.

### Calculate your sample concentrations. 
If you finished your preset properties, click the calculation button on the top right of the window. You need to choose a filename and path. where to store your calculations. After calculation a tab delimited .txt file will be generated. 


