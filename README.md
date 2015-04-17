# OpenCViOS
A few examples of different computer vision tools running on ios via openCV. There is an issue with performance and/or cpu throttling after about 5 seconds of image processing that needs to be worked out.

### sparse optical flow
tracks only a few keypoints, using the goodFeaturesToTrack function, faster than dense optical flow. Uses lucas kanade algorithm.

### template matching
This is doing template matching to look for the "santitas" logo (a brand of tortilla chips)

### hough circle detector
Calculates hough transform on the image, which is a per pixel accumulator over function space (in this case circles, but also has version in opencv for lines)

### FREAK: Fast Retina Keypoints
algorithm from paper: http://infoscience.epfl.ch/record/175537/files/2069.pdf
matches to the santitas logo - invariant to many perspective transformations, but more sensitive to scaling

### dense optical flow
uses farnebeck's algorithm to calculate dense optical flow fields
