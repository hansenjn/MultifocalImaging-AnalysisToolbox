# MultifocalImaging-AnalysisToolbox
A toolbox to analyze spherical and filamentous objects in multifocal images with high speed and high precision. The included software tools are published along https://doi.org/10.1101/2020.05.16.099390. 

## Licenses
All software is published under the GNU General Public License v3.0, except few packages included in SpermQ-MF (as also stated in the [SpermQ-MF repository](https://github.com/hansenjn/SpermQ-MF)). In detail, the following implemented packages were developed by others and thus, apply to different licenses:
- edu.emory.mathcs.jtransforms.fft\DoubleFFT_1D.java & edu.emory.mathcs.utils\ConcurrencyUtils.java (MPL 1.1/GPL 2.0/LGPL 2.1, Mozilla Public License Version 1.1, author: Piotr Wendykier)
- AnalyzeSkeleton & Skeletonize3D (GNU General Public License, http://www.gnu.org/licenses/gpl.txt, author: Ignacio Arganda-Carreras)

## How to cite?
When using software from this toolbox, please cite https://doi.org/10.1101/2020.05.16.099390.

## Copyright notice and contacts
Copyright (C) 2016-2020: Jan N. Hansen, An Gong, Jan F. Jikeli, Luis Alvarez

The software was developed in the research groups:
- [Molecular sensor systems](https://www.caesar.de/en/our-research/current-groups/molecular-sensory-systems/research-focus.html) (research center caesar, Bonn, Germany)
- [Biophysical Imaging](http://www.iii.uni-bonn.de/en/wachten_lab/) (Institute of Innate Immunity, University of Bonn, Germany)

The project was mainly funded by the [DFG priority program SPP 1726 "Microswimmers"](https://www.fz-juelich.de/ibi/ibi-5//EN/Leistungen/SPP1726/_node.html).

Contacts: 
- java code: jan.hansen(at)uni-bonn.de
- matlab code: luis.alvarez(at)caesar.de

## Using the toolbox
### System requirements
#### Hardware requirements
ImageJ does not require any specific hardware and can also run on low-performing computers. However, a RAM is required that allows to load one image sequence that you aim to analyze into your RAM  at least once, ideally twice or multiple times. ImageJ does not require any specific graphics card. The speed of the analysis depends on the processor speed.

#### Operating system
The ImageJ plugins and Java software were developed and tested on Windows 8.1. Matlab scripts were developed and tested on Windows 8.1 and Windows 10. ImageJ and Java is also available for Mac and Linux operating systems, where the ImageJ plugins and Java software in theory can be easily run, too.

#### Software requirements
Performing the analysis pipeline requires the installation of
- Java™ by Oracle (tested on Version 8, Update 231)
- [ImageJ](https://imagej.net/Downloads) (tested on versions 1.51u and 1.52i)

Optionally, for further data exploration, we provide Matlab scripts that require installation of
- [Matlab](https://www.mathworks.com/downloads) (tested on versions R2018b and R2020a)

### Installation instructions
- The ImageJ plugins are directly downloaded from the release pages of the individual repositories (download the newest releases of [Multifocal_Preparation](https://github.com/hansenjn/MultiFocal_Preparation/releases), [MultiFocalParticleTracker-Calibrator-3](https://github.com/hansenjn/MultiFocalParticleTracker-Calibrator-3/releases), [MultiFocalParticleTracker-Complex-3](https://github.com/hansenjn/MultiFocalParticleTracker-Complex-3/releases), [SpermQ-MF](https://github.com/hansenjn/SpermQ-MF/releases)). The plugins are installed by drag and drop into the ImageJ window (after opening ImageJ) and confirming the installation by pressing save. Next, ImageJ requires to be restarted. Typically the installation process of ImageJ plugins takes only few seconds / minutes (the time that your computer needs to launch ImageJ and relaunch it after placing the plugins).
- Java software (i.e. [MultiFocal_AlignCurvesByLMS](https://github.com/hansenjn/MultiFocal_AlignCurvesByLMS/releases)), after downloading, can be directly run by double clicking (when Java is installed).
- Matlab scripts can be directly opened and run in Matlab.

### User Guide / Manual
A manual for the multifocal analysis pipeline including example data is available here.

## Included tools
- [Multifocal_Preparation](https://github.com/hansenjn/MultiFocal_Preparation): An ImageJ plugin to convert raw camera recordings from a four-plane multifocal imaging setup, where the planes are projected to different positions of the camera chip, into a hyperstack (including image alignment and background and intensity corrections).
- [MultiFocalParticleTracker-Calibrator-3](https://github.com/hansenjn/MultiFocalParticleTracker-Calibrator-3): An ImageJ plugin to obtain the width of beads in multifocal images for generating a calibration table. 
- [MultiFocal_AlignCurvesByLMS](https://github.com/hansenjn/MultiFocal_AlignCurvesByLMS): A pure java tool to align bead profiles obtained by MultiFocalParticleTracker-Calibrator-3 across different planes by LMS.
- [MultiFocalParticleTracker-Complex-3](https://github.com/hansenjn/MultiFocalParticleTracker-Complex-3): An ImageJ plugin to calculate the z position of beads in multifocal images based on provding a calibrated relationship of bead radius and z position.
- Bead tracking matlab script: TODO
- [SpermQ-MF](https://github.com/hansenjn/SpermQ-MF): An ImageJ plugin for analyzing flagellar/filaments in images from multifocal microscopy.
