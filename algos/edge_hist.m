function [edge_hist] = edge_hist( image )
	
	tic
	
	T = 0.3; % R threshold - to ignore corners
	hsize = 10;
	sigma = 1;
	step = 5; % calculate edge every STEP pixels
	bins = 4;
	
	k = 0.05; % k value
	im = rgb2gray(image);
	
	f = fspecial('gaussian');
	img = imfilter(im, f); % denoised image
	
	[Ix Iy] = gradient(double(img));
	
	H = fspecial('gaussian', hsize, sigma);
	Ix2 = imfilter(Ix.^2, H);
	Iy2 = imfilter(Iy.^2, H);
	Ixy = imfilter(Ix.*Iy, H);
	

	all_eigs = zeros(ceil((size(Ix2,1)*size(Ix2,2))/(step*step)),1);
	size(all_eigs);
	for i = 1:step:size(Ix2, 1)
		for j = 1:step:size(Ix2, 2)
			
			m = [Ix2(i,j) Ixy(i,j); Ixy(i,j) Iy2(i,j)];
			[v e] = eigs(m);
		%	all_eigs = [all_eigs; max(e(1), e(2))];
		    all_eigs(i*j + j) = max(e(1),e(2));
			
		end
	end
	
	all_eigs = all_eigs ./ max(all_eigs);
	all_eigs = all_eigs .^ (1/2);
	edge_hist = hist(all_eigs, bins);
	edge_hist = log(edge_hist);
	
	toc
	
end
