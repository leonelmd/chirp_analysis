# -*- coding: utf-8 -*-
# @author: max (max@mdotmonar.ch)

include("entropy.jl")

using HDF5
using DSP
using JSON
using Statistics
using Plots

# parameters
sampling_rate = 20000
resampling_rate = 250
nyquist_frequency = 0.5 * sampling_rate

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

function get_segments(dataset, time)
	# open processed file
	h5open("./processed_data/"*dataset*"_chirp_processed.h5", "cw") do processed_file
		# check
		if group_check(processed_file, ["electrode_0", "event_1", "data"])
			println("Skipping getting signal segment..")
			return
		end

		println("Getting signal segment... ")

		h5open("./preprocessed_data/"*dataset*"_chirp_preprocessed.h5", "r") do preprocessed_file
			# get segments
			for i in 1:252
				for j in 2:11
					signal = read(preprocessed_file, "electrode_"*string(i-1)*"/event_"*string(j-1)*"/data")
					processed_file["electrode_"*string(i-1)*"/event_"*string(j-1)*"/data"] = signal[1:resampling_rate*time]
				end
			end
		end
	end

	println("Done.")
end

function normalize_signals(dataset)
	# open processed file
	h5open("./processed_data/"*dataset*"_chirp_processed.h5", "cw") do processed_file
		# check
		if group_check(processed_file, ["electrode_0", "event_1", "normalized"])
			println("Skipping signal segment normalization...")
			return
		end

		println("Normalize signal segment... ")

		# get segments
		for i in 1:252
			for j in 2:11
				signal = read(processed_file, "electrode_"*string(i-1)*"/event_"*string(j-1)*"/data")

				# normalize
				u = mean(signal)
				s = std(signal)
				normalized_signal = (signal .- u) ./ s
				processed_file["electrode_"*string(i-1)*"/event_"*string(j-1)*"/normalized"] = normalized_signal
			end
		end
	end

	println("Done.")
end

function get_mean_signals(dataset, time, filter="none", threshold=3) # threshold for SNR = 3 dB
	# get electrode mean
	h5open("./processed_data/"*dataset*"_chirp_processed.h5", "cw") do processed_file
		# check
		if group_check(processed_file, ["electrode_mean"])
			println("Skipping getting electrode mean...")
			return
		end

		println("Getting electrode mean... ")

		for j in 2:11
			mean_signal = zeros(resampling_rate*time)

			if filter == "none"
				for i in 1:252
					mean_signal += read(processed_file, "electrode_"*string(i-1)*"/event_"*string(j-1)*"/normalized/data")
				end
				mean_signal = mean_signal ./ 252
			else filter == "snr"
				# add SNR filter based on SNR h5 file
				snr_file = h5open("../SNR/"*dataset*"_SNR.h5", "r")
			end

			processed_file["electrode_mean/event_"*string(j-1)*"/data"] = mean_signal
		end
	end

	# get event mean
	h5open("./processed_data/"*dataset*"_chirp_processed.h5", "cw") do processed_file
		# check
		if group_check(processed_file, ["electrode_mean", "event_mean"])
			println("Skipping getting event mean...")
			return
		end

		println("Getting event mean... ")

		mean_signal = zeros(resampling_rate*time)
		for j in 2:11
			mean_signal += read(processed_file, "electrode_mean/event_"*string(j-1)*"/data")
		end
		mean_signal = mean_signal ./ 10
		processed_file["electrode_mean/event_mean/data"] = mean_signal
	end

	println("Done.")
end

function compute_entropy_curve(dataset, type, m, r, scales)
	# open entropy file
	h5open("./entropy_data/"*dataset*"_chirp_entropy.h5", "cw") do entropy_file
		# check
		if group_check(entropy_file, [type, string(r), "electrode_mean"])
			println("Skipping computing "*type*" curve with r = "*string(r)*"...")
			return
		end

		println("Computing "*type*" curve with r = "*string(r)*"...")

		h5open("./processed_data/"*dataset*"_chirp_processed.h5", "r") do processed_file

			println("Processing electrode mean...")
			for j in 2:11
				# get mean signal
				signal = read(processed_file, "electrode_mean/event_"*string(j-1)*"/data")
				# compute entropy curve
				if type == "MSE"
					entropy_curve = multiscale_entropy(signal, m, r*std(signal), "sample", scales)
				elseif type == "RCMSE"
					entropy_curve = refined_composite_multiscale_entropy(signal, m, r*std(signal), "sample", scales)
				elseif type == "FMSE"
					entropy_curve = multiscale_entropy(signal, m, r*std(signal), "fuzzy", scales)
				elseif type == "FRCMSE"
					entropy_curve = refined_composite_multiscale_entropy(signal, m, r*std(signal), "fuzzy", scales)
				end
				entropy_file[type*"/"*string(r)*"/electrode_mean/event_"*string(j-1)*"/curve"] = entropy_curve
				entropy_file[type*"/"*string(r)*"/electrode_mean/event_"*string(j-1)*"/nAUC"] = compute_nAUC(entropy_curve)
				entropy_file[type*"/"*string(r)*"/electrode_mean/event_"*string(j-1)*"/LRS"] = compute_LRS(entropy_curve, scales)
			end

			println("Processing event mean...")
			# get mean signal
			signal = read(processed_file, "electrode_mean/event_mean/data")
			# compute entropy curve
			if type == "MSE"
				entropy_curve = multiscale_entropy(signal, m, r*std(signal), "sample", scales)
			elseif type == "RCMSE"
				entropy_curve = refined_composite_multiscale_entropy(signal, m, r*std(signal), "sample", scales)
			elseif type == "FMSE"
				entropy_curve = multiscale_entropy(signal, m, r*std(signal), "fuzzy", scales)
			elseif type == "FRCMSE"
				entropy_curve = refined_composite_multiscale_entropy(signal, m, r*std(signal), "fuzzy", scales)
			end
			entropy_file[type*"/"*string(r)*"/electrode_mean/event_mean/curve"] = entropy_curve
			entropy_file[type*"/"*string(r)*"/electrode_mean/event_mean/nAUC"] = compute_nAUC(entropy_curve)
			entropy_file[type*"/"*string(r)*"/electrode_mean/event_mean/LRS"] = compute_LRS(entropy_curve, scales)
		end
	end

	println("Done.")
end