# -*- coding: utf-8 -*-
# @author: max (max@mdotmonar.ch)

using HDF5
using Plots
using StatsPlots
using DSP

include("processing.jl")
include("entropy.jl")

data_folder = "../../../neuroeng/data/UV_uERG"
stim_suffix = "_chirpLED_canon"

coordinates = [
	[1500, 1100],
	[1000, 900],
	[1300, 900],
	[1400, 1000],
	[1000, 800],
	[1200, 800],
	[1100, 700],
	[1500, 700],
	[1300, 500],
	[1200, 600],
	[1500, 300],
	[1400, 400],
	[1500, 100],
	[1100, 400],
	[900, 500],
	[800, 700],
	[1000, 100],
	[1100, 0],
	[800, 300],
	[900, 200],
	[700, 0],
	[800, 500],
	[600, 300],
	[700, 400],
	[400, 100],
	[500, 200],
	[1200, 1200],
	[1300, 1300],
	[1500, 1200],
	[1000, 1000],
	[1300, 1000],
	[1400, 1100],
	[1100, 800],
	[1200, 900],
	[1000, 700],
	[1500, 800],
	[1300, 600],
	[1200, 700],
	[1500, 400],
	[1400, 500],
	[900, 600],
	[1000, 600],
	[1200, 300],
	[1300, 200],
	[1200, 0],
	[1000, 500],
	[1000, 200],
	[1100, 100],
	[800, 400],
	[900, 300],
	[700, 500],
	[800, 0],
	[600, 200],
	[700, 300],
	[400, 0],
	[500, 100],
	[900, 1200],
	[1000, 1500],
	[800, 1100],
	[900, 1400],
	[800, 1500],
	[800, 1300],
	[900, 900],
	[1300, 1500],
	[1500, 1300],
	[1500, 1400],
	[1300, 1100],
	[1400, 1200],
	[1100, 900],
	[1200, 1000],
	[1400, 800],
	[1500, 900],
	[1300, 700],
	[900, 700],
	[1500, 500],
	[1400, 600],
	[1200, 400],
	[1100, 500],
	[1400, 200],
	[1300, 300],
	[1300, 0],
	[1400, 0],
	[1100, 200],
	[1200, 100],
	[900, 400],
	[1000, 300],
	[800, 100],
	[900, 0],
	[700, 200],
	[700, 600],
	[500, 0],
	[600, 100],
	[400, 300],
	[500, 400],
	[1400, 1300],
	[1400, 1400],
	[1200, 1100],
	[1300, 1200],
	[1500, 1000],
	[1100, 1000],
	[1300, 800],
	[1400, 900],
	[1400, 700],
	[900, 800],
	[1100, 600],
	[1500, 600],
	[1300, 400],
	[1200, 500],
	[1500, 200],
	[1400, 300],
	[1300, 100],
	[1400, 100],
	[1100, 300],
	[1200, 200],
	[1000, 0],
	[1000, 400],
	[800, 200],
	[900, 100],
	[700, 100],
	[800, 600],
	[600, 400],
	[600, 0],
	[400, 200],
	[500, 300],
	[800, 800],
	[1400, 1500],
	[700, 700],
	[100, 0],
	[0, 400],
	[500, 600],
	[200, 600],
	[100, 500],
	[500, 700],
	[300, 700],
	[400, 800],
	[0, 800],
	[200, 1000],
	[300, 900],
	[0, 1400],
	[400, 1100],
	[0, 1200],
	[100, 1100],
	[500, 1200],
	[900, 1500],
	[400, 1500],
	[800, 1400],
	[800, 1200],
	[700, 900],
	[800, 1000],
	[700, 1300],
	[700, 1100],
	[700, 1500],
	[600, 600],
	[600, 500],
	[300, 300],
	[200, 200],
	[0, 300],
	[500, 500],
	[200, 500],
	[100, 400],
	[400, 700],
	[300, 600],
	[500, 800],
	[0, 700],
	[200, 900],
	[300, 800],
	[0, 1100],
	[100, 1000],
	[300, 1200],
	[200, 1300],
	[600, 900],
	[500, 900],
	[600, 1200],
	[600, 1400],
	[500, 1300],
	[500, 1500],
	[400, 1400],
	[500, 1100],
	[300, 1500],
	[400, 1200],
	[500, 1000],
	[300, 1300],
	[700, 1000],
	[800, 900],
	[700, 1200],
	[700, 1400],
	[600, 1300],
	[600, 1500],
	[500, 1400],
	[600, 1100],
	[200, 100],
	[300, 200],
	[0, 200],
	[0, 100],
	[200, 400],
	[100, 300],
	[400, 600],
	[300, 500],
	[100, 700],
	[0, 600],
	[200, 800],
	[600, 800],
	[0, 1000],
	[100, 900],
	[300, 1100],
	[400, 1000],
	[200, 1500],
	[100, 1500],
	[100, 1300],
	[200, 1200],
	[300, 1400],
	[1300, 1400],
	[700, 800],
	[1200, 1300],
	[1100, 1100],
	[1100, 1200],
	[1200, 1500],
	[1000, 1100],
	[1000, 1300],
	[1100, 1400],
	[200, 0],
	[300, 100],
	[100, 200],
	[100, 100],
	[300, 400],
	[200, 300],
	[0, 500],
	[400, 500],
	[200, 700],
	[100, 600],
	[100, 800],
	[600, 700],
	[400, 900],
	[0, 900],
	[200, 1100],
	[300, 1000],
	[200, 1400],
	[100, 1400],
	[0, 1300],
	[100, 1200],
	[400, 1300],
	[1200, 1400],
	[600, 1000],
	[1100, 1300],
	[900, 1000],
	[1000, 1200],
	[1100, 1500],
	[900, 1100],
	[900, 1300],
	[1000, 1400],
	[400, 400],
	[300, 0]
]
coordinates = [[(c[1]÷100)+1, (c[2]÷100)+1] for c in coordinates]

electrode_labels =[
	"R12",
	"L10",
	"O10",
	"P11",
	"L9",
	"N9",
	"M8",
	"R8",
	"O6",
	"N7",
	"R4",
	"P5",
	"R2",
	"M5",
	"K6",
	"I8",
	"L2",
	"M1",
	"I4",
	"K3",
	"H1",
	"I6",
	"G4",
	"H5",
	"E2",
	"F3",
	"N13",
	"O14",
	"R13",
	"L11",
	"O11",
	"P12",
	"M9",
	"N10",
	"L8",
	"R9",
	"O7",
	"N8",
	"R5",
	"P6",
	"K7",
	"L7",
	"N4",
	"O3",
	"N1",
	"L6",
	"L3",
	"M2",
	"I5",
	"K4",
	"H6",
	"I1",
	"G3",
	"H4",
	"E1",
	"F2",
	"K13",
	"L16",
	"I12",
	"K15",
	"I16",
	"I14",
	"K10",
	"O16",
	"R14",
	"R15",
	"O12",
	"P13",
	"M10",
	"N11",
	"P9",
	"R10",
	"O8",
	"K8",
	"R6",
	"P7",
	"N5",
	"M6",
	"P3",
	"O4",
	"O1",
	"P1",
	"M3",
	"N2",
	"K5",
	"L4",
	"I2",
	"K1",
	"H3",
	"H7",
	"F1",
	"G2",
	"E4",
	"F5",
	"P14",
	"P15",
	"N12",
	"O13",
	"R11",
	"M11",
	"O9",
	"P10",
	"P8",
	"K9",
	"M7",
	"R7",
	"O5",
	"N6",
	"R3",
	"P4",
	"O2",
	"P2",
	"M4",
	"N3",
	"L1",
	"L5",
	"I3",
	"K2",
	"H2",
	"I7",
	"G5",
	"G1",
	"E3",
	"F4",
	"I9",
	"P16",
	"H8",
	"B1",
	"A5",
	"F7",
	"C7",
	"B6",
	"F8",
	"D8",
	"E9",
	"A9",
	"C11",
	"D10",
	"A15",
	"E12",
	"A13",
	"B12",
	"F13",
	"K16",
	"E16",
	"I15",
	"I13",
	"H10",
	"I11",
	"H14",
	"H12",
	"H16",
	"G7",
	"G6",
	"D4",
	"C3",
	"A4",
	"F6",
	"C6",
	"B5",
	"E8",
	"D7",
	"F9",
	"A8",
	"C10",
	"D9",
	"A12",
	"B11",
	"D13",
	"C14",
	"G10",
	"F10",
	"G13",
	"G15",
	"F14",
	"F16",
	"E15",
	"F12",
	"D16",
	"E13",
	"F11",
	"D14",
	"H11",
	"I10",
	"H13",
	"H15",
	"G14",
	"G16",
	"F15",
	"G12",
	"C2",
	"D3",
	"A3",
	"A2",
	"C5",
	"B4",
	"E7",
	"D6",
	"B8",
	"A7",
	"C9",
	"G9",
	"A11",
	"B10",
	"D12",
	"E11",
	"C16",
	"B16",
	"B14",
	"C13",
	"D15",
	"O15",
	"H9",
	"N14",
	"M12",
	"M13",
	"N16",
	"L12",
	"L14",
	"M15",
	"C1",
	"D2",
	"B3",
	"B2",
	"D5",
	"C4",
	"A6",
	"E6",
	"C8",
	"B7",
	"B9",
	"G8",
	"E10",
	"A10",
	"C12",
	"D11",
	"C15",
	"B15",
	"A14",
	"B13",
	"E14",
	"N15",
	"G11",
	"M14",
	"K11",
	"L13",
	"M16",
	"K12",
	"K14",
	"L15",
	"E5",
	"D1"
]

