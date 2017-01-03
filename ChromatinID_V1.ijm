brightnessThreshold = 0.5; // * max brightness
standardDevThreshold = 0.6; // * max standard deviation
sizeLowerThreshold = 10;
sizeUpperThreshold = 150;
circLowerThreshold = 0.00;
circUpperThreshold = 1.00;
paddingX = 30;
paddingY = 30;

getDimensions(width, height, channels, slices, frames);
run("Stack to Hyperstack...", "order=xyczt(default) channels=" + channels + " slices=" + slices + " frames=" + frames + " display=Grayscale");
stack = getImageID();

run("Z Project...","start=1 stop=" + slices + " projection=[Max Intensity]");
maxImg = getImageID();
getMinAndMax(min, max);
setThreshold(brightnessThreshold * max, max);

selectImage(stack);
run("Z Project...","start=1 stop=" + slices + " projection=[Standard Deviation]");
stdImg = getImageID();
stdTitle = getTitle();
getMinAndMax(stdMin, stdMax);

selectImage(maxImg);
measurements = "min max bounding"; 
run("Set Measurements...", measurements + " redirect=" + stdTitle + " decimal=6"); 
List.setMeasurements;

run("Analyze Particles...", "size=" + sizeLowerThreshold + "-" + sizeUpperThreshold + " circularity=" + circLowerThreshold + "-" + circUpperThreshold + " show=Nothing exclude clear");
getPixelSize(unit, pixWidth, pixHeight);

counter = 1;
for (i = 0; i < nResults; i++) {
	if (getResult("Max", i) > standardDevThreshold * stdMax){
	
		x1 = getResult("BX", i) / pixWidth - paddingX;
		y1 = getResult("BY", i) / pixHeight - paddingY;
		x2 = x1 + getResult("Width", i) / pixWidth + 2 * paddingX;
		y2 = y1 + getResult("Height", i) / pixHeight + 2 * paddingY;
		
		for (j = 0; j < nResults; j++) {
			if (i != j && getResult("Max", i) > standardDevThreshold * stdMax){
				nx1 = getResult("BX", j) / pixWidth;
				ny1 = getResult("BY", j) / pixHeight;
				nx2 = nx1 + getResult("Width", j) / pixWidth;
				ny2 = ny1 + getResult("Height", j) / pixHeight;

				xOverlap = minOf(x2, nx2) - maxOf(x1, nx1);
				yOverlap = minOf(y2, ny2) - maxOf(y1, ny1);
				
				if (xOverlap > 0 && yOverlap > 0){
					if (xOverlap < yOverlap){
						if (x1 > nx1) x1 = nx2;
						if (x2 < nx2) x2 = nx1;
					} else {
						if (y1 > ny1) y1 = ny2;
						if (y2 < ny2) y2 = ny1;
					}
				}
			}
		}
		
		makeRectangle(x1, y1, x2 - x1, y2 - y1);
		run("Duplicate...", "title=Chromatin_#" + counter);
		selectImage(maxImg);
		counter++;
	}
}

selectImage(maxImg);
close();
selectImage(stdImg);
close();