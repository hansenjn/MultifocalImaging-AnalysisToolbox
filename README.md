# MultifocalImaging-AnalysisToolbox
A toolbox to analyze spherical and filamentous objects in multifocal images with high speed and high precision. 

## Licenses
The included software tools are published along https://doi.org/10.1101/2020.05.16.099390. All software is published under the GNU General Public License v3.0, except few packages included in SpermQ-MF (as also stated in the [SpermQ-MF repository](https://github.com/hansenjn/SpermQ-MF)). In detail, the following implemented packages were developed by others and thus, apply to different licenses:
- edu.emory.mathcs.jtransforms.fft\DoubleFFT_1D.java & edu.emory.mathcs.utils\ConcurrencyUtils.java (MPL 1.1/GPL 2.0/LGPL 2.1, Mozilla Public License Version 1.1, author: Piotr Wendykier)
- AnalyzeSkeleton & Skeletonize3D (GNU General Public License, http://www.gnu.org/licenses/gpl.txt, author: Ignacio Arganda-Carreras)

## User Guide / Manual
A manual for the multifocal analysis pipeline will be uploaded here soon.

## Copyright notices for the developed code
Copyright (C) 2016-2020: Jan N. Hansen, An Gong, Jan F. Jikeli, Luis Alvarez

The software was developed in the research groups:
- [Molecular sensor systems](https://www.caesar.de/en/our-research/current-groups/molecular-sensory-systems/research-focus.html) (research center caesar, Bonn, Germany)
- [Biophysical Imaging](http://www.iii.uni-bonn.de/en/wachten_lab/) (Institute of Innate Immunity, University of Bonn, Germany)

The project was mainly funded by the DFG priority program SPP 1726 "Microswimmers".

Contacts: 
- java code: jan.hansen(at)uni-bonn.de
- matlab code: luis.alvarez(at)caesar.de

## Included tools
- [Multifocal_Preparation](https://github.com/hansenjn/MultiFocal_Preparation): An ImageJ plugin to convert raw camera recordings from a four-plane multifocal imaging setup, where the planes are projected to different positions of the camera chip, into a hyperstack (including image alignment and background and intensity corrections).
- [MultiFocalParticleTracker-Calibrator-3](https://github.com/hansenjn/MultiFocalParticleTracker-Calibrator-3): An ImageJ plugin to obtain the width of beads in multifocal images for generating a calibration table. 
- [MultiFocal_AlignCurvesByLMS](https://github.com/hansenjn/MultiFocal_AlignCurvesByLMS): A pure java tool to align bead profiles obtained by MultiFocalParticleTracker-Calibrator-3 across different planes by LMS.
- [MultiFocalParticleTracker-Complex-3](https://github.com/hansenjn/MultiFocalParticleTracker-Complex-3): An ImageJ plugin to calculate the z position of beads in multifocal images based on provding a calibrated relationship of bead radius and z position.
- Bead tracking matlab script: TODO
- [SpermQ-MF](https://github.com/hansenjn/SpermQ-MF): An ImageJ plugin for analyzing flagellar/filaments in images from multifocal microscopy.
