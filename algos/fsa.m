function ret = fsa(im)
  f = rgb2gray(im);
  F = fft2(f);
  c = cov(F);
  avg = mean(mean(F));
  c_mean = mean(mean(c));
  ret = [real(c_mean) imag(c_mean) real(avg) imag(avg)]; 
end

