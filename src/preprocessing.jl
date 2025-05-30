# -*- coding: utf-8 -*-
# @author: max (max@mdotmonar.ch)

using HDF5
using DSP
using Statistics
using CurveFit

# file handling parameters
data_folder = "data"
stim_suffix = "_chirp" #"_chirpLED_canon"

# signal processing parameters
sampling_rate = 20000
nyquist_frequency = 0.5 * sampling_rate
filt_order = 5

# electrodes and events
N_elec = 252
N_rep = 10

# reading event list
col_start = 2
col_end = 3
if occursin("LED_canon", stim_suffix) #LED_canon experiments have different event_list structure
	col_start = 1
	col_end = 2
end

function group_check(file, list, i=0)
	if i == length(list)
		return true
	end
	path = "/"*join(list[1:i], "/")
	if list[i+1] in keys(file[path])
		return group_check(file, list, i+1)
	end
	return false
end

function signal_reconstruct(signal, info)
	return [(s-info[:ADZero])*(info[:ConversionFactor]*(10.0^info[:Exponent])) for s in signal]
end

function high_pass_filter(signal, nco, order)
	filter = digitalfilter(Highpass(nco), Butterworth(order))
	return filtfilt(filter, signal)
end

function band_pass_filter(signal, nco_low, nco_high, order)
	filter = digitalfilter(Bandpass(nco_low, nco_high), Butterworth(order))
	return filtfilt(filter, signal)
end

function notch_filter(signal, nyquist_frequency, notch_freq=50, order=4)
	bandwidth = 2  # Hz (defines sharpness of the notch)
	# Normalize frequencies to Nyquist (fs/2)
	low = (notch_freq - bandwidth/2) / (nyquist_frequency)
	high = (notch_freq + bandwidth/2) / (nyquist_frequency)
	# Design Butterworth notch filter
	notch = digitalfilter(Bandstop(low, high), Butterworth(order))
	return filtfilt(notch, signal)
end

function filter_and_resample(dataset, filter, resampling_rate)
	h5open("./preprocessed_data/"*dataset*stim_suffix*"_preprocessed.h5", "cw") do preprocessed_file
		# check if average_signal group exists
		if group_check(preprocessed_file, ["electrode_0"])
			println("Skipping preprocessing...")
			return
		end

		# open raw file
		file = h5open(data_folder*"/"*dataset*stim_suffix*".h5", "r")
		stream = read(file, "Data/Recording_0/AnalogStream/Stream_0")
		close(file)

		# open event list file

		signal_length = trunc(Int, length(stream["ChannelData"])/N_elec)	# 252 channels typically

		for i in 1:N_elec
			println("Processing electrode_"*string(i-1)*"...")

			info = stream["InfoChannel"][i]
			signal_raw = stream["ChannelData"][signal_length*(i-1)+1:signal_length*i]

			signal = signal_reconstruct(signal_raw, info)
			signal = [s*1000 for s in signal] # Convert from V to mV

			for j in 2:(N_rep + 1) #add 1 to indices-->first column header
				println("Event "*string(j-1))
				csv_file = readlines(data_folder*"/event_list_"*dataset*stim_suffix*".csv")
				event_start = [split(line, ",") for line in csv_file][j][col_start]
				event_start = parse(Int, event_start)
				event_end = [split(line, ",") for line in csv_file][j][col_end]
				event_end = parse(Int, event_end)

				println("Event times: "*string(event_start)*" and "*string(event_end))

				subsignal = signal[event_start:event_end]

				# filter signal
				if filter["type"] == "HPF"
					filtered_signal = high_pass_filter(subsignal, filter["cutoff"]/nyquist_frequency, filt_order)
				elseif filter["type"] == "BPF"
					filtered_signal = band_pass_filter(subsignal, filter["cutoff_low"]/nyquist_frequency, filter["cutoff_high"]/nyquist_frequency, filt_order)
					# filtered_signal = notch_filter(filtered_signal, nyquist_frequency, 50)
				end
				println("Signal filtered...")

				# resample signal
				step = trunc(Int, sampling_rate / resampling_rate)
				resampled_signal = filtered_signal[1:step:end]

				preprocessed_file["electrode_"*string(i-1)*"/event_"*string(j-1)*"/data"] = resampled_signal
				println("Done")

			end
		end
		println("Done.")
	end
end

