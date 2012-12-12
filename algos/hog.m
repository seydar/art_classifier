% from http://www.mathworks.com/matlabcentral/fileexchange/28689-hog-descriptor-for-matlab
function H = hog(pixels)
  pixels    = double(pixels);
  [L C]     = size(pixels);
  s = [L C]; % this is actually necessary

  nwin_x = 3;
  nwin_y = 3;
  nbins  = 9;
  H      = zeros(nwin_x * nwin_y * nbins, 1);
  m      = sqrt(s(1) / 2);

  if s(2) == 1
    pixels = im_recover(pixels, m, 2 * m);
    s = [2 * m, m];
  end

  step_x  = floor(s(2) / (nwin_x + 1));
  step_y  = floor(s(1) / (nwin_y + 1));
  cont    = 0;
  hx      = [-1 0 1];
  hy      = -hx';

  grad_xr = imfilter(pixels, hx);
  grad_yu = imfilter(pixels, hy);
  angles  = atan2(grad_yu, grad_xr);
  mags    = ((grad_yu .^ 2) + (grad_xr .^ 2)) .^ 0.5;

  for n = 0:(nwin_y - 1)
    for m = 0:(nwin_x - 1)
      cont    = cont + 1;
      angles2 = angles((n * step_y + 1):((n + 2) * step_y), ...
                       (m * step_x + 1):((m + 2) * step_x));
      mags2   =   mags((n * step_y + 1):((n + 2) * step_y), ...
                       (m * step_x + 1):((m + 2) * step_x));

      v_angles = angles2(:);
      v_mags   = mags2(:);

      K   = max(size(v_angles));
      bin = 0;
      H2  = zeros(nbins, 1);
      for ang_lim = (-pi + 2 * pi / nbins):(2 * pi / nbins):pi
        bin = bin + 1;
        for k = 1:K
          if v_angles(k) < ang_lim
            v_angles(k) = 100;
            H2(bin) = H2(bin) + v_mags(k);
          end
        end
      end

      H2 = H2 / (norm(H2) + 0.01);
      H(((cont - 1) * nbins + 1):(cont * nbins), 1) = H2;
    end
  end
end

