# -*- coding: utf-8 -*-
# @author: max (max@mdotmonar.ch)

using HDF5
using Plots
using StatsPlots
using DSP
using CSV
using DataFrames
using XLSX

include("processing.jl")
include("entropy.jl")

groups = ["A", "B", "C", "D", "E", "F", "G", "H"]

group_labels = Dict()
group_labels["A"] = "WT young"
group_labels["B"] = "WT adult"
group_labels["C"] = "5xFAD young"
group_labels["D"] = "5xFAD adult"
group_labels["E"] = "XBP1s young"
group_labels["F"] = "XBP1s adult"
group_labels["G"] = "Double young"
group_labels["H"] = "Double adult"
group_labels_plot = ["WT young" "WT adult" "5xFAD young" "5xFAD adult" "XBP1s young" "XBP1s adult" "Double young" "Double adult"]

grouped_datasets = Dict()
grouped_datasets["A"] = [
	# WT 3m male
	"MR-0474",
	"MR-0311",
	"MR-0309",
	"MR-0306",
	"MR-0299-t2",
	"MR-0299-t1",
	"MR-0298-t2",
	"MR-0298-t1",
	"MR-0296-t2",
	"MR-0296-t1",
	# WT 3m female
	"MR-0491",
	"MR-0303",
	"MR-0300-t2",
	"MR-0300-t1",
]
grouped_datasets["B"] = [
	# WT 6m male
	"MR-0282",
	"MR-0276",
	"MR-0273",
	"MR-0270",
	# WT 6m female
	"MR-0294",
	"MR-0289",
	"MR-0288-t2",
	"MR-0288-t1",
	"MR-0284",
	"MR-0283-t2",
]
grouped_datasets["C"] = [
	# 5xFAD 3m male
	"MR-0310",
	"MR-0305",
	# 5xFAD 3m female
	"MR-0313",
	"MR-0312",
	"MR-0307-t2",
	"MR-0304-t2",
	"MR-0302-t2",
	"MR-0302-t1",
	"MR-0301-t2",
	"MR-0301-t1",
	"MR-0297",
]
grouped_datasets["D"] = [
	# 5xFAD 6m male
	"MR-0448",
	"MR-0447",
	"MR-0446",
	"MR-0293",
	"MR-0292-t2",
	"MR-0292-t1",
	"MR-0280-t2",
	"MR-0280-t1",
	"MR-0278",
	"MR-0275",
	# 5xFAD 6m female
	"MR-0291",
	"MR-0290",
	"MR-0287",
	"MR-0285-t2",
	"MR-0285-t1",
	"MR-0274",
]
grouped_datasets["E"] = [
	# XBP1s 3m male
	"MR-0592_nd4",
	"MR-0591_nd4",
	"MR-0483",
	"MR-0460",
	"MR-0456",
	# XBP1s 3m female
	"MR-0621_nd4",
	"MR-0620_nd4",
	"MR-0593_nd4",
	"MR-0573_nd4",
]
grouped_datasets["F"] = [
	# XBP1s 6m male
	"MR-0599_nd4",
	"MR-0597_nd4",
	"MR-0596_nd4",
	"MR-0569_nd4",
	"MR-0554",
	"MR-0465-t2",
	"MR-0465-t1",
	# XBP1s 6m female
	"MR-0625_nd4",
	"MR-0624_nd4",
	"MR-0623_nd4",
	"MR-0622_nd4",
]
grouped_datasets["G"] = [
	# Double 3m male
	"MR-0575_nd4",
	"MR-0583_nd4",
	# Double 3m female
	"MR-0577_nd4",
	"MR-0579_nd4",
	"MR-0585_nd4",
	"MR-0586_nd4",
]
grouped_datasets["H"] = [
	# Double 6m male
	"MR-0630_nd4",
	"MR-0629-t2_nd4",
	"MR-0629-t1_nd4",
	"MR-0552",
	# Double 6m female
	"MR-0530",
	"MR-0548-t1",
	"MR-0548-t2",
	"MR-0568_nd4",
	"MR-0582_nd4",
	"MR-0587_nd4",
	"MR-0588_nd4",
]

datasets = []
for group in groups
	global datasets = [datasets; grouped_datasets[group]]
end