groups = ["A", "B", "C", "D", "E", "F", "G"]#, "H"]

group_labels = Dict()
group_labels["A"] = "WT young"
group_labels["B"] = "WT adult"
group_labels["C"] = "WT old"
group_labels["D"] = "5xFAD young"
group_labels["E"] = "5xFAD adult"
group_labels["F"] = "5xFAD old"
group_labels["G"] = "TGXBP1s old"
# group_labels["H"] = "Double adult"
group_labels_plot = ["WT young" "WT adult" "WT old" "5xFAD young" "5xFAD adult" "5xFAD old" "TgXBP1s old"]

grouped_datasets = Dict()
grouped_datasets["A"] = [
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
]
grouped_datasets["B"] = [
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
]
grouped_datasets["C"] = [
	# WT 9m female
	"MR-0683", 
	# WT 9m male
	"MR-0670", #check entropy 19
	"MR-0682",
]
grouped_datasets["D"] = [
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
]
grouped_datasets["E"] = [
	# 5xFAD 6m female
	"MR-0659-t1",
	"MR-0659-t2",
	"MR-0660",
	"MR-0676",
	"MR-0690-t2",
	# 5xFAD 6m male
	"MR-0656",
	"MR-0657-t1", #check entropy 35
	"MR-0657-t2", #check preproc 36
	"MR-0674",
]
grouped_datasets["F"] = [
	# 5xFAD 9m female
	"MR-0646",
	"MR-0647",
	"MR-0684",
	"MR-0693-t2", #check preproc 41
	"MR-0694-t2",
	"MR-0695-t2", #check preproc 43
	# 5xFAD 9m male
	"MR-0681",
]

grouped_datasets["G"] = [
	# TgXBP1s 9m female
	"MR-0709-t2",
	"MR-0710-t1", #check preproc 46
	"MR-0712-t2",
	# TgXBP1s 9m male
	"MR-0708-t1",
	"MR-0711-t2", #check preproc 49
]

grouped_s_datasets = Dict()
grouped_s_datasets["male"] = []
grouped_s_datasets["female"] = []

grouped_s_datasets["male"] = [grouped_s_datasets["male"]; grouped_datasets["A"][5:8]]
grouped_s_datasets["female"] = [grouped_s_datasets["female"]; grouped_datasets["A"][1:4]]
grouped_s_datasets["male"] = [grouped_s_datasets["male"]; grouped_datasets["B"][5:9]]
grouped_s_datasets["female"] = [grouped_s_datasets["female"]; grouped_datasets["B"][1:4]]
grouped_s_datasets["male"] = [grouped_s_datasets["male"]; grouped_datasets["C"][2:3]]
grouped_s_datasets["female"] = [grouped_s_datasets["female"]; grouped_datasets["C"][1:1]]
grouped_s_datasets["male"] = [grouped_s_datasets["male"]; grouped_datasets["D"][5:8]]
grouped_s_datasets["female"] = [grouped_s_datasets["female"]; grouped_datasets["D"][1:4]]
grouped_s_datasets["male"] = [grouped_s_datasets["male"]; grouped_datasets["E"][6:9]]
grouped_s_datasets["female"] = [grouped_s_datasets["female"]; grouped_datasets["E"][1:5]]
grouped_s_datasets["male"] = [grouped_s_datasets["male"]; grouped_datasets["F"][7:7]]
grouped_s_datasets["female"] = [grouped_s_datasets["female"]; grouped_datasets["F"][1:6]]
grouped_s_datasets["male"] = [grouped_s_datasets["male"]; grouped_datasets["G"][4:5]]
grouped_s_datasets["female"] = [grouped_s_datasets["female"]; grouped_datasets["G"][1:3]]

datasets = []
for group in groups
	global datasets = [datasets; grouped_datasets[group]]
end

v_color = [:skyblue :skyblue :skyblue :tomato :tomato :tomato :goldenrod] #:seagreen :seagreen :goldenrod :goldenrod]
v_color_index = Dict()
v_color_index["A"] = :skyblue 
v_color_index["B"] = :skyblue
v_color_index["C"] = :skyblue
v_color_index["D"] = :tomato
v_color_index["E"] = :tomato
v_color_index["F"] = :tomato
v_color_index["G"] = :goldenrod
# v_color_index["H"] = :goldenrod
v_fill = [0.5 0.5 0.5 0.5 0.5 0.5 0.5]# 0.5]
v_ls = [:solid :dash :dot :solid :dash :dot :dot]
v_ls_index = Dict()
v_ls_index["A"] = :solid
v_ls_index["B"] = :dash
v_ls_index["C"] = :dot
v_ls_index["D"] = :solid
v_ls_index["E"] = :dash
v_ls_index["F"] = :dot
v_ls_index["G"] = :dot
# v_ls_index["H"] = :dash

t_list = ["FRCMSE"]
r_list = ["0.2"]
e_f_list = [
	"none",
	# "snr_0",
	# "snr_1",
	# "snr_2",
	# "snr_3",
	# "snr_4",
	# "snr_5",
	# "snr_6",
	"snr_7"
]

# Signal and spectrogram
function plot_signal(signal, fs=250)
	plot!([i/fs for i in 1:length(signal)], signal, xlabel="Time (s)", ylabel="Amplitude")
end

function plot_spectrogram(signal, fs=250)
	nw = length(signal) ÷ 30
	spec = spectrogram(signal, nw, nw÷2, fs=fs, window=hanning)
	heatmap!(spec.time, spec.freq, 10*log.(spec.power), c=:viridis, xlabel="Time (s)", ylabel="Frequency (Hz)")
end

