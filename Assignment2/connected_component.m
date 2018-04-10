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
    [m, n] = size(BW);
    BW_mk = zeros([m,n]);
    ext_BW = zeros([m+1, n+2]);
    ext_BW(2:m+1 , 2:n+1) = BW;
    ext_mk = zeros([m+1, n+2]);
    ext_mk(2:m+1 , 2:n+1) = BW_mk;
    region_id = 1;
    for i = 1:m
        for j = 1:n
            if(ext_BW(i+1 , j+1) > 0)
                if(sum(sum(ext_BW(i:i+1, j:j+1)) + ext_BW(i,j+2) > 1))
                    ext_mk(i+1, j+1) = max([ext_mk(i,j), ext_mk(i+1,j), ext_mk(i,j+1), ext_mk(i,j+2)]);
                    if ((ext_mk(i,j) > 0) && (ext_mk(i,j) ~= ext_mk(i+1, j+1)))
                        ext_mk(ext_mk == ext_mk(i,j)) = ext_mk(i+1, j+1);
                    end
                    if ((ext_mk(i+1,j) > 0) && (ext_mk(i+1,j) ~= ext_mk(i+1, j+1)))
                        ext_mk(ext_mk == ext_mk(i+1,j)) = ext_mk(i+1, j+1);
                    end
                    if ((ext_mk(i,j+1) > 0) && (ext_mk(i,j+1) ~= ext_mk(i+1, j+1)))
                        ext_mk(ext_mk == ext_mk(i,j+1)) = ext_mk(i+1, j+1);
                    end
                    if ((ext_mk(i,j+2) > 0) && (ext_mk(i,j+2) ~= ext_mk(i+1, j+1)))
                        ext_mk(ext_mk == ext_mk(i,j+2)) = ext_mk(i+1, j+1);
                    end
                else
                    ext_mk(i+1, j+1) = region_id;
                    region_id = region_id + 1;
                end
            end
        end
    end
    % relabel
    extrel_mk = zeros([m,n]);
    rel_id = 1;
    iter_id = 1;
    ccnum = [];
    while (iter_id < region_id)
        numOfPix = sum(sum(ext_mk == iter_id));
        if (numOfPix > 0)
            extrel_mk(ext_mk == iter_id) = rel_id;
            rel_id = rel_id + 1;
            ccnum = [ccnum; rel_id, numOfPix];
            disp(['Region ', num2str(rel_id - 1), ', no. of pixels = ', num2str(numOfPix)]);
        end
        iter_id = iter_id + 1;
    end

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% TODO_2: Find the largest connected component in binary format (0,1).
	% L_CC = ??
    ext_LCC = zeros([m+1, n+2]);
    [~, max_id] = max(ccnum(:,2));
    ext_LCC(extrel_mk == max_id) = 1;
    L_CC = ext_LCC(2:m, 2:n+1);
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    figure;
    subplot(1,2,1);imshow(BW);title('Input image');
    subplot(1,2,2);imshow(L_CC);title('Largest connected component');
    
end

