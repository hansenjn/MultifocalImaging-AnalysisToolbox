# Example data sets for SpermQ-MF - reconstruction of the flagellar beat
This example data set is part of the [MultifocalImaging-AnalysisToolbox](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox).  please see the main page of the [MultifocalImaging-AnalysisToolbox](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox) for copyright notes, license notes, etc. Please read the [User Guide](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/tree/master/User%20Guide) for detailed explanations.

SpermQ-MF outputs in the example data set have been obtained with SpermQ-MF version v0.3.0. To reproduce these output data, please use [SpermQ-MF version v0.3.0](https://github.com/hansenjn/SpermQ-MF/releases/tag/v0.3.0).

## Running the example data with SpermQ-MF
- Download this folder and place it on your hard disk
- Launch SpermQ-MF: Plugins > JNH > Multi Focal > SpermQ-MF Analysis, set the following settings

![](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/Settings%20Images/SpermQ-MF_Reconstruction_01.PNG?raw=true)

- A dialog pops up that allows to edit the analysis settings, select the settings as follows.

![](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/Settings%20Images/SpermQ-MF_Reconstruction_02.PNG?raw=true)

- A dialog emerges: select the file [Reconstruction_IcSpR_Cr_-MEDIAN_Cr_T1-250_Cr.tif](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/SpermQ-MF/Reconstruct%20Beat/Reconstruction_IcSpR_Cr_-MEDIAN_Cr_T1-250_Cr.tif) in your local file system. Press "start processing".

![](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/Settings%20Images/SpermQ-MF_Reconstruction_03.PNG?raw=true)

- A dialog emerges asking you to open the LUT file. Select the [SpermQ-MF_LUT_200601_161141.tif](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/SpermQ-MF/Reconstruct%20Beat/SpermQ-MF_LUT_200601_161141.tif) in your local file system and click “Open”.

![](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/Settings%20Images/SpermQ-MF_Reconstruction_04.PNG?raw=true)

- Now a maximum projection pops up and a dialog asking you to set a ROI. This ROI helps SpermQ-MF to find the sperm cell in the image, set a ROI around at least the head or around the whole sperm cell (should any additional particles are shown by the image, make sure they are not included in your ROI) and press OK.

![](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/Settings%20Images/SpermQ-MF_Reconstruction_05.PNG?raw=true)

- Again, a maximum projection and a dialog pops up, asking you to set another ROI. Draw a ROI where the whole cell is contained but not any other particle that might be in the image than the sperm cell. This ROI will determine the region in which SpermQ-MF determine the standard deviation (SD) across the stack to find the most sharpest (highest SD) image that will in turn be used to retrieve flagellar points. After drawing a ROI, click OK.

![](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/Settings%20Images/SpermQ-MF_Reconstruction_06.PNG?raw=true)

- Wait until the MultiTaskManager states “analysis done”. Commonly many log entries emerge during processing, these are just for debugging the software and can be ignored. The analysis can take a couple of minutes per file.

![](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/Settings%20Images/SpermQ-MF_Reconstruction_07.PNG?raw=true)

- Now, in your file system, in the folder where you had placed [Reconstruction_IcSpR_Cr_-MEDIAN_Cr_T1-250_Cr.tif](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/SpermQ-MF/Reconstruct%20Beat/Reconstruction_IcSpR_Cr_-MEDIAN_Cr_T1-250_Cr.tif), a folder like the output folder [Reconstruction_IcSpR_Cr_-MEDIAN_Cr_T1-250_Cr_mfa_200601_201630](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/tree/master/Example%20Data/SpermQ-MF/Reconstruct%20Beat/Reconstruction_IcSpR_Cr_-MEDIAN_Cr_T1-250_Cr_mfa_200601_201630). The output folder presented in this online repository is reduced to the files important for calibration, on your file system, the folder might contain more obsolete files. Please read also the [User Guide](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/tree/master/User%20Guide) for more explanations.

- The files with ending [KX.tif](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/SpermQ-MF/Reconstruct%20Beat/Reconstruction_IcSpR_Cr_-MEDIAN_Cr_T1-250_Cr_mfa_200601_201630/Reconstruction_IcSpR_Cr_-MEDIAN_Cr_T1-250_Cr_mfa_200601_201630_kX.tif), [KY.tif](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/SpermQ-MF/Reconstruct%20Beat/Reconstruction_IcSpR_Cr_-MEDIAN_Cr_T1-250_Cr_mfa_200601_201630/Reconstruction_IcSpR_Cr_-MEDIAN_Cr_T1-250_Cr_mfa_200601_201630_kY.tif), and [KZmedi.tif](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/SpermQ-MF/Reconstruct%20Beat/Reconstruction_IcSpR_Cr_-MEDIAN_Cr_T1-250_Cr_mfa_200601_201630/Reconstruction_IcSpR_Cr_-MEDIAN_Cr_T1-250_Cr_mfa_200601_201630_kZmedi.tif) show kymographs for the x, y, and z position relative to the orientation vector (head-midpiece axis), respectively.

![](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/Settings%20Images/SpermQ-MF_Reconstruction_08.PNG?raw=true)

- The intensity-z-position-code can be retrieved from the text files with ending [kX_info.txt](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/SpermQ-MF/Reconstruct%20Beat/Reconstruction_IcSpR_Cr_-MEDIAN_Cr_T1-250_Cr_mfa_200601_201630/Reconstruction_IcSpR_Cr_-MEDIAN_Cr_T1-250_Cr_mfa_200601_201630_kX_info.txt), [kY_info.txt](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/SpermQ-MF/Reconstruct%20Beat/Reconstruction_IcSpR_Cr_-MEDIAN_Cr_T1-250_Cr_mfa_200601_201630/Reconstruction_IcSpR_Cr_-MEDIAN_Cr_T1-250_Cr_mfa_200601_201630_kY_info.txt), and [kZmedi_info.txt](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/SpermQ-MF/Reconstruct%20Beat/Reconstruction_IcSpR_Cr_-MEDIAN_Cr_T1-250_Cr_mfa_200601_201630/Reconstruction_IcSpR_Cr_-MEDIAN_Cr_T1-250_Cr_mfa_200601_201630_kZmedi_info.txt), respectively. 

![](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/Settings%20Images/SpermQ-MF_Reconstruction_09.PNG?raw=true)

- The files with ending [coordX.txt](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/SpermQ-MF/Reconstruct%20Beat/Reconstruction_IcSpR_Cr_-MEDIAN_Cr_T1-250_Cr_mfa_200601_201630/Reconstruction_IcSpR_Cr_-MEDIAN_Cr_T1-250_Cr_mfa_200601_201630_coordX.txt), [coordY.txt](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/SpermQ-MF/Reconstruct%20Beat/Reconstruction_IcSpR_Cr_-MEDIAN_Cr_T1-250_Cr_mfa_200601_201630/Reconstruction_IcSpR_Cr_-MEDIAN_Cr_T1-250_Cr_mfa_200601_201630_coordY.txt), and [coordZ.txt](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/SpermQ-MF/Reconstruct%20Beat/Reconstruction_IcSpR_Cr_-MEDIAN_Cr_T1-250_Cr_mfa_200601_201630/Reconstruction_IcSpR_Cr_-MEDIAN_Cr_T1-250_Cr_mfa_200601_201630_coordZ.txt), contain the determined X, Y, and Z coordinates of the flagellum in µm, respectively. They can be used for further plotting.

![](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/Settings%20Images/SpermQ-MF_Reconstruction_10.PNG?raw=true)

- The file with ending [ti_zCmedian.tif](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/SpermQ-MF/Reconstruct%20Beat/Reconstruction_IcSpR_Cr_-MEDIAN_Cr_T1-250_Cr_mfa_200601_201630/Reconstruction_IcSpR_Cr_-MEDIAN_Cr_T1-250_Cr_mfa_200601_201630_ti_zCmedian.tif) shows the flagellar track in a stack, where the z information is intensity coded (the intensity code can be retrieved from the text file [ti_zCmedian_info.txt](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/SpermQ-MF/Reconstruct%20Beat/Reconstruction_IcSpR_Cr_-MEDIAN_Cr_T1-250_Cr_mfa_200601_201630/Reconstruction_IcSpR_Cr_-MEDIAN_Cr_T1-250_Cr_mfa_200601_201630_ti_zCmedian_info.txt).

![](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/Settings%20Images/SpermQ-MF_Reconstruction_11.PNG?raw=true)
