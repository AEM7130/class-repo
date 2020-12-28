# parameters for the model
mutable struct modelParams{t1 <: Real, t2 <: Real, t3 <: Real, t4 <: Real, t5 <: Real, t6 <: Real}
    J::t1 # number of sectors
    N::t2 # number of regions
    R::t3 # number of regions with labor reallocation (may need R_1, R_2 for separate areas)
    T::t4 # number of years
    beta::t5 # discount factor
    ν::t6 # variance of idiosyncratic shock to households
end

# parameters for the algorithm
mutable struct algoParams{t1 <: Real, t2 <: Real, t3 <: Real, t4 <: Real, t5 <: Real, t6 <: Real, t7 <: Real, t8 <: Real}
    tol_out::t1 # solution tolerance for labor loop
    tol_in::t2 # solution tolerance for inner price loop
    maxit::t3 # maximum number of outer loop iterations
    Hmax::t4 # maximum difference between udot guess and actual udot
    iter::t5 # current iteration
    damp::t6 # damping parameter
    howard_start::t7 # iteration to start howard improvement
    howard_its::t8 # number of howard iterations
end
