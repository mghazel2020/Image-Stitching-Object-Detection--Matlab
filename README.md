# Image-Stitching-Object-Detection--Matlab


# 1. Objective

The objective of this project is to demonstrate two important computer vision functionalties:

* Panorama construction via image stitching and mosaicking
* Object detectuon and recognition via and template feature matching.

# 2. Experimental Setup

In order to implement the desired image stitching and object recognition algorithms, we setup the following scenarios:

* Suppose we have template images of a set of objects:
  * In our application, we have template images of 5 different books
* We shall clutter these 6 books nearby each other:
  * The books are cluttered on the floor near each other with some separation between consecutive books
  * The books are also randomly oriented when placed on the floor 
  * The 5 books are arranged almost linearly
* Using a phone camera, acquire multiple images from left to write in such a way:
  * There is at least one book in each image
  * There a relatively significant overlay between consecutive images
  * At least part of one object appears in 2 consecutive images
  * The images are ordere from left-to-right.

# 3. Collected Data

The template images of the 6 objects of interest are illustrated in the next figure.
<img src="figures/templates-6-objects-interest.jpg" width="1000">

We also acquired 9 ordered scene images according the the experimental setup described in the previous section. 

<img src="figures/acquired-9-consecutive-scene-images.jpg" width="1000">

# 4. Approach

The implemented approach is two folds:

1. Apply MATLAB image backprojection and stitching functionalities to stitch the 9 acquired scene images together and construct a scene panorama
2. Apply MATLAB image feature detection and matching in order to detect and recognize the temples of the 6 objects of interest in each of the acquired 9 scene images as well as the constructed scene panorama.

# 5. Sample Results

The object detection and recognition results of the 6 objects of interest, using the 9 acquired scene images, are illustrated in the next figure.
<img src="figures/object-detection-results-from-scene-images.jpg" width="1000">

The object detection and recognition results of the 6 objects of interest, using the constructed scene panorama image, are illustrated in the next figure.

<img src="figures/object-detection-results-from-constructed-panorama.jpg" width="1000">


# 6. Conclusion
