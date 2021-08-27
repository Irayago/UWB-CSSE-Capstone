classdef Video
    properties (SetAccess = private)
        vid
        duration
        name
        path
        numOfFrames
        frameRate
    end
    methods
        function obj = Video(vName)
            obj.vid = VideoReader(vName);
            obj.duration = obj.vid.Duration;
            obj.path = obj.vid.Path;
            obj.name = obj.vid.Name;
            obj.frameRate = obj.vid.FrameRate;
            
            count = 0;
            while hasFrame(obj.vid)
               frame = readFrame(obj.vid);
               count = count + 1; 
            end
            obj.numOfFrames = count;
        end
        
        function name = getName(obj)
            name = obj.name;
        end
        
        function dur = getDuration(obj)
           dur = obj.duration; 
        end
        
        function vidReader = getVidReader(obj)
           vidReader = obj.vid; 
        end
        
        function path = getPath(obj)
            path = obj.path;
        end
        
        function frameNum = getFrames(obj)
           frameNum = obj.numOfFrames; 
        end
        
        function fRate = getFrameRate(obj)
            fRate = obj.frameRate;
        end
        
        function frames = readVideo(obj, index)
            frames = read(obj.vid, index, 'native');
        end
        
    end
end