# Signal and spectrogram of electrode mean
function signal_and_spectrogram_electrode_mean(dataset)
	processed_file = h5open("./processed_data/$(dataset)"*stim_suffix*"_processed.h5", "r")
	e_f_computed = keys(processed_file["electrode_mean"])

	for e_f in e_f_computed
		signal = read(processed_file, "electrode_mean/$(e_f)/data")

		p1 = plot(title="Normalized signal and spectrogram of $(dataset), \nelectrode mean w/ electrode filter: $(e_f)", legend=:none)
		plot_signal(signal)

		p2 = plot()
		plot_spectrogram(signal)

		plot(p1, p2, layout=grid(2, 1, heights=[0.2 ,0.8]), size=(800, 900), dpi=300)

		group = group_labels[findfirst(x -> dataset in x, grouped_datasets)]
		savefig("./plots_new/$(group)/$(dataset)/signals/electrode_mean_$(e_f).svg")
	end

	close(processed_file)
end

# SNR map
function SNR_map(dataset)
	# check if SNR file exists
	if !isfile(data_folder*"/"*dataset*"_SNR.h5")
		println("SNR file not found for dataset: ", dataset)
		return
	end

	snr_file = h5open(data_folder*"/"*dataset*"_SNR.h5", "r")
	snr_map = zeros(16, 16)
	for n in 1:252
		snr = read(snr_file, "electrode_$(n-1)/SNR")
		snr_map[coordinates[n][1], coordinates[n][2]] = snr
	end

	snr_map[1, 1] = NaN
	snr_map[1, 16] = NaN
	snr_map[16, 1] = NaN
	snr_map[16, 16] = NaN

	heatmap(snr_map, c=:viridis, title="SNR map of $(dataset)", size=(800, 800), dpi=300, xaxis=false, yaxis=false)
	for n in 1:252
		annotate!([(coordinates[n][1], coordinates[n][2], text(electrode_labels[n], 8, :black, :center))])
	end

	group = group_labels[findfirst(x -> dataset in x, grouped_datasets)]
	savefig("./plots_new/$(group)/$(dataset)/signals/SNR_map.svg")

	close(snr_file)
end

# Group entropy curves
function group_entropy_curves(group, e_f_list=["none", "snr_7"], type="RCMSE", r=0.2)
	for e_f in e_f_list
		plot(xlims=(1, 45), size=(800, 500), dpi=300, legend=:none, title="$(group_labels[group]) entropy curves w/ electrode filter: $(e_f)", xlabel="Scale", ylabel="SampEn")
		mean_entropy_curve = zeros(45)
		count = 0
			
		for dataset in grouped_datasets[group]
			entropy_file = h5open("./entropy_data/$(dataset)"*stim_suffix*"_entropy.h5", "r")
			entropy_data = read(entropy_file, "/"*type*"/"*string(r)*"/electrode_mean")
			if !haskey(entropy_data, e_f)
				continue
			end
			plot!(entropy_data[e_f]["curve"], color=:black, alpha=0.2)
			mean_entropy_curve += entropy_data[e_f]["curve"]
			count += 1
			close(entropy_file)
		end
		if count == 0
			continue
		end

		mean_entropy_curve /= count
		plot!(mean_entropy_curve, color=v_color_index[group], lw=2)

		savefig("./plots_new/$(group_labels[group])/group_entropy_curves_"*type*"_"*string(r)*"$(e_f).svg")
	end
end

function group_entropy_curves_extra(group, e_f_list=["none", "snr_7"], type="RCMSE", r=0.2)
	for e_f in e_f_list
		plot(xlims=(1, 45), size=(800, 500), dpi=300, legend=:none, title="$(group_labels[group]) entropy curves w/ electrode filter: $(e_f)", xlabel="Scale", ylabel="SampEn")
		mean_entropy_curve = zeros(45)
		count = 0
			
		for dataset in grouped_datasets[group]
			entropy_file = h5open("./entropy_data/$(dataset)"*stim_suffix*"_entropy.h5", "r")
			entropy_data = read(entropy_file, "/"*type*"/"*string(r)*"/electrode_mean")
			if !haskey(entropy_data, e_f)
				continue
			end
			if dataset == "MR-0446" || dataset == "MR-0447" || dataset == "MR-0448" || dataset == "MR-0474" || dataset == "MR-0491" || dataset == "MR-0543"
				plot!(entropy_data[e_f]["curve"], color=:green, alpha=0.5)
			else
				plot!(entropy_data[e_f]["curve"], color=:black, alpha=0.2)
			end
			mean_entropy_curve += entropy_data[e_f]["curve"]
			count += 1
			close(entropy_file)
		end
		if count == 0
			continue
		end

		mean_entropy_curve /= count
		plot!(mean_entropy_curve, color=v_color_index[group], lw=2)

		savefig("./plots_new/extra/$(group_labels[group])/group_entropy_curves_"*type*"_"*string(r)*"$(e_f).svg")
	end
end

# Mean entropy curves comparison
function mean_entropy_curves_comparison(e_f_list=["none", "snr_7"], type="RCMSE", r=0.2)
	for e_f in e_f_list
		plot(xlims=(1, 45), size=(800, 500), dpi=300, title="Mean entropy curves comparison w/ electrode filter: $(e_f)", xlabel="Scale", ylabel="SampEn")
		mean_entropy_curves = Dict()
		for group in groups
			mean_entropy_curves[group] = zeros(45)
		end

		for group in groups
			count = 0
			for dataset in grouped_datasets[group]
				entropy_file = h5open("./entropy_data/$(dataset)"*stim_suffix*"_entropy.h5", "r")
				entropy_data = read(entropy_file, "/"*type*"/"*string(r)*"/electrode_mean")
				if !haskey(entropy_data, e_f)
					continue
				end
				mean_entropy_curves[group] += entropy_data[e_f]["curve"]
				count += 1
				close(entropy_file)
			end
			if count == 0
				continue
			end
			mean_entropy_curves[group] /= count
			plot!(mean_entropy_curves[group], color=v_color_index[group], label=group_labels[group], ls=v_ls_index[group])
		end

		savefig("./plots_new/"*type*"_"*string(r)*"/mean_entropy_curves_comparison_$(e_f).svg")
	end
end

# SNR comparison
function SNR_comparison(dataset, e_f_list=["none", "snr_7"], t="RCMSE", r=0.2)
	entropy_file = h5open("./entropy_data/$(dataset)"*stim_suffix*"_entropy.h5", "r")
	entropy_data = read(entropy_file, "/$(t)/$(r)")

	l = @layout [a
		[grid(1,4)]
		[grid(1,4)]
	]
	p1 = plot(xlims=(1, 45))
	plot!(xlabel="Scale", ylabel="SampEn")
	plot!(title=t*" curves of $(dataset)\ncomparison of electrode filters")
	vspan!([1, 15], color=:black, alpha=0.1, label=:none)
	vspan!([16, 30], color=:black, alpha=0.1, label=:none)
	vspan!([31, 45], color=:black, alpha=0.1, label=:none)
	for e_f in e_f_list
		if !haskey(entropy_data["electrode_mean"], e_f)
			continue
		end
		entropy_curve = entropy_data["electrode_mean"][e_f]["curve"]
		scales = [i for i in 1:45]
		plot!(scales, entropy_curve, label=e_f)
	end
	# LRS
	p2 = []
	for (segment, lim) in zip(["all", "15", "30", "45"], ["1:45", "1:15", "16:30", "31:45"])
		p = plot(framestyle = :origin, xlims=(-1, 1), grid=false, xaxis=false, title="LRS "*lim)
		for e_f in e_f_list
			if !haskey(entropy_data["electrode_mean"], e_f)
				continue
			end
			if segment == "all"
				lrs = compute_LRS(entropy_data["electrode_mean"][e_f]["curve"], [i for i in 1:45])
			elseif segment == "15"
				lrs = compute_LRS(entropy_data["electrode_mean"][e_f]["curve"][1:15], [i for i in 1:15])
			elseif segment == "30"
				lrs = compute_LRS(entropy_data["electrode_mean"][e_f]["curve"][16:30], [i for i in 16:30])
			elseif segment == "45"
				lrs = compute_LRS(entropy_data["electrode_mean"][e_f]["curve"][31:45], [i for i in 31:45])
			end
			scatter!([0], [lrs], label=e_f, ms=5, markerstrokewidth=0)
		end
		p2 = [p2; p]
	end
	# nAUC
	p3 = []
	for (segment, lim) in zip(["all", "15", "30", "45"], ["1:45", "1:15", "16:30", "31:45"])
		p = plot(framestyle = :origin, xlims=(-1, 1), grid=false, xaxis=false, title="nAUC "*lim)
		for e_f in e_f_list
			if !haskey(entropy_data["electrode_mean"], e_f)
				continue
			end
			if segment == "all"
				nauc = compute_nAUC(entropy_data["electrode_mean"][e_f]["curve"])
			elseif segment == "15"
				nauc = compute_nAUC(entropy_data["electrode_mean"][e_f]["curve"][1:15])
			elseif segment == "30"
				nauc = compute_nAUC(entropy_data["electrode_mean"][e_f]["curve"][16:30])
			elseif segment == "45"
				nauc = compute_nAUC(entropy_data["electrode_mean"][e_f]["curve"][31:45])
			end
			
			scatter!([0], [nauc], label=e_f, ms=5, markerstrokewidth=0)
		end
		p3 = [p3; p]
	end
	plot(p1, p2..., p3..., layout=l, size=(900, 900), dpi=300)

	group = group_labels[findfirst(x -> dataset in x, grouped_datasets)]
	savefig("./plots_new/$(group)/$(dataset)/entropy/$(t)_$(r)_comparison.svg")

	close(entropy_file)
