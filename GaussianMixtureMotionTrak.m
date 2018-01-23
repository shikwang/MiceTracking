function GaussianMixtureMotionTrak(inputVideo) 
%%
% GaussianMixtureMotionTrak(inputVideo)
% This function is used to apply gaussian motion tracking on a input
% video file.
% Input: inputVideo - the file name of the video file
% Ouput: video file with box on moving object
% Author: Shikun Wang
% Date: 012218
%%
    foregroundDetector = vision.ForegroundDetector('NumGaussians', 3, ...
        'NumTrainingFrames', 1000);

    videoReader = vision.VideoFileReader(inputVideo);
    v=VideoWriter('sampleFrameMarker2Obj.avi','Motion JPEG AVI');
    open(v);
   
    % train the first 2000 frame to have motion objects
    for i = 1:1000
        frame = step(videoReader); % read the next video frame
        foreground = step(foregroundDetector, frame);
    end
    se = strel('square', 3);
    filteredForeground = imopen(foreground, se);

    blobAnalysis = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
        'AreaOutputPort', false, 'CentroidOutputPort', false, ...
        'MinimumBlobArea', 300,'MaximumCount',2);
    
    bbox = step(blobAnalysis, filteredForeground);
        
    result = insertShape(frame, 'Rectangle', bbox, 'Color', 'red');

    num = size(bbox, 1);
    result = insertText(result, [10 10], num, 'BoxOpacity', 1, ...
        'FontSize', 14);
    
    se = strel('square', 3); % morphological filter for noise removal

    canvasSize=100;
    
    index=0;
    while ~isDone(videoReader)

        frame = step(videoReader); % read the next video frame
        foreground = step(foregroundDetector, frame);
        filteredForeground = imopen(foreground, se);
        bbox = step(blobAnalysis, filteredForeground);%bbox is the coordinates
        
    %    if size(bbox,1)>0
    %        I2=imcrop(frame,bbox);
    %        width=size(I2,2);
    %        height=size(I2,1);
    %        out = padarray(I2,[double(canvasSize-height),double(canvasSize-width)],0,'both');
            
            % draw the boundary of the object
    %        BWout = imbinarize(rgb2gray(out));
    %        boundary = bwboundaries(BWout);
            
    %        baseFileName = sprintf('cropImage%d.png',index);
    %        folder='C:\Users\shi_k\Desktop\Shikun lab backup\scripts\ZED\cropimages';
    %        fullFileName = fullfile(folder, baseFileName);
    %        imwrite(out, fullFileName);
            
    %        index=index+1;
    %    end
        
        result = insertShape(frame, 'Rectangle', bbox, 'Color', 'red');

        num = size(bbox, 1);
        result = insertText(result, [10 10], num, 'BoxOpacity', 1, ...
            'FontSize', 14);
        writeVideo(v,result);
    end
    close(v);
    release(videoReader); % close the video file
end
