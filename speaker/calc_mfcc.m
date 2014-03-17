function mfcc_features = calc_mfcc(wavdata, samp_rate)

    FRAME_LEN = 64; % 32 ms for sampling rate of 16KHz

    audio = miraudio(wavdata, samp_rate);

    frames = mirframe(audio, 'Length', FRAME_LEN, 'sp');

    frame_mfcc = mirmfcc(frames);

    mfcc_data = mirgetdata(frame_mfcc);

	mfcc_features = mfcc_data;
    %mfcc_features = values_to_features(mfcc_data);
