% SEGMENT_PANDA contains the implementation of the main routine for Assignment 2. 
% This routine reads a image, which contains three intensity classes.
% The routine employs the Expectation-maximization method to estimate the parameters
% of the three intensity classes with a mixture of three Gaussian distributions, and
% segment the image with minimum error thresholds.
%  
function segment_image() 

% Define convergence threshold.
threshold = 0.01;

% Read the panda image and convert the color image into grayscale image.
Im = imread('sunset.jpg');
Im = rgb2gray(Im);
% Build a histgoram of the image, it is for the sake of
% parameter estimations and visualization.
Hist = imhist(Im,256)';

%
% The Expectation-maximization algorithm.
%

% Initialize the paramters.
Weight = zeros(3,1);
Mu = zeros(3,1);
Sigma = zeros(3,1);
Weight(1) = 0.35;
Weight(2) = 0.50;
Weight(3) = 0.15;
Mu(1) = 5;
Mu(2) = 90;
Mu(3) = 230;
Sigma(1) = 1;
Sigma(2) = 10;
Sigma(3) = 20;

itn = 1;
while(1)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% TODO_1: Estimate the expected posterior probabilities.
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	pixind = 1:256; % z
    Probh = Hist/sum(Hist); % true P_0(z), not used
    Probz = zeros(3, 256);
	Prob = zeros(3, 256);
	for i = 1:3
		Probz(i, :) = normpdf(pixind, Mu(i), Sigma(i)); % P(z|i)
	end
	PHist = Weight' * Probz; % predicted P(z)
    for j = 1:3
		Prob(j, :) = Weight(j) .* Probz(j, :) ./ PHist; % P(i|z)
    end
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Allocate spaces for the parameters estimated.
	NewWeight = zeros(3,1);
	NewMu = zeros(3,1);
	NewSigma = zeros(3,1);
    
    % TODO_2: Estimate the parameters.
    for k = 1:3
		NewMu(k) = sum( pixind .* Hist .* Prob(k,:)) / sum(Prob(k,:) .* Hist);
		NewSigma(k) = sqrt(sum(Prob(k, :) .* (pixind - NewMu(k)).^2 .* Hist) / sum(Prob(k, :) .* Hist));
		NewWeight(k) = sum(Prob(k, :) .* Hist) / sum(Hist);
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
    % Check if convergence is reached.
	DiffWeight = abs(NewWeight-Weight)./Weight;
	DiffMu = abs(NewMu-Mu)./Mu;
	DiffSigma = abs(NewSigma-Sigma)./Sigma;
	
	if (max(DiffWeight) < threshold) & (max(DiffMu) < threshold) & (max(DiffSigma) < threshold)
        break;
	end
	
	% Update the parameters.
	Weight = NewWeight;
	Mu = NewMu;
	Sigma = NewSigma;
    
    disp(['Iteration #' num2str(itn)]);
    disp([' Weight: ' num2str(Weight(1)) ' ' num2str(Weight(2)) ' ' num2str(Weight(3))]);
    disp([' Mu: ' num2str(Mu(1)) ' ' num2str(Mu(2)) ' ' num2str(Mu(3))]);
    disp([' Sigma: ' num2str(Sigma(1)) ' ' num2str(Sigma(2)) ' ' num2str(Sigma(3))]);
    itn = itn + 1;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO_3(a): Compute minimum error threshold between the first and the second
% Gaussian distributions.
%
% FirstThreshold = ?
T = (Mu(1) + Mu(2))/2;
dist = abs(Mu(2) - Mu(1));
iter = 1;
score_1 = Weight(1) * normpdf(T, Mu(1), Sigma(1));
score_2 = Weight(2) * normpdf(T, Mu(2), Sigma(2));
while abs(score_1 - score_2) > 1e-3
    iter = iter + 1;
    if score_1 > score_2
        T = T + dist * 0.5^iter;
    else
        T = T - dist * 0.5^iter;
    end
    score_1 = Weight(1) * normpdf(T, Mu(1), Sigma(1));
    score_2 = Weight(2) * normpdf(T, Mu(2), Sigma(2));
end
FirstThreshold = T;
 
% TODO_3(b): Compute minimum error threshold between the second and the third
% Gaussian distributions.
%
% SecondThreshold = ?
T = (Mu(2) + Mu(3))/2;
dist = abs(Mu(3) - Mu(2));
iter = 1;
score_2 = Weight(2) * normpdf(T, Mu(2), Sigma(2));
score_3 = Weight(3) * normpdf(T, Mu(3), Sigma(3));
while abs(score_2 - score_3) > 1e-3
    iter = iter + 1;
    if score_2 > score_3
        T = T + dist * 0.5^iter;
    else
        T = T - dist * 0.5^iter;
    end
    score_2 = Weight(2) * normpdf(T, Mu(2), Sigma(2));
    score_3 = Weight(3) * normpdf(T, Mu(3), Sigma(3));
end
SecondThreshold = T;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Show the segmentation results.
figure;
subplot(2,3,1);imshow(Im);title('Sunset');
subplot(2,3,3);imshow(Im<=FirstThreshold);title('First Intensity Class');
subplot(2,3,4);imshow(Im>FirstThreshold & Im<SecondThreshold);title('Second Intensity Class');
subplot(2,3,5);imshow(Im>=SecondThreshold);title('Third Intensity Class');
Params = zeros(9,1);
Params(1) = Weight(1);
Params(2) = Mu(1);
Params(3) = Sigma(1);
Params(4) = Weight(2);
Params(5) = Mu(2);
Params(6) = Sigma(2);
Params(7) = Weight(3);
Params(8) = Mu(3);
Params(9) = Sigma(3);
subplot(2,3,2);ggg(Params,Hist);