end

# LRS map
function LRS_map(dataset, t, r)
	entropy_file = h5open("./entropy_data/$(dataset)"*stim_suffix*"_entropy.h5", "r")
	lrs_all = zeros(16, 16)
	lrs_15 = zeros(16, 16)
	lrs_30 = zeros(16, 16)
	lrs_45 = zeros(16, 16)
	for i in 1:252
		signal = read(entropy_file, "/$(t)/$(r)/electrode_$(i-1)/event_mean/curve")
		lrs_all[coordinates[i][1], coordinates[i][2]] = compute_LRS(signal, [i for i in 1:45])
		lrs_15[coordinates[i][1], coordinates[i][2]] = compute_LRS(signal[1:15], [i for i in 1:15])
		lrs_30[coordinates[i][1], coordinates[i][2]] = compute_LRS(signal[16:30], [i for i in 16:30])
		lrs_45[coordinates[i][1], coordinates[i][2]] = compute_LRS(signal[31:45], [i for i in 31:45])
	end

	lrs_all[1, 1] = NaN
	lrs_all[1, 16] = NaN
	lrs_all[16, 1] = NaN
	lrs_all[16, 16] = NaN

	lrs_15[1, 1] = NaN
	lrs_15[1, 16] = NaN
	lrs_15[16, 1] = NaN
	lrs_15[16, 16] = NaN

	lrs_30[1, 1] = NaN
	lrs_30[1, 16] = NaN
	lrs_30[16, 1] = NaN
	lrs_30[16, 16] = NaN

	lrs_45[1, 1] = NaN
	lrs_45[1, 16] = NaN
	lrs_45[16, 1] = NaN
	lrs_45[16, 16] = NaN

	p1 = heatmap(lrs_all, c=:viridis, title="$(t) $(r) all, LRS", size=(800, 800), dpi=300, xaxis=false, yaxis=false)
	for n in 1:252
		annotate!([(coordinates[n][1], coordinates[n][2], text(electrode_labels[n], 4, :black, :center))])
	end
	p2 = heatmap(lrs_15, c=:viridis, title="$(t) $(r) 1-15, LRS", size=(800, 800), dpi=300, xaxis=false, yaxis=false)
	for n in 1:252
		annotate!([(coordinates[n][1], coordinates[n][2], text(electrode_labels[n], 4, :black, :center))])
	end
	p3 = heatmap(lrs_30, c=:viridis, title="$(t) $(r) 16-30, LRS", size=(800, 800), dpi=300, xaxis=false, yaxis=false)
	for n in 1:252
		annotate!([(coordinates[n][1], coordinates[n][2], text(electrode_labels[n], 4, :black, :center))])
	end
	p4 = heatmap(lrs_45, c=:viridis, title="$(t) $(r) 31-45, LRS", size=(800, 800), dpi=300, xaxis=false, yaxis=false)
	for n in 1:252
		annotate!([(coordinates[n][1], coordinates[n][2], text(electrode_labels[n], 4, :black, :center))])
	end
	plot(p1, p2, p3, p4, layout=(2, 2), size=(1000, 800), dpi=300)

	group = group_labels[findfirst(x -> dataset in x, grouped_datasets)]
	savefig("./plots_new/$(group)/$(dataset)/entropy/LRS_map_$(t)_$(r)_none.svg")

	# check if SNR file exists
	if !isfile(data_folder*"/"*dataset*"_SNR.h5")
		println("SNR file not found for dataset: ", dataset)
		return
	end

	snr_file = h5open(data_folder*"/"*dataset*"_SNR.h5", "r")
	snr_map = zeros(16, 16)
	for n in 1:252
		snr = read(snr_file, "electrode_$(n-1)/SNR")
		snr_map[coordinates[n][1], coordinates[n][2]] = snr
	end

	snr_map[1, 1] = NaN
	snr_map[1, 16] = NaN
	snr_map[16, 1] = NaN
	snr_map[16, 16] = NaN

	# SNR = 3 dB

	for i in 1:16
		for j in 1:16
			if snr_map[i, j] < 3
				lrs_all[i, j] = NaN
				lrs_15[i, j] = NaN
				lrs_30[i, j] = NaN
				lrs_45[i, j] = NaN
			end
		end
	end

	p1 = heatmap(lrs_all, c=:viridis, title="$(t) $(r) all, LRS", size=(800, 800), dpi=300, xaxis=false, yaxis=false)
	for n in 1:252
		annotate!([(coordinates[n][1], coordinates[n][2], text(electrode_labels[n], 4, :black, :center))])
	end
	p2 = heatmap(lrs_15, c=:viridis, title="$(t) $(r) 1-15, LRS", size=(800, 800), dpi=300, xaxis=false, yaxis=false)
	for n in 1:252
		annotate!([(coordinates[n][1], coordinates[n][2], text(electrode_labels[n], 4, :black, :center))])
	end
	p3 = heatmap(lrs_30, c=:viridis, title="$(t) $(r) 16-30, LRS", size=(800, 800), dpi=300, xaxis=false, yaxis=false)
	for n in 1:252
		annotate!([(coordinates[n][1], coordinates[n][2], text(electrode_labels[n], 4, :black, :center))])
	end
	p4 = heatmap(lrs_45, c=:viridis, title="$(t) $(r) 31-45, LRS", size=(800, 800), dpi=300, xaxis=false, yaxis=false)
	for n in 1:252
		annotate!([(coordinates[n][1], coordinates[n][2], text(electrode_labels[n], 4, :black, :center))])
	end
	plot(p1, p2, p3, p4, layout=(2, 2), size=(1000, 800), dpi=300)

	group = group_labels[findfirst(x -> dataset in x, grouped_datasets)]
	savefig("./plots_new/$(group)/$(dataset)/entropy/LRS_map_$(t)_$(r)_snr_3.svg")

	# SNR = 7 dB

	for i in 1:16
		for j in 1:16
			if snr_map[i, j] < 7
				lrs_all[i, j] = NaN
				lrs_15[i, j] = NaN
				lrs_30[i, j] = NaN
				lrs_45[i, j] = NaN
			end
		end
	end

	p1 = heatmap(lrs_all, c=:viridis, title="$(t) $(r) all, LRS", size=(800, 800), dpi=300, xaxis=false, yaxis=false)
	for n in 1:252
		annotate!([(coordinates[n][1], coordinates[n][2], text(electrode_labels[n], 4, :black, :center))])
	end
	p2 = heatmap(lrs_15, c=:viridis, title="$(t) $(r) 1-15, LRS", size=(800, 800), dpi=300, xaxis=false, yaxis=false)
	for n in 1:252
		annotate!([(coordinates[n][1], coordinates[n][2], text(electrode_labels[n], 4, :black, :center))])
	end
	p3 = heatmap(lrs_30, c=:viridis, title="$(t) $(r) 16-30, LRS", size=(800, 800), dpi=300, xaxis=false, yaxis=false)
	for n in 1:252
		annotate!([(coordinates[n][1], coordinates[n][2], text(electrode_labels[n], 4, :black, :center))])
	end
	p4 = heatmap(lrs_45, c=:viridis, title="$(t) $(r) 31-45, LRS", size=(800, 800), dpi=300, xaxis=false, yaxis=false)
	for n in 1:252
		annotate!([(coordinates[n][1], coordinates[n][2], text(electrode_labels[n], 4, :black, :center))])
	end
	plot(p1, p2, p3, p4, layout=(2, 2), size=(1000, 800), dpi=300)

	group = group_labels[findfirst(x -> dataset in x, grouped_datasets)]
	savefig("./plots_new/$(group)/$(dataset)/entropy/LRS_map_$(t)_$(r)_snr_7.svg")

	close(entropy_file)
