function ss = nms(scale_space, sz)

  s = size(scale_space);
  ss = zeros(s(1), s(2), s(3));
  max3 = @(x) max(max(max(x)));

  for i = 1:size(scale_space, 1)
    x = [max(i - sz, 1) min(size(scale_space, 1), i + sz)];
    for j = 1:size(scale_space, 2)
      y = [max(j - sz, 1) min(size(scale_space, 2), j + sz)];
      for k = 1:size(scale_space, 3)
        z = [max(k - sz, 1) min(size(scale_space, 3), k + sz)];
        if scale_space(i, j, k) ~= max3(scale_space(x(1):x(2), y(1):y(2), z(1):z(2)))
          ss(i, j, k) = 0;
        else
          ss(i, j, k) = scale_space(i, j, k);
        end
      end
    end
  end

  %ss = ordfilt3D(scale_space, 27);
end

