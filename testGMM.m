clear all;

for i = 55:80
	fprintf('Num %d : ' , i);
	if mod(i,2) == 0
		filename1 = sprintf('../SRT/corpus/Style_Reading/m_0%d_03_30s_1.wav', i);
		filename2 = sprintf('../SRT/corpus/Style_Reading/m_0%d_03_60s_1.wav', i);
	else
		filename1 = sprintf('../SRT/corpus/Style_Reading/f_0%d_03_30s_1.wav', i);
		filename2 = sprintf('../SRT/corpus/Style_Reading/f_0%d_03_60s_1.wav', i);
	end
	ext1 = exist(filename1);
	ext2 = exist(filename2);

	if ( ext1 == 2 & ext2 == 2)
	testpersonGMM(filename1,filename2);
	else 
		fprintf('\n');
	end
end

