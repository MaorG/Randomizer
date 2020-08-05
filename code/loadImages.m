function allData = loadImages(props)

allData = [];

for i = 1:numel(props.imageNames)
    
    data = struct;
    
    pairOrder = [1,2];
    if props.reverse
        pairOrder = [2,1];
    end
        
    data.static_name = props.imageNames{i}{pairOrder(1)};
    fileName = fullfile(props.inputDir, data.static_name);
    data.static = imread(fileName);

    data.dynamic_name = props.imageNames{i}{pairOrder(2)};
    fileName = fullfile(props.inputDir, data.dynamic_name);
    data.dynamic = imread(fileName);

    allData = [allData; data];

end

end