v_color = [:skyblue :skyblue :tomato :tomato :seagreen :seagreen :goldenrod :goldenrod]
v_color_index = Dict()
v_color_index["A"] = :skyblue 
v_color_index["B"] = :skyblue
v_color_index["C"] = :tomato
v_color_index["D"] = :tomato
v_color_index["E"] = :seagreen
v_color_index["F"] = :seagreen
v_color_index["G"] = :goldenrod
v_color_index["H"] = :goldenrod
v_fill = [0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5]
v_ls = [:dash :dashdot :dash :dashdot :dash :dashdot :dash :dashdot]
v_ls_index = Dict()
v_ls_index["A"] = :dash
v_ls_index["B"] = :dashdot
v_ls_index["C"] = :dash
v_ls_index["D"] = :dashdot
v_ls_index["E"] = :dash
v_ls_index["F"] = :dashdot
v_ls_index["G"] = :dash
v_ls_index["H"] = :dashdot

t_list = ["FRCMSE"]
r_list = ["0.2"]
e_f_list = [
	"none",
	"snr_0",
	"snr_1",
	"snr_2",
	"snr_3",
	"snr_4",
	"snr_5",
	"snr_6",
	"snr_7"
]


# load entropy data
entropy_data = Dict()

for dataset in datasets
	entropy_data[dataset] = Dict()
	for t in t_list
		entropy_data[dataset][t] = Dict()
		for r in r_list
			entropy_data[dataset][t][r] = Dict()
		end
	end
end

for dataset in datasets
	file = h5open("./entropy_data/$(dataset)_chirp_entropy.h5", "r")

	for type in t_list
		for r in r_list
			entropy = read(file["/$(type)/$(r)/electrode_mean"])
			for e_f in keys(entropy)
				entropy_data[dataset][type][r][e_f] = Dict()
				entropy_data[dataset][type][r][e_f]["curve"] = entropy[e_f]["curve"]
				entropy_data[dataset][type][r][e_f]["LRS_all"] = compute_LRS(entropy[e_f]["curve"], [i for i in 1:45])
				entropy_data[dataset][type][r][e_f]["LRS_15"] = compute_LRS(entropy[e_f]["curve"][1:15], [i for i in 1:15])
				entropy_data[dataset][type][r][e_f]["LRS_30"] = compute_LRS(entropy[e_f]["curve"][16:30], [i for i in 16:30])
				entropy_data[dataset][type][r][e_f]["LRS_45"] = compute_LRS(entropy[e_f]["curve"][31:45], [i for i in 31:45])
				entropy_data[dataset][type][r][e_f]["nAUC_all"] = compute_nAUC(entropy[e_f]["curve"])
				entropy_data[dataset][type][r][e_f]["nAUC_15"] = compute_nAUC(entropy[e_f]["curve"][1:15])
				entropy_data[dataset][type][r][e_f]["nAUC_30"] = compute_nAUC(entropy[e_f]["curve"][16:30])
				entropy_data[dataset][type][r][e_f]["nAUC_45"] = compute_nAUC(entropy[e_f]["curve"][31:45])
			end
		end
	end

	close(file)
end

# === Select the metrics you want ===
selected_metrics = ["LRS_all", "LRS_15", "LRS_30", "LRS_45", "nAUC_all", "nAUC_15", "nAUC_30", "nAUC_45"]

# === Build the table ===
rows = []

for group in groups
	for dataset in grouped_datasets[group]
		if "snr_7" in keys(entropy_data[dataset]["FRCMSE"]["0.2"])
			
		    data_dict = entropy_data[dataset]["FRCMSE"]["0.2"]["snr_7"]
		    data_dict["Subject"] = dataset
		    data_dict["Group"] = group_labels[group]

		    # for metric in selected_metrics
		    #     row[metric] = get(data_dict, metric, missing)
		    #     # println(get(data_dict, metric, missing))
		    # end
		    # row["Subject"] = datasets
		    # println(row)
		    push!(rows, Dict(string(k) => (isa(v, AbstractVector) && length(v) == 1 ? v[1] : v) for (k, v) in data_dict))
		end
	end
end

# === Create and export DataFrame ===
df = DataFrame(rows)

CSV.write("entropy_export_FRCMSE.csv", df)
# XLSX.writetable("entropy_export.xlsx", collect(eachcol(df)), names(df))

