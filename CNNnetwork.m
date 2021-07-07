classdef CNNnetwork < handle
    properties (SetAccess = private)
        %initialize googlenet
        net = googlenet
        trainedNet
        trainingDset
        validationDset
        inputLayerSize
        layerGraph
        numOfClasses
    end
    methods
        function obj = CNNnetwork(dName)
            
            if(nargin == 1)
            %load dataset
            dset = imageDatastore(dName,'IncludeSubfolders',...
                   true,'LabelSource','foldernames');
            
            %split dataset into 70% training and 30% validation sets 
            [obj.trainingDset,obj.validationDset] = splitEachLabel(dset,0.7);
            
            %retrieve input size into network 
            obj.inputLayerSize = obj.net.Layers(1).InputSize;
            
            %extract architecture of network
            obj.layerGraph = layerGraph(obj.net);
            
            %extract feature learner and output classifier
            featureLearner = obj.net.Layers(142);
            outputClassifier = obj.net.Layers(144);
            
            %obtain number of classes in dataset
            obj.numOfClasses = numel(categories(obj.trainingDset.Labels));
            
            %create new feature learner layer
            newFeatureLearner = fullyConnectedLayer(obj.numOfClasses, ...
                'Name','Facial Feature Learner', ...
                'WeightLearnRateFactor',10, ...
                'BiasLearnRateFactor',10);
            
            %create new classifier layer
            newClassifierLayer = classificationLayer('Name','Face Classifier');
            
            %replace feature learner layer
            obj.layerGraph = replaceLayer(obj.layerGraph, featureLearner.Name, newFeatureLearner);
            
            %replace classifier layer
            obj.layerGraph = replaceLayer(obj.layerGraph, outputClassifier.Name, newClassifierLayer);
            end           
        end
           
        % not used at the moment but could be used for further
        % customization with user input as a feature
        function obj = augmentImages(obj)
            
            pixel_range = [-30 30];
            scale_range = [0.9 1.1];
            
            %setup image augmentation options
            image_augmenter = imageDataAugmenter(...
                'RandXReflection',true,...
                'RandXTranslation',pixel_range,...
                'RandYTranslation',pixel_range,...
                'RandXScale',scale_range,...
                'RandYScale',scale_range);
            
            %augment training data set to prevent overfitting
            %obj.augmentedTrainSet = augmentedImageDatastore(obj.inputLayerSize(1:2),...
                %obj.trainingDset,'DataAugmentation',image_augmenter);
            
            %obj.augmentedValSet = augmentedImageDatastore(obj.inputLayerSize(1:2),obj.validationDset);          
        end
        
        function obj = trainCNN(obj)
            
                        
            pixel_range = [-30 30];
            scale_range = [0.9 1.1];
            
            %setup image augmentation options
            image_augmenter = imageDataAugmenter(...
                'RandXReflection',true,...
                'RandXTranslation',pixel_range,...
                'RandYTranslation',pixel_range,...
                'RandXScale',scale_range,...
                'RandYScale',scale_range);
            
            %augment training data set to prevent overfitting
            augmentedTrainSet = augmentedImageDatastore(obj.inputLayerSize(1:2),...
                obj.trainingDset,'DataAugmentation',image_augmenter);
            
            augmentedValSet = augmentedImageDatastore(obj.inputLayerSize(1:2),obj.validationDset);  
            
            
            %defining training options to apply
            sizeOfMinibatch = 5;
            numOfTrainImages = numel(augmentedTrainSet.Files);
            validationFreq = floor(numOfTrainImages/sizeOfMinibatch);
            trainOptions = trainingOptions('sgdm',...
                'MiniBatchSize',sizeOfMinibatch,...
                'MaxEpochs',6,...
                'InitialLearnRate',3e-4,...
                'Shuffle','every-epoch',...
                'ValidationData',augmentedValSet,...
                'ValidationFrequency',validationFreq,...
                'Verbose',false,...
                'Plots','training-progress');
            
            obj.trainedNet = trainNetwork(augmentedTrainSet,obj.layerGraph,trainOptions);            
        end
        
        function obj = testImage(obj, image)         
            img = imread(image);
            test = imresize(img,[224,224]);
            [label,prob] = classify(obj.trainedNet,test);
            figure;
            imshow(test);
            title({char(label),num2str(max(prob),2)});
        end
        
        function obj = testVideo(obj, video)
            vidReader = getVidReader(video);
            vidReader.CurrentTime = 0;
            while hasFrame(vidReader)
                frame = readFrame(vidReader);
                image(frame);
                testFrame = imresize(frame,[224 224]);
                
                [label,prob] = classify(obj.trainedNet,testFrame);
                title(char(label), num2str(max(prob),2));
                drawnow;
            end
        end
        
        function showArchitecture(obj)
            analyzeNetwork(obj.layerGraph);
        end
        
    end
end