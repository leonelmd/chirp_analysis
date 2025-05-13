using Random
using Statistics
using Plots
using Combinatorics

# --- Sample Entropy Functions ---
function chebyshev_distance(x, y)
    return maximum(abs.(x - y))
end

function generate_windows(signal, m)
    N = length(signal)
    return [signal[i:i + m - 1] for i in 1:N - m + 1]
end

function sample_entropy_matches(signal, m, r)
    m_vector = generate_windows(signal, m)
    m1_vector = generate_windows(signal, m + 1)

    A = sum(chebyshev_distance(i, j) <= r ? 1 : 0 for (i, j) in combinations(m1_vector, 2))
    B = sum(chebyshev_distance(i, j) <= r ? 1 : 0 for (i, j) in combinations(m_vector, 2))

    return A, B
end

function sample_entropy(signal, m, r)
    A, B = sample_entropy_matches(signal, m, r)
    return (A == 0 || B == 0) ? Inf : -log(A / B)
end

# --- Generate Signals ---
Random.seed!(123)
N = 1000

noise = randn(N)
sine_wave = sin.(2π .* (1:N) ./ 50)
sine_with_noise = sine_wave + 0.1 .* randn(N)

# --- Parameters ---
m = 2
r_noise = 0.2 * std(noise)
r_sine = 0.2 * std(sine_with_noise)

# --- Compute Sample Entropy ---
sampen_noise = sample_entropy(noise, m, r_noise)
sampen_sine = sample_entropy(sine_with_noise, m, r_sine)

# --- Plot Signals with Annotated Entropy ---
p1 = plot(noise, title="Gaussian Noise", xlabel="Time", ylabel="Amplitude", legend=false)
annotate!(p1, (50, maximum(noise) * 0.8, text("Sample Entropy = $(round(sampen_noise, digits=3))", :left, 10)))

p2 = plot(sine_with_noise, title="Sine + Noise", xlabel="Time", ylabel="Amplitude", legend=false)
annotate!(p2, (50, maximum(sine_with_noise) * 0.8, text("Sample Entropy = $(round(sampen_sine, digits=3))", :left, 10)))

plot(p1, p2, layout=(2, 1), size=(800, 500))
savefig("./plots/test_noise_sine.svg")
