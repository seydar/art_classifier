function [ tfr tsr ] = one_feat_cross( artist_1, artist_2, feature, T )

    % 10-fold cross validation

    firsts = dir(['./images/' artist_1 '*']);
    seconds = dir(['./images/' artist_2 '*']);
    
    f_size = size(firsts);
    s_size = size(seconds);

    all_f_indices = 1:f_size;
    all_s_indices = 1:s_size;
    
    total_first_rate = zeros(10,1);
    total_second_rate = zeros(10,1);
    
	parfor i=1:10
       f_test = all_f_indices(mod(all_f_indices, 10) == (i-1));
       f_train = all_f_indices(mod(all_f_indices, 10) ~= (i-1));
       
       s_test = all_s_indices(mod(all_s_indices, 10) == (i-1));
       s_train = all_s_indices(mod(all_s_indices, 10) ~= (i-1));
       
		[art_1_rate art_2_rate] = one_feat(artist_1, artist_2, feature, f_test, f_train, s_test, s_train, T);
       total_first_rate(i) = art_1_rate*(size(f_test,2)/f_size(1));
       total_second_rate(i) = art_2_rate*(size(s_test,2)/s_size(1));
	      
	end
	
	
    tfr = sum(total_first_rate);
    tsr = sum(total_second_rate);
    
end

function [fr sr] = one_feat(artist_1, artist_2, feat, f_test, f_train, s_test, s_train, T)

	db = db_setup('.');
    firsts = dir(['./images/' artist_1 '*']);
    seconds = dir(['./images/' artist_2 '*']);

	first_feats = [];
	second_feats = [];
	im1_feats = [];
	im2_feats = [];
	
	for i = f_train(1:end) % for all of the training images
        im1 = db.get_image(firsts(i).name); % get the ith image
        first_feats = [first_feats; im1.features.(feat)];
	end
	
	for i = s_train(1:end) % for all of the training images
        im2 = db.get_image(seconds(i).name);
        second_feats = [second_feats; im2.features.(feat)];
	end
	
	key = [repmat(0,length(f_train),1); repmat(1,length(s_train),1)];
	

	
	trained_svm = svmtrain([first_feats; second_feats], key);
	
	artist1_rate = 0;
	artist2_rate = 0;
	
	for i=1:size(f_test,1)
		 im1 = db.get_image(firsts(i).name);
		if (svmclassify(trained_svm, im1.features.(feat)) == 0)
			artist1_rate = artist1_rate + 1;
		end
	end
    
    for i=1:size(s_test,1)
		im2 = db.get_image(seconds(i).name);
		if (svmclassify(trained_svm, im2.features.(feat)) == 1)
			artist2_rate = artist2_rate + 1;			
		end
    end

	fr = artist1_rate/size(f_test,2);
	sr = artist2_rate/size(s_test,2);
	
	
end




















