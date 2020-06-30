# Example data sets for SpermQ-MF - test calibration mode
This example data set is part of the [MultifocalImaging-AnalysisToolbox](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox).  please see the main page of the [MultifocalImaging-AnalysisToolbox](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox) for copyright notes, license notes, etc. Please read the [User Guide](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/tree/master/User%20Guide) for detailed explanations!

SpermQ-MF outputs in the example data set have been obtained with SpermQ-MF version v0.3.0. To reproduce these output data, please use [SpermQ-MF version v0.3.0](https://github.com/hansenjn/SpermQ-MF/releases/tag/v0.3.0).

## Running the example data with SpermQ-MF
- Download this folder and place it on your hard disk
- Launch SpermQ-MF: Plugins > JNH > Multi Focal > SpermQ-MF Analysis, set the following settings

![](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/Settings%20Images/SpermQ-MF_Verification_01.PNG?raw=true)

- A dialog pops up that allows to edit the analysis settings, select the settings as follows.

![](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/Settings%20Images/SpermQ-MF_Verification_02.PNG?raw=true)

- A dialog emerges: select the file [Verification_IcSpR_Cr_Cr.tif](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/SpermQ-MF/Verify%20LUT/Verification_IcSpR_Cr_Cr.tif) in your local file system. Press "start processing".
- A dialog emerges asking you to open the LUT file. Select the [SpermQ-MF_LUT_200601_161141.tif](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/SpermQ-MF/Verify%20LUT/SpermQ-MF_LUT_200601_161141.tif) in your local file system and click “Open”.

- Now a maximum projection pops up and a dialog asking you to set a ROI. This ROI helps SpermQ-MF to find the sperm cell in the image, set a ROI around at least the head or around the whole sperm cell (should any additional particles are shown by the image, make sure they are not included in your ROI) and press OK.

![](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/Settings%20Images/SpermQ-MF_Verification_03.PNG?raw=true)

- Again, a maximum projection and a dialog pops up, asking you to set another ROI. Draw a ROI where the whole cell is contained but not any other particle that might be in the image than the sperm cell. This ROI will determine the region in which SpermQ-MF determine the standard deviation (SD) across the stack to find the most sharpest (highest SD) image that will in turn be used to retrieve flagellar points. After drawing a ROI, click OK.

![](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/Settings%20Images/SpermQ-MF_Verification_04.PNG?raw=true)

- Wait until the MultiTaskManager states “analysis done”. Commonly many log entries emerge during processing, these are just for debugging the software and can be ignored. The analysis can take a couple of minutes per file.

![](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/Settings%20Images/SpermQ-MF_Verification_05.PNG?raw=true)

- Now, in your file system, in the folder where you had placed [Verification_IcSpR_Cr_Cr.tif](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/SpermQ-MF/Verify%20LUT/Verification_IcSpR_Cr_Cr.tif), a folder like the output folder [Verification_IcSpR_Cr_Cr_mfa_200601_190152](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/tree/master/Example%20Data/SpermQ-MF/Verify%20LUT/Verification_IcSpR_Cr_Cr_mfa_200601_190152). The output folder presented in this online repository is reduced to the files important for calibration, on your file system, the folder might contain more obsolete files. Please read also the [User Guide](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/tree/master/User%20Guide) for more explanations.
- The file with ending [KZmedi.tif](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/SpermQ-MF/Verify%20LUT/Verification_IcSpR_Cr_Cr_mfa_200601_190152/Verification_IcSpR_Cr_Cr_mfa_200601_190152_kZmedi.tif) shows the z-positions (intensity-coded) determined along the arc length (x dimension) and along the piezo position (y dimension). The intensity-z-position-code can be retrieved from the file with ending [kZmedi_info.txt](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/SpermQ-MF/Verify%20LUT/Verification_IcSpR_Cr_Cr_mfa_200601_190152/Verification_IcSpR_Cr_Cr_mfa_200601_190152_kZmedi_info.txt). 

![](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/Settings%20Images/SpermQ-MF_Verification_06.PNG?raw=true)

- You may also retrieve the Z positions as a list from the tab-delimited text file with ending [coordZ.txt](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/SpermQ-MF/Verify%20LUT/Verification_IcSpR_Cr_Cr_mfa_200601_190152/Verification_IcSpR_Cr_Cr_mfa_200601_190152_coordZ.txt).

![](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/Settings%20Images/SpermQ-MF_Verification_07.PNG?raw=true)

- The inferred z-positions in relationship to the piezo position (indicated by the values in column “time” if multiplied by the step-size of the piezo during recording) should reveal a linear relationship with a slope of unity. The standard deviation of the residuals from a linear fit with slope unity demonstrates how accurate the method is. The average of the residuals should be zero to confirm that the method reveals an unbiased inferred z-position.