end

# nAUC map
function nAUC_map(dataset, t, r)
	entropy_file = h5open("./entropy_data/$(dataset)"*stim_suffix*"_entropy.h5", "r")
	nauc_all = zeros(16, 16)
	nauc_15 = zeros(16, 16)
	nauc_30 = zeros(16, 16)
	nauc_45 = zeros(16, 16)
	
	for i in 1:252
		signal = read(entropy_file, "/$(t)/$(r)/electrode_$(i-1)/event_mean/curve")
		nauc_all[coordinates[i][1], coordinates[i][2]] = compute_nAUC(signal)
		nauc_15[coordinates[i][1], coordinates[i][2]] = compute_nAUC(signal[1:15])
		nauc_30[coordinates[i][1], coordinates[i][2]] = compute_nAUC(signal[16:30])
		nauc_45[coordinates[i][1], coordinates[i][2]] = compute_nAUC(signal[31:45])
	end

	nauc_all[1, 1] = NaN
	nauc_all[1, 16] = NaN
	nauc_all[16, 1] = NaN
	nauc_all[16, 16] = NaN

	nauc_15[1, 1] = NaN
	nauc_15[1, 16] = NaN
	nauc_15[16, 1] = NaN
	nauc_15[16, 16] = NaN

	nauc_30[1, 1] = NaN
	nauc_30[1, 16] = NaN
	nauc_30[16, 1] = NaN
	nauc_30[16, 16] = NaN

	nauc_45[1, 1] = NaN
	nauc_45[1, 16] = NaN
	nauc_45[16, 1] = NaN
	nauc_45[16, 16] = NaN

	p1 = heatmap(nauc_all, c=:viridis, title="$(t) $(r) all, nAUC", size=(800, 800), dpi=300, xaxis=false, yaxis=false)
	for n in 1:252
		annotate!([(coordinates[n][1], coordinates[n][2], text(electrode_labels[n], 4, :black, :center))])
	end
	p2 = heatmap(nauc_15, c=:viridis, title="$(t) $(r) 1-15, nAUC", size=(800, 800), dpi=300, xaxis=false, yaxis=false)
	for n in 1:252
		annotate!([(coordinates[n][1], coordinates[n][2], text(electrode_labels[n], 4, :black, :center))])
	end
	p3 = heatmap(nauc_30, c=:viridis, title="$(t) $(r) 16-30, nAUC", size=(800, 800), dpi=300, xaxis=false, yaxis=false)
	for n in 1:252
		annotate!([(coordinates[n][1], coordinates[n][2], text(electrode_labels[n], 4, :black, :center))])
	end
	p4 = heatmap(nauc_45, c=:viridis, title="$(t) $(r) 31-45, nAUC", size=(800, 800), dpi=300, xaxis=false, yaxis=false)
	for n in 1:252
		annotate!([(coordinates[n][1], coordinates[n][2], text(electrode_labels[n], 4, :black, :center))])
	end
	plot(p1, p2, p3, p4, layout=(2, 2), size=(1000, 800), dpi=300)

	group = group_labels[findfirst(x -> dataset in x, grouped_datasets)]
	savefig("./plots_new/$(group)/$(dataset)/entropy/nAUC_map_$(t)_$(r)_none.svg")

	# check if SNR file exists
	if !isfile(data_folder*"/"*dataset*"_SNR.h5")
		println("SNR file not found for dataset: ", dataset)
		return
	end

	snr_file = h5open(data_folder*"/"*dataset*"_SNR.h5", "r")
	snr_map = zeros(16, 16)
	for n in 1:252
		snr = read(snr_file, "electrode_$(n-1)/SNR")
		snr_map[coordinates[n][1], coordinates[n][2]] = snr
	end

	snr_map[1, 1] = NaN
	snr_map[1, 16] = NaN
	snr_map[16, 1] = NaN
	snr_map[16, 16] = NaN

	# SNR = 3 dB

	for i in 1:16
		for j in 1:16
			if snr_map[i, j] < 3
				nauc_all[i, j] = NaN
				nauc_15[i, j] = NaN
				nauc_30[i, j] = NaN
				nauc_45[i, j] = NaN
			end
		end
	end

	p1 = heatmap(nauc_all, c=:viridis, title="$(t) $(r) all, nAUC", size=(800, 800), dpi=300, xaxis=false, yaxis=false)
	for n in 1:252
		annotate!([(coordinates[n][1], coordinates[n][2], text(electrode_labels[n], 4, :black, :center))])
	end
	p2 = heatmap(nauc_15, c=:viridis, title="$(t) $(r) 1-15, nAUC", size=(800, 800), dpi=300, xaxis=false, yaxis=false)
	for n in 1:252
		annotate!([(coordinates[n][1], coordinates[n][2], text(electrode_labels[n], 4, :black, :center))])
	end
	p3 = heatmap(nauc_30, c=:viridis, title="$(t) $(r) 16-30, nAUC", size=(800, 800), dpi=300, xaxis=false, yaxis=false)
	for n in 1:252
		annotate!([(coordinates[n][1], coordinates[n][2], text(electrode_labels[n], 4, :black, :center))])
	end
	p4 = heatmap(nauc_45, c=:viridis, title="$(t) $(r) 31-45, nAUC", size=(800, 800), dpi=300, xaxis=false, yaxis=false)
	for n in 1:252
		annotate!([(coordinates[n][1], coordinates[n][2], text(electrode_labels[n], 4, :black, :center))])
	end
	plot(p1, p2, p3, p4, layout=(2, 2), size=(1000, 800), dpi=300)

	group = group_labels[findfirst(x -> dataset in x, grouped_datasets)]
	savefig("./plots_new/$(group)/$(dataset)/entropy/nAUC_map_$(t)_$(r)_snr_3.svg")

	# SNR = 7 dB

	for i in 1:16
		for j in 1:16
			if snr_map[i, j] < 7
				nauc_all[i, j] = NaN
				nauc_15[i, j] = NaN
				nauc_30[i, j] = NaN
				nauc_45[i, j] = NaN
			end
		end
	end

	p1 = heatmap(nauc_all, c=:viridis, title="$(t) $(r) all, nAUC", size=(800, 800), dpi=300, xaxis=false, yaxis=false)
	for n in 1:252
		annotate!([(coordinates[n][1], coordinates[n][2], text(electrode_labels[n], 4, :black, :center))])
	end
	p2 = heatmap(nauc_15, c=:viridis, title="$(t) $(r) 1-15, nAUC", size=(800, 800), dpi=300, xaxis=false, yaxis=false)
	for n in 1:252
		annotate!([(coordinates[n][1], coordinates[n][2], text(electrode_labels[n], 4, :black, :center))])
	end
	p3 = heatmap(nauc_30, c=:viridis, title="$(t) $(r) 16-30, nAUC", size=(800, 800), dpi=300, xaxis=false, yaxis=false)
	for n in 1:252
		annotate!([(coordinates[n][1], coordinates[n][2], text(electrode_labels[n], 4, :black, :center))])
	end
	p4 = heatmap(nauc_45, c=:viridis, title="$(t) $(r) 31-45, nAUC", size=(800, 800), dpi=300, xaxis=false, yaxis=false)
	for n in 1:252
		annotate!([(coordinates[n][1], coordinates[n][2], text(electrode_labels[n], 4, :black, :center))])
	end
	plot(p1, p2, p3, p4, layout=(2, 2), size=(1000, 800), dpi=300)

	group = group_labels[findfirst(x -> dataset in x, grouped_datasets)]
	savefig("./plots_new/$(group)/$(dataset)/entropy/nAUC_map_$(t)_$(r)_snr_7.svg")

	close(entropy_file)
