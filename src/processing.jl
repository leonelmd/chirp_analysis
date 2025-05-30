# -*- coding: utf-8 -*-
# @author: max (max@mdotmonar.ch)

include("entropy.jl")

using HDF5
using DSP
using Statistics

# file handling parameters
data_folder = "data"
stim_suffix = "_chirp" #"_chirpLED_canon"

# signal processing parameters
sampling_rate = 20000
nyquist_frequency = 0.5 * sampling_rate
resampling_rate = 250

# electrodes and events
N_elec = 252
N_rep = 10

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
	h5open("./processed_data/"*dataset*stim_suffix*"_processed.h5", "cw") do processed_file
		# check
		if group_check(processed_file, ["electrode_0", "event_1", "data"])
			println("Skipping getting signal segment..")
			return
		end

		println("Getting signal segment... ")

		h5open("./preprocessed_data/"*dataset*stim_suffix*"_preprocessed.h5", "r") do preprocessed_file
			# get segments
			for i in 1:N_elec
				for j in 2:(N_rep + 1) #add 1 to indices-->first column header
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
	h5open("./processed_data/"*dataset*stim_suffix*"_processed.h5", "cw") do processed_file
		# check
		if group_check(processed_file, ["electrode_0", "event_1", "normalized"])
			println("Skipping signal segment normalization...")
			return
		end

		println("Normalize signal segment... ")

		# get segments
		for i in 1:N_elec
			for j in 2:(N_rep + 1) #add 1 to indices-->first column header
				signal = read(processed_file, "electrode_"*string(i-1)*"/event_"*string(j-1)*"/data")

				# normalize
				u = mean(signal)
				s = std(signal)
				normalized_signal = (signal .- u) ./ s
				processed_file["electrode_"*string(i-1)*"/event_"*string(j-1)*"/normalized/data"] = normalized_signal
			end
		end
	end

	println("Done.")
end

function get_event_mean(dataset, time)
	# open processed file
	h5open("./processed_data/"*dataset*stim_suffix*"_processed.h5", "cw") do processed_file
		# check
		if group_check(processed_file, ["electrode_0", "event_mean"])
			println("Skipping getting event mean...")
			return
		end

		println("Getting event mean.. ")

		# get event mean per electrode
		for i in 1:N_elec
			event_mean = zeros(resampling_rate*time)
			for j in 2:(N_rep + 1) #add 1 to indices-->first column header
				event_mean += read(processed_file, "electrode_"*string(i-1)*"/event_"*string(j-1)*"/normalized/data")
			end
			event_mean = event_mean ./ N_rep
			processed_file["electrode_"*string(i-1)*"/event_mean/data"] = event_mean
		end
	end

	println("Done.")
end

function get_electrode_mean(dataset, time, electrode_filter="none") #filters: none, snr_n
	# get electrode mean
	h5open("./processed_data/"*dataset*stim_suffix*"_processed.h5", "cw") do processed_file
		# check
		if group_check(processed_file, ["electrode_mean", electrode_filter])
			println("Skipping getting electrode mean...")
			return
		end

		println("Getting electrode mean... ")

		mean_signal = zeros(resampling_rate*time)
		if electrode_filter == "none"
			for i in 1:N_elec
				mean_signal += read(processed_file, "electrode_"*string(i-1)*"/event_mean/data")
			end
			mean_signal = mean_signal ./ N_elec
			processed_file["electrode_mean/none/data"] = mean_signal
		else
			threshold = parse(Float64, electrode_filter[5:end])
			# add SNR filter based on SNR h5 file
			snr_file = h5open(data_folder*"/"*dataset*"_SNR.h5", "r")

			filtered_electrodes = []

			for i in 1:N_elec
				if read(snr_file, "electrode_"*string(i-1)*"/SNR") >= threshold
					push!(filtered_electrodes, "electrode_"*string(i-1))
					mean_signal += read(processed_file, "electrode_"*string(i-1)*"/event_mean/data")
				end
			end

			mean_signal = mean_signal ./ length(filtered_electrodes)
			processed_file["electrode_mean/"*electrode_filter*"/data"] = mean_signal
		end
	end

	println("Done.")
