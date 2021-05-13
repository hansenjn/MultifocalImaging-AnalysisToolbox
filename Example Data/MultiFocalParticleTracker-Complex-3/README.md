# Example data set for MultiFocalParticleTracker-Complex-3
To analyze the data set, launch MultiFocalParticleTracker-Complex-3 in ImageJ via *Plugins > JNH > Multi Focal > Complex Particle Tracking 3...*

Next, set the following settings:
- xy calibration [µm]: 0.34375 µm / px
- Radius threshold [um] min | max:  0 | 10
- upscaling of LUT: 10
- maximum radius for xy fitting (px): 10
- Save Likelihood Plot: do NOT check
- Verify calibration mode: do NOT check

Press OK.

A dialog entitled "Multi-Task-Manager ..." pops up. Click add files, navigate through your file system to find and open
[BeadExample_Spots.txt](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/MultiFocalParticleTracker-Complex-3/BeadExample_Spots.txt).
After loading the file into the list of the "Multi-Task-Manager", press "start processing".

A dialog pops up requresting to "Open corresponding image". Select the corresponding image [BeadExample.tif](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/MultiFocalParticleTracker-Complex-3/BeadExample.tif)
and press Open.

A dialog pops up requresting to "Open corresponding LUT file (txt)". Select the corresponding LUT file [LUT.txt](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/MultiFocalParticleTracker-Complex-3/LUT.txt)
and press Open.

A dialog pops up requresting to "Open corresponding LUT standard deviation file (txt)". Select the corresponding LUT standard deviation file [SD_of_LUT.txt](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/MultiFocalParticleTracker-Complex-3/SD_of_LUT.txt)
and press Open.

Wait until the status bar in the Multi-Task-Manager Window states "analysis done!".

In the folder, where the [BeadExample_Spots.txt](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/MultiFocalParticleTracker-Complex-3/BeadExample_Spots.txt)
file was saved, additional files will have been created, e.g.
- [BeadExample_Spots_CMFPT_10_10.txt](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/MultiFocalParticleTracker-Complex-3/BeadExample_Spots_CMFPT_10_10.txt)
- [BeadExample_Spots_CMFPT_10_10_iLUT.png](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/MultiFocalParticleTracker-Complex-3/BeadExample_Spots_CMFPT_10_10_iLUT.png)
- [BeadExample_Spots_CMFPT_10_10_iLUT.txt](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/MultiFocalParticleTracker-Complex-3/BeadExample_Spots_CMFPT_10_10_iLUT.txt)
- [BeadExample_Spots_CMFPT_10_10_iLUTSD.png](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/MultiFocalParticleTracker-Complex-3/BeadExample_Spots_CMFPT_10_10_iLUT.png)
- [BeadExample_Spots_CMFPT_10_10_iLUTSD.txt](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/MultiFocalParticleTracker-Complex-3/BeadExample_Spots_CMFPT_10_10_iLUT.txt)
- [BeadExample_Spots_CMFPT_10_10_iLUTP.png](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/MultiFocalParticleTracker-Complex-3/BeadExample_Spots_CMFPT_10_10_iLUT.png)
- [BeadExample_Spots_CMFPT_10_10_iLUTP.txt](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/MultiFocalParticleTracker-Complex-3/BeadExample_Spots_CMFPT_10_10_iLUT.txt)
- [BeadExample_Spots_CMFPT_10_10_log.txt](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/MultiFocalParticleTracker-Complex-3/BeadExample_Spots_CMFPT_10_10_log.txt)
- [BeadExample_Spots_CMFPT_10_10_rawLUT.png](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/MultiFocalParticleTracker-Complex-3/BeadExample_Spots_CMFPT_10_10_rawLUT.png)
- [BeadExample_Spots_CMFPT_10_10_s.txt](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/MultiFocalParticleTracker-Complex-3/BeadExample_Spots_CMFPT_10_10_s.txt)

Next, columns 2, 3, 4, and 8 in the tab-delimited file [BeadExample_Spots_CMFPT_10_10_s.txt](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/blob/master/Example%20Data/MultiFocalParticleTracker-Complex-3/BeadExample_Spots_CMFPT_10_10_s.txt)
can be extracted and plotted - they list T, X, Y, Z coordinates for each analyzed bead. For further information on how to further analyze the output file, see our [MATLAB Scripts](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/tree/master/Matlab%20scripts)). For more details, see also the [User Guide](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox/tree/master/User%20Guide).

## Copyright and more

(c) 2021 Jan N. Hansen, An Gong, Luis Alvarez

For information, see the readme in the [main repository](https://github.com/hansenjn/MultifocalImaging-AnalysisToolbox).