end

# LRS distribution
function LRS_distribution(e_f_list, t, r)
	for (segment, lim) in zip(["all", "15", "30", "45"], ["1-45", "1-15", "16-30", "31-45"])
		for e_f in e_f_list
			# LRS distribution
			local grouped_lrs = Dict()
			local grouped_lrs_m = Dict()
			local grouped_lrs_f = Dict()
			for group in groups
				grouped_lrs[group] = Float64[]
				grouped_lrs_m[group] = Float64[]
				grouped_lrs_f[group] = Float64[]
			end
			for group in groups
				for dataset in grouped_datasets[group]
					entropy_file = h5open("./entropy_data/$(dataset)"*stim_suffix*"_entropy.h5", "r")
					entropy_data = read(entropy_file, "/$(t)/$(r)")

					if !haskey(entropy_data["electrode_mean"], e_f)
						continue
					end
					if segment == "all"
						lrs = compute_LRS(entropy_data["electrode_mean"][e_f]["curve"], [i for i in 1:45])
					elseif segment == "15"
						lrs = compute_LRS(entropy_data["electrode_mean"][e_f]["curve"][1:15], [i for i in 1:15])
					elseif segment == "30"
						lrs = compute_LRS(entropy_data["electrode_mean"][e_f]["curve"][16:30], [i for i in 16:30])
					elseif segment == "45"
						lrs = compute_LRS(entropy_data["electrode_mean"][e_f]["curve"][31:45], [i for i in 31:45])
					end

					push!(grouped_lrs[group], lrs)
					if dataset in grouped_s_datasets["male"]
						push!(grouped_lrs_m[group], lrs)
					else
						push!(grouped_lrs_f[group], lrs)
					end
					close(entropy_file)
				end
			end
			plot(size=(1000, 600), dpi=300, legend=:none)
			a_data = [grouped_lrs[group] for group in groups]
			a_m_data = [grouped_lrs_m[group] for group in groups]
			a_f_data = [grouped_lrs_f[group] for group in groups]

			violin_labels = [group_labels[group]*" ($(length(grouped_lrs[group])))" for group in groups]
			violin_labels = reshape(violin_labels, 1, length(violin_labels))

			violin!(violin_labels, a_data, label=violin_labels, color = v_color, fill = v_fill, ls=v_ls)
			dotplot!(violin_labels, a_m_data, label=false, line = 0, marker=:blue, side=:left, mode=:none, alpha=0.5)
			dotplot!(violin_labels, a_f_data, label=false, line = 0, marker=:pink, side=:left, mode=:none, alpha=0.5)
			plot!(xlabel="Group", ylabel="LRS", title="LRS distribution of $(t) $(r) $(lim), electrode filter: $(e_f)")

			println("subject count:", length([(a_data...)...]) )

			savefig("./plots_new/$(t)_$(r)/LRS_distribution_$(e_f)_$(lim).svg")
		end
	end
end

# LRS alt distribution
function LRS_alt_distribution(e_f_list, t, r)
	for (segment, lim) in zip(["all", "15", "30", "45"], ["1-45", "1-15", "16-30", "31-45"])
		for e_f in e_f_list
			# LRS distribution
			local grouped_lrs = Dict()
			local grouped_lrs_m = Dict()
			local grouped_lrs_f = Dict()
			for group in groups
				grouped_lrs[group] = Float64[]
				grouped_lrs_m[group] = Float64[]
				grouped_lrs_f[group] = Float64[]
			end
			for group in groups
				for dataset in grouped_datasets[group]
					entropy_file = h5open("./entropy_data/$(dataset)"*stim_suffix*"_entropy.h5", "r")

					if e_f != "none" && !isfile(data_folder*"/$(dataset)_SNR.h5")
						println("SNR file not found for dataset: ", dataset)
						continue
					end

					lrs = 0
					count = 0

					if e_f == "none"
						for i in 1:252
							signal = read(entropy_file, "/$(t)/$(r)/electrode_$(i-1)/event_mean/curve")
	
							if segment == "all"
								lrs += compute_LRS(signal, [i for i in 1:45])
							elseif segment == "15"
								lrs += compute_LRS(signal[1:15], [i for i in 1:15])
							elseif segment == "30"
								lrs += compute_LRS(signal[16:30], [i for i in 16:30])
							elseif segment == "45"
								lrs += compute_LRS(signal[31:45], [i for i in 31:45])
							end
							count += 1
						end
					else
						snr_file = h5open(data_folder*"/$(dataset)_SNR.h5", "r")
						for i in 1:252
							snr = read(snr_file, "/electrode_$(i-1)/SNR")

							if e_f == "snr_3" && snr < 3
								continue
							elseif e_f == "snr_7" && snr < 7
								continue
							end

							signal = read(entropy_file, "/$(t)/$(r)/electrode_$(i-1)/event_mean/curve")

							if segment == "all"
								lrs += compute_LRS(signal, [i for i in 1:45])
							elseif segment == "15"
								lrs += compute_LRS(signal[1:15], [i for i in 1:15])
							elseif segment == "30"
								lrs += compute_LRS(signal[16:30], [i for i in 16:30])
							elseif segment == "45"
								lrs += compute_LRS(signal[31:45], [i for i in 31:45])
							end

							count += 1
						end
						close(snr_file)
					end

					lrs /= count

					if isnan(lrs)
						println("$(dataset) LRS is NaN")
						continue
					end

					push!(grouped_lrs[group], lrs)
					if dataset in grouped_s_datasets["male"]
						push!(grouped_lrs_m[group], lrs)
					else
						push!(grouped_lrs_f[group], lrs)
					end

					close(entropy_file)
				end
			end

			plot(size=(1000, 600), dpi=300, legend=:none)
			a_data = [grouped_lrs[group] for group in groups]
			a_m_data = [grouped_lrs_m[group] for group in groups]
			a_f_data = [grouped_lrs_f[group] for group in groups]

			violin_labels = [group_labels[group]*" ($(length(grouped_lrs[group])))" for group in groups]
			violin_labels = reshape(violin_labels, 1, length(violin_labels))

			violin!(violin_labels, a_data, label=violin_labels, color = v_color, fill = v_fill, ls=v_ls)
			dotplot!(violin_labels, a_m_data, label=false, line = 0, marker=:blue, side=:left, mode=:none, alpha=0.5)
			dotplot!(violin_labels, a_f_data, label=false, line = 0, marker=:pink, side=:left, mode=:none, alpha=0.5)
			plot!(xlabel="Group", ylabel="LRS", title="LRS alt distribution of $(t) $(r) $(lim), electrode filter: $(e_f)")

			println("subject count:", length([(a_data...)...]) )

			savefig("./plots_new/$(t)_$(r)/LRS_alt_distribution_$(e_f)_$(lim).svg")
		end
	end
