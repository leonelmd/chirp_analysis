# -*- coding: utf-8 -*-
# @author: max (max@mdotmonar.ch)

using HDF5

include("preprocessing.jl")
include("processing.jl")

data_folder = "../../../neuroeng/data/UV_uERG"
# parameters
filter = Dict(
	"type" => "BPF",
	"cutoff_low" => 0.1, # Hz
	"cutoff_high" => 40 # Hz
)
resampling_rate = 250 # Hz

r_list = [0.2]
e_f_list = [
	"none",
	#"snr_0",
	#"snr_1",
	#"snr_2",
	#"snr_3",
	#"snr_4",
	#"snr_5",
	#"snr_6",
	"snr_7"
]

# divide the datasets into N chunks
N = 88
start_dataset = parse(Int, ARGS[1])

datasets = [
	# WT 3m female
	"MR-0677",
	"MR-0678",
	"MR-0688-t2",
	"MR-0689-t2",
	# WT 3m male
	"MR-0662",
	"MR-0665",
	"MR-0668",
	"MR-0669",
	# WT 6m female
	"MR-0679",
	"MR-0680",
	"MR-0691-t1",
	"MR-0692-t2",
	# WT 6m male
	"MR-0654-t1",
	"MR-0654-t2",
	"MR-0655",
	"MR-0658",
	"MR-0687-t1",
	# WT 9m female
	"MR-0683", 
	# WT 9m male
	"MR-0670", 
	"MR-0682",
	# 5xFAD 3m female
	"MR-0644",
	"MR-0645",
	"MR-0648",
	"MR-0649",
	# 5xFAD 3m male
	"MR-0661",
	"MR-0663",
	"MR-0666",
	"MR-0667",
	# 5xFAD 6m female
	"MR-0659-t1",
	"MR-0659-t2",
	"MR-0660",
	"MR-0676",
	"MR-0690-t2",
	# 5xFAD 6m male
	"MR-0656",
	"MR-0657-t1",
	"MR-0657-t2",
	"MR-0674",
	# 5xFAD 9m female
	"MR-0646",
	"MR-0647",
	"MR-0684",
	"MR-0693-t2",
	"MR-0694-t2",
	"MR-0695-t2",
	# 5xFAD 9m male
	"MR-0681",
	# TgXBP1s 9m female
	"MR-0709-t2",
	"MR-0710-t1",
	"MR-0712-t2",
	# TgXBP1s 9m male
	"MR-0708-t1",
	"MR-0711-t2"
]

# split according to N cores
f_datasets = datasets[start_dataset:N:end]

for dataset in f_datasets
	for electrode_filter in e_f_list
		threshold = parse(Float64, electrode_filter[5:end])
		if electrode_filter != "none"
			skipped = true
			if !isfile(data_folder*"/"*dataset*"_SNR.h5")
				println("SNR file not found for dataset: ", dataset)
				compute_and_save_snr(dataset, resampling_rate)
			end
			snr_file = h5open(data_folder*"/"*dataset*"_SNR.h5", "r")
			for i in 1:252
				if read(snr_file, "electrode_"*string(i-1)*"/SNR") >= threshold
					skipped = false
					break
				end
			end			
		else
			skipped = false
		end
		if skipped
			println("Dataset: "*dataset*" with no SNR above: ", electrode_filter)
			continue
		end

		println("Processing dataset: "*dataset*" with electrode filter: ", electrode_filter)
	
		## PREPROCESSING
		println("Preprocessing dataset: ", dataset)
		filter_and_resample(dataset, filter, resampling_rate)
		

		## PROCESSING
		println("Processing dataset: ", dataset)
		get_segments(dataset, 35)
		normalize_signals(dataset)
		get_event_mean(dataset, 35)
		get_electrode_mean(dataset, 35, electrode_filter)

		## ENTROPY
		println("Computing entropy and complexity for dataset: ", dataset)
		for r in r_list
			compute_entropy_curve(dataset, electrode_filter, "FRCMSE", 2, r, [i for i in 1:45])
		end
	end
end

println("Main complete.")