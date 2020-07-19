# Generative Artwork: "Treescape"

A Processing.js code-generated landscape featuring a surrealistic tree against a dramatic sky.

This is a simplified version of the code used to generate the Treescape artworks on https://www.genartive.com.

![Sample Treescape artwork](https://www.genartive.com/thumbs/treescape/350/577580052.png)

# Dependencies
Artwork is rendered to an HTML Canvas by a Processing.js script, which is the Javascript adaptation of the Processing language. 

More information and full documentation for the Processing.js library is at http://processingjs.org/.

# Usage
To run this code and generate a random artwork, simply open `index.html` in a modern web browser.

The `index.html` file includes a local copy of the Processing.js library (version 1.3.6) and then loads and runs the Processing.js code in `treescape.pde` via the `data-processing-sources` attribute on the HTML canvas element.

# Additional Details
Processing.js will automatically run the `setup()` function in the PDE file. This initializes the canvas and then calls additional functions to draw the various elements of the artwork, in this case, a sky, tree, grass, and hills. The exact number of elements and their relative positions and sizes are randomized through generous use of the Processing.js `random(min,max)` function, which ensures that every execution of this code generates a unique artwork.

This artwork uses the Processing.js `HSB` (Hue/Saturation/Brightness) color mode, as documented at http://processingjs.org/reference/colorMode_/. 

On each execution a "main" hue between 1 and 360 is chosen at random, and then [split complementary colours](https://www.tigercolor.com/color-lab/color-theory/color-harmonies.htm#:~:text=Split%2DComplementary,scheme%2C%20but%20has%20less%20tension) are generated from that main hue. This creates three harmonious hues for use in the artwork's colour palette. Each hue is modified further by adjusting its saturation and brightness.

Note that all calculations related to x and y coordinates, or widths and heights of elements, are scaled to the rendered size of the canvas. On [genartive.com](https://www.genartive.com) this enables me to seed the `random()` function with a fixed value and then regenerate the same artwork multiple times on canvases of any size. The logic for this seeding and resizing is not included in this simplified sample code.

Recursion is used to draw the tree branches and the tree roots. Specifically, once a branch is drawn, if it is thicker than the minimum the function calls itself again to create two thinner branches splitting out from itself.

Because of the enormous number of entities that result from this exponential recursion, some concessions needed to be made for performance, to prevent browsers from running slowly or hanging. Specifically:

- The drawing of each new branch recursion call is wrapped in a Javascript `timeout()` function, with a delay of only 1ms, which ensures that it is executed in a different thread than the current one;

- Because repeatedly changing the active `fill()` color carries a performance cost, leaves are not drawn at the same time as the branches. Instead, the x, y and color values of desired leaves are stashed in global arrays, and then leaves are rendered in batches of the same colour after the full tree has been rendered.

# Usage Permissions
Please use this code for educational purposes, to satisfy your curiosity or to adapt parts or techniques for your own projects.

Do not redistribute this code unmodified in its entirety.

Do not redistribute or sell artworks generated from this code without significant modification.
