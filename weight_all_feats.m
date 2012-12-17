function [artist1_rate artist2_rate] = weight_all_feats(artist_1, artist_2, w, f_test, f_train, s_test, s_train, T)

    % here, w is a vector of length L. ||w|| = 1
    % length(feat_names) = L, too
    % T is our "sureness" threshold - 

   feat_names = {'corner_thresh' 'edge_hist' 'hog' 'color_hist' 'lbp'};
  %  feat_names = {'corner_thresh' 'edge_hist' 'color_hist' 'lbp'};
    
    db = db_setup('.');
    
    firsts = dir(['./images/' artist_1 '*']);
    seconds = dir(['./images/' artist_2 '*']);
    
    first_feats = {};
    second_feats = {};
    
    for i = f_train(1:end) % for all of the training images
        im1 = db.get_image(firsts(i).name); % get the ith image
        im1_feats = {};
        for j = 1:length(w)
            im1_feats = [im1_feats im1.features.(feat_names{j})]; % make a ROW of the features for each
        end
        first_feats = [first_feats; im1_feats];
	end
    
	for i = s_train(1:end) % for all of the training images
        im2 = db.get_image(seconds(i).name);
        im2_feats = {};
        for j = 1:length(w)
            im2_feats = [im2_feats im2.features.(feat_names{j})];
        end
        second_feats = [second_feats; im2_feats];
	end
    
    key = [repmat(0,length(f_train),1); repmat(1,length(s_train),1)];
    
    svms = {};
    
	for i = 1:length(w)
            ff = [];
            sf = [];
		for j = 1:length(f_train)           
            ff = [ff; first_feats{j,i}];
		end
		 for j = 1:length(s_train)
            sf = [sf; second_feats{j,i}];            
		 end
		 svms = [svms svmtrain([ff; sf], key)];
	end

	
    artist1_rate = [];
    artist2_rate = [];
    
    for i=f_test(1:end)
        im = db.get_image(firsts(i).name);
        wsum = 0;
		for j=1:length(w)
			if (svmclassify(svms{j}, im.features.(feat_names{j})) == 0)
                wsum = wsum + w(j);
			end
		end
       % disp(wsum);
        if wsum >= T
            artist1_rate = [artist1_rate 1];
 %       elseif wsum < (1-T)
 %           artist1_rate = [artist1_rate -1];
        else
            artist1_rate = [artist1_rate 0];
        end
    end
    
    for i=s_test(1:end)
        im = db.get_image(seconds(i).name);
        wsum = 0;
        for j=1:length(w)
            if (svmclassify(svms{j}, im.features.(feat_names{j})) == 1)
                wsum = wsum + w(j);
            end
        end
        if wsum >= T
            artist2_rate = [artist2_rate 1];
   %     elseif wsum < 1-T
    %        artist2_rate = [artist2_rate -1];
        else
            artist2_rate = [artist2_rate 0];
        end
    end
    
 %   disp([artist_1 ' identification rate: ' num2str(sum(artist1_rate==1)/length(artist1_rate))]);
 %   disp([artist_2 ' identification rate: ' num2str(sum(artist2_rate==1)/length(artist2_rate))]);
    
 artist1_rate = sum(artist1_rate)/size(f_test,2);
 artist2_rate = sum(artist2_rate)/size(s_test,2);
 
 
 
end