function filter_and_resample_photodiode(dataset, filter, resampling_rate)
	h5open("./preprocessed_data/"*dataset*stim_suffix*"_preprocessed.h5", "cw") do preprocessed_file
		# check if average_signal group exists
		if group_check(preprocessed_file, ["photodiode"])
			println("Skipping preprocessing of photodiode channel...")
			return
		end

		# open raw file
		file = h5open(data_folder*"/"*dataset*stim_suffix*".h5", "r")
		stream = read(file, "Data/Recording_0/AnalogStream/Stream_1")
		close(file)

		# open event list file

		signal_length = trunc(Int, length(stream["ChannelData"])/4)	# 4 channels

		for i in [1,]
			println("Processing photodiode...")

			info = stream["InfoChannel"][i]
			signal_raw = stream["ChannelData"][signal_length*(i-1)+1:signal_length*i]

			signal = signal_reconstruct(signal_raw, info)
			signal = [s*1000 for s in signal] # Convert from V to mV

			for j in 2:(N_rep + 1) #add 1 to indices-->first column header
				csv_file = readlines(data_folder*"/event_list_"*dataset*stim_suffix*".csv")
				event_start = [split(line, ",") for line in csv_file][j][col_start]
				event_start = parse(Int, event_start)
				event_end = [split(line, ",") for line in csv_file][j][col_end]
				event_end = parse(Int, event_end)

				subsignal = signal[event_start:event_end]

				# filter signal
				if filter["type"] == "HPF"
					filtered_signal = high_pass_filter(subsignal, filter["cutoff"]/nyquist_frequency, filt_order)
				elseif filter["type"] == "BPF"
					filtered_signal = band_pass_filter(subsignal, filter["cutoff_low"]/nyquist_frequency, filter["cutoff_high"]/nyquist_frequency, filt_order)
				end

				# resample signal
				step = trunc(Int, sampling_rate / resampling_rate)
				resampled_signal = filtered_signal[1:step:end]

				preprocessed_file["photodiode"*"/event_"*string(j-1)*"/data"] = resampled_signal
			end
		end
		println("Done.")
	end
end

function compute_and_save_snr(dataset, resampling_rate)
    sec = 1 #seconds of noise to consider in SNR calculation
    h5open(data_folder * "/" * dataset * "_SNR.h5", "cw") do SNR
		# check if average_signal group exists
		if group_check(SNR, ["electrode_0", "SNR"])
			println("Skipping SNR calculation for dataset: "* dataset)
			return
		end

		# open raw file
		file = h5open(data_folder * "/" * dataset * stim_suffix * ".h5", "r")
		stream = read(file, "Data/Recording_0/AnalogStream/Stream_0")
		close(file)

		# open event list file
		signal_length = trunc(Int, length(stream["ChannelData"])/N_elec)
       
        #read events file
		csv_file = readlines(data_folder*"/event_list_"*dataset*stim_suffix*".csv")
        #get the first event to estimate size of matrices
		event_start = [split(line, ",") for line in csv_file][2][col_start] #first event is row 2
		event_start = parse(Int, event_start)
		event_end = [split(line, ",") for line in csv_file][2][col_end]
		event_end = parse(Int, event_end)

        step = trunc(Int, sampling_rate / resampling_rate) #for resampling

        for i in 1:N_elec
			println("Processing electrode_"*string(i-1)*"...")

			info = stream["InfoChannel"][i]
			signal_raw = stream["ChannelData"][signal_length*(i-1)+1:signal_length*i]

			signal = signal_reconstruct(signal_raw, info)
			signal = [s*1000 for s in signal] # Convert from V to mV

			subsignal = signal[event_start:event_end]
			noisesignal = signal[event_start - Int(sec*sampling_rate) : event_start]
            
			resampled_signal = subsignal[1:step:end]
			resampled_noise = noisesignal[1:step:end]

			#time_signal = length(resampled_signal)/resampling_rate
			#time_noise = length(resampled_noise)/resampling_rate
			time_signal = 35 #duration of chirp. Hard coded!!
			time_noise = sec

			mean_signal = zeros(Int(resampling_rate*time_signal))
            mean_noise = zeros(Int(resampling_rate*time_noise))

			for j in 2:(N_rep + 1) #add 1 to indices-->first column header
				println("Event "*string(j-1))
				
				event_start = [split(line, ",") for line in csv_file][j][col_start]
				event_start = parse(Int, event_start)
				event_end = [split(line, ",") for line in csv_file][j][col_end]
				event_end = parse(Int, event_end)

				println("Event times: "*string(event_start)*" and "*string(event_end))

				subsignal = signal[event_start:event_end]
				noisesignal = signal[event_start - Int(sec*sampling_rate) : event_start]
				resampled_signal = subsignal[1:step:resampling_rate*time_signal]
                resampled_noise = noisesignal[1:step:end]

                mean_signal += resampled_signal
                mean_noise += resampled_noise
            end
            mean_signal = mean_signal ./ N_rep
            mean_noise = mean_noise ./ N_rep
            
            power_signal = mean(mean_signal.^2)
            power_noise = mean(mean_noise.^2)
            snr = 10* log10(power_signal/power_noise)
            println("Electrode " *string(i-1)* " SNR")
            println(snr)
            SNR["electrode_"*string(i-1)*"/SNR"] = snr
		end
		
		println("Done.")
	end
end

