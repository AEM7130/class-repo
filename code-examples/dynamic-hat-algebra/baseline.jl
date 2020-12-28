function solve_baseline_tvf(ap, mp)

    ################################
    ################################
    # required data inputs
    ################################
    ################################

    ### ACTUAL ECONOMY TIME PATHS
    # μ_baseline: actual migration shares ((J+1)Rx(J+1)RxT)
    # xbilat_baseline: actual bilateral expenditures (JNxNxT)
    # wages_baseline: change in wages (JxNxT)
    # λ_baseline: actual expenditure shares (JNxNxT)
    # labor_baseline: change in labor for mobile regions ((J+1)xRxT)
    # L0: actual initial labor for mobile regions ((J+1)Rx1)

    ### INITIAL VALUES AND PARAMETERS
    # VARjn00: structures value added (JxN)
    # VALjn00: labor value added (JxN)
    # λ00: initial expenditure shares (JNxN)
    # xbilat00: initial bilateral expenditures (JNxN)
    # Sn00: trade imbalances not explained by global portfolio (Nx1)
    # α: final consumption shares (JxN)
    # io: share of each region in global portfolio (Nx1)
    # Ψ: share of structures in structure-labor aggregate (JxN)
    # G: share of materials in gross output (JNxN)
    # γ: share of value added in gross output (JxN)
    # θinv: inverse of trade elasticity (Jx1)


    ################################
    ################################
    # load data
    ################################
    ################################

    actual_economy = matread("../data/test-cdp/Baseline_2000_2007_economy_actual_data.mat")
    base_year_full = matread("../data/test-cdp/Base_year_full.mat")
    extract(base_year_full)

    # actual_economy variables + L0_initial
    μ_baseline = [actual_economy["series_mu"][:,:,t] for t = 1:mp.T-1]
    xbilat_baseline = [actual_economy["series_xbilat"][:,:,t] for t = 1:mp.T]
    wages_baseline = [actual_economy["series_wageshat"][:,:,t] for t = 1:mp.T]
    λ_baseline = [actual_economy["Din_baseline"][:,:,t] for t = 1:mp.T]
    labor_baseline = [actual_economy["series_Ljn0hat"][:,:,t] for t = 1:mp.T]
    L0 = actual_economy["L0_initial"]

    labor0_usa = [labor_baseline[t][2:mp.J+1,:] for t = 1:mp.T]
    labor0 = [ones(mp.J, mp.N) for t = 1:mp.T]
    for t = 1:mp.T
        labor0[t][:,1:mp.R] = labor0_usa[t]
    end

    μ = μ_baseline
    μ00 = μ[1]

    # using the mobility flows to construct the evolution of labor allocations in the baseline economy
    L00 = reshape(L0, mp.J+1, mp.R)
    L00_aux0 = reshape(L00, (mp.J+1)*mp.R, 1)
    L00_aux1 = repeat(L00_aux0, 1, (mp.J+1)*mp.R)
    L00_aux1 = μ00.*L00_aux1
    L1 = sum(L00_aux1, dims = 1)'
    L1 = reshape(L1, mp.J+1, mp.R)

    # compute full labor path
    Ldyn = similar(labor_baseline)
    Ldyn[2] = L1
    Ldyn[1] = reshape(L0, mp.J+1, mp.R)

    for t = 2:(mp.T-1)
        aux = μ[t] .* repeat(reshape(Ldyn[t], (mp.J+1) * mp.R, 1), 1, (mp.J+1) * mp.R)
        aux = sum(aux, dims = 1)'
        Ldyn[t+1] = reshape(aux, (mp.J+1), mp.R)
    end

    Ltemp = [Ldyn[t][2:mp.J+1,:] for t = 1:mp.T]


    # set initial conditions
    VALjn0 = VALjn00 # labor value added
    VARjn0 = VARjn00 # structures value added
    Sn = Sn00 #trade imbalances not explained by global portfolio (they are zero by construction)
    Sn_prime = zeros(size(Sn)) # trade balance [exogenous] 2nd term on RHS of eq (14)
    λ = Din00 # bilateral trade shares
    xbilat = xbilat00 # bilateral trade flows
    real_wages = [ones(mp.J, mp.N) for i = 1:mp.T]
    Zs = [ones(mp.J, mp.N) for i = 1:mp.T] # fundamental productivity
    κ_hat = ones(mp.J * mp.N, mp.N) # relative changes in trade costs [exogenous]

    io = base_year_full["io"] # region shares
    α = alphas # sector shares in final demand
    γ = gamma # share of value added in output
    Ψ = B # share of structures in structure-labor aggregate

    G = base_year_full["G"]' # share of materials (TRANSPOSE SO WE PULL COLUMNS NOT ROWS)
    G_vec = [G[:,n:n+mp.J-1] for n = 1:mp.J:size(G,2)] # vector form for quicker algebra


    θinv = T # inverse of theta
    θinv_stack = similar(λ[:,1]) # stack θinv JxJ submatrices for easier multiplication later
    for j in 1:mp.J
        index = 1+(j-1)*mp.N:mp.N*j
        θinv_stack[index,:] = ones(mp.N)*θinv[j]
    end
    θinv_stack = repeat(θinv_stack, 1, mp.N)

    # storage vectors
    wages_out = [ones(mp.J, mp.N) for i = 1:mp.T]
    λ_out = [similar(λ) for i = 1:mp.T]
    xbilat_out = [similar(VARjn0) for i = 1:mp.T]

    wages_out[1] = ones(mp.J, mp.N)
    λ_out[1] = Din00
    xbilat_out[1] = xbilat_baseline[1]
    labor_out = [ones(mp.J, mp.N) for i = 1:mp.T]

    ################################
    # PART 2: given labor supply, solve for temporary
    # equilibrium (static production problem)
    ################################

    # initial phat guess
    phat = ones(mp.J, mp.N)

    # Solve static subproblem at time t
    for t = 1:(mp.T-1)

        println("Baseline economy: solving year $(t) of $(mp.T) with time-varying fundamentals.")

        Z_hat = Zs[t] # relative changes in technology/productivity

        labor = ones(mp.J, mp.N) # [exogenous] change in employment in other countries
        labor[:,1:mp.R] = Ltemp[t+1] ./ Ltemp[t]

        # lambdas
        λ_1 = λ_baseline[t+1]
        λ_0 = λ_baseline[t]
        # set initial guess to be baseline economy value
        ω0 = wages_baseline[t+1].*labor0[t+1].^Ψ
        ω = ω0
        ω, wages, Phat, rental_rate, phat, VARjn_prime, VALjn_prime, X_prime, λ_prime, xbilat_prime =
            solve_temp_equilibrium(
            ω, ω0, phat, labor, VARjn0, VALjn0, λ, λ_0, λ_1, Sn_prime,
            κ_hat, Z_hat, α, io, θinv, θinv_stack, Ψ, G, G_vec, γ,
            mp, ap
        )


        λ = λ_prime
        VARjn0 = VARjn_prime
        VALjn0 = VALjn_prime

        wages_out[t+1] = wages
        λ_out[t+1] = λ_prime
        xbilat_out[t+1] = xbilat_prime
        labor_out[t+1] = labor

    end

    save("../data/counterfactual/base_tvf.jld",
    "wages", wages_out,
    "λs", λ_out,
    "xbilats", xbilat_out,
    "labor", labor_out
    )


