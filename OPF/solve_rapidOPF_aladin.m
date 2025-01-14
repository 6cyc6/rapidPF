function [xsol, xsol_stacked, logg] = solve_rapidOPF_aladin(problem, mpc_split, option, names)
    % extract data from rapidPF problem
    A       = horzcat(problem.AA{:});
    b       = problem.b;
    x0      = problem.zz0;
    lam0    = problem.lam0;   
    Nregion = numel(x0);
    % initialize local NLP problem by extracting data from rapidPF problem
    nlps(Nregion,1)     = localNLP;
    for i = 1:Nregion
        Nx = numel(x0{i});
        % cost fun
        fi = problem.locFuns.ffi{i};% original local cost function
        gi = problem.sens.gg{i};% gradient of the local cost function
        hi = problem.sens.HH{i};% hessian  of the local cost function
        Ai = problem.AA{i};% consensus matrix for current region
        
        % residual
        if strcmp(option.nlp.solver,'lsqnonlin')
            ri  = problem.locFuns.rri{i};% residual function
            dri = problem.locFuns.dri{i};% gradient of residual function
        else
            ri  = [];
            dri = [];
        end
        
        % constraints
        if strcmp(option.problem_type,'feasibility')
            option.constrained = 'equality';
            con_eq    = problem.locFuns.ggi{i};            % equality constraints
            jac_eq    = problem.sens.JJac{i};            % jacobian matrix of equality constraints
%             hi        = [];
        else
            con_eq    = [];            % equality constraints
            jac_eq    = [];            % jacobian matrix of equality constraints
        end
        con_ineq    = [];            % equality constraints
        jac_ineq    = [];            % jacobian matrix of equality constraints
            % problem solve by lsqnonlin - objective calculated by residual
        local_funs = originalFuns(fi, gi, hi, Ai, ri, dri, con_eq, jac_eq, con_ineq, jac_ineq);
        nlps(i)    = localNLP(local_funs,option.nlp,problem.llbx{i},problem.uubx{i});
    end
    % main alg
    [xopt,logg] = run_aladin_algorithm(nlps,x0,lam0,A,b,option); 
    % reordering primal variable
    [xsol, xsol_stacked] = deal_solution(xopt, mpc_split, names); 
end