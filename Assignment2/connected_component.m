% connected_component.m contains the implementation of the main routine for Question 1 in Assignment 2. 
% This function search for all connected component on the input image. It should output the total number of
% connected components, number of pixels in each connected component and
% display the largest connected component. Note that you are not allow to
% use the bwlabel/bwlabeln/bwconncomp matlab built-in function in this
% question.

function connected_component()
    %Read the input image and convert it to binary image (0,1)
    IM = imread('cc_image.jpg');
    BW = im2bw(IM);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% TODO_1: Search for all connected components with connectivity equals
	% to 8 and output the result to the command window in following format:
    % There are total {number of regions} region(s) :
    % Region 1, no. of pixels = {number of pixels}
    % Region 2, no. of pixels = {number of pixels}
    % ...
    next_pixel = [-1 -1; -1 0; -1 1; 0 -1; 0 1; 1 -1; 1 0; 1 1];
    [m, n] = size(BW);
    BW_mk = zeros([m,n]);
    region_idx = 0;
    for i = 1:m 
        for j = 1:n
            if ((BW(m,n) > 0 ) & (BW_mk(m,n) == 0))
                BW_mk(m,n) = 1;
            end
        end
    end    
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% TODO_2: Find the largest connected component in binary format (0,1).
	% L_CC = ??
    
    
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    figure;
    subplot(1,2,1);imshow(BW);title('Input image');
    subplot(1,2,2);imshow(L_CC);title('Largest connected component');
    
end

