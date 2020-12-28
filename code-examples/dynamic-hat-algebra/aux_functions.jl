################################
################################
### auxiliary functions
################################
################################

# Function to construct datasets for the actual economy
function construct_datasets()

    # APPENDIX E HAS INFO ON HOW TO COMPUTE STUFF FOR US AND WHETHER THEY JUST USE THE SAME PARAMS AS THE COUNTRY LEVEL

    ### INITIAL VALUES AND PARAMETERS
    # VARjn00: structures value added (JxN) DONE GLOBAL
    # VALjn00: labor value added (JxN) DONE GLOBAL
    # λ00: initial expenditure shares (JNxN) DONE GLOBAL
    # xbilat00: initial bilateral expenditures (JNxN) DONE GLOBAL
    # Sn00: trade imbalances not explained by global portfolio (Nx1) ZEROS
    # α: final consumption shares (JxN)
    # io: share of each region in global portfolio (Nx1)
    # Ψ: share of structures in structure-labor aggregate (VA) (JxN) DONE GLOBAL
    # G: share of materials/intermediates in gross output (JNxN)
    # γ: share of value added in gross output (JxN) DONE GLOBAL
    # θinv: inverse of trade elasticity (Jx1) TAKE FROM OTHER LIT

end

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
