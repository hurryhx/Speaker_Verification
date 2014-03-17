function out= work()
	clc;
	close all;
	clear;
	
	start = 0;
	second = 5;
	for id=1:100
		if mod(id,2) ==1
			if id < 10
				filename = sprintf('../SRT/corpus/Style_Reading/f_00%d_03.wav', id);
				filename2 = sprintf('../SRT/corpus/Style_Reading/f_00%d_03_%ds_1.wav', id, second);
			elseif id < 100
				filename = sprintf('../SRT/corpus/Style_Reading/f_0%d_03.wav', id);
				filename2 = sprintf('../SRT/corpus/Style_Reading/f_0%d_03_%ds_1.wav', id, second);

			else
				filename = sprintf('../SRT/corpus/Style_Reading/f_%d_03.wav', id);
				filename2 = sprintf('../SRT/corpus/Style_Reading/f_%d_03_%ds_1.wav', id, second);
			end
		else
			if id < 10
				filename = sprintf('../SRT/corpus/Style_Reading/m_00%d_03.wav', id);
				filename2 = sprintf('../SRT/corpus/Style_Reading/m_00%d_03_%ds_1.wav', id, second);
			elseif id < 100
				filename = sprintf('../SRT/corpus/Style_Reading/m_0%d_03.wav', id);
				filename2 = sprintf('../SRT/corpus/Style_Reading/m_0%d_03_%ds_1.wav', id, second);
			else
				filename = sprintf('../SRT/corpus/Style_Reading/m_%d_03.wav', id);
				filename2 = sprintf('../SRT/corpus/Style_Reading/m_%d_03_%ds_1.wav', id, second);
			end
		end

		fprintf(filename);
		ext = exist(filename, 'file')
		if ext==2
			[y,fs] = wavread(filename);
			x = deSlience(y);
			wstart = floor(start*fs)+1; wend = floor((start+second)*fs);
			res = x(wstart:wend);
			wavwrite(res, fs, filename2);
			%sound(x,fs);
		end
	end
end


