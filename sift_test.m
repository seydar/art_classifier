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
    
	%parfor i=1:10
      	  
  %     disp(['testing i = ' num2str(i)])
       f_test = all_f_indices(mod(all_f_indices, 10) == (i-1));
       f_train = all_f_indices(mod(all_f_indices, 10) ~= (i-1));
       
       s_test = all_s_indices(mod(all_s_indices, 10) == (i-1));
       s_train = all_s_indices(mod(all_s_indices, 10) ~= (i-1));
       
    %   [art_1_rate art_2_rate] = weight_all_feats(artist_1, artist_2, w, f_test, f_train, s_test, s_train, T);
	
		[art_1_rate art_2_rate] = svm_sift(db, level, artist_1, artist_2, f_test, f_train, s_test, s_train);
	

       total_first_rate(i) = art_1_rate*(size(f_test,2)/f_size(1));
       total_second_rate(i) = art_2_rate*(size(s_test,2)/s_size(1));
	      
%	end
	
	
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
	
	[s_words, ~] = vl_ikmeans(second_feats, K);

	%generate codebook
	
	codebook = [f_words s_words];
	
	size(codebook)
	
	%build kd-tree
	
	
	%gen histograms for training data
	
	
	
	%gen histograms for testing data
	
	
	%{
	
	
	%training svm
	
	key = [repmat(0,length(f_train),1); repmat(1,length(s_train),1)];
	
	trained_svm = svmtrain([first_feats; second_feats], key);
	
	
	artist1_rate = 0;
	artist2_rate = 0;
	
	for i=f_test(1:end)
        im = db.get_image(firsts(i).name);
        if (svmclassify(trained_svm, im.features.(['sifthist' art_1 art_2 num2str(level)])) == 0)
			artist1_rate = artist1_rate + 1;
		end
	end
    
    for i=s_test(1:end)
        im = db.get_image(seconds(i).name);
        if (svmclassify(trained_svm, im.features.(['sifthist' art_1 art_2 num2str(level)])) == 1)
			artist2_rate = artist2_rate + 1;			
		end
    end
    
 %   disp([artist_1 ' identification rate: ' num2str(sum(artist1_rate==1)/length(artist1_rate))]);
 %   disp([artist_2 ' identification rate: ' num2str(sum(artist2_rate==1)/length(artist2_rate))]);
    
	fr = artist1_rate/size(f_test,2);
	sr = artist2_rate/size(s_test,2);
		%}


end

%function [db] = gen_sift_hist_test(db, 































