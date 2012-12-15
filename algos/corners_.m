function [ n ] = corners_( image, T )

    % k value
    k = 0.05;

    % read in image, convert to grayscale
    im = [];
    if size(image, 3) == 3
        im = rgb2gray(image);
    end
    
    % denoise with gaussian
    f = fspecial('gaussian');
    img = imfilter(im, f);
    
    % get X and Y partial derivatives
    [Ix Iy] = gradient(double(img));
    
    % compute M matrix. this gaussian is for the window.
    H = fspecial('gaussian');
    Ix2 = imfilter(Ix.^2, H);
    Iy2 = imfilter(Iy.^2, H);
    Ixy = imfilter(Ix.*Iy, H);
    
    M = [Ix2 Ixy; Ixy Iy2];
    
    s = size(M);
    Rmat = zeros(s(1)/2, s(2)/2);
    
    all_eigs = [];
    
    for i = 1:s(1)/2
        for j = 1:s(2)/2
            m = get2(M, i, j);
            e = eig(m);
            R = e(1)*e(2) - k*(e(1)+e(2))^2;
            Rmat(i,j) = R;
            all_eigs = [all_eigs; e(1); e(2)];
        end
    end

    R_norm = Rmat / max(max(Rmat));
    c = im2bw(R_norm, T);

    
    n = sum(sum(c));

end

