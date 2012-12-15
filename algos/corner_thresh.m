function [v] = corner_thresh(image)

    [n1] = corners_(image, 0.2);
    [n2] = corners_(image, 0.4);
    [n3] = corners_(image, 0.6);
    [n4] = corners_(image, 0.8);

    v = [n1 n2 n3 n4];

end