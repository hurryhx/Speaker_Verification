close all;
T=3;

ans = [];
count = 0;

data = [];
new_points = [];
y_train=[];
dimension = 12;

cc = [1:1:40]


for iii =  21:21
	namename = strcat(num2str(iii), 'model.mat');
	load(namename);
	points = embedding(phi, lambda, T);

for id22 = 1:40
	id2 = cc(id22);
	fprintf('target: %d label %d\n', id2, iii);
	
	if (iii == id2)
		nnn = 300;
	else
		nnn = 300;
	end
	
	new_points = [];

	for iid = 1:nnn
		name2 = sprintf('../SRT/corpus/Test/%d_%d.wav', id2, iid);
		[wav2 fs2] = wavread(name2);
		xtest = generateFeature2(wav2, fs2);
		diff_x = gh_embedding(phi, lambda, test_fea_d, xtest, dimension, W, epsilon_vector);
		new_points(:,iid) = diff_x * diag(lambda.^T);
	end
	size(new_points);
	size(ytrain);
	size(points);

	new_points(:,1:5)


	tmp1 = [];
	tmp2 = [];
	tmp1=knnclassify(new_points', points, ytrain', 15);
	
	for iddd =1:nnn
		xlabel(iddd) = id2;
	end
	
	tmp2=knnMethod(points', ytrain, new_points, xlabel,15)';
	%tmp1 = tmp2;

	tmp = [tmp1 tmp2]

	nn = size(tmp2,1);

	for jj = 1:nn
		count = count + 1;
		data(count).target = iii;
		data(count).score = tmp2(jj);
		data(count).label = id2;
	end
end
end

save('data41_60_2.mat','data');



