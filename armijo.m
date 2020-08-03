function mk = armijo( xk, rho, sigma, d, A0,phi_S,I,K,q,Ak,Proj,tau )

    assert( rho > 0 && rho < 1 );
    assert( sigma > 0 && sigma < 0.5 );

    mk = 0; max_mk = 100;

    while mk <= max_mk
        x = xk + tau * rho^mk * d;
%         obj_func( xk,A0,phi_S,I ) + sigma * tau * rho^mk *(Proj'*Proj)
%         obj_func( xk,A0,phi_S,I )
%         obj_func( x,A0,phi_S,I )
        if obj_func( x,A0,phi_S,I ) <=  obj_func( xk,A0,phi_S,I ) - sigma * tau * rho^mk *(Proj'*Proj)
            break;
        end
        mk = mk + 1;
    end

return;