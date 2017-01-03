# Cell Microscopy Code
The code below is used to analyze cell images taken using high-speed fluorescence microscopy. The results are used in thesis work for the UNC Department of Biology's Maddox Lab.
# Purpose
By analyzing certain features of the 3-dimensional input images, the program is able to identify chromatin within the cells. As a result, the chromatin can be marked by location and its size and intensity can be measured over time. This data contributes to the thesis work of doctoral student Vincent Boudreau, which deals with the timing of chromatin transformations in cell division. More information on this research can be found at http://labs.bio.unc.edu/Maddox/Site/Projects.html.
# Language and Code Structure
The code is written in ImageJ, a variant of Java used for image processing, and is run through the FIJI framework. It consists of two main sections: the first performs operations on the image which distinguish the chromatin from other cell features, and the second clips and orients the identified samples.
