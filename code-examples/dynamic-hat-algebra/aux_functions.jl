################################
################################
### auxiliary functions
################################
################################

# Function to quickly multiply vectors of matrices
function fastmultiply(out, L, R)
    for i = 1:length(L)
        @inbounds mul!(out[i], L[i], R[i])
    end
    out = hcat(out...)
    return out
end

# dictionary extraction
function extract(d)
    expr = quote end
    for (k, v) in d
        push!(expr.args, :($(Symbol(k)) = $v))
    end
    eval(expr)
    return
end
