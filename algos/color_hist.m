function colors = color_hist(image, num_bins)
	dec = all_dec(image);
	image_ = reshape(dec, (size(image,1)*size(image,2)), 1);
	hist_ = hist(image_,num_bins);
    hist_ = hist_ ./ sum(hist_);
	values = average_intensity(image);
	colors = [hist_ values];
end

function dec_values = all_dec(image)
	dec_values = zeros(size(image,1),size(image,2));
	for i = 1:size(image,1)
		for j = 1:size(image,2)
			dec_values(i,j) = to_decimal(image(i,j,:));
		end
	end
end

function pixel_dec = to_decimal(pixel)
	pixel_dec = bitshift(pixel(1),16) + bitshift(pixel(2),8) + pixel(3);
end

function values = average_intensity(image)
	ave_red = average_red(image);
	ave_green = average_green(image);
	ave_blue = average_blue(image);
	ave_total = (ave_red + ave_blue + ave_green) / 3;
	values = [ave_red ave_green ave_blue ave_total];
end

function ave_red = average_red(im)
	red = im(:,:,1);
	sum_red = sum(sum(red));
	ave_red = sum_red/(size(im,1) * size(im,2));
end

function ave_green = average_green(im)
	green = im(:,:,2);
	sum_green = sum(sum(green));
	ave_green = sum_green/(size(im,1) * size(im,2));
end

function ave_blue = average_blue(im)
	blue = im(:,:,3);
	sum_blue = sum(sum(blue));
	ave_blue = sum_blue/(size(im,1) * size(im,2));
end


































