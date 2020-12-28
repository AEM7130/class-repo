# Load and activate packages
using Pkg
Pkg.activate(".")
Pkg.instantiate()
using LinearAlgebra, CSV, Statistics, MAT, JLD

################################
################################
# load other jl files
################################
################################

include("custom_types.jl")  # parametric types specific to this project
include("solvers_tvf.jl")       # inner solver functions for time varying fundamentals
include("solvers_cf.jl")       # inner solver functions for constant fundamentals
include("aux_functions.jl") # auxiliary functions
include("baseline.jl")      # baseline equilibrium-specific functions
include("counterfactual.jl")      # counterfactual equilibrium-specific functions

################################
################################
# construct datasets
################################
################################

################################
################################
# initialize parameter type
################################
################################

# model parameters
mp_cf = modelParams(22, 87, 50, 200, 0.99, 5.3436)
mp_tvf = modelParams(22, 87, 50, 29, 0.99, 5.3436)
mp_counterfactual = modelParams(22, 87, 50, 200, 0.99, 5.3436)

# algorithm parameters
ap_cf = algoParams(1e-3, 1e-2, 1e5, 1., 1, .05, Inf, 15)
ap_cf = algoParams(1e-3, 1e-7, 1e5, 1., 1, .05, Inf, 15)
ap_tvf = algoParams(1e-3, 1e-7, 1e5, 1., 1, .05, Inf, 10)
ap_counterfactual = algoParams(1e-3, 1e-7, 1e5, 1., 1, .05, Inf, 15)

################################
################################
# solve baseline model
################################
################################

# time varying fundamentals for years where we have data
@time solve_baseline_tvf(ap_tvf, mp_tvf)

# constant fundamentals past the last year of our data
@time solve_baseline_cf(ap_cf, mp_cf)

# combine the two baseline economies into one
@time combine_baseline(mp_tvf, mp_cf)

################################
################################
# solve counterfactual model
################################
################################

# compute the counterfactual outcome in changes relative to baseline
@time solve_counterfactual_tvf(ap_counterfactual, mp_counterfactual)

################################
################################
# compute results
################################
################################
