classdef Actor
    properties (SetAccess = private)
        name
    end
    methods
        function obj = Actor(uName)
            obj.name = uName;
        end
        
        function aName = getName(obj)
            aName = obj.name;
        end
        
    end
end