function [vote] = sift_vote(sift_svms, image, artist_tree, codebook)


	vote_sum = 0;

	for i=1:6
	
		hist_ = gen_one_sift_hist(artist_tree{i}, codebook, (i+2), image);
		if (svmclassify(sift_svms{i}, hist_) == 1)
			vote_sum = vote_sum + 1;
			if i == 6
				vote_sum = vote_sum + 1;
			end
		end
	
	end

	vote = round(vote_sum / 7);

end