end

function compute_entropy_curve(dataset, e_f, type, m, r, scales)

	#=
	h5open("./entropy_data/"*dataset*stim_suffix*"_entropy.h5", "cw") do entropy_file
		# check
		if group_check(entropy_file, [type, string(r), "electrode_0", "event_1"])
			println("Skipping computing "*type*" curve with r = "*string(r)*" for all events, for all electrodes...")
			return
		end

		println("Computing "*type*" curve with r = "*string(r)*" for all events, for all electrodes...")

		h5open("./processed_data/"*dataset*stim_suffix*"_processed.h5", "r") do processed_file

			# compute entropy curve for all events, for all electrodes
			for i in 0:251
				for j in 1:10
					signal = read(processed_file, "electrode_"*string(i)*"/event_"*string(j)*"/normalized/data")
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
					entropy_file[type*"/"*string(r)*"/electrode_"*string(i)*"/event_"*string(j)*"/curve"] = entropy_curve
					entropy_file[type*"/"*string(r)*"/electrode_"*string(i)*"/event_"*string(j)*"/nAUC"] = compute_nAUC(entropy_curve)
					entropy_file[type*"/"*string(r)*"/electrode_"*string(i)*"/event_"*string(j)*"/LRS"] = compute_LRS(entropy_curve, scales)
				end
			end
		end
	end

	h5open("./entropy_data/"*dataset*stim_suffix*"_entropy.h5", "cw") do entropy_file
		# check
		if group_check(entropy_file, [type, string(r), "electrode_0", "event_mean"])
			println("Skipping computing "*type*" curve with r = "*string(r)*" for all event means...")
			return
		end

		println("Computing "*type*" curve with r = "*string(r)*" for all event means...")

		h5open("./processed_data/"*dataset*stim_suffix*"_processed.h5", "r") do processed_file

			# compute entropy curve for event mean, for all electrodes
			for i in 0:251
				signal = read(processed_file, "electrode_"*string(i)*"/event_mean/data")
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
				entropy_file[type*"/"*string(r)*"/electrode_"*string(i)*"/event_mean/curve"] = entropy_curve
				entropy_file[type*"/"*string(r)*"/electrode_"*string(i)*"/event_mean/nAUC"] = compute_nAUC(entropy_curve)
				entropy_file[type*"/"*string(r)*"/electrode_"*string(i)*"/event_mean/LRS"] = compute_LRS(entropy_curve, scales)
			end
		end
	end
	=#
	
	h5open("./entropy_data/"*dataset*stim_suffix*"_entropy.h5", "cw") do entropy_file
		# check
		if group_check(entropy_file, [type, string(r), "electrode_mean", e_f])
			println("Skipping computing "*type*" curve with r = "*string(r)*" for electrode mean with electrode filter = "*e_f*"...")
			return
		end

		println("Computing "*type*" curve with r = "*string(r)*" for electrode mean with electrode filter = "*e_f*"...")

		h5open("./processed_data/"*dataset*stim_suffix*"_processed.h5", "r") do processed_file

			# compute entropy curve for electrode mean
			signal = read(processed_file, "electrode_mean/"*e_f*"/data")
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
			entropy_file[type*"/"*string(r)*"/electrode_mean/"*e_f*"/curve"] = entropy_curve
			entropy_file[type*"/"*string(r)*"/electrode_mean/"*e_f*"/nAUC"] = compute_nAUC(entropy_curve)
			entropy_file[type*"/"*string(r)*"/electrode_mean/"*e_f*"/LRS"] = compute_LRS(entropy_curve, scales)
		end
	end

	println("Done.")
end