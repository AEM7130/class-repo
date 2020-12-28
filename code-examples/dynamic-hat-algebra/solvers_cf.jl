# solve for sequence of temporary equilibria
function solve_static_subproblem(
    VARjn0, VALjn0, Zs, Ldyn, λ, μ, Haux, Sn_prime,
    κ_hat, α, io, θinv, θinv_stack, Ψ, G, G_vec, γ,
    mp, ap, ωs, phats
)
    ωs_out = similar(ωs)
    wages_out = [ones(mp.J, mp.N) for i = 1:mp.T]
    phat_out = [ones(mp.J, mp.N) for i = 1:mp.T]
    λ_out = [similar(λ) for i = 1:mp.T]
    xbilat_out = [similar(VARjn0) for i = 1:mp.T]
    Phat_out = [ones(mp.N) for i = 1:mp.T]
    real_wages_out = [ones(mp.J, mp.N) for i = 1:mp.T]
    labor_out = [ones(mp.J, mp.N) for i = 1:mp.T]

    # Solve static subproblem at time t
    for t = 1:(mp.T-2)

        println("Baseline economy: solving period $t of $(mp.T) with constant fundamentals.")

        Z_hat = Zs[t] # relative changes in technology/productivity [exogenous]

        ω = ωs[t] # initial factor price guess
        phat = phats[t] # initial price index guess

        labor = ones(mp.J, mp.N) # [exogenous] change in employment in other countries
        labor[:, 1:mp.R] = Ldyn[t+1][2:mp.J+1,:] ./ Ldyn[t][2:mp.J+1,:]

        ω_out, wages, Phat, rental_rate, phat, VARjn_prime, VALjn_prime, X_prime, λ_prime, xbilat_prime =
            solve_temp_equilibrium(
            ω, phat, labor, VARjn0, VALjn0, λ, Sn_prime,
            κ_hat, Z_hat, α, io, θinv, θinv_stack, Ψ, G, G_vec, γ,
            mp, ap
        )

        λ = λ_prime
        VARjn0 = VARjn_prime
        VALjn0 = VALjn_prime

        ωs_out[t] = ω_out # update initial wage guess
        wages_out[t+1] = wages
        phat_out[t+1] = phat
        λ_out[t+1] = λ_prime
        xbilat_out[t+1] = xbilat_prime
        Phat_out[t+1] = vec(Phat)
        real_wages_out[t+1] = wages ./  Phat
        labor_out[t+1] = labor

    end

    return ωs_out, wages_out, phat_out, Phat_out, real_wages_out, xbilat_out, λ_out, labor_out

end

