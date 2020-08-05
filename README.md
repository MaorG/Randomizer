# Randomizer
# mask randomization tool: Randomize objects in a mask relative to a reference mask

function randomizeMasks(configFileName)

takes as input pairs of masks (each pair representing two populations).

for each pair, it randomizes one population objects (the "dynamic" objects) with respect to a reference population objects (the "static" objects).

finally it writes the randomized objects masks as an 8-bit b/w image.

notes: 
- in order to make later analysis simpler, for each randomized objects mask created, a copy of the reference population with a matching naming scheme is created.
- the randomization is performed by randomizing the location of objects in random order, while requiring that the locations are valid. if no valid location is found, object is not used.


input: configuration file name

	configuration file is in JSON format. example file content:

		{
			"inputDir": "C:/school/misc/Randomizer/data/",
			"outputDir": "C:/school/misc/Randomizer/rand/",
			"repeats": 5,
			"reverse": 0,
			"staticOverlap": 0,
			"dynamicOverlap": 0,
			"randomSeed": 1,
			"imageNames": [
				["a1/pop1.tif", "a1/pop2.tif"],
				["a1/pop2.tif", "a1/pop1.tif"],
				["a2/pop3.tif", "a2/pop4.tif"]
			]
		}
	 
	inputDir: path of root directory of source images
	outputDir: path of root directory of output images
	repeats: number of randomization per pair
	reverse: if 0, the first mask is the reference, and the second is randomized. if 1, order is flipped.
	staticOverlap: can a randomized object overlap reference objects?    	 0 = No, 1 = Yes
	staticOverlap: can a randomized object overlap other randomized objects? 0 = No, 1 = Yes
	<optional> randomseed: set a random seed
	imageNames: list of pairs of filenames. the position is relative to the "inputDir" path.
	
output: images 
	
	new images are under the output root directory, with the same sub-directory structure as the input.
	new randomized images have the names of the original images, with suffixes "_r_001", "_r_002", ...  
	duplicated reference images have the names of the original images, with suffixes "_s_001", "_s_002", ...  
	
Example script:
	
	> configName = 'C:\project\conf_json.json';
	> randomizeMasks(configName);


written in MATLAB version 2018b

Maor Grinberg 2020


