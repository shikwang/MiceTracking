videoReader = vision.VideoFileReader('FrameMarker2.avi');
v = VideoWriter('sampleFrameMarker2.avi','Motion JPEG AVI');
open(v);

for index = 1:10000
    frame = step(videoReader);
    height = size(frame,1);
    width = size(frame,2);
    frame2 = imcrop(frame,[0,220,400,height/2]);
    writeVideo(v,frame2);
end

close(v);
release(videoReader);