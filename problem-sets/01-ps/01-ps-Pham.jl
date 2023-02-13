# Problem 1

using CompEcon # for integration routine
using Distributions 
using FastGaussQuadrature
using Expectations
using QuadGK
using LinearAlgebra, Statistics
using Optim

function profit_max_q(a, c, mu, sigma, method, n)
    # calculate the expectation of b 
    log_normal = LogNormal(mu, sigma)
    if method == "mc"
        # perform Monte Carlo integration
        # first draw n random b from the support of log normal
        b = rand(1:1000000, n)

        # integrate
        E_b = 1000000 * 1/n * sum(pdf.(log_normal, b) .* b) 

    elseif method == "quad"
        # perform quadrature integration
        f(x) = x*pdf(log_normal,x)
        E_b = quadgk(f, 0, 1000000, rtol=1e-6)
    else
        print("Please enter a correct integration method")
    end
    # define functions
    P(q) = a - E_b*q  
    C(q) = c*q
    Π(q) = -(P(q)*q - C(q))

    # find q 
    result = optimize(Π,0,1000)
    q = result.minimizer
    profit = -result.minimum

    # return the result
    print("Maximized profit is $profit and quantity is $q. Estimated value
    of b is $E_b")
    # return q
end

# Problem 2:
function distance_to_center(point)
    distance = sqrt((point[1] - 0.5)^2 + (point[2] - 0.5)^2)
    if distance <= 0.5
        return 1
    else
        return 0
    end    
end


function estimate_pi(n)
    square_points = [rand(2) for i in 1:n]
    
    # return the distances from the points to the center 
    distances = distance_to_center.(square_points)

    # area of the square
    area = 1 * 1/n * sum(distances)

    # return pi
    pi = area / (0.5^2)
    return pi
end

# estimate_pi(1000000)

# Problem 3

