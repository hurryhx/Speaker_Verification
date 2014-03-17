function [x,fs] = reSample(filename, kk, en)

	ext = exist(filename,'file');

	if ext == 2
		[rawData, fs] = wavread(filename);
		rawData = deSlience(rawData);
		n = size(rawData,2);
		x =[];
		k = floor(n/(fs));
		tempData= [];
		for i = 1:k
			tempData(:,i) = rawData( (i-1)*fs +1 : i*fs);
		end

		for i = 1:kk
			tempData = tempData(:,randperm(size(tempData,2)));
			temp = [];
			for j = 1:en
				temp = [temp, tempData(:,j)'];
			end
			x(:,i) = temp';
		end
		%sound(temp,fs);

	else
		fs = -1;
		x = [];
	end

end
