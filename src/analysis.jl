# -*- coding: utf-8 -*-
# @author: max (max@mdotmonar.ch)

using HDF5
using Plots
using StatsPlots
using DSP
using HypothesisTests

include("processing.jl")
include("entropy.jl")

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

t_list = ["RCMSE"]
r_list = ["0.2"]
e_f_list = ["none", "snr_3", "snr_7"]

# Kruskal-Wallis test for LRS
function kruskal_test_LRS(e_f, segment)
	grouped_lrs = Dict()
	for group in groups
		grouped_lrs[group] = Float64[]
	end
	for group in groups
		for dataset in grouped_datasets[group]
			entropy_file = h5open("./entropy_data/$(dataset)_chirp_entropy.h5", "r")
			entropy_data = read(entropy_file, "/RCMSE/0.2")
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
			close(entropy_file)
		end
	end

	analysis_file = open("./analysis/Kruskal-Wallis_RCMSE_0.2_LRS_$(segment)_$(e_f).txt", "w")
	println("RCMSE 0.2 LRS $(segment) $(e_f): Analysis #####################################################")
	write(analysis_file, "RCMSE 0.2 LRS $(segment) $(e_f): Analysis #####################################################\n")
	kruskal_lrs = KruskalWallisTest(grouped_lrs["A"], grouped_lrs["B"], grouped_lrs["C"], grouped_lrs["D"], grouped_lrs["E"], grouped_lrs["F"], grouped_lrs["G"], grouped_lrs["H"])
	println("Kruskal-Wallis test p-value: $(pvalue(kruskal_lrs))")
	write(analysis_file, "Kruskal-Wallis test p-value: $(pvalue(kruskal_lrs))\n\n")
	println("")
	if pvalue(kruskal_lrs) < 0.05
		# perform mann-whitney u test for each pair
		println("Significant differences (Mann-Whitney U test):")
		write(analysis_file, "Significant differences (Mann-Whitney U test):\n")
		for i in 1:8
			for j in i+1:8
				mannwhitney = MannWhitneyUTest(grouped_lrs[groups[i]], grouped_lrs[groups[j]])
				if pvalue(mannwhitney) < 0.05
					println("$(group_labels[groups[i]]) vs $(group_labels[groups[j]]):\t\t\t$(pvalue(mannwhitney))")
					write(analysis_file, "$(group_labels[groups[i]]) vs $(group_labels[groups[j]]):\t\t\t$(pvalue(mannwhitney))\n")
				end
			end
		end
	end
	println("#############################################################################")
	write(analysis_file, "#############################################################################\n")
	println("")
	close(analysis_file)
end

# Kruskal-Wallis test for LRS alt
function kruskal_test_LRS_alt(e_f, segment)
	grouped_lrs = Dict()
	for group in groups
		grouped_lrs[group] = Float64[]
	end
	for group in groups
		for dataset in grouped_datasets[group]
			entropy_file = h5open("./entropy_data/$(dataset)_chirp_entropy.h5", "r")

			if e_f != "none" && !isfile("../SNR/$(dataset)_SNR.h5")
				println("SNR file not found for dataset: ", dataset)
				continue
			end

			lrs = 0
			count = 0

			if e_f == "none"
				for i in 1:252
					signal = read(entropy_file, "/RCMSE/0.2/electrode_$(i-1)/event_mean/curve")

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
				snr_file = h5open("../SNR/$(dataset)_SNR.h5", "r")
				for i in 1:252
					snr = read(snr_file, "/electrode_$(i-1)/SNR")

					if e_f == "snr_3" && snr < 3
						continue
					elseif e_f == "snr_7" && snr < 7
						continue
					end

					signal = read(entropy_file, "/RCMSE/0.2/electrode_$(i-1)/event_mean/curve")

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

			close(entropy_file)
		end
	end

	analysis_file = open("./analysis/Kruskal-Wallis_RCMSE_0.2_LRS_alt_$(segment)_$(e_f).txt", "w")
	println("RCMSE 0.2 LRS alt $(segment) $(e_f): Analysis #####################################################")
	write(analysis_file, "RCMSE 0.2 LRS alt $(segment) $(e_f): Analysis #####################################################\n")
	kruskal_lrs = KruskalWallisTest(grouped_lrs["A"], grouped_lrs["B"], grouped_lrs["C"], grouped_lrs["D"], grouped_lrs["E"], grouped_lrs["F"], grouped_lrs["G"], grouped_lrs["H"])
	println("Kruskal-Wallis test p-value: $(pvalue(kruskal_lrs))")
	write(analysis_file, "Kruskal-Wallis test p-value: $(pvalue(kruskal_lrs))\n\n")
	println("")
	if pvalue(kruskal_lrs) < 0.05
		# perform mann-whitney u test for each pair
		println("Significant differences (Mann-Whitney U test):")
		write(analysis_file, "Significant differences (Mann-Whitney U test):\n")
		for i in 1:8
			for j in i+1:8
				mannwhitney = MannWhitneyUTest(grouped_lrs[groups[i]], grouped_lrs[groups[j]])
				if pvalue(mannwhitney) < 0.05
					println("$(group_labels[groups[i]]) vs $(group_labels[groups[j]]):\t\t\t$(pvalue(mannwhitney))")
					write(analysis_file, "$(group_labels[groups[i]]) vs $(group_labels[groups[j]]):\t\t\t$(pvalue(mannwhitney))\n")
				end
			end
		end
	end
	println("#############################################################################")
	write(analysis_file, "#############################################################################\n")
	println("")
	close(analysis_file)
