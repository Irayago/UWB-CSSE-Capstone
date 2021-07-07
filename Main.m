import ARclasses.*

%call class with folder that contains dataset
cNet = CNNnetwork('Dataset');
%cNet.showArchitecture();
%cNet.augmentImages();
cNet.trainCNN();
%cNet.testImage('test.jpg');
%cNet.testImage('test1.jpg');
%cNet.testImage('test2.jpg');

movie = Video('trailer.mp4');
cNet.testVideo(movie);





