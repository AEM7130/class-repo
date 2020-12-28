function solve_counterfactual_tvf(ap, mp)


    ################################
    ################################
    # required data inputs
    ################################
    ################################

    ### BASELINE ECONOMY TIME PATHS
    # μ_baseline: baseline migration shares ((J+1)Rx(J+1)RxT)
    # xbilat_baseline: baseline bilateral expenditures (JNxNxT)
    # wages_baseline: baseline change in wages (JxNxT)
    # λ_baseline: baseline change in expenditure shares (JNxNxT)
    # labor_baseline: baseline change in labor for mobile regions ((J+1)xRxT)
    # L0: baseline initial labor for mobile regions [actual data] ((J+1)Rx1)

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

    ### INITIAL GUESSES
    # H: initial guesses of udots ((J+1)xRxT)
    # ωs: initial guesses of factor prices (JxNxT)

    ### COUNTERFACTUAL SHOCKS
    # Zs: counterfactual Zdot / baseline Zdot (JxNxT)

    ################################
    ################################
    # counterfactual shocks
    ################################
    ################################

    # counterfactual Zdot / baseline Zdot
    Zs = [ones(mp.J, mp.N) for i = 1:mp.T]
    china=[25.6097
            7.6093
            5.2773
            9.2464
            7.6897
            45.7781
            5.9298
            5.6533
            64.5661
            38.9064
            196.6509
            3.5324]
    china = china.^(1/28)
    for t = 1:28
        Zs[t][1:12, 57] = china
    end


    ################################
    ################################
    # load baseline and initial data
    ################################
    ################################
    #
    baseline_economy = load("../data/counterfactual/baseline_economy.jld")
    extract(baseline_economy)
    μ00 = μ_baseline[1]

    #baseline_economy = matread("../data/test-cdp/Baseline_economy.mat")
    counterfactual_economy = matread("../data/test-cdp/Counterfactual_economy.mat")

    # load baseline economy and base year data
    # baseline_economy = load("../data/counterfactual/baseline_economy.jld")
    # extract(baseline_economy)

    # Usual initial conditions
    base_year_full = matread("../data/test-cdp/Base_year_full.mat")
    extract(base_year_full)


    # # initial guess for counterfactual trajectory of changes in utility udot = exp(Vt+1 - V)^1/ν
    Hc = [ones((mp.J + 1), mp.R) for i = 1:mp.T]
    Hc = [reshape(counterfactual_economy["V"][:,t], mp.J + 1, mp.R) for t = 1:mp.T]


    # set initial conditions
    VALjn0 = VALjn00 # labor value added
    VARjn0 = VARjn00 # structures value added
    λ = Din00 # bilateral trade shares
    Sn = Sn00 #trade imbalances not explained by global portfolio (they are zero by construction)
    Sn_prime = zeros(size(Sn)) # trade balance [exogenous] 2nd term on RHS of eq (14)
    xbilat = xbilat00 # bilateral trade flows
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
    VARjn0_out = [similar(VARjn0) for i = 1:mp.T]
    VALjn0_out = [similar(VARjn0) for i = 1:mp.T]
    real_wages = [ones(mp.J, mp.N) for i = 1:mp.T]
    Ldyn = similar(labor_baseline)
    μ = [zeros(mp.R * (mp.J+1), mp.R * (mp.J + 1)) for t in 1:mp.T]

    wages_out[1] = ones(mp.J, mp.N)
    λ_out[1] = Din00
    xbilat_out[1] = xbilat_baseline[1]

    # initial phat guess
    phats = [ones(mp.J, mp.N) for i = 1:mp.T] # initial factor price guesses

    ################################
    ################################
    # outer loop
    ################################
    ################################

    iter = 1

    while (iter <= ap.maxit) & (ap.Hmax > ap.tol_out)

        # reassign initial values
        VALjn0 = VALjn00 # labor value added
        VARjn0 = VARjn00 # structures value added
        λ = Din00 # bilateral trade shares

        Hcaux = reshape.(Hc, 1, (mp.J + 1) * mp.R)
        Hcaux = repeat.(Hcaux, (mp.J + 1) * mp.R, 1)

        # Step 2 in algorithm described in Appendix 3 Part II (create path of migration matrices)
        # Calculate mu1_tilde that refers the mobility matrix vartheta in the
        # appendix that has information on the jump in values
        μ = [zeros(mp.R * (mp.J+1), mp.R * (mp.J + 1)) for t in 1:mp.T]
        μ[1] = μ_baseline[2].*(Hcaux[2].^mp.beta);

        # Computing the mobility matrix at t=1
        num = μ[1].*(Hcaux[3].^mp.beta)
        num[isnan.(num)] .= 0
        den = sum(num', dims = 1)'
        μ[2] = num./den

        # And now for all the other time periods
        for t = 2:mp.T-2
            num = (μ_baseline[t+1]./μ_baseline[t]).*μ[t].*(Hcaux[t+2].^mp.beta)
            num[isnan.(num)] .= 0
           den = sum(num')'
           den = sum(num', dims = 1)'
           μ[t+1] = num./den
       end

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

        Ldyn[mp.T] .= 0
        Ltemp = [Ldyn[t][2:mp.J+1,:] for t = 1:mp.T]

        ################################
        # PART 2: given labor supply, solve for temporary
        # equilibrium (static production problem)
        ################################

        # Solve static subproblem at time t
        for t = 1:(mp.T-2)

            println("Counterfactual economy: solving period $(t) of $(mp.T).")

            Z_hat = 1 ./Zs[t] # change in productivity relative to baseline
            phat = phats[t]
            labor = ones(mp.J, mp.N) # [exogenous] change in employment in other countries
            labor[:,1:mp.R] = Ltemp[t+1] ./ Ltemp[t]

            # lambdas
            λ_1 = λ_baseline[t+1]
            λ_0 = λ_baseline[t]
            # set initial guess to be baseline economy value
            ω0 = wages_baseline[t+1].*labor_baseline[t+1].^Ψ
            ω = ω0
            ω, wages, Phat, rental_rate, phat, VARjn_prime, VALjn_prime, X_prime, λ_prime, xbilat_prime =
                solve_temp_equilibrium(
                ω, ω0, phat, labor, VARjn0, VALjn0, λ, λ_0, λ_1, Sn_prime,
                κ_hat, Z_hat, α, io, θinv, θinv_stack, Ψ, G, G_vec, γ,
                mp, ap
            )

            # Get next period values
            λ = λ_prime
            VARjn0 = VARjn_prime
            VALjn0 = VALjn_prime

            wages_out[t+1] = wages
            λ_out[t+1] = λ_prime
            VARjn0_out = VARjn_prime
            VALjn0_out = VALjn_prime
            xbilat_out[t+1] = xbilat_prime
            real_wages[t+1] = (wages./wages_baseline[t+1])./Phat
            phats[t] = phat

        end

        # From real wages, compute H
        real_wages_aux = [[1; (real_wages[t][:,1:mp.R]).^(1/mp.ν)] for t in 1:mp.T]
        real_wages_aux = reshape.(real_wages_aux, mp.R*(mp.J+1), 1) # 1st term on rhs of eq (17)

        # update changes in value at t = 1
        H0 = repeat(reshape(Hc[2], mp.R * (mp.J + 1), 1)', mp.R * (mp.J + 1), 1)
        μ1 = μ_baseline[2].*H0.^mp.beta
        aux = μ1 .* Hcaux[3].^mp.beta
        aux = sum(aux', dims = 1)'
        H0 = aux.*real_wages_aux[2]

        # update changes in value at other times t
        real_wages_aux = [[1; (real_wages[t][:,1:mp.R]).^(1/mp.ν)] for t in 1:mp.T]
        real_wages_aux = repeat.(reshape.(real_wages_aux, mp.R*(mp.J+1), 1), 1, mp.R*(mp.J+1)) # 1st term on rhs of eq (17)

        H_temp = [zeros(mp.R * (mp.J + 1), mp.R * (mp.J + 1)) for t in 1:mp.T]
        for t in 1:mp.T-1
            H_temp[t+1] = μ_baseline[t+1] ./ μ_baseline[t] .* μ[t] .* real_wages_aux[t+1]
            H_temp[t+1][isnan.(H_temp[t+1])] .= 0
        end

        num = [H_temp[t] .* Hcaux[t+1].^mp.beta for t in 1:mp.T-1] # RHS of eq (17) before summation
        push!(num, zeros(size(num[1])))

        Hc_new = [vec(sum(num[t]', dims = 1)) for t = 3:mp.T] # new path of y's
        pushfirst!(Hc_new, vec(H0))
        pushfirst!(Hc_new, vec(zeros(size(H0))))
        Hc_new[mp.T] .= 1.
        Hc[mp.T] .= 1
        Hc_old = reshape.(Hc, (mp.J+1)*mp.R, 1)

        # CDP error criterion
        last_error = ap.Hmax
        ap.Hmax = maximum([maximum(abs.(Hc_new[t] - Hc_old[t])) for t in 2:mp.T])
        println("Outer loop iteration $iter error: $(ap.Hmax), previous iteration error: $(last_error).")

        Hc = [0.5 * reshape(Hc_new[t], (mp.J+1), mp.R) + 0.5 * Hc[t] for t in 1:mp.T]

        # Tighten up tolerance once close, switch back to solving
        if ap.Hmax < ap.tol_out .* 2.0
            if ap.tol_in < 1e-7
                println("Decreasing tolerance.")
            end
            ap.tol_in = max(ap.tol_in ./ 10, 1e-7)
            howard_iter = ap.howard_its + 1
        end


        iter += 1


    end

    save("../data/counterfactual/counterfactual_economy.jld",
    "wages", wages_out,
    "real_wages", real_wages,
    "λ", λ_out,
    "xbilat", xbilat_out,
    "Ldyn", Ldyn,
    "μ", μ,
    "Hc", Hc
    )


end
