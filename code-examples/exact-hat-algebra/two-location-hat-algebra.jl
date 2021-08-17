#####################
## model parameters
#####################

p = (
    γ = 0.5,    # labor share
    θ = 8.,     # trade elasticity
    damp = 0.1, # function iteration damping
    tol = 1e-3  # convergence tolerance
    )


#####################
## initial data
#####################

λ = [.3 .7;
     .4 .6]         # trade shares
Y = [100., 100.]    # output
X = λ .* p.γ .* Y   # bilateral expenditures
π = [.8 .2;
     .3 .7]         # migration shares
L = [1.5, 1.5]        # labor distribution

#####################
## counterfactual set up
#####################

T_hat = [5., 1.]  # counterfactual change in productivity

#####################
## initialize model
#####################

w_guess = ones(2) # initial guess

data = (λ = λ, π = π, L = L, Y = Y, X = X) # set up data tuple

# make sure shares sum to 1
sum(data.λ, dims = 2)
sum(data.π, dims = 2)

#####################
## solver functions
#####################

# solve P as function of wages and data
function solve_P_hat(p, data, w_hat, T_hat)
    ( data.λ * ( T_hat .* w_hat.^(-p.γ*p.θ) ) ).^(-1/p.θ)
end

# solve λ as function of wages and P
function solve_λ_hat(p, w_hat, T_hat, P_hat)
    T_hat .* ( w_hat.^p.γ ./ P_hat ).^-p.θ
end

# solve for migration shares as function of real wages and data
function solve_π_hat(p, data, w_hat, P_hat)
    (w_hat ./ P_hat) ./ (data.π * ((w_hat ./ P_hat)))
end

# solve for labor as function of migration shares and data
function solve_L_hat(p, data, π_hat)
    (1 ./ data.L) .* (( π_hat .* data.π ) * data.L)
end

# solve for change in wages (and other variables)
function solve_w_hat(p, data, w_hat)

    L_hat = similar(w_hat)
    π_hat = similar(w_hat)
    λ_hat = similar(w_hat)
    P_hat = similar(w_hat)
    error = Inf
    iters = 1

    while error > p.tol && iters < 1e3

        P_hat = solve_P_hat(p, data, w_hat, T_hat)  # given wage guess, solve for P
        λ_hat = solve_λ_hat(p, w_hat, T_hat, P_hat) # given P, solve for trade shares
        π_hat = solve_π_hat(p, data, w_hat, P_hat)  # given real wages, solve for migration shares
        L_hat = solve_L_hat(p, data, π_hat)         # given migration shares, solve for labor

        # wage fixed point we are iterating on until convergence
        w_hat_new = (1/p.γ) * (1 ./ L_hat) .* (1 ./ data.Y) .* ( ( data.X .* λ_hat ) * ( w_hat .* L_hat ) )

        # error checking
        error = maximum(abs.((w_hat_new .- w_hat)./w_hat))
        w_hat = p.damp .* w_hat_new .+ (1 - p.damp) .* w_hat
        iters += 1

    end

    return w_hat, L_hat, π_hat, λ_hat, P_hat

end

#####################
## SOLVE MODEL
#####################

w_hat, L_hat, π_hat, λ_hat, P_hat = solve_w_hat(p, data, w_guess)
