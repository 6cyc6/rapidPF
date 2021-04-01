function pf_q = create_local_power_flow_equation_q(Vang, Vmag, Qg, Ybus,gen_bus_entries,copy_bus_entries,Qd)
    [~, M_q] = build_pf_matrix(Vang, Ybus);
    Q = Vmag .* (M_q * Vmag);
    % plus / minus
    pf_q = Q + Qd;
    pf_q(gen_bus_entries) = Q(gen_bus_entries) - Qg;
    pf_q(copy_bus_entries) = [];
end