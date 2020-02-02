# No Cap(tion)
Give us an image, as we'll give you a lyric based caption. No cap.
Build at Hack UCI by Chris, Alex & Gurman.

## Design
Our app is comprised of three major parts:
1. Letting the user select the image they'd like to caption.
2. Parsing the image and extracting relevant info from it.
	* This is done using Google's Vision API, and results are filtered and refined by our backend. 
	* A list of potential useful words are returned to the user.
	* They can then either choose to accept some or add their own words.
3. Up to 5 words are then used to generate 5 lyric-based captions.
	* The 5 words are compared against our index of thousands of songs.
	* Potential matches are ranked by various criteria, including placement, repeat count, and priority.
## To run:
* Run pod install
* Ensure that the backend & frontend are linked
* Be amazed
## Screenshots
![Landing](https://i.imgur.com/CX4b9Wn.png)
![Suggestions](https://i.imgur.com/K8jqgF2.png)
![Results](https://i.imgur.com/hAoambQ.png)
