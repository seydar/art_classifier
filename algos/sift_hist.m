function [hist_] = sift_hist(art_tree, code_book, K, image, levels)

	[~, d] = vl_sift(single(rgb2gray(image)), 'levels',levels);
	
	image_clusters = [];
	for j = 1:size(d,2)
		[i, ~] = vl_kdtreequery(art_tree, code_book, single(d(:,j)));
		image_clusters = [image_clusters; i];	
	end
	
	hist_ = hist(double(image_clusters), 2*K);
    hist_ = hist_ ./ sum(hist_);
	
end