end

# nAUC distribution
function nAUC_distribution(e_f_list, t, r)
	for (segment, lim) in zip(["all", "15", "30", "45"], ["1-45", "1-15", "16-30", "31-45"])
		for e_f in e_f_list
			# nAUC distribution
			local grouped_nauc = Dict()
			local grouped_nauc_m = Dict()
			local grouped_nauc_f = Dict()
			for group in groups
				grouped_nauc[group] = Float64[]
				grouped_nauc_m[group] = Float64[]
				grouped_nauc_f[group] = Float64[]
			end
			for group in groups
				for dataset in grouped_datasets[group]
					entropy_file = h5open("./entropy_data/$(dataset)"*stim_suffix*"_entropy.h5", "r")
					entropy_data = read(entropy_file, "/$(t)/$(r)")

					if !haskey(entropy_data["electrode_mean"], e_f)
						continue
					end
					if segment == "all"
						nauc = compute_nAUC(entropy_data["electrode_mean"][e_f]["curve"])
					elseif segment == "15"
						nauc = compute_nAUC(entropy_data["electrode_mean"][e_f]["curve"][1:15])
					elseif segment == "30"
						nauc = compute_nAUC(entropy_data["electrode_mean"][e_f]["curve"][16:30])
					elseif segment == "45"
						nauc = compute_nAUC(entropy_data["electrode_mean"][e_f]["curve"][31:45])
					end

					push!(grouped_nauc[group], nauc)
					if dataset in grouped_s_datasets["male"]
						push!(grouped_nauc_m[group], nauc)
					else
						push!(grouped_nauc_f[group], nauc)
					end
					close(entropy_file)
				end
			end
			plot(size=(1000, 600), dpi=300, legend=:none)
			a_data = [grouped_nauc[group] for group in groups]
			a_m_data = [grouped_nauc_m[group] for group in groups]
			a_f_data = [grouped_nauc_f[group] for group in groups]

			violin_labels = [group_labels[group]*" ($(length(grouped_nauc[group])))" for group in groups]
			violin_labels = reshape(violin_labels, 1, length(violin_labels))

			violin!(violin_labels, a_data, label=violin_labels, color = v_color, fill = v_fill, ls=v_ls)
			dotplot!(violin_labels, a_m_data, label=false, line = 0, marker=:blue, side=:left, mode=:none, alpha=0.5)
			dotplot!(violin_labels, a_f_data, label=false, line = 0, marker=:pink, side=:left, mode=:none, alpha=0.5)
			plot!(xlabel="Group", ylabel="nAUC", title="nAUC distribution of $(t) $(r) $(lim), electrode filter: $(e_f)")

			println("subject count:", length([(a_data...)...]) )

			savefig("./plots_new/$(t)_$(r)/nAUC_distribution_$(e_f)_$(lim).svg")
		end
	end
end

# nAUC alt distribution
function nAUC_alt_distribution(e_f_list, t, r)
	for (segment, lim) in zip(["all", "15", "30", "45"], ["1-45", "1-15", "16-30", "31-45"])
		for e_f in e_f_list
			# nAUC distribution
			local grouped_nauc = Dict()
			local grouped_nauc_m = Dict()
			local grouped_nauc_f = Dict()
			for group in groups
				grouped_nauc[group] = Float64[]
				grouped_nauc_m[group] = Float64[]
				grouped_nauc_f[group] = Float64[]
			end
			for group in groups
				for dataset in grouped_datasets[group]
					entropy_file = h5open("./entropy_data/$(dataset)"*stim_suffix*"_entropy.h5", "r")

					if e_f != "none" && !isfile(data_folder*"/$(dataset)_SNR.h5")
						println("SNR file not found for dataset: ", dataset)
						continue
					end

					nauc = 0
					count = 0

					if e_f == "none"
						for i in 1:252
							signal = read(entropy_file, "/$(t)/$(r)/electrode_$(i-1)/event_mean/curve")
	
							if segment == "all"
								nauc += compute_nAUC(signal)
							elseif segment == "15"
								nauc += compute_nAUC(signal[1:15])
							elseif segment == "30"
								nauc += compute_nAUC(signal[16:30])
							elseif segment == "45"
								nauc += compute_nAUC(signal[31:45])
							end
							count += 1
						end
					else
						snr_file = h5open(data_folder*"/$(dataset)_SNR.h5", "r")
						for i in 1:252
							snr = read(snr_file, "/electrode_$(i-1)/SNR")

							if e_f == "snr_3" && snr < 3
								continue
							elseif e_f == "snr_7" && snr < 7
								continue
							end

							signal = read(entropy_file, "/$(t)/$(r)/electrode_$(i-1)/event_mean/curve")

							if segment == "all"
								nauc += compute_nAUC(signal)
							elseif segment == "15"
								nauc += compute_nAUC(signal[1:15])
							elseif segment == "30"
								nauc += compute_nAUC(signal[16:30])
							elseif segment == "45"
								nauc += compute_nAUC(signal[31:45])
							end

							count += 1
						end
						close(snr_file)
					end

					nauc /= count

					if isnan(nauc)
						println("$(dataset) nAUC is NaN")
						continue
					end

					push!(grouped_nauc[group], nauc)
					if dataset in grouped_s_datasets["male"]
						push!(grouped_nauc_m[group], nauc)
					else
						push!(grouped_nauc_f[group], nauc)
					end
					close(entropy_file)
				end
			end

			plot(size=(1000, 600), dpi=300, legend=:none)
			a_data = [grouped_nauc[group] for group in groups]
			a_m_data = [grouped_nauc_m[group] for group in groups]
			a_f_data = [grouped_nauc_f[group] for group in groups]

			violin_labels = [group_labels[group]*" ($(length(grouped_nauc[group])))" for group in groups]
			violin_labels = reshape(violin_labels, 1, length(violin_labels))

			violin!(violin_labels, a_data, label=violin_labels, color = v_color, fill = v_fill, ls=v_ls)
			dotplot!(violin_labels, a_m_data, label=false, line = 0, marker=:blue, side=:left, mode=:none, alpha=0.5)
			dotplot!(violin_labels, a_f_data, label=false, line = 0, marker=:pink, side=:left, mode=:none, alpha=0.5)
			plot!(xlabel="Group", ylabel="nAUC", title="nAUC alt distribution of $(t) $(r) $(lim), electrode filter: $(e_f)")

			println("subject count:", length([(a_data...)...]) )

			savefig("./plots_new/$(t)_$(r)/nAUC_alt_distribution_$(e_f)_$(lim).svg")
		end
	end
end