# Solves for the temporary equilibrium given factor price guess (x in eq 5 on p 750 → xdot in eq 11 on p 754)
function solve_temp_equilibrium(
    ω, phat, labor, VARjn0, VALjn0, λ, Sn_prime,
    κ_hat, Z_hat, α, io, θinv, θinv_stack, Ψ, G, G_vec, γ,
    mp, ap
)

    ωmax = 1
    itw = 1

    λ_prime = similar(λ)
    X_prime = similar(VARjn0)

    while (itw <= ap.maxit) & (ωmax > ap.tol_in)

        # calculate good prices and input bundle consistent with factor prices [eq (11) and (12) on page 754]
        phat, xhat = solve_prices(phat, ω, κ_hat, Z_hat, θinv, θinv_stack, G, G_vec, γ, λ, mp, ap)

        # calculate bilateral trade shares [eq (13) on page 754]
        λ_prime = solve_λprime(λ, κ_hat, Z_hat, xhat, phat, θinv, θinv_stack, γ, mp)

        # calculate total expenditures [eq (14) on page 754]
        X_prime = solve_expenditures(α, Ψ, G, λ_prime, ω, labor, Sn_prime, VARjn0, VALjn0, io, mp)

        # calculate factot prices [eq (15) on page 754]
        ω_new = solve_factor_prices(X_prime, λ_prime, Ψ, γ, labor, VARjn0, VALjn0, mp)

        # new factor prices
        ω1 = ap.damp*ω_new .+ (1 - ap.damp)*ω

        ## CDP error criterion
        ωmax_usa = sum(abs.((ω1[:,1:mp.R] .- ω[:,1:mp.R])).^2)
        ωmax_row = sum(abs.((ω1[1,mp.R+1:mp.N] .- ω[1,mp.R+1:mp.N])).^2)
        ωmax = ωmax_usa + ωmax_row
        ω = ω1
        itw += 1

    end

    # recovering wages and rental rates from matrix of factor prices ω
    wages = similar(ω)
    rental_rate = similar(ω)
    wages[:,1:mp.R] = ω[:,1:mp.R].*(labor[:,1:mp.R].^(-Ψ[:,1:mp.R]))
    wages[:,mp.R+1:mp.N] = ω[:,mp.R+1:mp.N]  # outside the US, wage dot = rent dot frω footnote 63 on p.811, we assume no reallocation of labor outside the US
    rental_rate[:,1:mp.R] = wages[:,1:mp.R].*labor[:,1:mp.R]
    rental_rate[:,mp.R+1:mp.N] = ω[:,mp.R+1:mp.N]   # outside the US, wage dot = rent dot

    # recovering deficits
    VARjn_prime = (VARjn0.*ω .*(labor.^(1 .- Ψ)))
    VAR_prime = sum(VARjn_prime, dims = 1)'
    chi_prime = sum(VAR_prime)
    Bn_prime = Sn_prime .- io.*chi_prime + VAR_prime

    # recovering X
    X_prime = reshape(X_prime', 1, mp.J*mp.N)'
    xbilat_prime = repeat(X_prime, 1, mp.N).*λ_prime

    # recovering other variables
    VALjn_prime = wages .* labor .* VALjn0
    VAjn_prime = VALjn_prime .+ VARjn_prime
    VAjn_prime = VAjn_prime[:,1:mp.R]

    Phat = prod(phat.^(α), dims = 1)

    return ω, wages, Phat, rental_rate, phat, VARjn_prime, VALjn_prime, X_prime, λ_prime, xbilat_prime

end

function solve_factor_prices(X_prime, λ_prime, Ψ, γ, labor, VARjn0, VALjn0, mp)

    X = reshape(X_prime', 1, mp.J*mp.N)'

    DP = λ_prime.*X

    Exjnp = similar(γ)
    for j=1:mp.J
        for n=1:mp.N
            Exjnp[j,n] = sum(DP[1+mp.N*(j-1):mp.N*j,n]) # rightmost term in eqn (15)
        end
    end

    aux = γ.*Exjnp
    ω0 = ones(mp.J,mp.N)
    ω0[:,1:mp.R] = aux[:,1:mp.R]./((labor[:,1:mp.R].^(1 .- Ψ[:,1:mp.R])).*(VARjn0[:,1:mp.R] + VALjn0[:,1:mp.R]))
    VAR = sum(VARjn0, dims = 1)
    VAL = sum(VALjn0, dims = 1)
    aux = sum(aux, dims = 1)
    ω0[:,mp.R+1:mp.N] .= (aux[:,mp.R+1:mp.N]./(VAR[:,mp.R+1:mp.N] + VAL[:,mp.R+1:mp.N]))

    return ω0

end

function solve_expenditures(α, Ψ, G, λ_prime, ω, labor, Sn_prime, VARjn0, VALjn0, io, mp)

    # counterfactual equilibrium structures
    VARjn_prime = VARjn0 .* ω .* (labor.^(1 .- Ψ))
    VAR_prime = sum(VARjn_prime, dims = 1)'

    # total revenues in the global portfolio
    chi_prime = sum(VAR_prime)

    # new trade balance
    Bn_prime = Sn_prime .- io.*chi_prime + VAR_prime

    # Calculate the Ω matrix as in CP 2015.
    NBP = similar(λ_prime')

    for n_out in 1:mp.N
        for n_in in 1:mp.N
            @inbounds NBP[n_out, 1 + (n_in-1)*mp.J : n_in*mp.J] = λ_prime[n_in:mp.N:mp.J*mp.N, n_out]
        end
    end

    NNBP = kron(NBP, ones(mp.J, 1))
    GG = kron(ones(1,mp.N), G')
    GP = GG.*NNBP
    Ω = I - GP

    # calculate total expenditures
    aux = sum(ω.*(labor.^(1 .- Ψ)).*(VARjn0 + VALjn0), dims = 1)' .- Bn_prime
    aux = kron(aux, ones(mp.J,1))
    X = Ω \ (reshape(α, mp.N * mp.J, 1) .* aux)
    X_prime = reshape(X, mp.J, mp.N)

    return X_prime

end


function solve_λprime(λ, κ_hat, Z_hat, xhat, phat, θinv, θinv_stack, γ, mp)

    # Calculating bilateral trade shares using eqn (13)
    xhat_prime = xhat.^(-1 ./ θinv)
    phat_prime = phat.^(-1 ./ θinv)

    λ_k = λ .* (κ_hat.^(-1 ./ θinv_stack))
    λ_k[isnan.(λ_k)] .= 0

    Dλ = similar(κ_hat)
    λ_prime = similar(Dλ)
    for n in 1:mp.N
        index = n:mp.N:size(θinv_stack,1)-(mp.N-n)
        Dλ[index,:] = λ_k[index,:] .* (xhat_prime.*(Z_hat.^(γ./(repeat(θinv, 1, mp.N)))))
        λ_prime[index,:] = Dλ[index,:]./repeat(phat_prime[:,n], 1, mp.N);
    end

    return λ_prime

end

function solve_prices(phat_guess, ω, κ_hat, Z_hat, θinv, θinv_stack, G, G_vec, γ, λ, mp, ap)

    log_p_guess = [phat_guess[:,i] for i = 1:mp.N]
    xhat = similar(ω, Float64)
    phat = similar(ω, Float64)
    pfmax = 1.
    it = 1
    GP = [ones(mp.J) for i = 1:mp.N]

    # create vector of vectors
    log_ω = log.(ω)
    # preallocate outside loop
    log_xhat = similar(ω, Float64)
    # first term in log(xhat), can be precomputed
    log_xhat_1 = similar(ω, Float64)

    for n in 1:mp.N
        log_xhat_1[:,n] = γ[:,n].*log_ω[:,n]
    end

    while (it <= ap.maxit) & (pfmax > ap.tol_in)

        # G*log(p), use mul! to make faster
        GP_array = fastmultiply(GP, G_vec, log_p_guess)

        # calculate input bundle costs [log(xhat) frω eq (11) on p 754]
        log_xhat = log_xhat_1 .+ GP_array

        xhat = exp.(log_xhat)

        # calculate change in prices [eq (12) on p 754]
        λ_k = λ .* (κ_hat.^(-1 ./ θinv_stack))
        λ_k[isnan.(λ_k)] .= 0

        for j in 1:mp.J
            for n in 1:mp.N
                phat[j,n] = λ_k[n+(j-1)*mp.N,:]' *
                    (Z_hat[j,:].^(gamma[j,:]./(θinv[j])).*(xhat[j,:].^(-1/θinv[j])))
                phat[j,n] = phat[j,n]^(-θinv[j])
            end
        end

        pfmax = maximum(abs.(phat - phat_guess)./phat_guess)

        ## CDP error criterion
        pfmax = maximum(abs.(phat - phat_guess))

        phat_guess = deepcopy(phat)
        log_p_guess = [log.(phat_guess[:,n]) for n = 1:size(phat_guess,2)]
        it += 1

    end

    return phat_guess, xhat

end
