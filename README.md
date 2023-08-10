# Concentration-Calculator v2.0.0

## Feature-Checkpoints

 - [x] loading data from txt files (tab delimited), xlsx, xls (never tested?)
 - [x] viewing data in speadsheet format
 - [x] generate calculation presets for customized workflows and metabolite sets (Internal Standard and Calibration Curve (mixable))
 - [x] saving of customized presets
 - [x] customizable "quick preset" option for fast preset access
 - [x] tableview for managing concentrations for calibration curve calculation
 - [x] calculation of metabolite concnetrations with Internal Standard method
 - [x] calculation of metabolite concentrations with Calibration Curve method
 - [x] live summary of all tabs for quick pre calculation access
 - [x] export results as txt (tab delimited), xlsx and xlsx with summary

## How does the calculator work?


### Main Menu
Open the main menu on the top left button:

![alt text](https://github.com/KeilainMan/Concentration-Calculator/blob/main/assets/readme_pics/main_menu.png "Main Menu")

First you need to load your data into the calculator.
 
### Data loading
Click the "Open sample file" button in the main menu.
Choose the file you want to open via file manager.
Your sample files can have one of the following configurations:

  1. Txt (tab delimited): Provide a txt file containing:
     1. A column with all sample names
     2. One column for each compound you want to calculate (usually peak area) with unique column name
        - If it is a compound that should be calculated by internal standard, add the internal standard column right behind it (usually peak area). Columnname not relevant
        - If the compound shall be calculated using a calibration curve just the column is sufficient, but provide your standards in there
     3. (Optional) A column for normalization (usually weight in mg)
     4. (Optional) A column for varying extraction volumes (usually in ml)
    ![alt text](https://github.com/KeilainMan/Concentration-Calculator/blob/main/assets/readme_pics/txt_file.PNG "Text File Example")
  2. Xlsx: Provide a xlsx file containing:
     1. A sheet for every compound you want to calculate. Sheetname should be unique
        - The sheet should contain a column with your meassured sample data (usually peak area)(columnname not nessasary, see Main-Tab explanation, header)
        - If you want a compound to be calculated using internal standard method provide a secon column in the sheet with meassured internal standard data (usually peak area)
        - If you want a compound to be calculated using a calibration curve one column is sufficient but be sure to add your concentrations
        - One sheet must contain a column with your sample names
     2. (Optional) A sheet for normalization (usually weight in mg)
     3. (Optional) A sheet for varying extraction volumes (usually in ml)
     See the provided test_data.
  3. Xlsx: Provide a xlsx file which is build like a txt file (1)


### Design your own custom preset
After loading your data you need to create or load a preset. For creating a new preset press the "New preset" button in the main menu. For loading click the "Open preset" button in the main menu

When you create a new preset, a basic main tab will be opened.
Fill in all nessasary fields (*):

  ![alt text](https://github.com/KeilainMan/Concentration-Calculator/blob/main/assets/readme_pics/main_tab_input_mode_1.PNG "Main Tab with Input Mode 1")

  - Series Name: Insert a name to identify your preset
  - Series Info: Insert some info, like compound classes
  - Varying extraction volumes: Select if your extraction volumes differs between samples
      - Yes: Extraction Volume Column Name: Insert the column or sheet name for a corresponding volume column
      - No: Extraction Volume: Insert your extraction volume in ml
  - Normalization: Decide if you want to normalize your data. Currently normalization can only be performed with masses in mg and returns values in ng/g
      - Yes: Normalization Column Name: Insert the column or sheet name for a corresponding masses column
  - Input Mode: Select your Input Mode. If you decide to use a file build like the above mentioned txt file, choose Input Mode 1. If you decide to use a file build like the above mentioned xlsx file,    choose Input Mode 2.
      - Input Mode 1: Sample Name Column: Insert the the column number, where to find your sample names.
      - Input Mode 2: Sample Name Column: Insert the the column number, where to find your sample names.
                      Sample Name Sheet: Insert the sheet name of the sheet, where to find your sample names.
                      Sample Area Column: Insert the column number in which column of a sheet your sample areas are to be found.
                      Internal Standard Area Column: Insert the column number in which column of a sheet your internal standard areas are to be found.
                      Header: Select if your columns have a header (like column names)

After filing in your main tab, you can choose to create a new tab for either "Internal Standard" or "Calibration Curve". Choose the tab you want to create via the new tab button:

  ![alt text](https://github.com/KeilainMan/Concentration-Calculator/blob/main/assets/readme_pics/main_tab_input_mode_1.PNG "Main Tab with Input Mode 1")

  Internal Standard Tab: This tab type is used if a compound shall be calculated via internal standard method.
    - Tab Name: Set a name for your tab. Highly recommended.
    - Compound Name: Insert the name of your compound of interest.
    - Internal Standard Name: Insert the name of your internal standard.
    - Internal Standard Abbreviation: Insert a abbreviation of your IS.
    - Internal Standard Concentration: Insert the concentration of your internal standard in ng/ml, which shall be used for calculation.
    - Response Factor: Insert a reponse factor for your internal standard.
    - Column/Sheet Name: Insert the name of the column (Input Mode1) or sheet (Input Mode2) of your compound. This has to be an exact match!
  
  ![alt text](https://github.com/KeilainMan/Concentration-Calculator/blob/main/assets/readme_pics/is_tab.PNG "Internal Standard Tab")

  Calibration Curve Tab:
    - Tab Name: Set a name for your tab. Highly recommended.
    - Compound Name: Insert the name of your compound of interest.
    - Column/Sheet Name: Insert the name of the column (Input Mode1) or sheet (Input Mode2) of your compound. This has to be an exact match!
    - Curve Concentrations (min. 3): Insert your known concentrations (first field) and the row (second field) where the corresponding area is to be found in the column/sheet. If you want this      concentration to be considered for the calculation, check the ckeckbox on the right.
    - Curve Style: Choose how the intercept of your calibration curve shall look like.
      - origin intercept: Sets the intercept to zero
      - intercept: calculates a intercept with the y-axis which fits the curve best.

  ![alt text](https://github.com/KeilainMan/Concentration-Calculator/blob/main/assets/readme_pics/cc_tab.PNG "Calibration Curve Tab")

  Create as many tabs as needed. When finished save your preset via the main menu button "Save preset"

  ### Calculation
  The calibration process is started once you press the top right calibration button, choose an export system (see below) and a location and file name.
  For calibration with internal standard method the following procedure is applied:
  
  1. Firstly the mass of sample compound in the meassured sample will be calculated in ng.
  ![alt text](https://github.com/KeilainMan/Concentration-Calculator/blob/main/assets/readme_pics/IS_calculation_1.PNG "IS Formula 1")<br>
  Therefor the peak area of the sample A<sub>S</sub> is divided by the peak area of the internal standard A<sub>IS</sub> times the extraction volume V times concentration of the internal standard c<sub>IS</sub> time the responde factor r<sub>f</sub>. 
  2. If normalization shall be applied and masses in mg are supplied the results will further be calculated by:
  ![alt text](https://github.com/KeilainMan/Concentration-Calculator/blob/main/assets/readme_pics/IS_calculation_2.PNG "IS Formula 2")<br>
  The mass of the sample compound n<sub>S</sub> is divided by the provided normalization mass m<sub>S</sub> and multiplied by 1000 to receive results in ng/g.
  
  For calibration with the internal standard method the following procedure is applied:

  1. Through least square regression a calibration curve is calculated from your given concentrations. The curve parameters are visible in the graph of the corresponding Calibration Curve Tab or in the summary. Then the mass of sample compound in the meassured sample will be calculated in ng:
  ![alt text](https://github.com/KeilainMan/Concentration-Calculator/blob/main/assets/readme_pics/CC_calculation_1.PNG "CC Formula 1")<br>
  Where the peak area of the sample A<sub>S</sub> is multiplied with the extraction volume V and the slope a.
  2. If normalization shall be applied it follows the same procedure as for internal standard calculation.
  
  The calculation process is organized in a way, that calculation parameters will be selected by rows, so make sure that every parameter (sample area, IS-area, extraction volume, mass etc.) is provided in the right row and be sure about the header function for input mode 2.
  If you want to use differen parameters (e.g. peak height) you can also apply them in the scope of this calculator. All formulas just work from numbers and the UI is customized for the use e.g. peak area and choosen units (ng, ml, mg, ng/g). 

### Export
When you start the calculation process you have to choose one export system:<br>
![alt text](https://github.com/KeilainMan/Concentration-Calculator/blob/main/assets/readme_pics/calibration_button.png "Calibration Button")

Export as txt: 
- produce a tab delimited txt file. First column are you sample names, following columns are your calculation results.

Export as xlsx:
- produce a xlsx file. It contain the same structure as the txt file on the first sheet.

Export as xlsx (w summary):
- produce a xlsx file. It contain the same structure as the txt file on the first sheet. On the second sheet is a summary of your calculation. 
  

## Known Bugs

1. Provided datapoints in the plot of CC Tabs seem to be off sometimes. This should not impact calculations as long as they are inserted correctly.
2. R^2 value of linear regression with intercept through the origin is wrong. This does not impact calculations. The value is solely for validation purpose.
3. There is no way to delete quick presets but to delete them manually in the safe file in the user directory.



## Troubleshooting

| Problem                      | Solutions                                                                                                                                     | Reason                                                                                                          |
|------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------|
| Missing compounds in results | -Check if your column/sheet name is correct<br>-Check if your input mode is correct                                                           | Your column/sheet name is the identifier for the calculation, if it doesn't match the compound will be skipped. |
| Results are 0.0              | -Check if your rows are sorted fitted to the calculation process (see Calculation)                                                            | If values do not fit the calculation process the result gets 0.0, e.g IS concentration of 0                     |
| Calculation doesn't start    | -Check if you filled all asterisk fields on your tabs.<br>-Check your live summary if the values correspond your tabs, if not try reentering. |                                                                                                                 |