end

# Kruskal-Wallis test for nAUC
function kruskal_test_nAUC(e_f, segment)
	grouped_nauc = Dict()
	for group in groups
		grouped_nauc[group] = Float64[]
	end
	for group in groups
		for dataset in grouped_datasets[group]
			entropy_file = h5open("./entropy_data/$(dataset)_chirp_entropy.h5", "r")
			entropy_data = read(entropy_file, "/RCMSE/0.2")
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
			close(entropy_file)
		end
	end

	analysis_file = open("./analysis/Kruskal-Wallis_RCMSE_0.2_nAUC_$(segment)_$(e_f).txt", "w")
	println("RCMSE 0.2 nAUC $(segment) $(e_f): Analysis #####################################################")
	write(analysis_file, "RCMSE 0.2 nAUC $(segment) $(e_f): Analysis #####################################################\n")
	kruskal_nauc = KruskalWallisTest(grouped_nauc["A"], grouped_nauc["B"], grouped_nauc["C"], grouped_nauc["D"], grouped_nauc["E"], grouped_nauc["F"], grouped_nauc["G"], grouped_nauc["H"])
	println("Kruskal-Wallis test p-value: $(pvalue(kruskal_nauc))")
	write(analysis_file, "Kruskal-Wallis test p-value: $(pvalue(kruskal_nauc))\n\n")
	println("")
	if pvalue(kruskal_nauc) < 0.05
		# perform mann-whitney u test for each pair
		println("Significant differences (Mann-Whitney U test):")
		write(analysis_file, "Significant differences (Mann-Whitney U test):\n")
		for i in 1:8
			for j in i+1:8
				mannwhitney = MannWhitneyUTest(grouped_nauc[groups[i]], grouped_nauc[groups[j]])
				if pvalue(mannwhitney) < 0.05
					println("$(group_labels[groups[i]]) vs $(group_labels[groups[j]]):\t\t\t$(pvalue(mannwhitney))")
					write(analysis_file, "$(group_labels[groups[i]]) vs $(group_labels[groups[j]]):\t\t\t$(pvalue(mannwhitney))\n")
				end
			end
		end
	end
	println("#############################################################################")
	write(analysis_file, "#############################################################################\n")
	println("")
	close(analysis_file)
end

# Kruskal-Wallis test for nAUC alt
function kruskal_test_nAUC_alt(e_f, segment)
	grouped_nauc = Dict()
	for group in groups
		grouped_nauc[group] = Float64[]
	end
	for group in groups
		for dataset in grouped_datasets[group]
			entropy_file = h5open("./entropy_data/$(dataset)_chirp_entropy.h5", "r")

			if e_f != "none" && !isfile("../SNR/$(dataset)_SNR.h5")
				println("SNR file not found for dataset: ", dataset)
				continue
			end

			nauc = 0
			count = 0

			if e_f == "none"
				for i in 1:252
					signal = read(entropy_file, "/RCMSE/0.2/electrode_$(i-1)/event_mean/curve")

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
				snr_file = h5open("../SNR/$(dataset)_SNR.h5", "r")
				for i in 1:252
					snr = read(snr_file, "/electrode_$(i-1)/SNR")

					if e_f == "snr_3" && snr < 3
						continue
					elseif e_f == "snr_7" && snr < 7
						continue
					end

					signal = read(entropy_file, "/RCMSE/0.2/electrode_$(i-1)/event_mean/curve")

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

			close(entropy_file)
		end
	end

	analysis_file = open("./analysis/Kruskal-Wallis_RCMSE_0.2_nAUC_alt_$(segment)_$(e_f).txt", "w")
	println("RCMSE 0.2 nAUC $(segment) $(e_f): Analysis #####################################################")
	write(analysis_file, "RCMSE 0.2 nAUC $(segment) $(e_f): Analysis #####################################################\n")
	kruskal_nauc = KruskalWallisTest(grouped_nauc["A"], grouped_nauc["B"], grouped_nauc["C"], grouped_nauc["D"], grouped_nauc["E"], grouped_nauc["F"], grouped_nauc["G"], grouped_nauc["H"])
	println("Kruskal-Wallis test p-value: $(pvalue(kruskal_nauc))")
	write(analysis_file, "Kruskal-Wallis test p-value: $(pvalue(kruskal_nauc))\n\n")
	println("")
	if pvalue(kruskal_nauc) < 0.05
		# perform mann-whitney u test for each pair
		println("Significant differences (Mann-Whitney U test):")
		write(analysis_file, "Significant differences (Mann-Whitney U test):\n")
		for i in 1:8
			for j in i+1:8
				mannwhitney = MannWhitneyUTest(grouped_nauc[groups[i]], grouped_nauc[groups[j]])
				if pvalue(mannwhitney) < 0.05
					println("$(group_labels[groups[i]]) vs $(group_labels[groups[j]]):\t\t\t$(pvalue(mannwhitney))")
					write(analysis_file, "$(group_labels[groups[i]]) vs $(group_labels[groups[j]]):\t\t\t$(pvalue(mannwhitney))\n")
				end
			end
		end
	end
	println("#############################################################################")
	write(analysis_file, "#############################################################################\n")
	println("")
	close(analysis_file)
