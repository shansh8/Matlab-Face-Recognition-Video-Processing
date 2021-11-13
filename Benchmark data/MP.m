function ExtractBiggestBlob()
clc;
close all;
v= VideoReader('E:\3 sem\CCTV\work1\vid.avi');
% peopleDetector = vision.PeopleDetector;
for im = 2000:10:2600;
    tic;
    a=read(v,im);
    a=imresize(a,0.5);
    b=read(v,im+10);
    b=imresize(b,0.5);
    fig= imsubtract(a,b);
    
    I2=rgb2gray(fig);
    I3 = imadjust(I2, stretchlim(I2), [0 1]);
    level = graythresh(I3);
    bw = im2bw(I3,level);
    K = medfilt2(bw);
    I = medfilt2(K,[5,5]);
    
    
    L = im2double(I);
    f = imfilter(L.^(-5+1),ones(5,5),'replicate');
    f = f ./(imfilter(L.^-5,ones(5,5),'replicate'));
    f= im2bw(f);
    
  
   
    
    [labeledImage, numberOfBlobs] = bwlabel(I);
    biggestBlob = ExtractNLargestBlobs(I, 10);
    st = regionprops(biggestBlob, 'BoundingBox' );
   figure, subplot (1,2,1);
  
   imshow(b, [])
    for k = 1 : length(st)
        thisBB = st(k).BoundingBox;
        rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],...
            'EdgeColor','r','LineWidth',2 )
    end
     title('Temporal Differencing');
     
    [labeledImage, numberOfBlobs] = bwlabel(f);
    biggestBlob1 = ExtractNLargestBlobs(f, 10);
    st1 = regionprops(biggestBlob1, 'BoundingBox' );
   subplot (1,2,2);
   
   imshow(b, [])
    for k1 = 1 : length(st1)
        thisBB1 = st1(k1).BoundingBox;
        rectangle('Position', [thisBB1(1),thisBB1(2),thisBB1(3),thisBB1(4)],...
            'EdgeColor','r','LineWidth',2 )
    end
    title('Modified Temporal Differencing')
    %    sub=imcrop(b,[],thisBB);
    %    sub=imresize(sub,4);
    %    [bboxes,scores] = step(peopleDetector,sub);
    %   sub = insertObjectAnnotation(sub,'rectangle',bboxes,'Human');
    % imshow(sub);
    toc;
end
end


function binaryImage = ExtractNLargestBlobs(binaryImage, numberToExtract)
try
    
    [labeledImage, numberOfBlobs] = bwlabel(binaryImage);
    blobMeasurements = regionprops(labeledImage, 'area');
    
    allAreas = [blobMeasurements.Area];
    if numberToExtract > 0
        [sortedAreas, sortIndexes] = sort(allAreas, 'descend');
    elseif numberToExtract < 0
        [sortedAreas, sortIndexes] = sort(allAreas, 'ascend');
        numberToExtract = -numberToExtract;
    else
        binaryImage = false(size(binaryImage));
        return;
    end
    biggestBlob = ismember(labeledImage, sortIndexes(1:numberToExtract));
    binaryImage = biggestBlob > 0;
catch ME
    errorMessage = sprintf('Error in function ExtractNLargestBlobs().\n\nError Message:\n%s', ME.message);
end
end