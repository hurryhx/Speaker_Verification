function genmodel(testid)


d=60;%number of samples.
num=20;%ids
start = 0;
sec=5;%seconds
test_fea_d = [];
for id=start+1:start+num
	testname = sprintf('../SRT/corpus/Train/%d.wav', id);
	ext = exist(testname, 'file');
	if ext == 2
		fparams.num = d;
		fparams.lenth = 5;
		test_fea = generateFeature(testname, fparams);
	end
	test_fea_d = [test_fea_d test_fea];
	for ii=1:d
		ytrain((id-1-start)*d+ii) = id;
	end
end
%trainname = sprintf('../SRT/corpus/Train/%d.wav', testid);
%test_fea = generateFeature(trainname, fparams);
%test_fea_d = [test_fea_d test_fea];
%for ii=1:d
	%ytrain(num*d+ii) = num+1;
%end




params.C = 5;
params.beta = 0.1;
params.symmetric = false;
params.diffusion_dimension = 12;

[phi, lambda, W, D, epsilon_vector] = diffusion_map(test_fea_d, params);

size(ytrain)

if 0
dimension = 8;
T=3;
points = embedding(phi, lambda, T);
for iid = 1:300
	name = sprintf('../SRT/corpus/Test/%d_%d.wav', 21, iid);
	[wav fs] = wavread(name);
	xtest = generateFeature2(wav, fs);
	diff_x = gh_embedding(phi, lambda, test_fea_d, xtest, dimension, W, epsilon_vector);
	new_points(:,iid) = diff_x * diag(lambda.^T);
end
tmp1=knnMethod(points', ytrain, new_points, 10);
tmp2=knnclassify(new_points', points, ytrain', 10);
fprintf('score %d catagory %d\n', tmp1, tmp2);
end

name = strcat(num2str(testid),'model.mat');
save(name);




