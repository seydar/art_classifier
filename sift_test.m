function [ tfr tsr ] = sift_test( artist_1, artist_2, level)
    % 10-fold cross validation
	
	db = db_setup('.');
    firsts = dir(['./images/' artist_1 '*']);
    seconds = dir(['./images/' artist_2 '*']);
    
    f_size = size(firsts);
    s_size = size(seconds);

    all_f_indices = 1:f_size;
    all_s_indices = 1:s_size;
    
    total_first_rate = zeros(10,1);
    total_second_rate = zeros(10,1);
    
	parfor i=1:10
       disp(['testing i = ' num2str(i)])
       f_test = all_f_indices(mod(all_f_indices, 10) == (i-1));
       f_train = all_f_indices(mod(all_f_indices, 10) ~= (i-1));
       
       s_test = all_s_indices(mod(all_s_indices, 10) == (i-1));
       s_train = all_s_indices(mod(all_s_indices, 10) ~= (i-1));
       
    %   [art_1_rate art_2_rate] = weight_all_feats(artist_1, artist_2, w, f_test, f_train, s_test, s_train, T);
	
		[art_1_rate art_2_rate] = svm_sift(db, level, artist_1, artist_2, f_test, f_train, s_test, s_train);
	

       total_first_rate(i) = art_1_rate*(size(f_test,2)/f_size(1));
       total_second_rate(i) = art_2_rate*(size(s_test,2)/s_size(1));
	      
	end
	
	
    tfr = sum(total_first_rate);
    tsr = sum(total_second_rate);
   

end

function [fr sr] = svm_sift(db, level, art_1, art_2, f_test, f_train, s_test, s_train)

	%steps to do:
	%1)	extract sift data for the level needed
	%2)	generate codebook by clustering features from f_train and s_train
	%3)	build a kd-tree using that info
	%4)	generate histograms for each of the testing images as well as the
	%training images
	%5)	train svm with training images
	%6)	run svm with testing images
	
	
	%1)	extract sift data for the level needed
		
	firsts = dir(['./images/' art_1 '*']);
	seconds = dir(['./images/' art_2 '*']);
	first_feats = [];
	second_feats = [];
	
	for i = f_train(1:end)
		im1 = db.get_image(firsts(i).name);
		first_feats = [first_feats im1.features.(['rawsift' num2str(level)])];		
	end
	
	[f_words, ~] = vl_ikmeans(first_feats, 10);	%using 10-means clustering
	
	for i = s_train(1:end)
		im2 = db.get_image(seconds(i).name);
		second_feats = [second_feats im2.features.(['rawsift' num2str(level)])];		
	end
	
	[s_words, ~] = vl_ikmeans(second_feats, 10);

	%generate codebook
	
	codebook = [f_words s_words];
	codebook = single(codebook);
%	size(codebook)
	
	%build kd-tree
	
	artist_tree = vl_kdtreebuild(codebook);
	
	%gen histograms for training data
	%gen histograms for testing data

	[t_f_hist, t_s_hist] = gen_sift_hist_(db, artist_tree, codebook, level, firsts, seconds, f_train, s_train);
	[f_test_hist, s_test_hist] = gen_sift_hist_(db, artist_tree, codebook, level, firsts, seconds, f_test, s_test);

	
	%training svm
	
	key = [repmat(0,length(f_train),1); repmat(1,length(s_train),1)];
	
	trained_svm = svmtrain([t_f_hist; t_s_hist], key);
	
	
	artist1_rate = 0;
	artist2_rate = 0;

	
	
	for i=1:size(f_test_hist,1)
    %    im = db.get_image(firsts(i).name);
		if (svmclassify(trained_svm, f_test_hist(i,:)) == 0)
			artist1_rate = artist1_rate + 1;
		end
	end
    
    for i=1:size(s_test_hist,1)
   %     im = db.get_image(seconds(i).name);
		if (svmclassify(trained_svm, s_test_hist(i,:)) == 1)
			artist2_rate = artist2_rate + 1;			
		end
    end
    
 %   disp([artist_1 ' identification rate: ' num2str(sum(artist1_rate==1)/length(artist1_rate))]);
 %   disp([artist_2 ' identification rate: ' num2str(sum(artist2_rate==1)/length(artist2_rate))]);
    
	fr = artist1_rate/size(f_test,2);
	sr = artist2_rate/size(s_test,2);
	


end

function [first_hist, second_hist] = gen_sift_hist_(db, art_tree, code_book, level,  firsts, seconds, f, s)	%input is either training or testing

	image_clusters = [];
	all_hists = [];
	first_hist = [];
	second_hist = [];
	
	for j = f(1:end)
		im = db.get_image(firsts(j).name);
		d = im.features.(['rawsift' num2str(level)]);
		image_clusters = [];
		for k = 1:size(d,2)
			[i, ~] = vl_kdtreequery(art_tree, code_book, single(d(:,k)));
			image_clusters = [image_clusters; i];
		end
		hist_ = hist(double(image_clusters), 20);
		hist_ = hist_ ./ sum(hist_);
		first_hist = [first_hist; hist_];
	end
	
	
	for j = s(1:end)
		im = db.get_image(seconds(j).name);
		d = im.features.(['rawsift' num2str(level)]);
		image_clusters = [];
		for k = 1:size(d,2)
			[i, ~] = vl_kdtreequery(art_tree, code_book, single(d(:,k)));
			image_clusters = [image_clusters; i];
		end
		hist_ = hist(double(image_clusters), 20);
		hist_ = hist_ ./ sum(hist_);
		second_hist = [second_hist; hist_];
	end

	
	
	
end































