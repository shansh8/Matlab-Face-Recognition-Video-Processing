clc;
close all;
v= VideoReader('E:\4 Sem\work\vid.avi');
n=v.NumberOFFrames;
peopleDetector = vision.PeopleDetector;

for im = 1950:5:1960;
    tic;
    a=read(v,im);
    bboxes = step(peopleDetector,a);
    sub = insertObjectAnnotation(a,'rectangle',bboxes,'Human');
    figure; imshow(sub);
    toc;
end