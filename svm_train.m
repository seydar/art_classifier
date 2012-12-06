function [firsts_rate seconds_rate ] = svm_train(artist_1, artist_2, feat, n)

   db      = db_setup('.');

	if strcmp(feat, 'sift_hist')
		gen_sift_hist(artist_1, artist_2, 10);
    end
	
    firsts  = dir(['./images/' artist_1 '*']);
    seconds = dir(['./images/' artist_2 '*']);
    
    ensimst = [];
    toiset  = [];
    for i = 1:n
        im = db.get_image(firsts(i).name);
        ensimst = [ensimst; im.features.(feat)];
        
        im = db.get_image(seconds(i).name);
        toiset  = [toiset;  im.features.(feat)];
    end
    
    key = [repmat(0,n, 1)
           repmat(1,n, 1)];
    
    trained_svm = svmtrain([ensimst; toiset], key);
    
    %looking at training rate for firsts
    firsts_rate = 0;
    for i=(n+1):length(firsts)
        im = db.get_image(firsts(i).name);
        if (svmclassify(trained_svm, im.features.(feat)) == 0)
            firsts_rate = firsts_rate + 1;
        end
    end
    firsts_rate = (firsts_rate) / (length(firsts) - n);
    
    seconds_rate = 0;
    for i=(n+1):length(seconds)
        im = db.get_image(seconds(i).name);
%        seconds(i).name;
        if (svmclassify(trained_svm, im.features.(feat)) == 1)
            seconds_rate = seconds_rate + 1;
        end
    end
    seconds_rate = (seconds_rate) / (length(seconds) - n);
    
    
    
end