end

function complexity_std(dataset, t, r)
	entropy_file = h5open("./entropy_data/$(dataset)_chirp_entropy.h5", "r")
	lrs_all = zeros(16, 16)
	nauc_all = zeros(16, 16)
	lrs_15 = zeros(16, 16)
	nauc_15 = zeros(16, 16)
	lrs_30 = zeros(16, 16)
	nauc_30 = zeros(16, 16)
	lrs_45 = zeros(16, 16)
	nauc_45 = zeros(16, 16)

	for i in [1, 16]
		for j in [1, 16]
			lrs_all[i, j] = NaN
			nauc_all[i, j] = NaN
			lrs_15[i, j] = NaN
			nauc_15[i, j] = NaN
			lrs_30[i, j] = NaN
			nauc_30[i, j] = NaN
			lrs_45[i, j] = NaN
			nauc_45[i, j] = NaN
		end
	end
	
	for i in 1:252
		signal = read(entropy_file, "/$(t)/$(r)/electrode_$(i-1)/event_mean/curve")
		lrs_all[coordinates[i][1], coordinates[i][2]] = compute_LRS(signal, [i for i in 1:45])
		lrs_15[coordinates[i][1], coordinates[i][2]] = compute_LRS(signal[1:15], [i for i in 1:15])
		lrs_30[coordinates[i][1], coordinates[i][2]] = compute_LRS(signal[16:30], [i for i in 16:30])
		lrs_45[coordinates[i][1], coordinates[i][2]] = compute_LRS(signal[31:45], [i for i in 31:45])
		nauc_all[coordinates[i][1], coordinates[i][2]] = compute_nAUC(signal)
		nauc_15[coordinates[i][1], coordinates[i][2]] = compute_nAUC(signal[1:15])
		nauc_30[coordinates[i][1], coordinates[i][2]] = compute_nAUC(signal[16:30])
		nauc_45[coordinates[i][1], coordinates[i][2]] = compute_nAUC(signal[31:45])
	end

	group = group_labels[findfirst(x -> dataset in x, grouped_datasets)]
	std_file = open("./analysis/$(group)/$(dataset)_complexity_std.txt", "w")

	for (db, label) in zip([lrs_all, nauc_all, lrs_15, nauc_15, lrs_30, nauc_30, lrs_45, nauc_45], ["lrs_all", "nauc_all", "lrs_15", "nauc_15", "lrs_30", "nauc_30", "lrs_45", "nauc_45"])
		std_db = [db...]
		std_db = std_db[.!isnan.(std_db)]
		std_db = std(std_db)
		write(std_file, "$(label): $(std_db)\n")
	end

	close(entropy_file)
	close(std_file)
end


##################
# create directory
if !isdir("./analysis")
	mkdir("./analysis")
end

if !isdir("./analysis/tests")
	mkdir("./analysis/tests")
end

for group in groups
	if !isdir("./analysis/$(group_labels[group])")
		mkdir("./analysis/$(group_labels[group])")
	end
end

# perform analysis
for e_f in e_f_list
	for segment in ["all", "15", "30", "45"]
		#kruskal_test_LRS(e_f, segment)
		#kruskal_test_LRS_alt(e_f, segment)
		#kruskal_test_nAUC(e_f, segment)
		#kruskal_test_nAUC_alt(e_f, segment)
	end
end

for dataset in datasets
	complexity_std(dataset, "RCMSE", "0.2")
end

println("Analysis performed.")