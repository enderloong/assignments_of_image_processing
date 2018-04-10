% boundary_extraction.m contains the implementation of main routine for Question
% 1 in Assignment 2. This function uses erosion to obtain the boundary of different objects. 
% Note that you are not allowed to use the matlab built-in function such as
% imfilter, imerode or any third-party function in this question.

function boundary_extraction()

    % Read the input image and convert it to binary image
    IM = imread('image.jpg');
    img = im2bw(IM);
    % Display the input image
    figure;
    imshow(img);title('Input image');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % TODO_1: Apply erosion on the image
    % img_erode = ??
    erosion = [-1 -1; -1 0; -1 1;0 -1; 0 0; 0 1; 1 -1; 1 0; 1 1];
    e_size = size(erosion, 1);
    [m, n] = size(img);
    img_proc = zeros([m,n,e_size]);
    for i = 1:e_size
        img_proc(max(1, 1 + erosion(i,1)):min(m, m + erosion(i,1)), max(1, 1 + erosion(i,2)):min(n, n + erosion(i,2)),i) = ...
        img(max(1, 1 - erosion(i,1)):min(m, m - erosion(i,1)), max(1, 1 - erosion(i,2)):min(n, n - erosion(i,2)));
    end
    img_erode = zeros([m,n]);
    img_erode(sum(img_proc, 3) == 9) = 1;
    img_erode = logical(img_erode);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % TODO_1: Apply erosion on the image
    % img_boundary = ??
    img_boundary = logical(img .* (~img_erode));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Display the input image
    figure;
    imshow(img_boundary);title('Boundary image');

end