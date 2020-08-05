function exportRandomizations(allData, props)

    for i = 1:numel(allData)
        data = allData(i);
        for ri = 1:props.repeats

            randomizedMask = getRandomization(data,props);

            suffix = num2str(ri,'%03u');
            suffix_r = strcat('_r_', suffix);
            suffix_s = strcat('_s_', suffix);

            fullfilename = fullfile(props.outputDir, allData(i).dynamic_name);
            [filepath,name,ext] = fileparts(fullfilename);
            fullfilename = fullfile(filepath,[name,suffix_r,ext])
            [status, msg, msgID] = mkdir(filepath);
            imwrite(255*uint8(randomizedMask),fullfilename);

            fullfilename = fullfile(props.outputDir, allData(i).static_name);
            [filepath,name,ext] = fileparts(fullfilename);
            fullfilename = fullfile(filepath,[name,suffix_s,ext])
            [status, msg, msgID] = mkdir(filepath);
            imwrite(255*uint8(allData(i).static(:,:,1)>0),fullfilename);

        end
    end
end