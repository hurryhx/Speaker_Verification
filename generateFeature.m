function [fea] = generateFeature(filename,params)

	[data,fs] = reSample(filename,params.num,params.lenth);


	di = 13;
	fea = [];
	if (fs >0 )
	for i = 1:params.num
		temp = [];
		tempfeature = melcepst(data(:,i),fs,'M',di);

		nn = size(tempfeature,1);

		for j = 1:di
			for k = 3:nn-3
				%tempfeature_d(k,j) = abs(tempfeature(k+2,j) - tempfeature(k,j));
				tempfeature_dd(k,j) = 2*tempfeature(k+2,j) - 2*tempfeature(k-2,j) + tempfeature(k+1,j)-tempfeature(k-1,j);
			end
			tempfeature_d(:,j) = tempfeature_dd(3:nn-3, j);
		end

		for j = 1:di
			temp(6*j -5) = mean(tempfeature(:,j));
			temp(6*j -4) = var(tempfeature(:,j));
			temp(6*j -3) = min(tempfeature(:,j));
			temp(6*j -2) = max(tempfeature(:,j));
			temp(6*j -1) = mean(tempfeature_d(:,j));
			temp(6*j   ) = var(tempfeature_d(:,j));
		end

		%tlpc = lpc(data);
		%tlpcc = lpc2lpcc(tlpc);
		%for k = 6*j+1:6*j+12
		%	temp(k) = tlpcc(k-6*j);
		%end

		fea(:,i) = temp';
	end
	end

end
