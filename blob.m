function ExtractBiggestBlob()
clc;
close all;
v= VideoReader('E:\4 Sem\work\vid.avi');
n=v.NumberOFFrames;
peopleDetector = vision.CascadeObjectDetector();

for im = 1950:5:1960;
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
    [labeledImage, numberOfBlobs] = bwlabel(f);
    biggestBlob = ExtractNLargestBlobs(f, 1);
    st = regionprops(biggestBlob, 'BoundingBox' );
    %     figure, imshow(b, [])
    thisBB = st.BoundingBox;
    rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],...
        'EdgeColor','r','LineWidth',2 )
    sub=imcrop(b,[],thisBB);
    sub=imresize(sub,4);
    bboxes = step(peopleDetector,sub);
    sub = insertObjectAnnotation(sub,'rectangle',bboxes,'Human');
    figure; imshow(sub);
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
    binaryImage = biggestBlob >=0.9;
catch ME
    errorMessage = sprintf('Error in function ExtractNLargestBlobs().\n\nError Message:\n%s', ME.message);
end
end
