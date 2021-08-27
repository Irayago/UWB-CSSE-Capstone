import ARclasses.*

%call class with folder that contains dataset
cNet = CNNnetwork('Dataset');
%cNet.showArchitecture();
%cNet.augmentImages();
%cNet.trainCNN();
%cNet.saveNetwork('test.mat');
cNet = cNet.loadNetwork('test.mat');
%cNet.testImage('test.jpg');
%cNet.testImage('test1.jpg');
%cNet.testImage('test2.jpg');

movie = Video('trailer.mp4');
cNet.testVideo(movie);





