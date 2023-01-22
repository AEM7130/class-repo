#!/bin/bash
curl -fsSL https://install.julialang.org | sh
mkdir -p ~/.julia-environments/tools
cd ~/.julia-environments/tools
julia -e 'using Pkg; Pkg.activate("."); Pkg.add("Revise"); Pkg.add("OhMyREPL"); Pkg.add("BenchmarkTools")'
echo 'push!(LOAD_PATH, Base.Filesystem.homedir() * "/.julia-environments/tools/")
try
    @eval using OhMyREPL
catch e
    @warn "Error initializing OhMyREPL" exception=(e, catch_backtrace())
end

try
    @eval using Revise
catch e
    @warn "Error initializing Revise" exception=(e, catch_backtrace())
end

try
    @eval using BenchmarkTools
catch e
    @warn "Error initializing BenchmarkTools" exception=(e, catch_backtrace())
end' > ~/.julia/config/startup.jl

