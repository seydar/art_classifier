im = imread('./images/picasso23.jpg');
    if (size(im,1) * size(im,2)) > (480*640)
	    scale = (640*480)/(size(im,1) * size(im,2));
        im = imresize(im, scale);
    end

im_ = single(rgb2gray(im));
%possible changes

%fc = [0;0;10;0] ;
[f,d] = vl_sift(im_,'levels',1000) ;
%[f,d] = vl_sift(im_,'Magnif',0.5) ;

%[f,d] = vl_sift(im_);
imshow(im);
hold on
%perm = randperm(size(f,2)) ;
sel = perm(1:50) ;
%size(f)
h1 = vl_plotframe(f(:,sel)) ;
h2 = vl_plotframe(f(:,sel)) ;
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;
h3 = vl_plotsiftdescriptor(d(:,sel),f(:,sel)) ;
set(h3,'color','g') ;

hold off