# STD LRS
function STD_LRS_distribution(e_f_list, t, r)
	for (segment, lim) in zip(["all", "15", "30", "45"], ["1-45", "1-15", "16-30", "31-45"])
		for e_f in e_f_list
			# LRS distribution
			local grouped_lrs = Dict()
			for group in groups
				grouped_lrs[group] = Float64[]
			end
			for group in groups
				for dataset in grouped_datasets[group]
					entropy_file = h5open("./entropy_data/$(dataset)"*stim_suffix*"_entropy.h5", "r")

					if e_f != "none" && !isfile(data_folder*"/$(dataset)_SNR.h5")
						println("SNR file not found for dataset: ", dataset)
						continue
					end

					lrs = Float64[]

					if e_f == "none"
						for i in 1:252
							signal = read(entropy_file, "/$(t)/$(r)/electrode_$(i-1)/event_mean/curve")
	
							if segment == "all"
								lrs = [lrs; compute_LRS(signal, [i for i in 1:45])]
							elseif segment == "15"
								lrs = [lrs; compute_LRS(signal[1:15], [i for i in 1:15])]
							elseif segment == "30"
								lrs = [lrs; compute_LRS(signal[16:30], [i for i in 16:30])]
							elseif segment == "45"
								lrs = [lrs; compute_LRS(signal[31:45], [i for i in 31:45])]
							end
						end
					else
						snr_file = h5open(data_folder*"/$(dataset)_SNR.h5", "r")
						for i in 1:252
							snr = read(snr_file, "/electrode_$(i-1)/SNR")

							if e_f == "snr_3" && snr < 3
								continue
							elseif e_f == "snr_7" && snr < 7
								continue
							end

							signal = read(entropy_file, "/$(t)/$(r)/electrode_$(i-1)/event_mean/curve")

							if segment == "all"
								lrs = [lrs; compute_LRS(signal, [i for i in 1:45])]
							elseif segment == "15"
								lrs = [lrs; compute_LRS(signal[1:15], [i for i in 1:15])]
							elseif segment == "30"
								lrs = [lrs; compute_LRS(signal[16:30], [i for i in 16:30])]
							elseif segment == "45"
								lrs = [lrs; compute_LRS(signal[31:45], [i for i in 31:45])]
							end
						end
						close(snr_file)
					end

					std_value = std(lrs)

					if isnan(std_value)
						println("$(dataset) LRS is NaN")
						continue
					end

					push!(grouped_lrs[group], std_value)

					close(entropy_file)
				end
			end

			plot(size=(1000, 600), dpi=300, legend=:none)
			a_data = [grouped_lrs[group] for group in groups]

			violin_labels = [group_labels[group]*" ($(length(grouped_lrs[group])))" for group in groups]
			violin_labels = reshape(violin_labels, 1, length(violin_labels))

			violin!(violin_labels, a_data, label=violin_labels, color = v_color, fill = v_fill, ls=v_ls)
			dotplot!(violin_labels, a_data, label=false, line = 0, marker=:black, side=:left, mode=:none, alpha=0.3)
			plot!(xlabel="Group", ylabel="STD", title="STD distribution of LRS $(t) $(r) $(lim), electrode filter: $(e_f)")

			println("subject count:", length([(a_data...)...]) )

			savefig("./plots_new/extra/STD_distribution_LRS_$(e_f)_$(lim).svg")
		end
	end
end

# STD nAUC
function STD_nAUC_distribution(e_f_list, t, r)
	for (segment, lim) in zip(["all", "15", "30", "45"], ["1-45", "1-15", "16-30", "31-45"])
		for e_f in e_f_list
			# LRS distribution
			local grouped_lrs = Dict()
			for group in groups
				grouped_lrs[group] = Float64[]
			end
			for group in groups
				for dataset in grouped_datasets[group]
					entropy_file = h5open("./entropy_data/$(dataset)"*stim_suffix*"_entropy.h5", "r")

					if e_f != "none" && !isfile(data_folder*"/$(dataset)_SNR.h5")
						println("SNR file not found for dataset: ", dataset)
						continue
					end

					lrs = Float64[]

					if e_f == "none"
						for i in 1:252
							signal = read(entropy_file, "/$(t)/$(r)/electrode_$(i-1)/event_mean/curve")
	
							if segment == "all"
								lrs = [lrs; compute_nAUC(signal)]
							elseif segment == "15"
								lrs = [lrs; compute_nAUC(signal[1:15])]
							elseif segment == "30"
								lrs = [lrs; compute_nAUC(signal[16:30])]
							elseif segment == "45"
								lrs = [lrs; compute_nAUC(signal[31:45])]
							end
						end
					else
						snr_file = h5open(data_folder*"/$(dataset)_SNR.h5", "r")
						for i in 1:252
							snr = read(snr_file, "/electrode_$(i-1)/SNR")

							if e_f == "snr_3" && snr < 3
								continue
							elseif e_f == "snr_7" && snr < 7
								continue
							end

							signal = read(entropy_file, "/$(t)/$(r)/electrode_$(i-1)/event_mean/curve")

							if segment == "all"
								lrs = [lrs; compute_nAUC(signal)]
							elseif segment == "15"
								lrs = [lrs; compute_nAUC(signal[1:15])]
							elseif segment == "30"
								lrs = [lrs; compute_nAUC(signal[16:30])]
							elseif segment == "45"
								lrs = [lrs; compute_nAUC(signal[31:45])]
							end
						end
						close(snr_file)
					end

					std_value = std(lrs)

					if isnan(std_value)
						println("$(dataset) LRS is NaN")
						continue
					end

					push!(grouped_lrs[group], std_value)

					close(entropy_file)
				end
			end

			plot(size=(1000, 600), dpi=300, legend=:none)
			a_data = [grouped_lrs[group] for group in groups]

			violin_labels = [group_labels[group]*" ($(length(grouped_lrs[group])))" for group in groups]
			violin_labels = reshape(violin_labels, 1, length(violin_labels))

			violin!(violin_labels, a_data, label=violin_labels, color = v_color, fill = v_fill, ls=v_ls)
			dotplot!(violin_labels, a_data, label=false, line = 0, marker=:black, side=:left, mode=:none, alpha=0.3)
			plot!(xlabel="Group", ylabel="STD", title="STD distribution of nAUC $(t) $(r) $(lim), electrode filter: $(e_f)")

			println("subject count:", length([(a_data...)...]) )

			savefig("./plots_new/extra/STD_distribution_nAUC_$(e_f)_$(lim).svg")
		end
	end
end

####################
# create directories
if !isdir("./plots_new")
	mkdir("./plots_new")
end

if !isdir("./plots_new/extra")
	mkdir("./plots_new/extra")
end

for t in t_list
	for r in r_list
		if !isdir("./plots_new/$(t)_$(r)")
			mkdir("./plots_new/$(t)_$(r)")
		end
	end
end

for group in groups
	if !isdir("./plots_new/$(group_labels[group])")
		mkdir("./plots_new/$(group_labels[group])")
	end
	if !isdir("./plots_new/extra/$(group_labels[group])")
		mkdir("./plots_new/extra/$(group_labels[group])")
	end
	for dataset in grouped_datasets[group]
		if !isdir("./plots_new/$(group_labels[group])/$(dataset)")
			mkdir("./plots_new/$(group_labels[group])/$(dataset)")
		end
		if !isdir("./plots_new/$(group_labels[group])/$(dataset)/signals")
			mkdir("./plots_new/$(group_labels[group])/$(dataset)/signals")
		end
		if !isdir("./plots_new/$(group_labels[group])/$(dataset)/signals/electrodes")
			mkdir("./plots_new/$(group_labels[group])/$(dataset)/signals/electrodes")
		end
		if !isdir("./plots_new/$(group_labels[group])/$(dataset)/entropy")
			mkdir("./plots_new/$(group_labels[group])/$(dataset)/entropy")
		end
	end 
end

for dataset in datasets
	signal_and_spectrogram_electrode_mean(dataset)
	SNR_map(dataset)

	#entropy
	for t in t_list
		for r in r_list
			# SNR_comparison(dataset, e_f_list, t, r)
			# LRS_map(dataset, t, r)
			# nAUC_map(dataset, t, r)
		end
	end
end

for t in t_list
	for r in r_list
		for group in groups
			group_entropy_curves(group, e_f_list, t, r)
		end

		mean_entropy_curves_comparison(e_f_list, t, r)
	end
end
# LRS and nAUC distribution
for t in t_list
	for r in r_list
		LRS_distribution(e_f_list, t, r)
		# LRS_alt_distribution(e_f_list, t, r)
		nAUC_distribution(e_f_list, t, r)
		# nAUC_alt_distribution(e_f_list, t, r)
		# STD_LRS_distribution(e_f_list, t, r)
		# STD_nAUC_distribution(e_f_list, t, r)
	end
end

println("Plots saved.")