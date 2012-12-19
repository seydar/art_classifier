function [hist_] = gen_one_sift_hist(art_tree, code_book, level, image)

	image_clusters = [];
	hist_ = [];
	d = image.features.(['rawsift' num2str(level)]);
	image_clusters = [];
	for k = 1:size(d,2)
		[i, ~] = vl_kdtreequery(art_tree, code_book, single(d(:,k)));
		image_clusters = [image_clusters; i];
	end
	hist_ = hist(double(image_clusters), 20);
	hist_ = hist_ ./ sum(hist_);

end