end


function solve_baseline_cf(ap, mp)

    ################################
    ################################
    # required data inputs
    ################################
    ################################

    ### TIME VARYING FUNDAMENTAL BASELINE ECONOMY TIME PATHS
    # μ_baseline: time varying fundamental baseline economy migration shares ((J+1)Rx(J+1)RxT)
    # L0_initial: actual initial labor for mobile regions in first year of TVF baseline economy ((J+1)Rx1)

    ### INITIAL VALUES AND PARAMETERS
    # VARjn00: structures value added (JxN)
    # VALjn00: labor value added (JxN)
    # λ00: initial expenditure shares (JNxN)
    # xbilat00: initial bilateral expenditures (JNxN)
    # Sn00: trade imbalances not explained by global portfolio (Nx1)
    # α: final consumption shares (JxN)
    # io: share of each region in global portfolio (Nx1)
    # Ψ: share of structures in structure-labor aggregate (JxN)
    # G: share of materials in gross output (JNxN)
    # γ: share of value added in gross output (JxN)
    # θinv: inverse of trade elasticity (Jx1)
    # μ: initial migration shares for first constant fundamental period (last tvf period) ((J+1)Rx(J+1)R)

    ### INITIAL GUESSES
    # H: initial guesses of udots ((J+1)xRxT)
    # ωs: initial guesses of factor prices (JxNxT)

    ################################
    ################################
    # compute initial conditions
    # based on tvf baseline results
    ################################
    ################################

    mu = matread("../data/test-cdp/mu.mat")
    base_year = matread("../data/test-cdp/Baseline_2000_2007_economy_actual.mat")
    extract(base_year)

    μs = mu["series_mu_adj"]
    μ0 =μs[:,:,end]
    μ = μs[:,:,1]
    labor = [similar(base_year["L0_initial"]) for n = 1:size(mu["series_mu_adj"],3)+1]
    labor[1] = base_year["L0_initial"]
    labor[2] = μ' * labor[1]

    for t = 2:size(μs,3)
        labor[t+1] = μs[:,:,t]' * labor[t]
    end

    L0 = labor[end]

    ################################
    ################################
    # initialize variables
    ################################
    ################################

    initial_H = matread("../data/test-cdp/Baseline_2007.mat")
    H = [reshape(initial_H["Hvectnoshock"][:,t], mp.J + 1, mp.R) for t = 1:mp.T]
    # H = load("../data/counterfactual/base_cf_climate2.jld")["H"]

    # # # initial guess for trajectory of changes in utility udot = exp(Vt+1 - V)^1/ν
    # H = [ones((mp.J + 1), mp.R) for i = 1:mp.T]
    # #

    # # initial factor price guesses
    ωs = load("../data/counterfactual/base_cf.jld")["ωs"]
    # ωs = [ones(mp.J, mp.N) for i = 1:mp.T]

    real_wages = [ones(mp.J, mp.N) for i = 1:mp.T]
    phats = [ones(mp.J, mp.N) for i = 1:mp.T] # initial factor price guesses
    wages = [ones(mp.J, mp.N) for i = 1:mp.T]
    Phats = [Array{Float64}(undef, mp.N) for i = 1:mp.T]
    xbilats = [ones(mp.J*mp.N, mp.N) for i = 1:mp.T]
    labor = [ones(mp.J, mp.N) for i = 1:mp.T]
    λs = similar(xbilats)
    Zs = [ones(mp.J, mp.N) for i = 1:mp.T] # fundamental productivity
    κ_hat = ones(mp.J * mp.N, mp.N) # relative changes in trade costs [exogenous]

    VALjn0 = VALjn00 # labor value added
    VARjn0 = VARjn00 # structures value added

    Sn = Sn00 # trade balance
    Sn_prime = zeros(size(Sn)) # trade balance [exogenous] 2nd term on RHS of eq (14)

    λ = Din00 # bilateral trade shares
    xbilat = xbilat00 # bilateral trade flows
    xbilats[1] = xbilat00 # bilateral trade flows
    io = base_year["io"] # region shares
    α = alphas # sector shares in final demand
    γ = gamma # share of value added in output

    G = base_year["G"]' # share of materials (TRANSPOSE SO WE PULL COLUMNS NOT ROWS)
    G_vec = [G[:,n:n+mp.J-1] for n = 1:mp.J:size(G,2)] # vector form for quicker algebra

    Ψ = B # share of structures in structure-labor aggregate

    θinv = T # inverse of theta
    θinv_stack = similar(λ[:,1]) # stack θinv JxJ submatrices for easier multiplication later
    for j in 1:mp.J
        index = 1+(j-1)*mp.N:mp.N*j
        θinv_stack[index,:] = ones(mp.N)*θinv[j]
    end
    θinv_stack = repeat(θinv_stack, 1, mp.N)

    iter = 1
    howard_iter = 1

    ################################
    ################################
    # outer loop
    ################################
    ################################

    while (iter <= ap.maxit) & (ap.Hmax > ap.tol_out)

        # reassign initial values
        VALjn0 = VALjn00 # labor value added
        VARjn0 = VARjn00 # structures value added
        λ = Din00 # bilateral trade shares

        println("Computing labor path.")
        ################################
        # PART 1: solve for migration
        # flows μdot and labor supply L
        ################################

        ################################
        # STEP 1: Create auxiliary udot matrix (need to make sure this works identically to matlab)
        # NJxNJ, the udot trajectory in equation (16)

        Haux = reshape.(H, 1, (mp.J + 1) * mp.R)
        Haux = repeat.(Haux, (mp.J + 1) * mp.R, 1)

        ################################
        # STEP 2: Determine the trajectory of migration shares using the initial migration share
        # (at t=-1) and the guess for the udot trajectory in Step 1

        # eq (16) numerator
        num = μ0 .* (Haux[2] .^ mp.beta)

        # eq (16) denominator
        den = sum(num', dims = 1)'
        den = repeat(den, 1, mp.R * (mp.J + 1))

        # time 0 migration share
        μ00 = num ./ den

        # initialize vector of migration shares
        μ = similar(H)
        μ[1] = μ00

        # given udot and mu(t), compute mu(t+1) using eqn(16) on p.755
        for t = 1:(mp.T-2)
            num = μ[t] .* (Haux[t+2] .^ mp.beta)
            den = sum(num', dims = 1)'
            den = repeat(den, 1, mp.R * (mp.J + 1))
            μ[t+1] = num ./ den
        end

        μ[mp.T] = μ[mp.T - 1]

        ################################
        # STEP 3: Use the trajectory of migration shares mu and the initial labor allocation L0
        # to compute the path of labor supply / allocations, given by eqn (18) on p.755

        # compute labor allocation at time t = 1
        L00 = reshape(L0, (mp.J + 1), mp.R)
        L00 = μ[1] .* repeat(reshape(L00, (mp.J + 1) * mp.R, 1), 1, (mp.J + 1) * mp.R)
        L1 = sum(L00, dims = 1)'
        L1 = reshape(L1, (mp.J + 1), mp.R)

        # compute full labor path
        Ldyn = similar(H)
        Ldyn[2] = L1
        Ldyn[1] = reshape(L0, (mp.J + 1), mp.R)

        for t = 2:(mp.T-1)
            aux = μ[t] .* repeat(reshape(Ldyn[t], (mp.J + 1) * mp.R, 1), 1, (mp.J + 1) * mp.R)
            aux = sum(aux, dims = 1)'
            Ldyn[t+1] = reshape(aux, (mp.J + 1), mp.R)
        end

        # labor in the final period is zero
        Ldyn[mp.T] .= 0

        ################################
        # PART 2: given labor supply, solve for temporary
        # equilibrium (static production problem)
        ################################


        if iter < ap.howard_start || howard_iter > ap.howard_its
            println("Solving static subproblems.")
            # Solve the static subproblem: path of temporary equilibria
            ωs, wages, phats, Phats, real_wages, xbilats, λs, labor = solve_static_subproblem(
                VARjn0, VALjn0, Zs, Ldyn, λ, μ, Haux, Sn_prime,
                κ_hat, α, io, θinv, θinv_stack, Ψ, G, G_vec, γ,
                mp, ap, ωs, phats
            )
            howard_iter = 1
        else
            howard_iter += 1
            println("Howard iteration $(howard_iter-1).")
        end

        println("Updating utility change guess.")

        ################################
        # PART 3: update guess of udot
        ################################

        # From real wages, compute Y
        real_wages_aux = [[1; (real_wages[t][:,1:mp.R]).^(1/mp.ν)] for t in 1:mp.T]
        real_wages_aux = repeat.(reshape.(real_wages_aux, mp.R*(mp.J+1), 1), 1, mp.R*(mp.J+1)) # 1st term on rhs of eq (17)

        real_wages_nu = [μ[t] .* real_wages_aux[t+1] for t in 1:mp.T-1] # 2nd term on rhs of eq (17)
        pushfirst!(real_wages_nu, zeros(size(real_wages_nu[1])))

        num = [real_wages_nu[t] .* Haux[t+1].^mp.beta for t in 1:mp.T-1] # RHS of eq (17) before summation
        push!(num, zeros(size(num[1])))

        H_new = [sum(num[t]', dims = 1)' for t = 1:mp.T] # new path of y's

        H_new[mp.T] .= 1.
        H[mp.T] .= 1
        H_old = reshape.(H, (mp.J+1)*mp.R, 1)

        # CDP error criterion
        if howard_iter == 1
            last_error = ap.Hmax
            ap.Hmax = maximum([maximum(abs.(H_new[t] - H_old[t])) for t in 2:mp.T])
            # ap.Hmax = maximum([maximum(abs.(Y[t] - Y_old[t])./Y_old[t]) for t in 2:mp.T])
            println("Outer loop iteration $iter error: $(ap.Hmax), previous iteration error: $(last_error).")
            iter += 1
        end

        H = [0.5 * reshape(H_new[t], (mp.J+1), mp.R) + 0.5 * H[t] for t in 1:mp.T]

        # Tighten up tolerance once close, switch back to solving
        if ap.Hmax < ap.tol_out .* 2.0
            if ap.tol_in < 1e-7
                println("Decreasing tolerance.")
            end
            ap.tol_in = max(ap.tol_in ./ 10, 1e-7)
            howard_iter = ap.howard_its + 1
        end

        save("../data/counterfactual/base_cf_TEMP_$(ap.tol_out)_$(ap.tol_in).jld", "H", H, "ωs", ωs)

    end

    save("../data/counterfactual/base_cf.jld", "H", H, "real_wages", real_wages, "ωs", ωs, "wages", wages, "Phats", Phats, "phats", phats, "xbilats", xbilats, "μs", μ, "λs", λs, "labor", labor)

end


function combine_baseline(mp_tvf, mp_cf)

    ################################
    ################################
    # required data inputs
    ################################
    ################################

    ### TIME VARYING FUNDAMENTAL BASELINE ECONOMY TIME PATHS
    # xbilats: tvf bilateral expenditures (JNxNxT)
    # wages: tvf baseline wages (JxNxT)
    # λs: tvf baseline expenditure shares (JNxNxT)
    # labor: tvf baseline change in labor for mobile regions (JxRxT)

    tvf_data = load("../data/counterfactual/base_tvf.jld")

    ### CONSTANT FUNDAMENTAL BASELINE ECONOMY TIME PATHS
    # μs: cf baseline economy migration shares ((J+1)Rx(J+1)RxT)
    # xbilats: cf baseline bilateral expenditures (JNxNxT)
    # wages: cf baseline wages (JxNxT)
    # λs: cf baseline expenditure shares (JNxNxT)
    # labor: cf baseline change in labor for mobile regions (JxRxT)

    cf_data = load("../data/counterfactual/base_cf.jld")

    ### DATA
    # μ: actual economy migration shares ((J+1)Rx(J+1)RxT)
    # labor0:

    μ_actual = matread("../data/test-cdp/mu.mat")["series_mu_adj"]
    μ_actual = [μ_actual[:,:,t] for t = 1:mp_tvf.T-1]
    L0 = matread("../data/test-cdp/Baseline_2000_2007_economy_actual_data.mat")["L0_initial"]


    ################################
    ################################
    # compute required baseline
    # economy paths
    ################################
    ################################

    # baseline migration shares
    μ_baseline = [similar(μ_actual[1]) for t = 1:(mp_cf.T + mp_tvf.T)]
    for t in 1:(mp_cf.T + mp_tvf.T)-1

        if t < mp_tvf.T
            μ_baseline[t] = μ_actual[t]
        else
            μ_baseline[t] = cf_data["μs"][t - mp_tvf.T + 1]
        end

    end

    # baseline bilateral expenditures
    xbilat_baseline = [tvf_data["xbilats"]; cf_data["xbilats"][2:end]]

    # baseline change in expenditure shares
    λ_baseline = [tvf_data["λs"]; cf_data["λs"][2:end]]

    # baseline change in labor allocation
    labor_baseline = [tvf_data["labor"]; cf_data["labor"][2:end]]

    # baseline change in wages
    wages_baseline = [tvf_data["wages"]; cf_data["wages"][2:end]]

    save("../data/counterfactual/baseline_economy.jld",
    "μ_baseline", μ_baseline,
    "xbilat_baseline", xbilat_baseline,
    "λ_baseline", λ_baseline,
    "labor_baseline", labor_baseline,
    "wages_baseline", wages_baseline,
    "L0", L0
    )



end
