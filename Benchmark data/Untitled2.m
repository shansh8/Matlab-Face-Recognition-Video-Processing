
clc;
close all;
v= VideoReader('E:\4 sem\work\Benchmark data\AVSS_AB_Easy_Divx.avi');
% peopleDetector = vision.PeopleDetector;
for im = 1200:10:1210;
    tic;
    a=read(v,im);
    a=imresize(a,0.5);
    a=rgb2gray(a);
    a=edge(a);
    imshow(a);
end