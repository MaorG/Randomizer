function randomizedMask = getRandomization(data, props)

try
    static = data.static(:,:,1);
    static = static > 0;
    dynamic = data.dynamic(:,:,1);
    dynamic = dynamic > 0;
catch
    disp('ERROR: bad file format?')
    randomizedMask = [];
    return;
end

dynamicEntities = getEntitiesFromMask(dynamic);
randomizedMask = getRandomizedDynamicMask(static, dynamicEntities, props);

end

function entities = getEntitiesFromMask(im)

CC = bwconncomp(im);
rp = regionprops(CC, 'Centroid', 'PixelList', 'PixelIdxList', 'Area');
centers = cat(1, rp.Centroid);
pixels = cell(numel(rp),1);
pixelsidx = cell(numel(rp),1);
for ii = 1:numel(rp)
    pixels{ii} = rp(ii).PixelList;
    pixelsidx{ii} = rp(ii).PixelIdxList;
end
areas = cat(1, rp.Area);

entities = struct;
entities.centers = centers;
entities.areas = areas;
entities.pixels = pixels;
entities.pixelsidx = pixelsidx;

end

function dynamicRandomized = getRandomizedDynamicMask(static, dynamicEntities, props)

    numDynamicEntities = numel(dynamicEntities.pixels);

    imsize = size(static);
    viableDynamicPixels = ones(imsize);
    viableStaticPixels = ones(imsize);
    
    if props.staticOverlap ~= 1
        viableStaticPixels = ~(static);
    end
    
    I = zeros(imsize);

    successCount = 0;
    maxTryCount = 1000;
    
    randomOrder = randperm(numDynamicEntities);
    
    for di = 1:numDynamicEntities
        tryCount = 0;
        pixels = dynamicEntities.pixels{randomOrder(di)};
        while tryCount < maxTryCount
            
            newPixels = randomizePixelsLocationMB(imsize,pixels);
            
            goodLocation = true;
            
            % check if location is valid
            if props.staticOverlap == 0
                if (~all(viableStaticPixels(newPixels)))
                    goodLocation = false;
                end
            end
            
            if props.dynamicOverlap == 0
                if (sum(viableDynamicPixels(newPixels)) ~= numel(newPixels))
                    goodLocation = false;
                end
            end
            
            if goodLocation
                tryCount = inf;
                if props.dynamicOverlap == 0
                    viableDynamicPixels(newPixels) = 0;
                end
                I(newPixels) = di;
                successCount = successCount + 1;
            else
                tryCount = tryCount+1;
            end
        end
        
    end
    dynamicRandomized = I;
end



function newPixels = randomizePixelsLocationMB(imSize,pixels)

maxRows = imSize(1);
maxCols = imSize(2);
curAgg = pixels;

curAggRows = curAgg(:, 2);
curAggCols = curAgg(:, 1);

curAggTopRow = min(curAggRows);
curAggTopCol = min(curAggCols);
maxRowLength = max(curAggRows) - curAggTopRow;
maxColLength = max(curAggCols) - curAggTopCol;

baseAggRows = curAggRows - curAggTopRow + 1;
baseAggCols = curAggCols - curAggTopCol + 1;

curMaxRows = maxRows - maxRowLength;
curMaxCols = maxCols - maxColLength;

randRowInc = randi([0, curMaxRows - 1]);
randColInc = randi([0, curMaxCols - 1]);

newAggRows = baseAggRows + randRowInc;
newAggCols = baseAggCols + randColInc;

% newAggMask = iMask;

newPixels = sub2ind(imSize, newAggRows, newAggCols);
end
